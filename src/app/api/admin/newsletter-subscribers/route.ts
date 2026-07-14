import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { listSubscribers, deleteSubscriber, setSubscriberStatus } from "@/lib/newsletter";

export const dynamic = "force-dynamic";

// List subscribers, optionally filtered by status / email query.
export async function GET(req: NextRequest) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const status = req.nextUrl.searchParams.get("status") ?? undefined;
  const q = req.nextUrl.searchParams.get("q") ?? undefined;
  return NextResponse.json(await listSubscribers({ status: status || undefined, q: q || undefined }));
}

// Delete a subscriber (GDPR erasure) or change its status (e.g. force-unsubscribe).
export async function DELETE(req: NextRequest) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const id = Number(req.nextUrl.searchParams.get("id"));
  if (!Number.isInteger(id) || id <= 0) return NextResponse.json({ error: "Invalid subscriber id" }, { status: 400 });
  const deleted = await deleteSubscriber(id);
  if (!deleted) return NextResponse.json({ error: "Subscriber not found" }, { status: 404 });
  return NextResponse.json({ success: true });
}

export async function PATCH(req: NextRequest) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const b = (await req.json().catch(() => ({}))) as Record<string, unknown>;
  const id = Number(b.id);
  const status = typeof b.status === "string" ? b.status : "";
  if (!Number.isInteger(id) || id <= 0) return NextResponse.json({ error: "Invalid subscriber id" }, { status: 400 });
  if (!["pending", "confirmed", "unsubscribed"].includes(status)) {
    return NextResponse.json({ error: "Invalid status" }, { status: 400 });
  }
  const ok = await setSubscriberStatus(id, status);
  if (!ok) return NextResponse.json({ error: "Subscriber not found" }, { status: 404 });
  return NextResponse.json({ success: true });
}
