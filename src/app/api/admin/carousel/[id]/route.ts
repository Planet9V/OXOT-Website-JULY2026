import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { getAdminSession } from "@/lib/auth";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// Update / delete a single hero carousel slide. Ported from the source
// PUT/DELETE /admin/carousel/:id (Celestial-Agent-Nexus: adminMedia.ts).
// A field is only touched when present in the body (partial patch), matching the
// source. getAdminSession-guarded.

function parseId(raw: string): number | null {
  const id = Number(raw);
  return Number.isInteger(id) && id > 0 ? id : null;
}

export async function PUT(req: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const id = parseId((await params).id);
  if (id === null) return NextResponse.json({ error: "Invalid slide id" }, { status: 400 });

  const b = (await req.json().catch(() => ({}))) as {
    imagePath?: string; captionEn?: string | null; captionNl?: string | null;
    linkUrl?: string | null; active?: boolean; sortOrder?: number;
  };

  // Build a partial UPDATE from only the fields present in the body.
  const sets: string[] = [];
  const vals: unknown[] = [];
  const add = (col: string, v: unknown) => {
    vals.push(v);
    sets.push(`${col}=$${vals.length}`);
  };
  if (typeof b.imagePath === "string") {
    const p = b.imagePath.trim();
    if (!p) return NextResponse.json({ error: "Image path cannot be empty" }, { status: 400 });
    add("image_path", p);
  }
  if (b.captionEn !== undefined) add("caption_en", (typeof b.captionEn === "string" && b.captionEn.trim()) || null);
  if (b.captionNl !== undefined) add("caption_nl", (typeof b.captionNl === "string" && b.captionNl.trim()) || null);
  if (b.linkUrl !== undefined) add("link_url", (typeof b.linkUrl === "string" && b.linkUrl.trim()) || null);
  if (b.active !== undefined) add("active", b.active === true);
  if (typeof b.sortOrder === "number" && Number.isFinite(b.sortOrder)) add("sort_order", Math.trunc(b.sortOrder));

  if (sets.length === 0) return NextResponse.json({ error: "No fields to update" }, { status: 400 });
  sets.push(`updated_at=now()`);
  vals.push(id);

  try {
    const res = await pool.query(
      `UPDATE carousel_slides SET ${sets.join(", ")} WHERE id=$${vals.length}`,
      vals
    );
    if (res.rowCount === 0)
      return NextResponse.json({ error: "Slide not found" }, { status: 404 });
    return NextResponse.json({ ok: true });
  } catch (err) {
    console.error("[admin/carousel] update failed:", err);
    return NextResponse.json({ error: "Could not update slide" }, { status: 500 });
  }
}

export async function DELETE(_req: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const id = parseId((await params).id);
  if (id === null) return NextResponse.json({ error: "Invalid slide id" }, { status: 400 });
  const res = await pool.query(`DELETE FROM carousel_slides WHERE id=$1`, [id]);
  if (res.rowCount === 0)
    return NextResponse.json({ error: "Slide not found" }, { status: 404 });
  return NextResponse.json({ success: true });
}
