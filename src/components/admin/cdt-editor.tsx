"use client";
import { useEffect, useState, useCallback } from "react";
import { Button } from "@/components/ui/button";
import type { CDT } from "@/lib/cdt";

// Admin editor for the Cyber Digital Twin (CDT) flagship page content
// (site_blocks key "cdt_home"). Mirrors src/components/admin/cra-home-editor.tsx
// — same load/edit/save shape, same per-locale tab pattern.
//
// Only the top-level text sections get dedicated inputs (hero, statBand,
// livingModel intro+points, boms intro, consequence, priority intro,
// monteCarlo intro, methodology intro+steps, outcomes, finalCta). Deeper
// structured data (living-model layers, BOM type cards, the drilldown table,
// consequence methods, priority buckets, Monte Carlo bins/ci/scenarios) has no
// bespoke input here — the whole CDT object round-trips on every save, so
// that data persists untouched even though this editor doesn't expose it.
//
// NOT registered in admin-shell.tsx — a later phase wires it in.
// Export name: CdtEditor. Section key to use when wiring it in: "cdt".

type Both = { en: CDT; nl: CDT };
type Loc = "en" | "nl";

const field = "w-full rounded-lg border border-border bg-background px-3 py-2 text-sm";
const lbl = "block text-xs font-medium text-muted-foreground mb-1";
const box = "space-y-3 rounded-lg border border-border p-4";
const head = "text-xs font-semibold uppercase tracking-wide text-muted-foreground";

