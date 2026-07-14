import { pool } from "./db";
import { embed } from "./embeddings";
import type { Locale } from "@/i18n/config";

export interface RetrievedChunk {
  id: number;
  text: string;
  pageId: string;
  score: number; // raw cosine distance (0..2, lower = closer). Page boost affects ranking only.
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
  // Plain pgvector cosine, dimension-agnostic (works at 1536 or 2560). Page-boosted
  // ranking in SQL, returning the RAW cosine distance as `score`. When embeddings
  // are <=2000 dims a plain HNSW index (migration 035) accelerates the ORDER BY;
  // at higher dims it's an exact sequential scan (correct, fine for this corpus).
  // No halfvec dependency — the earlier halfvec cast was removed because halfvec
  // support on the live instance was unverifiable and a failed cast would have
  // silently stripped the agent's grounding.
  const { rows } = await pool.query(
    `SELECT id, text, page_id,
       (embedding <=> $1::vector) AS score
     FROM content_chunks
     WHERE locale = $2
     ORDER BY (embedding <=> $1::vector)
       - (CASE WHEN page_id = $3 THEN 0.05 ELSE 0 END) ASC
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
