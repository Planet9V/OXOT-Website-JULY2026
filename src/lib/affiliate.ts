import { pool } from "@/lib/db";

// Shape returned to the admin UI: affiliate link row + its keywords + derived
// click count (from link_clicks.affiliate_link_id). Lives in a lib module — NOT
// in the route file — because Next.js App Router forbids non-handler exports from
// a `route.ts` (they break the generated route types / `next build`).
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
