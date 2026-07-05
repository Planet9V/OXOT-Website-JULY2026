import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { getAdminSession } from "@/lib/auth";
import { isLocale } from "@/i18n/config";

export async function GET(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const menuKey = new URL(req.url).searchParams.get("menu") ?? "main";
  const { rows } = await pool.query(
    `SELECT mi.id, mi.locale, mi.label, mi.href, mi.position
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
    `INSERT INTO menu_items (menu_id, locale, label, href, position)
     VALUES ($1,$2,$3,$4,$5)`,
    [menu.rows[0].id, b.locale, b.label, b.href, b.position ?? 0]
  );
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
