// Block CMS — server-only data access for page_blocks (docs/BLOCK-CMS-PLAN.md §C.3).
// Imports @/lib/db, so this module must NEVER be imported by a "use client"
// component. Read path only in Phase 0; write/snapshot paths arrive in Phase 3.
import { pool } from "@/lib/db";
import type { BlockType, PageBlock } from "@/lib/blocks/types";

/**
 * Ordered blocks for a page in one locale. Empty array if the page has no blocks
 * yet (e.g. before the Phase-1 backfill), so callers can fall back to the coded
 * route. Wrapped in try/catch to match the never-500 posture of getCdt()/
 * getConformityHome().
 */
export async function getPageBlocks(slug: string, locale: string): Promise<PageBlock[]> {
  try {
    const { rows } = await pool.query(
      `SELECT id, slug, locale, position, type, config
         FROM page_blocks
        WHERE slug = $1 AND locale = $2
        ORDER BY position`,
      [slug, locale]
    );
    return rows.map((r) => ({
      id: Number(r.id),
      slug: r.slug as string,
      locale: r.locale as string,
      position: Number(r.position),
      type: r.type as BlockType,
      config: r.config
    }));
  } catch (e) {
    console.warn(`[page-blocks] DB unavailable for ${slug}/${locale}:`, e);
    return [];
  }
}
