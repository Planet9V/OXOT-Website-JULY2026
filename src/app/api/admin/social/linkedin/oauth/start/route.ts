import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { getLinkedInConfig } from "@/lib/integration-settings";
import { buildLinkedinAuthUrl } from "@/lib/social";
import { signOAuthState } from "@/lib/oauth-state";

export const dynamic = "force-dynamic";

const ADMIN_URL = "/admin";
function adminRedirect(flag: string): string {
  return `${ADMIN_URL}?linkedin=${flag}`;
}

// Begin the OAuth flow: redirect the admin's browser to LinkedIn's
// authorization page with an HMAC-signed, 10-minute state token (CSRF guard).
export async function GET(req: NextRequest) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const cfg = await getLinkedInConfig();
  if (!cfg.clientId) {
    return NextResponse.redirect(new URL(adminRedirect("missing_client"), req.nextUrl.origin));
  }
  const state = signOAuthState();
  const authUrl = buildLinkedinAuthUrl(req.nextUrl.origin, cfg.clientId, state);
  return NextResponse.redirect(authUrl);
}
