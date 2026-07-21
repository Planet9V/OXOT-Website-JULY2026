// Block CMS — server-only data access for page_blocks (docs/BLOCK-CMS-PLAN.md §C.3).
// Imports @/lib/db, so this module must NEVER be imported by a "use client"
// component. Read path only in Phase 0; write/snapshot paths arrive in Phase 3.
import { pool } from "@/lib/db";
import { snapshotCurrent } from "@/lib/page-versions";
import type { BlockType, PageBlock } from "@/lib/blocks/types";

/** A block as submitted by the admin builder (no id/slug/locale yet). */
export interface BlockInput {
  type: BlockType;
  config: unknown;
}

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

/**
 * Replace ALL blocks for a page+locale with the given ordered list, in ONE
 * transaction and snapshot-first (zero-loss): the current pages row + its
 * existing blocks are captured into page_versions before anything changes,
 * then the block set is rewritten. `position` is assigned from array order.
 * Returns the number of blocks written.
 */
export async function setPageBlocks(
  slug: string,
  locale: string,
  blocks: BlockInput[],
  note = "Block edit",
  snapshot = true
): Promise<number> {
  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    // Snapshot the pre-change state (pages row + current blocks) for history.
    // Skipped for live-preview writes (snapshot=false) to avoid version spam;
    // an explicit Save records a version.
    if (snapshot) {
      const { rows: pub } = await client.query(
        `SELECT published FROM pages WHERE slug=$1 AND locale=$2 LIMIT 1`,
        [slug, locale]
      );
      await snapshotCurrent(
        slug, locale,
        pub[0]?.published ? "published" : "draft",
        note, client
      );
    }

    await client.query(`DELETE FROM page_blocks WHERE slug=$1 AND locale=$2`, [slug, locale]);
    for (let i = 0; i < blocks.length; i++) {
      await client.query(
        `INSERT INTO page_blocks (slug, locale, position, type, config)
         VALUES ($1,$2,$3,$4,$5)`,
        [slug, locale, i, blocks[i].type, JSON.stringify(blocks[i].config ?? {})]
      );
    }
    await client.query("COMMIT");
    return blocks.length;
  } catch (err) {
    await client.query("ROLLBACK").catch(() => {});
    throw err;
  } finally {
    client.release();
  }
}
