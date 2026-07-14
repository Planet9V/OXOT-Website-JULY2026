import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { isLocale } from "@/i18n/config";
import {
  getConformityHomeForEdit,
  saveConformityHome,
  type ConformityHome
} from "@/lib/conformity-home";

export const runtime = "nodejs";

// Load the editable conformity-home content for both locales (stored row or defaults).
export async function GET() {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const [en, nl] = await Promise.all([
    getConformityHomeForEdit("en"),
    getConformityHomeForEdit("nl")
  ]);
  return NextResponse.json({ en, nl });
}

// Save one locale's conformity-home content.
export async function PUT(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const body = (await req.json().catch(() => ({}))) as {
    locale?: string;
    data?: ConformityHome;
  };
  if (!body.locale || !isLocale(body.locale) || !body.data?.hero || !body.data?.featureGrid) {
    return NextResponse.json(
      { error: "locale + data{hero,featureGrid,…} required" },
      { status: 400 }
    );
  }
  try {
    await saveConformityHome(body.locale, body.data);
  } catch (e) {
    console.error("[conformity-home] save failed:", e);
    return NextResponse.json({ error: "save failed" }, { status: 500 });
  }
  return NextResponse.json(body.data);
}