export function CdtEditor() {
  const [data, setData] = useState<Both | null>(null);
  const [loc, setLoc] = useState<Loc>("en");
  const [msg, setMsg] = useState("");
  const [saving, setSaving] = useState(false);

  const load = useCallback(async () => {
    const res = await fetch("/api/admin/cdt");
    if (res.ok) setData(await res.json());
  }, []);
  useEffect(() => {
    void load();
  }, [load]);

  // Immutable deep edit of the current locale's content.
  function edit(fn: (c: CDT) => void) {
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
    const res = await fetch("/api/admin/cdt", {
      method: "PUT",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ locale: loc, data: data[loc] })
    });
    setMsg(
      res.ok
        ? "Saved. The Cyber Digital Twin page updates on next load."
        : ((await res.json().catch(() => ({}))).error ?? "error")
    );
    setSaving(false);
  }

  if (!data)
    return (
      <section>
        <h2 className="font-semibold">Cyber Digital Twin page content</h2>
        <p className="text-sm text-muted-foreground">Loading…</p>
      </section>
    );

  const c = data[loc];

  return (
    <section className="space-y-5">
      <div className="flex items-center justify-between">
        <h2 className="font-semibold">Cyber Digital Twin page content</h2>
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
        <div><label className={lbl}>Eyebrow</label><input className={field} value={c.hero.eyebrow} onChange={(e) => edit((c) => { c.hero.eyebrow = e.target.value; })} /></div>
        <div><label className={lbl}>Title</label><textarea className={`${field} h-16`} value={c.hero.title} onChange={(e) => edit((c) => { c.hero.title = e.target.value; })} /></div>
        <div><label className={lbl}>Title accent (highlighted line)</label><input className={field} value={c.hero.titleAccent} onChange={(e) => edit((c) => { c.hero.titleAccent = e.target.value; })} /></div>
        <div><label className={lbl}>Subtitle</label><textarea className={`${field} h-24`} value={c.hero.subtitle} onChange={(e) => edit((c) => { c.hero.subtitle = e.target.value; })} /></div>
        {c.hero.badges.map((b, i) => (
          <div key={i}><label className={lbl}>Badge {i + 1}</label><input className={field} value={b} onChange={(e) => edit((c) => { c.hero.badges[i] = e.target.value; })} /></div>
        ))}
        <div><label className={lbl}>CTA label</label><input className={field} value={c.hero.ctaLabel} onChange={(e) => edit((c) => { c.hero.ctaLabel = e.target.value; })} /></div>
      </div>

      {/* STAT BAND */}
      <div className={box}>
        <p className={head}>Stat band</p>
        {c.statBand.items.map((s, i) => (
          <div key={i} className="grid grid-cols-3 gap-2 rounded-md border border-border/60 p-3">
            <div><label className={lbl}>Value</label><input className={field} value={s.value} onChange={(e) => edit((c) => { c.statBand.items[i].value = e.target.value; })} /></div>
            <div><label className={lbl}>Label</label><input className={field} value={s.label} onChange={(e) => edit((c) => { c.statBand.items[i].label = e.target.value; })} /></div>
            <div><label className={lbl}>Sub (optional)</label><input className={field} value={s.sub ?? ""} onChange={(e) => edit((c) => { c.statBand.items[i].sub = e.target.value; })} /></div>
          </div>
        ))}
      </div>

      {/* LIVING MODEL */}
      <div className={box}>
        <p className={head}>Living model (seven-layer graph)</p>
        <div><label className={lbl}>Eyebrow</label><input className={field} value={c.livingModel.eyebrow} onChange={(e) => edit((c) => { c.livingModel.eyebrow = e.target.value; })} /></div>
        <div><label className={lbl}>Title</label><input className={field} value={c.livingModel.title} onChange={(e) => edit((c) => { c.livingModel.title = e.target.value; })} /></div>
        <div><label className={lbl}>Body</label><textarea className={`${field} h-20`} value={c.livingModel.body} onChange={(e) => edit((c) => { c.livingModel.body = e.target.value; })} /></div>
        {c.livingModel.points.map((p, i) => (
          <div key={i}><label className={lbl}>Point {i + 1}</label><input className={field} value={p} onChange={(e) => edit((c) => { c.livingModel.points[i] = e.target.value; })} /></div>
        ))}
        <p className="text-xs text-muted-foreground">The seven graph layers themselves are edited via raw data only (not exposed here); this save will not disturb them.</p>
      </div>

      {/* BOMS */}
      <div className={box}>
        <p className={head}>BOMs (DEXPI-extended bills of materials)</p>
        <div><label className={lbl}>Eyebrow</label><input className={field} value={c.boms.eyebrow} onChange={(e) => edit((c) => { c.boms.eyebrow = e.target.value; })} /></div>
        <div><label className={lbl}>Title</label><input className={field} value={c.boms.title} onChange={(e) => edit((c) => { c.boms.title = e.target.value; })} /></div>
        <div><label className={lbl}>Intro</label><textarea className={`${field} h-20`} value={c.boms.intro} onChange={(e) => edit((c) => { c.boms.intro = e.target.value; })} /></div>
        <div><label className={lbl}>Standard note</label><textarea className={`${field} h-16`} value={c.boms.standardNote} onChange={(e) => edit((c) => { c.boms.standardNote = e.target.value; })} /></div>
        <div><label className={lbl}>Dependency note</label><textarea className={`${field} h-16`} value={c.boms.dependencyNote} onChange={(e) => edit((c) => { c.boms.dependencyNote = e.target.value; })} /></div>
      </div>

      {/* CONSEQUENCE */}
      <div className={box}>
        <p className={head}>Consequence-driven methods</p>
        <div><label className={lbl}>Eyebrow</label><input className={field} value={c.consequence.eyebrow} onChange={(e) => edit((c) => { c.consequence.eyebrow = e.target.value; })} /></div>
        <div><label className={lbl}>Title</label><input className={field} value={c.consequence.title} onChange={(e) => edit((c) => { c.consequence.title = e.target.value; })} /></div>
        <div><label className={lbl}>Intro</label><textarea className={`${field} h-20`} value={c.consequence.intro} onChange={(e) => edit((c) => { c.consequence.intro = e.target.value; })} /></div>
        <div><label className={lbl}>Note</label><textarea className={`${field} h-16`} value={c.consequence.note} onChange={(e) => edit((c) => { c.consequence.note = e.target.value; })} /></div>
      </div>

      {/* PRIORITY */}
      <div className={box}>
        <p className={head}>NOW / NEXT / NEVER prioritization</p>
        <div><label className={lbl}>Eyebrow</label><input className={field} value={c.priority.eyebrow} onChange={(e) => edit((c) => { c.priority.eyebrow = e.target.value; })} /></div>
        <div><label className={lbl}>Title</label><input className={field} value={c.priority.title} onChange={(e) => edit((c) => { c.priority.title = e.target.value; })} /></div>
        <div><label className={lbl}>Intro</label><textarea className={`${field} h-20`} value={c.priority.intro} onChange={(e) => edit((c) => { c.priority.intro = e.target.value; })} /></div>
        <div><label className={lbl}>Rule</label><textarea className={`${field} h-16`} value={c.priority.rule} onChange={(e) => edit((c) => { c.priority.rule = e.target.value; })} /></div>
      </div>

      {/* MONTE CARLO */}
      <div className={box}>
        <p className={head}>Monte Carlo prediction pipeline</p>
        <div><label className={lbl}>Eyebrow</label><input className={field} value={c.monteCarlo.eyebrow} onChange={(e) => edit((c) => { c.monteCarlo.eyebrow = e.target.value; })} /></div>
        <div><label className={lbl}>Title</label><input className={field} value={c.monteCarlo.title} onChange={(e) => edit((c) => { c.monteCarlo.title = e.target.value; })} /></div>
        <div><label className={lbl}>Intro</label><textarea className={`${field} h-20`} value={c.monteCarlo.intro} onChange={(e) => edit((c) => { c.monteCarlo.intro = e.target.value; })} /></div>
        <div><label className={lbl}>Runs label</label><input className={field} value={c.monteCarlo.runsLabel} onChange={(e) => edit((c) => { c.monteCarlo.runsLabel = e.target.value; })} /></div>
      </div>

      {/* METHODOLOGY */}
      <div className={box}>
        <p className={head}>Methodology (Assess → Model → Improve → Sustain)</p>
        <div><label className={lbl}>Eyebrow</label><input className={field} value={c.methodology.eyebrow} onChange={(e) => edit((c) => { c.methodology.eyebrow = e.target.value; })} /></div>
        <div><label className={lbl}>Title</label><input className={field} value={c.methodology.title} onChange={(e) => edit((c) => { c.methodology.title = e.target.value; })} /></div>
        <div><label className={lbl}>Intro</label><textarea className={`${field} h-20`} value={c.methodology.intro} onChange={(e) => edit((c) => { c.methodology.intro = e.target.value; })} /></div>
        {c.methodology.steps.map((s, i) => (
          <div key={i} className="grid grid-cols-[auto_1fr] items-end gap-2 rounded-md border border-border/60 p-3">
            <div><label className={lbl}>No.</label><input className={`${field} w-16`} value={s.number} onChange={(e) => edit((c) => { c.methodology.steps[i].number = e.target.value; })} /></div>
            <div><label className={lbl}>Title</label><input className={field} value={s.title} onChange={(e) => edit((c) => { c.methodology.steps[i].title = e.target.value; })} /></div>
            <div className="col-span-2"><label className={lbl}>Body</label><textarea className={`${field} h-16`} value={s.body} onChange={(e) => edit((c) => { c.methodology.steps[i].body = e.target.value; })} /></div>
          </div>
        ))}
      </div>

      {/* OUTCOMES */}
      <div className={box}>
        <p className={head}>Outcomes</p>
        <div><label className={lbl}>Eyebrow</label><input className={field} value={c.outcomes.eyebrow} onChange={(e) => edit((c) => { c.outcomes.eyebrow = e.target.value; })} /></div>
        <div><label className={lbl}>Title</label><input className={field} value={c.outcomes.title} onChange={(e) => edit((c) => { c.outcomes.title = e.target.value; })} /></div>
        <div><label className={lbl}>Intro</label><textarea className={`${field} h-20`} value={c.outcomes.intro} onChange={(e) => edit((c) => { c.outcomes.intro = e.target.value; })} /></div>
      </div>

      {/* FINAL CTA */}
      <div className={box}>
        <p className={head}>Final CTA</p>
        <div><label className={lbl}>Title</label><input className={field} value={c.finalCta.title} onChange={(e) => edit((c) => { c.finalCta.title = e.target.value; })} /></div>
        <div><label className={lbl}>Line</label><textarea className={`${field} h-16`} value={c.finalCta.line} onChange={(e) => edit((c) => { c.finalCta.line = e.target.value; })} /></div>
        <div><label className={lbl}>CTA label</label><input className={field} value={c.finalCta.ctaLabel} onChange={(e) => edit((c) => { c.finalCta.ctaLabel = e.target.value; })} /></div>
      </div>

      <div className="flex items-center gap-3">
        <Button type="button" onClick={save} disabled={saving}>
          {saving ? "Saving…" : `Save ${loc.toUpperCase()} Cyber Digital Twin page`}
        </Button>
        {msg && <span className="text-sm text-muted-foreground">{msg}</span>}
      </div>
      <p className="text-xs text-muted-foreground">
        Edits are per-locale and saved to the database — they take over from the built-in defaults.
        Only the top-level text sections above have dedicated fields; the seven-layer graph, BOM type
        cards, drilldown table, consequence methods, priority buckets, and Monte Carlo bins/scenarios
        are saved untouched along with the rest of the object.
      </p>
    </section>
  );
}
