import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { listVersions } from "@/lib/page-versions";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// List version history (newest-first) for a page.
export async function GET(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });

  const { searchParams } = new URL(req.url);
  const slug = searchParams.get("slug");
  const locale = searchParams.get("locale");
  if (!slug || !locale)
    return NextResponse.json({ error: "slug & locale required" }, { status: 400 });

  const versions = await listVersions(slug, locale);
  return NextResponse.json({ versions });
}
