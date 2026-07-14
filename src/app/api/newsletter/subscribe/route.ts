import { NextRequest, NextResponse } from "next/server";
import { subscribe, isValidEmail } from "@/lib/newsletter";
import { rateLimit, clientIp, tooMany } from "@/lib/rate-limit";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// Double opt-in: create a pending subscriber with confirm/unsubscribe tokens and
// send a confirmation email linking to /api/newsletter/confirm?token=…. Tolerant:
// a dup/confirmed email is a no-op that returns the same generic success, and any
// error still returns ok so a subscribe attempt never surfaces an error or leaks
// whether the address already existed.
export async function POST(req: NextRequest) {
  // Tight cap: subscribe triggers an outbound email, so throttle hard per IP.
  const rl = rateLimit(`subscribe:${clientIp(req)}`, 5, 60_000);
  if (!rl.ok) return tooMany(rl.retryAfter);

  const body = await req.json().catch(() => ({}));
  const email = typeof body?.email === "string" ? body.email.trim().toLowerCase() : "";
  const locale = typeof body?.locale === "string" ? body.locale : null;
  const source = typeof body?.source === "string" ? body.source : "footer";

  if (!email || email.length > 320 || !isValidEmail(email)) {
    return NextResponse.json({ ok: false, error: "invalid_email" }, { status: 400 });
  }

  // Honeypot: a hidden `website` field means a bot filled the form. Silently
  // accept (no email sent) so the bot can't tell it was detected.
  if (typeof body?.website === "string" && body.website.trim() !== "") {
    return NextResponse.json({ ok: true });
  }

  try {
    await subscribe({ email, locale, source, baseUrl: req.nextUrl.origin });
  } catch (err) {
    console.error("[newsletter] subscribe failed:", err);
    // Never 500 a subscribe attempt.
    return NextResponse.json({ ok: true });
  }

  return NextResponse.json({ ok: true });
}
