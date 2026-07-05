import { pool } from "./db";
import { embed } from "./embeddings";
import type { Locale } from "@/i18n/config";

export interface RetrievedChunk {
  id: number;
  text: string;
  pageId: string;
  score: number; // cosine distance (lower = closer), after page boost
}

// pgvector similarity, filtered by active locale, boosted toward current page.
export async function retrieve(
  query: string,
  locale: Locale,
  currentPageId?: string,
  k = 6
): Promise<RetrievedChunk[]> {
  const vector = await embed(query);
  const literal = `[${vector.join(",")}]`;
  const { rows } = await pool.query(
    `SELECT id, text, page_id,
       (embedding <=> $1::vector)
         - (CASE WHEN page_id = $3 THEN 0.05 ELSE 0 END) AS score
     FROM content_chunks
     WHERE locale = $2
     ORDER BY score ASC
     LIMIT $4`,
    [literal, locale, currentPageId ?? null, k]
  );
  return rows.map((r) => ({
    id: Number(r.id),
    text: r.text as string,
    pageId: r.page_id as string,
    score: Number(r.score)
  }));
}
