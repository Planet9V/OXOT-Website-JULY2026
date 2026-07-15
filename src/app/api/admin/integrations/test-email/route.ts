import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { getEmailConfig } from "@/lib/integration-settings";
import { recordIntegrationEvent } from "@/lib/integration-observability";

export const dynamic = "force-dynamic";

// Sends a short test email using the saved config (SMTP password or Gmail
// OAuth2, whichever authType is active). Never leaks secrets.
export async function POST(req: NextRequest) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });

  const body = (await req.json().catch(() => ({}))) as { to?: unknown };
  const to = typeof body.to === "string" ? body.to.trim() : "";
  if (!to) return NextResponse.json({ ok: false, error: "Recipient address required" }, { status: 400 });

  const cfg = await getEmailConfig();
  const usable =
    cfg.authType === "oauth2"
      ? Boolean(cfg.oauthClientId && cfg.oauthClientSecret && cfg.oauthRefreshToken && cfg.oauthUser)
      : Boolean(cfg.host && cfg.username && cfg.password);
  if (!usable) {
    return NextResponse.json({ ok: false, error: "Email is not configured" }, { status: 400 });
  }

  try {
    // Imported lazily and type-safely so the route only pulls nodemailer when hit.
    const nodemailer = (await import("nodemailer")).default;
    const transport =
      cfg.authType === "oauth2"
        ? nodemailer.createTransport({
            service: "gmail",
            auth: {
              type: "OAuth2",
              user: cfg.oauthUser,
              clientId: cfg.oauthClientId,
              clientSecret: cfg.oauthClientSecret,
              refreshToken: cfg.oauthRefreshToken
            }
          })
        : nodemailer.createTransport({
            host: cfg.host,
            port: cfg.port,
            secure: cfg.secure,
            auth: { user: cfg.username, pass: cfg.password }
          });

    const fromEmail = cfg.fromEmail || cfg.username || cfg.oauthUser;
    const from = cfg.fromName ? `"${cfg.fromName}" <${fromEmail}>` : fromEmail;

    await transport.sendMail({
      from,
      to,
      subject: "OXOT test email",
      text: "This is a test email from the OXOT admin console. If you received this, your email settings work.",
      html: "<p>This is a test email from the OXOT admin console.</p><p>If you received this, your email settings work.</p>"
    });

    await recordIntegrationEvent({ integration: "email", kind: "test_email", success: true, detail: `Sent to ${to}` });
    return NextResponse.json({ ok: true });
  } catch (e) {
    // Surface a message but never the password/refresh token.
    const error = e instanceof Error ? e.message : "send failed";
    await recordIntegrationEvent({ integration: "email", kind: "test_email", success: false, detail: error });
    return NextResponse.json({ ok: false, error }, { status: 500 });
  }
}
