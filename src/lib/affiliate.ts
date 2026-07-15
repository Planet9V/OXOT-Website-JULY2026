import { pool } from "@/lib/db";
import { snapshotCurrent } from "@/lib/page-versions";
import { queueReindex } from "@/lib/reindex";

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

// --- AI Link Insertion ----------------------------------------------------
//
// Ported from the source's suggestAffiliateLinks/applyAffiliateLinks
// (Celestial-Agent-Nexus: artifacts/api-server/src/lib/affiliate.ts), adapted
// to this app's single-body page model: instead of scanning per-section JSON
// (two_column/faq), we scan one page's `pages.body` markdown string directly.
// Keyword matching stays deterministic (literal, case-insensitive, word-
// boundary) so applyAffiliateLinks can always re-find exactly what was shown.

export class AffiliatePageNotFoundError extends Error {}

export interface AffiliateSuggestion {
  affiliateLinkId: number;
  linkName: string;
  keyword: string;
  snippet: string;
  /** Which occurrence (0-based, in document order) of `keyword` this is, among
   *  occurrences not already inside a link — lets applyAffiliateLinks re-find
   *  the exact same spot deterministically. */
  occurrenceIndex: number;
}

export interface AffiliateSelection {
  affiliateLinkId: number;
  keyword: string;
  occurrenceIndex: number;
}

// Matches existing markdown links `[text](url)` and HTML anchor tags, so
// suggest/apply never touch text that is already a link.
const LINK_SPAN_RE = /\[[^\]\n]*\]\([^)\n]*\)|<a\b[^>]*>[\s\S]*?<\/a>/gi;

function findLinkSpans(body: string): Array<[number, number]> {
  const spans: Array<[number, number]> = [];
  for (const m of body.matchAll(LINK_SPAN_RE)) {
    spans.push([m.index, m.index + m[0].length]);
  }
  return spans;
}

function overlapsAnySpan(index: number, length: number, spans: Array<[number, number]>): boolean {
  return spans.some(([s, e]) => index < e && index + length > s);
}

function keywordRegex(keyword: string): RegExp {
  const esc = keyword.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  return new RegExp(`\\b${esc}\\b`, "gi");
}

function snippetAround(text: string, index: number, length: number): string {
  const start = Math.max(0, index - 50);
  const end = Math.min(text.length, index + length + 50);
  const prefix = start > 0 ? "…" : "";
  const suffix = end < text.length ? "…" : "";
  return `${prefix}${text.slice(start, end).trim()}${suffix}`;
}

/** All non-linked occurrences of `keyword` in `body`, in document order. */
function findOccurrences(
  body: string,
  keyword: string,
  spans: Array<[number, number]>
): Array<{ index: number; length: number; text: string }> {
  const out: Array<{ index: number; length: number; text: string }> = [];
  for (const m of body.matchAll(keywordRegex(keyword))) {
    if (overlapsAnySpan(m.index, m[0].length, spans)) continue;
    out.push({ index: m.index, length: m[0].length, text: m[0] });
  }
  return out;
}

/**
 * Deterministic keyword-match suggestions for one page's body: for every
 * ACTIVE affiliate keyword whose locale matches the page, find literal
 * (case-insensitive, word-boundary) occurrences that are not already inside
 * a link. Read-only — never touches the page.
 */
export async function suggestAffiliateLinks(
  slug: string,
  locale: string
): Promise<AffiliateSuggestion[]> {
  const { rows: pageRows } = await pool.query(
    `SELECT body FROM pages WHERE slug=$1 AND locale=$2 LIMIT 1`,
    [slug, locale]
  );
  const page = pageRows[0];
  if (!page) throw new AffiliatePageNotFoundError("Page not found");
  const body: string = page.body ?? "";
  if (!body) return [];

  const { rows: kwRows } = await pool.query(
    `SELECT k.affiliate_link_id AS "affiliateLinkId", k.keyword, l.name AS "linkName"
       FROM affiliate_keywords k
       JOIN affiliate_links l ON l.id = k.affiliate_link_id
      WHERE k.active = true AND l.active = true AND k.locale = $1
      ORDER BY k.id`,
    [locale]
  );
  if (kwRows.length === 0) return [];

  const spans = findLinkSpans(body);
  const suggestions: AffiliateSuggestion[] = [];
  for (const kw of kwRows) {
    const occurrences = findOccurrences(body, kw.keyword, spans);
    occurrences.forEach((occ, occurrenceIndex) => {
      suggestions.push({
        affiliateLinkId: Number(kw.affiliateLinkId),
        linkName: kw.linkName,
        keyword: occ.text,
        snippet: snippetAround(body, occ.index, occ.length),
        occurrenceIndex,
      });
    });
  }
  return suggestions;
}

