import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";

const ALLOWED = new Set(["page", "click", "scroll", "dwell"]);
const META_MAX_BYTES = 4096;

// Only accept a plain JSON object for `meta`, capped in size; anything else -> null.
function sanitizeMeta(meta: unknown): Record<string, unknown> | null {
  if (!meta || typeof meta !== "object" || Array.isArray(meta)) return null;
  try {
    const json = JSON.stringify(meta);
    if (json.length > META_MAX_BYTES) return null;
    return meta as Record<string, unknown>;
  } catch {
    return null;
  }
}

// Consent-gated capture of behavioral signals. No consent -> 403, nothing stored.
export async function POST(req: NextRequest) {
  const body = (await req.json().catch(() => ({}))) as {
    sessionId?: string;
    type?: string;
    pageId?: string;
    element?: string;
    meta?: unknown;
  };
  if (!body.sessionId || !body.type || !ALLOWED.has(body.type)) {
    return NextResponse.json({ error: "invalid event" }, { status: 400 });
  }

  const { rows } = await pool.query(
    `SELECT consent_at FROM visitor_sessions WHERE id = $1`,
    [body.sessionId]
  );
  if (!rows.length) {
    return NextResponse.json({ error: "session not found" }, { status: 404 });
  }
  if (!rows[0].consent_at) {
    return NextResponse.json({ error: "consent required" }, { status: 403 });
  }

  await pool.query(
    `INSERT INTO visitor_events (session_id, type, page_id, element, meta)
     VALUES ($1, $2, $3, $4, $5)`,
    [body.sessionId, body.type, body.pageId ?? null, body.element ?? null, sanitizeMeta(body.meta)]
  );
  return NextResponse.json({ ok: true });
}
