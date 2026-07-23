"use client";
// Visual block Page Builder (docs/BLOCK-CMS-PLAN.md Phase 3, rebuilt).
// Modeled on the Celestial-Agent-Nexus admin editor: collapsible section cards
// with a generic VISUAL form (ObjectFields) for every block — no JSON — plus a
// live preview pane showing the real ?blocks=1 render. Composes/edits the
// flagship CDT + Conformity pages and any new dynamic page from a grouped
// palette of all block types. Saves via /api/admin/pages/blocks (snapshot-first;
// live-preview writes skip the snapshot).
import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import {
  Plus, Trash2, Copy, ChevronUp, ChevronDown, Save, ExternalLink, FilePlus2, Braces, RefreshCw, Loader2, Sparkles, Wand2
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { ObjectFields } from "@/components/admin/object-fields";
import { BLOCK_SCHEMAS, schemaFor } from "@/lib/blocks/schema";
import type { BlockType } from "@/lib/blocks/types";

type WBlock = { type: BlockType; config: Record<string, unknown> };
type Status = { kind: "idle" | "ok" | "err" | "busy"; msg: string };

const KNOWN_PAGES = [
  { slug: "home", label: "Home page" },
  { slug: "cyber-digital-twin", label: "Cyber Digital Twin" },
  { slug: "conformity", label: "Conformity page" }
];

const CATEGORY_LABEL: Record<string, string> = { generic: "Building blocks", cra: "Home / CRA", cdt: "Cyber Digital Twin", conformity: "Conformity" };
const CATEGORY_ORDER = ["generic", "cra", "cdt", "conformity"];

// Turn a slug into a readable label for pages the flagship list doesn't name.
function labelForSlug(slug: string): string {
  return slug.replace(/-/g, " ").replace(/\b\w/g, (c) => c.toUpperCase());
}
type PageOption = { slug: string; label: string; contentType?: string };

export function PageBuilder() {
  const [slug, setSlug] = useState("cyber-digital-twin");
  const [locale, setLocale] = useState<"en" | "nl">("en");
  const [blocks, setBlocks] = useState<WBlock[]>([]);
  const [open, setOpen] = useState<number | null>(0);
  const [advanced, setAdvanced] = useState<Set<number>>(new Set());
  const [dirty, setDirty] = useState(false);
  const [status, setStatus] = useState<Status>({ kind: "idle", msg: "" });
  const [adding, setAdding] = useState(false);
  const [previewKey, setPreviewKey] = useState(0);
  const previewTimer = useRef<ReturnType<typeof setTimeout> | null>(null);
  // AI assist state
  const [aiOpen, setAiOpen] = useState<number | null>(null);
  const [aiText, setAiText] = useState("");
  const [aiBusy, setAiBusy] = useState<number | "page" | null>(null);
  // All selectable pages: the flagship three, merged with every page in the DB
  // (deduped by slug) so migrated + newly-created block pages are editable here.
  const [pages, setPages] = useState<PageOption[]>(KNOWN_PAGES);

  const loadPages = useCallback(async () => {
    try {
      const res = await fetch("/api/admin/pages");
      const d = await res.json();
      const rows: { slug: string; contentType?: string }[] = d.pages ?? [];
      const bySlug = new Map<string, PageOption>();
      for (const p of KNOWN_PAGES) bySlug.set(p.slug, { ...p });
      for (const r of rows) {
        if (!bySlug.has(r.slug)) bySlug.set(r.slug, { slug: r.slug, label: labelForSlug(r.slug), contentType: r.contentType });
        else bySlug.get(r.slug)!.contentType = r.contentType;
      }
      setPages([...bySlug.values()].sort((a, b) =>
        (KNOWN_PAGES.some((k) => k.slug === b.slug) ? 1 : 0) - (KNOWN_PAGES.some((k) => k.slug === a.slug) ? 1 : 0)
        || a.label.localeCompare(b.label)));
    } catch { /* keep flagship defaults */ }
  }, []);
  useEffect(() => { void loadPages(); }, [loadPages]);

  const load = useCallback(async (s: string, l: string) => {
    setStatus({ kind: "busy", msg: "Loading…" });
    try {
      const res = await fetch(`/api/admin/pages/blocks?slug=${encodeURIComponent(s)}&locale=${l}`);
      const d = await res.json();
      const loaded: WBlock[] = (d.blocks ?? []).map((b: { type: BlockType; config: unknown }) => ({ type: b.type, config: (b.config ?? {}) as Record<string, unknown> }));
      setBlocks(loaded); setOpen(loaded.length ? 0 : null); setDirty(false);
      setStatus({ kind: "idle", msg: `${loaded.length} block(s) loaded.` });
      setPreviewKey((k) => k + 1);
    } catch { setStatus({ kind: "err", msg: "Failed to load blocks." }); }
  }, []);

  useEffect(() => { void load(slug, locale); }, [slug, locale, load]);
  useEffect(() => {
    const h = (e: BeforeUnloadEvent) => { if (dirty) { e.preventDefault(); e.returnValue = ""; } };
    window.addEventListener("beforeunload", h);
    return () => window.removeEventListener("beforeunload", h);
  }, [dirty]);

  // Persist to page_blocks. preview=true skips the version snapshot and refreshes
  // the live preview; an explicit save records a snapshot.
  const persist = useCallback(async (next: WBlock[], preview: boolean) => {
    const res = await fetch("/api/admin/pages/blocks", {
      method: "PUT", headers: { "content-type": "application/json" },
      body: JSON.stringify({ slug, locale, blocks: next, preview })
    });
    const d = await res.json().catch(() => ({}));
    if (!res.ok) throw new Error(d.error ?? "save failed");
    return d.count as number;
  }, [slug, locale]);

  // Debounced live-preview apply on every edit.
  const schedulePreview = useCallback((next: WBlock[]) => {
    if (previewTimer.current) clearTimeout(previewTimer.current);
    previewTimer.current = setTimeout(async () => {
      try { await persist(next, true); setPreviewKey((k) => k + 1); } catch { /* preview best-effort */ }
    }, 1200);
  }, [persist]);

  const mutate = (next: WBlock[], keepOpen = open) => { setBlocks(next); setDirty(true); setOpen(keepOpen); schedulePreview(next); };

  const addBlock = (type: BlockType) => {
    const cfg = (schemaFor(type)?.defaultConfig() ?? {}) as Record<string, unknown>;
    const next = [...blocks, { type, config: cfg }];
    mutate(next, next.length - 1); setAdding(false);
  };
  const move = (i: number, d: number) => { const j = i + d; if (j < 0 || j >= blocks.length) return; const n = blocks.slice(); [n[i], n[j]] = [n[j], n[i]]; mutate(n, j); };
  const duplicate = (i: number) => { const n = blocks.slice(); n.splice(i + 1, 0, { type: blocks[i].type, config: structuredClone(blocks[i].config) }); mutate(n, i + 1); };
  const remove = (i: number) => { const n = blocks.filter((_, k) => k !== i); mutate(n, n.length ? Math.max(0, i - 1) : null); };
  const setConfig = (i: number, config: Record<string, unknown>) => mutate(blocks.map((b, k) => (k === i ? { ...b, config } : b)), open);

  // AI: rewrite one block's copy on-brand (keeps the same JSON shape).
  const aiImprove = async (i: number) => {
    setAiBusy(i);
    try {
      const res = await fetch("/api/admin/pages/blocks/assist", {
        method: "POST", headers: { "content-type": "application/json" },
        body: JSON.stringify({ mode: "block-copy", blockType: blocks[i].type, config: blocks[i].config, instruction: aiText, locale })
      });
      const d = await res.json();
      if (!res.ok) { setStatus({ kind: "err", msg: d.error ?? "AI failed." }); return; }
      setConfig(i, d.config as Record<string, unknown>);
      setStatus({ kind: "ok", msg: "AI updated this block's copy — review, then Save." });
      setAiOpen(null); setAiText("");
    } catch { setStatus({ kind: "err", msg: "AI request failed." }); }
    finally { setAiBusy(null); }
  };

  // AI: draft a whole page of blocks from a brief (appends to the current page).
  const aiDraftPage = async () => {
    const brief = window.prompt("Describe the page you want (topic, audience, sections):")?.trim();
    if (!brief) return;
    setAiBusy("page"); setStatus({ kind: "busy", msg: "AI is drafting the page…" });
    try {
      const res = await fetch("/api/admin/pages/blocks/assist", {
        method: "POST", headers: { "content-type": "application/json" },
        body: JSON.stringify({ mode: "page-draft", instruction: brief, locale })
      });
      const d = await res.json();
      if (!res.ok) { setStatus({ kind: "err", msg: d.error ?? "AI failed." }); return; }
      const drafted = (d.blocks ?? []) as WBlock[];
      if (drafted.length === 0) { setStatus({ kind: "err", msg: "AI returned no blocks." }); return; }
      const next = [...blocks, ...drafted.map((b) => ({ type: b.type, config: (b.config ?? {}) as Record<string, unknown> }))];
      mutate(next, blocks.length);
      setStatus({ kind: "ok", msg: `AI added ${drafted.length} block(s) — review, then Save.` });
    } catch { setStatus({ kind: "err", msg: "AI request failed." }); }
    finally { setAiBusy(null); }
  };

  const save = async () => {
    setStatus({ kind: "busy", msg: "Saving…" });
    try { const c = await persist(blocks, false); setDirty(false); setStatus({ kind: "ok", msg: `Saved ${c} block(s) — a version snapshot was recorded.` }); setPreviewKey((k) => k + 1); }
    catch (e) { setStatus({ kind: "err", msg: (e as Error).message }); }
  };

  const newPage = async () => {
    const s = window.prompt("New page slug (e.g. 'about-us'):")?.trim(); if (!s) return;
    const title = window.prompt("Page title:")?.trim() || s;
    setStatus({ kind: "busy", msg: "Creating page…" });
    const res = await fetch("/api/admin/pages", { method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify({ slug: s, locale, title, body: "", published: false, contentType: "blocks" }) });
    if (!res.ok) { const d = await res.json().catch(() => ({})); setStatus({ kind: "err", msg: d.error ?? "Create failed." }); return; }
    setSlug(s); setBlocks([]); setOpen(null); setDirty(false); void loadPages();
    setStatus({ kind: "ok", msg: `Page '${s}' created (${locale}). Add blocks, then Save. Publish it in Pages to go live.` });
  };

  // The palette: EVERY block type, grouped by category, so any page type can be built.
  const grouped = useMemo(() => {
    const g: Record<string, BlockType[]> = {};
    for (const s of Object.values(BLOCK_SCHEMAS)) (g[s.category] ??= []).push(s.type);
    return g;
  }, []);

  // Home lives at the locale root (/{locale}); every other page at /{locale}/{slug}.
  const pagePath = slug === "home" ? `/${locale}` : `/${locale}/${slug}`;
  const previewSrc = `${pagePath}?blocks=1&pv=${previewKey}`;

  return (
    <div className="space-y-4">
      {/* Toolbar */}
      <Card>
        <CardContent className="flex flex-wrap items-center gap-3 py-3">
          <select className="h-9 rounded-md border border-border bg-background px-2 text-sm" value={slug}
            onChange={(e) => { if (dirty && !confirm("Discard unsaved changes?")) return; setSlug(e.target.value); }}>
            {pages.map((p) => (
              <option key={p.slug} value={p.slug}>
                {p.label}{p.contentType && p.contentType !== "blocks" && !KNOWN_PAGES.some((k) => k.slug === p.slug) ? "  (markdown)" : ""}
              </option>
            ))}
            {!pages.some((p) => p.slug === slug) ? <option value={slug}>{slug}</option> : null}
          </select>
          <div className="inline-flex overflow-hidden rounded-md border border-border">
            {(["en", "nl"] as const).map((l) => (
              <button key={l} onClick={() => { if (dirty && !confirm("Discard unsaved changes?")) return; setLocale(l); }}
                className={`px-3 py-1.5 text-xs font-medium ${locale === l ? "bg-primary text-primary-foreground" : "text-muted-foreground hover:bg-accent"}`}>{l.toUpperCase()}</button>
            ))}
          </div>
          <div className="ml-auto flex items-center gap-2">
            <Button size="sm" variant="outline" onClick={aiDraftPage} disabled={aiBusy === "page"}>
              {aiBusy === "page" ? <Loader2 className="h-4 w-4 animate-spin" /> : <Wand2 className="h-4 w-4" />} AI draft
            </Button>
            <Button size="sm" variant="outline" onClick={newPage}><FilePlus2 className="h-4 w-4" /> New page</Button>
            <Button size="sm" variant="outline" onClick={() => window.open(`${pagePath}?blocks=1`, "_blank")}><ExternalLink className="h-4 w-4" /> Open</Button>
            <Button size="sm" onClick={save} disabled={status.kind === "busy" || !dirty}>
              {status.kind === "busy" ? <Loader2 className="h-4 w-4 animate-spin" /> : <Save className="h-4 w-4" />} Save
            </Button>
          </div>
          {status.msg ? <p className={`w-full text-xs ${status.kind === "err" ? "text-destructive" : status.kind === "ok" ? "text-primary" : "text-muted-foreground"}`}>{status.msg}</p> : null}
        </CardContent>
      </Card>

      <div className="grid gap-4 lg:grid-cols-2">
        {/* Editor column */}
        <div className="space-y-3">
          <div className="flex items-center justify-between">
            <h2 className="text-sm font-semibold text-foreground">Sections ({blocks.length})</h2>
            <div className="relative">
              <Button size="sm" variant="outline" onClick={() => setAdding((v) => !v)}><Plus className="h-4 w-4" /> Add block</Button>
              {adding ? (
                <div className="absolute right-0 z-30 mt-1 max-h-96 w-72 overflow-auto rounded-md border border-border bg-popover p-1 shadow-lg">
                  {CATEGORY_ORDER.filter((c) => grouped[c]?.length).map((cat) => (
                    <div key={cat}>
                      <p className="px-2 py-1 text-[10px] font-semibold uppercase tracking-wide text-muted-foreground">{CATEGORY_LABEL[cat] ?? cat}</p>
                      {grouped[cat].map((t) => {
                        const s = schemaFor(t);
                        return (
                          <button key={t} onClick={() => addBlock(t)} className="block w-full rounded px-2 py-1.5 text-left text-sm hover:bg-accent">
                            <span className="font-medium text-foreground">{s?.label ?? t}</span>
                            {s?.hint ? <span className="block text-xs text-muted-foreground">{s.hint}</span> : null}
                          </button>
                        );
                      })}
                    </div>
                  ))}
                </div>
              ) : null}
            </div>
          </div>

          {blocks.length === 0 ? (
            <div className="rounded-xl border border-dashed border-border bg-muted/30 p-10 text-center text-sm text-muted-foreground">
              No sections yet. Add one with “Add block”.
            </div>
          ) : null}

          {blocks.map((b, i) => {
            const isOpen = open === i;
            const isAdv = advanced.has(i);
            return (
              <Card key={i} className="overflow-hidden">
                <button className="flex w-full items-center gap-2 px-4 py-3 text-left" onClick={() => setOpen(isOpen ? null : i)}>
                  <span className="w-5 text-xs tabular-nums text-muted-foreground">{i + 1}.</span>
                  <span className="flex-1 truncate text-sm font-medium text-foreground">{schemaFor(b.type)?.label ?? b.type}</span>
                  <Badge variant="secondary" className="shrink-0 font-mono text-[10px]">{b.type}</Badge>
                  {isOpen ? <ChevronUp className="h-4 w-4 text-muted-foreground" /> : <ChevronDown className="h-4 w-4 text-muted-foreground" />}
                </button>
                {isOpen ? (
                  <CardContent className="border-t border-border pt-3">
                    <div className="mb-3 flex items-center justify-end gap-1">
                      <Button size="icon" variant="ghost" className="h-7 w-7" onClick={() => move(i, -1)} disabled={i === 0} title="Move up"><ChevronUp className="h-3.5 w-3.5" /></Button>
                      <Button size="icon" variant="ghost" className="h-7 w-7" onClick={() => move(i, 1)} disabled={i === blocks.length - 1} title="Move down"><ChevronDown className="h-3.5 w-3.5" /></Button>
                      <Button size="icon" variant="ghost" className="h-7 w-7" onClick={() => duplicate(i)} title="Duplicate"><Copy className="h-3.5 w-3.5" /></Button>
                      <Button size="icon" variant="ghost" className="h-7 w-7 text-destructive" onClick={() => remove(i)} title="Delete"><Trash2 className="h-3.5 w-3.5" /></Button>
                      <Button size="sm" variant="ghost" className="h-7 gap-1 text-xs text-primary" onClick={() => { setAiOpen(aiOpen === i ? null : i); setAiText(""); }}>
                        <Sparkles className="h-3.5 w-3.5" /> AI
                      </Button>
                      <Button size="sm" variant="ghost" className="h-7 gap-1 text-xs" onClick={() => setAdvanced((s) => { const n = new Set(s); n.has(i) ? n.delete(i) : n.add(i); return n; })}>
                        <Braces className="h-3.5 w-3.5" /> {isAdv ? "Form" : "JSON"}
                      </Button>
                    </div>
                    {aiOpen === i ? (
                      <div className="mb-3 rounded-md border border-primary/40 bg-primary/5 p-3">
                        <p className="mb-2 text-xs font-medium text-primary">AI — improve this section's copy (on-brand, same layout)</p>
                        <div className="flex gap-2">
                          <input
                            className="h-9 flex-1 rounded-md border border-border bg-background px-3 text-sm"
                            placeholder="e.g. make it punchier · add urgency about the CRA deadline · shorten"
                            value={aiText}
                            onChange={(e) => setAiText(e.target.value)}
                            onKeyDown={(e) => { if (e.key === "Enter" && aiBusy !== i) aiImprove(i); }}
                          />
                          <Button size="sm" onClick={() => aiImprove(i)} disabled={aiBusy === i}>
                            {aiBusy === i ? <Loader2 className="h-4 w-4 animate-spin" /> : <Wand2 className="h-4 w-4" />} Improve
                          </Button>
                        </div>
                        <p className="mt-1.5 text-[11px] text-muted-foreground">Leave blank to just tighten and align to the styleguide. Review the result, then Save.</p>
                      </div>
                    ) : null}
                    {isAdv
                      ? <JsonEditor value={b.config} onChange={(cfg) => setConfig(i, cfg)} />
                      : <ObjectFields value={b.config} onChange={(cfg) => setConfig(i, cfg)} />}
                  </CardContent>
                ) : null}
              </Card>
            );
          })}
        </div>

        {/* Live preview column */}
        <div className="lg:sticky lg:top-4 lg:self-start">
          <div className="mb-2 flex items-center justify-between">
            <h2 className="text-sm font-semibold text-foreground">Live preview</h2>
            <div className="flex items-center gap-2">
              <Button size="sm" variant="ghost" onClick={() => setPreviewKey((k) => k + 1)}><RefreshCw className="h-3.5 w-3.5" /> Refresh</Button>
              <a className="inline-flex items-center gap-1 text-xs text-primary hover:underline" href={`${pagePath}?blocks=1`} target="_blank" rel="noreferrer">Open page <ExternalLink className="h-3 w-3" /></a>
            </div>
          </div>
          <div className="overflow-hidden rounded-xl border border-border bg-card">
            <iframe key={previewKey} src={previewSrc} title="Live preview" className="h-[70vh] w-full bg-background" />
          </div>
          <p className="mt-2 text-xs text-muted-foreground">Preview updates ~1s after you stop typing. Edits are saved to the draft blocks; the live public page is unchanged until cutover.</p>
        </div>
      </div>
    </div>
  );
}

function JsonEditor({ value, onChange }: { value: Record<string, unknown>; onChange: (v: Record<string, unknown>) => void }) {
  const [text, setText] = useState(() => JSON.stringify(value, null, 2));
  const [err, setErr] = useState<string | null>(null);
  useEffect(() => { setText(JSON.stringify(value, null, 2)); }, [value]);
  return (
    <div className="space-y-2">
      <textarea className="min-h-[280px] w-full rounded-md border border-border bg-background p-3 font-mono text-xs text-foreground" value={text}
        onChange={(e) => { setText(e.target.value); try { onChange(JSON.parse(e.target.value)); setErr(null); } catch (x) { setErr((x as Error).message); } }} />
      {err ? <p className="text-xs text-destructive">Invalid JSON: {err}</p> : <p className="text-xs text-primary">JSON is valid.</p>}
    </div>
  );
}
