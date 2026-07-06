import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { getAdminSession } from "@/lib/auth";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

export async function GET(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });

  const id = new URL(req.url).searchParams.get("id");

  // Detail view: the inquiry + its linked chat transcript + similar inquiries.
  if (id) {
    const { rows } = await pool.query(
      `SELECT id, name, email, company, message, locale, page, session_id,
              handled, admin_note, responded_at, created_at,
              (embedding IS NOT NULL) AS has_vec
         FROM contact_messages WHERE id=$1`,
      [id]
    );
    if (!rows.length) return NextResponse.json({ error: "not found" }, { status: 404 });
    const inq = rows[0];

    let transcript: unknown[] = [];
    if (inq.session_id) {
      try {
        const t = await pool.query(
          `SELECT role, text, provider, ts FROM agent_messages
            WHERE session_id=$1 ORDER BY ts ASC LIMIT 100`,
          [inq.session_id]
        );
        transcript = t.rows;
      } catch { /* ignore */ }
    }

    let similar: unknown[] = [];
    try {
      const s = await pool.query(
        `SELECT id, name, company, left(message, 140) AS message, created_at,
                (embedding <=> (SELECT embedding FROM contact_messages WHERE id=$1)) AS dist
           FROM contact_messages
          WHERE id <> $1 AND embedding IS NOT NULL
            AND (SELECT embedding FROM contact_messages WHERE id=$1) IS NOT NULL
          ORDER BY dist ASC LIMIT 4`,
        [id]
      );
      similar = s.rows;
    } catch { /* embedding may be unavailable */ }

    return NextResponse.json({ inquiry: inq, transcript, similar });
  }

  // List + lightweight stats.
  const { rows } = await pool.query(
    `SELECT id, name, email, company, message, locale, page, session_id,
            handled, admin_note, responded_at, created_at
       FROM contact_messages
      ORDER BY handled ASC, created_at DESC LIMIT 300`
  );
  let series: { day: string; n: number }[] = [];
  try {
    const q = await pool.query(
      "SELECT to_char(date_trunc('day', created_at),'YYYY-MM-DD') d, count(*)::int n FROM contact_messages WHERE created_at > now() - interval '30 days' GROUP BY 1 ORDER BY 1"
    );
    series = q.rows.map((r) => ({ day: r.d, n: Number(r.n) }));
  } catch { /* ignore */ }
  return NextResponse.json({ messages: rows, series });
}

export async function PATCH(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const b = (await req.json().catch(() => ({}))) as {
    id?: string; handled?: boolean; adminNote?: string; responded?: boolean;
  };
  if (!b.id) return NextResponse.json({ error: "id required" }, { status: 400 });
  await pool.query(
    `UPDATE contact_messages SET
       handled = COALESCE($2, handled),
       admin_note = COALESCE($3, admin_note),
       responded_at = CASE WHEN $4::boolean IS TRUE THEN now()
                           WHEN $4::boolean IS FALSE THEN NULL
                           ELSE responded_at END
     WHERE id=$1`,
    [b.id, b.handled ?? null, b.adminNote ?? null, b.responded ?? null]
  );
  return NextResponse.json({ ok: true });
}
