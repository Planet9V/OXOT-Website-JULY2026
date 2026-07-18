import { pool } from "./db";
import type { Locale } from "@/i18n/config";

// ─────────────────────────────────────────────────────────────────────────────
// Conformity Platform data access.
// Backs /[locale]/conformity-platform/* — the multi-regulation obligation model
// (regulations, requirements, cross-cutting themes, theme×regulation matrix,
// implementation timeline, source corpus). Seeded by migration 021.
// NL columns fall back to the English value when a translation is absent, so no
// user-facing string is ever empty in either locale.
// ─────────────────────────────────────────────────────────────────────────────

export interface Regulation {
  key: string;
  name: string;
  shortName: string;
  fullTitle: string;
  jurisdiction: string | null;
  summary: string | null;
  inForceDate: string | null;
  sourceUrl: string | null;
  requirementCount: number;
  sortOrder: number;
}

export interface Theme {
  key: string;
  name: string;
  description: string | null;
  sortOrder: number;
  requirementCount: number;
}

export interface Requirement {
  id: number;
  regulationKey: string;
  regulationShortName: string;
  themeKey: string | null;
  themeName: string | null;
  refCode: string;
  title: string;
  description: string | null;
  obligationType: string;
  appliesTo: string[];
  mappingCount: number;
  sortOrder: number;
}

export interface MatrixCell {
  themeKey: string;
  regulationKey: string;
  requirementCount: number;
  requirementRefs: string[];
}

export interface TimelineEvent {
  regulationKey: string | null;
  date: string;
  label: string;
  sortOrder: number;
}

export interface SourceDoc {
  title: string;
  filename: string | null;
  url: string | null;
  kind: string | null;
  description: string | null;
  regulationKey: string | null;
  sortOrder: number;
}

export interface ConformitySummary {
  regulationCount: number;
  requirementCount: number;
  themeCount: number;
  mappingCount: number;
}

const isNl = (l: Locale) => l === "nl";

export async function getRegulations(locale: Locale): Promise<Regulation[]> {
  const nl = isNl(locale);
  const { rows } = await pool.query(
    `SELECT key,
            COALESCE(${nl ? "NULLIF(name_nl,'')," : ""} name)             AS "name",
            COALESCE(${nl ? "NULLIF(short_name_nl,'')," : ""} short_name) AS "shortName",
            COALESCE(${nl ? "NULLIF(full_title_nl,'')," : ""} full_title) AS "fullTitle",
            jurisdiction,
            COALESCE(${nl ? "NULLIF(summary_nl,'')," : ""} summary)       AS "summary",
            to_char(in_force_date,'YYYY-MM-DD') AS "inForceDate",
            source_url        AS "sourceUrl",
            requirement_count AS "requirementCount",
            sort_order        AS "sortOrder"
       FROM conformity_regulations
      ORDER BY sort_order, short_name`
  );
  return rows;
}

export async function getRegulation(key: string, locale: Locale): Promise<Regulation | null> {
  const all = await getRegulations(locale);
  return all.find((r) => r.key === key) ?? null;
}

export async function getThemes(locale: Locale): Promise<Theme[]> {
  const nl = isNl(locale);
  const { rows } = await pool.query(
    `SELECT t.key,
            COALESCE(${nl ? "NULLIF(t.name_nl,'')," : ""} t.name)              AS "name",
            COALESCE(${nl ? "NULLIF(t.description_nl,'')," : ""} t.description) AS "description",
            t.sort_order AS "sortOrder",
            COALESCE(SUM(m.requirement_count),0)::int AS "requirementCount"
       FROM conformity_themes t
       LEFT JOIN conformity_mappings m ON m.theme_key = t.key
      GROUP BY t.id
      ORDER BY t.sort_order, t.name`
  );
  return rows;
}

export async function getRequirements(locale: Locale): Promise<Requirement[]> {
  const nl = isNl(locale);
  const { rows } = await pool.query(
    `SELECT r.id,
            r.regulation_key AS "regulationKey",
            COALESCE(${nl ? "NULLIF(reg.short_name_nl,'')," : ""} reg.short_name) AS "regulationShortName",
            r.theme_key      AS "themeKey",
            COALESCE(${nl ? "NULLIF(t.name_nl,'')," : ""} t.name) AS "themeName",
            r.ref_code       AS "refCode",
            COALESCE(${nl ? "NULLIF(r.title_nl,'')," : ""} r.title)             AS "title",
            COALESCE(${nl ? "NULLIF(r.description_nl,'')," : ""} r.description) AS "description",
            r.obligation_type AS "obligationType",
            r.applies_to      AS "appliesTo",
            r.mapping_count   AS "mappingCount",
            r.sort_order      AS "sortOrder"
       FROM conformity_requirements r
       LEFT JOIN conformity_regulations reg ON reg.key = r.regulation_key
       LEFT JOIN conformity_themes t ON t.key = r.theme_key
      ORDER BY reg.sort_order, r.sort_order`
  );
  return rows;
}

export async function getRequirementsForRegulation(
  key: string,
  locale: Locale
): Promise<Requirement[]> {
  const all = await getRequirements(locale);
  return all.filter((r) => r.regulationKey === key);
}

export async function getMatrixCells(): Promise<MatrixCell[]> {
  const { rows } = await pool.query(
    `SELECT theme_key        AS "themeKey",
            regulation_key   AS "regulationKey",
            requirement_count AS "requirementCount",
            requirement_refs  AS "requirementRefs"
       FROM conformity_mappings`
  );
  return rows;
}

export async function getTimeline(locale: Locale): Promise<TimelineEvent[]> {
  const nl = isNl(locale);
  const { rows } = await pool.query(
    `SELECT regulation_key AS "regulationKey",
            to_char(event_date,'YYYY-MM-DD') AS "date",
            COALESCE(${nl ? "NULLIF(label_nl,'')," : ""} label) AS "label",
            sort_order AS "sortOrder"
       FROM conformity_timeline
      ORDER BY event_date, sort_order`
  );
  return rows;
}

export async function getSources(locale: Locale): Promise<SourceDoc[]> {
  const nl = isNl(locale);
  const { rows } = await pool.query(
    `SELECT COALESCE(${nl ? "NULLIF(title_nl,'')," : ""} title)             AS "title",
            filename, url, kind,
            COALESCE(${nl ? "NULLIF(description_nl,'')," : ""} description) AS "description",
            regulation_key AS "regulationKey",
            sort_order     AS "sortOrder"
       FROM conformity_sources
      ORDER BY sort_order, title`
  );
  return rows;
}

export async function getSummary(): Promise<ConformitySummary> {
  const { rows } = await pool.query(
    `SELECT key, value_int FROM conformity_meta`
  );
  const m: Record<string, number> = {};
  for (const r of rows) m[r.key] = r.value_int;
  // Fall back to live counts if a meta row is missing.
  const fallback = await pool.query(
    `SELECT (SELECT count(*) FROM conformity_regulations) AS regs,
            (SELECT count(*) FROM conformity_requirements) AS reqs,
            (SELECT count(*) FROM conformity_themes) AS themes`
  );
  const f = fallback.rows[0];
  return {
    regulationCount: m.regulation_count ?? Number(f.regs),
    requirementCount: m.requirement_count ?? Number(f.reqs),
    themeCount: m.theme_count ?? Number(f.themes),
    mappingCount: m.mapping_count ?? 0,
  };
}

/** Obligation type keys → display order. */
export const OBLIGATION_TYPES = [
  "product_requirement",
  "process",
  "documentation",
  "reporting",
  "governance",
] as const;
