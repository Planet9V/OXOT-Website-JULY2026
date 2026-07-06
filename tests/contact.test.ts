import { describe, it, expect, beforeEach } from "vitest";
import { validateContact, hashIp, checkRateLimit, _resetRateLimit } from "@/lib/contact";

describe("validateContact", () => {
  const valid = { name: "Jane Doe", email: "jane@acme.com", message: "We run a water utility and need an OT assessment." };

  it("accepts a well-formed submission", () => {
    const r = validateContact(valid);
    expect(r.ok).toBe(true);
    if (r.ok) {
      expect(r.data.name).toBe("Jane Doe");
      expect(r.data.email).toBe("jane@acme.com");
      expect(r.data.company).toBeNull();
      expect(r.data.locale).toBe("en");
    }
  });

  it("defaults locale to en and passes nl through", () => {
    const en = validateContact(valid);
    const nl = validateContact({ ...valid, locale: "nl" });
    expect(en.ok && en.data.locale).toBe("en");
    expect(nl.ok && nl.data.locale).toBe("nl");
  });

  it("rejects an invalid email", () => {
    const r = validateContact({ ...valid, email: "not-an-email" });
    expect(r.ok).toBe(false);
    if (!r.ok) expect(r.errors.email).toBe("invalid");
  });

  it("rejects a too-short message and a missing name", () => {
    const r = validateContact({ name: "J", email: "j@acme.com", message: "hi" });
    expect(r.ok).toBe(false);
    if (!r.ok) {
      expect(r.errors.name).toBeDefined();
      expect(r.errors.message).toBe("too_short");
    }
  });

  it("flags honeypot as spam without field errors", () => {
    const r = validateContact({ ...valid, website: "http://spam.example" });
    expect(r.ok).toBe(false);
    if (!r.ok) expect(r.spam).toBe(true);
  });

  it("trims whitespace and drops empty optional company", () => {
    const r = validateContact({ ...valid, name: "  Jane  ", company: "   " });
    expect(r.ok && r.data.name).toBe("Jane");
    expect(r.ok && r.data.company).toBeNull();
  });
});

describe("hashIp", () => {
  it("returns null for empty input and a stable 32-char hash otherwise", () => {
    expect(hashIp(null)).toBeNull();
    const a = hashIp("203.0.113.7");
    const b = hashIp("203.0.113.7");
    expect(a).toBe(b);
    expect(a).toHaveLength(32);
    expect(hashIp("203.0.113.8")).not.toBe(a);
  });
});

describe("checkRateLimit", () => {
  beforeEach(() => _resetRateLimit());

  it("allows up to the limit then blocks", () => {
    const key = "contact:1.2.3.4";
    for (let n = 0; n < 5; n++) expect(checkRateLimit(key, 5, 1000)).toBe(true);
    expect(checkRateLimit(key, 5, 1000)).toBe(false);
  });

  it("frees up capacity after the window passes", () => {
    const key = "contact:5.6.7.8";
    const t0 = 1_000_000;
    for (let n = 0; n < 5; n++) expect(checkRateLimit(key, 5, 1000, t0)).toBe(true);
    expect(checkRateLimit(key, 5, 1000, t0)).toBe(false);
    expect(checkRateLimit(key, 5, 1000, t0 + 2000)).toBe(true);
  });

  it("tracks different keys independently", () => {
    expect(checkRateLimit("a", 1, 1000)).toBe(true);
    expect(checkRateLimit("a", 1, 1000)).toBe(false);
    expect(checkRateLimit("b", 1, 1000)).toBe(true);
  });
});
