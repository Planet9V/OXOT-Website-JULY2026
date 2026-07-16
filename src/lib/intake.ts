import { pool } from "@/lib/db";

/**
 * Pure, dependency-free validation + insert helpers for the CRA readiness
 * intake form. Mirrors src/lib/contact.ts (same honeypot/email/UUID patterns);
 * hashIp + checkRateLimit are reused directly from contact.ts by callers
 * rather than duplicated here.
 */

export const SEGMENTS = ["manufacturer", "oem", "integrator", "reseller", "operator"] as const;
export type Segment = (typeof SEGMENTS)[number];

export function isSegment(v: unknown): v is Segment {
  return typeof v === "string" && (SEGMENTS as readonly string[]).includes(v);
}

export interface IntakeInput {
  name?: unknown;
  email?: unknown;
  company?: unknown;
  role?: unknown;
  segment?: unknown;
  answers?: unknown;
  blocker?: unknown;
  locale?: unknown;
  page?: unknown;
  sessionId?: unknown;
  utm?: unknown;
  // Honeypot: a hidden field real users never fill.
  website?: unknown;
}

export interface IntakeData {
  name: string;
  email: string;
  company: string | null;
  role: string | null;
  segment: Segment;
  answers: Record<string, unknown>;
  blocker: string | null;
  locale: string;
  page: string | null;
  sessionId: string | null;
  utm: Record<string, unknown>;
  // Set by the route after validation (validateIntake never sees the request IP).
  ipHash: string | null;
}

const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const str = (v: unknown) => (typeof v === "string" ? v.trim() : "");

function plainObject(v: unknown): Record<string, unknown> | null {
  if (v === undefined) return {};
  if (typeof v !== "object" || v === null || Array.isArray(v)) return null;
  return v as Record<string, unknown>;
}

export type IntakeResult =
  | { ok: true; data: IntakeData }
  | { ok: false; errors: Record<string, string>; spam?: boolean };

export function validateIntake(input: IntakeInput): IntakeResult {
  // Honeypot filled -> silently treat as spam (caller should return a fake 200).
  if (str(input.website)) return { ok: false, errors: {}, spam: true };

  const name = str(input.name);
  const email = str(input.email);
  const company = str(input.company);
  const role = str(input.role);
  const segment = str(input.segment);
  const blocker = str(input.blocker);
  const locale = input.locale === "nl" ? "nl" : "en";
  const page = str(input.page);

  const errors: Record<string, string> = {};
  if (name.length < 2) errors.name = "required";
  if (name.length > 120) errors.name = "too_long";
  if (!EMAIL_RE.test(email)) errors.email = "invalid";
  if (!isSegment(segment)) errors.segment = "invalid";
  if (company.length > 160) errors.company = "too_long";
  if (role.length > 120) errors.role = "too_long";
  if (blocker.length > 5000) errors.blocker = "too_long";

  const answers = plainObject(input.answers);
  if (answers === null) errors.answers = "invalid";

  const utm = plainObject(input.utm);
  if (utm === null) errors.utm = "invalid";

  if (Object.keys(errors).length) return { ok: false, errors };

  const sid = str(input.sessionId);
  return {
    ok: true,
    data: {
      name,
      email,
      company: company || null,
      role: role || null,
      segment: segment as Segment,
      answers: answers ?? {},
      blocker: blocker || null,
      locale,
      page: page || null,
      sessionId: sid && UUID_RE.test(sid) ? sid : null,
      utm: utm ?? {},
      ipHash: null
    }
  };
}

/**
 * Insert a lead, same two-step pattern as /api/contact: try with the embedding
 * first; if that fails (e.g. column/model unavailable), retry without it so
 * leads are never lost. Returns the new row's id.
 */
export async function insertLead(data: IntakeData, embedLiteral: string | null): Promise<string> {
  try {
    const { rows } = await pool.query<{ id: string }>(
      `INSERT INTO cra_readiness_leads
         (segment, name, email, company, role, answers, blocker, locale, page, utm, ip_hash, session_id, embedding)
       VALUES ($1,$2,$3,$4,$5,$6::jsonb,$7,$8,$9,$10::jsonb,$11,$12,$13::vector)
       RETURNING id`,
      [
        data.segment,
        data.name,
        data.email,
        data.company,
        data.role,
        JSON.stringify(data.answers),
        data.blocker,
        data.locale,
        data.page,
        JSON.stringify(data.utm),
        data.ipHash,
        data.sessionId,
        embedLiteral
      ]
    );
    return rows[0].id;
  } catch (err) {
    console.error("[intake] insert failed:", err);
    try {
      const { rows } = await pool.query<{ id: string }>(
        `INSERT INTO cra_readiness_leads
           (segment, name, email, company, role, answers, blocker, locale, page, utm, ip_hash, session_id)
         VALUES ($1,$2,$3,$4,$5,$6::jsonb,$7,$8,$9,$10::jsonb,$11,$12)
         RETURNING id`,
        [
          data.segment,
          data.name,
          data.email,
          data.company,
          data.role,
          JSON.stringify(data.answers),
          data.blocker,
          data.locale,
          data.page,
          JSON.stringify(data.utm),
          data.ipHash,
          data.sessionId
        ]
      );
      return rows[0].id;
    } catch (err2) {
      console.error("[intake] insert failed (fallback):", err2);
      throw err2;
    }
  }
}
