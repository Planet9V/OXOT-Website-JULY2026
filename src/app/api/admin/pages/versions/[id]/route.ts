import { NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { getVersion } from "@/lib/page-versions";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// Full content of a single version, for preview.
export async function GET(_req: Request, { params }: { params: Promise<{ id: string }> }) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });

  const { id } = await params;
  const versionId = Number(id);
  if (!Number.isInteger(versionId))
    return NextResponse.json({ error: "invalid version id" }, { status: 400 });

  const version = await getVersion(versionId);
  if (!version) return NextResponse.json({ error: "not found" }, { status: 404 });
  return NextResponse.json({ version });
}
