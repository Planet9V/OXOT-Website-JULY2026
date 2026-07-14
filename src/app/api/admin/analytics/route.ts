import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { pool } from "@/lib/db";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// Admin analytics overview. Ported from the source (artifacts/api-server:
// adminAnalytics.ts + lib/analytics.ts getAnalyticsOverview) to raw SQL. The
// source's affiliate link-performance is replaced with generic outbound-click
// aggregates (this stack has no affiliate-links table). getAdminSession-guarded.
export async function GET(req: NextRequest) {
  if (!(await getAdminSession())) {
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  }

  const daysParam = Number(req.nextUrl.searchParams.get("days"));
  const rangeDays =
    Number.isFinite(daysParam) && daysParam > 0
      ? Math.min(Math.floor(daysParam), 365)
      : 30;
  const since = new Date(Date.now() - rangeDays * 24 * 60 * 60 * 1000);

  try {
    const [totals, clickTotals, viewsByDay, topPages, topReferrers, deviceBreakdown, topOutbound] =
      await Promise.all([
        pool.query(
          `SELECT count(*)::int AS views,
                  count(distinct session_id)::int AS uniques
             FROM page_views
            WHERE created_at >= $1`,
          [since]
        ),
        pool.query(
          `SELECT count(*)::int AS clicks
             FROM link_clicks
            WHERE created_at >= $1`,
          [since]
        ),
        pool.query(
          `SELECT to_char(date_trunc('day', created_at), 'YYYY-MM-DD') AS date,
                  count(*)::int AS views
             FROM page_views
            WHERE created_at >= $1
            GROUP BY date_trunc('day', created_at)
            ORDER BY date_trunc('day', created_at)`,
          [since]
        ),
        pool.query(
          `SELECT path, count(*)::int AS views
             FROM page_views
            WHERE created_at >= $1
            GROUP BY path
            ORDER BY count(*) DESC
            LIMIT 10`,
          [since]
        ),
        pool.query(
          `SELECT coalesce(nullif(referrer, ''), 'Direct') AS referrer,
                  count(*)::int AS count
             FROM page_views
            WHERE created_at >= $1
            GROUP BY coalesce(nullif(referrer, ''), 'Direct')
            ORDER BY count(*) DESC
            LIMIT 10`,
          [since]
        ),
        pool.query(
          `SELECT coalesce(nullif(device, ''), 'unknown') AS device,
                  count(*)::int AS count
             FROM page_views
            WHERE created_at >= $1
            GROUP BY coalesce(nullif(device, ''), 'unknown')
            ORDER BY count(*) DESC`,
          [since]
        ),
        pool.query(
          `SELECT href, count(*)::int AS clicks
             FROM link_clicks
            WHERE created_at >= $1
            GROUP BY href
            ORDER BY count(*) DESC
            LIMIT 10`,
          [since]
        ),
      ]);

    return NextResponse.json({
      rangeDays,
      totalViews: totals.rows[0]?.views ?? 0,
      uniqueVisitors: totals.rows[0]?.uniques ?? 0,
      totalClicks: clickTotals.rows[0]?.clicks ?? 0,
      viewsByDay: viewsByDay.rows.map((r) => ({ date: r.date, views: Number(r.views) })),
      topPages: topPages.rows.map((r) => ({ path: r.path, views: Number(r.views) })),
      topReferrers: topReferrers.rows.map((r) => ({
        referrer: r.referrer,
        count: Number(r.count),
      })),
      deviceBreakdown: deviceBreakdown.rows.map((r) => ({
        device: r.device,
        count: Number(r.count),
      })),
      topOutbound: topOutbound.rows.map((r) => ({ href: r.href, clicks: Number(r.clicks) })),
    });
  } catch (err) {
    console.error("[admin/analytics] query failed:", err);
    return NextResponse.json({ error: "analytics_unavailable" }, { status: 500 });
  }
}
