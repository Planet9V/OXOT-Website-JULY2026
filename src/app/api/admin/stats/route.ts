import { NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { getAdminSession } from "@/lib/auth";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

async function scalar(sql: string): Promise<number> {
  try { const { rows } = await pool.query(sql); return Number(rows[0]?.n ?? 0); }
  catch { return 0; }
}

export async function GET() {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });

  const [
    pagesPublished, pagesTotal, articles, enquiriesNew, enquiriesTotal, agentMessages, sessions, chunks
  ] = await Promise.all([
    scalar("SELECT count(*)::int n FROM pages WHERE published=true"),
    scalar("SELECT count(*)::int n FROM pages"),
    scalar("SELECT count(*)::int n FROM pages WHERE content_type='article' AND published=true"),
    scalar("SELECT count(*)::int n FROM contact_messages WHERE handled=false"),
    scalar("SELECT count(*)::int n FROM contact_messages"),
    scalar("SELECT count(*)::int n FROM agent_messages WHERE role='assistant'"),
    scalar("SELECT count(*)::int n FROM visitor_sessions"),
    scalar("SELECT count(*)::int n FROM content_chunks")
  ]);

  // 14-day activity series (enquiries by created_at, agent replies by ts).
  const days: { day: string; enquiries: number; messages: number }[] = [];
  const map: Record<string, { enquiries: number; messages: number }> = {};
  for (let i = 13; i >= 0; i--) {
    const d = new Date(); d.setDate(d.getDate() - i);
    const key = d.toISOString().slice(0, 10);
    map[key] = { enquiries: 0, messages: 0 };
    days.push({ day: key, enquiries: 0, messages: 0 });
  }
  try {
    const q1 = await pool.query(
      "SELECT to_char(date_trunc('day', created_at),'YYYY-MM-DD') d, count(*)::int n FROM contact_messages WHERE created_at > now() - interval '14 days' GROUP BY 1"
    );
    for (const r of q1.rows) if (map[r.d]) map[r.d].enquiries = Number(r.n);
  } catch { /* table may be empty */ }
  try {
    const q2 = await pool.query(
      "SELECT to_char(date_trunc('day', ts),'YYYY-MM-DD') d, count(*)::int n FROM agent_messages WHERE role='assistant' AND ts > now() - interval '14 days' GROUP BY 1"
    );
    for (const r of q2.rows) if (map[r.d]) map[r.d].messages = Number(r.n);
  } catch { /* ignore */ }
  for (const row of days) { row.enquiries = map[row.day].enquiries; row.messages = map[row.day].messages; }

  return NextResponse.json({
    kpis: { pagesPublished, pagesTotal, articles, enquiriesNew, enquiriesTotal, agentMessages, sessions, chunks },
    series: days
  });
}
