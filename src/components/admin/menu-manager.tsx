"use client";
import { useEffect, useState, useCallback } from "react";
import { Button } from "@/components/ui/button";

type Item = { id: number; locale: string; label: string; href: string; position: number };

export function MenuManager({ menu = "main" }: { menu?: string }) {
  const [items, setItems] = useState<Item[]>([]);
  const [form, setForm] = useState({ locale: "en", label: "", href: "", position: 0 });
  const [msg, setMsg] = useState("");

  const load = useCallback(async () => {
    const res = await fetch(`/api/admin/menu-items?menu=${menu}`);
    if (res.ok) setItems((await res.json()).items);
  }, [menu]);
  useEffect(() => { void load(); }, [load]);

  async function add(e: React.FormEvent) {
    e.preventDefault();
    setMsg("");
    const res = await fetch("/api/admin/menu-items", {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ menu, ...form })
    });
    if (res.ok) { setForm({ locale: "en", label: "", href: "", position: 0 }); void load(); }
    else setMsg((await res.json()).error ?? "error");
  }

  async function del(id: number) {
    await fetch(`/api/admin/menu-items?id=${id}`, { method: "DELETE" });
    void load();
  }

  return (
    <section className="space-y-4">
      <h2 className="font-semibold">Menu: {menu}</h2>
      <table className="w-full text-sm">
        <thead><tr className="text-left text-muted-foreground">
          <th>Locale</th><th>Label</th><th>Href</th><th>Pos</th><th></th>
        </tr></thead>
        <tbody>
          {items.map((it) => (
            <tr key={it.id} className="border-t border-border">
              <td>{it.locale}</td><td>{it.label}</td><td>{it.href}</td><td>{it.position}</td>
              <td><button className="text-red-500" onClick={() => del(it.id)}>delete</button></td>
            </tr>
          ))}
          {!items.length && <tr><td colSpan={5} className="py-2 text-muted-foreground">No items.</td></tr>}
        </tbody>
      </table>

      <form onSubmit={add} className="flex flex-wrap items-end gap-2 rounded-lg border border-border p-4">
        <select className="rounded-lg border border-border bg-background px-3 py-2"
          value={form.locale} onChange={(e) => setForm({ ...form, locale: e.target.value })}>
          <option value="en">en</option><option value="nl">nl</option>
        </select>
        <input className="rounded-lg border border-border bg-background px-3 py-2" placeholder="label"
          value={form.label} onChange={(e) => setForm({ ...form, label: e.target.value })} />
        <input className="rounded-lg border border-border bg-background px-3 py-2" placeholder="/en/about"
          value={form.href} onChange={(e) => setForm({ ...form, href: e.target.value })} />
        <input type="number" className="w-20 rounded-lg border border-border bg-background px-3 py-2" placeholder="pos"
          value={form.position} onChange={(e) => setForm({ ...form, position: Number(e.target.value) })} />
        <Button type="submit">Add</Button>
        {msg && <span className="text-sm text-red-500">{msg}</span>}
      </form>
    </section>
  );
}
