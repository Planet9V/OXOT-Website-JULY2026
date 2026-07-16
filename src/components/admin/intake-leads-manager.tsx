"use client";
import * as React from "react";
import { ResponsiveContainer, BarChart, Bar, XAxis, Tooltip as RTooltip, CartesianGrid } from "recharts";
import { Users, Sparkle, CalendarCheck2, Building2, Search, MessageSquare, Sparkles, User, ExternalLink, Reply } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { cn } from "@/lib/utils";
import { SEGMENTS } from "@/lib/segments";
import { IntakeSettingsCard } from "@/components/admin/intake-settings-card";

const inp = "rounded-md border border-border bg-background px-3 py-2 text-sm";

type Stage = "new" | "prospect" | "customer" | "lost";
type SchedulingStatus = "none" | "offered" | "scheduled";

type Lead = {
  id: string;
  segment: string;
  stage: Stage;
  tags: string[];
  name: string;
  email: string;
  company: string | null;
  role: string | null;
  scheduling_status: SchedulingStatus;
  scheduled_at: string | null;
  handled: boolean;
  admin_note: string | null;
  responded_at: string | null;
  created_at: string;
};

type LeadDetail = Lead & {
  blocker: string | null;
  answers: Record<string, unknown>;
  locale: string;
  page: string | null;
  utm: Record<string, unknown>;
  session_id: string | null;
  has_vec: boolean;
};

type Detail = {
  lead: LeadDetail;
  transcript: { role: string; text: string; provider: string | null; ts: string }[];
  similar: { id: string; name: string; company: string | null; segment: string; blocker: string | null; dist: number; created_at: string }[];
};

const STAGES: { key: Stage | "all"; label: string }[] = [
  { key: "all", label: "All" },
  { key: "new", label: "New" },
  { key: "prospect", label: "Prospect" },
  { key: "customer", label: "Customer" },
  { key: "lost", label: "Lost" }
];

function segmentLabel(s: string): string {
  return s.charAt(0).toUpperCase() + s.slice(1);
}

