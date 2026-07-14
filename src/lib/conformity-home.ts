import { pool } from "./db";
import type { Locale } from "@/i18n/config";
import enDefault from "../../data/conformity_home_en.json";
import nlDefault from "../../data/conformity_home_nl.json";

/**
 * Structured, admin-editable content for the conformity home page (the live
 * front door at /[locale]). Stored in the site_blocks table as one JSONB row per
 * locale (key='conformity_home'); falls back to the shipped JSON defaults when a
 * row hasn't been created/edited yet. This is a NEW key, parallel to and
 * independent of the existing 'home' key (which now feeds /industrial-operations).
 */

export interface CtaLink {
  label: string;
  href: string;
}

export interface ConformityHomeHero {
  eyebrow: string;
  title: string;
  subtitle: string;
  primaryCta: CtaLink;
  secondaryCta: CtaLink;
  bullets: string[];
}

export interface ConformityHomeLogoWall {
  title: string;
  logos: string[];
}

export interface ConformityHomeStat {
  value: string;
  label: string;
  sublabel: string;
}

export interface ConformityHomeFeature {
  title: string;
  description: string;
  icon: string;
}

export interface ConformityHomeFeatureGrid {
  eyebrow: string;
  title: string;
  subtitle: string;
  features: ConformityHomeFeature[];
}

export interface ConformityHomeProblemShift {
  eyebrow: string;
  title: string;
  body: string;
  bullets: string[];
  cta: CtaLink;
}

export interface ConformityHomeComparisonRow {
  label: string;
  left: string;
  right: boolean;
}

export interface ConformityHomeComparison {
  eyebrow: string;
  title: string;
  subtitle: string;
  columns: string[];
  rows: ConformityHomeComparisonRow[];
}

export interface ConformityHomeStep {
  number: string;
  title: string;
  description: string;
}

export interface ConformityHomeSteps {
  eyebrow: string;
  title: string;
  steps: ConformityHomeStep[];
}

export interface ConformityHomeQuote {
  quote: string;
  author: string;
  role: string;
}

export interface ConformityHomeFaqItem {
  question: string;
  answer: string;
}

export interface ConformityHomeFaq {
  eyebrow: string;
  title: string;
  items: ConformityHomeFaqItem[];
}

export interface ConformityHomeCta {
  title: string;
  subtitle: string;
  primaryCta: CtaLink;
  secondaryCta: CtaLink;
}

export interface ConformityHome {
  hero: ConformityHomeHero;
  logoWall: ConformityHomeLogoWall;
  stats: ConformityHomeStat[];
  featureGrid: ConformityHomeFeatureGrid;
  problem: ConformityHomeProblemShift;
  shift: ConformityHomeProblemShift;
  comparison: ConformityHomeComparison;
  steps: ConformityHomeSteps;
  quote: ConformityHomeQuote;
  faq: ConformityHomeFaq;
  cta: ConformityHomeCta;
}

export const CONFORMITY_HOME_KEY = "conformity_home";

// Defaults come straight from the shipped JSON, so the page renders identically
// before anyone touches the admin. Unknown locales fall back to English.
export function defaultConformityHome(locale: Locale): ConformityHome {
  return (locale === "nl" ? nlDefault : enDefault) as ConformityHome;
}

// Public read used by the live page. Wrapped in try/catch so the front door
// never 500s if the DB is unavailable — it degrades to the shipped defaults.
export async function getConformityHome(locale: Locale): Promise<ConformityHome> {
  try {
    const { rows } = await pool.query(
      `SELECT data FROM site_blocks WHERE key = $1 AND locale = $2 LIMIT 1`,
      [CONFORMITY_HOME_KEY, locale]
    );
    if (rows[0]?.data) return rows[0].data as ConformityHome;
  } catch (e) {
    console.warn("[conformity-home] DB unavailable, using JSON defaults:", e);
  }
  return defaultConformityHome(locale);
}

// Admin read: the stored row if present, otherwise the defaults (so the editor
// always has something to load and edit).
export async function getConformityHomeForEdit(locale: Locale): Promise<ConformityHome> {
  return getConformityHome(locale);
}

export async function saveConformityHome(locale: Locale, data: ConformityHome): Promise<void> {
  await pool.query(
    `INSERT INTO site_blocks (key, locale, data, updated_at)
     VALUES ($1, $2, $3, now())
     ON CONFLICT (key, locale) DO UPDATE SET data = EXCLUDED.data, updated_at = now()`,
    [CONFORMITY_HOME_KEY, locale, JSON.stringify(data)]
  );
}
