import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { scheduleNewsletter, NewsletterStateError } from "@/lib/newsletter";

export const dynamic = "force-dynamic";

// Store a scheduled time (status -> scheduled). A cron/worker to fire scheduled
// sends is out of scope; the admin can still send manually from the list.
export async function POST(req: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const id = Number((await params).id);
  if (!Number.isInteger(id) || id <= 0) return NextResponse.json({ error: "Invalid newsletter id" }, { status: 400 });
  const b = (await req.json().catch(() => ({}))) as Record<string, unknown>;
  const raw = typeof b.scheduledAt === "string" ? b.scheduledAt : "";
  const when = new Date(raw);
  if (!raw || Number.isNaN(when.getTime())) return NextResponse.json({ error: "A valid scheduled time is required" }, { status: 400 });
  if (when.getTime() <= Date.now()) return NextResponse.json({ error: "The scheduled time must be in the future" }, { status: 400 });
  try {
    const updated = await scheduleNewsletter(id, when);
    if (!updated) return NextResponse.json({ error: "Newsletter not found" }, { status: 404 });
    return NextResponse.json(updated);
  } catch (err) {
    if (err instanceof NewsletterStateError) return NextResponse.json({ error: err.message }, { status: 400 });
    throw err;
  }
}
