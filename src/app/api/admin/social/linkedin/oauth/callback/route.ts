import { NextRequest, NextResponse } from "next/server";
import { getLinkedInConfig, saveIntegrationSettings } from "@/lib/integration-settings";
import { exchangeLinkedinCode } from "@/lib/social";
import { verifyOAuthState } from "@/lib/oauth-state";
import { recordIntegrationEvent } from "@/lib/integration-observability";

export const dynamic = "force-dynamic";

const ADMIN_URL = "/admin";
function adminRedirect(origin: string, flag: string): string {
  return new URL(`${ADMIN_URL}?linkedin=${flag}`, origin).toString();
}

// OAuth callback: LinkedIn redirects the admin's browser back here with
// ?code&state. This route is NOT session-guarded (LinkedIn, not the admin
// browser, drives the redirect) — instead the signed+TTL'd `state` is the CSRF
// guard, verified before any token exchange happens.
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

  const cfg = await getLinkedInConfig();
  if (!cfg.clientId || !cfg.clientSecret) {
    return NextResponse.redirect(adminRedirect(origin, "missing_client"));
  }

  try {
    const token = await exchangeLinkedinCode(origin, code, cfg.clientId, cfg.clientSecret);
    await saveIntegrationSettings({
      linkedin_access_token: token.accessToken,
      linkedin_token_expires_at: token.expiresAt ? String(token.expiresAt) : ""
    });
    await recordIntegrationEvent({
      integration: "linkedin",
      kind: "oauth",
      success: true,
      detail: "OAuth authorization completed"
    });
    return NextResponse.redirect(adminRedirect(origin, "connected"));
  } catch (err) {
    await recordIntegrationEvent({
      integration: "linkedin",
      kind: "oauth",
      success: false,
      detail: err instanceof Error ? err.message : "token exchange failed"
    });
    return NextResponse.redirect(adminRedirect(origin, "error"));
  }
}
