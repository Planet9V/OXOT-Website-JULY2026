"use client";
import { useEffect, useState, useCallback } from "react";
import { Button } from "@/components/ui/button";
import type { CraHome } from "@/lib/cra-home";

// Admin editor for the CRA-readiness home page content (site_blocks key
// "cra_home"). Mirrors src/components/admin/conformity-home-editor.tsx —
// same load/edit/save shape, same per-locale tab pattern.
//
// NOT registered in admin-shell.tsx (Phase C scope excludes that file — a
// later phase wires it in). Export name: CraHomeEditor. Section key to use
// when wiring it in: "cra-home".

type Both = { en: CraHome; nl: CraHome };
type Loc = "en" | "nl";

const field = "w-full rounded-lg border border-border bg-background px-3 py-2 text-sm";
const lbl = "block text-xs font-medium text-muted-foreground mb-1";
const box = "space-y-3 rounded-lg border border-border p-4";
const head = "text-xs font-semibold uppercase tracking-wide text-muted-foreground";

export function CraHomeEditor() {
  const [data, setData] = useState<Both | null>(null);
  const [loc, setLoc] = useState<Loc>("en");
  const [msg, setMsg] = useState("");
  const [saving, setSaving] = useState(false);

  const load = useCallback(async () => {
    const res = await fetch("/api/admin/cra-home");
    if (res.ok) setData(await res.json());
  }, []);
  useEffect(() => {
    void load();
  }, [load]);

  // Immutable deep edit of the current locale's content.
  function edit(fn: (c: CraHome) => void) {
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
    const res = await fetch("/api/admin/cra-home", {
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
        <h2 className="font-semibold">CRA home page content</h2>
        <p className="text-sm text-muted-foreground">Loading…</p>
      </section>
    );

  const c = data[loc];

  return (
    <section className="space-y-5">
      <div className="flex items-center justify-between">
        <h2 className="font-semibold">CRA readiness home page content</h2>
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
        <div><label className={lbl}>"2026 reality" callout</label><textarea className={`${field} h-20`} value={c.hero.realityCallout} onChange={(e) => edit((c) => { c.hero.realityCallout = e.target.value; })} /></div>
        <div><label className={lbl}>Form heading</label><input className={field} value={c.hero.formHeading} onChange={(e) => edit((c) => { c.hero.formHeading = e.target.value; })} /></div>
        <div><label className={lbl}>Form subtitle</label><input className={field} value={c.hero.formSub} onChange={(e) => edit((c) => { c.hero.formSub = e.target.value; })} /></div>
        <div><label className={lbl}>"You leave the call with…" promise</label><textarea className={`${field} h-20`} value={c.hero.leaveWith} onChange={(e) => edit((c) => { c.hero.leaveWith = e.target.value; })} /></div>
      </div>

      {/* DEPARTURE BOARD */}
      <div className={box}>
        <p className={head}>Departure board</p>
        <div><label className={lbl}>Title</label><input className={field} value={c.departureBoard.title} onChange={(e) => edit((c) => { c.departureBoard.title = e.target.value; })} /></div>
        <div><label className={lbl}>Intro</label><textarea className={`${field} h-16`} value={c.departureBoard.intro} onChange={(e) => edit((c) => { c.departureBoard.intro = e.target.value; })} /></div>
        <div className="grid grid-cols-4 gap-2">
          {c.departureBoard.axisLabels.map((l, i) => (
            <div key={i}><label className={lbl}>Axis {i + 1}</label><input className={field} value={l} onChange={(e) => edit((c) => { c.departureBoard.axisLabels[i] = e.target.value; })} /></div>
          ))}
        </div>
        <p className={head}>Milestones</p>
        {c.departureBoard.milestones.map((m, i) => (
          <div key={i} className="grid grid-cols-4 items-end gap-2 rounded-md border border-border/60 p-3">
            <div><label className={lbl}>% along axis</label><input type="number" className={field} value={m.pct} onChange={(e) => edit((c) => { c.departureBoard.milestones[i].pct = Number(e.target.value); })} /></div>
            <div><label className={lbl}>Date label</label><input className={field} value={m.dateLabel} onChange={(e) => edit((c) => { c.departureBoard.milestones[i].dateLabel = e.target.value; })} /></div>
            <div><label className={lbl}>Note</label><input className={field} value={m.note} onChange={(e) => edit((c) => { c.departureBoard.milestones[i].note = e.target.value; })} /></div>
            <div><label className={lbl}>Tone (start/info/warning/end)</label><input className={field} value={m.tone} onChange={(e) => edit((c) => { c.departureBoard.milestones[i].tone = e.target.value as typeof m.tone; })} /></div>
          </div>
        ))}
        <p className={head}>Roads</p>
        {c.departureBoard.roads.map((r, ri) => (
          <div key={ri} className="space-y-2 rounded-md border border-border/60 p-3">
            <div className="grid grid-cols-2 gap-2">
              <div><label className={lbl}>Label</label><input className={field} value={r.label} onChange={(e) => edit((c) => { c.departureBoard.roads[ri].label = e.target.value; })} /></div>
              <div><label className={lbl}>Sub</label><input className={field} value={r.sub} onChange={(e) => edit((c) => { c.departureBoard.roads[ri].sub = e.target.value; })} /></div>
            </div>
            {r.segments.map((s, si) => (
              <div key={si} className="grid grid-cols-4 gap-2">
                <div><label className={lbl}>Start %</label><input type="number" className={field} value={s.startPct} onChange={(e) => edit((c) => { c.departureBoard.roads[ri].segments[si].startPct = Number(e.target.value); })} /></div>
                <div><label className={lbl}>Width %</label><input type="number" className={field} value={s.widthPct} onChange={(e) => edit((c) => { c.departureBoard.roads[ri].segments[si].widthPct = Number(e.target.value); })} /></div>
                <div><label className={lbl}>Tone</label><input className={field} value={s.tone} onChange={(e) => edit((c) => { c.departureBoard.roads[ri].segments[si].tone = e.target.value as typeof s.tone; })} /></div>
                <div><label className={lbl}>Caption</label><input className={field} value={s.caption} onChange={(e) => edit((c) => { c.departureBoard.roads[ri].segments[si].caption = e.target.value; })} /></div>
              </div>
            ))}
          </div>
        ))}
        <p className={head}>Legend</p>
        {c.departureBoard.legend.map((l, i) => (
          <div key={i} className="grid grid-cols-2 gap-2">
            <div><label className={lbl}>Tone</label><input className={field} value={l.tone} onChange={(e) => edit((c) => { c.departureBoard.legend[i].tone = e.target.value as typeof l.tone; })} /></div>
            <div><label className={lbl}>Label</label><input className={field} value={l.label} onChange={(e) => edit((c) => { c.departureBoard.legend[i].label = e.target.value; })} /></div>
          </div>
        ))}
      </div>

      {/* ROADS SPLIT */}
      <div className={box}>
        <p className={head}>Roads split</p>
        <div><label className={lbl}>Title</label><input className={field} value={c.roadsSplit.title} onChange={(e) => edit((c) => { c.roadsSplit.title = e.target.value; })} /></div>
        <div><label className={lbl}>Intro</label><textarea className={`${field} h-16`} value={c.roadsSplit.intro} onChange={(e) => edit((c) => { c.roadsSplit.intro = e.target.value; })} /></div>
        <div><label className={lbl}>Start badge</label><input className={field} value={c.roadsSplit.startBadge} onChange={(e) => edit((c) => { c.roadsSplit.startBadge = e.target.value; })} /></div>
        {c.roadsSplit.roads.map((r, i) => (
          <div key={i} className="space-y-2 rounded-md border border-border/60 p-3">
            <span className="text-xs text-muted-foreground">Road #{i + 1}</span>
            <input className={field} placeholder="title" value={r.title} onChange={(e) => edit((c) => { c.roadsSplit.roads[i].title = e.target.value; })} />
            <input className={field} placeholder="segment / eligibility tag" value={r.segment} onChange={(e) => edit((c) => { c.roadsSplit.roads[i].segment = e.target.value; })} />
            <textarea className={`${field} h-20`} placeholder="body" value={r.body} onChange={(e) => edit((c) => { c.roadsSplit.roads[i].body = e.target.value; })} />
            <input className={field} placeholder="CE mark note" value={r.ceMarkNote} onChange={(e) => edit((c) => { c.roadsSplit.roads[i].ceMarkNote = e.target.value; })} />
          </div>
        ))}
        <div><label className={lbl}>Wrong turns</label><textarea className={`${field} h-20`} value={c.roadsSplit.wrongTurns} onChange={(e) => edit((c) => { c.roadsSplit.wrongTurns = e.target.value; })} /></div>
        <div><label className={lbl}>Footnote</label><input className={field} value={c.roadsSplit.footnote} onChange={(e) => edit((c) => { c.roadsSplit.footnote = e.target.value; })} /></div>
      </div>

      {/* PERSONAS */}
      <div className={box}>
        <p className={head}>Personas</p>
        <div><label className={lbl}>Title</label><input className={field} value={c.personas.title} onChange={(e) => edit((c) => { c.personas.title = e.target.value; })} /></div>
        <div><label className={lbl}>Intro</label><textarea className={`${field} h-16`} value={c.personas.intro} onChange={(e) => edit((c) => { c.personas.intro = e.target.value; })} /></div>
        {c.personas.cards.map((p, i) => (
          <div key={i} className="space-y-2 rounded-md border border-border/60 p-3">
            <span className="text-xs text-muted-foreground">Segment: {p.segment}</span>
            <input className={field} placeholder="title" value={p.title} onChange={(e) => edit((c) => { c.personas.cards[i].title = e.target.value; })} />
            <textarea className={`${field} h-20`} placeholder="quote (first person, verbatim)" value={p.quote} onChange={(e) => edit((c) => { c.personas.cards[i].quote = e.target.value; })} />
            <input className={field} placeholder="cta" value={p.cta} onChange={(e) => edit((c) => { c.personas.cards[i].cta = e.target.value; })} />
          </div>
        ))}
      </div>

      {/* RETAINER */}
      <div className={box}>
        <p className={head}>Retainer</p>
        <div><label className={lbl}>Title</label><input className={field} value={c.retainer.title} onChange={(e) => edit((c) => { c.retainer.title = e.target.value; })} /></div>
        <div><label className={lbl}>Intro</label><textarea className={`${field} h-20`} value={c.retainer.intro} onChange={(e) => edit((c) => { c.retainer.intro = e.target.value; })} /></div>
        {c.retainer.phases.map((p, i) => (
          <div key={i} className="space-y-2 rounded-md border border-border/60 p-3">
            <span className="text-xs text-muted-foreground">Phase #{i + 1}</span>
            <input className={field} placeholder="tag" value={p.tag} onChange={(e) => edit((c) => { c.retainer.phases[i].tag = e.target.value; })} />
            <input className={field} placeholder="title" value={p.title} onChange={(e) => edit((c) => { c.retainer.phases[i].title = e.target.value; })} />
            <textarea className={`${field} h-16`} placeholder="body" value={p.body} onChange={(e) => edit((c) => { c.retainer.phases[i].body = e.target.value; })} />
          </div>
        ))}
        <div className="space-y-2 rounded-md border-2 border-primary/40 p-3">
          <span className="text-xs font-semibold text-primary">Reserved seat (visually distinct tile)</span>
          <input className={field} placeholder="tag" value={c.retainer.reservedSeat.tag} onChange={(e) => edit((c) => { c.retainer.reservedSeat.tag = e.target.value; })} />
          <input className={field} placeholder="title" value={c.retainer.reservedSeat.title} onChange={(e) => edit((c) => { c.retainer.reservedSeat.title = e.target.value; })} />
          <textarea className={`${field} h-16`} placeholder="body" value={c.retainer.reservedSeat.body} onChange={(e) => edit((c) => { c.retainer.reservedSeat.body = e.target.value; })} />
        </div>
        <div><label className={lbl}>Digital twin note</label><textarea className={`${field} h-16`} value={c.retainer.digitalTwin} onChange={(e) => edit((c) => { c.retainer.digitalTwin = e.target.value; })} /></div>
      </div>

      {/* PROCESS */}
      <div className={box}>
        <p className={head}>Process strip</p>
        <div><label className={lbl}>Title</label><input className={field} value={c.process.title} onChange={(e) => edit((c) => { c.process.title = e.target.value; })} /></div>
        {c.process.steps.map((s, i) => (
          <div key={i} className="grid grid-cols-[auto_1fr] items-end gap-2 rounded-md border border-border/60 p-3">
            <div><label className={lbl}>No.</label><input className={`${field} w-16`} value={s.number} onChange={(e) => edit((c) => { c.process.steps[i].number = e.target.value; })} /></div>
            <div><label className={lbl}>Title</label><input className={field} value={s.title} onChange={(e) => edit((c) => { c.process.steps[i].title = e.target.value; })} /></div>
            <div className="col-span-2"><label className={lbl}>Body {i === 1 ? "(names Vincent deliberately)" : ""}</label><textarea className={`${field} h-16`} value={s.body} onChange={(e) => edit((c) => { c.process.steps[i].body = e.target.value; })} /></div>
          </div>
        ))}
      </div>

      {/* FINAL CTA */}
      <div className={box}>
        <p className={head}>Final CTA</p>
        <div><label className={lbl}>Title</label><input className={field} value={c.finalCta.title} onChange={(e) => edit((c) => { c.finalCta.title = e.target.value; })} /></div>
        <div><label className={lbl}>Line ("The wall is fixed…")</label><textarea className={`${field} h-16`} value={c.finalCta.line} onChange={(e) => edit((c) => { c.finalCta.line = e.target.value; })} /></div>
        <div><label className={lbl}>CTA label</label><input className={field} value={c.finalCta.ctaLabel} onChange={(e) => edit((c) => { c.finalCta.ctaLabel = e.target.value; })} /></div>
      </div>

      <div className="flex items-center gap-3">
        <Button type="button" onClick={save} disabled={saving}>
          {saving ? "Saving…" : `Save ${loc.toUpperCase()} CRA home page`}
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
