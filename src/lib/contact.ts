import { createHash } from "node:crypto";

/**
 * Pure, dependency-free validation + spam controls for the contact form.
 * Kept separate from the route handler so it is unit-testable (Karpathy rule 9).
 */

export interface ContactInput {
  name?: unknown;
  email?: unknown;
  company?: unknown;
  message?: unknown;
  locale?: unknown;
  page?: unknown;
  sessionId?: unknown;
  // Honeypot: a hidden field real users never fill. Named to look tempting to bots.
  website?: unknown;
}

export interface ContactData {
  name: string;
  email: string;
  company: string | null;
  message: string;
  locale: string;
  page: string | null;
  sessionId: string | null;
}

const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

export type ContactResult =
  | { ok: true; data: ContactData }
  | { ok: false; errors: Record<string, string>; spam?: boolean };

const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const str = (v: unknown) => (typeof v === "string" ? v.trim() : "");

export function validateContact(input: ContactInput): ContactResult {
  // Honeypot filled -> silently treat as spam (caller should return a fake 200).
  if (str(input.website)) return { ok: false, errors: {}, spam: true };

  const name = str(input.name);
  const email = str(input.email);
  const company = str(input.company);
  const message = str(input.message);
  const locale = input.locale === "nl" ? "nl" : "en";
  const page = str(input.page);

  const errors: Record<string, string> = {};
  if (name.length < 2) errors.name = "required";
  if (name.length > 120) errors.name = "too_long";
  if (!EMAIL_RE.test(email)) errors.email = "invalid";
  if (message.length < 10) errors.message = "too_short";
  if (message.length > 5000) errors.message = "too_long";
  if (company.length > 160) errors.company = "too_long";

  if (Object.keys(errors).length) return { ok: false, errors };

  const sid = str(input.sessionId);
  return {
    ok: true,
    data: {
      name,
      email,
      company: company || null,
      message,
      locale,
      page: page || null,
      sessionId: sid && UUID_RE.test(sid) ? sid : null
    }
  };
}

export function hashIp(ip: string | null | undefined): string | null {
  if (!ip) return null;
  return createHash("sha256").update(ip).digest("hex").slice(0, 32);
}

// Best-effort in-memory per-key rate limiter. Resets on process restart; good
// enough to blunt trivial floods without external state. Not a security boundary.
const hits = new Map<string, number[]>();
export function checkRateLimit(
  key: string,
  limit = 5,
  windowMs = 10 * 60 * 1000,
  now = Date.now()
): boolean {
  const arr = (hits.get(key) ?? []).filter((t) => now - t < windowMs);
  if (arr.length >= limit) {
    hits.set(key, arr);
    return false;
  }
  arr.push(now);
  hits.set(key, arr);
  return true;
}

// Test helper: clear limiter state.
export function _resetRateLimit(): void {
  hits.clear();
}
