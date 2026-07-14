import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { getAdminSession } from "@/lib/auth";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// Per-page SEO admin. Ported from the source (Celestial-Agent-Nexus:
// artifacts/api-server/src/routes/adminSeo.ts). Reconciled to this app's `pages`
// table: meta_title / meta_description / og_image already exist; og_title,
// og_description, canonical_url, meta_keywords, noindex added in migration 032.
// No parallel SEO table. getAdminSession-guarded.

// GET → list every page with its SEO fields (ordered locale, slug).
export async function GET() {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const { rows } = await pool.query(
    `SELECT id, slug, locale, title, published,
            meta_title       AS "metaTitle",
            meta_description AS "metaDescription",
            meta_keywords    AS "metaKeywords",
            canonical_url    AS "canonicalUrl",
            og_title         AS "ogTitle",
            og_description   AS "ogDescription",
            og_image         AS "ogImage",
            noindex
       FROM pages
      ORDER BY locale, slug`
  );
  return NextResponse.json({ pages: rows });
}

// PUT → update one page's SEO fields (page identified by id in the body).
export async function PUT(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const b = (await req.json().catch(() => ({}))) as {
    id?: number;
    metaTitle?: string | null; metaDescription?: string | null; metaKeywords?: string | null;
    canonicalUrl?: string | null; ogTitle?: string | null; ogDescription?: string | null;
    ogImage?: string | null; noindex?: boolean;
  };
  const id = Number(b.id);
  if (!Number.isInteger(id) || id <= 0)
    return NextResponse.json({ error: "Invalid page id" }, { status: 400 });

  const clean = (v: string | null | undefined): string | null => {
    if (v === undefined || v === null) return null;
    const t = v.trim();
    return t.length > 0 ? t : null;
  };

  const { rowCount } = await pool.query(
    `UPDATE pages
        SET meta_title=$2, meta_description=$3, meta_keywords=$4, canonical_url=$5,
            og_title=$6, og_description=$7, og_image=$8, noindex=$9, updated_at=now()
      WHERE id=$1`,
    [
      id,
      clean(b.metaTitle), clean(b.metaDescription), clean(b.metaKeywords), clean(b.canonicalUrl),
      clean(b.ogTitle), clean(b.ogDescription), clean(b.ogImage), b.noindex === true,
    ]
  );
  if (rowCount === 0) return NextResponse.json({ error: "Page not found" }, { status: 404 });
  return NextResponse.json({ ok: true });
}
