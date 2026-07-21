// Block CMS — generic server renderer (docs/BLOCK-CMS-PLAN.md §C.3).
// Reads a page's ordered blocks and dispatches each to its registry adapter.
// SERVER component (imports the registry, which imports the section components).
import { Fragment } from "react";
import { getDictionary } from "@/i18n/dictionaries";
import type { Locale } from "@/i18n/config";
import { getPageBlocks } from "@/lib/blocks/page-blocks";
import { BLOCK_REGISTRY, type RenderCtx } from "@/lib/blocks/registry";
import type { BlockType } from "@/lib/blocks/types";

/**
 * Render every block for `slug`/`locale`, in `position` order. Builds one
 * RenderCtx per page: the locale, the dictionary (for dictionary-bound blocks),
 * and a `sibling(type)` accessor so a block can read another block's config on
 * the same page (the CDT hero needs the livingModel to draw its graph).
 *
 * Renders nothing if the page has no blocks — the caller (Phase 2 route) keeps
 * the coded fallback, so this is safe to mount before the backfill exists.
 */
export async function BlockRenderer({ slug, locale }: { slug: string; locale: Locale }) {
  const blocks = await getPageBlocks(slug, locale);
  if (blocks.length === 0) return null;

  const dict = getDictionary(locale);

  // First-wins map of type -> config, for cross-block references at render time.
  const byType = new Map<BlockType, unknown>();
  for (const b of blocks) {
    if (!byType.has(b.type)) byType.set(b.type, b.config);
  }

  const ctx: RenderCtx = {
    locale,
    dict,
    sibling: (type) => byType.get(type)
  };

  return (
    <>
      {blocks.map((b) => {
        const def = BLOCK_REGISTRY[b.type];
        if (!def) return null; // unknown type: skip rather than crash the page
        // Keyed Fragment — no DOM wrapper, so the markup matches the coded route
        // exactly (sections are direct siblings, as in the current <main>).
        return <Fragment key={b.id}>{def.Render(b.config, ctx)}</Fragment>;
      })}
    </>
  );
}
