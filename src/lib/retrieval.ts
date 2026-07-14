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
  // Cast both sides to halfvec(2560) so the HNSW index (migration 034) is usable —
  // plain vector(2560) has no ANN index (2000-dim cap). We over-fetch a candidate
  // set by pure cosine distance (index-backed), then re-rank in JS to apply the
  // current-page boost. This keeps the boost without defeating the index, and the
  // halfvec distance is fine for ranking. If halfvec is unavailable the query
  // errors and the caller (/api/agent) degrades gracefully to no context.
  const candidates = Math.max(k * 4, 24);
  const { rows } = await pool.query(
    `SELECT id, text, page_id,
       (embedding::halfvec(2560) <=> $1::halfvec(2560)) AS score
     FROM content_chunks
     WHERE locale = $2
     ORDER BY embedding::halfvec(2560) <=> $1::halfvec(2560)
     LIMIT $3`,
    [literal, locale, candidates]
  );
  const mapped = rows.map((r) => ({
    id: Number(r.id),
    text: r.text as string,
    pageId: r.page_id as string,
    score: Number(r.score)
  }));
  // Current-page boost: subtract 0.05 from the effective distance for chunks on the
  // page the visitor is viewing, re-sort, and return the top k. `score` stays the
  // RAW distance so downstream confidence gating remains valid.
  return mapped
    .map((r) => ({ r, adj: r.score - (currentPageId && r.pageId === currentPageId ? 0.05 : 0) }))
    .sort((a, b) => a.adj - b.adj)
    .slice(0, k)
    .map((x) => x.r);
}
