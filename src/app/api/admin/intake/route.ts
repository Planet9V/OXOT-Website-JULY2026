import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { getAdminSession } from "@/lib/auth";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

const STAGES = ["new", "prospect", "customer", "lost"] as const;
const SCHEDULING_STATUSES = ["none", "offered", "scheduled"] as const;

export async function GET(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });

  const id = new URL(req.url).searchParams.get("id");

  // Detail view: the lead + its linked chat transcript + similar leads.
  if (id) {
    const { rows } = await pool.query(
      `SELECT id, segment, stage, tags, name, email, company, role, answers, blocker,
              locale, page, utm, ip_hash, session_id, scheduling_status, scheduled_at,
              handled, admin_note, responded_at, created_at,
              (embedding IS NOT NULL) AS has_vec
         FROM cra_readiness_leads WHERE id=$1`,
      [id]
    );
    if (!rows.length) return NextResponse.json({ error: "not found" }, { status: 404 });
    const lead = rows[0];

    let transcript: unknown[] = [];
    if (lead.session_id) {
      try {
        const t = await pool.query(
          `SELECT role, text, provider, ts FROM agent_messages
            WHERE session_id=$1 ORDER BY ts ASC LIMIT 100`,
          [lead.session_id]
        );
        transcript = t.rows;
      } catch { /* ignore */ }
    }

    let similar: unknown[] = [];
    try {
      const s = await pool.query(
        `SELECT id, name, company, segment, left(blocker, 140) AS blocker, created_at,
                (embedding <=> (SELECT embedding FROM cra_readiness_leads WHERE id=$1)) AS dist
           FROM cra_readiness_leads
          WHERE id <> $1 AND embedding IS NOT NULL
            AND (SELECT embedding FROM cra_readiness_leads WHERE id=$1) IS NOT NULL
          ORDER BY dist ASC LIMIT 4`,
        [id]
      );
      similar = s.rows;
    } catch { /* embedding may be unavailable */ }

    return NextResponse.json({ lead, transcript, similar });
  }

  // List + lightweight stats.
  const { rows } = await pool.query(
    `SELECT id, segment, stage, tags, name, email, company, role,
            scheduling_status, scheduled_at, handled, admin_note, responded_at, created_at
       FROM cra_readiness_leads
      ORDER BY handled ASC, created_at DESC LIMIT 300`
  );
  let series: { day: string; n: number }[] = [];
  try {
    const q = await pool.query(
      "SELECT to_char(date_trunc('day', created_at),'YYYY-MM-DD') d, count(*)::int n FROM cra_readiness_leads WHERE created_at > now() - interval '30 days' GROUP BY 1 ORDER BY 1"
    );
    series = q.rows.map((r) => ({ day: r.d, n: Number(r.n) }));
  } catch { /* ignore */ }
  return NextResponse.json({ leads: rows, series });
}

export async function PATCH(req: NextRequest) {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const b = (await req.json().catch(() => ({}))) as {
    id?: string;
    handled?: boolean;
    adminNote?: string;
    responded?: boolean;
    stage?: string;
    tags?: string[];
    schedulingStatus?: string;
    scheduledAt?: string | null;
  };
  if (!b.id) return NextResponse.json({ error: "id required" }, { status: 400 });

  if (b.stage !== undefined && !STAGES.includes(b.stage as (typeof STAGES)[number])) {
    return NextResponse.json({ error: "invalid stage" }, { status: 400 });
  }
  if (b.schedulingStatus !== undefined && !SCHEDULING_STATUSES.includes(b.schedulingStatus as (typeof SCHEDULING_STATUSES)[number])) {
    return NextResponse.json({ error: "invalid schedulingStatus" }, { status: 400 });
  }
  if (b.tags !== undefined && (!Array.isArray(b.tags) || !b.tags.every((t) => typeof t === "string"))) {
    return NextResponse.json({ error: "invalid tags" }, { status: 400 });
  }

  await pool.query(
    `UPDATE cra_readiness_leads SET
       handled = COALESCE($2, handled),
       admin_note = COALESCE($3, admin_note),
       responded_at = CASE WHEN $4::boolean IS TRUE THEN now()
                           WHEN $4::boolean IS FALSE THEN NULL
                           ELSE responded_at END,
       stage = COALESCE($5, stage),
       tags = COALESCE($6::text[], tags),
       scheduling_status = COALESCE($7, scheduling_status),
       scheduled_at = COALESCE($8::timestamptz, scheduled_at)
     WHERE id=$1`,
    [
      b.id,
      b.handled ?? null,
      b.adminNote ?? null,
      b.responded ?? null,
      b.stage ?? null,
      b.tags ?? null,
      b.schedulingStatus ?? null,
      b.scheduledAt ?? null
    ]
  );
  return NextResponse.json({ ok: true });
}
