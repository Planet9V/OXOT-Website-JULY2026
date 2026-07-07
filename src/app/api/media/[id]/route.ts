import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";

export const dynamic = "force-dynamic";

/** Public serve: /api/media/123 → the stored bytes with correct content-type. */
export async function GET(_req: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const n = parseInt(id, 10);
  if (!Number.isFinite(n)) return new NextResponse("bad id", { status: 400 });
  const { rows } = await pool.query(`SELECT bytes, mime FROM media WHERE id=$1 LIMIT 1`, [n]);
  if (!rows.length) return new NextResponse("not found", { status: 404 });
  const buf = rows[0].bytes as Buffer;
  return new NextResponse(new Uint8Array(buf), {
    status: 200,
    headers: {
      "Content-Type": rows[0].mime,
      "Content-Length": String(buf.length),
      "Cache-Control": "public, max-age=31536000, immutable"
    }
  });
}
