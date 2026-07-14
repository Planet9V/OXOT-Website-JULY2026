import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { getAdminSession } from "@/lib/auth";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// Admin CRUD for affiliate links + their keywords. Ported from the source
// (Celestial-Agent-Nexus: artifacts/api-server/src/routes/adminAffiliate.ts +
// lib/affiliate.ts). Adapted to Next.js App Router + raw pg. getAdminSession-guarded.
// Click totals are derived from link_clicks.affiliate_link_id (no counter column).

interface KeywordInput {
  keyword: string;
  locale?: string;
  active?: boolean;
}

// Affiliate targets are used verbatim in an HTTP redirect, so reject anything
// that is not an absolute http/https URL (e.g. javascript:, relative paths).
function isValidHttpUrl(value: string): boolean {
  try {
    const u = new URL(value.trim());
    return u.protocol === "http:" || u.protocol === "https:";
  } catch {
    return false;
  }
}

// De-dupe + normalize keyword rows (locale limited to en/nl, blanks dropped).
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

// Shape returned to the admin UI: link row + its keywords + derived click count.
export async function listAffiliateLinks() {
  const [links, keywords, counts] = await Promise.all([
    pool.query(
      `SELECT id, name, target_url AS "targetUrl", description, sponsored, active,
              created_at AS "createdAt", updated_at AS "updatedAt"
         FROM affiliate_links ORDER BY created_at DESC`
    ),
    pool.query(
      `SELECT id, affiliate_link_id AS "affiliateLinkId", keyword, locale, active
         FROM affiliate_keywords ORDER BY id`
    ),
    pool.query(
      `SELECT affiliate_link_id AS "linkId", count(*)::int AS c
         FROM link_clicks WHERE affiliate_link_id IS NOT NULL
        GROUP BY affiliate_link_id`
    ),
  ]);

  const countMap = new Map<number, number>(counts.rows.map((r) => [Number(r.linkId), Number(r.c)]));
  const kwByLink = new Map<number, { id: number; keyword: string; locale: string; active: boolean }[]>();
  for (const k of keywords.rows) {
    const list = kwByLink.get(Number(k.affiliateLinkId)) ?? [];
    list.push({ id: Number(k.id), keyword: k.keyword, locale: k.locale, active: k.active });
    kwByLink.set(Number(k.affiliateLinkId), list);
  }
  return links.rows.map((l) => ({
    id: Number(l.id),
    name: l.name,
    targetUrl: l.targetUrl,
    description: l.description,
    sponsored: l.sponsored,
    active: l.active,
    clickCount: countMap.get(Number(l.id)) ?? 0,
    keywords: kwByLink.get(Number(l.id)) ?? [],
    createdAt: l.createdAt,
    updatedAt: l.updatedAt,
  }));
}

export async function GET() {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  return NextResponse.json({ links: await listAffiliateLinks() });
}

export async function POST(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
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
    const { rows } = await client.query(
      `INSERT INTO affiliate_links (name, target_url, description, sponsored, active)
       VALUES ($1,$2,$3,$4,$5) RETURNING id`,
      [name, targetUrl, (typeof b.description === "string" && b.description.trim()) || null,
       b.sponsored !== false, b.active !== false]
    );
    const linkId = Number(rows[0].id);
    for (const k of keywords) {
      await client.query(
        `INSERT INTO affiliate_keywords (affiliate_link_id, keyword, locale, active)
         VALUES ($1,$2,$3,$4)`,
        [linkId, k.keyword, k.locale ?? "en", k.active !== false]
      );
    }
    await client.query("COMMIT");
    return NextResponse.json({ ok: true, id: linkId });
  } catch (err) {
    await client.query("ROLLBACK").catch(() => {});
    console.error("[admin/affiliate] create failed:", err);
    return NextResponse.json({ error: "Could not create link" }, { status: 500 });
  } finally {
    client.release();
  }
}
