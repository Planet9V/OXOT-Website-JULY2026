import { pool } from "@/lib/db";

/**
 * CRA intake settings — stored as key/value rows in the EXISTING `app_settings`
 * table (no migration needed), mirroring src/lib/integration-settings.ts.
 *
 * None of these keys are secrets (a scheduling URL, a notify-email address, a
 * boolean flag, and a JSON map of segment -> PDF path/id are all fine to read
 * back verbatim), so — unlike integration-settings.ts — there is NO encryption
 * here. Everything is stored and returned as plaintext.
 */

/** All keys this module owns in app_settings. */
export const INTAKE_SETTING_KEYS = [
  "intake_scheduling_provider", // "none" | "calcom" | "calendly"
  "intake_scheduling_url",
  "intake_segment_email_autosend", // "true" | "false"
  "intake_segment_pdf_map", // JSON string: {segment: pathOrId}
  "intake_notify_email"
] as const;
export type IntakeSettingKey = (typeof INTAKE_SETTING_KEYS)[number];

export type SchedulingProvider = "none" | "calcom" | "calendly";

export interface IntakeSettings {
  schedulingProvider: SchedulingProvider;
  schedulingUrl: string;
  segmentEmailAutosend: boolean;
  segmentPdfMap: Record<string, string>;
  notifyEmail: string;
}

let cache: { at: number; rows: Record<string, string> } | null = null;
const TTL_MS = 10_000;

async function readSettings(): Promise<Record<string, string>> {
  if (cache && Date.now() - cache.at < TTL_MS) return cache.rows;
  const rows: Record<string, string> = {};
  try {
    const r = await pool.query<{ key: string; value: string | null }>(
      `SELECT key, value FROM app_settings WHERE key = ANY($1::text[])`,
      [INTAKE_SETTING_KEYS as readonly string[]]
    );
    for (const row of r.rows) if (row.value != null && row.value !== "") rows[row.key] = row.value;
  } catch {
    // table may not exist yet — treat as empty.
  }
  cache = { at: Date.now(), rows };
  return rows;
}

function bool(v: string | undefined, dflt = false): boolean {
  if (v == null) return dflt;
  return v === "true" || v === "1";
}

function parsePdfMap(v: string | undefined): Record<string, string> {
  if (!v) return {};
  try {
    const parsed = JSON.parse(v);
    if (parsed && typeof parsed === "object" && !Array.isArray(parsed)) {
      const out: Record<string, string> = {};
      for (const [k, val] of Object.entries(parsed)) {
        if (typeof val === "string") out[k] = val;
      }
      return out;
    }
  } catch {
    // malformed JSON — treat as unset rather than throwing.
  }
  return {};
}

/** Effective intake settings. Nothing here is secret. */
export async function getIntakeSettings(): Promise<IntakeSettings> {
  const s = await readSettings();
  const provider = s.intake_scheduling_provider;
  return {
    schedulingProvider: provider === "calcom" || provider === "calendly" ? provider : "none",
    schedulingUrl: s.intake_scheduling_url ?? "",
    segmentEmailAutosend: bool(s.intake_segment_email_autosend, false),
    segmentPdfMap: parsePdfMap(s.intake_segment_pdf_map),
    notifyEmail: s.intake_notify_email ?? ""
  };
}

/** Admin view: identical to getIntakeSettings() — nothing here is a secret. */
export async function getIntakeSettingsMasked(): Promise<IntakeSettings> {
  return getIntakeSettings();
}

/**
 * Upsert a batch of intake settings. An empty string value deletes the row
 * (reverting to the default). Booleans should be passed as "true"/"false".
 */
export async function saveIntakeSettings(patch: Partial<Record<IntakeSettingKey, string>>): Promise<void> {
  const entries = Object.entries(patch).filter(([k]) =>
    (INTAKE_SETTING_KEYS as readonly string[]).includes(k)
  ) as [IntakeSettingKey, string][];

  for (const [key, value] of entries) {
    if (value === "") continue;
    if (key === "intake_scheduling_provider" && !["none", "calcom", "calendly"].includes(value)) {
      throw new Error("intake_scheduling_provider must be one of: none, calcom, calendly");
    }
    if (key === "intake_segment_pdf_map") {
      try {
        const parsed = JSON.parse(value);
        if (typeof parsed !== "object" || parsed === null || Array.isArray(parsed)) throw new Error("not an object");
      } catch {
        throw new Error("intake_segment_pdf_map must be a JSON object string");
      }
    }
  }

  for (const [key, value] of entries) {
    if (value === "") {
      await pool.query(`DELETE FROM app_settings WHERE key = $1`, [key]);
    } else {
      await pool.query(
        `INSERT INTO app_settings (key, value, updated_at) VALUES ($1,$2, now())
         ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value, updated_at = now()`,
        [key, value]
      );
    }
  }
  cache = null; // invalidate so next read is fresh
}
