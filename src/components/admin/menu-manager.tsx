"use client";
import { useEffect, useState, useCallback } from "react";
import { Button } from "@/components/ui/button";
import { ArrowUp, ArrowDown, Trash2, Plus } from "lucide-react";

type Item = { id: number; locale: string; label: string; href: string; position: number; parentId: number | null; description: string | null };

export function MenuManager({ menu = "main" }: { menu?: string }) {
  const [items, setItems] = useState<Item[]>([]);
  const [form, setForm] = useState({ locale: "en", label: "", href: "", parentId: "", description: "" });
  const [msg, setMsg] = useState("");

  const load = useCallback(async () => {
    const res = await fetch(`/api/admin/menu-items?menu=${menu}`);
    if (res.ok) setItems((await res.json()).items);
  }, [menu]);
  useEffect(() => { void load(); }, [load]);

  const patch = (id: number, body: Record<string, unknown>) =>
    fetch("/api/admin/menu-items", { method: "PATCH", headers: { "content-type": "application/json" }, body: JSON.stringify({ id, ...body }) });

  const setLocal = (id: number, field: keyof Item, value: unknown) =>
    setItems((xs) => xs.map((x) => (x.id === id ? { ...x, [field]: value } : x)));

  async function saveField(it: Item, field: "label" | "href" | "description") {
    await patch(it.id, { [field]: it[field] ?? "" });
    setMsg("Saved.");
  }
  async function saveParent(it: Item, parentId: number | null) {
    setLocal(it.id, "parentId", parentId);
    await patch(it.id, { parentId });
    setMsg("Saved.");
  }

  async function move(it: Item, dir: -1 | 1) {
    const col = items.filter((x) => x.locale === it.locale && x.parentId === it.parentId).sort((a, b) => a.position - b.position);
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
      body: JSON.stringify({ menu, locale: form.locale, label: form.label, href: form.href, position: maxPos + 1,
        parentId: form.parentId ? Number(form.parentId) : null, description: form.description })
    });
    if (res.ok) { setForm({ locale: form.locale, label: "", href: "", parentId: "", description: "" }); void load(); }
    else setMsg((await res.json()).error ?? "error");
  }

  async function del(id: number) {
    if (!confirm("Delete this menu item (and any children)?")) return;
    await fetch(`/api/admin/menu-items?id=${id}`, { method: "DELETE" });
    void load();
  }

  const locales = Array.from(new Set(items.map((i) => i.locale))).sort();
  const inp = "w-full rounded-md border border-border bg-background px-2.5 py-1.5 text-sm";
  const topLevel = (loc: string) => items.filter((i) => i.locale === loc && i.parentId === null).sort((a, b) => a.position - b.position);

  return (
    <section className="space-y-6">
      <div>
        <h2 className="text-lg font-semibold">Menu: {menu}</h2>
        <p className="text-sm text-muted-foreground">Build the top nav and its mega-menu dropdowns. Give an item a <strong>Parent</strong> to nest it into a dropdown; add a short <strong>description</strong> shown under the link in the panel. Reorder within a group with the arrows.</p>
      </div>

      {locales.map((loc) => {
        const tops = topLevel(loc);
        const renderRow = (it: Item, isChild: boolean) => (
          <div key={it.id} className={isChild ? "ml-6 border-l-2 border-border pl-3" : ""}>
            <div className="flex items-start gap-2 py-2">
              <div className="flex flex-col pt-1">
                <button onClick={() => move(it, -1)} className="text-muted-foreground hover:text-primary" title="Move up"><ArrowUp className="h-3.5 w-3.5" /></button>
                <button onClick={() => move(it, 1)} className="text-muted-foreground hover:text-primary" title="Move down"><ArrowDown className="h-3.5 w-3.5" /></button>
              </div>
              <div className="flex-1 space-y-1.5">
                <div className="flex flex-wrap gap-2">
                  <input className={`${inp} max-w-[12rem] flex-1`} value={it.label} onChange={(e) => setLocal(it.id, "label", e.target.value)} onBlur={() => saveField(it, "label")} placeholder="label" />
                  <input className={`${inp} flex-1`} value={it.href} onChange={(e) => setLocal(it.id, "href", e.target.value)} onBlur={() => saveField(it, "href")} placeholder="/en/about" />
                  <select className={`${inp} max-w-[11rem]`} value={it.parentId ?? ""} onChange={(e) => saveParent(it, e.target.value ? Number(e.target.value) : null)}>
                    <option value="">— top level —</option>
                    {tops.filter((p) => p.id !== it.id).map((p) => <option key={p.id} value={p.id}>under: {p.label}</option>)}
                  </select>
                </div>
                <input className={inp} value={it.description ?? ""} onChange={(e) => setLocal(it.id, "description", e.target.value)} onBlur={() => saveField(it, "description")} placeholder="Short description (shown in the dropdown panel)" />
              </div>
              <button onClick={() => del(it.id)} title="Delete" className="mt-1 rounded-md p-1.5 text-muted-foreground hover:text-red-500"><Trash2 className="h-4 w-4" /></button>
            </div>
          </div>
        );
        return (
          <div key={loc} className="rounded-xl border border-border">
            <div className="border-b border-border bg-muted/40 px-4 py-2 text-xs font-semibold uppercase tracking-wide text-muted-foreground">{loc}</div>
            <div className="divide-y divide-border px-3">
              {tops.map((top) => (
                <div key={top.id} className="py-1">
                  {renderRow(top, false)}
                  {items.filter((c) => c.parentId === top.id).sort((a, b) => a.position - b.position).map((c) => renderRow(c, true))}
                </div>
              ))}
              {!tops.length && <div className="p-3 text-sm text-muted-foreground">No items.</div>}
            </div>
          </div>
        );
      })}

      <form onSubmit={add} className="space-y-2 rounded-xl border border-dashed border-border p-4">
        <div className="flex flex-wrap items-end gap-2">
          <select className="rounded-md border border-border bg-background px-3 py-2 text-sm" value={form.locale} onChange={(e) => setForm({ ...form, locale: e.target.value })}>
            <option value="en">en</option><option value="nl">nl</option>
          </select>
          <input className="rounded-md border border-border bg-background px-3 py-2 text-sm" placeholder="Label" value={form.label} onChange={(e) => setForm({ ...form, label: e.target.value })} />
          <input className="rounded-md border border-border bg-background px-3 py-2 text-sm" placeholder="/en/about" value={form.href} onChange={(e) => setForm({ ...form, href: e.target.value })} />
          <select className="rounded-md border border-border bg-background px-3 py-2 text-sm" value={form.parentId} onChange={(e) => setForm({ ...form, parentId: e.target.value })}>
            <option value="">— top level —</option>
            {topLevel(form.locale).map((p) => <option key={p.id} value={p.id}>under: {p.label}</option>)}
          </select>
          <Button type="submit"><Plus className="mr-1 h-4 w-4" /> Add</Button>
        </div>
        <input className="w-full rounded-md border border-border bg-background px-3 py-2 text-sm" placeholder="Description (optional — shown in dropdown)" value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} />
        {msg && <span className="text-sm text-muted-foreground">{msg}</span>}
      </form>
    </section>
  );
}
