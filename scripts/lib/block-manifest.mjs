// Shared block manifest for the backfill + parity scripts (Phase 1).
// MIRRORS src/lib/blocks/types.ts (BLOCK_SOURCE_FIELD + *_BLOCK_ORDER). Kept as
// plain ESM so the .mjs scripts can import it without a TS toolchain. The
// self-check at the bottom guards against drift (counts must match the plan:
// CDT = 11 blocks, Conformity = 12, one of which is field-less).
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

const HERE = dirname(fileURLToPath(import.meta.url));
export const REPO = join(HERE, "..", "..");

/** Ordered [blockType, sourceField] per page. `null` field = data-bound block
 *  with no site_blocks sub-object (its content lives elsewhere, e.g. the
 *  dictionary-driven consulting carousel), so it contributes nothing to the
 *  reconstructed object and carries an empty config. */
export const PAGE_MANIFEST = {
  "cyber-digital-twin": {
    defaultJson: { en: "data/cdt_en.json", nl: "data/cdt_nl.json" },
    siteBlockKey: "cdt_home",
    blocks: [
      ["cdt.hero", "hero"],
      ["cdt.statBand", "statBand"],
      ["cdt.livingModel", "livingModel"],
      ["cdt.boms", "boms"],
      ["cdt.drilldown", "drilldown"],
      ["cdt.consequence", "consequence"],
      ["cdt.priority", "priority"],
      ["cdt.monteCarlo", "monteCarlo"],
      ["cdt.methodology", "methodology"],
      ["cdt.outcomes", "outcomes"],
      ["cdt.finalCta", "finalCta"]
    ]
  },
  conformity: {
    defaultJson: { en: "data/conformity_home_en.json", nl: "data/conformity_home_nl.json" },
    siteBlockKey: "conformity_home",
    blocks: [
      ["conformity.hero", "hero"],
      ["conformity.consultingCarousel", null],
      ["conformity.regulationBand", "logoWall"],
      ["conformity.stats", "stats"],
      ["conformity.platform", "featureGrid"],
      ["conformity.problem", "problem"],
      ["conformity.shift", "shift"],
      ["conformity.comparison", "comparison"],
      ["conformity.howItWorks", "steps"],
      ["conformity.testimonial", "quote"],
      ["conformity.faq", "faq"],
      ["conformity.finalCta", "cta"]
    ]
  },
  home: {
    defaultJson: { en: "data/cra_home_en.json", nl: "data/cra_home_nl.json" },
    siteBlockKey: "cra_home",
    blocks: [
      ["cra.hero", "hero"],
      ["cra.statBand", "statBand"],
      ["cra.departureBoard", "departureBoard"],
      ["cra.roadsSplit", "roadsSplit"],
      ["cra.personas", "personas"],
      ["cra.engine", "engine"],
      ["cra.retainer", "retainer"],
      ["cra.whyOxot", "whyOxot"],
      // Composite: this block carries BOTH the intake and process sub-objects.
      ["cra.intake", ["intake", "process"]],
      ["cra.finalCta", "finalCta"]
    ]
  }
};

// Drift guard — fail loudly if the manifest ever diverges from the plan.
{
  const cdt = PAGE_MANIFEST["cyber-digital-twin"].blocks.length;
  const conf = PAGE_MANIFEST.conformity.blocks.length;
  const home = PAGE_MANIFEST.home.blocks.length;
  const confFieldless = PAGE_MANIFEST.conformity.blocks.filter(([, f]) => f === null).length;
  if (cdt !== 11) throw new Error(`manifest drift: CDT expected 11 blocks, got ${cdt}`);
  if (conf !== 12) throw new Error(`manifest drift: Conformity expected 12 blocks, got ${conf}`);
  if (home !== 10) throw new Error(`manifest drift: Home expected 10 blocks, got ${home}`);
  if (confFieldless !== 1) throw new Error(`manifest drift: expected 1 field-less block, got ${confFieldless}`);
}

/** Load a page's source content object for a locale: the site_blocks row if a
 *  `db` client is given AND a row exists, otherwise the shipped JSON default —
 *  exactly mirroring getCdt()/getConformityHome(). */
export async function loadSource(slug, locale, db = null) {
  const m = PAGE_MANIFEST[slug];
  if (!m) throw new Error(`unknown page slug: ${slug}`);
  if (db) {
    const { rows } = await db.query(
      `SELECT data FROM site_blocks WHERE key = $1 AND locale = $2 LIMIT 1`,
      [m.siteBlockKey, locale]
    );
    if (rows[0]?.data) return { source: "site_blocks", data: rows[0].data };
  }
  const file = join(REPO, m.defaultJson[locale]);
  return { source: "json-default", data: JSON.parse(readFileSync(file, "utf8")) };
}

/** Decompose a page's source object into ordered block rows (in-memory).
 *  field: string => config = obj[field]; array => config = { f: obj[f], … }
 *  (composite block, e.g. Home intake carries intake+process); null => {}. */
export function decompose(slug, obj) {
  return PAGE_MANIFEST[slug].blocks.map(([type, field], position) => {
    let config;
    if (field === null) config = {};
    else if (Array.isArray(field)) config = Object.fromEntries(field.map((f) => [f, obj[f]]));
    else config = obj[field];
    return { position, type, config };
  });
}

/** Reconstruct the page's source object from its block rows (skips field-less
 *  blocks; composite/array blocks assign each of their fields back). */
export function reconstruct(slug, blocks) {
  const fieldByType = new Map(PAGE_MANIFEST[slug].blocks);
  const obj = {};
  for (const b of blocks) {
    const field = fieldByType.get(b.type);
    if (field == null) continue;
    if (Array.isArray(field)) for (const f of field) obj[f] = b.config?.[f];
    else obj[field] = b.config;
  }
  return obj;
}
