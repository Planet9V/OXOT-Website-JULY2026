"use client";
import * as React from "react";
import {
  ResponsiveContainer, AreaChart, Area, XAxis, YAxis, Tooltip as RTooltip, CartesianGrid
} from "recharts";
import { Eye, Users, MousePointerClick } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Skeleton, SkeletonBlock } from "@/components/admin/skeleton";

// Ported from the source admin analytics page (artifacts/oxot-web/src/pages/
// admin-analytics.tsx). First-party traffic + engagement. Fetches from
// /api/admin/analytics; the affiliate/AI-recommendations sections are dropped
// (no affiliate-links table or LLM recommendations plumbing in this stack) and
// replaced with generic top outbound links.

type Overview = {
  rangeDays: number;
  totalViews: number;
  uniqueVisitors: number;
  totalClicks: number;
  viewsByDay: { date: string; views: number }[];
  topPages: { path: string; views: number }[];
  topReferrers: { referrer: string; count: number }[];
  deviceBreakdown: { device: string; count: number }[];
  topOutbound: { href: string; clicks: number }[];
};

const RANGES = [
  { label: "7 days", value: 7 },
  { label: "30 days", value: 30 },
  { label: "90 days", value: 90 },
];

function Kpi({ icon: Icon, label, value, loading }: {
  icon: React.ElementType; label: string; value: number; loading: boolean;
}) {
  return (
    <Card className="transition-shadow hover:shadow-md">
      <CardContent className="p-5">
        <div className="flex items-center gap-2 text-sm text-muted-foreground">
          <Icon className="h-4 w-4" /> {label}
        </div>
        {loading ? (
          <Skeleton className="mt-2 h-8 w-20" />
        ) : (
          <div className="mt-2 text-3xl font-semibold tracking-tight tabular-nums">
            {value.toLocaleString()}
          </div>
        )}
      </CardContent>
    </Card>
  );
}

function ListSkeleton({ rows = 4 }: { rows?: number }) {
  return (
    <ul className="space-y-2">
      {Array.from({ length: rows }).map((_, i) => (
        <li key={i} className="flex justify-between gap-2">
          <Skeleton className="h-4 w-2/3" />
          <Skeleton className="h-4 w-8" />
        </li>
      ))}
    </ul>
  );
}

