import { pool } from "./db";
import { ingestPage } from "./ingest";
import { isLocale } from "@/i18n/config";

// Strip fenced code blocks (```svg / ```carousel / ```html / code) so they don't
// pollute embeddings — mirrors scripts/ingest.mjs and the manual reindex route
// (src/app/api/admin/content/reindex/route.ts).
function stripFences(md: string): string {
  return md.replace(/```[\s\S]*?```/g, "").replace(/\n{3,}/g, "\n\n");
}

/** Remove all embeddings for one page/locale so the agent can't retrieve it. */
export async function purgePage(slug: string, locale: string): Promise<void> {
  await pool.query(`DELETE FROM content_chunks WHERE page_id=$1 AND locale=$2`, [slug, locale]);
}

/**
 * Re-embed a single page's content into content_chunks, reusing the same
 * chunk+embed+insert path as the manual "Rebuild now" admin action
 * (src/lib/ingest.ts). If the page no longer exists or is unpublished, its stale
 * embeddings are PURGED (so the assistant can never retrieve/cite removed or
 * hidden content) and it returns 0.
 */
export async function reindexPage(slug: string, locale: string): Promise<number> {
  if (!isLocale(locale)) return 0;
  const { rows } = await pool.query<{ body: string | null; published: boolean }>(
    `SELECT body, published FROM pages WHERE slug=$1 AND locale=$2 LIMIT 1`,
    [slug, locale]
  );
  const page = rows[0];
  if (!page || !page.published) {
    await purgePage(slug, locale); // gone or unpublished -> drop stale grounding
    return 0;
  }

  const body = stripFences(page.body ?? "");
  return ingestPage(slug, locale, body, `pages/${locale}/${slug}`);
}

/**
 * Fire-and-forget trigger for reindexPage: never throws. Embedding can fail
 * (no OpenRouter/Ollama configured, network error, etc.) — those failures are
 * logged and swallowed here so a page save/restore/translate never turns into
 * a failed HTTP response just because re-embedding didn't succeed.
 */
export function queueReindex(slug: string, locale: string): void {
  void reindexPage(slug, locale).catch((err) => {
    console.error(`[reindex] queueReindex failed for ${slug}/${locale}:`, err);
  });
}
