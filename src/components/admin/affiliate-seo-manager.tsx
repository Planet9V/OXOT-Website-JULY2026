"use client";
import * as React from "react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs";
import {
  Link2, Search, Plus, Pencil, Trash2, Save, CheckCircle2, XCircle, ExternalLink, Sparkles,
} from "lucide-react";
import { SetupGuide, HelpTip } from "@/components/admin/setup-guide";

// Ported from the source Affiliate & SEO admin (Celestial-Agent-Nexus:
// artifacts/oxot-web/src/pages/admin-seo.tsx). Adapted to this app's plain
// admin styling (matches integrations-manager.tsx) and raw-pg backed routes.
// The "AI Link Insertion" tab (source: admin-seo.tsx AiInsertionTab, backed by
// suggestAffiliateLinks/applyAffiliateLinks) is adapted to this app's
// single-body page model: instead of scanning page-section JSON, it scans a
// page's markdown `body` directly (see src/lib/affiliate.ts).

const inp = "w-full rounded-md border border-border bg-background px-3 py-2 text-sm";
const lbl = "text-xs font-semibold uppercase tracking-[0.15em] text-muted-foreground";

function Toggle({ on, onChange, label }: { on: boolean; onChange: (v: boolean) => void; label?: string }) {
  return (
    <button
      type="button"
      role="switch"
      aria-checked={on}
      aria-label={label}
      onClick={() => onChange(!on)}
      className={`relative inline-flex h-6 w-11 shrink-0 items-center rounded-full transition-colors ${on ? "bg-primary" : "bg-muted"}`}
    >
      <span className={`inline-block h-5 w-5 transform rounded-full bg-background shadow transition-transform ${on ? "translate-x-5" : "translate-x-0.5"}`} />
    </button>
  );
}

type Status = { kind: "idle" | "ok" | "err"; msg: string };

function StatusBar({ status }: { status: Status }) {
  if (status.kind === "idle") return null;
  return (
    <div className={`flex items-center gap-2 rounded-lg border p-3 text-sm ${status.kind === "ok" ? "border-primary/30 bg-primary/5 text-foreground" : "border-red-500/30 bg-red-500/5 text-foreground"}`}>
      {status.kind === "ok" ? <CheckCircle2 className="h-4 w-4 text-primary" /> : <XCircle className="h-4 w-4 text-red-500" />}
      {status.msg}
    </div>
  );
}

// --- Affiliate tab -------------------------------------------------------

type Keyword = { id: number; keyword: string; locale: string; active: boolean };
type AffiliateLink = {
  id: number; name: string; targetUrl: string; description: string | null;
  sponsored: boolean; active: boolean; clickCount: number; keywords: Keyword[];
};

type LinkForm = {
  name: string; targetUrl: string; description: string;
  sponsored: boolean; active: boolean; keywordsEn: string; keywordsNl: string;
};

const EMPTY_LINK: LinkForm = {
  name: "", targetUrl: "", description: "", sponsored: true, active: true, keywordsEn: "", keywordsNl: "",
};

function keywordsToText(link: AffiliateLink | null, locale: string): string {
  if (!link) return "";
  return link.keywords.filter((k) => k.locale === locale).map((k) => k.keyword).join(", ");
}

