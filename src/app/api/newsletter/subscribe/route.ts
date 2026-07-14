import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";

export const runtime = "nodejs";

// Minimal, permissive email shape check — real validation happens at confirm time.
const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export async function POST(req: NextRequest) {
  const body = await req.json().catch(() => ({}));
  const email = typeof body?.email === "string" ? body.email.trim().toLowerCase() : "";
  const locale = typeof body?.locale === "string" ? body.locale : null;
  const source = typeof body?.source === "string" ? body.source : "footer";

  if (!email || email.length > 320 || !EMAIL_RE.test(email)) {
    return NextResponse.json({ ok: false, error: "invalid_email" }, { status: 400 });
  }

  try {
    // Record the subscriber. Duplicates are a no-op (never surface an error to the client).
    // Actual double opt-in email delivery is a later phase; we only capture intent here.
    await pool.query(
      `INSERT INTO newsletter_subscribers (email, locale, status, source)
       VALUES ($1, $2, 'pending', $3)
       ON CONFLICT (email) DO NOTHING`,
      [email, locale, source]
    );
  } catch (err) {
    console.error("[newsletter] insert failed:", err);
    // Never 500 the client for a subscribe attempt — treat as accepted and move on.
    return NextResponse.json({ ok: true });
  }

  return NextResponse.json({ ok: true });
}
