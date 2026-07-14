import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// Public hero carousel feed. Ported from the source /site/carousel handler
// (Celestial-Agent-Nexus: artifacts/api-server/src/routes/adminMedia.ts). Returns
// ACTIVE slides ordered by sort_order, with the caption resolved for the active
// locale (?locale=nl|en). The hero primarily reads slides server-side via
// getCarouselSlides(); this endpoint exposes the same data to any client caller.
export async function GET(req: NextRequest) {
  const raw = req.nextUrl.searchParams.get("locale");
  const locale = raw === "nl" ? "nl" : "en";
  try {
    const { rows } = await pool.query(
      `SELECT id, image_path, caption_en, caption_nl, link_url, sort_order
         FROM carousel_slides
        WHERE active = true
        ORDER BY sort_order ASC, id ASC`
    );
    const slides = rows.map((r) => ({
      id: Number(r.id),
      src: r.image_path as string,
      caption: ((locale === "nl" ? r.caption_nl : r.caption_en) as string | null) ?? null,
      link: (r.link_url as string | null) ?? null,
    }));
    return NextResponse.json({ slides });
  } catch (err) {
    console.error("[api/carousel] list failed:", err);
    // Never 500 the public feed — an empty list lets the hero fall back to static.
    return NextResponse.json({ slides: [] });
  }
}
