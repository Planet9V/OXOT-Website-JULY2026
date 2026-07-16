import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { isLocale } from "@/i18n/config";
import { getCdtForEdit, saveCdt, type CDT } from "@/lib/cdt";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// Load the editable cdt (Cyber Digital Twin) content for both locales (stored row or defaults).
export async function GET() {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const [en, nl] = await Promise.all([getCdtForEdit("en"), getCdtForEdit("nl")]);
  return NextResponse.json({ en, nl });
}

// Save one locale's cdt content.
export async function PUT(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const body = (await req.json().catch(() => ({}))) as {
    locale?: string;
    data?: CDT;
  };
  if (!body.locale || !isLocale(body.locale) || !body.data?.hero || !body.data?.priority) {
    return NextResponse.json(
      { error: "locale + data{hero,priority,…} required" },
      { status: 400 }
    );
  }
  try {
    await saveCdt(body.locale, body.data);
  } catch (e) {
    console.error("[cdt] save failed:", e);
    return NextResponse.json({ error: "save failed" }, { status: 500 });
  }
  return NextResponse.json(body.data);
}
