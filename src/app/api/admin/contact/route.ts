import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { getAdminSession } from "@/lib/auth";

export const runtime = "nodejs";

export async function GET() {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const { rows } = await pool.query(
    `SELECT id, name, email, company, message, locale, page, handled, created_at
       FROM contact_messages
      ORDER BY handled ASC, created_at DESC
      LIMIT 200`
  );
  return NextResponse.json({ messages: rows });
}

// Mark a submission handled / unhandled.
export async function PATCH(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const b = (await req.json().catch(() => ({}))) as { id?: string; handled?: boolean };
  if (!b.id) return NextResponse.json({ error: "id required" }, { status: 400 });
  await pool.query(`UPDATE contact_messages SET handled=$2 WHERE id=$1`, [b.id, b.handled === true]);
  return NextResponse.json({ ok: true });
}
