import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { getAdminSession } from "@/lib/auth";
import { isLocale } from "@/i18n/config";
import { snapshotCurrent } from "@/lib/page-versions";
import { queueReindex } from "@/lib/reindex";

export async function GET(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });

  const { searchParams } = new URL(req.url);
  const slug = searchParams.get("slug");
  const locale = searchParams.get("locale");

  // Single full page (load-for-edit) when slug+locale are given.
  if (slug && locale) {
    const { rows } = await pool.query(
      `SELECT slug, locale, title, body, published,
              meta_title AS "metaTitle", meta_description AS "metaDescription",
              excerpt, og_image AS "ogImage", content_type AS "contentType"
         FROM pages WHERE slug=$1 AND locale=$2 LIMIT 1`,
      [slug, locale]
    );
    if (!rows.length) return NextResponse.json({ error: "not found" }, { status: 404 });
    return NextResponse.json({ page: rows[0] });
  }

  const { rows } = await pool.query(
    `SELECT slug, locale, title, content_type AS "contentType", published, updated_at
       FROM pages ORDER BY slug, locale`
  );
  return NextResponse.json({ pages: rows });
}

// Upsert a page for one locale, including SEO/meta fields.
export async function POST(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const b = (await req.json().catch(() => ({}))) as {
    slug?: string; locale?: string; title?: string; body?: string; published?: boolean;
    metaTitle?: string; metaDescription?: string; excerpt?: string;
    ogImage?: string; contentType?: string;
  };
  if (!b.slug || !b.locale || !isLocale(b.locale) || !b.title) {
    return NextResponse.json({ error: "slug, valid locale, title required" }, { status: 400 });
  }
  const contentType = b.contentType === "article" ? "article" : "page";

  // Bilingual guard: cannot publish unless the sibling locale exists.
  if (b.published) {
    const other = b.locale === "nl" ? "en" : "nl";
    const sib = await pool.query(`SELECT 1 FROM pages WHERE slug=$1 AND locale=$2`, [b.slug, other]);
    if (!sib.rows.length) {
      return NextResponse.json(
        { error: `cannot publish: missing ${other} version of "${b.slug}"` },
        { status: 409 }
      );
    }
  }
  // Zero-loss: snapshot whatever currently lives in `pages` (if anything)
  // before the upsert overwrites it, all in one transaction.
  const client = await pool.connect();
  try {
    await client.query("BEGIN");

    const { rows: existingRows } = await client.query(
      `SELECT published FROM pages WHERE slug=$1 AND locale=$2 LIMIT 1`,
      [b.slug, b.locale]
    );
    if (existingRows.length) {
      await snapshotCurrent(
        b.slug, b.locale,
        existingRows[0].published ? "published" : "draft",
        "Auto-snapshot before edit",
        client
      );
    }

    await client.query(
      `INSERT INTO pages
         (slug, locale, title, body, published,
          meta_title, meta_description, excerpt, og_image, content_type,
          published_at, updated_at)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,
          CASE WHEN $5 THEN now() ELSE NULL END, now())
       ON CONFLICT (slug, locale) DO UPDATE
         SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published,
             meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description,
             excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type,
             published_at=COALESCE(pages.published_at, EXCLUDED.published_at),
             updated_at=now()`,
      [
        b.slug, b.locale, b.title, b.body ?? "", b.published === true,
        b.metaTitle ?? null, b.metaDescription ?? null, b.excerpt ?? null,
        b.ogImage ?? null, contentType
      ]
    );

    await client.query("COMMIT");
    // Keep the AI agent's grounding current. Fire-and-forget — never blocks or
    // fails the save. Called unconditionally: reindexPage re-embeds a published
    // page and PURGES a now-unpublished one, so unpublishing drops its grounding.
    queueReindex(b.slug, b.locale);
    return NextResponse.json({ ok: true });
  } catch (err) {
    await client.query("ROLLBACK").catch(() => {});
    console.error("[admin/pages] save failed:", err);
    return NextResponse.json({ error: "Could not save page" }, { status: 500 });
  } finally {
    client.release();
  }
}

export async function DELETE(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const { searchParams } = new URL(req.url);
  const slug = searchParams.get("slug"), locale = searchParams.get("locale");
  if (!slug || !locale) return NextResponse.json({ error: "slug & locale required" }, { status: 400 });
  const other = locale === "nl" ? "en" : "nl";

  const client = await pool.connect();
  try {
    await client.query("BEGIN");

    const { rows: existingRows } = await client.query(
      `SELECT published FROM pages WHERE slug=$1 AND locale=$2 LIMIT 1`,
      [slug, locale]
    );
    if (existingRows.length) {
      // Zero-loss: snapshot the live content before it's deleted so it stays
      // recoverable in page_versions.
      await snapshotCurrent(
        slug, locale,
        existingRows[0].published ? "published" : "draft",
        "Snapshot before delete",
        client
      );
    }

    // Bilingual integrity: never leave a lone published sibling. If the other locale
    // is published, unpublish it as part of the delete (mirrors the publish guard).
    await client.query(`UPDATE pages SET published=false, updated_at=now() WHERE slug=$1 AND locale=$2 AND published=true`, [slug, other]);
    await client.query(`DELETE FROM pages WHERE slug=$1 AND locale=$2`, [slug, locale]);

    await client.query("COMMIT");
    // Purge stale embeddings for the deleted page AND the just-unpublished sibling
    // so the agent can never retrieve/cite removed or hidden content.
    queueReindex(slug, locale);
    queueReindex(slug, other);
    return NextResponse.json({ ok: true });
  } catch (err) {
    await client.query("ROLLBACK").catch(() => {});
    console.error("[admin/pages] delete failed:", err);
    return NextResponse.json({ error: "Could not delete page" }, { status: 500 });
  } finally {
    client.release();
  }
}
