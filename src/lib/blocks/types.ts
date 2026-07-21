// Block CMS — pure type/constant module (docs/BLOCK-CMS-PLAN.md §C.2).
// NO runtime imports (especially not @/lib/db): this module is safe to import
// from BOTH server render code and "use client" admin editor code. It is the
// single source of truth for block type keys and the ordered manifests that
// define how CDT and Conformity are composed.

/** Registry key for a block type, namespaced by originating page family. */
export type BlockType =
  // Cyber Digital Twin (src/components/cdt/sections.tsx) — 11 sections.
  | "cdt.hero"
  | "cdt.statBand"
  | "cdt.livingModel"
  | "cdt.boms"
  | "cdt.drilldown"
  | "cdt.consequence"
  | "cdt.priority"
  | "cdt.monteCarlo"
  | "cdt.methodology"
  | "cdt.outcomes"
  | "cdt.finalCta"
  // Conformity (src/components/conformity-home/sections.tsx + inline) — 12 sections.
  | "conformity.hero"
  | "conformity.consultingCarousel"
  | "conformity.regulationBand"
  | "conformity.stats"
  | "conformity.platform"
  | "conformity.problem"
  | "conformity.shift"
  | "conformity.comparison"
  | "conformity.howItWorks"
  | "conformity.testimonial"
  | "conformity.faq"
  | "conformity.finalCta"
  // Home / CRA-readiness landing (src/components/cra-home/sections.tsx) — 10 sections.
  | "cra.hero"
  | "cra.statBand"
  | "cra.departureBoard"
  | "cra.roadsSplit"
  | "cra.personas"
  | "cra.engine"
  | "cra.retainer"
  | "cra.whyOxot"
  | "cra.intake"
  | "cra.finalCta"
  // Generic, effect-rich blocks — for building any new dynamic page.
  | "prose"
  | "block.hero"
  | "block.stats"
  | "block.featureGrid"
  | "block.cta"
  | "block.media"
  | "block.divider";

/** A single stored block: ordered, typed, per-locale config. Mirrors page_blocks. */
export interface PageBlock {
  id: number;
  slug: string;
  locale: string;
  position: number;
  type: BlockType;
  config: unknown; // validated/narrowed per-type by the registry
}

/**
 * Ordered composition of the CDT page — EXACTLY the render order in
 * src/app/[locale]/cyber-digital-twin/page.tsx:59-75. The backfill (Phase 1)
 * emits page_blocks in this order; the renderer reads ORDER BY position.
 */
export const CDT_BLOCK_ORDER: BlockType[] = [
  "cdt.hero",
  "cdt.statBand",
  "cdt.livingModel",
  "cdt.boms",
  "cdt.drilldown",
  "cdt.consequence",
  "cdt.priority",
  "cdt.monteCarlo",
  "cdt.methodology",
  "cdt.outcomes",
  "cdt.finalCta"
];

/**
 * Ordered composition of the Conformity page — EXACTLY the render order in
 * src/app/[locale]/conformity/page.tsx:83-125 (including the two sections whose
 * wrapper markup is inline in the route: consultingCarousel and faq).
 */
export const CONFORMITY_BLOCK_ORDER: BlockType[] = [
  "conformity.hero",
  "conformity.consultingCarousel",
  "conformity.regulationBand",
  "conformity.stats",
  "conformity.platform",
  "conformity.problem",
  "conformity.shift",
  "conformity.comparison",
  "conformity.howItWorks",
  "conformity.testimonial",
  "conformity.faq",
  "conformity.finalCta"
];

/**
 * Maps a page slug to its canonical ordered block manifest. Used by the backfill
 * (which sub-object goes to which block, in what order) and by parity checks.
 */
/**
 * Ordered composition of the Home (CRA-readiness) page — EXACTLY the render order
 * in src/app/[locale]/page.tsx. `cra.intake` carries BOTH the intake and process
 * sub-objects (the IntakeSection component renders them together).
 */
export const CRA_BLOCK_ORDER: BlockType[] = [
  "cra.hero",
  "cra.statBand",
  "cra.departureBoard",
  "cra.roadsSplit",
  "cra.personas",
  "cra.engine",
  "cra.retainer",
  "cra.whyOxot",
  "cra.intake",
  "cra.finalCta"
];

export const PAGE_BLOCK_MANIFEST: Record<string, BlockType[]> = {
  "cyber-digital-twin": CDT_BLOCK_ORDER,
  conformity: CONFORMITY_BLOCK_ORDER,
  home: CRA_BLOCK_ORDER
};

/**
 * For a block type, the key of the CDT/ConformityHome sub-object it carries.
 * Drives lossless backfill (config = wholePageObject[field]) and reconstruction
 * (parity: wholePageObject[field] = block.config). `null` = the block has no
 * site_blocks sub-object (its content is data-bound elsewhere, e.g. the
 * dictionary-driven consulting carousel).
 */
export const BLOCK_SOURCE_FIELD: Partial<Record<BlockType, string | null>> = {
  "cdt.hero": "hero",
  "cdt.statBand": "statBand",
  "cdt.livingModel": "livingModel",
  "cdt.boms": "boms",
  "cdt.drilldown": "drilldown",
  "cdt.consequence": "consequence",
  "cdt.priority": "priority",
  "cdt.monteCarlo": "monteCarlo",
  "cdt.methodology": "methodology",
  "cdt.outcomes": "outcomes",
  "cdt.finalCta": "finalCta",
  "conformity.hero": "hero",
  "conformity.consultingCarousel": null, // dictionary-bound, no site_blocks field
  "conformity.regulationBand": "logoWall",
  "conformity.stats": "stats",
  "conformity.platform": "featureGrid",
  "conformity.problem": "problem",
  "conformity.shift": "shift",
  "conformity.comparison": "comparison",
  "conformity.howItWorks": "steps",
  "conformity.testimonial": "quote",
  "conformity.faq": "faq",
  "conformity.finalCta": "cta"
};
