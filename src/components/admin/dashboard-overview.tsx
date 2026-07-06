"use client";
import * as React from "react";
import {
  ResponsiveContainer, AreaChart, Area, XAxis, YAxis, Tooltip as RTooltip, CartesianGrid
} from "recharts";
import { FileText, Newspaper, Inbox, Bot, Users, Database, ArrowUpRight } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";

type Stats = {
  kpis: {
    pagesPublished: number; pagesTotal: number; articles: number;
    enquiriesNew: number; enquiriesTotal: number; agentMessages: number; sessions: number; chunks: number;
  };
  series: { day: string; enquiries: number; messages: number }[];
};

function Kpi({ icon: Icon, label, value, sub, badge }: {
  icon: React.ElementType; label: string; value: React.ReactNode; sub?: string; badge?: React.ReactNode;
}) {
  return (
    <Card className="transition-shadow hover:shadow-md">
      <CardContent className="p-5">
        <div className="flex items-center justify-between">
          <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-primary/10 text-primary">
            <Icon className="h-4 w-4" />
          </div>
          {badge}
        </div>
        <div className="mt-3 text-2xl font-semibold tracking-tight">{value}</div>
        <div className="mt-0.5 text-sm text-muted-foreground">{label}</div>
        {sub && <div className="mt-1 text-xs text-muted-foreground/80">{sub}</div>}
      </CardContent>
    </Card>
  );
}

export function DashboardOverview() {
  const [stats, setStats] = React.useState<Stats | null>(null);
  React.useEffect(() => {
    fetch("/api/admin/stats").then((r) => (r.ok ? r.json() : null)).then(setStats).catch(() => {});
  }, []);

  const k = stats?.kpis;

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-xl font-semibold tracking-tight">Overview</h2>
        <p className="text-sm text-muted-foreground">Content, leads and assistant activity at a glance.</p>
      </div>

      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        <Kpi icon={FileText} label="Published pages" value={k ? k.pagesPublished : "—"} sub={k ? `${k.pagesTotal} total incl. drafts` : undefined} />
        <Kpi icon={Newspaper} label="Insights articles" value={k ? k.articles : "—"} />
        <Kpi icon={Inbox} label="Contact enquiries" value={k ? k.enquiriesTotal : "—"}
          badge={k && k.enquiriesNew > 0 ? <Badge>{k.enquiriesNew} new</Badge> : undefined} />
        <Kpi icon={Bot} label="Assistant replies" value={k ? k.agentMessages : "—"} sub="Grounded answers served" />
        <Kpi icon={Users} label="Visitor sessions" value={k ? k.sessions : "—"} sub="Consent-gated" />
        <Kpi icon={Database} label="Knowledge chunks" value={k ? k.chunks : "—"} sub="Embedded for retrieval" />
      </div>

      <Card>
        <CardHeader className="flex flex-row items-center justify-between space-y-0">
          <div>
            <CardTitle className="text-base">Activity — last 14 days</CardTitle>
            <p className="mt-1 text-xs text-muted-foreground">Enquiries and assistant replies per day</p>
          </div>
          <ArrowUpRight className="h-4 w-4 text-muted-foreground" />
        </CardHeader>
        <CardContent>
          <div className="h-64 w-full">
            <ResponsiveContainer width="100%" height="100%">
              <AreaChart data={stats?.series ?? []} margin={{ left: -20, right: 8, top: 4, bottom: 0 }}>
                <defs>
                  <linearGradient id="gEnq" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stopColor="hsl(var(--primary))" stopOpacity={0.35} />
                    <stop offset="100%" stopColor="hsl(var(--primary))" stopOpacity={0} />
                  </linearGradient>
                  <linearGradient id="gMsg" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stopColor="hsl(var(--muted-foreground))" stopOpacity={0.25} />
                    <stop offset="100%" stopColor="hsl(var(--muted-foreground))" stopOpacity={0} />
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" vertical={false} />
                <XAxis dataKey="day" tickFormatter={(d: string) => d.slice(5)} tick={{ fontSize: 11, fill: "hsl(var(--muted-foreground))" }} tickLine={false} axisLine={false} />
                <YAxis allowDecimals={false} tick={{ fontSize: 11, fill: "hsl(var(--muted-foreground))" }} tickLine={false} axisLine={false} width={28} />
                <RTooltip contentStyle={{ background: "hsl(var(--popover))", border: "1px solid hsl(var(--border))", borderRadius: 8, fontSize: 12, color: "hsl(var(--popover-foreground))" }} />
                <Area type="monotone" dataKey="enquiries" name="Enquiries" stroke="hsl(var(--primary))" strokeWidth={2} fill="url(#gEnq)" />
                <Area type="monotone" dataKey="messages" name="Assistant" stroke="hsl(var(--muted-foreground))" strokeWidth={2} fill="url(#gMsg)" />
              </AreaChart>
            </ResponsiveContainer>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
