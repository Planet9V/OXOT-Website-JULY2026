import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { isLocale } from "@/i18n/config";
import { getHomeContentForEdit, saveHomeContent, type HomeContent } from "@/lib/site-content";

export const runtime = "nodejs";

// Load the editable homepage content for both locales (stored row or defaults).
export async function GET() {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const [en, nl] = await Promise.all([getHomeContentForEdit("en"), getHomeContentForEdit("nl")]);
  return NextResponse.json({ en, nl });
}

// Save one locale's homepage content.
export async function POST(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const body = (await req.json().catch(() => ({}))) as { locale?: string; data?: HomeContent };
  if (!body.locale || !isLocale(body.locale) || !body.data?.hero || !body.data?.services) {
    return NextResponse.json({ error: "locale + data{hero,services} required" }, { status: 400 });
  }
  try {
    await saveHomeContent(body.locale, body.data);
  } catch (e) {
    console.error("[site-content] save failed:", e);
    return NextResponse.json({ error: "save failed" }, { status: 500 });
  }
  return NextResponse.json({ ok: true });
}
