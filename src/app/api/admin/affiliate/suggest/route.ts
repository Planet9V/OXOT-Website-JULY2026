import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { suggestAffiliateLinks, AffiliatePageNotFoundError } from "@/lib/affiliate";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// AI Link Insertion: deterministic keyword-match suggestions for a page's body.
// Ported from the source (Celestial-Agent-Nexus: adminAffiliate.ts POST
// /admin/affiliate/suggest), adapted to this app's single-body page model —
// see suggestAffiliateLinks in src/lib/affiliate.ts. Read-only.
export async function POST(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });

  const b = (await req.json().catch(() => ({}))) as { slug?: string; locale?: string };
  const slug = typeof b.slug === "string" ? b.slug.trim() : "";
  const locale = typeof b.locale === "string" ? b.locale.trim() : "";
  if (!slug || !locale)
    return NextResponse.json({ error: "slug and locale are required" }, { status: 400 });

  try {
    const suggestions = await suggestAffiliateLinks(slug, locale);
    return NextResponse.json({ suggestions });
  } catch (err) {
    if (err instanceof AffiliatePageNotFoundError)
      return NextResponse.json({ error: err.message }, { status: 404 });
    console.error("[admin/affiliate/suggest] failed:", err);
    return NextResponse.json({ error: "Could not generate suggestions" }, { status: 500 });
  }
}
