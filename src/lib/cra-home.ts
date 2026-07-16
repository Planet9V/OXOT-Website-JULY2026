import { pool } from "./db";
import type { Locale } from "@/i18n/config";
import enDefault from "../../data/cra_home_en.json";
import nlDefault from "../../data/cra_home_nl.json";

/**
 * Structured, admin-editable content for the CRA-readiness home page (the new
 * front door at /[locale] — see PHASE C of the CRA intake epic). Stored in the
 * site_blocks table as one JSONB row per locale (key='cra_home'); falls back to
 * the shipped JSON defaults when a row hasn't been created/edited yet. Mirrors
 * src/lib/conformity-home.ts (same table, same resilience pattern) — the old
 * conformity-home content/route/editor are untouched and still live at
 * /[locale]/conformity.
 */

export type MilestoneTone = "start" | "info" | "warning" | "end";

export interface DepartureMilestone {
  /** Position along the Jul '26 -> Dec '27 axis, 0-100. */
  pct: number;
  dateLabel: string;
  note: string;
  tone: MilestoneTone;
}

export type RoadSegmentTone = "safe" | "tight" | "late" | "closed";

export interface RoadSegment {
  startPct: number;
  widthPct: number;
  tone: RoadSegmentTone;
  caption: string;
}

export interface DepartureRoad {
  id: string;
  label: string;
  sub: string;
  segments: RoadSegment[];
}

export interface DepartureBoardLegendItem {
  tone: RoadSegmentTone;
  label: string;
}

export interface CraHomeDepartureBoard {
  title: string;
  intro: string;
  axisLabels: string[];
  milestones: DepartureMilestone[];
  roads: DepartureRoad[];
  legend: DepartureBoardLegendItem[];
}

/** Status tone for a road's headline callout on the pathway map:
 *  closed (red) · reserved (primary/orange) · scales (emerald). */
export type RoadStatusTone = "closed" | "reserved" | "scales";

export interface RoadsSplitRoad {
  id: string;
  /** Road-sign lane label, e.g. "ROAD A · MODULE A". */
  laneLabel: string;
  title: string;
  body: string;
  ceMarkNote: string;
  /** Eligibility tag shown on the sign, e.g. "Default products · Class I with a harmonised standard · 17–32 wks". */
  segment: string;
  /** The ⚠/⛟/⟳ status callout, e.g. "CLOSED FOR CLASS I — until standards are cited (~Q2 2027)". */
  status: string;
  statusTone: RoadStatusTone;
  /** Per-road OXOT service alignment line (sign detail / expandable). */
  oxotDoes: string;
}

export interface RoadStatItem {
  label: string;
  value: string;
}

export interface CraHomeRoadsSplit {
  title: string;
  intro: string;
  startBadge: string;
  roads: RoadsSplitRoad[];
  destinationLabel: string;
  wrongTurnsTitle: string;
  wrongTurns: string;
  footnote: string;
  /** 6-item stat bar shown beneath the pathway map. */
  statBar: RoadStatItem[];
}

export interface PersonaCard {
  /** One of SEGMENTS in src/lib/intake.ts: manufacturer | oem | integrator | reseller | operator. */
  segment: string;
  title: string;
  quote: string;
  /** "One regulation. Five buyers." — what this segment BUYS. */
  buys: string;
  cta: string;
}

export interface CraHomePersonas {
  title: string;
  intro: string;
  cards: PersonaCard[];
}

export interface RetainerPhase {
  tag: string;
  title: string;
  body: string;
}

export interface RetainerReservedSeat {
  tag: string;
  title: string;
  body: string;
}

export interface CraHomeRetainer {
  title: string;
  intro: string;
  phases: RetainerPhase[];
  reservedSeat: RetainerReservedSeat;
  digitalTwin: string;
}

export interface ProcessStep {
  number: string;
  title: string;
  body: string;
}

export interface CraHomeProcess {
  title: string;
  steps: ProcessStep[];
}

export interface CraHomeFinalCta {
  title: string;
  line: string;
  ctaLabel: string;
}

export interface CraHomeHero {
  eyebrow: string;
  title: string;
  titleAccent: string;
  subtitle: string;
  badges: string[];
  realityCallout: string;
  /** Primary CTA on the hero — scrolls to the #intake section. */
  ctaLabel: string;
}

export interface StatBandItem {
  value: string;
  label: string;
  sub?: string;
}

export interface CraHomeStatBand {
  items: StatBandItem[];
}

export interface EngineBom {
  code: string;
  label: string;
}

export interface EngineRiskStep {
  number: string;
  title: string;
  body: string;
}

export interface CraHomeEngine {
  eyebrow: string;
  title: string;
  intro: string;
  bomsTitle: string;
  boms: EngineBom[];
  bomsNote: string;
  riskTitle: string;
  riskSteps: EngineRiskStep[];
  riskNote: string;
  outputsTitle: string;
  outputsHuman: string;
  outputsMachine: string;
  outputsNote: string;
}

export interface WhyOxotPillar {
  title: string;
  body: string;
}

export interface CraHomeWhyOxot {
  eyebrow: string;
  title: string;
  intro: string;
  pillars: WhyOxotPillar[];
}

export interface CraHomeIntake {
  eyebrow: string;
  title: string;
  intro: string;
  formHeading: string;
  formSub: string;
  /** "You leave the call with…" promise; also passed to the intake form. */
  promise: string;
}

export interface CraHome {
  hero: CraHomeHero;
  statBand: CraHomeStatBand;
  departureBoard: CraHomeDepartureBoard;
  roadsSplit: CraHomeRoadsSplit;
  personas: CraHomePersonas;
  engine: CraHomeEngine;
  retainer: CraHomeRetainer;
  whyOxot: CraHomeWhyOxot;
  intake: CraHomeIntake;
  process: CraHomeProcess;
  finalCta: CraHomeFinalCta;
}

export const CRA_HOME_KEY = "cra_home";

// Defaults come straight from the shipped JSON, so the page renders identically
// before anyone touches the admin. Unknown locales fall back to English.
export function defaultCraHome(locale: Locale): CraHome {
  return (locale === "nl" ? nlDefault : enDefault) as CraHome;
}

// Public read used by the live page. Wrapped in try/catch so the front door
// never 500s if the DB is unavailable — it degrades to the shipped defaults.
export async function getCraHome(locale: Locale): Promise<CraHome> {
  try {
    const { rows } = await pool.query(
      `SELECT data FROM site_blocks WHERE key = $1 AND locale = $2 LIMIT 1`,
      [CRA_HOME_KEY, locale]
    );
    if (rows[0]?.data) return rows[0].data as CraHome;
  } catch (e) {
    console.warn("[cra-home] DB unavailable, using JSON defaults:", e);
  }
  return defaultCraHome(locale);
}

// Admin read: the stored row if present, otherwise the defaults (so the editor
// always has something to load and edit).
export async function getCraHomeForEdit(locale: Locale): Promise<CraHome> {
  return getCraHome(locale);
}

export async function saveCraHome(locale: Locale, data: CraHome): Promise<void> {
  await pool.query(
    `INSERT INTO site_blocks (key, locale, data, updated_at)
     VALUES ($1, $2, $3, now())
     ON CONFLICT (key, locale) DO UPDATE SET data = EXCLUDED.data, updated_at = now()`,
    [CRA_HOME_KEY, locale, JSON.stringify(data)]
  );
}
