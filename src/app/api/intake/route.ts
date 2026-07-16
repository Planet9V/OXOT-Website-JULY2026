import { NextRequest, NextResponse } from "next/server";
import { hashIp, checkRateLimit } from "@/lib/contact";
import { validateIntake, insertLead, isSegment } from "@/lib/intake";
import { embed } from "@/lib/embeddings";
import { sendEmail, isMailConfigured } from "@/lib/mailer";
import { email0, segmentEmail } from "@/lib/intake-emails";
import { getIntakeSettings } from "@/lib/intake-settings";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// Embed the inquiry text so it lands in the vector store (best-effort, bounded).
async function embedInquiry(text: string): Promise<string | null> {
  try {
    const v = await Promise.race([
      embed(text),
      new Promise<number[]>((_, rej) => setTimeout(() => rej(new Error("embed timeout")), 8000))
    ]);
    return `[${(v as number[]).join(",")}]`;
  } catch (e) {
    console.warn("[intake] embed skipped:", e);
    return null;
  }
}

function clientIp(req: NextRequest): string | null {
  const xff = req.headers.get("x-forwarded-for");
  if (xff) return xff.split(",")[0].trim();
  return req.headers.get("x-real-ip");
}

// Escape untrusted lead input before interpolating into the internal notify email
// HTML (defence against markup injection into the admin inbox).
function esc(s: string): string {
  return s.replace(/[&<>"']/g, (c) => (
    { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c] as string
  ));
}

// Fire-and-forget the follow-up emails. Never throws, never blocks the response.
function sendFollowUpEmails(leadId: string, data: {
  name: string;
  email: string;
  company: string | null;
  segment: string;
  locale: string;
}): void {
  void (async () => {
    try {
      if (!(await isMailConfigured())) return;

      const settings = await getIntakeSettings();
      const e0 = email0(data.locale, { firstName: data.name, date: new Date() });
      await sendEmail({ to: data.email, subject: e0.subject, html: e0.html, text: e0.text });

      if (settings.notifyEmail) {
        await sendEmail({
          to: settings.notifyEmail,
          subject: `New CRA intake lead: ${data.name} (${data.segment})`,
          html: `<p>New CRA readiness intake lead.</p><ul>
            <li>Name: ${esc(data.name)}</li>
            <li>Email: ${esc(data.email)}</li>
            <li>Company: ${esc(data.company ?? "-")}</li>
            <li>Segment: ${esc(data.segment)}</li>
            <li>Lead ID: ${esc(leadId)}</li>
          </ul>`,
          text: `New CRA readiness intake lead.\nName: ${data.name}\nEmail: ${data.email}\nCompany: ${data.company ?? "-"}\nSegment: ${data.segment}\nLead ID: ${leadId}`
        });
      }

      if (settings.segmentEmailAutosend && isSegment(data.segment)) {
        const seg = segmentEmail(data.segment, data.locale, { firstName: data.name, company: data.company });
        const pdfPath = settings.segmentPdfMap[data.segment];
        const attachments = pdfPath ? [{ filename: `${data.segment}-oxot-cra-guide.pdf`, path: pdfPath }] : undefined;
        await sendEmail({ to: data.email, subject: seg.subject, html: seg.html, text: seg.text, attachments });
      }
    } catch (err) {
      console.error("[intake] follow-up email send failed:", err);
    }
  })();
}

export async function POST(req: NextRequest) {
  const body = await req.json().catch(() => ({}));
  const result = validateIntake(body);

  // Honeypot tripped: pretend success so bots don't learn they were caught.
  if (!result.ok && result.spam) {
    return NextResponse.json({ ok: true });
  }
  if (!result.ok) {
    return NextResponse.json({ ok: false, errors: result.errors }, { status: 400 });
  }

  const ip = clientIp(req);
  if (!checkRateLimit(`intake:${ip ?? "unknown"}`)) {
    return NextResponse.json(
      { ok: false, errors: { _: "rate_limited" } },
      { status: 429 }
    );
  }

  const data = { ...result.data, ipHash: hashIp(ip) };
  const literal = await embedInquiry(
    [data.company, data.segment, data.blocker, JSON.stringify(data.answers)].filter(Boolean).join(" — ")
  );

  let leadId: string;
  try {
    leadId = await insertLead(data, literal);
  } catch (err) {
    console.error("[intake] insert failed:", err);
    return NextResponse.json({ ok: false, errors: { _: "server" } }, { status: 500 });
  }

  sendFollowUpEmails(leadId, {
    name: data.name,
    email: data.email,
    company: data.company,
    segment: data.segment,
    locale: data.locale
  });

  const settings = await getIntakeSettings();
  return NextResponse.json({
    ok: true,
    leadId,
    scheduling: { provider: settings.schedulingProvider, url: settings.schedulingUrl }
  });
}
