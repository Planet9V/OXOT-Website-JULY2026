import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { isBotUserAgent } from "@/lib/bot-detection";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// Public first-party visitor beacon. No auth. Fired once per public route view
// (page_view) and on tracked link clicks (link_click). Ported from the source
// tracking route (artifacts/api-server/src/routes/tracking.ts): bots/crawlers are
// kept out of the numbers but the request is always acked so a tracking failure
// never surfaces to the visitor.
export async function POST(req: NextRequest) {
  let body: Record<string, unknown>;
  try {
    body = (await req.json()) as Record<string, unknown>;
  } catch {
    // Malformed payload: ack anyway, record nothing.
    return NextResponse.json({ ok: true });
  }

  // Keep bots/crawlers out of visitor analytics: skip recording but still ack.
  if (isBotUserAgent(req.headers.get("user-agent"))) {
    return NextResponse.json({ ok: true });
  }

  const str = (v: unknown): string | null =>
    typeof v === "string" && v.trim() !== "" ? v.trim() : null;

  const type = typeof body.type === "string" ? body.type : "page_view";

  try {
    if (type === "link_click") {
      const href = str(body.href);
      if (!href) return NextResponse.json({ ok: true });
      const kindRaw = str(body.kind);
      const kind =
        kindRaw === "internal" || kindRaw === "outbound" || kindRaw === "affiliate"
          ? kindRaw
          : "outbound";
      await pool.query(
        `INSERT INTO link_clicks (href, kind, path, locale, session_id, referrer)
         VALUES ($1, $2, $3, $4, $5, $6)`,
        [href, kind, str(body.path), str(body.locale), str(body.sessionId), str(body.referrer)]
      );
    } else {
      const path = str(body.path);
      if (!path) return NextResponse.json({ ok: true });
      const locale = body.locale === "nl" ? "nl" : "en";
      await pool.query(
        `INSERT INTO page_views (path, locale, session_id, referrer, device)
         VALUES ($1, $2, $3, $4, $5)`,
        [path, locale, str(body.sessionId), str(body.referrer), str(body.device)]
      );
    }
  } catch (err) {
    // Always ack so a tracking failure never surfaces to the visitor.
    console.error("[track] failed to record event:", err);
  }

  return NextResponse.json({ ok: true });
}
