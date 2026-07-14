import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { getAdminSession } from "@/lib/auth";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// Update / delete a single affiliate link (+ replace its keywords). Ported from
// the source adminAffiliate.ts (PUT/DELETE /admin/affiliate/links/:id).

interface KeywordInput {
  keyword: string;
  locale?: string;
  active?: boolean;
}

function isValidHttpUrl(value: string): boolean {
  try {
    const u = new URL(value.trim());
    return u.protocol === "http:" || u.protocol === "https:";
  } catch {
    return false;
  }
}

function normalizeKeywords(raw: unknown): KeywordInput[] {
  if (!Array.isArray(raw)) return [];
  const seen = new Set<string>();
  const out: KeywordInput[] = [];
  for (const k of raw) {
    if (!k || typeof k !== "object") continue;
    const keyword = typeof (k as KeywordInput).keyword === "string" ? (k as KeywordInput).keyword.trim() : "";
    if (!keyword) continue;
    const locale = (k as KeywordInput).locale === "nl" ? "nl" : "en";
    const dedupeKey = `${locale}:${keyword.toLowerCase()}`;
    if (seen.has(dedupeKey)) continue;
    seen.add(dedupeKey);
    out.push({ keyword, locale, active: (k as KeywordInput).active !== false });
  }
  return out;
}

function parseId(raw: string): number | null {
  const id = Number(raw);
  return Number.isInteger(id) && id > 0 ? id : null;
}

export async function PUT(req: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const id = parseId((await params).id);
  if (id === null) return NextResponse.json({ error: "Invalid link id" }, { status: 400 });

  const b = (await req.json().catch(() => ({}))) as {
    name?: string; targetUrl?: string; description?: string | null;
    sponsored?: boolean; active?: boolean; keywords?: unknown;
  };
  const name = typeof b.name === "string" ? b.name.trim() : "";
  const targetUrl = typeof b.targetUrl === "string" ? b.targetUrl.trim() : "";
  if (!name || !targetUrl)
    return NextResponse.json({ error: "Name and target URL are required" }, { status: 400 });
  if (!isValidHttpUrl(targetUrl))
    return NextResponse.json({ error: "Target URL must be an absolute http(s) URL" }, { status: 400 });

  const keywords = normalizeKeywords(b.keywords);
  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    const upd = await client.query(
      `UPDATE affiliate_links
          SET name=$2, target_url=$3, description=$4, sponsored=$5, active=$6, updated_at=now()
        WHERE id=$1`,
      [id, name, targetUrl, (typeof b.description === "string" && b.description.trim()) || null,
       b.sponsored !== false, b.active !== false]
    );
    if (upd.rowCount === 0) {
      await client.query("ROLLBACK");
      return NextResponse.json({ error: "Affiliate link not found" }, { status: 404 });
    }
    await client.query(`DELETE FROM affiliate_keywords WHERE affiliate_link_id=$1`, [id]);
    for (const k of keywords) {
      await client.query(
        `INSERT INTO affiliate_keywords (affiliate_link_id, keyword, locale, active)
         VALUES ($1,$2,$3,$4)`,
        [id, k.keyword, k.locale ?? "en", k.active !== false]
      );
    }
    await client.query("COMMIT");
    return NextResponse.json({ ok: true });
  } catch (err) {
    await client.query("ROLLBACK").catch(() => {});
    console.error("[admin/affiliate] update failed:", err);
    return NextResponse.json({ error: "Could not update link" }, { status: 500 });
  } finally {
    client.release();
  }
}

export async function DELETE(_req: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const id = parseId((await params).id);
  if (id === null) return NextResponse.json({ error: "Invalid link id" }, { status: 400 });
  // affiliate_keywords + link_clicks.affiliate_link_id both ON DELETE CASCADE.
  const res = await pool.query(`DELETE FROM affiliate_links WHERE id=$1`, [id]);
  if (res.rowCount === 0)
    return NextResponse.json({ error: "Affiliate link not found" }, { status: 404 });
  return NextResponse.json({ success: true });
}
