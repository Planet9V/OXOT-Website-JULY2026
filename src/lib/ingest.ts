import { pool } from "./db";
import { embed } from "./embeddings";
import type { Locale } from "@/i18n/config";

// Split text into retrieval-sized chunks on blank lines, capped by length.
export function chunk(text: string, max = 800): string[] {
  const paras = text.split(/\n\s*\n/).map((p) => p.trim()).filter(Boolean);
  const out: string[] = [];
  let cur = "";
  for (const p of paras) {
    if ((cur + "\n\n" + p).length > max && cur) {
      out.push(cur);
      cur = p;
    } else {
      cur = cur ? `${cur}\n\n${p}` : p;
    }
  }
  if (cur) out.push(cur);
  return out;
}

// --- site_blocks JSONB -> prose extraction --------------------------------
// The coded flagship landing pages (CRA home, Cyber Digital Twin, Conformity
// home, the legacy `home` block) store their content as structured JSONB in
// site_blocks rather than markdown in pages.body. To ground the assistant on
// them we recursively collect the human-readable string leaves and feed the
// result through the same chunk+embed path as CMS pages.

// Keys ending in these suffixes hold ids, links, or enum/status tags, never
// prose — skip the whole subtree under them.
const SKIP_KEY_SUFFIXES = ["id", "href", "url", "tone", "icon"];
// A few additional keys that are always enum-ish codes/identifiers, not prose.
const SKIP_KEY_EXACT = new Set(["code", "level", "cve", "kev"]);

function isSkippableKey(key: string): boolean {
  const k = key.toLowerCase();
  if (SKIP_KEY_EXACT.has(k)) return true;
  return SKIP_KEY_SUFFIXES.some((suffix) => k.endsWith(suffix));
}

// Numeric-ish / bare-token strings (percentages, counts, ranges) aren't prose
// even under a textual-looking key — skip those too, along with links.
function isProseValue(value: string): boolean {
  const v = value.trim();
  if (!v) return false;
  if (/^https?:\/\//i.test(v) || v.startsWith("/")) return false;
  if (/^[-+]?[\d.,%:/\s]+$/.test(v)) return false;
  return true;
}

/**
 * Recursively walk a parsed site_blocks JSONB value and collect human-readable
 * string leaves, in document order, skipping obvious non-prose fields (ids,
 * hrefs/urls, tone/status enums, numeric-ish values, icon names — see
 * isSkippableKey/isProseValue above).
 */
export function extractProse(value: unknown): string[] {
  if (typeof value === "string") {
    return isProseValue(value) ? [value.trim()] : [];
  }
  if (Array.isArray(value)) {
    return value.flatMap((v) => extractProse(v));
  }
  if (value && typeof value === "object") {
    const out: string[] = [];
    for (const [k, v] of Object.entries(value as Record<string, unknown>)) {
      if (isSkippableKey(k)) continue;
      out.push(...extractProse(v));
    }
    return out;
  }
  return [];
}

// Re-ingest a page for a locale: clear old chunks, embed + insert new ones.
export async function ingestPage(
  pageId: string,
  locale: Locale,
  text: string,
  sourceRef?: string
): Promise<number> {
  const parts = chunk(text);
  await pool.query(
    `DELETE FROM content_chunks WHERE page_id = $1 AND locale = $2`,
    [pageId, locale]
  );
  for (const part of parts) {
    const vector = await embed(part);
    await pool.query(
      `INSERT INTO content_chunks (page_id, locale, text, embedding, source_ref)
       VALUES ($1, $2, $3, $4::vector, $5)`,
      [pageId, locale, part, `[${vector.join(",")}]`, sourceRef ?? null]
    );
  }
  return parts.length;
}
