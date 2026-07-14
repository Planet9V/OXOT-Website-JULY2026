import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import {
  getIntegrationsMasked,
  saveIntegrationSettings,
  type IntegrationSettingKey
} from "@/lib/integration-settings";

export const dynamic = "force-dynamic";

// Current integration settings — all secrets masked, never leaked to the client.
export async function GET() {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  return NextResponse.json(await getIntegrationsMasked());
}

// Save settings. Only fields present in the body are changed. For secret fields
// (smtp password, LinkedIn/X tokens): omit or send "" to keep the stored value,
// send a value to replace it. Booleans are sent as real booleans and stored as
// "true"/"false".
export async function PUT(req: NextRequest) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const b = (await req.json().catch(() => ({}))) as Record<string, unknown>;

  // camelCase body field -> snake_case app_settings key
  const strMap: Record<string, IntegrationSettingKey> = {
    smtpFromName: "smtp_from_name",
    smtpFromEmail: "smtp_from_email",
    smtpHost: "smtp_host",
    smtpPort: "smtp_port",
    smtpUsername: "smtp_username",
    smtpPassword: "smtp_password",
    smtpAlertEmail: "smtp_alert_email",
    linkedinAccessToken: "linkedin_access_token",
    linkedinAuthorUrn: "linkedin_author_urn",
    xApiKey: "x_api_key",
    xApiSecret: "x_api_secret",
    xAccessToken: "x_access_token",
    xAccessSecret: "x_access_secret",
    xUsername: "x_username"
  };
  const boolMap: Record<string, IntegrationSettingKey> = {
    emailEnabled: "email_enabled",
    smtpSecure: "smtp_secure",
    linkedinEnabled: "linkedin_enabled",
    linkedinAutoPublish: "linkedin_auto_publish",
    xEnabled: "x_enabled",
    xAutoPublish: "x_auto_publish"
  };

  const patch: Partial<Record<IntegrationSettingKey, string>> = {};
  for (const [field, key] of Object.entries(strMap)) {
    if (typeof b[field] === "string") patch[key] = (b[field] as string).trim();
  }
  for (const [field, key] of Object.entries(boolMap)) {
    if (typeof b[field] === "boolean") patch[key] = b[field] ? "true" : "false";
  }

  try {
    await saveIntegrationSettings(patch);
  } catch (e) {
    return NextResponse.json({ error: e instanceof Error ? e.message : "save failed" }, { status: 400 });
  }
  return NextResponse.json(await getIntegrationsMasked());
}
