import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { getAdminSession } from "@/lib/auth";

export const dynamic = "force-dynamic";

const ALLOWED = new Set(["image/png", "image/jpeg", "image/webp", "image/gif", "application/pdf"]);
const MAX_BYTES = 15 * 1024 * 1024; // 15 MB

/** List uploaded media (metadata only — never the bytes). */
export async function GET() {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const { rows } = await pool.query(
    `SELECT id, filename, mime, size, width, height, alt, created_at
       FROM media ORDER BY created_at DESC`
  );
  return NextResponse.json({ media: rows });
}

/** Upload: JSON { filename, mime, dataBase64, width?, height?, alt? }.
 *  Images are pre-cropped/resized client-side; here we validate + store. */
export async function POST(req: NextRequest) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const b = (await req.json().catch(() => ({}))) as {
    filename?: string; mime?: string; dataBase64?: string; width?: number; height?: number; alt?: string;
  };
  if (!b.mime || !ALLOWED.has(b.mime)) {
    return NextResponse.json({ error: "unsupported file type (png, jpeg, webp, gif, pdf)" }, { status: 400 });
  }
  if (!b.dataBase64) return NextResponse.json({ error: "no data" }, { status: 400 });
  const buf = Buffer.from(b.dataBase64, "base64");
  if (!buf.length) return NextResponse.json({ error: "empty file" }, { status: 400 });
  if (buf.length > MAX_BYTES) return NextResponse.json({ error: "file too large (max 15 MB)" }, { status: 413 });

  const { rows } = await pool.query(
    `INSERT INTO media (filename, mime, bytes, size, width, height, alt)
     VALUES ($1,$2,$3,$4,$5,$6,$7)
     RETURNING id, filename, mime, size, width, height, alt, created_at`,
    [
      (b.filename ?? "upload").slice(0, 200),
      b.mime,
      buf,
      buf.length,
      Number.isFinite(b.width) ? b.width : null,
      Number.isFinite(b.height) ? b.height : null,
      b.alt?.slice(0, 500) ?? null
    ]
  );
  return NextResponse.json({ ok: true, media: rows[0] });
}

export async function DELETE(req: NextRequest) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const idParam = new URL(req.url).searchParams.get("id");
  const id = Number(idParam);
  if (!idParam || !Number.isInteger(id) || id <= 0) {
    return NextResponse.json({ error: "valid numeric id required" }, { status: 400 });
  }
  await pool.query(`DELETE FROM media WHERE id=$1`, [id]);
  return NextResponse.json({ ok: true });
}
