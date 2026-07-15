import { NextRequest, NextResponse } from "next/server";
import { unsubscribe } from "@/lib/newsletter";
import { isLocale, defaultLocale } from "@/i18n/config";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// One-click unsubscribe: GET ?token=… moves the subscriber to unsubscribed,
// then redirects to an on-brand result page. Token verification logic is
// unchanged; only the response is now a redirect.
export async function GET(req: NextRequest) {
  const token = req.nextUrl.searchParams.get("token") ?? "";
  const ok = token ? await unsubscribe(token) : false;
  const localeParam = req.nextUrl.searchParams.get("locale") ?? "";
  const locale = isLocale(localeParam) ? localeParam : defaultLocale;
  const dest = ok ? "unsubscribed" : "invalid";
  return NextResponse.redirect(new URL(`/${locale}/newsletter/${dest}`, req.nextUrl));
}