function AffiliateTab() {
  const [links, setLinks] = React.useState<AffiliateLink[]>([]);
  const [editing, setEditing] = React.useState<AffiliateLink | null>(null);
  const [showForm, setShowForm] = React.useState(false);
  const [form, setForm] = React.useState<LinkForm>(EMPTY_LINK);
  const [status, setStatus] = React.useState<Status>({ kind: "idle", msg: "" });
  const [busy, setBusy] = React.useState(false);

  const load = React.useCallback(async () => {
    const res = await fetch("/api/admin/affiliate");
    if (res.ok) setLinks(((await res.json()) as { links: AffiliateLink[] }).links);
  }, []);
  React.useEffect(() => { void load(); }, [load]);

  function openNew() {
    setEditing(null);
    setForm(EMPTY_LINK);
    setShowForm(true);
    setStatus({ kind: "idle", msg: "" });
  }
  function openEdit(link: AffiliateLink) {
    setEditing(link);
    setForm({
      name: link.name, targetUrl: link.targetUrl, description: link.description ?? "",
      sponsored: link.sponsored, active: link.active,
      keywordsEn: keywordsToText(link, "en"), keywordsNl: keywordsToText(link, "nl"),
    });
    setShowForm(true);
    setStatus({ kind: "idle", msg: "" });
  }

  function buildBody() {
    const parse = (raw: string, locale: "en" | "nl") =>
      raw.split(/[,\n]/).map((s) => s.trim()).filter(Boolean).map((keyword) => ({ keyword, locale, active: true }));
    return {
      name: form.name.trim(),
      targetUrl: form.targetUrl.trim(),
      description: form.description.trim() || null,
      sponsored: form.sponsored,
      active: form.active,
      keywords: [...parse(form.keywordsEn, "en"), ...parse(form.keywordsNl, "nl")],
    };
  }

  async function save() {
    if (!form.name.trim() || !form.targetUrl.trim()) {
      setStatus({ kind: "err", msg: "Name and target URL are required." });
      return;
    }
    setBusy(true); setStatus({ kind: "idle", msg: "" });
    try {
      const url = editing ? `/api/admin/affiliate/${editing.id}` : "/api/admin/affiliate";
      const res = await fetch(url, {
        method: editing ? "PUT" : "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify(buildBody()),
      });
      if (!res.ok) {
        const e = (await res.json().catch(() => ({}))) as { error?: string };
        setStatus({ kind: "err", msg: e.error ?? "Could not save link." });
        return;
      }
      setStatus({ kind: "ok", msg: editing ? "Link updated." : "Link created." });
      setShowForm(false);
      await load();
    } finally { setBusy(false); }
  }

  async function remove(id: number) {
    const res = await fetch(`/api/admin/affiliate/${id}`, { method: "DELETE" });
    if (res.ok) { setStatus({ kind: "ok", msg: "Link deleted." }); await load(); }
    else setStatus({ kind: "err", msg: "Could not delete link." });
  }

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between gap-3">
        <p className="text-sm text-muted-foreground">
          Partner links and the keywords behind them. Public copy links through the tracked redirect
          <code className="mx-1 rounded bg-muted px-1">/api/go/&lt;id&gt;</code> so every click is recorded.
        </p>
        <Button onClick={openNew}><Plus className="h-4 w-4" /> New link</Button>
      </div>

      <StatusBar status={status} />

      {showForm && (
        <div className="rounded-xl border border-border p-5 space-y-4">
          <h3 className="font-semibold">{editing ? "Edit affiliate link" : "New affiliate link"}</h3>
          <div className="grid gap-4 sm:grid-cols-2">
            <div>
              <label className={lbl}>Name</label>
              <input className={`${inp} mt-1`} value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} placeholder="Partner name" />
            </div>
            <div>
              <label className={lbl}>Target URL</label>
              <input className={`${inp} mt-1`} value={form.targetUrl} onChange={(e) => setForm({ ...form, targetUrl: e.target.value })} placeholder="https://partner.example.com/offer" />
            </div>
            <div className="sm:col-span-2">
              <label className={lbl}>Description</label>
              <textarea className={`${inp} mt-1 h-16`} value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} placeholder="Internal note about this partner" />
            </div>
            <div>
              <label className={lbl}>Keywords (EN)</label>
              <textarea className={`${inp} mt-1 h-20`} value={form.keywordsEn} onChange={(e) => setForm({ ...form, keywordsEn: e.target.value })} placeholder="comma or line separated" />
            </div>
            <div>
              <label className={lbl}>Keywords (NL)</label>
              <textarea className={`${inp} mt-1 h-20`} value={form.keywordsNl} onChange={(e) => setForm({ ...form, keywordsNl: e.target.value })} placeholder="komma of regel gescheiden" />
            </div>
          </div>
          <div className="flex flex-wrap items-center gap-6">
            <div className="flex items-center gap-2"><Toggle on={form.sponsored} onChange={(v) => setForm({ ...form, sponsored: v })} label="Sponsored" /><span className="text-sm">Sponsored</span></div>
            <div className="flex items-center gap-2"><Toggle on={form.active} onChange={(v) => setForm({ ...form, active: v })} label="Active" /><span className="text-sm">Active</span></div>
          </div>
          <div className="flex items-center gap-2">
            <Button onClick={save} disabled={busy}><Save className="h-4 w-4" /> {busy ? "Saving…" : "Save"}</Button>
            <Button variant="outline" onClick={() => setShowForm(false)} disabled={busy}>Cancel</Button>
          </div>
        </div>
      )}

      <div className="overflow-x-auto rounded-xl border border-border">
        <table className="w-full text-sm">
          <thead className="border-b border-border bg-muted/40 text-left text-xs uppercase tracking-wide text-muted-foreground">
            <tr>
              <th className="px-4 py-2">Name</th>
              <th className="px-4 py-2">Keywords</th>
              <th className="px-4 py-2 text-right">Clicks</th>
              <th className="px-4 py-2">Status</th>
              <th className="px-4 py-2 text-right">Actions</th>
            </tr>
          </thead>
          <tbody>
            {links.map((link) => (
              <tr key={link.id} className="border-b border-border/60 last:border-0 hover:bg-muted/30">
                <td className="px-4 py-2">
                  <div className="font-medium">{link.name}</div>
                  <a href={link.targetUrl} target="_blank" rel="noopener noreferrer" className="flex max-w-[220px] items-center gap-1 truncate text-xs text-muted-foreground hover:text-primary">
                    <ExternalLink className="h-3 w-3 shrink-0" /> <span className="truncate">{link.targetUrl}</span>
                  </a>
                </td>
                <td className="px-4 py-2">
                  <div className="flex max-w-[260px] flex-wrap gap-1">
                    {link.keywords.length === 0 ? <span className="text-xs text-muted-foreground">—</span> :
                      link.keywords.map((k) => (
                        <Badge key={k.id} variant="secondary" className="text-xs">{k.keyword}<span className="ml-1 uppercase opacity-60">{k.locale}</span></Badge>
                      ))}
                  </div>
                </td>
                <td className="px-4 py-2 text-right tabular-nums">{link.clickCount}</td>
                <td className="px-4 py-2">
                  <div className="flex gap-1">
                    <Badge variant={link.active ? "success" : "outline"}>{link.active ? "Active" : "Off"}</Badge>
                    {link.sponsored && <Badge variant="outline" className="text-xs">Sponsored</Badge>}
                  </div>
                </td>
                <td className="px-4 py-2">
                  <div className="flex justify-end gap-1">
                    <Button variant="ghost" size="icon" title="Edit" onClick={() => openEdit(link)}><Pencil className="h-4 w-4" /></Button>
                    <Button variant="ghost" size="icon" title="Delete" onClick={() => remove(link.id)}><Trash2 className="h-4 w-4 text-destructive" /></Button>
                  </div>
                </td>
              </tr>
            ))}
            {!links.length && <tr><td colSpan={5} className="px-4 py-6 text-center text-muted-foreground">No affiliate links yet. Create one to start tracking partner clicks.</td></tr>}
          </tbody>
        </table>
      </div>
    </div>
  );
}

