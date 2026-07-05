"use client";
import { useEffect, useState, useCallback } from "react";
import { Button } from "@/components/ui/button";

type Row = { slug: string; locale: string; title: string; published: boolean };

export function PagesManager() {
  const [rows, setRows] = useState<Row[]>([]);
  const [form, setForm] = useState({ slug: "", locale: "en", title: "", body: "", published: false });
  const [msg, setMsg] = useState("");

  const load = useCallback(async () => {
    const res = await fetch("/api/admin/pages");
    if (res.ok) setRows((await res.json()).pages);
  }, []);
  useEffect(() => { void load(); }, [load]);

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

  return (
    <section className="space-y-6">
      <div>
        <h2 className="mb-2 font-semibold">Pages</h2>
        <table className="w-full text-sm">
          <thead><tr className="text-left text-muted-foreground">
            <th>Slug</th><th>Locale</th><th>Title</th><th>Published</th><th></th>
          </tr></thead>
          <tbody>
            {rows.map((r) => (
              <tr key={`${r.slug}-${r.locale}`} className="border-t border-border">
                <td>{r.slug}</td><td>{r.locale}</td><td>{r.title}</td>
                <td>{r.published ? "✓" : "—"}</td>
                <td><button className="text-red-500" onClick={() => del(r.slug, r.locale)}>delete</button></td>
              </tr>
            ))}
            {!rows.length && <tr><td colSpan={5} className="py-2 text-muted-foreground">No pages yet.</td></tr>}
          </tbody>
        </table>
      </div>

      <form onSubmit={save} className="space-y-2 rounded-lg border border-border p-4">
        <h2 className="font-semibold">Add / edit page</h2>
        <div className="flex gap-2">
          <input className="flex-1 rounded-lg border border-border bg-background px-3 py-2"
            placeholder="slug" value={form.slug}
            onChange={(e) => setForm({ ...form, slug: e.target.value })} />
          <select className="rounded-lg border border-border bg-background px-3 py-2"
            value={form.locale} onChange={(e) => setForm({ ...form, locale: e.target.value })}>
            <option value="en">en</option><option value="nl">nl</option>
          </select>
        </div>
        <input className="w-full rounded-lg border border-border bg-background px-3 py-2"
          placeholder="title" value={form.title}
          onChange={(e) => setForm({ ...form, title: e.target.value })} />
        <textarea className="h-28 w-full rounded-lg border border-border bg-background px-3 py-2"
          placeholder="body" value={form.body}
          onChange={(e) => setForm({ ...form, body: e.target.value })} />
        <label className="flex items-center gap-2 text-sm">
          <input type="checkbox" checked={form.published}
            onChange={(e) => setForm({ ...form, published: e.target.checked })} />
          Published (requires both nl + en)
        </label>
        {msg && <p className="text-sm text-muted-foreground">{msg}</p>}
        <Button type="submit">Save</Button>
      </form>
    </section>
  );
}
