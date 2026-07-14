import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { listNewsletters, createNewsletter } from "@/lib/newsletter";

export const dynamic = "force-dynamic";

// List all newsletter campaigns (with denormalised counts + opened count).
export async function GET() {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  return NextResponse.json(await listNewsletters());
}

// Create a draft newsletter.
export async function POST(req: NextRequest) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const b = (await req.json().catch(() => ({}))) as Record<string, unknown>;
  const subject = typeof b.subject === "string" ? b.subject.trim() : "";
  const contentMarkdown = typeof b.contentMarkdown === "string" ? b.contentMarkdown : "";
  if (!subject) return NextResponse.json({ error: "A subject is required" }, { status: 400 });
  const created = await createNewsletter({
    subject,
    preheader: typeof b.preheader === "string" ? b.preheader.trim() || null : null,
    contentMarkdown,
    topic: typeof b.topic === "string" ? b.topic.trim() || null : null,
    locale: b.locale === "nl" ? "nl" : "en"
  });
  return NextResponse.json(created);
}
