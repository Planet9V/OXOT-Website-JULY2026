"use client";
import { useEffect, useState, useCallback, useRef } from "react";
import { FileText, Trash2, Pencil, Wand2, Braces, History, RotateCcw, Languages } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { RichEditor } from "@/components/admin/editor/rich-editor";
import { SkeletonRows } from "@/components/admin/skeleton";

type Row = { slug: string; locale: string; title: string; contentType: string; published: boolean };
type Form = {
  slug: string; locale: string; title: string; body: string; published: boolean;
  metaTitle: string; metaDescription: string; excerpt: string; ogImage: string; contentType: string;
};
type VersionSummary = {
  id: number; versionNumber: number; state: string; note: string | null; createdAt: string; title: string;
};
type VersionFull = VersionSummary & { body: string };
const EMPTY: Form = {
  slug: "", locale: "en", title: "", body: "", published: false,
  metaTitle: "", metaDescription: "", excerpt: "", ogImage: "", contentType: "page"
};
const selectCls = "h-9 rounded-lg border border-input bg-background px-3 text-sm";

export function PagesManager() {
  const [rows, setRows] = useState<Row[]>([]);
  const [form, setForm] = useState<Form>(EMPTY);
  const [editorKey, setEditorKey] = useState(0);
  const [raw, setRaw] = useState(false);
  const [msg, setMsg] = useState("");
  const [busy, setBusy] = useState(false);
  const [menuTops, setMenuTops] = useState<{ id: number; label: string; locale: string; parentId: number | null }[]>([]);
  const [menuParent, setMenuParent] = useState("");
  const [menuMsg, setMenuMsg] = useState("");

  const [historyFor, setHistoryFor] = useState<{ slug: string; locale: string } | null>(null);
  const [versions, setVersions] = useState<VersionSummary[]>([]);
  const [preview, setPreview] = useState<VersionFull | null>(null);
  const [historyMsg, setHistoryMsg] = useState("");
  const [translating, setTranslating] = useState<string | null>(null);
  const [initialLoading, setInitialLoading] = useState(true);

  // Unsaved-changes tracking: `loadedFormRef` is the last saved/loaded snapshot of
  // the editor form. `dirty` is derived by comparing the live `form` against it.
  const loadedFormRef = useRef<Form>(EMPTY);
  const [dirty, setDirty] = useState(false);

  const load = useCallback(async () => {
    const res = await fetch("/api/admin/pages");
    if (res.ok) setRows((await res.json()).pages);
  }, []);
  const loadMenu = useCallback(async () => {
    const res = await fetch("/api/admin/menu-items?menu=main");
    if (res.ok) setMenuTops((await res.json()).items);
  }, []);
  useEffect(() => { void load().finally(() => setInitialLoading(false)); void loadMenu(); }, [load, loadMenu]);

  useEffect(() => {
    setDirty(JSON.stringify(form) !== JSON.stringify(loadedFormRef.current));
  }, [form]);

  // Warn on tab close/refresh only while there are unsaved edits.
  useEffect(() => {
    if (!dirty) return;
    function handler(e: BeforeUnloadEvent) {
      e.preventDefault();
      e.returnValue = "";
    }
    window.addEventListener("beforeunload", handler);
    return () => window.removeEventListener("beforeunload", handler);
  }, [dirty]);

  function confirmDiscardIfDirty(): boolean {
    if (!dirty) return true;
    return window.confirm("You have unsaved changes — discard them?");
  }

  // Add the page currently in the editor to the main menu (optionally under a parent).
  async function addToMenu() {
    if (!form.slug) { setMenuMsg("Enter a slug first."); return; }
    const href = form.slug ? `/${form.locale}/${form.slug}` : `/${form.locale}`;
    const res = await fetch("/api/admin/menu-items", {
      method: "POST", headers: { "content-type": "application/json" },
      body: JSON.stringify({ menu: "main", locale: form.locale, label: form.title || form.slug, href,
        parentId: menuParent ? Number(menuParent) : null, description: form.excerpt || "" })
    });
    setMenuMsg(res.ok ? "Added to menu." : ((await res.json()).error ?? "error"));
    if (res.ok) void loadMenu();
  }

  function set<K extends keyof Form>(k: K, v: Form[K]) { setForm((f) => ({ ...f, [k]: v })); }
  function reset() {
    if (!confirmDiscardIfDirty()) return;
    setForm(EMPTY);
    loadedFormRef.current = EMPTY;
    setEditorKey((k) => k + 1);
    setMsg("");
  }

  async function loadPage(slug: string, locale: string) {
    if (!confirmDiscardIfDirty()) return;
    const res = await fetch(`/api/admin/pages?slug=${encodeURIComponent(slug)}&locale=${locale}`);
    if (!res.ok) { setMsg("Could not load page."); return; }
    const { page } = await res.json();
    const next: Form = {
      slug: page.slug, locale: page.locale, title: page.title ?? "", body: page.body ?? "",
      published: !!page.published, metaTitle: page.metaTitle ?? "", metaDescription: page.metaDescription ?? "",
      excerpt: page.excerpt ?? "", ogImage: page.ogImage ?? "", contentType: page.contentType ?? "page"
    };
    setForm(next);
    loadedFormRef.current = next;
    setEditorKey((k) => k + 1);
    setMsg(`Loaded ${slug} · ${locale} — edit and Save.`);
  }

  async function save(e: React.FormEvent) {
    e.preventDefault();
    setMsg(""); setBusy(true);
    const res = await fetch("/api/admin/pages", {
      method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify(form)
    });
    setMsg(res.ok ? "Saved." : ((await res.json()).error ?? "error"));
    setBusy(false);
    if (res.ok) { loadedFormRef.current = form; void load(); }
  }

  async function del(slug: string, locale: string) {
    await fetch(`/api/admin/pages?slug=${slug}&locale=${locale}`, { method: "DELETE" });
    void load();
  }

  async function translate(slug: string, locale: string) {
    if (!confirmDiscardIfDirty()) return;
    const target = locale === "en" ? "nl" : "en";
    if (
      !window.confirm(
        `Translate "${slug}" (${locale}) into ${target}? This will overwrite the current ${target} version. ` +
          `Its prior content is saved to version history first and can be restored from there.`
      )
    )
      return;
    setTranslating(`${slug}-${locale}`);
    setMsg("");
    const res = await fetch("/api/admin/pages/translate", {
      method: "POST", headers: { "content-type": "application/json" },
      body: JSON.stringify({ slug, sourceLocale: locale }),
    });
    const data = await res.json().catch(() => ({}));
    setTranslating(null);
    if (!res.ok) { setMsg(data.error ?? "Translation failed."); return; }
    setMsg(`Translated ${slug} · ${data.targetLocale}. Review it in the editor — the prior version is in history and can be restored if the translation needs work.`);
    void load();
  }

  async function openHistory(slug: string, locale: string) {
    setHistoryFor({ slug, locale });
    setPreview(null);
    setHistoryMsg("Loading…");
    const res = await fetch(`/api/admin/pages/versions?slug=${encodeURIComponent(slug)}&locale=${locale}`);
    if (!res.ok) { setHistoryMsg("Could not load history."); return; }
    const { versions } = await res.json();
    setVersions(versions);
    setHistoryMsg("");
  }
  function closeHistory() { setHistoryFor(null); setVersions([]); setPreview(null); setHistoryMsg(""); }

  async function previewVersion(id: number) {
    const res = await fetch(`/api/admin/pages/versions/${id}`);
    if (!res.ok) { setHistoryMsg("Could not load version."); return; }
    const { version } = await res.json();
    setPreview(version);
  }

  async function restoreVersion(id: number) {
    if (!historyFor) return;
    if (!window.confirm("Restore this version? The current content will be snapshotted first, so nothing is lost.")) return;
    setHistoryMsg("Restoring…");
    const res = await fetch("/api/admin/pages/restore", {
      method: "POST", headers: { "content-type": "application/json" },
      body: JSON.stringify({ slug: historyFor.slug, locale: historyFor.locale, versionId: id })
    });
    if (!res.ok) { setHistoryMsg((await res.json()).error ?? "Restore failed."); return; }
    setHistoryMsg("Restored.");
    void load();
    void openHistory(historyFor.slug, historyFor.locale);
    if (form.slug === historyFor.slug && form.locale === historyFor.locale) {
      void loadPage(historyFor.slug, historyFor.locale);
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-xl font-semibold tracking-tight">Pages</h2>
        <p className="text-sm text-muted-foreground">Edit page content with the rich editor. Publishing requires both nl + en.</p>
      </div>

      <Card>
        <CardHeader className="pb-3"><CardTitle className="text-base">All pages</CardTitle></CardHeader>
        <CardContent className="p-0">
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead className="border-y border-border bg-muted/40 text-left text-xs uppercase tracking-wide text-muted-foreground">
                <tr><th className="px-4 py-2">Slug</th><th className="px-4 py-2">Locale</th><th className="px-4 py-2">Title</th><th className="px-4 py-2">Type</th><th className="px-4 py-2">Status</th><th className="px-4 py-2 text-right">Actions</th></tr>
              </thead>
              <tbody>
                {initialLoading && <SkeletonRows cols={6} />}
                {!initialLoading && rows.map((r) => (
                  <tr key={`${r.slug}-${r.locale}`} className="border-b border-border/60 last:border-0 hover:bg-muted/30">
                    <td className="px-4 py-2 font-mono text-xs">{r.slug}</td>
                    <td className="px-4 py-2 uppercase">{r.locale}</td>
                    <td className="px-4 py-2">{r.title}</td>
                    <td className="px-4 py-2">{r.contentType}</td>
                    <td className="px-4 py-2">{r.published ? <Badge variant="success">Published</Badge> : <Badge variant="secondary">Draft</Badge>}</td>
                    <td className="px-4 py-2">
                      <div className="flex justify-end gap-1">
                        <Button variant="ghost" size="icon" title="Load into editor" aria-label={`Load ${r.slug} (${r.locale}) into editor`}
                          onClick={() => loadPage(r.slug, r.locale)}>
                          <Pencil className="h-4 w-4" />
                        </Button>
                        <Button variant="ghost" size="icon" title="Version history" aria-label={`Version history for ${r.slug} (${r.locale})`}
                          onClick={() => openHistory(r.slug, r.locale)}>
                          <History className="h-4 w-4" />
                        </Button>
                        <Button variant="ghost" size="icon"
                          title={`Translate → ${r.locale === "en" ? "NL" : "EN"}`}
                          aria-label={`Translate ${r.slug} to ${r.locale === "en" ? "NL" : "EN"}`}
                          disabled={translating === `${r.slug}-${r.locale}`}
                          onClick={() => translate(r.slug, r.locale)}>
                          <Languages className="h-4 w-4" />
                        </Button>
                        <Button variant="ghost" size="icon" title="Delete" aria-label={`Delete ${r.slug} (${r.locale})`} onClick={() => del(r.slug, r.locale)}>
                          <Trash2 className="h-4 w-4 text-destructive" />
                        </Button>
                      </div>
                    </td>
                  </tr>
                ))}
                {!initialLoading && !rows.length && <tr><td colSpan={6} className="px-4 py-6 text-center text-muted-foreground">No pages yet.</td></tr>}
              </tbody>
            </table>
          </div>
        </CardContent>
      </Card>

      {historyFor && (
        <Card>
          <CardHeader className="pb-3">
            <CardTitle className="flex items-center justify-between text-base">
              <span className="flex items-center gap-2"><History className="h-4 w-4" /> History — {historyFor.slug} · {historyFor.locale}</span>
              <Button variant="outline" size="sm" onClick={closeHistory}>Close</Button>
            </CardTitle>
          </CardHeader>
          <CardContent>
            {historyMsg && <p className="mb-3 text-sm text-muted-foreground">{historyMsg}</p>}
            <div className="grid gap-4 md:grid-cols-2">
              <div className="overflow-x-auto">
                <table className="w-full text-sm">
                  <thead className="border-y border-border bg-muted/40 text-left text-xs uppercase tracking-wide text-muted-foreground">
                    <tr><th className="px-3 py-2">#</th><th className="px-3 py-2">State</th><th className="px-3 py-2">Note</th><th className="px-3 py-2">Date</th><th className="px-3 py-2 text-right">Actions</th></tr>
                  </thead>
                  <tbody>
                    {versions.map((v) => (
                      <tr key={v.id} className="border-b border-border/60 last:border-0 hover:bg-muted/30">
                        <td className="px-3 py-2">{v.versionNumber}</td>
                        <td className="px-3 py-2 capitalize">{v.state}</td>
                        <td className="px-3 py-2 text-muted-foreground">{v.note ?? "—"}</td>
                        <td className="px-3 py-2 text-muted-foreground">{new Date(v.createdAt).toLocaleString()}</td>
                        <td className="px-3 py-2">
                          <div className="flex justify-end gap-1">
                            <Button variant="ghost" size="sm" onClick={() => previewVersion(v.id)}>Preview</Button>
                            <Button variant="outline" size="sm" onClick={() => restoreVersion(v.id)}>
                              <RotateCcw className="mr-1 h-3.5 w-3.5" /> Restore
                            </Button>
                          </div>
                        </td>
                      </tr>
                    ))}
                    {!versions.length && !historyMsg && (
                      <tr><td colSpan={5} className="px-3 py-6 text-center text-muted-foreground">No versions yet.</td></tr>
                    )}
                  </tbody>
                </table>
              </div>
              <div className="rounded-lg border border-border/60 bg-muted/20 p-4">
                <p className="mb-2 text-xs font-semibold uppercase tracking-wide text-muted-foreground">Preview</p>
                {preview ? (
                  <div>
                    <p className="mb-1 text-sm font-medium">{preview.title}</p>
                    <pre className="max-h-72 overflow-auto whitespace-pre-wrap text-xs text-muted-foreground">{preview.body}</pre>
                  </div>
                ) : (
                  <p className="text-sm text-muted-foreground">Select a version to preview its content.</p>
                )}
              </div>
            </div>
          </CardContent>
        </Card>
      )}

      <Card>
        <CardHeader className="pb-3"><CardTitle className="flex items-center gap-2 text-base"><FileText className="h-4 w-4" /> Add / edit page</CardTitle></CardHeader>
        <CardContent>
          <form onSubmit={save} className="space-y-4">
            <div className="grid gap-3 sm:grid-cols-4">
              <div className="sm:col-span-2"><Label className="mb-1.5 block">Slug</Label><Input placeholder="ot-security-assessments" value={form.slug} onChange={(e) => set("slug", e.target.value)} /></div>
              <div><Label className="mb-1.5 block">Locale</Label>
                <select className={`w-full ${selectCls}`} value={form.locale} onChange={(e) => set("locale", e.target.value)}><option value="en">en</option><option value="nl">nl</option></select></div>
              <div><Label className="mb-1.5 block">Type</Label>
                <select className={`w-full ${selectCls}`} value={form.contentType} onChange={(e) => set("contentType", e.target.value)}><option value="page">page</option><option value="article">article</option></select></div>
            </div>
            <div><Label className="mb-1.5 block">Title (H1)</Label><Input placeholder="Page title" value={form.title} onChange={(e) => set("title", e.target.value)} /></div>

            <div>
              <div className="mb-1.5 flex items-center justify-between">
                <Label>Body</Label>
                <Button type="button" variant="outline" size="sm" onClick={() => setRaw((r) => !r)}>
                  {raw ? <><Wand2 className="h-3.5 w-3.5" /> Rich editor</> : <><Braces className="h-3.5 w-3.5" /> Markdown</>}
                </Button>
              </div>
              {raw ? (
                <Textarea className="h-72 font-mono text-xs" placeholder="# Markdown…" value={form.body} onChange={(e) => set("body", e.target.value)} />
              ) : (
                <RichEditor key={editorKey} value={form.body} onChange={(md) => set("body", md)} />
              )}
              <p className="mt-1.5 text-xs text-muted-foreground">Rich editor round-trips Markdown. For <code className="rounded bg-muted px-1">svg</code> / <code className="rounded bg-muted px-1">carousel</code> embeds, use a code block (or the Markdown toggle).</p>
            </div>

            <div className="rounded-lg border border-border/60 bg-muted/20 p-4">
              <p className="mb-3 text-xs font-semibold uppercase tracking-wide text-muted-foreground">SEO / social</p>
              <div className="space-y-2">
                <Input placeholder="Meta title (≈60 chars)" value={form.metaTitle} onChange={(e) => set("metaTitle", e.target.value)} />
                <Textarea className="h-16" placeholder="Meta description (≤160 chars)" value={form.metaDescription} onChange={(e) => set("metaDescription", e.target.value)} />
                <Input placeholder="Excerpt (listing summary)" value={form.excerpt} onChange={(e) => set("excerpt", e.target.value)} />
                <Input placeholder="OG image URL" value={form.ogImage} onChange={(e) => set("ogImage", e.target.value)} />
              </div>
            </div>

            <label className="flex items-center gap-2 text-sm">
              <input type="checkbox" checked={form.published} onChange={(e) => set("published", e.target.checked)} />
              Published <span className="text-muted-foreground">(requires both nl + en)</span>
            </label>

            <div className="rounded-lg border border-border/60 bg-muted/20 p-4">
              <p className="mb-2 text-xs font-semibold uppercase tracking-wide text-muted-foreground">Navigation</p>
              <p className="mb-3 text-xs text-muted-foreground">Place this page in the top menu. Choose a parent to nest it into that dropdown (mega-menu). The page&apos;s excerpt becomes the dropdown description.</p>
              <div className="flex flex-wrap items-center gap-2">
                <select className={`${selectCls} min-w-[12rem]`} value={menuParent} onChange={(e) => setMenuParent(e.target.value)}>
                  <option value="">— top level —</option>
                  {menuTops.filter((m) => m.locale === form.locale && m.parentId === null).map((m) => (
                    <option key={m.id} value={m.id}>under: {m.label}</option>
                  ))}
                </select>
                <Button type="button" variant="outline" onClick={addToMenu}>Add “{form.title || form.slug || "page"}” to menu</Button>
                {menuMsg && <span className="text-sm text-muted-foreground">{menuMsg}</span>}
              </div>
            </div>

            <div className="flex items-center gap-3">
              <Button type="submit" disabled={busy}>{busy ? "Saving…" : "Save page"}</Button>
              <Button type="button" variant="outline" onClick={reset}>Clear</Button>
              {msg && <span className="text-sm text-muted-foreground">{msg}</span>}
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
