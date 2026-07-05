import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { isLocale } from "@/i18n/config";

// Create a visitor session. Consent is recorded only if explicitly granted.
export async function POST(req: NextRequest) {
  const body = (await req.json().catch(() => ({}))) as {
    locale?: string;
    consent?: boolean;
  };
  const locale = body.locale && isLocale(body.locale) ? body.locale : "en";
  const { rows } = await pool.query(
    `INSERT INTO visitor_sessions (locale, consent_at)
     VALUES ($1, CASE WHEN $2 THEN now() ELSE NULL END)
     RETURNING id, consent_at`,
    [locale, body.consent === true]
  );
  return NextResponse.json({ sessionId: rows[0].id, consent: !!rows[0].consent_at });
}

// Grant (or update) consent for an existing session.
export async function PATCH(req: NextRequest) {
  const body = (await req.json().catch(() => ({}))) as {
    sessionId?: string;
    consent?: boolean;
  };
  if (!body.sessionId) {
    return NextResponse.json({ error: "sessionId required" }, { status: 400 });
  }
  const { rowCount } = await pool.query(
    `UPDATE visitor_sessions
       SET consent_at = CASE WHEN $2 THEN now() ELSE NULL END
     WHERE id = $1`,
    [body.sessionId, body.consent === true]
  );
  if (!rowCount) {
    return NextResponse.json({ error: "session not found" }, { status: 404 });
  }
  return NextResponse.json({ ok: true });
}