// --- AI Link Insertion tab ------------------------------------------------

type PageOption = { slug: string; locale: string; title: string; published: boolean };

type Suggestion = {
  affiliateLinkId: number;
  linkName: string;
  keyword: string;
  snippet: string;
  occurrenceIndex: number;
};

const AI_INSERT_SETUP_STEPS: React.ReactNode[] = [
  <>In the &quot;Affiliate Links&quot; tab, click &quot;New link&quot; and add the partner name, destination URL, and one or more keywords (per language).</>,
  <>Come back to this tab, choose a page, and click &quot;Suggest links&quot; — it finds where those keywords appear in the page.</>,
  <>Review each suggestion (keyword + surrounding text) and tick the ones to turn into tracked links.</>,
  <>Click &quot;Apply&quot; — the keywords become tracked <code className="rounded bg-muted px-1">/api/go/&lt;id&gt;</code> links. The page&apos;s previous version is saved to history, so you can restore it anytime.</>
];

function AiInsertTab() {
  const [pages, setPages] = React.useState<PageOption[]>([]);
  const [pageKey, setPageKey] = React.useState("");
  const [suggestions, setSuggestions] = React.useState<Suggestion[]>([]);
  const [selected, setSelected] = React.useState<Set<number>>(new Set());
  const [status, setStatus] = React.useState<Status>({ kind: "idle", msg: "" });
  const [busy, setBusy] = React.useState(false);

  React.useEffect(() => {
    (async () => {
      const res = await fetch("/api/admin/pages");
      if (res.ok) setPages(((await res.json()) as { pages: PageOption[] }).pages);
    })();
  }, []);

  const [slug, locale] = pageKey ? pageKey.split("::") : ["", ""];

  async function runSuggest() {
    if (!slug || !locale) return;
    setBusy(true);
    setStatus({ kind: "idle", msg: "" });
    setSuggestions([]);
    setSelected(new Set());
    try {
      const res = await fetch("/api/admin/affiliate/suggest", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ slug, locale }),
      });
      const data = (await res.json().catch(() => ({}))) as { suggestions?: Suggestion[]; error?: string };
      if (!res.ok) {
        setStatus({ kind: "err", msg: data.error ?? "Could not generate suggestions." });
        return;
      }
      const found = data.suggestions ?? [];
      setSuggestions(found);
      setSelected(new Set(found.map((_, i) => i)));
      if (found.length === 0) setStatus({ kind: "ok", msg: "No keyword matches found for this page." });
    } finally {
      setBusy(false);
    }
  }

  async function runApply() {
    const chosen = suggestions.filter((_, i) => selected.has(i));
    if (chosen.length === 0) return;
    setBusy(true);
    setStatus({ kind: "idle", msg: "" });
    try {
      const res = await fetch("/api/admin/affiliate/apply", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({
          slug,
          locale,
          selections: chosen.map((s) => ({
            affiliateLinkId: s.affiliateLinkId,
            keyword: s.keyword,
            occurrenceIndex: s.occurrenceIndex,
          })),
        }),
      });
      const data = (await res.json().catch(() => ({}))) as { inserted?: number; error?: string };
      if (!res.ok) {
        setStatus({ kind: "err", msg: data.error ?? "Could not apply links." });
        return;
      }
      setStatus({
        kind: "ok",
        msg: `Inserted ${data.inserted ?? 0} link(s) into the page. The prior version is saved in page history.`,
      });
      setSuggestions([]);
      setSelected(new Set());
    } finally {
      setBusy(false);
    }
  }

  function toggle(i: number) {
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(i)) next.delete(i);
      else next.add(i);
      return next;
    });
  }

  return (
    <div className="space-y-4">
      <div className="flex flex-wrap items-start justify-between gap-3">
        <p className="text-sm text-muted-foreground">
          Find keyword matches in a page&apos;s body and turn them into tracked partner links
          (<code className="mx-1 rounded bg-muted px-1">/api/go/&lt;id&gt;</code>). The page&apos;s
          current content is snapshotted to history before anything changes.
        </p>
        <SetupGuide title="AI Link Insertion setup guide" steps={AI_INSERT_SETUP_STEPS} />
      </div>

      <StatusBar status={status} />

      <div className="flex flex-wrap items-end gap-3">
        <div className="min-w-[260px]">
          <label className={lbl}>Page <HelpTip text="Pick the page whose body should be scanned for affiliate keyword matches. Only pages with existing affiliate links/keywords will produce suggestions." /></label>
          <select
            className={`${inp} mt-1`}
            value={pageKey}
            onChange={(e) => {
              setPageKey(e.target.value);
              setSuggestions([]);
              setSelected(new Set());
              setStatus({ kind: "idle", msg: "" });
            }}
          >
            <option value="">Choose a page…</option>
            {pages.map((p) => (
              <option key={`${p.slug}::${p.locale}`} value={`${p.slug}::${p.locale}`}>
                {p.title} · /{p.slug} ({p.locale})
              </option>
            ))}
          </select>
        </div>
        <Button onClick={runSuggest} disabled={!pageKey || busy}>
          <Sparkles className="h-4 w-4" /> {busy && suggestions.length === 0 ? "Analyzing…" : "Suggest links"}
        </Button>
        <HelpTip text="Scans the selected page's body for any active affiliate keyword and lists each match so you can choose which ones to convert into tracked links." />
      </div>

      {suggestions.length > 0 && (
        <div className="divide-y divide-border overflow-hidden rounded-xl border border-border">
          {suggestions.map((s, i) => (
            <label key={i} className="flex cursor-pointer items-start gap-3 p-4 hover:bg-muted/30">
              <input
                type="checkbox"
                className="mt-1 h-4 w-4"
                checked={selected.has(i)}
                onChange={() => toggle(i)}
              />
              <div className="min-w-0">
                <div className="flex flex-wrap items-center gap-2">
                  <Badge variant="secondary">{s.linkName}</Badge>
                  <span className="text-sm font-medium">&quot;{s.keyword}&quot;</span>
                </div>
                <p className="mt-1 text-sm text-muted-foreground">{s.snippet}</p>
              </div>
            </label>
          ))}
          <div className="flex justify-end p-4">
            <Button onClick={runApply} disabled={busy || selected.size === 0}>
              {busy ? "Applying…" : `Apply ${selected.size} to page`}
            </Button>
          </div>
        </div>
      )}
    </div>
  );
}

