import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { getAdminSession } from "@/lib/auth";
import { isLocale } from "@/i18n/config";

export async function GET(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const menuKey = new URL(req.url).searchParams.get("menu") ?? "main";
  const { rows } = await pool.query(
    `SELECT mi.id, mi.locale, mi.label, mi.href, mi.position, mi.parent_id AS "parentId", mi.description
       FROM menu_items mi JOIN menus m ON m.id = mi.menu_id
      WHERE m.key = $1 ORDER BY mi.locale, mi.position`,
    [menuKey]
  );
  return NextResponse.json({ items: rows });
}

export async function POST(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const b = (await req.json().catch(() => ({}))) as {
    menu?: string; locale?: string; label?: string; href?: string; position?: number;
    parentId?: number | null; description?: string;
  };
  if (!b.locale || !isLocale(b.locale) || !b.label || !b.href) {
    return NextResponse.json({ error: "locale, label, href required" }, { status: 400 });
  }
  const menuKey = b.menu ?? "main";
  const menu = await pool.query(
    `INSERT INTO menus (key) VALUES ($1)
     ON CONFLICT (key) DO UPDATE SET key=EXCLUDED.key RETURNING id`,
    [menuKey]
  );
  await pool.query(
    `INSERT INTO menu_items (menu_id, locale, label, href, position, parent_id, description)
     VALUES ($1,$2,$3,$4,$5,$6,$7)`,
    [menu.rows[0].id, b.locale, b.label, b.href, b.position ?? 0,
     Number.isFinite(b.parentId) ? b.parentId : null, b.description?.trim() || null]
  );
  return NextResponse.json({ ok: true });
}

/** Update label / href / position of an existing item (inline edit + reorder). */
export async function PATCH(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const b = (await req.json().catch(() => ({}))) as { id?: number; label?: string; href?: string; position?: number; parentId?: number | null; description?: string };
  if (!b.id) return NextResponse.json({ error: "id required" }, { status: 400 });
  const sets: string[] = [];
  const vals: unknown[] = [];
  let p = 1;
  if (typeof b.label === "string") { sets.push(`label = $${p++}`); vals.push(b.label); }
  if (typeof b.href === "string") { sets.push(`href = $${p++}`); vals.push(b.href); }
  if (Number.isFinite(b.position)) { sets.push(`position = $${p++}`); vals.push(b.position); }
  if ("parentId" in b) { sets.push(`parent_id = $${p++}`); vals.push(Number.isFinite(b.parentId) ? b.parentId : null); }
  if (typeof b.description === "string") { sets.push(`description = $${p++}`); vals.push(b.description.trim() || null); }
  if (!sets.length) return NextResponse.json({ error: "nothing to update" }, { status: 400 });
  vals.push(b.id);
  await pool.query(`UPDATE menu_items SET ${sets.join(", ")} WHERE id = $${p}`, vals);
  return NextResponse.json({ ok: true });
}

export async function DELETE(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const id = new URL(req.url).searchParams.get("id");
  if (!id) return NextResponse.json({ error: "id required" }, { status: 400 });
  await pool.query(`DELETE FROM menu_items WHERE id = $1`, [id]);
  return NextResponse.json({ ok: true });
}
