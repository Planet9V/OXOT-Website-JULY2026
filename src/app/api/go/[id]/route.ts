import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { isBotUserAgent } from "@/lib/bot-detection";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// Public affiliate click tracker + redirect. Ported from the source tracking
// route (Celestial-Agent-Nexus: artifacts/api-server/src/routes/tracking.ts
// GET /go/:id + lib/affiliate.ts recordClick). No auth.
//
// Looks up the affiliate link by id, records a link_clicks row (kind='affiliate',
// affiliate_link_id set) and 302-redirects to target_url. Bots/crawlers (incl.
// social unfurlers) are still redirected but NOT counted as human clicks. Any
// unknown/invalid/inactive link falls back to a redirect home so a bad link never
// dead-ends the visitor.
export async function GET(req: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  const home = new URL("/", req.url);
  const { id: rawId } = await params;
  const id = Number(rawId);
  if (!Number.isInteger(id) || id <= 0) {
    return NextResponse.redirect(home, 302);
  }

  // Referrer (the page the link was clicked from) — capture the path for analytics.
  const referer = req.headers.get("referer");
  let path: string | null = null;
  if (referer) {
    try {
      path = new URL(referer).pathname;
    } catch {
      path = null;
    }
  }
  const locale = path?.startsWith("/nl") ? "nl" : path?.startsWith("/en") ? "en" : null;
  const skipRecording = isBotUserAgent(req.headers.get("user-agent"));

  try {
    const { rows } = await pool.query(
      `SELECT id, target_url FROM affiliate_links WHERE id=$1 AND active=true LIMIT 1`,
      [id]
    );
    const link = rows[0];
    if (!link) return NextResponse.redirect(home, 302);

    if (!skipRecording) {
      await pool.query(
        `INSERT INTO link_clicks (href, kind, path, locale, referrer, affiliate_link_id)
         VALUES ($1, 'affiliate', $2, $3, $4, $5)`,
        [link.target_url, path, locale, referer, link.id]
      );
    }
    return NextResponse.redirect(new URL(link.target_url), 302);
  } catch (err) {
    console.error("[go] failed to record affiliate click:", err);
    return NextResponse.redirect(home, 302);
  }
}
