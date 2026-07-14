"use client";
import { useEffect, useState, useCallback } from "react";
import { Button } from "@/components/ui/button";
import type { ConformityHome } from "@/lib/conformity-home";

type Both = { en: ConformityHome; nl: ConformityHome };
type Loc = "en" | "nl";

const field = "w-full rounded-lg border border-border bg-background px-3 py-2 text-sm";
const lbl = "block text-xs font-medium text-muted-foreground mb-1";
const box = "space-y-3 rounded-lg border border-border p-4";
const head = "text-xs font-semibold uppercase tracking-wide text-muted-foreground";

export function ConformityHomeEditor() {
  const [data, setData] = useState<Both | null>(null);
  const [loc, setLoc] = useState<Loc>("en");
  const [msg, setMsg] = useState("");
  const [saving, setSaving] = useState(false);

  const load = useCallback(async () => {
    const res = await fetch("/api/admin/conformity-home");
    if (res.ok) setData(await res.json());
  }, []);
  useEffect(() => {
    void load();
  }, [load]);

  // Immutable deep edit of the current locale's content.
  function edit(fn: (c: ConformityHome) => void) {
    setData((d) => {
      if (!d) return d;
      const copy: Both = structuredClone(d);
      fn(copy[loc]);
      return copy;
    });
  }

  async function save() {
    if (!data) return;
    setSaving(true);
    setMsg("");
    const res = await fetch("/api/admin/conformity-home", {
      method: "PUT",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ locale: loc, data: data[loc] })
    });
    setMsg(
      res.ok
        ? "Saved. The home page updates on next load."
        : ((await res.json().catch(() => ({}))).error ?? "error")
    );
    setSaving(false);
  }

  if (!data)
    return (
      <section>
        <h2 className="font-semibold">Home page content</h2>
        <p className="text-sm text-muted-foreground">Loading…</p>
      </section>
    );

  const c = data[loc];

  return (
    <section className="space-y-5">
      <div className="flex items-center justify-between">
        <h2 className="font-semibold">Home page content (conformity landing)</h2>
        <div className="flex gap-1 rounded-lg border border-border p-1 text-sm">
          {(["en", "nl"] as Loc[]).map((l) => (
            <button
              key={l}
              onClick={() => setLoc(l)}
              className={`rounded px-3 py-1 ${loc === l ? "bg-primary text-primary-foreground" : ""}`}
            >
              {l}
            </button>
          ))}
        </div>
      </div>

      {/* HERO */}
      <div className={box}>
        <p className={head}>Hero</p>
        <div>
          <label className={lbl}>Eyebrow</label>
          <input className={field} value={c.hero.eyebrow} onChange={(e) => edit((c) => { c.hero.eyebrow = e.target.value; })} />
        </div>
        <div>
          <label className={lbl}>Title (H1)</label>
          <textarea className={`${field} h-16`} value={c.hero.title} onChange={(e) => edit((c) => { c.hero.title = e.target.value; })} />
        </div>
        <div>
          <label className={lbl}>Subtitle</label>
          <textarea className={`${field} h-24`} value={c.hero.subtitle} onChange={(e) => edit((c) => { c.hero.subtitle = e.target.value; })} />
        </div>
        <div className="grid grid-cols-2 gap-2">
          <div><label className={lbl}>Primary CTA label</label><input className={field} value={c.hero.primaryCta.label} onChange={(e) => edit((c) => { c.hero.primaryCta.label = e.target.value; })} /></div>
          <div><label className={lbl}>Primary CTA href</label><input className={field} value={c.hero.primaryCta.href} onChange={(e) => edit((c) => { c.hero.primaryCta.href = e.target.value; })} /></div>
          <div><label className={lbl}>Secondary CTA label</label><input className={field} value={c.hero.secondaryCta.label} onChange={(e) => edit((c) => { c.hero.secondaryCta.label = e.target.value; })} /></div>
          <div><label className={lbl}>Secondary CTA href</label><input className={field} value={c.hero.secondaryCta.href} onChange={(e) => edit((c) => { c.hero.secondaryCta.href = e.target.value; })} /></div>
        </div>
        {c.hero.bullets.map((b, i) => (
          <div key={i}>
            <label className={lbl}>Bullet {i + 1}</label>
            <input className={field} value={b} onChange={(e) => edit((c) => { c.hero.bullets[i] = e.target.value; })} />
          </div>
        ))}
      </div>

      {/* LOGO WALL */}
      <div className={box}>
        <p className={head}>Regulation band</p>
        <div><label className={lbl}>Title</label><input className={field} value={c.logoWall.title} onChange={(e) => edit((c) => { c.logoWall.title = e.target.value; })} /></div>
        {c.logoWall.logos.map((g, i) => (
          <div key={i}><label className={lbl}>Logo {i + 1}</label><input className={field} value={g} onChange={(e) => edit((c) => { c.logoWall.logos[i] = e.target.value; })} /></div>
        ))}
      </div>

      {/* STATS */}
      <div className={box}>
        <p className={head}>Stats</p>
        {c.stats.map((s, i) => (
          <div key={i} className="grid grid-cols-3 gap-2">
            <div><label className={lbl}>Value</label><input className={field} value={s.value} onChange={(e) => edit((c) => { c.stats[i].value = e.target.value; })} /></div>
            <div><label className={lbl}>Label</label><input className={field} value={s.label} onChange={(e) => edit((c) => { c.stats[i].label = e.target.value; })} /></div>
            <div><label className={lbl}>Sublabel</label><input className={field} value={s.sublabel} onChange={(e) => edit((c) => { c.stats[i].sublabel = e.target.value; })} /></div>
          </div>
        ))}
      </div>

      {/* FEATURE GRID */}
      <div className={box}>
        <p className={head}>Feature grid</p>
        <div><label className={lbl}>Eyebrow</label><input className={field} value={c.featureGrid.eyebrow} onChange={(e) => edit((c) => { c.featureGrid.eyebrow = e.target.value; })} /></div>
        <div><label className={lbl}>Title</label><input className={field} value={c.featureGrid.title} onChange={(e) => edit((c) => { c.featureGrid.title = e.target.value; })} /></div>
        <div><label className={lbl}>Subtitle</label><textarea className={`${field} h-16`} value={c.featureGrid.subtitle} onChange={(e) => edit((c) => { c.featureGrid.subtitle = e.target.value; })} /></div>
        {c.featureGrid.features.map((f, i) => (
          <div key={i} className="space-y-2 rounded-md border border-border/60 p-3">
            <span className="text-xs text-muted-foreground">Feature #{i + 1}</span>
            <input className={field} placeholder="title" value={f.title} onChange={(e) => edit((c) => { c.featureGrid.features[i].title = e.target.value; })} />
            <textarea className={`${field} h-16`} placeholder="description" value={f.description} onChange={(e) => edit((c) => { c.featureGrid.features[i].description = e.target.value; })} />
            <input className={field} placeholder="icon (Library, FileCheck, ScanSearch, FileOutput, ShieldAlert, Users)" value={f.icon} onChange={(e) => edit((c) => { c.featureGrid.features[i].icon = e.target.value; })} />
          </div>
        ))}
      </div>

      {/* PROBLEM */}
      <div className={box}>
        <p className={head}>Problem</p>
        <div><label className={lbl}>Eyebrow</label><input className={field} value={c.problem.eyebrow} onChange={(e) => edit((c) => { c.problem.eyebrow = e.target.value; })} /></div>
        <div><label className={lbl}>Title</label><input className={field} value={c.problem.title} onChange={(e) => edit((c) => { c.problem.title = e.target.value; })} /></div>
        <div><label className={lbl}>Body</label><textarea className={`${field} h-24`} value={c.problem.body} onChange={(e) => edit((c) => { c.problem.body = e.target.value; })} /></div>
        {c.problem.bullets.map((b, i) => (
          <div key={i}><label className={lbl}>Bullet {i + 1}</label><input className={field} value={b} onChange={(e) => edit((c) => { c.problem.bullets[i] = e.target.value; })} /></div>
        ))}
        <div className="grid grid-cols-2 gap-2">
          <div><label className={lbl}>CTA label</label><input className={field} value={c.problem.cta.label} onChange={(e) => edit((c) => { c.problem.cta.label = e.target.value; })} /></div>
          <div><label className={lbl}>CTA href</label><input className={field} value={c.problem.cta.href} onChange={(e) => edit((c) => { c.problem.cta.href = e.target.value; })} /></div>
        </div>
      </div>

      {/* SHIFT */}
      <div className={box}>
        <p className={head}>Shift</p>
        <div><label className={lbl}>Eyebrow</label><input className={field} value={c.shift.eyebrow} onChange={(e) => edit((c) => { c.shift.eyebrow = e.target.value; })} /></div>
        <div><label className={lbl}>Title</label><input className={field} value={c.shift.title} onChange={(e) => edit((c) => { c.shift.title = e.target.value; })} /></div>
        <div><label className={lbl}>Body</label><textarea className={`${field} h-24`} value={c.shift.body} onChange={(e) => edit((c) => { c.shift.body = e.target.value; })} /></div>
        {c.shift.bullets.map((b, i) => (
          <div key={i}><label className={lbl}>Bullet {i + 1}</label><input className={field} value={b} onChange={(e) => edit((c) => { c.shift.bullets[i] = e.target.value; })} /></div>
        ))}
        <div className="grid grid-cols-2 gap-2">
          <div><label className={lbl}>CTA label</label><input className={field} value={c.shift.cta.label} onChange={(e) => edit((c) => { c.shift.cta.label = e.target.value; })} /></div>
          <div><label className={lbl}>CTA href</label><input className={field} value={c.shift.cta.href} onChange={(e) => edit((c) => { c.shift.cta.href = e.target.value; })} /></div>
        </div>
      </div>

      {/* COMPARISON */}
      <div className={box}>
        <p className={head}>Comparison</p>
        <div><label className={lbl}>Eyebrow</label><input className={field} value={c.comparison.eyebrow} onChange={(e) => edit((c) => { c.comparison.eyebrow = e.target.value; })} /></div>
        <div><label className={lbl}>Title</label><input className={field} value={c.comparison.title} onChange={(e) => edit((c) => { c.comparison.title = e.target.value; })} /></div>
        <div><label className={lbl}>Subtitle</label><textarea className={`${field} h-16`} value={c.comparison.subtitle} onChange={(e) => edit((c) => { c.comparison.subtitle = e.target.value; })} /></div>
        <div className="grid grid-cols-2 gap-2">
          {c.comparison.columns.map((col, i) => (
            <div key={i}><label className={lbl}>Column {i + 1}</label><input className={field} value={col} onChange={(e) => edit((c) => { c.comparison.columns[i] = e.target.value; })} /></div>
          ))}
        </div>
        {c.comparison.rows.map((r, i) => (
          <div key={i} className="grid grid-cols-[2fr_2fr_auto] items-end gap-2 rounded-md border border-border/60 p-3">
            <div><label className={lbl}>Row label</label><input className={field} value={r.label} onChange={(e) => edit((c) => { c.comparison.rows[i].label = e.target.value; })} /></div>
            <div><label className={lbl}>Left</label><input className={field} value={r.left} onChange={(e) => edit((c) => { c.comparison.rows[i].left = e.target.value; })} /></div>
            <label className="flex items-center gap-1 pb-2 text-xs"><input type="checkbox" checked={r.right} onChange={(e) => edit((c) => { c.comparison.rows[i].right = e.target.checked; })} />right ✓</label>
          </div>
        ))}
      </div>

      {/* STEPS */}
      <div className={box}>
        <p className={head}>How it works (steps)</p>
        <div><label className={lbl}>Eyebrow</label><input className={field} value={c.steps.eyebrow} onChange={(e) => edit((c) => { c.steps.eyebrow = e.target.value; })} /></div>
        <div><label className={lbl}>Title</label><input className={field} value={c.steps.title} onChange={(e) => edit((c) => { c.steps.title = e.target.value; })} /></div>
        {c.steps.steps.map((s, i) => (
          <div key={i} className="grid grid-cols-[auto_1fr] items-end gap-2 rounded-md border border-border/60 p-3">
            <div><label className={lbl}>No.</label><input className={`${field} w-16`} value={s.number} onChange={(e) => edit((c) => { c.steps.steps[i].number = e.target.value; })} /></div>
            <div><label className={lbl}>Title</label><input className={field} value={s.title} onChange={(e) => edit((c) => { c.steps.steps[i].title = e.target.value; })} /></div>
            <div className="col-span-2"><label className={lbl}>Description</label><textarea className={`${field} h-16`} value={s.description} onChange={(e) => edit((c) => { c.steps.steps[i].description = e.target.value; })} /></div>
          </div>
        ))}
      </div>

      {/* QUOTE */}
      <div className={box}>
        <p className={head}>Testimonial</p>
        <div><label className={lbl}>Quote</label><textarea className={`${field} h-20`} value={c.quote.quote} onChange={(e) => edit((c) => { c.quote.quote = e.target.value; })} /></div>
        <div className="grid grid-cols-2 gap-2">
          <div><label className={lbl}>Author</label><input className={field} value={c.quote.author} onChange={(e) => edit((c) => { c.quote.author = e.target.value; })} /></div>
          <div><label className={lbl}>Role</label><input className={field} value={c.quote.role} onChange={(e) => edit((c) => { c.quote.role = e.target.value; })} /></div>
        </div>
      </div>

      {/* FAQ */}
      <div className={box}>
        <p className={head}>FAQ</p>
        <div><label className={lbl}>Eyebrow</label><input className={field} value={c.faq.eyebrow} onChange={(e) => edit((c) => { c.faq.eyebrow = e.target.value; })} /></div>
        <div><label className={lbl}>Title</label><input className={field} value={c.faq.title} onChange={(e) => edit((c) => { c.faq.title = e.target.value; })} /></div>
        {c.faq.items.map((it, i) => (
          <div key={i} className="space-y-2 rounded-md border border-border/60 p-3">
            <span className="text-xs text-muted-foreground">Q{i + 1}</span>
            <input className={field} placeholder="question" value={it.question} onChange={(e) => edit((c) => { c.faq.items[i].question = e.target.value; })} />
            <textarea className={`${field} h-16`} placeholder="answer" value={it.answer} onChange={(e) => edit((c) => { c.faq.items[i].answer = e.target.value; })} />
          </div>
        ))}
      </div>

      {/* FINAL CTA */}
      <div className={box}>
        <p className={head}>Final CTA</p>
        <div><label className={lbl}>Title</label><input className={field} value={c.cta.title} onChange={(e) => edit((c) => { c.cta.title = e.target.value; })} /></div>
        <div><label className={lbl}>Subtitle</label><textarea className={`${field} h-16`} value={c.cta.subtitle} onChange={(e) => edit((c) => { c.cta.subtitle = e.target.value; })} /></div>
        <div className="grid grid-cols-2 gap-2">
          <div><label className={lbl}>Primary CTA label</label><input className={field} value={c.cta.primaryCta.label} onChange={(e) => edit((c) => { c.cta.primaryCta.label = e.target.value; })} /></div>
          <div><label className={lbl}>Primary CTA href</label><input className={field} value={c.cta.primaryCta.href} onChange={(e) => edit((c) => { c.cta.primaryCta.href = e.target.value; })} /></div>
          <div><label className={lbl}>Secondary CTA label</label><input className={field} value={c.cta.secondaryCta.label} onChange={(e) => edit((c) => { c.cta.secondaryCta.label = e.target.value; })} /></div>
          <div><label className={lbl}>Secondary CTA href</label><input className={field} value={c.cta.secondaryCta.href} onChange={(e) => edit((c) => { c.cta.secondaryCta.href = e.target.value; })} /></div>
        </div>
      </div>

      <div className="flex items-center gap-3">
        <Button type="button" onClick={save} disabled={saving}>
          {saving ? "Saving…" : `Save ${loc.toUpperCase()} home page`}
        </Button>
        {msg && <span className="text-sm text-muted-foreground">{msg}</span>}
      </div>
      <p className="text-xs text-muted-foreground">
        Edits are per-locale and saved to the database — they take over from the built-in defaults.
        Styling/layout is fixed by the design; you edit the text, numbers and links.
      </p>
    </section>
  );
}
