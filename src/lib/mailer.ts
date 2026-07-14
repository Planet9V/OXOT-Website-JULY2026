import nodemailer, { type Transporter } from "nodemailer";
import { getEmailConfig, type EmailConfig } from "@/lib/integration-settings";

/**
 * Email-sending seam. Delivery uses SMTP credentials configured by the admin in
 * the admin console (stored in app_settings, secrets encrypted at rest). Until
 * email is enabled and configured, sends are a graceful no-op so the rest of the
 * newsletter system works end-to-end without a provider.
 *
 * Ported from Celestial-Agent-Nexus/artifacts/api-server/src/lib/mailer.ts,
 * adapted to this app's getEmailConfig() field names (host/port/username/
 * password/secure instead of smtpHost/smtpPort/smtpUser/smtpPassword/smtpSecure).
 */

export interface SendEmailParams {
  to: string;
  subject: string;
  html: string;
  text?: string;
  headers?: Record<string, string>;
}

export interface SendEmailResult {
  delivered: boolean;
  error?: string;
}

/** A config is usable only when enabled and the essential SMTP fields are set. */
function isConfigUsable(c: EmailConfig): boolean {
  return Boolean(c.enabled && c.host && c.username && c.password && c.fromEmail);
}

/** Whether email delivery is enabled and fully configured. */
export async function isMailConfigured(): Promise<boolean> {
  const config = await getEmailConfig();
  return isConfigUsable(config);
}

/** From header for outgoing mail, e.g. `OXOT <news@oxot.eu>`. */
function formatFrom(c: EmailConfig): string {
  const email = c.fromEmail ?? "";
  return c.fromName ? `${c.fromName} <${email}>` : email;
}

function buildTransport(c: EmailConfig): Transporter {
  const port = c.port || 587;
  return nodemailer.createTransport({
    host: c.host,
    port,
    // `secure` true = implicit TLS (465); false = STARTTLS (587/25).
    secure: c.secure ?? port === 465,
    auth: { user: c.username, pass: c.password }
  });
}

/** Send a single email. Returns delivered:false (never throws) on any failure. */
export async function sendEmail(params: SendEmailParams): Promise<SendEmailResult> {
  // Everything (config read, transport creation, send) is inside one catch so
  // callers can rely on this never throwing — a DB hiccup must not crash a
  // newsletter batch send.
  try {
    const config = await getEmailConfig();
    if (!isConfigUsable(config)) {
      // Not configured is not a delivery failure per se — surface it but don't
      // treat it as an error the admin must fix.
      return { delivered: false, error: "email not configured" };
    }
    const transport = buildTransport(config);
    await transport.sendMail({
      from: formatFrom(config),
      to: params.to,
      subject: params.subject,
      html: params.html,
      text: params.text,
      headers: params.headers
    });
    return { delivered: true };
  } catch (err) {
    const error = (err instanceof Error ? err.message : "send_failed").slice(0, 300);
    return { delivered: false, error };
  }
}
