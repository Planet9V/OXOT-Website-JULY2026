import { pool } from "./db";
import { getDictionary } from "@/i18n/dictionaries";
import type { Locale } from "@/i18n/config";

/**
 * Structured, admin-editable homepage content (hero + services). Stored in the
 * site_blocks table as one JSONB row per locale (key='home'); falls back to the
 * i18n dictionary defaults when a row hasn't been created/edited yet.
 */

export interface HomeStat { n: string; l: string; accent: boolean }
export interface HomeHero {
  kicker: string;
  title: string;
  subtitle: string;
  cta: string;
  cta2: string;
  trustLabel: string;
  industries: string[];
  card: { title: string; tag: string; findingsLabel: string; stats: HomeStat[] };
}
export interface HomeServiceItem { name: string; desc: string; href: string }
export interface HomeServices {
  eyebrow: string;
  heading: string;
  intro: string;
  more: string;
  cta: { title: string; body: string; button: string };
  items: HomeServiceItem[];
}
export interface HomeContent { hero: HomeHero; services: HomeServices }

export const HOME_KEY = "home";

// Defaults come straight from the shipped dictionaries, so the site renders
// identically before anyone touches the admin.
export function defaultHomeContent(locale: Locale): HomeContent {
  return getDictionary(locale).home as unknown as HomeContent;
}

export async function getHomeContent(locale: Locale): Promise<HomeContent> {
  try {
    const { rows } = await pool.query(
      `SELECT data FROM site_blocks WHERE key = $1 AND locale = $2 LIMIT 1`,
      [HOME_KEY, locale]
    );
    if (rows[0]?.data) return rows[0].data as HomeContent;
  } catch (e) {
    console.warn("[site-content] DB unavailable, using dictionary defaults:", e);
  }
  return defaultHomeContent(locale);
}

// Admin read: the stored row if present, otherwise the defaults (so the editor
// always has something to load and edit).
export async function getHomeContentForEdit(locale: Locale): Promise<HomeContent> {
  return getHomeContent(locale);
}

export async function saveHomeContent(locale: Locale, data: HomeContent): Promise<void> {
  await pool.query(
    `INSERT INTO site_blocks (key, locale, data, updated_at)
     VALUES ($1, $2, $3, now())
     ON CONFLICT (key, locale) DO UPDATE SET data = EXCLUDED.data, updated_at = now()`,
    [HOME_KEY, locale, JSON.stringify(data)]
  );
}
