import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { getNewsletter, updateNewsletter, deleteNewsletter, NewsletterStateError } from "@/lib/newsletter";

export const dynamic = "force-dynamic";

function parseId(raw: string): number | null {
  const id = Number(raw);
  return Number.isInteger(id) && id > 0 ? id : null;
}

export async function GET(_req: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const id = parseId((await params).id);
  if (id === null) return NextResponse.json({ error: "Invalid newsletter id" }, { status: 400 });
  const row = await getNewsletter(id);
  if (!row) return NextResponse.json({ error: "Newsletter not found" }, { status: 404 });
  return NextResponse.json(row);
}

export async function PUT(req: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const id = parseId((await params).id);
  if (id === null) return NextResponse.json({ error: "Invalid newsletter id" }, { status: 400 });
  const b = (await req.json().catch(() => ({}))) as Record<string, unknown>;
  const subject = typeof b.subject === "string" ? b.subject.trim() : "";
  if (!subject) return NextResponse.json({ error: "A subject is required" }, { status: 400 });
  try {
    const updated = await updateNewsletter(id, {
      subject,
      preheader: typeof b.preheader === "string" ? b.preheader.trim() || null : null,
      contentMarkdown: typeof b.contentMarkdown === "string" ? b.contentMarkdown : "",
      topic: typeof b.topic === "string" ? b.topic.trim() || null : null,
      locale: b.locale === "nl" ? "nl" : "en"
    });
    if (!updated) return NextResponse.json({ error: "Newsletter not found" }, { status: 404 });
    return NextResponse.json(updated);
  } catch (err) {
    if (err instanceof NewsletterStateError) return NextResponse.json({ error: err.message }, { status: 400 });
    throw err;
  }
}

export async function DELETE(_req: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const id = parseId((await params).id);
  if (id === null) return NextResponse.json({ error: "Invalid newsletter id" }, { status: 400 });
  const deleted = await deleteNewsletter(id);
  if (!deleted) return NextResponse.json({ error: "Newsletter not found" }, { status: 404 });
  return NextResponse.json({ success: true });
}
