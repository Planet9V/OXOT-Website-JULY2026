import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { getLinkedinRedirectUri } from "@/lib/social";

export const dynamic = "force-dynamic";

// The exact redirect URI the admin must whitelist in their LinkedIn OAuth app
// (LinkedIn > Auth > OAuth 2.0 settings > Authorized redirect URLs).
export async function GET(req: NextRequest) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  return NextResponse.json({ redirectUri: getLinkedinRedirectUri(req.nextUrl.origin) });
}
