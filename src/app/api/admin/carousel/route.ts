import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { getAdminSession } from "@/lib/auth";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// Admin CRUD for the homepage hero carousel. Ported from the source
// (Celestial-Agent-Nexus: artifacts/api-server/src/routes/adminMedia.ts —
// /admin/carousel list + create). Adapted to Next.js App Router + raw pg and
// getAdminSession-guarded. This app supplies image paths/URLs directly (public
// paths like /hero/en/slide-1.png or media library URLs) rather than the source's
// upload pipeline, so create takes image_path instead of an uploaded objectPath.

// Row shape returned to the admin manager. imageUrl mirrors image_path because
// carousel slides here reference directly-servable public paths/URLs.
function toSlideDto(r: Record<string, unknown>) {
  return {
    id: Number(r.id),
    sortOrder: Number(r.sort_order),
    kind: r.kind as string,
    imagePath: r.image_path as string,
    imageUrl: r.image_path as string,
    groupId: (r.group_id as string | null) ?? null,
    pageIndex: r.page_index === null || r.page_index === undefined ? null : Number(r.page_index),
    captionEn: (r.caption_en as string | null) ?? null,
    captionNl: (r.caption_nl as string | null) ?? null,
    linkUrl: (r.link_url as string | null) ?? null,
    active: Boolean(r.active),
  };
}

export async function listCarouselSlides() {
  const { rows } = await pool.query(
    `SELECT id, sort_order, kind, image_path, group_id, page_index,
            caption_en, caption_nl, link_url, active
       FROM carousel_slides
      ORDER BY sort_order ASC, id ASC`
  );
  return rows.map(toSlideDto);
}

export async function GET() {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  return NextResponse.json({ slides: await listCarouselSlides() });
}

export async function POST(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const b = (await req.json().catch(() => ({}))) as {
    imagePath?: string; kind?: string; captionEn?: string | null; captionNl?: string | null;
    linkUrl?: string | null; active?: boolean; sortOrder?: number;
  };
  const imagePath = typeof b.imagePath === "string" ? b.imagePath.trim() : "";
  if (!imagePath)
    return NextResponse.json({ error: "Image path or URL is required" }, { status: 400 });
  const kind = b.kind === "pdf" ? "pdf" : "image";

  // Default sort_order to the end of the list (max + 1), matching the source's
  // nextSortOrder() behavior, unless an explicit value is provided.
  let sortOrder = typeof b.sortOrder === "number" && Number.isFinite(b.sortOrder) ? Math.trunc(b.sortOrder) : null;
  if (sortOrder === null) {
    const { rows } = await pool.query(`SELECT COALESCE(MAX(sort_order), -1) + 1 AS next FROM carousel_slides`);
    sortOrder = Number(rows[0].next);
  }

  try {
    const { rows } = await pool.query(
      `INSERT INTO carousel_slides (sort_order, kind, image_path, caption_en, caption_nl, link_url, active)
       VALUES ($1,$2,$3,$4,$5,$6,$7)
       RETURNING id, sort_order, kind, image_path, group_id, page_index, caption_en, caption_nl, link_url, active`,
      [
        sortOrder, kind, imagePath,
        (typeof b.captionEn === "string" && b.captionEn.trim()) || null,
        (typeof b.captionNl === "string" && b.captionNl.trim()) || null,
        (typeof b.linkUrl === "string" && b.linkUrl.trim()) || null,
        b.active !== false,
      ]
    );
    return NextResponse.json({ ok: true, slide: toSlideDto(rows[0]) });
  } catch (err) {
    console.error("[admin/carousel] create failed:", err);
    return NextResponse.json({ error: "Could not create slide" }, { status: 500 });
  }
}