/**
 * Applies admin-approved keyword -> tracked-link insertions to a page's body.
 * Zero-loss: snapshots the page's CURRENT body into page_versions BEFORE the
 * UPDATE, in the same transaction, so the pre-insertion content is always
 * recoverable. Idempotent: re-derives occurrences from the current body and
 * skips anything stale or already linked, and never links the same text spot
 * twice even if two selections resolve to it (e.g. two links sharing a
 * keyword). Returns the number of links actually inserted.
 */
export async function applyAffiliateLinks(
  slug: string,
  locale: string,
  selections: AffiliateSelection[]
): Promise<number> {
  if (selections.length === 0) return 0;

  const client = await pool.connect();
  try {
    await client.query("BEGIN");

    const { rows: pageRows } = await client.query(
      `SELECT body, published FROM pages WHERE slug=$1 AND locale=$2 LIMIT 1`,
      [slug, locale]
    );
    const page = pageRows[0];
    if (!page) {
      await client.query("ROLLBACK");
      throw new AffiliatePageNotFoundError("Page not found");
    }

    // Zero-loss: snapshot the page's current content BEFORE any insertion, so
    // the pre-insertion body is always recoverable in page_versions.
    await snapshotCurrent(
      slug,
      locale,
      page.published ? "published" : "draft",
      "Auto-snapshot before AI link insertion",
      client
    );

    let body: string = page.body ?? "";
    const spans = findLinkSpans(body);

    // Resolve each selection to a concrete text range against the CURRENT
    // body, re-scanning per keyword (same deterministic logic as suggest) so
    // occurrenceIndex lines up with what was shown to the admin.
    const occurrencesByKeyword = new Map<string, Array<{ index: number; length: number; text: string }>>();
    const targets: Array<{ index: number; length: number; text: string; affiliateLinkId: number }> = [];
    for (const sel of selections) {
      const key = sel.keyword.toLowerCase();
      let occurrences = occurrencesByKeyword.get(key);
      if (!occurrences) {
        occurrences = findOccurrences(body, sel.keyword, spans);
        occurrencesByKeyword.set(key, occurrences);
      }
      const occ = occurrences[sel.occurrenceIndex];
      if (!occ) continue; // stale suggestion (body changed since suggest) — skip, don't guess
      targets.push({ ...occ, affiliateLinkId: sel.affiliateLinkId });
    }

    // Never double-link the same text span, even if two selections resolved
    // to it (e.g. two affiliate links sharing a keyword) — keep the first.
    const uniqueTargets: typeof targets = [];
    for (const t of targets) {
      const overlaps = uniqueTargets.some(
        (u) => t.index < u.index + u.length && t.index + t.length > u.index
      );
      if (!overlaps) uniqueTargets.push(t);
    }

    // Apply right-to-left so earlier byte offsets stay valid across edits.
    uniqueTargets.sort((a, b) => b.index - a.index);
    for (const t of uniqueTargets) {
      const href = `/api/go/${t.affiliateLinkId}`;
      body = `${body.slice(0, t.index)}[${t.text}](${href})${body.slice(t.index + t.length)}`;
    }

    await client.query(`UPDATE pages SET body=$1, updated_at=now() WHERE slug=$2 AND locale=$3`, [
      body,
      slug,
      locale,
    ]);

    await client.query("COMMIT");
    // Content changed — keep the AI agent's grounding current (fire-and-forget).
    queueReindex(slug, locale);
    return uniqueTargets.length;
  } catch (err) {
    await client.query("ROLLBACK").catch(() => {});
    throw err;
  } finally {
    client.release();
  }
}
