import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { sendNewsletterNow, NewsletterStateError } from "@/lib/newsletter";

export const dynamic = "force-dynamic";

// Run the send pipeline now and return the finalised newsletter with counts.
export async function POST(req: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const id = Number((await params).id);
  if (!Number.isInteger(id) || id <= 0) return NextResponse.json({ error: "Invalid newsletter id" }, { status: 400 });
  const baseUrl = req.nextUrl.origin;
  try {
    const updated = await sendNewsletterNow(id, baseUrl);
    if (!updated) return NextResponse.json({ error: "Newsletter not found" }, { status: 404 });
    return NextResponse.json(updated);
  } catch (err) {
    if (err instanceof NewsletterStateError) return NextResponse.json({ error: err.message }, { status: 400 });
    throw err;
  }
}
