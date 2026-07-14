"use client";
import * as React from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs";
import {
  Mail, Plus, Pencil, Trash2, Send, Clock, Users, Share2,
  AlertTriangle, CheckCircle2, XCircle, Linkedin
} from "lucide-react";

// Ported from Celestial-Agent-Nexus/artifacts/oxot-web/src/pages/admin-newsletter.tsx,
// re-styled to this app's admin look (plain inputs like integrations-manager,
// shadcn Button/Badge/Tabs/Input/Textarea). Wires to the /api/admin/newsletters,
// /api/admin/newsletter-subscribers and /api/admin/social route handlers.

const inp = "w-full rounded-md border border-border bg-background px-3 py-2 text-sm";
const lbl = "text-xs font-semibold uppercase tracking-[0.15em] text-muted-foreground";

function XIcon({ className }: { className?: string }) {
  return (
    <svg viewBox="0 0 24 24" fill="currentColor" className={className} aria-hidden="true">
      <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24h-6.66l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231 5.45-6.231Zm-1.161 17.52h1.833L7.084 4.126H5.117L17.083 19.77Z" />
    </svg>
  );
}

function fmtDate(value: string | null): string {
  if (!value) return "—";
  return new Date(value).toLocaleString(undefined, { dateStyle: "medium", timeStyle: "short" });
}

type Newsletter = {
  id: number; subject: string; preheader: string | null; contentMarkdown: string;
  topic: string | null; locale: string; status: string; scheduledAt: string | null;
  sentAt: string | null; recipientCount: number; sentCount: number; failedCount: number;
  openedCount: number; createdAt: string; updatedAt: string;
};
type Subscriber = {
  id: number; email: string; status: string; locale: string; source: string | null;
  confirmedAt: string | null; unsubscribedAt: string | null; createdAt: string;
};
type SocialPost = {
  id: number; platform: string; success: boolean; error: string | null;
  text: string; source: string; createdAt: string;
};
type SocialData = {
  status: { linkedin: { configured: boolean }; x: { configured: boolean } };
  recentPosts: SocialPost[];
};

const EDITABLE = new Set(["draft", "scheduled", "failed"]);

function statusVariant(status: string): "default" | "secondary" | "destructive" | "outline" {
  if (status === "sent") return "default";
  if (status === "sending" || status === "scheduled") return "secondary";
  if (status === "failed") return "destructive";
  return "outline";
}

// --- Campaigns -------------------------------------------------------------

