import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import {
  applyAffiliateLinks,
  AffiliatePageNotFoundError,
  type AffiliateSelection,
} from "@/lib/affiliate";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// AI Link Insertion: apply admin-approved keyword suggestions to a page's
// body. Ported from the source (Celestial-Agent-Nexus: adminAffiliate.ts
// POST /admin/affiliate/apply). Zero-loss: applyAffiliateLinks snapshots the
// page's current body into page_versions BEFORE the UPDATE (see
// src/lib/affiliate.ts), and queues a reindex since content changed.
export async function POST(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });

  const b = (await req.json().catch(() => ({}))) as {
    slug?: string;
    locale?: string;
    selections?: unknown;
  };
  const slug = typeof b.slug === "string" ? b.slug.trim() : "";
  const locale = typeof b.locale === "string" ? b.locale.trim() : "";
  if (!slug || !locale)
    return NextResponse.json({ error: "slug and locale are required" }, { status: 400 });

  const selections = normalizeSelections(b.selections);
  if (selections.length === 0)
    return NextResponse.json({ error: "At least one selection is required" }, { status: 400 });

  try {
    const inserted = await applyAffiliateLinks(slug, locale, selections);
    return NextResponse.json({ ok: true, inserted });
  } catch (err) {
    if (err instanceof AffiliatePageNotFoundError)
      return NextResponse.json({ error: err.message }, { status: 404 });
    console.error("[admin/affiliate/apply] failed:", err);
    return NextResponse.json({ error: "Could not apply links" }, { status: 500 });
  }
}

function normalizeSelections(raw: unknown): AffiliateSelection[] {
  if (!Array.isArray(raw)) return [];
  const out: AffiliateSelection[] = [];
  for (const s of raw) {
    if (!s || typeof s !== "object") continue;
    const rec = s as { affiliateLinkId?: unknown; keyword?: unknown; occurrenceIndex?: unknown };
    const affiliateLinkId = Number(rec.affiliateLinkId);
    const keyword = typeof rec.keyword === "string" ? rec.keyword : "";
    const occurrenceIndex = Number(rec.occurrenceIndex);
    if (!Number.isInteger(affiliateLinkId) || affiliateLinkId <= 0) continue;
    if (!keyword) continue;
    if (!Number.isInteger(occurrenceIndex) || occurrenceIndex < 0) continue;
    out.push({ affiliateLinkId, keyword, occurrenceIndex });
  }
  return out;
}
