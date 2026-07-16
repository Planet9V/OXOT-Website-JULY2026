import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { getIntakeSettingsMasked, saveIntakeSettings, type IntakeSettingKey } from "@/lib/intake-settings";

export const dynamic = "force-dynamic";

// Current CRA intake settings. Nothing here is a secret (see intake-settings.ts).
export async function GET() {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  return NextResponse.json(await getIntakeSettingsMasked());
}

export async function PUT(req: NextRequest) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const b = (await req.json().catch(() => ({}))) as Record<string, unknown>;

  const patch: Partial<Record<IntakeSettingKey, string>> = {};

  if (typeof b.schedulingUrl === "string") patch.intake_scheduling_url = b.schedulingUrl.trim();
  if (typeof b.notifyEmail === "string") patch.intake_notify_email = b.notifyEmail.trim();

  if (b.schedulingProvider !== undefined) {
    if (b.schedulingProvider !== "none" && b.schedulingProvider !== "calcom" && b.schedulingProvider !== "calendly") {
      return NextResponse.json({ error: "schedulingProvider must be one of: none, calcom, calendly" }, { status: 400 });
    }
    patch.intake_scheduling_provider = b.schedulingProvider;
  }

  if (typeof b.segmentEmailAutosend === "boolean") {
    patch.intake_segment_email_autosend = b.segmentEmailAutosend ? "true" : "false";
  }

  if (b.segmentPdfMap !== undefined) {
    if (typeof b.segmentPdfMap !== "object" || b.segmentPdfMap === null || Array.isArray(b.segmentPdfMap)) {
      return NextResponse.json({ error: "segmentPdfMap must be an object" }, { status: 400 });
    }
    patch.intake_segment_pdf_map = JSON.stringify(b.segmentPdfMap);
  }

  try {
    await saveIntakeSettings(patch);
  } catch (e) {
    return NextResponse.json({ error: e instanceof Error ? e.message : "save failed" }, { status: 400 });
  }

  return NextResponse.json(await getIntakeSettingsMasked());
}