function CampaignsTab({ notify }: { notify: (kind: "ok" | "err", msg: string) => void }) {
  const [items, setItems] = React.useState<Newsletter[]>([]);
  const [loading, setLoading] = React.useState(true);
  const [editing, setEditing] = React.useState<Newsletter | null>(null);
  const [creating, setCreating] = React.useState(false);
  const [scheduling, setScheduling] = React.useState<Newsletter | null>(null);
  const [busy, setBusy] = React.useState(false);

  const load = React.useCallback(async () => {
    setLoading(true);
    try {
      const res = await fetch("/api/admin/newsletters");
      if (res.ok) setItems((await res.json()) as Newsletter[]);
    } finally { setLoading(false); }
  }, []);
  React.useEffect(() => { void load(); }, [load]);

  const onSend = async (n: Newsletter) => {
    if (!window.confirm(`Send "${n.subject}" now to all confirmed ${n.locale.toUpperCase()} subscribers?`)) return;
    setBusy(true);
    try {
      const res = await fetch(`/api/admin/newsletters/${n.id}/send`, { method: "POST" });
      if (!res.ok) { const e = await res.json().catch(() => ({})); notify("err", e.error ?? "Could not send"); return; }
      notify("ok", "Send complete. Delivery counts updated.");
      await load();
    } finally { setBusy(false); }
  };

  const onDelete = async (n: Newsletter) => {
    if (!window.confirm(`Delete "${n.subject}"? This cannot be undone.`)) return;
    const res = await fetch(`/api/admin/newsletters/${n.id}`, { method: "DELETE" });
    if (res.ok) { notify("ok", "Newsletter deleted"); await load(); }
    else notify("err", "Could not delete");
  };

  return (
    <div className="space-y-4">
      <div className="flex justify-end">
        <Button onClick={() => setCreating(true)}><Plus className="h-4 w-4" /> New newsletter</Button>
      </div>

      <div className="overflow-x-auto rounded-xl border border-border">
        <table className="w-full text-sm">
          <thead className="border-b border-border bg-muted/40 text-left text-xs uppercase tracking-wide text-muted-foreground">
            <tr>
              <th className="px-4 py-2">Subject</th>
              <th className="px-4 py-2">Status</th>
              <th className="px-4 py-2 text-right">Recipients</th>
              <th className="px-4 py-2 text-right">Opens</th>
              <th className="px-4 py-2">When</th>
              <th className="px-4 py-2 text-right">Actions</th>
            </tr>
          </thead>
          <tbody>
            {loading && <tr><td colSpan={6} className="px-4 py-8 text-center text-muted-foreground">Loading…</td></tr>}
            {!loading && items.length === 0 && (
              <tr><td colSpan={6} className="px-4 py-10 text-center text-muted-foreground">No newsletters yet. Create your first draft.</td></tr>
            )}
            {items.map((n) => {
              const editable = EDITABLE.has(n.status);
              return (
                <tr key={n.id} className="border-b border-border last:border-0">
                  <td className="px-4 py-2">
                    <div className="font-medium">{n.subject}</div>
                    <div className="text-xs text-muted-foreground">{n.topic ? `${n.topic} · ` : ""}{n.locale.toUpperCase()}</div>
                  </td>
                  <td className="px-4 py-2"><Badge variant={statusVariant(n.status)} className="capitalize">{n.status}</Badge></td>
                  <td className="px-4 py-2 text-right tabular-nums">
                    {n.status === "sent" || n.status === "sending" ? `${n.sentCount}/${n.recipientCount}` : "—"}
                    {n.failedCount > 0 && <span className="ml-1 text-xs text-destructive">({n.failedCount} failed)</span>}
                  </td>
                  <td className="px-4 py-2 text-right tabular-nums">{n.status === "sent" ? n.openedCount : "—"}</td>
                  <td className="px-4 py-2 text-sm text-muted-foreground">
                    {n.status === "scheduled" ? `Scheduled ${fmtDate(n.scheduledAt)}` : n.status === "sent" ? `Sent ${fmtDate(n.sentAt)}` : fmtDate(n.createdAt)}
                  </td>
                  <td className="px-4 py-2">
                    <div className="flex items-center justify-end gap-1">
                      {editable && <Button size="icon" variant="ghost" title="Edit" onClick={() => setEditing(n)}><Pencil className="h-4 w-4" /></Button>}
                      {editable && <Button size="icon" variant="ghost" title="Send now" disabled={busy} onClick={() => onSend(n)}><Send className="h-4 w-4" /></Button>}
                      {editable && <Button size="icon" variant="ghost" title="Schedule" onClick={() => setScheduling(n)}><Clock className="h-4 w-4" /></Button>}
                      <Button size="icon" variant="ghost" title="Delete" onClick={() => onDelete(n)}><Trash2 className="h-4 w-4 text-destructive" /></Button>
                    </div>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>

      {(creating || editing) && (
        <NewsletterDialog
          newsletter={editing}
          onClose={() => { setCreating(false); setEditing(null); }}
          onSaved={async () => { setCreating(false); setEditing(null); await load(); notify("ok", "Saved"); }}
          onError={(m) => notify("err", m)}
        />
      )}
      {scheduling && (
        <ScheduleDialog
          newsletter={scheduling}
          onClose={() => setScheduling(null)}
          onSaved={async () => { setScheduling(null); await load(); notify("ok", "Newsletter scheduled"); }}
          onError={(m) => notify("err", m)}
        />
      )}
    </div>
  );
}

function Modal({ title, children, onClose }: { title: string; children: React.ReactNode; onClose: () => void }) {
  return (
    <div className="fixed inset-0 z-50 flex items-start justify-center overflow-y-auto bg-black/50 p-4" onClick={onClose}>
      <div className="mt-12 w-full max-w-2xl rounded-xl border border-border bg-card p-6 shadow-lg" onClick={(e) => e.stopPropagation()}>
        <h3 className="mb-4 text-lg font-semibold">{title}</h3>
        {children}
      </div>
    </div>
  );
}

function NewsletterDialog({
  newsletter, onClose, onSaved, onError
}: { newsletter: Newsletter | null; onClose: () => void; onSaved: () => void; onError: (m: string) => void }) {
  const [subject, setSubject] = React.useState(newsletter?.subject ?? "");
  const [topic, setTopic] = React.useState(newsletter?.topic ?? "");
  const [preheader, setPreheader] = React.useState(newsletter?.preheader ?? "");
  const [locale, setLocale] = React.useState(newsletter?.locale ?? "en");
  const [content, setContent] = React.useState(newsletter?.contentMarkdown ?? "");
  const [saving, setSaving] = React.useState(false);

  const onSave = async () => {
    if (!subject.trim() || !content.trim()) { onError("Subject and content are required"); return; }
    setSaving(true);
    try {
      const body = { subject: subject.trim(), preheader: preheader.trim() || null, contentMarkdown: content, topic: topic.trim() || null, locale };
      const res = await fetch(
        newsletter ? `/api/admin/newsletters/${newsletter.id}` : "/api/admin/newsletters",
        { method: newsletter ? "PUT" : "POST", headers: { "content-type": "application/json" }, body: JSON.stringify(body) }
      );
      if (!res.ok) { const e = await res.json().catch(() => ({})); onError(e.error ?? "Could not save"); return; }
      onSaved();
    } finally { setSaving(false); }
  };

  return (
    <Modal title={newsletter ? "Edit newsletter" : "New newsletter"} onClose={onClose}>
      <div className="space-y-4">
        <div className="grid grid-cols-1 gap-3 sm:grid-cols-3">
          <div className="space-y-1.5 sm:col-span-2">
            <label className={lbl}>Topic</label>
            <input className={inp} value={topic} onChange={(e) => setTopic(e.target.value)} placeholder="e.g. AI Act, CRA, NIS2" />
          </div>
          <div className="space-y-1.5">
            <label className={lbl}>Language</label>
            <select className={inp} value={locale} onChange={(e) => setLocale(e.target.value)}>
              <option value="en">English</option>
              <option value="nl">Dutch</option>
            </select>
          </div>
        </div>
        <div className="space-y-1.5">
          <label className={lbl}>Subject</label>
          <Input value={subject} onChange={(e) => setSubject(e.target.value)} placeholder="Subject line" />
        </div>
        <div className="space-y-1.5">
          <label className={lbl}>Preheader (inbox preview)</label>
          <Input value={preheader} onChange={(e) => setPreheader(e.target.value)} placeholder="One-line preview shown in the inbox" />
        </div>
        <div className="space-y-1.5">
          <label className={lbl}>Content (Markdown)</label>
          <Textarea value={content} onChange={(e) => setContent(e.target.value)} rows={12} placeholder="## Heading&#10;&#10;Body text with **markdown**…" className="font-mono text-sm" />
        </div>
      </div>
      <div className="mt-6 flex justify-end gap-2">
        <Button variant="outline" onClick={onClose}>Cancel</Button>
        <Button onClick={onSave} disabled={saving}>{saving ? "Saving…" : "Save"}</Button>
      </div>
    </Modal>
  );
}

function ScheduleDialog({
  newsletter, onClose, onSaved, onError
}: { newsletter: Newsletter; onClose: () => void; onSaved: () => void; onError: (m: string) => void }) {
  const [when, setWhen] = React.useState("");
  const [saving, setSaving] = React.useState(false);
  const onSubmit = async () => {
    if (!when) return;
    setSaving(true);
    try {
      const res = await fetch(`/api/admin/newsletters/${newsletter.id}/schedule`, {
        method: "POST", headers: { "content-type": "application/json" },
        body: JSON.stringify({ scheduledAt: new Date(when).toISOString() })
      });
      if (!res.ok) { const e = await res.json().catch(() => ({})); onError(e.error ?? "Could not schedule"); return; }
      onSaved();
    } finally { setSaving(false); }
  };
  return (
    <Modal title="Schedule newsletter" onClose={onClose}>
      <p className="mb-3 text-sm text-muted-foreground">{newsletter.subject}</p>
      <div className="space-y-1.5">
        <label className={lbl}>Send at</label>
        <input type="datetime-local" className={inp} value={when} onChange={(e) => setWhen(e.target.value)} />
        <p className="text-xs text-muted-foreground">Stored as a scheduled time. You can also send manually from the list.</p>
      </div>
      <div className="mt-6 flex justify-end gap-2">
        <Button variant="outline" onClick={onClose}>Cancel</Button>
        <Button onClick={onSubmit} disabled={!when || saving}>{saving ? "Scheduling…" : "Schedule"}</Button>
      </div>
    </Modal>
  );
}

// --- Subscribers -----------------------------------------------------------

function SubscribersTab({ notify }: { notify: (kind: "ok" | "err", msg: string) => void }) {
  const [subs, setSubs] = React.useState<Subscriber[]>([]);
  const [loading, setLoading] = React.useState(true);
  const [q, setQ] = React.useState("");
  const [status, setStatus] = React.useState("all");

  const load = React.useCallback(async () => {
    setLoading(true);
    try {
      const res = await fetch("/api/admin/newsletter-subscribers");
      if (res.ok) setSubs((await res.json()) as Subscriber[]);
    } finally { setLoading(false); }
  }, []);
  React.useEffect(() => { void load(); }, [load]);

  const filtered = subs.filter((s) => {
    if (status !== "all" && s.status !== status) return false;
    if (q && !s.email.toLowerCase().includes(q.toLowerCase())) return false;
    return true;
  });
  const counts = {
    confirmed: subs.filter((s) => s.status === "confirmed").length,
    pending: subs.filter((s) => s.status === "pending").length,
    unsubscribed: subs.filter((s) => s.status === "unsubscribed").length
  };

  const onDelete = async (s: Subscriber) => {
    if (!window.confirm(`Delete ${s.email}? This permanently removes their record (GDPR erasure).`)) return;
    const res = await fetch(`/api/admin/newsletter-subscribers?id=${s.id}`, { method: "DELETE" });
    if (res.ok) { notify("ok", "Subscriber deleted"); await load(); }
    else notify("err", "Could not delete");
  };

  const onExport = () => {
    const header = "email,status,locale,source,confirmed_at,created_at";
    const csv = [header, ...subs.map((s) =>
      [s.email, s.status, s.locale, s.source ?? "", s.confirmedAt ?? "", s.createdAt].map((v) => `"${String(v).replace(/"/g, '""')}"`).join(",")
    )].join("\n");
    const url = URL.createObjectURL(new Blob([csv], { type: "text/csv" }));
    const a = document.createElement("a");
    a.href = url; a.download = "subscribers.csv"; a.click();
    URL.revokeObjectURL(url);
  };

  return (
    <div className="space-y-4">
      <div className="grid grid-cols-3 gap-3">
        {(["confirmed", "pending", "unsubscribed"] as const).map((k) => (
          <div key={k} className="rounded-xl border border-border bg-card p-4">
            <div className="text-2xl font-bold tabular-nums">{counts[k]}</div>
            <div className="text-xs capitalize text-muted-foreground">{k}</div>
          </div>
        ))}
      </div>

      <div className="flex flex-col gap-2 sm:flex-row sm:items-center">
        <input className={`${inp} max-w-xs`} placeholder="Search by email…" value={q} onChange={(e) => setQ(e.target.value)} />
        <select className={`${inp} w-44`} value={status} onChange={(e) => setStatus(e.target.value)}>
          <option value="all">All statuses</option>
          <option value="confirmed">Confirmed</option>
          <option value="pending">Pending</option>
          <option value="unsubscribed">Unsubscribed</option>
        </select>
        <Button variant="outline" onClick={onExport} className="sm:ml-auto">Export CSV</Button>
      </div>

      <div className="overflow-x-auto rounded-xl border border-border">
        <table className="w-full text-sm">
          <thead className="border-b border-border bg-muted/40 text-left text-xs uppercase tracking-wide text-muted-foreground">
            <tr>
              <th className="px-4 py-2">Email</th>
              <th className="px-4 py-2">Status</th>
              <th className="px-4 py-2">Language</th>
              <th className="px-4 py-2">Source</th>
              <th className="px-4 py-2">Confirmed</th>
              <th className="px-4 py-2 text-right">Actions</th>
            </tr>
          </thead>
          <tbody>
            {loading && <tr><td colSpan={6} className="px-4 py-8 text-center text-muted-foreground">Loading…</td></tr>}
            {!loading && filtered.length === 0 && <tr><td colSpan={6} className="px-4 py-10 text-center text-muted-foreground">No subscribers found.</td></tr>}
            {filtered.map((s) => (
              <tr key={s.id} className="border-b border-border last:border-0">
                <td className="px-4 py-2 font-medium">{s.email}</td>
                <td className="px-4 py-2">
                  <Badge variant={s.status === "confirmed" ? "default" : s.status === "pending" ? "outline" : "secondary"} className="capitalize">{s.status}</Badge>
                </td>
                <td className="px-4 py-2 text-sm uppercase">{s.locale}</td>
                <td className="px-4 py-2 text-sm text-muted-foreground">{s.source ?? "—"}</td>
                <td className="px-4 py-2 text-sm text-muted-foreground">{fmtDate(s.confirmedAt)}</td>
                <td className="px-4 py-2 text-right">
                  <Button size="icon" variant="ghost" title="Delete" onClick={() => onDelete(s)}><Trash2 className="h-4 w-4 text-destructive" /></Button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

// --- Social ----------------------------------------------------------------

function PlatformCard({ icon, name, configured, description }: { icon: React.ReactNode; name: string; configured: boolean; description: string }) {
  return (
    <div className={`space-y-2 rounded-xl border p-4 ${configured ? "border-emerald-300 bg-emerald-500/5" : "border-amber-300 bg-amber-500/5"}`}>
      <div className="flex items-center gap-2">
        {icon}<span className="text-sm font-semibold">{name}</span>
        {configured ? <CheckCircle2 className="ml-auto h-4 w-4 text-emerald-500" /> : <XCircle className="ml-auto h-4 w-4 text-amber-500" />}
      </div>
      <p className="text-xs text-muted-foreground">{description}</p>
      {!configured && <p className="text-xs font-medium text-amber-700 dark:text-amber-400">Enter and enable this platform on the Integrations page.</p>}
    </div>
  );
}

function SocialTab({ notify }: { notify: (kind: "ok" | "err", msg: string) => void }) {
  const [data, setData] = React.useState<SocialData | null>(null);
  const [text, setText] = React.useState("");
  const [platforms, setPlatforms] = React.useState<Set<"linkedin" | "x">>(new Set());
  const [posting, setPosting] = React.useState(false);

  const load = React.useCallback(async () => {
    const res = await fetch("/api/admin/social");
    if (res.ok) setData((await res.json()) as SocialData);
  }, []);
  React.useEffect(() => { void load(); }, [load]);

  const linkedInConfigured = data?.status.linkedin.configured ?? false;
  const xConfigured = data?.status.x.configured ?? false;
  const anyConfigured = linkedInConfigured || xConfigured;

  const toggle = (p: "linkedin" | "x") => setPlatforms((prev) => {
    const next = new Set(prev);
    if (next.has(p)) next.delete(p); else next.add(p);
    return next;
  });

  const onPost = async () => {
    if (!text.trim() || platforms.size === 0) return;
    setPosting(true);
    try {
      const res = await fetch("/api/admin/social", {
        method: "POST", headers: { "content-type": "application/json" },
        body: JSON.stringify({ text: text.trim(), platforms: Array.from(platforms) })
      });
      if (!res.ok) { const e = await res.json().catch(() => ({})); notify("err", e.error ?? "Could not post"); return; }
      const j = (await res.json()) as { results: { platform: string; success: boolean; error: string | null }[] };
      const allOk = j.results.every((r) => r.success);
      notify(allOk ? "ok" : "err", allOk ? "Posted successfully" : "Some posts failed — see the log below");
      setText("");
      await load();
    } finally { setPosting(false); }
  };

  return (
    <div className="space-y-6">
      <div>
        <h3 className="mb-3 text-sm font-semibold">Platform credentials</h3>
        <div className="grid grid-cols-1 gap-3 sm:grid-cols-2">
          <PlatformCard icon={<Linkedin className="h-4 w-4 text-[#0077B5]" />} name="LinkedIn" configured={linkedInConfigured}
            description="Posts via UGC Posts v2. Author URN format: urn:li:organization:12345" />
          <PlatformCard icon={<XIcon className="h-4 w-4" />} name="X (Twitter)" configured={xConfigured}
            description="Posts via API v2 with OAuth 1.0a. Requires an X app with read+write permissions." />
        </div>
      </div>

      <div className="space-y-3">
        <h3 className="text-sm font-semibold">Compose a post</h3>
        {!anyConfigured ? (
          <div className="rounded-xl border border-dashed border-border p-6 text-center text-sm text-muted-foreground">
            Add credentials for at least one platform on the Integrations page to enable posting.
          </div>
        ) : (
          <>
            <div className="space-y-1.5">
              <label className={lbl}>Post text</label>
              <Textarea value={text} onChange={(e) => setText(e.target.value)} rows={4} maxLength={3000} placeholder="What would you like to share?" />
              <p className="text-right text-xs text-muted-foreground">{text.length}/3000</p>
            </div>
            <div className="flex items-center gap-4">
              <span className="text-sm font-medium">Post to:</span>
              {linkedInConfigured && (
                <label className="flex cursor-pointer select-none items-center gap-1.5 text-sm">
                  <input type="checkbox" checked={platforms.has("linkedin")} onChange={() => toggle("linkedin")} />
                  <Linkedin className="h-4 w-4 text-[#0077B5]" /> LinkedIn
                </label>
              )}
              {xConfigured && (
                <label className="flex cursor-pointer select-none items-center gap-1.5 text-sm">
                  <input type="checkbox" checked={platforms.has("x")} onChange={() => toggle("x")} />
                  <XIcon className="h-4 w-4" /> X
                </label>
              )}
            </div>
            <Button onClick={onPost} disabled={!text.trim() || platforms.size === 0 || posting}>
              <Send className="h-4 w-4" /> {posting ? "Posting…" : "Post now"}
            </Button>
          </>
        )}
      </div>

      <div className="space-y-3">
        <div className="flex items-center justify-between">
          <h3 className="text-sm font-semibold">Recent posts</h3>
          <Button size="sm" variant="ghost" onClick={() => load()}>Refresh</Button>
        </div>
        <p className="text-xs text-muted-foreground">Every attempt is logged here. Failures show the reason so you can act on expired tokens or quota limits.</p>
        {!data || data.recentPosts.length === 0 ? (
          <div className="rounded-xl border border-dashed border-border p-6 text-center text-sm text-muted-foreground">No posts yet.</div>
        ) : (
          <div className="space-y-2">
            {data.recentPosts.map((p) => (
              <div key={p.id} className={`flex items-start gap-2 rounded-md border p-3 text-sm ${p.success ? "border-emerald-300 bg-emerald-500/5" : "border-destructive/30 bg-destructive/5"}`}>
                {p.success ? <CheckCircle2 className="mt-0.5 h-4 w-4 shrink-0 text-emerald-500" /> : <XCircle className="mt-0.5 h-4 w-4 shrink-0 text-destructive" />}
                <div className="min-w-0 flex-1">
                  <div className="flex flex-wrap items-center gap-2">
                    {p.platform === "linkedin" ? <Linkedin className="h-3.5 w-3.5 text-[#0077B5]" /> : <XIcon className="h-3.5 w-3.5" />}
                    <span className="font-medium capitalize">{p.platform}</span>
                    <Badge variant="outline" className="text-[10px] capitalize">{p.source}</Badge>
                    <span className="ml-auto text-xs text-muted-foreground">{fmtDate(p.createdAt)}</span>
                  </div>
                  {p.error ? <p className="mt-1 break-words text-xs text-destructive">{p.error}</p> : p.text && <p className="mt-1 line-clamp-2 text-xs text-muted-foreground">{p.text}</p>}
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

// --- Root ------------------------------------------------------------------

export function NewsletterSocialManager() {
  const [tab, setTab] = React.useState("campaigns");
  const [emailConfigured, setEmailConfigured] = React.useState<boolean | null>(null);
  const [banner, setBanner] = React.useState<{ kind: "ok" | "err"; msg: string } | null>(null);

  React.useEffect(() => {
    void (async () => {
      const res = await fetch("/api/admin/integrations");
      if (!res.ok) return;
      const d = (await res.json()) as { emailEnabled: boolean; smtpHost: string; smtpFromEmail: string; smtpUsername: string; smtpPasswordSet: boolean };
      setEmailConfigured(Boolean(d.emailEnabled && d.smtpHost && d.smtpFromEmail && d.smtpUsername && d.smtpPasswordSet));
    })();
  }, []);

  const notify = React.useCallback((kind: "ok" | "err", msg: string) => {
    setBanner({ kind, msg });
    window.setTimeout(() => setBanner(null), 4000);
  }, []);

  return (
    <section className="space-y-6">
      <div className="flex items-center gap-3">
        <Mail className="h-6 w-6 text-primary" />
        <div>
          <h2 className="text-lg font-semibold">Newsletter &amp; Social</h2>
          <p className="text-sm text-muted-foreground">Create, schedule and send compliance updates — and share them on social media.</p>
        </div>
      </div>

      {banner && (
        <div className={`flex items-center gap-2 rounded-lg border p-3 text-sm ${banner.kind === "ok" ? "border-primary/30 bg-primary/5" : "border-red-500/30 bg-red-500/5"}`}>
          {banner.kind === "ok" ? <CheckCircle2 className="h-4 w-4 text-primary" /> : <XCircle className="h-4 w-4 text-red-500" />}
          {banner.msg}
        </div>
      )}

      {emailConfigured === false && (
        <div className="flex items-start gap-3 rounded-lg border border-amber-300 bg-amber-500/10 p-4">
          <AlertTriangle className="mt-0.5 h-5 w-5 shrink-0 text-amber-600" />
          <div className="text-sm">
            <div className="font-semibold">Email sending isn&apos;t connected yet</div>
            <p className="text-muted-foreground">You can create, edit and schedule newsletters now. To deliver confirmation emails and campaigns, connect the email provider on the Integrations page. Until then, sends are recorded but not delivered.</p>
          </div>
        </div>
      )}

      <Tabs value={tab} onValueChange={setTab}>
        <TabsList>
          <TabsTrigger value="campaigns"><Mail className="mr-2 h-4 w-4" /> Campaigns</TabsTrigger>
          <TabsTrigger value="subscribers"><Users className="mr-2 h-4 w-4" /> Subscribers</TabsTrigger>
          <TabsTrigger value="social"><Share2 className="mr-2 h-4 w-4" /> Social</TabsTrigger>
        </TabsList>
        <TabsContent value="campaigns"><CampaignsTab notify={notify} /></TabsContent>
        <TabsContent value="subscribers"><SubscribersTab notify={notify} /></TabsContent>
        <TabsContent value="social"><SocialTab notify={notify} /></TabsContent>
      </Tabs>
    </section>
  );
}
