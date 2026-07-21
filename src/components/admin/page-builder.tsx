"use client";
// Professional block Page Builder (docs/BLOCK-CMS-PLAN.md Phase 3).
// Two panes: a reorderable block canvas + a per-block inspector (schema form and
// a JSON power-editor). Compose new dynamic pages from effect-rich generic
// blocks, or edit the flagship CDT/Conformity pages. Saves via
// /api/admin/pages/blocks (snapshot-first). Preview opens the page with ?blocks=1.
import { useCallback, useEffect, useMemo, useState } from "react";
import {
  Plus, Trash2, Copy, ChevronUp, ChevronDown, Save, Eye, FilePlus2, Braces, LayoutList, Loader2
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { BlockFieldForm } from "@/components/admin/block-field-form";
import { BLOCK_SCHEMAS, PALETTE_BLOCKS, schemaFor } from "@/lib/blocks/schema";
import type { BlockType } from "@/lib/blocks/types";

type WBlock = { type: BlockType; config: Record<string, unknown> };
type Status = { kind: "idle" | "ok" | "err" | "busy"; msg: string };

const KNOWN_PAGES = [
  { slug: "cyber-digital-twin", label: "Cyber Digital Twin" },
  { slug: "conformity", label: "Conformity page" }
];
const FLAGSHIP_CATEGORY: Record<string, "cdt" | "conformity"> = {
  "cyber-digital-twin": "cdt",
  conformity: "conformity"
};

export function PageBuilder() {
  const [slug, setSlug] = useState("cyber-digital-twin");
  const [locale, setLocale] = useState<"en" | "nl">("en");
  const [blocks, setBlocks] = useState<WBlock[]>([]);
  const [selected, setSelected] = useState<number | null>(null);
  const [dirty, setDirty] = useState(false);
  const [status, setStatus] = useState<Status>({ kind: "idle", msg: "" });
  const [showJson, setShowJson] = useState(false);
  const [adding, setAdding] = useState(false);

  const load = useCallback(async (s: string, l: string) => {
    setStatus({ kind: "busy", msg: "Loading…" });
    try {
      const res = await fetch(`/api/admin/pages/blocks?slug=${encodeURIComponent(s)}&locale=${l}`);
      const d = await res.json();
      const loaded: WBlock[] = (d.blocks ?? []).map((b: { type: BlockType; config: unknown }) => ({
        type: b.type, config: (b.config ?? {}) as Record<string, unknown>
      }));
      setBlocks(loaded);
      setSelected(loaded.length ? 0 : null);
      setDirty(false);
      setStatus({ kind: "idle", msg: `${loaded.length} block(s) loaded.` });
    } catch {
      setStatus({ kind: "err", msg: "Failed to load blocks." });
    }
  }, []);

  useEffect(() => { void load(slug, locale); }, [slug, locale, load]);

  useEffect(() => {
    const h = (e: BeforeUnloadEvent) => { if (dirty) { e.preventDefault(); e.returnValue = ""; } };
    window.addEventListener("beforeunload", h);
    return () => window.removeEventListener("beforeunload", h);
  }, [dirty]);

  const mutate = (next: WBlock[], keepSel = selected) => { setBlocks(next); setDirty(true); setSelected(keepSel); };

  const addBlock = (type: BlockType) => {
    const cfg = (schemaFor(type)?.defaultConfig() ?? {}) as Record<string, unknown>;
    const next = [...blocks, { type, config: cfg }];
    mutate(next, next.length - 1);
    setAdding(false);
  };
  const move = (i: number, d: number) => {
    const j = i + d; if (j < 0 || j >= blocks.length) return;
    const next = blocks.slice(); [next[i], next[j]] = [next[j], next[i]];
    mutate(next, j);
  };
  const duplicate = (i: number) => {
    const next = blocks.slice();
    next.splice(i + 1, 0, { type: blocks[i].type, config: structuredClone(blocks[i].config) });
    mutate(next, i + 1);
  };
  const remove = (i: number) => {
    const next = blocks.filter((_, k) => k !== i);
    mutate(next, next.length ? Math.max(0, i - 1) : null);
  };
  const setConfig = (i: number, config: Record<string, unknown>) =>
    mutate(blocks.map((b, k) => (k === i ? { ...b, config } : b)));

  const save = async () => {
    setStatus({ kind: "busy", msg: "Saving…" });
    try {
      const res = await fetch("/api/admin/pages/blocks", {
        method: "PUT", headers: { "content-type": "application/json" },
        body: JSON.stringify({ slug, locale, blocks })
      });
      const d = await res.json();
      if (!res.ok) { setStatus({ kind: "err", msg: d.error ?? "Save failed." }); return; }
      setDirty(false);
      setStatus({ kind: "ok", msg: `Saved ${d.count} block(s). A snapshot was recorded.` });
    } catch {
      setStatus({ kind: "err", msg: "Network error while saving." });
    }
  };

  const newPage = async () => {
    const s = window.prompt("New page slug (e.g. 'about-us'):")?.trim();
    if (!s) return;
    const title = window.prompt("Page title:")?.trim() || s;
    setStatus({ kind: "busy", msg: "Creating page…" });
    const res = await fetch("/api/admin/pages", {
      method: "POST", headers: { "content-type": "application/json" },
      body: JSON.stringify({ slug: s, locale, title, body: "", published: false, contentType: "blocks" })
    });
    if (!res.ok) { const d = await res.json().catch(() => ({})); setStatus({ kind: "err", msg: d.error ?? "Create failed." }); return; }
    setSlug(s); setBlocks([]); setSelected(null); setDirty(false);
    setStatus({ kind: "ok", msg: `Page '${s}' created (${locale}). Add blocks and save.` });
  };

  const paletteTypes = useMemo<BlockType[]>(() => {
    const flagship = FLAGSHIP_CATEGORY[slug];
    const extra = flagship
      ? (Object.values(BLOCK_SCHEMAS).filter((x) => x.category === flagship).map((x) => x.type) as BlockType[])
      : [];
    return [...PALETTE_BLOCKS, ...extra];
  }, [slug]);

  const sel = selected != null ? blocks[selected] : null;
  const selSchema = sel ? schemaFor(sel.type) : undefined;

  return (
    <div className="space-y-4">
      {/* Toolbar */}
      <Card>
        <CardContent className="flex flex-wrap items-center gap-3 py-3">
          <div className="flex items-center gap-2">
            <LayoutList className="h-4 w-4 text-primary" />
            <select className="h-9 rounded-md border border-border bg-background px-2 text-sm" value={slug}
              onChange={(e) => { if (dirty && !confirm("Discard unsaved changes?")) return; setSlug(e.target.value); }}>
              {KNOWN_PAGES.map((p) => <option key={p.slug} value={p.slug}>{p.label}</option>)}
              {!KNOWN_PAGES.some((p) => p.slug === slug) ? <option value={slug}>{slug}</option> : null}
            </select>
          </div>
          <div className="inline-flex overflow-hidden rounded-md border border-border">
            {(["en", "nl"] as const).map((l) => (
              <button key={l} onClick={() => { if (dirty && !confirm("Discard unsaved changes?")) return; setLocale(l); }}
                className={`px-3 py-1.5 text-xs font-medium ${locale === l ? "bg-primary text-primary-foreground" : "text-muted-foreground hover:bg-accent"}`}>
                {l.toUpperCase()}
              </button>
            ))}
          </div>
          <div className="ml-auto flex items-center gap-2">
            <Button size="sm" variant="outline" onClick={newPage}><FilePlus2 className="h-4 w-4" /> New page</Button>
            <Button size="sm" variant="outline" onClick={() => window.open(`/${locale}/${slug}?blocks=1`, "_blank")}><Eye className="h-4 w-4" /> Preview</Button>
            <Button size="sm" onClick={save} disabled={status.kind === "busy" || !dirty}>
              {status.kind === "busy" ? <Loader2 className="h-4 w-4 animate-spin" /> : <Save className="h-4 w-4" />} Save
            </Button>
          </div>
          {status.msg ? (
            <p className={`w-full text-xs ${status.kind === "err" ? "text-destructive" : status.kind === "ok" ? "text-primary" : "text-muted-foreground"}`}>{status.msg}</p>
          ) : null}
        </CardContent>
      </Card>

      <div className="grid gap-4 lg:grid-cols-[minmax(0,360px)_1fr]">
        {/* Canvas */}
        <Card>
          <CardHeader className="flex flex-row items-center justify-between py-3">
            <CardTitle className="text-sm">Blocks ({blocks.length})</CardTitle>
            <div className="relative">
              <Button size="sm" variant="outline" onClick={() => setAdding((v) => !v)}><Plus className="h-4 w-4" /> Add block</Button>
              {adding ? (
                <div className="absolute right-0 z-20 mt-1 max-h-80 w-64 overflow-auto rounded-md border border-border bg-popover p-1 shadow-lg">
                  {paletteTypes.map((t) => {
                    const s = schemaFor(t);
                    return (
                      <button key={t} onClick={() => addBlock(t)} className="block w-full rounded px-2 py-1.5 text-left text-sm hover:bg-accent">
                        <span className="font-medium text-foreground">{s?.label ?? t}</span>
                        {s?.hint ? <span className="block text-xs text-muted-foreground">{s.hint}</span> : null}
                      </button>
                    );
                  })}
                </div>
              ) : null}
            </div>
          </CardHeader>
          <CardContent className="space-y-2">
            {blocks.length === 0 ? <p className="py-8 text-center text-sm text-muted-foreground">No blocks yet — click “Add block”.</p> : null}
            {blocks.map((b, i) => (
              <div key={i} onClick={() => { setSelected(i); setShowJson(false); }}
                className={`cursor-pointer rounded-md border p-2.5 ${selected === i ? "border-primary bg-primary/5" : "border-border hover:bg-accent"}`}>
                <div className="flex items-center gap-2">
                  <span className="flex-1 truncate text-sm font-medium text-foreground">{schemaFor(b.type)?.label ?? b.type}</span>
                  <Badge variant="secondary" className="shrink-0 font-mono text-[10px]">{b.type}</Badge>
                </div>
                <div className="mt-2 flex items-center gap-1" onClick={(e) => e.stopPropagation()}>
                  <Button size="icon" variant="ghost" className="h-6 w-6" onClick={() => move(i, -1)}><ChevronUp className="h-3.5 w-3.5" /></Button>
                  <Button size="icon" variant="ghost" className="h-6 w-6" onClick={() => move(i, 1)}><ChevronDown className="h-3.5 w-3.5" /></Button>
                  <Button size="icon" variant="ghost" className="h-6 w-6" onClick={() => duplicate(i)}><Copy className="h-3.5 w-3.5" /></Button>
                  <Button size="icon" variant="ghost" className="h-6 w-6 text-destructive" onClick={() => remove(i)}><Trash2 className="h-3.5 w-3.5" /></Button>
                </div>
              </div>
            ))}
          </CardContent>
        </Card>

        {/* Inspector */}
        <Card>
          <CardHeader className="flex flex-row items-center justify-between py-3">
            <CardTitle className="text-sm">{sel ? (selSchema?.label ?? sel.type) : "Inspector"}</CardTitle>
            {sel ? (
              <Button size="sm" variant="ghost" onClick={() => setShowJson((v) => !v)}>
                <Braces className="h-4 w-4" /> {showJson ? "Form" : "JSON"}
              </Button>
            ) : null}
          </CardHeader>
          <CardContent>
            {!sel ? (
              <p className="py-8 text-center text-sm text-muted-foreground">Select a block to edit it.</p>
            ) : showJson || !selSchema || selSchema.fields.length === 0 ? (
              <JsonEditor value={sel.config} onChange={(cfg) => setConfig(selected!, cfg)} forced={!!selSchema && selSchema.fields.length === 0} />
            ) : (
              <BlockFieldForm fields={selSchema.fields} value={sel.config} onChange={(cfg) => setConfig(selected!, cfg)} />
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}

function JsonEditor({ value, onChange, forced }: { value: Record<string, unknown>; onChange: (v: Record<string, unknown>) => void; forced?: boolean }) {
  const [text, setText] = useState(() => JSON.stringify(value, null, 2));
  const [err, setErr] = useState<string | null>(null);
  useEffect(() => { setText(JSON.stringify(value, null, 2)); }, [value]);
  return (
    <div className="space-y-2">
      {forced ? <p className="text-xs text-muted-foreground">This block has a deep structure and is edited as JSON.</p> : null}
      <textarea
        className="min-h-[320px] w-full rounded-md border border-border bg-background p-3 font-mono text-xs text-foreground"
        value={text}
        onChange={(e) => {
          setText(e.target.value);
          try { onChange(JSON.parse(e.target.value)); setErr(null); } catch (x) { setErr((x as Error).message); }
        }}
      />
      {err ? <p className="text-xs text-destructive">Invalid JSON: {err}</p> : <p className="text-xs text-primary">JSON is valid.</p>}
    </div>
  );
}
