"use client";
import { useEffect, useState, useCallback } from "react";
import { Button } from "@/components/ui/button";
import { ArrowUp, ArrowDown, Trash2, Plus } from "lucide-react";

type Item = { id: number; locale: string; label: string; href: string; position: number };

export function MenuManager({ menu = "main" }: { menu?: string }) {
  const [items, setItems] = useState<Item[]>([]);
  const [form, setForm] = useState({ locale: "en", label: "", href: "" });
  const [msg, setMsg] = useState("");

  const load = useCallback(async () => {
    const res = await fetch(`/api/admin/menu-items?menu=${menu}`);
    if (res.ok) setItems((await res.json()).items);
  }, [menu]);
  useEffect(() => { void load(); }, [load]);

  const patch = (id: number, body: Partial<Item>) =>
    fetch("/api/admin/menu-items", { method: "PATCH", headers: { "content-type": "application/json" }, body: JSON.stringify({ id, ...body }) });

  // update local state as the user types
  const setLocal = (id: number, field: "label" | "href", value: string) =>
    setItems((xs) => xs.map((x) => (x.id === id ? { ...x, [field]: value } : x)));

  // persist on blur
  async function saveField(it: Item, field: "label" | "href") {
    await patch(it.id, { [field]: it[field] });
    setMsg("Saved.");
  }

  async function move(it: Item, dir: -1 | 1) {
    const col = items.filter((x) => x.locale === it.locale).sort((a, b) => a.position - b.position);
    const idx = col.findIndex((x) => x.id === it.id);
    const other = col[idx + dir];
    if (!other) return;
    await Promise.all([patch(it.id, { position: other.position }), patch(other.id, { position: it.position })]);
    await load();
  }

  async function add(e: React.FormEvent) {
    e.preventDefault();
    setMsg("");
    const maxPos = Math.max(-1, ...items.filter((x) => x.locale === form.locale).map((x) => x.position));
    const res = await fetch("/api/admin/menu-items", {
      method: "POST", headers: { "content-type": "application/json" },
      body: JSON.stringify({ menu, ...form, position: maxPos + 1 })
    });
    if (res.ok) { setForm({ locale: form.locale, label: "", href: "" }); void load(); }
    else setMsg((await res.json()).error ?? "error");
  }

  async function del(id: number) {
    if (!confirm("Delete this menu item?")) return;
    await fetch(`/api/admin/menu-items?id=${id}`, { method: "DELETE" });
    void load();
  }

  const locales = Array.from(new Set(items.map((i) => i.locale))).sort();
  const inp = "w-full rounded-md border border-border bg-background px-2.5 py-1.5 text-sm";

  return (
    <section className="space-y-6">
      <div>
        <h2 className="text-lg font-semibold">Menu: {menu}</h2>
        <p className="text-sm text-muted-foreground">Edit labels/links inline (saved when you click away), reorder with the arrows, or add a new item.</p>
      </div>

      {locales.map((loc) => {
        const col = items.filter((i) => i.locale === loc).sort((a, b) => a.position - b.position);
        return (
          <div key={loc} className="rounded-xl border border-border">
            <div className="border-b border-border bg-muted/40 px-4 py-2 text-xs font-semibold uppercase tracking-wide text-muted-foreground">{loc}</div>
            <div className="divide-y divide-border">
              {col.map((it, i) => (
                <div key={it.id} className="flex items-center gap-2 p-2.5">
                  <div className="flex flex-col">
                    <button onClick={() => move(it, -1)} disabled={i === 0} className="text-muted-foreground disabled:opacity-30 hover:text-primary" title="Move up"><ArrowUp className="h-3.5 w-3.5" /></button>
                    <button onClick={() => move(it, 1)} disabled={i === col.length - 1} className="text-muted-foreground disabled:opacity-30 hover:text-primary" title="Move down"><ArrowDown className="h-3.5 w-3.5" /></button>
                  </div>
                  <input className={`${inp} max-w-[10rem]`} value={it.label} onChange={(e) => setLocal(it.id, "label", e.target.value)} onBlur={() => saveField(it, "label")} placeholder="label" />
                  <input className={`${inp} flex-1`} value={it.href} onChange={(e) => setLocal(it.id, "href", e.target.value)} onBlur={() => saveField(it, "href")} placeholder="/en/about" />
                  <button onClick={() => del(it.id)} title="Delete" className="rounded-md p-1.5 text-muted-foreground hover:text-red-500"><Trash2 className="h-4 w-4" /></button>
                </div>
              ))}
              {!col.length && <div className="p-3 text-sm text-muted-foreground">No items.</div>}
            </div>
          </div>
        );
      })}

      <form onSubmit={add} className="flex flex-wrap items-end gap-2 rounded-xl border border-dashed border-border p-4">
        <select className="rounded-md border border-border bg-background px-3 py-2 text-sm" value={form.locale} onChange={(e) => setForm({ ...form, locale: e.target.value })}>
          <option value="en">en</option><option value="nl">nl</option>
        </select>
        <input className="rounded-md border border-border bg-background px-3 py-2 text-sm" placeholder="Label" value={form.label} onChange={(e) => setForm({ ...form, label: e.target.value })} />
        <input className="rounded-md border border-border bg-background px-3 py-2 text-sm" placeholder="/en/about" value={form.href} onChange={(e) => setForm({ ...form, href: e.target.value })} />
        <Button type="submit"><Plus className="mr-1 h-4 w-4" /> Add item</Button>
        {msg && <span className="text-sm text-muted-foreground">{msg}</span>}
      </form>
    </section>
  );
}
