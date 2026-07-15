import { NextRequest, NextResponse } from "next/server";
import { runDueScheduledSends } from "@/lib/newsletter";
import { getLinkedInConfig, getAlertRecipient } from "@/lib/integration-settings";
import { sendEmail } from "@/lib/mailer";
import { recordIntegrationEvent } from "@/lib/integration-observability";
import { pool } from "@/lib/db";

export const dynamic = "force-dynamic";

/**
 * Single scheduled-work endpoint, hit by an external scheduler (Railway Cron
 * — add a cron job that runs e.g. every 5 minutes and calls
 * `POST /api/cron?key=$CRON_SECRET` or sends header `x-cron-secret`). Runs:
 *   1. Due scheduled-newsletter sends (status='scheduled' AND scheduled_at<=now()).
 *   2. A best-effort check for a LinkedIn token expiring within 7 days, emailing
 *      the configured alert recipient (throttled to once per 24h).
 * Guarded by CRON_SECRET so this can't be triggered by an arbitrary request.
 */
function isAuthorized(req: NextRequest): boolean {
  const secret = process.env.CRON_SECRET;
  if (!secret) return false; // no secret configured -> cron is disabled, not "open"
  const headerKey = req.headers.get("x-cron-secret");
  const queryKey = req.nextUrl.searchParams.get("key");
  return headerKey === secret || queryKey === secret;
}

const WARNING_WINDOW_DAYS = 7;

export async function POST(req: NextRequest) {
  if (!isAuthorized(req)) return NextResponse.json({ error: "unauthorized" }, { status: 401 });

  const baseUrl = req.nextUrl.origin;
  const scheduled = await runDueScheduledSends(baseUrl);

  const expiryWarning: { warned: boolean; daysLeft: number | null } = { warned: false, daysLeft: null };
  try {
    const cfg = await getLinkedInConfig();
    if (cfg.enabled && cfg.accessToken && cfg.tokenExpiresAt) {
      const daysLeft = Math.floor((cfg.tokenExpiresAt - Date.now()) / (1000 * 60 * 60 * 24));
      expiryWarning.daysLeft = daysLeft;
      if (daysLeft <= WARNING_WINDOW_DAYS) {
        const { rows } = await pool.query<{ id: number }>(
          `SELECT id FROM integration_events
            WHERE integration = 'linkedin' AND kind = 'token_warning'
              AND created_at >= now() - interval '24 hours'
            LIMIT 1`
        );
        if (rows.length === 0) {
          const to = await getAlertRecipient();
          if (to) {
            const message =
              daysLeft < 0
                ? "Your LinkedIn access token has expired. Reconnect it from the admin Integrations page."
                : `Your LinkedIn access token expires in ${daysLeft} day(s). Reconnect it from the admin Integrations page to keep auto-publishing working.`;
            await sendEmail({
              to,
              subject: "OXOT: LinkedIn connection needs attention",
              html: `<p>${message}</p>`,
              text: message
            });
          }
          await recordIntegrationEvent({
            integration: "linkedin",
            kind: "token_warning",
            success: true,
            detail: `Token expires in ${daysLeft} day(s)`
          });
          expiryWarning.warned = true;
        }
      }
    }
  } catch (err) {
    console.error("[cron] LinkedIn expiry check failed:", err);
  }

  return NextResponse.json({ ok: true, scheduledSends: scheduled, linkedinExpiryWarning: expiryWarning });
}

// Some cron providers only support GET.
export async function GET(req: NextRequest) {
  return POST(req);
}
