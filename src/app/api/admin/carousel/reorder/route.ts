import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { getAdminSession } from "@/lib/auth";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// Reorder hero carousel slides. Ported from the source PUT /admin/carousel/reorder
// (Celestial-Agent-Nexus: adminMedia.ts). Requires `ids` to be an exact
// permutation of the current slide ids so a partial/malformed payload cannot
// leave duplicate or stale sort_order values. Runs in a transaction.
export async function PUT(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });

  const b = (await req.json().catch(() => ({}))) as { ids?: unknown };
  const ids = Array.isArray(b.ids) ? b.ids.map((v) => Number(v)) : [];
  if (ids.length === 0 || ids.some((n) => !Number.isInteger(n)))
    return NextResponse.json({ error: "ids must be an array of slide ids" }, { status: 400 });

  const client = await pool.connect();
  try {
    const existing = await client.query(`SELECT id FROM carousel_slides`);
    const existingIds: number[] = existing.rows.map((r) => Number(r.id));
    const idsSet = new Set(ids);
    const isPermutation =
      existingIds.length === ids.length &&
      idsSet.size === ids.length &&
      existingIds.every((id) => idsSet.has(id));
    if (!isPermutation) {
      return NextResponse.json(
        { error: "ids must be an exact permutation of the current carousel slide ids" },
        { status: 400 }
      );
    }

    await client.query("BEGIN");
    for (let i = 0; i < ids.length; i++) {
      await client.query(`UPDATE carousel_slides SET sort_order=$1, updated_at=now() WHERE id=$2`, [i, ids[i]]);
    }
    await client.query("COMMIT");
    return NextResponse.json({ ok: true });
  } catch (err) {
    await client.query("ROLLBACK").catch(() => {});
    console.error("[admin/carousel] reorder failed:", err);
    return NextResponse.json({ error: "Could not reorder slides" }, { status: 500 });
  } finally {
    client.release();
  }
}
