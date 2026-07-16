import { pool } from "./db";
import type { Locale } from "@/i18n/config";
import enDefault from "../../data/cdt_en.json";
import nlDefault from "../../data/cdt_nl.json";

/**
 * Structured, admin-editable content for the flagship Cyber Digital Twin (CDT)
 * page (the static route at /[locale]/cyber-digital-twin, which shadows the
 * legacy markdown [slug] page of the same slug — the old pages row stays intact,
 * zero-loss). Stored in the site_blocks table as one JSONB row per locale
 * (key='cdt_home'); falls back to the shipped JSON defaults when a row hasn't
 * been created/edited yet. Mirrors src/lib/cra-home.ts exactly (same table,
 * same resilience pattern).
 *
 * NOTE (build-safety): client components must only `import type { ... }` from
 * this module — it value-imports the DB pool (server-only). All DB reads happen
 * in page.tsx via getCdt(); plain serializable data is passed to client comps.
 */

/* ---------- Hero ---------- */
export interface CdtHero {
  eyebrow: string;
  title: string;
  titleAccent: string;
  subtitle: string;
  badges: string[];
  ctaLabel: string;
}

/* ---------- Stat band ---------- */
export interface CdtStat {
  value: string;
  label: string;
  sub?: string;
}
export interface CdtStatBand {
  items: CdtStat[];
}

/* ---------- Living model (seven-layer graph) ---------- */
export type GraphLayerTone = "asset" | "risk" | "control" | "dependency";
export interface GraphLayer {
  id: string;
  name: string;
  caption: string;
  tone: GraphLayerTone;
}
export interface CdtLivingModel {
  eyebrow: string;
  title: string;
  body: string;
  points: string[];
  /** Exactly 7 layers, rendered as the interactive seven-layer graph. */
  layers: GraphLayer[];
  /** Caption shown in the graph's reveal panel before a layer is hovered/focused. */
  graphHint: string;
  /** aria-label for the graph's root <svg>. */
  graphAriaLabel: string;
}

/* ---------- BOMs (DEXPI-extended bills of materials) ---------- */
export type BomCode = "SBOM" | "HBOM" | "CBOM" | "SaaS-BOM" | "Ops-BOM";
export interface BomType {
  code: BomCode;
  name: string;
  desc: string;
  carries: string;
}
export interface CdtBoms {
  eyebrow: string;
  title: string;
  intro: string;
  standardNote: string;
  dependencyNote: string;
  boms: BomType[];
}

/* ---------- Drill-down BOM table ---------- */
export type BomRowLevel =
  | "component"
  | "equipment"
  | "productLine"
  | "facility"
  | "org";
export type BomPriority = "now" | "next" | "never";
export interface BomRow {
  id: string;
  parentId: string | null;
  level: BomRowLevel;
  label: string;
  version?: string;
  cve?: string;
  kev: boolean;
  epss: number;
  cvss: number;
  consequence?: string;
  priority: BomPriority;
}
export interface CdtDrilldownColumns {
  component: string;
  version: string;
  level: string;
  kev: string;
  epss: string;
  cvss: string;
  consequence: string;
}
export interface CdtDrilldownLegendItem {
  key: string;
  label: string;
}
export interface CdtDrilldownLevelNames {
  organization: string;
  facility: string;
  productLine: string;
  equipment: string;
  component: string;
}
export interface CdtDrilldownSortOptions {
  cvss: string;
  epss: string;
}
export interface CdtDrilldown {
  title: string;
  intro: string;
  columns: CdtDrilldownColumns;
  legend: CdtDrilldownLegendItem[];
  rows: BomRow[];
  /** Level names keyed by BomRowLevel, used for the filter dropdown + row sublabels. */
  levelNames: CdtDrilldownLevelNames;
  /** Label for the "deepest level to show" filter (visible text + aria-label). */
  deepestLabel: string;
  /** Label preceding the sort buttons, e.g. "Sort:". */
  sortLabel: string;
  sortOptions: CdtDrilldownSortOptions;
  /** Header for the priority column (NOW/NEXT/NEVER). */
  priorityHeader: string;
  /** aria-labels for the row expand/collapse toggle. */
  collapseLabel: string;
  expandLabel: string;
  /** Text on the priority pill, keyed by BomPriority. */
  priorityLabels: Record<BomPriority, string>;
}

/* ---------- Consequence-driven methods ---------- */
export type ConsequenceMethodCode = "FMECA" | "RCIL" | "SCIL";
export interface ConsequenceMethod {
  code: ConsequenceMethodCode;
  name: string;
  body: string;
}
export interface CdtConsequence {
  eyebrow: string;
  title: string;
  intro: string;
  note: string;
  methods: ConsequenceMethod[];
}

