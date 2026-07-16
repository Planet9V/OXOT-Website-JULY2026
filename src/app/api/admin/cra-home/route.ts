import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { isLocale } from "@/i18n/config";
import { getCraHomeForEdit, saveCraHome, type CraHome } from "@/lib/cra-home";

export const runtime = "nodejs";

// Load the editable cra-home content for both locales (stored row or defaults).
export async function GET() {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const [en, nl] = await Promise.all([getCraHomeForEdit("en"), getCraHomeForEdit("nl")]);
  return NextResponse.json({ en, nl });
}

// Save one locale's cra-home content.
export async function PUT(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const body = (await req.json().catch(() => ({}))) as {
    locale?: string;
    data?: CraHome;
  };
  if (!body.locale || !isLocale(body.locale) || !body.data?.hero || !body.data?.departureBoard) {
    return NextResponse.json(
      { error: "locale + data{hero,departureBoard,…} required" },
      { status: 400 }
    );
  }
  try {
    await saveCraHome(body.locale, body.data);
  } catch (e) {
    console.error("[cra-home] save failed:", e);
    return NextResponse.json({ error: "save failed" }, { status: 500 });
  }
  return NextResponse.json(body.data);
}
