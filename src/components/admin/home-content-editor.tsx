"use client";
import { useEffect, useState, useCallback } from "react";
import { Button } from "@/components/ui/button";
import type { HomeContent } from "@/lib/site-content";

type Both = { en: HomeContent; nl: HomeContent };
type Loc = "en" | "nl";

const field = "w-full rounded-lg border border-border bg-background px-3 py-2 text-sm";
const lbl = "block text-xs font-medium text-muted-foreground mb-1";

export function HomeContentEditor() {
  const [data, setData] = useState<Both | null>(null);
  const [loc, setLoc] = useState<Loc>("en");
  const [msg, setMsg] = useState("");
  const [saving, setSaving] = useState(false);

  const load = useCallback(async () => {
    const res = await fetch("/api/admin/site-content");
    if (res.ok) setData(await res.json());
  }, []);
  useEffect(() => { void load(); }, [load]);

  // Immutable deep edit of the current locale's content.
  function edit(fn: (c: HomeContent) => void) {
    setData((d) => {
      if (!d) return d;
      const copy: Both = structuredClone(d);
      fn(copy[loc]);
      return copy;
    });
  }

  async function save() {
    if (!data) return;
    setSaving(true); setMsg("");
    const res = await fetch("/api/admin/site-content", {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ locale: loc, data: data[loc] })
    });
    setMsg(res.ok ? "Saved. The homepage updates on next load." : ((await res.json()).error ?? "error"));
    setSaving(false);
  }

  if (!data) return <section><h2 className="font-semibold">Homepage content</h2><p className="text-sm text-muted-foreground">Loading…</p></section>;

  const c = data[loc];
  const h = c.hero;
  const s = c.services;

  return (
    <section className="space-y-5">
      <div className="flex items-center justify-between">
        <h2 className="font-semibold">Homepage content (hero + services)</h2>
        <div className="flex gap-1 rounded-lg border border-border p-1 text-sm">
          {(["en", "nl"] as Loc[]).map((l) => (
            <button key={l} onClick={() => setLoc(l)}
              className={`rounded px-3 py-1 ${loc === l ? "bg-primary text-primary-foreground" : ""}`}>{l}</button>
          ))}
        </div>
      </div>

      {/* HERO */}
      <div className="space-y-3 rounded-lg border border-border p-4">
        <p className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">Hero</p>
        <div><label className={lbl}>Eyebrow</label><input className={field} value={h.kicker} onChange={(e) => edit((c) => { c.hero.kicker = e.target.value; })} /></div>
        <div><label className={lbl}>Headline (H1)</label><textarea className={`${field} h-16`} value={h.title} onChange={(e) => edit((c) => { c.hero.title = e.target.value; })} /></div>
        <div><label className={lbl}>Lede</label><textarea className={`${field} h-20`} value={h.subtitle} onChange={(e) => edit((c) => { c.hero.subtitle = e.target.value; })} /></div>
        <div className="grid grid-cols-2 gap-2">
          <div><label className={lbl}>Primary button</label><input className={field} value={h.cta} onChange={(e) => edit((c) => { c.hero.cta = e.target.value; })} /></div>
          <div><label className={lbl}>Secondary link</label><input className={field} value={h.cta2} onChange={(e) => edit((c) => { c.hero.cta2 = e.target.value; })} /></div>
        </div>
        <div className="grid grid-cols-2 gap-2">
          <div><label className={lbl}>Trust label</label><input className={field} value={h.trustLabel} onChange={(e) => edit((c) => { c.hero.trustLabel = e.target.value; })} /></div>
          <div><label className={lbl}>Industries (comma-separated)</label><input className={field} value={h.industries.join(", ")} onChange={(e) => edit((c) => { c.hero.industries = e.target.value.split(",").map((x) => x.trim()).filter(Boolean); })} /></div>
        </div>

        <p className="pt-1 text-xs font-semibold uppercase tracking-wide text-muted-foreground">Insight card</p>
        <div className="grid grid-cols-3 gap-2">
          <div><label className={lbl}>Card title</label><input className={field} value={h.card.title} onChange={(e) => edit((c) => { c.hero.card.title = e.target.value; })} /></div>
          <div><label className={lbl}>Card tag</label><input className={field} value={h.card.tag} onChange={(e) => edit((c) => { c.hero.card.tag = e.target.value; })} /></div>
          <div><label className={lbl}>Findings label</label><input className={field} value={h.card.findingsLabel} onChange={(e) => edit((c) => { c.hero.card.findingsLabel = e.target.value; })} /></div>
        </div>
        {h.card.stats.map((st, i) => (
          <div key={i} className="grid grid-cols-[1fr_2fr_auto] items-end gap-2">
            <div><label className={lbl}>Stat {i + 1} number</label><input className={field} value={st.n} onChange={(e) => edit((c) => { c.hero.card.stats[i].n = e.target.value; })} /></div>
            <div><label className={lbl}>Label</label><input className={field} value={st.l} onChange={(e) => edit((c) => { c.hero.card.stats[i].l = e.target.value; })} /></div>
            <label className="flex items-center gap-1 pb-2 text-xs"><input type="checkbox" checked={st.accent} onChange={(e) => edit((c) => { c.hero.card.stats[i].accent = e.target.checked; })} />orange</label>
          </div>
        ))}
      </div>

      {/* SERVICES */}
      <div className="space-y-3 rounded-lg border border-border p-4">
        <p className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">Services</p>
        <div className="grid grid-cols-2 gap-2">
          <div><label className={lbl}>Eyebrow</label><input className={field} value={s.eyebrow} onChange={(e) => edit((c) => { c.services.eyebrow = e.target.value; })} /></div>
          <div><label className={lbl}>Heading (H2)</label><input className={field} value={s.heading} onChange={(e) => edit((c) => { c.services.heading = e.target.value; })} /></div>
        </div>
        <div><label className={lbl}>Intro</label><textarea className={`${field} h-16`} value={s.intro} onChange={(e) => edit((c) => { c.services.intro = e.target.value; })} /></div>
        <div><label className={lbl}>Service link text</label><input className={field} value={s.more} onChange={(e) => edit((c) => { c.services.more = e.target.value; })} /></div>

        <p className="pt-1 text-xs font-semibold uppercase tracking-wide text-muted-foreground">Service items</p>
        {s.items.map((it, i) => (
          <div key={i} className="space-y-2 rounded-md border border-border/60 p-3">
            <div className="flex items-center justify-between">
              <span className="text-xs text-muted-foreground">#{String(i + 1).padStart(2, "0")}</span>
              <button className="text-xs text-red-500" onClick={() => edit((c) => { c.services.items.splice(i, 1); })}>remove</button>
            </div>
            <input className={field} placeholder="title" value={it.name} onChange={(e) => edit((c) => { c.services.items[i].name = e.target.value; })} />
            <textarea className={`${field} h-16`} placeholder="description" value={it.desc} onChange={(e) => edit((c) => { c.services.items[i].desc = e.target.value; })} />
            <input className={field} placeholder="link (e.g. /services)" value={it.href} onChange={(e) => edit((c) => { c.services.items[i].href = e.target.value; })} />
          </div>
        ))}
        <Button type="button" variant="outline" onClick={() => edit((c) => { c.services.items.push({ name: "", desc: "", href: "/services" }); })}>+ Add service</Button>

        <p className="pt-1 text-xs font-semibold uppercase tracking-wide text-muted-foreground">CTA cell</p>
        <div className="grid grid-cols-3 gap-2">
          <div><label className={lbl}>Title</label><input className={field} value={s.cta.title} onChange={(e) => edit((c) => { c.services.cta.title = e.target.value; })} /></div>
          <div><label className={lbl}>Body</label><input className={field} value={s.cta.body} onChange={(e) => edit((c) => { c.services.cta.body = e.target.value; })} /></div>
          <div><label className={lbl}>Button</label><input className={field} value={s.cta.button} onChange={(e) => edit((c) => { c.services.cta.button = e.target.value; })} /></div>
        </div>
      </div>

      <div className="flex items-center gap-3">
        <Button type="button" onClick={save} disabled={saving}>{saving ? "Saving…" : `Save ${loc.toUpperCase()} homepage`}</Button>
        {msg && <span className="text-sm text-muted-foreground">{msg}</span>}
      </div>
      <p className="text-xs text-muted-foreground">Edits are per-locale. Styling/layout is fixed by the design; you edit the text, numbers, industries, stats and service list.</p>
    </section>
  );
}
