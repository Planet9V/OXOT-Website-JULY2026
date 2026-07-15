import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { restoreVersion } from "@/lib/page-versions";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// Restore a page to a prior version. Zero-loss: restoreVersion() snapshots
// the current pages row before overwriting it, in one transaction.
export async function POST(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });

  const b = (await req.json().catch(() => ({}))) as {
    slug?: string; locale?: string; versionId?: number;
  };
  const versionId = Number(b.versionId);
  if (!b.slug || !b.locale || !Number.isInteger(versionId))
    return NextResponse.json({ error: "slug, locale, versionId required" }, { status: 400 });

  const result = await restoreVersion(b.slug, b.locale, versionId);
  if (!result.ok) return NextResponse.json({ error: result.error }, { status: 400 });
  return NextResponse.json({ ok: true });
}
