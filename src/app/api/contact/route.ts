import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { validateContact, hashIp, checkRateLimit } from "@/lib/contact";
import { embed } from "@/lib/embeddings";

export const runtime = "nodejs";

// Embed the inquiry text so it lands in the vector store (best-effort, bounded).
async function embedInquiry(text: string): Promise<string | null> {
  try {
    const v = await Promise.race([
      embed(text),
      new Promise<number[]>((_, rej) => setTimeout(() => rej(new Error("embed timeout")), 8000))
    ]);
    return `[${(v as number[]).join(",")}]`;
  } catch (e) {
    console.warn("[contact] embed skipped:", e);
    return null;
  }
}

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

  const { name, email, company, message, locale, page, sessionId } = result.data;
  const literal = await embedInquiry([company, message].filter(Boolean).join(" — "));
  try {
    await pool.query(
      `INSERT INTO contact_messages (name, email, company, message, locale, page, ip_hash, session_id, embedding)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9::vector)`,
      [name, email, company, message, locale, page, hashIp(ip), sessionId, literal]
    );
  } catch (err) {
    console.error("[contact] insert failed:", err);
    // Retry without the embedding (e.g. column/model unavailable) so leads are never lost.
    try {
      await pool.query(
        `INSERT INTO contact_messages (name, email, company, message, locale, page, ip_hash, session_id)
         VALUES ($1,$2,$3,$4,$5,$6,$7,$8)`,
        [name, email, company, message, locale, page, hashIp(ip), sessionId]
      );
    } catch (err2) {
      console.error("[contact] insert failed (fallback):", err2);
      return NextResponse.json({ ok: false, errors: { _: "server" } }, { status: 500 });
    }
  }

  return NextResponse.json({ ok: true });
}