/* ---------- NOW / NEXT / NEVER prioritization ---------- */
export type PriorityConsequence = "critical" | "high" | "med" | "low";
export type PriorityExploit = "kev" | "high-epss" | "low-epss" | "no-path";
export interface PriorityItem {
  label: string;
  consequence: PriorityConsequence;
  exploit: PriorityExploit;
}
export interface PriorityBucket {
  key: BomPriority;
  label: string;
  rule: string;
  items: PriorityItem[];
}
export interface CdtPriorityConsequenceLevels {
  critical: string;
  high: string;
  med: string;
  low: string;
}
export interface CdtPriorityExploitLevels {
  kev: string;
  highEpss: string;
  lowEpss: string;
  noPath: string;
}
export interface CdtPriority {
  eyebrow: string;
  title: string;
  intro: string;
  rule: string;
  buckets: PriorityBucket[];
  /** Y-axis label, e.g. "Consequence →". */
  axisConsequence: string;
  /** X-axis label, e.g. "Exploitability pathway →". */
  axisExploit: string;
  consequenceLevels: CdtPriorityConsequenceLevels;
  exploitLevels: CdtPriorityExploitLevels;
  /** Idle-state hint under the reveal panel. */
  hint: string;
  /** Shown in the reveal panel when a selected cell has no items. */
  emptyCellNote: string;
}

/* ---------- Monte Carlo prediction pipeline ---------- */
export interface MonteCarloBin {
  x: number;
  p: number;
}
export interface MonteCarloCi {
  meanPct: number;
  lowerPct: number;
  upperPct: number;
  label: string;
}
export interface MonteCarloScenario {
  id: string;
  label: string;
  note: string;
  shiftPct: number;
}
export interface CdtMonteCarlo {
  eyebrow: string;
  title: string;
  intro: string;
  runsLabel: string;
  bins: MonteCarloBin[];
  ci: MonteCarloCi;
  scenarios: MonteCarloScenario[];
  /** X-axis caption under the histogram, e.g. "P(reach a safety-critical system)...". */
  xAxisLabel: string;
  /** Label on the dashed mean marker, e.g. "mean". */
  meanLabel: string;
  /** Confidence-interval abbreviation next to the mean readout, e.g. "CI" / "BI". */
  ciAbbrev: string;
}

/* ---------- Methodology (Assess → Model → Improve → Sustain) ---------- */
export interface MethodologyStep {
  number: string;
  title: string;
  body: string;
}
export interface CdtMethodology {
  eyebrow: string;
  title: string;
  intro: string;
  steps: MethodologyStep[];
}

/* ---------- Outcomes ---------- */
export interface OutcomeCard {
  title: string;
  body: string;
  href?: string;
}
export interface CdtOutcomes {
  eyebrow: string;
  title: string;
  intro: string;
  cards: OutcomeCard[];
}

/* ---------- Final CTA ---------- */
export interface CdtFinalCta {
  title: string;
  line: string;
  ctaLabel: string;
}

/* ---------- Whole page ---------- */
export interface CDT {
  hero: CdtHero;
  statBand: CdtStatBand;
  livingModel: CdtLivingModel;
  boms: CdtBoms;
  drilldown: CdtDrilldown;
  consequence: CdtConsequence;
  priority: CdtPriority;
  monteCarlo: CdtMonteCarlo;
  methodology: CdtMethodology;
  outcomes: CdtOutcomes;
  finalCta: CdtFinalCta;
}

export const CDT_HOME_KEY = "cdt_home";

// Defaults come straight from the shipped JSON, so the page renders identically
// before anyone touches the admin. Unknown locales fall back to English.
export function defaultCdt(locale: Locale): CDT {
  return (locale === "nl" ? nlDefault : enDefault) as CDT;
}

// Public read used by the live page. Wrapped in try/catch so the page never
// 500s if the DB is unavailable — it degrades to the shipped defaults.
export async function getCdt(locale: Locale): Promise<CDT> {
  try {
    const { rows } = await pool.query(
      `SELECT data FROM site_blocks WHERE key = $1 AND locale = $2 LIMIT 1`,
      [CDT_HOME_KEY, locale]
    );
    if (rows[0]?.data) return rows[0].data as CDT;
  } catch (e) {
    console.warn("[cdt] DB unavailable, using JSON defaults:", e);
  }
  return defaultCdt(locale);
}

// Admin read: the stored row if present, otherwise the defaults (so the editor
// always has something to load and edit).
export async function getCdtForEdit(locale: Locale): Promise<CDT> {
  return getCdt(locale);
}

export async function saveCdt(locale: Locale, data: CDT): Promise<void> {
  await pool.query(
    `INSERT INTO site_blocks (key, locale, data, updated_at)
     VALUES ($1, $2, $3, now())
     ON CONFLICT (key, locale) DO UPDATE SET data = EXCLUDED.data, updated_at = now()`,
    [CDT_HOME_KEY, locale, JSON.stringify(data)]
  );
}