export function AnalyticsManager() {
  const [days, setDays] = React.useState(30);
  const [data, setData] = React.useState<Overview | null>(null);
  const [loading, setLoading] = React.useState(true);

  React.useEffect(() => {
    let active = true;
    setLoading(true);
    fetch(`/api/admin/analytics?days=${days}`)
      .then((r) => (r.ok ? r.json() : null))
      .then((d) => { if (active) { setData(d); setLoading(false); } })
      .catch(() => { if (active) setLoading(false); });
    return () => { active = false; };
  }, [days]);

  return (
    <div className="space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-4">
        <div>
          <h2 className="text-xl font-semibold tracking-tight">Analytics</h2>
          <p className="text-sm text-muted-foreground">
            First-party traffic and engagement. Consent-gated.
          </p>
        </div>
        <div className="flex gap-1 rounded-lg bg-muted p-1">
          {RANGES.map((r) => (
            <button
              key={r.value}
              onClick={() => setDays(r.value)}
              className={`rounded-md px-3 py-1.5 text-sm transition-colors ${
                days === r.value ? "bg-background font-medium shadow-sm" : "text-muted-foreground"
              }`}
            >
              {r.label}
            </button>
          ))}
        </div>
      </div>

      <div className="grid gap-4 sm:grid-cols-3">
        <Kpi icon={Eye} label="Page views" value={data?.totalViews ?? 0} loading={loading} />
        <Kpi icon={Users} label="Unique visitors" value={data?.uniqueVisitors ?? 0} loading={loading} />
        <Kpi icon={MousePointerClick} label="Outbound clicks" value={data?.totalClicks ?? 0} loading={loading} />
      </div>

      <Card>
        <CardHeader>
          <CardTitle className="text-base">Views over time</CardTitle>
        </CardHeader>
        <CardContent>
          {loading ? (
            <SkeletonBlock className="h-64" />
          ) : data && data.viewsByDay.length === 0 ? (
            <p className="py-12 text-center text-sm text-muted-foreground">
              No visits recorded in this range yet.
            </p>
          ) : (
            <div className="h-64 w-full">
              <ResponsiveContainer width="100%" height="100%">
                <AreaChart data={data?.viewsByDay ?? []} margin={{ left: -20, right: 8, top: 4, bottom: 0 }}>
                  <defs>
                    <linearGradient id="gViews" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="0%" stopColor="hsl(var(--primary))" stopOpacity={0.35} />
                      <stop offset="100%" stopColor="hsl(var(--primary))" stopOpacity={0} />
                    </linearGradient>
                  </defs>
                  <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" vertical={false} />
                  <XAxis dataKey="date" tickFormatter={(d: string) => d.slice(5)} tick={{ fontSize: 11, fill: "hsl(var(--muted-foreground))" }} tickLine={false} axisLine={false} />
                  <YAxis allowDecimals={false} tick={{ fontSize: 11, fill: "hsl(var(--muted-foreground))" }} tickLine={false} axisLine={false} width={28} />
                  <RTooltip contentStyle={{ background: "hsl(var(--popover))", border: "1px solid hsl(var(--border))", borderRadius: 8, fontSize: 12, color: "hsl(var(--popover-foreground))" }} />
                  <Area type="monotone" dataKey="views" name="Views" stroke="hsl(var(--primary))" strokeWidth={2} fill="url(#gViews)" />
                </AreaChart>
              </ResponsiveContainer>
            </div>
          )}
        </CardContent>
      </Card>

      <div className="grid gap-6 lg:grid-cols-3">
        <Card>
          <CardHeader><CardTitle className="text-base">Top pages</CardTitle></CardHeader>
          <CardContent>
            {loading ? <ListSkeleton /> : data && data.topPages.length > 0 ? (
              <ul className="space-y-2">
                {data.topPages.map((p) => (
                  <li key={p.path} className="flex justify-between text-sm">
                    <span className="mr-2 truncate text-muted-foreground">{p.path}</span>
                    <span className="font-medium tabular-nums">{p.views}</span>
                  </li>
                ))}
              </ul>
            ) : (
              <p className="text-sm text-muted-foreground">No data.</p>
            )}
          </CardContent>
        </Card>

        <Card>
          <CardHeader><CardTitle className="text-base">Top referrers</CardTitle></CardHeader>
          <CardContent>
            {loading ? <ListSkeleton /> : data && data.topReferrers.length > 0 ? (
              <ul className="space-y-2">
                {data.topReferrers.map((r) => (
                  <li key={r.referrer} className="flex justify-between text-sm">
                    <span className="mr-2 truncate text-muted-foreground">{r.referrer}</span>
                    <span className="font-medium tabular-nums">{r.count}</span>
                  </li>
                ))}
              </ul>
            ) : (
              <p className="text-sm text-muted-foreground">No data.</p>
            )}
          </CardContent>
        </Card>

        <Card>
          <CardHeader><CardTitle className="text-base">Devices</CardTitle></CardHeader>
          <CardContent>
            {loading ? <ListSkeleton /> : data && data.deviceBreakdown.length > 0 ? (
              <ul className="space-y-2">
                {data.deviceBreakdown.map((d) => (
                  <li key={d.device} className="flex justify-between text-sm">
                    <span className="capitalize text-muted-foreground">{d.device}</span>
                    <span className="font-medium tabular-nums">{d.count}</span>
                  </li>
                ))}
              </ul>
            ) : (
              <p className="text-sm text-muted-foreground">No data.</p>
            )}
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader><CardTitle className="text-base">Top outbound links</CardTitle></CardHeader>
        <CardContent>
          {loading ? <ListSkeleton /> : data && data.topOutbound.length > 0 ? (
            <ul className="space-y-2">
              {data.topOutbound.map((l) => (
                <li key={l.href} className="flex justify-between gap-2 text-sm">
                  <span className="truncate text-muted-foreground">{l.href}</span>
                  <span className="shrink-0 font-medium tabular-nums">{l.clicks}</span>
                </li>
              ))}
            </ul>
          ) : (
            <p className="text-sm text-muted-foreground">No outbound clicks recorded yet.</p>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
