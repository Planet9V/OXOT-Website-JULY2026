import { NextRequest, NextResponse } from "next/server";
import { confirmSubscription } from "@/lib/newsletter";
import { isLocale, defaultLocale } from "@/i18n/config";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// Double opt-in confirmation: GET ?token=… flips the subscriber to confirmed and
// records consent (timestamp + IP), then redirects to an on-brand result page.
// Token verification logic is unchanged; only the response is now a redirect.
export async function GET(req: NextRequest) {
  const token = req.nextUrl.searchParams.get("token") ?? "";
  const ip = req.headers.get("x-forwarded-for")?.split(",")[0]?.trim() || null;
  const ok = token ? await confirmSubscription(token, ip) : false;
  const localeParam = req.nextUrl.searchParams.get("locale") ?? "";
  const locale = isLocale(localeParam) ? localeParam : defaultLocale;
  const dest = ok ? "confirmed" : "invalid";
  return NextResponse.redirect(new URL(`/${locale}/newsletter/${dest}`, req.nextUrl));
}
