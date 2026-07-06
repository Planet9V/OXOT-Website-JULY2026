"use client";
import * as React from "react";
import { ResponsiveContainer, BarChart, Bar, XAxis, Tooltip as RTooltip, CartesianGrid } from "recharts";
import { Inbox, MailCheck, Reply, Search, MessageSquare, Sparkles, User, ExternalLink } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { cn } from "@/lib/utils";

type Msg = {
  id: string; name: string; email: string; company: string | null; message: string;
  locale: string; page: string | null; session_id: string | null;
  handled: boolean; admin_note: string | null; responded_at: string | null; created_at: string;
};
type Detail = {
  inquiry: Msg & { has_vec: boolean };
  transcript: { role: string; text: string; provider: string | null; ts: string }[];
  similar: { id: string; name: string; company: string | null; message: string; dist: number; created_at: string }[];
};

export function InquiriesManager() {
  const [list, setList] = React.useState<Msg[]>([]);
  const [series, setSeries] = React.useState<{ day: string; n: number }[]>([]);
  const [filter, setFilter] = React.useState<"all" | "new" | "handled">("all");
  const [q, setQ] = React.useState("");
  const [sel, setSel] = React.useState<string | null>(null);
  const [detail, setDetail] = React.useState<Detail | null>(null);
  const [note, setNote] = React.useState("");

  const load = React.useCallback(async () => {
    const res = await fetch("/api/admin/contact");
    if (res.ok) { const d = await res.json(); setList(d.messages); setSeries(d.series ?? []); }
  }, []);
  React.useEffect(() => { void load(); }, [load]);

  const openDetail = React.useCallback(async (id: string) => {
    setSel(id); setDetail(null);
    const res = await fetch(`/api/admin/contact?id=${id}`);
    if (res.ok) { const d = await res.json(); setDetail(d); setNote(d.inquiry.admin_note ?? ""); }
  }, []);

  async function patch(id: string, body: Record<string, unknown>) {
    await fetch("/api/admin/contact", { method: "PATCH", headers: { "content-type": "application/json" }, body: JSON.stringify({ id, ...body }) });
    await load(); if (sel === id) await openDetail(id);
  }

  const total = list.length;
  const newCount = list.filter((m) => !m.handled).length;
  const responded = list.filter((m) => m.responded_at).length;

  const filtered = list.filter((m) => {
    if (filter === "new" && m.handled) return false;
    if (filter === "handled" && !m.handled) return false;
    if (q) { const s = q.toLowerCase(); return [m.name, m.email, m.company, m.message].some((v) => (v ?? "").toLowerCase().includes(s)); }
    return true;
  });

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-xl font-semibold tracking-tight">Inquiries</h2>
        <p className="text-sm text-muted-foreground">Analyze, respond to, and manage contact requests — with the linked chat and similar leads.</p>
      </div>

      {/* KPIs + chart */}
      <div className="grid gap-4 lg:grid-cols-3">
        <div className="grid grid-cols-3 gap-4 lg:col-span-1 lg:grid-cols-1">
          <Kpi icon={Inbox} label="Total" value={total} />
          <Kpi icon={MailCheck} label="New" value={newCount} accent={newCount > 0} />
          <Kpi icon={Reply} label="Responded" value={responded} />
        </div>
        <Card className="lg:col-span-2">
          <CardHeader className="pb-2"><CardTitle className="text-sm">Inquiries — last 30 days</CardTitle></CardHeader>
          <CardContent>
            <div className="h-40 w-full">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={series} margin={{ left: -28, right: 6, top: 4 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" vertical={false} />
                  <XAxis dataKey="day" tickFormatter={(d: string) => d.slice(5)} tick={{ fontSize: 10, fill: "hsl(var(--muted-foreground))" }} tickLine={false} axisLine={false} interval="preserveStartEnd" />
                  <RTooltip contentStyle={{ background: "hsl(var(--popover))", border: "1px solid hsl(var(--border))", borderRadius: 8, fontSize: 12 }} />
                  <Bar dataKey="n" name="Inquiries" fill="hsl(var(--primary))" radius={[3, 3, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* filter + search */}
      <div className="flex flex-wrap items-center justify-between gap-3">
        <Tabs value={filter} onValueChange={(v) => setFilter(v as typeof filter)}>
          <TabsList>
            <TabsTrigger value="all">All</TabsTrigger>
            <TabsTrigger value="new">New{newCount > 0 ? ` (${newCount})` : ""}</TabsTrigger>
            <TabsTrigger value="handled">Handled</TabsTrigger>
          </TabsList>
        </Tabs>
        <div className="relative w-full max-w-xs">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input className="pl-8" placeholder="Search name, email, message…" value={q} onChange={(e) => setQ(e.target.value)} />
        </div>
      </div>

      {/* list + detail */}
      <div className="grid gap-4 lg:grid-cols-5">
        <div className="space-y-2 lg:col-span-2">
          {filtered.length === 0 && <p className="rounded-lg border border-dashed border-border p-6 text-center text-sm text-muted-foreground">No inquiries.</p>}
          {filtered.map((m) => (
            <button key={m.id} onClick={() => openDetail(m.id)}
              className={cn("w-full rounded-lg border p-3 text-left transition-colors",
                sel === m.id ? "border-primary bg-primary/5" : "border-border hover:bg-accent")}>
              <div className="flex items-center justify-between gap-2">
                <span className="truncate text-sm font-medium">{m.name}{m.company ? ` · ${m.company}` : ""}</span>
                <div className="flex shrink-0 items-center gap-1">
                  {m.session_id && <MessageSquare className="h-3.5 w-3.5 text-primary" aria-label="Has chat" />}
                  {m.handled ? <Badge variant="secondary">handled</Badge> : <Badge>new</Badge>}
                </div>
              </div>
              <p className="mt-1 line-clamp-2 text-xs text-muted-foreground">{m.message}</p>
              <div className="mt-1 text-[11px] text-muted-foreground/70">{new Date(m.created_at).toLocaleString()} · {m.locale}{m.page ? ` · ${m.page}` : ""}</div>
            </button>
          ))}
        </div>

        <div className="lg:col-span-3">
          {!sel && <Card><CardContent className="p-8 text-center text-sm text-muted-foreground">Select an inquiry to view details, the linked chat, and similar leads.</CardContent></Card>}
          {sel && !detail && <Card><CardContent className="p-8 text-center text-sm text-muted-foreground">Loading…</CardContent></Card>}
          {detail && (
            <Card>
              <CardContent className="space-y-5 p-5">
                <div className="flex flex-wrap items-start justify-between gap-3">
                  <div>
                    <div className="text-base font-semibold">{detail.inquiry.name}</div>
                    <a href={`mailto:${detail.inquiry.email}`} className="text-sm text-primary underline underline-offset-2">{detail.inquiry.email}</a>
                    <div className="mt-0.5 text-xs text-muted-foreground">
                      {detail.inquiry.company ?? "—"} · {new Date(detail.inquiry.created_at).toLocaleString()} · {detail.inquiry.locale}{detail.inquiry.page ? ` · ${detail.inquiry.page}` : ""}
                    </div>
                  </div>
                  <div className="flex gap-2">
                    <Button size="sm" variant={detail.inquiry.handled ? "secondary" : "default"} onClick={() => patch(detail.inquiry.id, { handled: !detail.inquiry.handled })}>
                      {detail.inquiry.handled ? "Handled ✓" : "Mark handled"}
                    </Button>
                    <Button size="sm" variant="outline" asChild>
                      <a href={`mailto:${detail.inquiry.email}?subject=${encodeURIComponent("Re: your OXOT enquiry")}`} onClick={() => patch(detail.inquiry.id, { responded: true })}>
                        <Reply className="h-4 w-4" /> Reply
                      </a>
                    </Button>
                  </div>
                </div>

                <div className="rounded-lg bg-muted/40 p-3 text-sm whitespace-pre-wrap">{detail.inquiry.message}</div>

                {/* linked chat transcript */}
                {detail.inquiry.session_id && (
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

                {/* similar inquiries */}
                {detail.similar.length > 0 && (
                  <div>
                    <div className="mb-2 flex items-center gap-2 text-xs font-semibold uppercase tracking-wide text-muted-foreground"><Sparkles className="h-3.5 w-3.5" /> Similar inquiries</div>
                    <div className="space-y-1.5">
                      {detail.similar.map((s) => (
                        <button key={s.id} onClick={() => openDetail(s.id)} className="flex w-full items-center justify-between gap-2 rounded-md border border-border px-3 py-1.5 text-left text-xs hover:bg-accent">
                          <span className="truncate">{s.name}{s.company ? ` · ${s.company}` : ""} — <span className="text-muted-foreground">{s.message}</span></span>
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
                    <Button size="sm" variant="outline" onClick={() => patch(detail.inquiry.id, { adminNote: note })}>Save note</Button>
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