// --- SEO tab -------------------------------------------------------------

type SeoPage = {
  id: number; slug: string; locale: string; title: string; published: boolean;
  metaTitle: string | null; metaDescription: string | null; metaKeywords: string | null;
  canonicalUrl: string | null; ogTitle: string | null; ogDescription: string | null;
  ogImage: string | null; noindex: boolean;
};

type SeoForm = {
  metaTitle: string; metaDescription: string; metaKeywords: string; canonicalUrl: string;
  ogTitle: string; ogDescription: string; ogImage: string; noindex: boolean;
};

function SeoTab() {
  const [pages, setPages] = React.useState<SeoPage[]>([]);
  const [editing, setEditing] = React.useState<SeoPage | null>(null);
  const [form, setForm] = React.useState<SeoForm | null>(null);
  const [status, setStatus] = React.useState<Status>({ kind: "idle", msg: "" });
  const [busy, setBusy] = React.useState(false);

  const load = React.useCallback(async () => {
    const res = await fetch("/api/admin/seo");
    if (res.ok) setPages(((await res.json()) as { pages: SeoPage[] }).pages);
  }, []);
  React.useEffect(() => { void load(); }, [load]);

  function openEdit(p: SeoPage) {
    setEditing(p);
    setForm({
      metaTitle: p.metaTitle ?? "", metaDescription: p.metaDescription ?? "", metaKeywords: p.metaKeywords ?? "",
      canonicalUrl: p.canonicalUrl ?? "", ogTitle: p.ogTitle ?? "", ogDescription: p.ogDescription ?? "",
      ogImage: p.ogImage ?? "", noindex: p.noindex,
    });
    setStatus({ kind: "idle", msg: "" });
  }

  async function save() {
    if (!editing || !form) return;
    setBusy(true); setStatus({ kind: "idle", msg: "" });
    try {
      const res = await fetch("/api/admin/seo", {
        method: "PUT",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({
          id: editing.id,
          metaTitle: form.metaTitle.trim() || null,
          metaDescription: form.metaDescription.trim() || null,
          metaKeywords: form.metaKeywords.trim() || null,
          canonicalUrl: form.canonicalUrl.trim() || null,
          ogTitle: form.ogTitle.trim() || null,
          ogDescription: form.ogDescription.trim() || null,
          ogImage: form.ogImage.trim() || null,
          noindex: form.noindex,
        }),
      });
      if (!res.ok) {
        const e = (await res.json().catch(() => ({}))) as { error?: string };
        setStatus({ kind: "err", msg: e.error ?? "Could not save metadata." });
        return;
      }
      setStatus({ kind: "ok", msg: "SEO metadata saved." });
      setEditing(null); setForm(null);
      await load();
    } finally { setBusy(false); }
  }

  return (
    <div className="space-y-4">
      <p className="text-sm text-muted-foreground">
        Per-page meta title, description, keywords, canonical URL, social (Open Graph) cards and indexing.
        Written to the existing <code className="rounded bg-muted px-1">pages</code> columns rendered on the public site.
      </p>

      <StatusBar status={status} />

      {editing && form && (
        <div className="rounded-xl border border-border p-5 space-y-4">
          <h3 className="font-semibold">SEO · {editing.title} <span className="text-xs font-normal text-muted-foreground">/{editing.slug} · {editing.locale}</span></h3>
          <div className="grid gap-4 sm:grid-cols-2">
            <div className="sm:col-span-2">
              <label className={lbl}>Meta title</label>
              <input className={`${inp} mt-1`} value={form.metaTitle} onChange={(e) => setForm({ ...form, metaTitle: e.target.value })} placeholder="≈60 chars" />
            </div>
            <div className="sm:col-span-2">
              <label className={lbl}>Meta description</label>
              <textarea className={`${inp} mt-1 h-16`} value={form.metaDescription} onChange={(e) => setForm({ ...form, metaDescription: e.target.value })} placeholder="≤160 chars" />
            </div>
            <div>
              <label className={lbl}>Meta keywords</label>
              <input className={`${inp} mt-1`} value={form.metaKeywords} onChange={(e) => setForm({ ...form, metaKeywords: e.target.value })} placeholder="comma, separated, keywords" />
            </div>
            <div>
              <label className={lbl}>Canonical URL</label>
              <input className={`${inp} mt-1`} value={form.canonicalUrl} onChange={(e) => setForm({ ...form, canonicalUrl: e.target.value })} placeholder="https://oxot.eu/…" />
            </div>
          </div>
          <div className="border-t border-border pt-4">
            <p className="mb-3 text-sm font-medium">Social sharing (Open Graph)</p>
            <div className="grid gap-4 sm:grid-cols-2">
              <div>
                <label className={lbl}>OG title</label>
                <input className={`${inp} mt-1`} value={form.ogTitle} onChange={(e) => setForm({ ...form, ogTitle: e.target.value })} />
              </div>
              <div>
                <label className={lbl}>OG image URL</label>
                <input className={`${inp} mt-1`} value={form.ogImage} onChange={(e) => setForm({ ...form, ogImage: e.target.value })} placeholder="https://…/share.png" />
              </div>
              <div className="sm:col-span-2">
                <label className={lbl}>OG description</label>
                <textarea className={`${inp} mt-1 h-16`} value={form.ogDescription} onChange={(e) => setForm({ ...form, ogDescription: e.target.value })} />
              </div>
            </div>
          </div>
          <div className="flex items-center gap-2 border-t border-border pt-4">
            <Toggle on={form.noindex} onChange={(v) => setForm({ ...form, noindex: v })} label="Hide from search engines" />
            <div>
              <span className="text-sm">Hide from search engines</span>
              <p className="text-xs text-muted-foreground">Adds noindex,nofollow to this page.</p>
            </div>
          </div>
          <div className="flex items-center gap-2">
            <Button onClick={save} disabled={busy}><Save className="h-4 w-4" /> {busy ? "Saving…" : "Save"}</Button>
            <Button variant="outline" onClick={() => { setEditing(null); setForm(null); }} disabled={busy}>Cancel</Button>
          </div>
        </div>
      )}

      <div className="overflow-x-auto rounded-xl border border-border">
        <table className="w-full text-sm">
          <thead className="border-b border-border bg-muted/40 text-left text-xs uppercase tracking-wide text-muted-foreground">
            <tr>
              <th className="px-4 py-2">Page</th>
              <th className="px-4 py-2">Meta title</th>
              <th className="px-4 py-2">Indexing</th>
              <th className="px-4 py-2 text-right">Actions</th>
            </tr>
          </thead>
          <tbody>
            {pages.map((p) => (
              <tr key={p.id} className="border-b border-border/60 last:border-0 hover:bg-muted/30">
                <td className="px-4 py-2">
                  <div className="font-medium">{p.title}</div>
                  <div className="text-xs text-muted-foreground">/{p.slug} · {p.locale} · {p.published ? "published" : "draft"}</div>
                </td>
                <td className="max-w-[280px] px-4 py-2">
                  <span className="line-clamp-1 text-muted-foreground">{p.metaTitle || <span className="italic opacity-60">Uses page title</span>}</span>
                </td>
                <td className="px-4 py-2">{p.noindex ? <Badge variant="outline">noindex</Badge> : <Badge variant="secondary">indexed</Badge>}</td>
                <td className="px-4 py-2">
                  <div className="flex justify-end">
                    <Button variant="ghost" size="icon" title="Edit SEO" onClick={() => openEdit(p)}><Pencil className="h-4 w-4" /></Button>
                  </div>
                </td>
              </tr>
            ))}
            {!pages.length && <tr><td colSpan={4} className="px-4 py-6 text-center text-muted-foreground">No pages yet.</td></tr>}
          </tbody>
        </table>
      </div>
    </div>
  );
}

// --- Manager -------------------------------------------------------------

export function AffiliateSeoManager() {
  return (
    <section className="space-y-6">
      <div>
        <h2 className="text-lg font-semibold">Affiliate &amp; SEO</h2>
        <p className="text-sm text-muted-foreground">Partner links with tracked clicks, and per-page search &amp; social metadata.</p>
      </div>
      <Tabs defaultValue="affiliate">
        <TabsList>
          <TabsTrigger value="affiliate"><Link2 className="mr-2 h-4 w-4" /> Affiliate Links</TabsTrigger>
          <TabsTrigger value="ai-insert"><Sparkles className="mr-2 h-4 w-4" /> AI Link Insertion</TabsTrigger>
          <TabsTrigger value="seo"><Search className="mr-2 h-4 w-4" /> SEO Metadata</TabsTrigger>
        </TabsList>
        <TabsContent value="affiliate"><AffiliateTab /></TabsContent>
        <TabsContent value="ai-insert"><AiInsertTab /></TabsContent>
        <TabsContent value="seo"><SeoTab /></TabsContent>
      </Tabs>
    </section>
  );
}
