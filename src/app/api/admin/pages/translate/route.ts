import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { getAdminSession } from "@/lib/auth";
import { isLocale } from "@/i18n/config";
import { snapshotCurrent } from "@/lib/page-versions";
import { translatePage } from "@/lib/translate";
import { queueReindex } from "@/lib/reindex";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// AI EN<->NL page translation, zero-loss: if the target-locale counterpart
// already exists, its current content is snapshotted (via snapshotCurrent)
// BEFORE the translated content overwrites it, in the same transaction as
// the upsert — so a failure rolls back and nothing is lost.
export async function POST(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });

  const b = (await req.json().catch(() => ({}))) as { slug?: string; sourceLocale?: string };
  if (!b.slug || !b.sourceLocale || !isLocale(b.sourceLocale)) {
    return NextResponse.json({ error: "slug and valid sourceLocale required" }, { status: 400 });
  }
  const slug = b.slug;
  const sourceLocale = b.sourceLocale;
  const targetLocale = sourceLocale === "en" ? "nl" : "en";

  const { rows: sourceRows } = await pool.query(
    `SELECT title, body, meta_title AS "metaTitle", meta_description AS "metaDescription",
            excerpt, og_image AS "ogImage", content_type AS "contentType"
       FROM pages WHERE slug=$1 AND locale=$2 LIMIT 1`,
    [slug, sourceLocale]
  );
  const source = sourceRows[0];
  if (!source) return NextResponse.json({ error: "source page not found" }, { status: 404 });

  let translated;
  try {
    translated = await translatePage(
      {
        title: source.title ?? "",
        body: source.body ?? "",
        metaTitle: source.metaTitle ?? "",
        metaDescription: source.metaDescription ?? "",
        excerpt: source.excerpt ?? "",
      },
      sourceLocale,
      targetLocale
    );
  } catch (err) {
    console.error("[admin/pages/translate] translation failed:", err);
    return NextResponse.json(
      { error: err instanceof Error ? err.message : "Translation failed" },
      { status: 502 }
    );
  }

  const client = await pool.connect();
  try {
    await client.query("BEGIN");

    const { rows: existingRows } = await client.query(
      `SELECT published FROM pages WHERE slug=$1 AND locale=$2 LIMIT 1`,
      [slug, targetLocale]
    );
    const existing = existingRows[0];

    if (existing) {
      // Zero-loss: snapshot the counterpart's current content before the
      // translation overwrites it.
      await snapshotCurrent(
        slug, targetLocale,
        existing.published ? "published" : "draft",
        "Auto-snapshot before AI translation",
        client
      );
    }

    // CRITICAL: never change the counterpart's published flag here.
    // - If it already existed, keep its current published value untouched
    //   (translated content still needs review either way).
    // - If it did not exist, create it as a draft (published=false) so an
    //   untranslated-reviewed page is never auto-published.
    const publishedValue = existing ? existing.published : false;

    await client.query(
      `INSERT INTO pages
         (slug, locale, title, body, published,
          meta_title, meta_description, excerpt, og_image, content_type,
          published_at, updated_at)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,
          CASE WHEN $5 THEN now() ELSE NULL END, now())
       ON CONFLICT (slug, locale) DO UPDATE
         SET title=EXCLUDED.title, body=EXCLUDED.body,
             meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description,
             excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type,
             updated_at=now()`,
      [
        slug, targetLocale, translated.title, translated.body, publishedValue,
        translated.metaTitle || null, translated.metaDescription || null, translated.excerpt || null,
        source.ogImage ?? null, source.contentType ?? "page",
      ]
    );

    await client.query("COMMIT");
    // Keep the AI agent's grounding current: re-embed the translated
    // counterpart when published. Fire-and-forget — never blocks the response.
    if (publishedValue) queueReindex(slug, targetLocale);
    return NextResponse.json({ ok: true, targetLocale });
  } catch (err) {
    await client.query("ROLLBACK").catch(() => {});
    console.error("[admin/pages/translate] save failed:", err);
    return NextResponse.json({ error: "Could not save translated page" }, { status: 500 });
  } finally {
    client.release();
  }
}
