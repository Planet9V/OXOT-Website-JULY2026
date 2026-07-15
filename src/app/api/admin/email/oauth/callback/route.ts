import { NextRequest, NextResponse } from "next/server";
import { getEmailConfig, saveIntegrationSettings } from "@/lib/integration-settings";
import { verifyOAuthState, getGmailRedirectUri } from "@/lib/oauth-state";
import { recordIntegrationEvent } from "@/lib/integration-observability";

export const dynamic = "force-dynamic";

const ADMIN_URL = "/admin";
function adminRedirect(origin: string, flag: string): string {
  return new URL(`${ADMIN_URL}?email=${flag}`, origin).toString();
}

// OAuth callback: Google redirects the admin's browser back here with
// ?code&state. NOT session-guarded (Google drives the redirect) — the
// signed+TTL'd `state` is the CSRF guard, verified before any token exchange.
export async function GET(req: NextRequest) {
  const { origin, searchParams } = req.nextUrl;
  const code = searchParams.get("code");
  const state = searchParams.get("state");
  const error = searchParams.get("error");

  if (error) {
    return NextResponse.redirect(adminRedirect(origin, "denied"));
  }
  if (!verifyOAuthState(state)) {
    return NextResponse.redirect(adminRedirect(origin, "bad_state"));
  }
  if (!code) {
    return NextResponse.redirect(adminRedirect(origin, "no_code"));
  }

  const cfg = await getEmailConfig();
  if (!cfg.oauthClientId || !cfg.oauthClientSecret) {
    return NextResponse.redirect(adminRedirect(origin, "missing_client"));
  }

  try {
    const body = new URLSearchParams({
      grant_type: "authorization_code",
      code,
      redirect_uri: getGmailRedirectUri(origin),
      client_id: cfg.oauthClientId,
      client_secret: cfg.oauthClientSecret
    });
    const res = await fetch("https://oauth2.googleapis.com/token", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: body.toString()
    });
    if (!res.ok) {
      const detail = await res.text().catch(() => "");
      throw new Error(`Google token exchange ${res.status}: ${detail}`);
    }
    const json = (await res.json()) as { refresh_token?: string; access_token?: string };
    if (!json.refresh_token) {
      // Google omits refresh_token when the user has already granted consent
      // and prompt=consent wasn't honoured (rare) — surface a clear message
      // rather than silently storing nothing.
      throw new Error(
        "Google did not return a refresh token. Revoke OXOT's access at https://myaccount.google.com/permissions and try connecting again."
      );
    }
    await saveIntegrationSettings({
      email_auth_type: "oauth2",
      email_oauth_refresh_token: json.refresh_token
    });
    await recordIntegrationEvent({
      integration: "email",
      kind: "oauth",
      success: true,
      detail: "Gmail OAuth authorization completed"
    });
    return NextResponse.redirect(adminRedirect(origin, "connected"));
  } catch (err) {
    await recordIntegrationEvent({
      integration: "email",
      kind: "oauth",
      success: false,
      detail: err instanceof Error ? err.message : "token exchange failed"
    });
    return NextResponse.redirect(adminRedirect(origin, "error"));
  }
}