export function IntakeLeadsManager() {
  const [list, setList] = React.useState<Lead[]>([]);
  const [series, setSeries] = React.useState<{ day: string; n: number }[]>([]);
  const [stageFilter, setStageFilter] = React.useState<Stage | "all">("all");
  const [segmentFilter, setSegmentFilter] = React.useState<string>("all");
  const [q, setQ] = React.useState("");
  const [sel, setSel] = React.useState<string | null>(null);
  const [detail, setDetail] = React.useState<Detail | null>(null);
  const [note, setNote] = React.useState("");
  const [tagsInput, setTagsInput] = React.useState("");

  const load = React.useCallback(async () => {
    const res = await fetch("/api/admin/intake");
    if (res.ok) { const d = await res.json(); setList(d.leads); setSeries(d.series ?? []); }
  }, []);
  React.useEffect(() => { void load(); }, [load]);

  const openDetail = React.useCallback(async (id: string) => {
    setSel(id); setDetail(null);
    const res = await fetch(`/api/admin/intake?id=${id}`);
    if (res.ok) {
      const d = await res.json();
      setDetail(d);
      setNote(d.lead.admin_note ?? "");
      setTagsInput((d.lead.tags ?? []).join(", "));
    }
  }, []);

  async function patch(id: string, body: Record<string, unknown>) {
    await fetch("/api/admin/intake", { method: "PATCH", headers: { "content-type": "application/json" }, body: JSON.stringify({ id, ...body }) });
    await load(); if (sel === id) await openDetail(id);
  }

  const total = list.length;
  const newCount = list.filter((m) => m.stage === "new").length;
  const scheduledCount = list.filter((m) => m.scheduling_status === "scheduled").length;
  const customerCount = list.filter((m) => m.stage === "customer").length;

  const filtered = list.filter((m) => {
    if (stageFilter !== "all" && m.stage !== stageFilter) return false;
    if (segmentFilter !== "all" && m.segment !== segmentFilter) return false;
    if (q) {
      const s = q.toLowerCase();
      return [m.name, m.email, m.company, m.role].some((v) => (v ?? "").toLowerCase().includes(s));
    }
    return true;
  });

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-xl font-semibold tracking-tight">CRA Readiness Leads</h2>
        <p className="text-sm text-muted-foreground">Manage segmented intake leads — stage, tags, scheduling, and the linked chat and similar leads.</p>
      </div>

      <IntakeSettingsCard />

      {/* KPIs + chart */}
      <div className="grid gap-4 lg:grid-cols-3">
        <div className="grid grid-cols-2 gap-4 lg:col-span-1">
          <Kpi icon={Users} label="Total" value={total} />
          <Kpi icon={Sparkle} label="New" value={newCount} accent={newCount > 0} />
          <Kpi icon={CalendarCheck2} label="Scheduled" value={scheduledCount} />
          <Kpi icon={Building2} label="Customers" value={customerCount} />
        </div>
        <Card className="lg:col-span-2">
          <CardHeader className="pb-2"><CardTitle className="text-sm">Leads — last 30 days</CardTitle></CardHeader>
          <CardContent>
            <div className="h-40 w-full">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={series} margin={{ left: -28, right: 6, top: 4 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" vertical={false} />
                  <XAxis dataKey="day" tickFormatter={(d: string) => d.slice(5)} tick={{ fontSize: 10, fill: "hsl(var(--muted-foreground))" }} tickLine={false} axisLine={false} interval="preserveStartEnd" />
                  <RTooltip contentStyle={{ background: "hsl(var(--popover))", border: "1px solid hsl(var(--border))", borderRadius: 8, fontSize: 12 }} />
                  <Bar dataKey="n" name="Leads" fill="hsl(var(--primary))" radius={[3, 3, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* filter + search */}
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div className="flex flex-wrap items-center gap-2">
          <Tabs value={stageFilter} onValueChange={(v) => setStageFilter(v as Stage | "all")}>
            <TabsList>
              {STAGES.map((s) => (
                <TabsTrigger key={s.key} value={s.key}>
                  {s.label}{s.key === "new" && newCount > 0 ? ` (${newCount})` : ""}
                </TabsTrigger>
              ))}
            </TabsList>
          </Tabs>
          <select className={inp} value={segmentFilter} onChange={(e) => setSegmentFilter(e.target.value)}>
            <option value="all">All segments</option>
            {SEGMENTS.map((s) => <option key={s} value={s}>{segmentLabel(s)}</option>)}
          </select>
        </div>
        <div className="relative w-full max-w-xs">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input className="pl-8" placeholder="Search name, email, role…" value={q} onChange={(e) => setQ(e.target.value)} />
        </div>
      </div>

      {/* list + detail */}
      <div className="grid gap-4 lg:grid-cols-5">
        <div className="space-y-2 lg:col-span-2">
          {filtered.length === 0 && <p className="rounded-lg border border-dashed border-border p-6 text-center text-sm text-muted-foreground">No leads.</p>}
          {filtered.map((m) => (
            <button key={m.id} onClick={() => openDetail(m.id)}
              className={cn("w-full rounded-lg border p-3 text-left transition-colors",
                sel === m.id ? "border-primary bg-primary/5" : "border-border hover:bg-accent")}>
              <div className="flex items-center justify-between gap-2">
                <span className="truncate text-sm font-medium">{m.name}{m.company ? ` · ${m.company}` : ""}</span>
                <div className="flex shrink-0 items-center gap-1">
                  <Badge variant="secondary">{segmentLabel(m.segment)}</Badge>
                  <Badge variant={m.stage === "new" ? "default" : "secondary"}>{m.stage}</Badge>
                </div>
              </div>
              <p className="mt-1 line-clamp-2 text-xs text-muted-foreground">{m.role ?? "—"}</p>
              <div className="mt-1 text-[11px] text-muted-foreground/70">
                {new Date(m.created_at).toLocaleString()}
                {m.scheduling_status !== "none" ? ` · scheduling: ${m.scheduling_status}` : ""}
              </div>
            </button>
          ))}
        </div>

        <div className="lg:col-span-3">
          {!sel && <Card><CardContent className="p-8 text-center text-sm text-muted-foreground">Select a lead to view details, the linked chat, and similar leads.</CardContent></Card>}
          {sel && !detail && <Card><CardContent className="p-8 text-center text-sm text-muted-foreground">Loading…</CardContent></Card>}
          {detail && (
            <Card>
              <CardContent className="space-y-5 p-5">
                <div className="flex flex-wrap items-start justify-between gap-3">
                  <div>
                    <div className="text-base font-semibold">{detail.lead.name}</div>
                    <a href={`mailto:${detail.lead.email}`} className="text-sm text-primary underline underline-offset-2">{detail.lead.email}</a>
                    <div className="mt-0.5 text-xs text-muted-foreground">
                      {detail.lead.company ?? "—"} · {detail.lead.role ?? "—"} · {segmentLabel(detail.lead.segment)} · {new Date(detail.lead.created_at).toLocaleString()} · {detail.lead.locale}{detail.lead.page ? ` · ${detail.lead.page}` : ""}
                    </div>
                  </div>
                  <div className="flex gap-2">
                    <Button size="sm" variant={detail.lead.handled ? "secondary" : "default"} onClick={() => patch(detail.lead.id, { handled: !detail.lead.handled })}>
                      {detail.lead.handled ? "Handled ✓" : "Mark handled"}
                    </Button>
                    <Button size="sm" variant="outline" asChild>
                      <a href={`mailto:${detail.lead.email}?subject=${encodeURIComponent("Re: your CRA readiness enquiry")}`} onClick={() => patch(detail.lead.id, { responded: true })}>
                        <Reply className="h-4 w-4" /> Reply
                      </a>
                    </Button>
                  </div>
                </div>

                {detail.lead.blocker && (
                  <div className="rounded-lg bg-muted/40 p-3 text-sm whitespace-pre-wrap">{detail.lead.blocker}</div>
                )}

                {/* stage segmented control */}
                <div>
                  <div className="mb-1.5 text-xs font-semibold uppercase tracking-wide text-muted-foreground">Stage</div>
                  <div className="flex flex-wrap gap-1.5">
                    {(["new", "prospect", "customer", "lost"] as Stage[]).map((s) => (
                      <Button key={s} size="sm" variant={detail.lead.stage === s ? "default" : "outline"} onClick={() => patch(detail.lead.id, { stage: s })}>
                        {s.charAt(0).toUpperCase() + s.slice(1)}
                      </Button>
                    ))}
                  </div>
                </div>

                {/* scheduling status (read-only) */}
                <div className="rounded-lg border border-border p-3 text-xs text-muted-foreground">
                  <span className="font-semibold uppercase tracking-wide">Scheduling</span>{" "}
                  {detail.lead.scheduling_status}
                  {detail.lead.scheduled_at ? ` · ${new Date(detail.lead.scheduled_at).toLocaleString()}` : ""}
                </div>

                {/* tags editor */}
                <div>
                  <div className="mb-1.5 text-xs font-semibold uppercase tracking-wide text-muted-foreground">Tags</div>
                  <div className="flex flex-wrap items-center gap-2">
                    <Input
                      className="max-w-sm"
                      value={tagsInput}
                      onChange={(e) => setTagsInput(e.target.value)}
                      placeholder="comma, separated, tags"
                    />
                    <Button
                      size="sm"
                      variant="outline"
                      onClick={() => patch(detail.lead.id, { tags: tagsInput.split(",").map((t) => t.trim()).filter(Boolean) })}
                    >
                      Save tags
                    </Button>
                  </div>
                  {detail.lead.tags.length > 0 && (
                    <div className="mt-2 flex flex-wrap gap-1.5">
                      {detail.lead.tags.map((t) => <Badge key={t} variant="secondary">{t}</Badge>)}
                    </div>
                  )}
                </div>

                {/* linked chat transcript */}
                {detail.lead.session_id && (
                  <div>
                    <div className="mb-2 flex items-center gap-2 text-xs font-semibold uppercase tracking-wide text-muted-foreground"><MessageSquare className="h-3.5 w-3.5" /> Linked chat session</div>
                    {detail.transcript.length === 0 ? <p className="text-xs text-muted-foreground">Session linked, no messages recorded.</p> : (
                      <div className="max-h-56 space-y-2 overflow-y-auto rounded-lg border border-border p-3">
                        {detail.transcript.map((t, i) => (
                          <div key={i} className={cn("flex", t.role === "user" ? "justify-end" : "justify-start")}>
                            <div className={cn("max-w-[80%] rounded-lg px-3 py-1.5 text-xs", t.role === "user" ? "bg-primary text-primary-foreground" : "bg-muted")}>
                              {t.role === "assistant" && <User className="mb-0.5 inline h-3 w-3 opacity-60" />} {t.text}
                            </div>
                          </div>
                        ))}
                      </div>
                    )}
                  </div>
                )}

                {/* similar leads */}
                {detail.similar.length > 0 && (
                  <div>
                    <div className="mb-2 flex items-center gap-2 text-xs font-semibold uppercase tracking-wide text-muted-foreground"><Sparkles className="h-3.5 w-3.5" /> Similar leads</div>
                    <div className="space-y-1.5">
                      {detail.similar.map((s) => (
                        <button key={s.id} onClick={() => openDetail(s.id)} className="flex w-full items-center justify-between gap-2 rounded-md border border-border px-3 py-1.5 text-left text-xs hover:bg-accent">
                          <span className="truncate">{s.name}{s.company ? ` · ${s.company}` : ""} — <span className="text-muted-foreground">{segmentLabel(s.segment)}{s.blocker ? ` · ${s.blocker}` : ""}</span></span>
                          <ExternalLink className="h-3 w-3 shrink-0 text-muted-foreground" />
                        </button>
                      ))}
                    </div>
                  </div>
                )}

                {/* admin note */}
                <div>
                  <div className="mb-1.5 text-xs font-semibold uppercase tracking-wide text-muted-foreground">Internal note</div>
                  <Textarea className="h-20" value={note} onChange={(e) => setNote(e.target.value)} placeholder="Context, next steps, owner…" />
                  <div className="mt-2">
                    <Button size="sm" variant="outline" onClick={() => patch(detail.lead.id, { adminNote: note })}>Save note</Button>
                  </div>
                </div>
              </CardContent>
            </Card>
          )}
        </div>
      </div>
    </div>
  );
}

function Kpi({ icon: Icon, label, value, accent }: { icon: React.ElementType; label: string; value: number; accent?: boolean }) {
  return (
    <Card>
      <CardContent className="p-4">
        <div className={cn("flex h-8 w-8 items-center justify-center rounded-lg", accent ? "bg-primary text-primary-foreground" : "bg-primary/10 text-primary")}>
          <Icon className="h-4 w-4" />
        </div>
        <div className="mt-2 text-xl font-semibold">{value}</div>
        <div className="text-xs text-muted-foreground">{label}</div>
      </CardContent>
    </Card>
  );
}
