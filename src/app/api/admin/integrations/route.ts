import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import {
  getIntegrationsMasked,
  saveIntegrationSettings,
  type IntegrationSettingKey
} from "@/lib/integration-settings";
import { recordIntegrationEvent, type IntegrationName } from "@/lib/integration-observability";

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
    emailOauthClientId: "email_oauth_client_id",
    emailOauthClientSecret: "email_oauth_client_secret",
    emailOauthUser: "email_oauth_user",
    linkedinAccessToken: "linkedin_access_token",
    linkedinAuthorUrn: "linkedin_author_urn",
    linkedinClientId: "linkedin_client_id",
    linkedinClientSecret: "linkedin_client_secret",
    linkedinProfileUrl: "linkedin_profile_url",
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
  // Enum field: only "password" or "oauth2" are accepted; anything else is ignored.
  if (b.emailAuthType === "password" || b.emailAuthType === "oauth2") {
    patch.email_auth_type = b.emailAuthType;
  }

  try {
    await saveIntegrationSettings(patch);
  } catch (e) {
    return NextResponse.json({ error: e instanceof Error ? e.message : "save failed" }, { status: 400 });
  }

  // Best-effort activity note. Section is inferred from which keys were sent —
  // the admin UI saves one integration's card at a time.
  const keys = Object.keys(patch);
  const integration: IntegrationName | null = keys.some((k) => k.startsWith("smtp_") || k.startsWith("email_"))
    ? "email"
    : keys.some((k) => k.startsWith("linkedin_"))
      ? "linkedin"
      : keys.some((k) => k.startsWith("x_"))
        ? "x"
        : null;
  if (integration) {
    void recordIntegrationEvent({ integration, kind: "config_saved", success: true, detail: null });
  }

  return NextResponse.json(await getIntegrationsMasked());
}
