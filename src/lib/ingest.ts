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
