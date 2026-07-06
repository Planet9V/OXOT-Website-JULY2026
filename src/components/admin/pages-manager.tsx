"use client";
import { useEffect, useState, useCallback } from "react";
import { Button } from "@/components/ui/button";

type Row = { slug: string; locale: string; title: string; contentType: string; published: boolean };
type Form = {
  slug: string; locale: string; title: string; body: string; published: boolean;
  metaTitle: string; metaDescription: string; excerpt: string; ogImage: string; contentType: string;
};
const EMPTY: Form = {
  slug: "", locale: "en", title: "", body: "", published: false,
  metaTitle: "", metaDescription: "", excerpt: "", ogImage: "", contentType: "page"
};

export function PagesManager() {
  const [rows, setRows] = useState<Row[]>([]);
  const [form, setForm] = useState<Form>(EMPTY);
  const [msg, setMsg] = useState("");

  const load = useCallback(async () => {
    const res = await fetch("/api/admin/pages");
    if (res.ok) setRows((await res.json()).pages);
  }, []);
  useEffect(() => { void load(); }, [load]);

  function set<K extends keyof Form>(k: K, v: Form[K]) { setForm((f) => ({ ...f, [k]: v })); }

  async function save(e: React.FormEvent) {
    e.preventDefault();
    setMsg("");
    const res = await fetch("/api/admin/pages", {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify(form)
    });
    if (res.ok) { setMsg("Saved."); void load(); }
    else setMsg((await res.json()).error ?? "error");
  }

  async function del(slug: string, locale: string) {
    await fetch(`/api/admin/pages?slug=${slug}&locale=${locale}`, { method: "DELETE" });
    void load();
  }

  const field = "w-full rounded-lg border border-border bg-background px-3 py-2";

  return (
    <section className="space-y-6">
      <div>
        <h2 className="mb-2 font-semibold">Pages</h2>
        <table className="w-full text-sm">
          <thead><tr className="text-left text-muted-foreground">
            <th>Slug</th><th>Locale</th><th>Title</th><th>Type</th><th>Published</th><th></th>
          </tr></thead>
          <tbody>
            {rows.map((r) => (
              <tr key={`${r.slug}-${r.locale}`} className="border-t border-border">
                <td>{r.slug}</td><td>{r.locale}</td><td>{r.title}</td>
                <td>{r.contentType}</td><td>{r.published ? "✓" : "—"}</td>
                <td><button className="text-red-500" onClick={() => del(r.slug, r.locale)}>delete</button></td>
              </tr>
            ))}
            {!rows.length && <tr><td colSpan={6} className="py-2 text-muted-foreground">No pages yet.</td></tr>}
          </tbody>
        </table>
      </div>

      <form onSubmit={save} className="space-y-2 rounded-lg border border-border p-4">
        <h2 className="font-semibold">Add / edit page</h2>
        <div className="flex gap-2">
          <input className={`flex-1 ${field}`} placeholder="slug (e.g. ot-security-assessments)"
            value={form.slug} onChange={(e) => set("slug", e.target.value)} />
          <select className={field} value={form.locale} onChange={(e) => set("locale", e.target.value)}>
            <option value="en">en</option><option value="nl">nl</option>
          </select>
          <select className={field} value={form.contentType} onChange={(e) => set("contentType", e.target.value)}>
            <option value="page">page</option><option value="article">article</option>
          </select>
        </div>
        <input className={field} placeholder="title (H1)" value={form.title}
          onChange={(e) => set("title", e.target.value)} />
        <textarea className={`h-40 ${field}`} placeholder="body" value={form.body}
          onChange={(e) => set("body", e.target.value)} />

        <div className="rounded-lg border border-border/60 p-3">
          <p className="mb-2 text-xs font-medium uppercase tracking-wide text-muted-foreground">SEO / social</p>
          <input className={field} placeholder="meta title (≈60 chars, for search results)"
            value={form.metaTitle} onChange={(e) => set("metaTitle", e.target.value)} />
          <textarea className={`mt-2 h-16 ${field}`} placeholder="meta description (≤160 chars)"
            value={form.metaDescription} onChange={(e) => set("metaDescription", e.target.value)} />
          <input className={`mt-2 ${field}`} placeholder="excerpt (short summary, used in listings)"
            value={form.excerpt} onChange={(e) => set("excerpt", e.target.value)} />
          <input className={`mt-2 ${field}`} placeholder="og image URL (social share image)"
            value={form.ogImage} onChange={(e) => set("ogImage", e.target.value)} />
        </div>

        <label className="flex items-center gap-2 text-sm">
          <input type="checkbox" checked={form.published}
            onChange={(e) => set("published", e.target.checked)} />
          Published (requires both nl + en)
        </label>
        {msg && <p className="text-sm text-muted-foreground">{msg}</p>}
        <div className="flex gap-2">
          <Button type="submit">Save</Button>
          <Button type="button" variant="outline" onClick={() => setForm(EMPTY)}>Clear</Button>
        </div>
      </form>
    </section>
  );
}
