import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { getAdminSession } from "@/lib/auth";
import { isLocale } from "@/i18n/config";

export async function GET() {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const { rows } = await pool.query(
    `SELECT slug, locale, title, published, updated_at FROM pages ORDER BY slug, locale`
  );
  return NextResponse.json({ pages: rows });
}

// Upsert a page for one locale.
export async function POST(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const b = (await req.json().catch(() => ({}))) as {
    slug?: string; locale?: string; title?: string; body?: string; published?: boolean;
  };
  if (!b.slug || !b.locale || !isLocale(b.locale) || !b.title) {
    return NextResponse.json({ error: "slug, valid locale, title required" }, { status: 400 });
  }
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
  await pool.query(
    `INSERT INTO pages (slug, locale, title, body, published, updated_at)
     VALUES ($1,$2,$3,$4,$5, now())
     ON CONFLICT (slug, locale) DO UPDATE
       SET title=EXCLUDED.title, body=EXCLUDED.body,
           published=EXCLUDED.published, updated_at=now()`,
    [b.slug, b.locale, b.title, b.body ?? "", b.published === true]
  );
  return NextResponse.json({ ok: true });
}

export async function DELETE(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const { searchParams } = new URL(req.url);
  const slug = searchParams.get("slug"), locale = searchParams.get("locale");
  if (!slug || !locale) return NextResponse.json({ error: "slug & locale required" }, { status: 400 });
  await pool.query(`DELETE FROM pages WHERE slug=$1 AND locale=$2`, [slug, locale]);
  return NextResponse.json({ ok: true });
}
