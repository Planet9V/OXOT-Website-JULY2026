import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { getEmailConfig } from "@/lib/integration-settings";

export const dynamic = "force-dynamic";

// Sends a short test email using the saved SMTP config. Never leaks the password.
export async function POST(req: NextRequest) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });

  const body = (await req.json().catch(() => ({}))) as { to?: unknown };
  const to = typeof body.to === "string" ? body.to.trim() : "";
  if (!to) return NextResponse.json({ ok: false, error: "Recipient address required" }, { status: 400 });

  const cfg = await getEmailConfig();
  if (!cfg.host || !cfg.username || !cfg.password) {
    return NextResponse.json({ ok: false, error: "SMTP not configured" }, { status: 400 });
  }

  try {
    // Imported lazily and type-safely so the route only pulls nodemailer when hit.
    const nodemailer = (await import("nodemailer")).default;
    const transport = nodemailer.createTransport({
      host: cfg.host,
      port: cfg.port,
      secure: cfg.secure,
      auth: { user: cfg.username, pass: cfg.password }
    });

    const fromEmail = cfg.fromEmail || cfg.username;
    const from = cfg.fromName ? `"${cfg.fromName}" <${fromEmail}>` : fromEmail;

    await transport.sendMail({
      from,
      to,
      subject: "OXOT test email",
      text: "This is a test email from the OXOT admin console. If you received this, your SMTP settings work.",
      html: "<p>This is a test email from the OXOT admin console.</p><p>If you received this, your SMTP settings work.</p>"
    });

    return NextResponse.json({ ok: true });
  } catch (e) {
    // Surface a message but never the password.
    return NextResponse.json({ ok: false, error: e instanceof Error ? e.message : "send failed" }, { status: 500 });
  }
}
