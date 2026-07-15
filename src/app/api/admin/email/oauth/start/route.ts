import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { getEmailConfig } from "@/lib/integration-settings";
import { signOAuthState, getGmailRedirectUri } from "@/lib/oauth-state";

export const dynamic = "force-dynamic";

const ADMIN_URL = "/admin";
function adminRedirect(origin: string, flag: string): string {
  return new URL(`${ADMIN_URL}?email=${flag}`, origin).toString();
}

// Begin the Gmail "Connect Google" flow: redirect the admin's browser to
// Google's consent screen. access_type=offline + prompt=consent guarantee a
// refresh_token comes back on the callback (Google only issues one on the
// first consent, or every time prompt=consent is forced).
export async function GET(req: NextRequest) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const cfg = await getEmailConfig();
  if (!cfg.oauthClientId) {
    return NextResponse.redirect(adminRedirect(req.nextUrl.origin, "missing_client"));
  }
  const state = signOAuthState();
  const params = new URLSearchParams({
    response_type: "code",
    client_id: cfg.oauthClientId,
    redirect_uri: getGmailRedirectUri(req.nextUrl.origin),
    scope: "https://mail.google.com/",
    access_type: "offline",
    prompt: "consent",
    state
  });
  return NextResponse.redirect(`https://accounts.google.com/o/oauth2/v2/auth?${params.toString()}`);
}
