import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { validateContact, hashIp, checkRateLimit } from "@/lib/contact";

export const runtime = "nodejs";

function clientIp(req: NextRequest): string | null {
  const xff = req.headers.get("x-forwarded-for");
  if (xff) return xff.split(",")[0].trim();
  return req.headers.get("x-real-ip");
}

export async function POST(req: NextRequest) {
  const body = await req.json().catch(() => ({}));
  const result = validateContact(body);

  // Honeypot tripped: pretend success so bots don't learn they were caught.
  if (!result.ok && result.spam) {
    return NextResponse.json({ ok: true });
  }
  if (!result.ok) {
    return NextResponse.json({ ok: false, errors: result.errors }, { status: 400 });
  }

  const ip = clientIp(req);
  if (!checkRateLimit(`contact:${ip ?? "unknown"}`)) {
    return NextResponse.json(
      { ok: false, errors: { _: "rate_limited" } },
      { status: 429 }
    );
  }

  const { name, email, company, message, locale, page } = result.data;
  try {
    await pool.query(
      `INSERT INTO contact_messages (name, email, company, message, locale, page, ip_hash)
       VALUES ($1,$2,$3,$4,$5,$6,$7)`,
      [name, email, company, message, locale, page, hashIp(ip)]
    );
  } catch (err) {
    console.error("[contact] insert failed:", err);
    return NextResponse.json({ ok: false, errors: { _: "server" } }, { status: 500 });
  }

  return NextResponse.json({ ok: true });
}
