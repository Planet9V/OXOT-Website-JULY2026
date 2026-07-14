"use client";
import * as React from "react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  Plus, Save, Trash2, ArrowUp, ArrowDown, CheckCircle2, XCircle, ImageIcon,
} from "lucide-react";

// Homepage hero carousel manager. Ported from the source admin carousel page
// (Celestial-Agent-Nexus: artifacts/oxot-web/src/pages/admin-carousel.tsx —
// list / reorder / toggle / edit / delete slides). Adapted to this app's plain
// admin styling (matches affiliate-seo-manager.tsx) and the raw-pg backed routes
// under /api/admin/carousel. The source's file-upload buttons are replaced by an
// image path / URL field: uploads are handled by the Media library, and the hero
// deck ships as public paths (e.g. /hero/en/slide-1.png), so slides reference a
// path or URL directly.

const inp = "w-full rounded-md border border-border bg-background px-3 py-2 text-sm";
const lbl = "text-xs font-semibold uppercase tracking-[0.15em] text-muted-foreground";

function Toggle({ on, onChange, label }: { on: boolean; onChange: (v: boolean) => void; label?: string }) {
  return (
    <button
      type="button"
      role="switch"
      aria-checked={on}
      aria-label={label}
      onClick={() => onChange(!on)}
      className={`relative inline-flex h-6 w-11 shrink-0 items-center rounded-full transition-colors ${on ? "bg-primary" : "bg-muted"}`}
    >
      <span className={`inline-block h-5 w-5 transform rounded-full bg-background shadow transition-transform ${on ? "translate-x-5" : "translate-x-0.5"}`} />
    </button>
  );
}

type Status = { kind: "idle" | "ok" | "err"; msg: string };

function StatusBar({ status }: { status: Status }) {
  if (status.kind === "idle") return null;
  return (
    <div className={`flex items-center gap-2 rounded-lg border p-3 text-sm ${status.kind === "ok" ? "border-primary/30 bg-primary/5 text-foreground" : "border-red-500/30 bg-red-500/5 text-foreground"}`}>
      {status.kind === "ok" ? <CheckCircle2 className="h-4 w-4 text-primary" /> : <XCircle className="h-4 w-4 text-red-500" />}
      {status.msg}
    </div>
  );
}

type Slide = {
  id: number; sortOrder: number; kind: string; imagePath: string; imageUrl: string;
  groupId: string | null; pageIndex: number | null;
  captionEn: string | null; captionNl: string | null; linkUrl: string | null; active: boolean;
};

type AddForm = { imagePath: string; captionEn: string; captionNl: string; linkUrl: string; active: boolean };
const EMPTY_ADD: AddForm = { imagePath: "", captionEn: "", captionNl: "", linkUrl: "", active: true };

export function CarouselManager() {
  const [slides, setSlides] = React.useState<Slide[]>([]);
  const [status, setStatus] = React.useState<Status>({ kind: "idle", msg: "" });
  const [showAdd, setShowAdd] = React.useState(false);
  const [add, setAdd] = React.useState<AddForm>(EMPTY_ADD);
  const [busy, setBusy] = React.useState(false);

  const load = React.useCallback(async () => {
    const res = await fetch("/api/admin/carousel");
    if (res.ok) setSlides(((await res.json()) as { slides: Slide[] }).slides);
  }, []);
  React.useEffect(() => { void load(); }, [load]);

  async function createSlide() {
    if (!add.imagePath.trim()) {
      setStatus({ kind: "err", msg: "Image path or URL is required." });
      return;
    }
    setBusy(true); setStatus({ kind: "idle", msg: "" });
    try {
      const res = await fetch("/api/admin/carousel", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({
          imagePath: add.imagePath.trim(),
          captionEn: add.captionEn.trim() || null,
          captionNl: add.captionNl.trim() || null,
          linkUrl: add.linkUrl.trim() || null,
          active: add.active,
        }),
      });
      if (!res.ok) {
        const e = (await res.json().catch(() => ({}))) as { error?: string };
        setStatus({ kind: "err", msg: e.error ?? "Could not add slide." });
        return;
      }
      setStatus({ kind: "ok", msg: "Slide added." });
      setAdd(EMPTY_ADD); setShowAdd(false);
      await load();
    } finally { setBusy(false); }
  }

  async function move(i: number, dir: -1 | 1) {
    const j = i + dir;
    if (j < 0 || j >= slides.length) return;
    const ids = slides.map((s) => s.id);
    [ids[i], ids[j]] = [ids[j], ids[i]];
    // Optimistic reorder for snappy UI; reconcile with the server response.
    const reordered = [...slides];
    [reordered[i], reordered[j]] = [reordered[j], reordered[i]];
    setSlides(reordered);
    const res = await fetch("/api/admin/carousel/reorder", {
      method: "PUT",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ ids }),
    });
    if (!res.ok) setStatus({ kind: "err", msg: "Could not reorder slides." });
    await load();
  }

  async function remove(id: number) {
    if (!confirm("Remove this slide?")) return;
    const res = await fetch(`/api/admin/carousel/${id}`, { method: "DELETE" });
    if (res.ok) { setStatus({ kind: "ok", msg: "Slide removed." }); await load(); }
    else setStatus({ kind: "err", msg: "Could not delete slide." });
  }

  return (
    <section className="space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h2 className="text-lg font-semibold">Hero carousel</h2>
          <p className="text-sm text-muted-foreground">
            Slides shown on the homepage hero. Reorder, hide, edit captions (EN/NL) and links. Empty or
            hidden slides fall back to the shipped hero deck so the front door never goes blank.
          </p>
        </div>
        <Button onClick={() => { setShowAdd((v) => !v); setStatus({ kind: "idle", msg: "" }); }}>
          <Plus className="h-4 w-4" /> Add slide
        </Button>
      </div>

      <StatusBar status={status} />

      {showAdd && (
        <div className="rounded-xl border border-border p-5 space-y-4">
          <h3 className="font-semibold">New slide</h3>
          <div className="grid gap-4 sm:grid-cols-2">
            <div className="sm:col-span-2">
              <label className={lbl}>Image path or URL</label>
              <input className={`${inp} mt-1`} value={add.imagePath} onChange={(e) => setAdd({ ...add, imagePath: e.target.value })} placeholder="/hero/en/slide-1.png or https://…/image.png" />
            </div>
            <div>
              <label className={lbl}>Caption (EN)</label>
              <input className={`${inp} mt-1`} value={add.captionEn} onChange={(e) => setAdd({ ...add, captionEn: e.target.value })} />
            </div>
            <div>
              <label className={lbl}>Caption (NL)</label>
              <input className={`${inp} mt-1`} value={add.captionNl} onChange={(e) => setAdd({ ...add, captionNl: e.target.value })} />
            </div>
            <div className="sm:col-span-2">
              <label className={lbl}>Link URL (optional)</label>
              <input className={`${inp} mt-1`} value={add.linkUrl} onChange={(e) => setAdd({ ...add, linkUrl: e.target.value })} placeholder="/contact" />
            </div>
          </div>
          <div className="flex items-center gap-2">
            <Toggle on={add.active} onChange={(v) => setAdd({ ...add, active: v })} label="Active" />
            <span className="text-sm">Visible on site</span>
          </div>
          <div className="flex items-center gap-2">
            <Button onClick={createSlide} disabled={busy}><Save className="h-4 w-4" /> {busy ? "Saving…" : "Add slide"}</Button>
            <Button variant="outline" onClick={() => { setShowAdd(false); setAdd(EMPTY_ADD); }} disabled={busy}>Cancel</Button>
          </div>
        </div>
      )}

      {slides.length === 0 ? (
        <div className="flex flex-col items-center justify-center rounded-xl border border-border bg-card p-12 text-center">
          <div className="mb-4 flex h-16 w-16 items-center justify-center rounded-full bg-muted">
            <ImageIcon className="h-8 w-8 text-muted-foreground" />
          </div>
          <h3 className="mb-1 text-lg font-medium">No slides yet</h3>
          <p className="max-w-md text-muted-foreground">Add a slide to build your hero carousel. Until then the homepage uses the shipped hero deck.</p>
        </div>
      ) : (
        <div className="space-y-4">
          {slides.map((slide, i) => (
            <SlideCard
              key={slide.id}
              slide={slide}
              index={i}
              count={slides.length}
              onMove={move}
              onDelete={remove}
              onSaved={(msg) => { setStatus({ kind: "ok", msg }); void load(); }}
              onError={(msg) => setStatus({ kind: "err", msg })}
            />
          ))}
        </div>
      )}
    </section>
  );
}

function SlideCard({
  slide, index, count, onMove, onDelete, onSaved, onError,
}: {
  slide: Slide;
  index: number;
  count: number;
  onMove: (i: number, dir: -1 | 1) => void;
  onDelete: (id: number) => void;
  onSaved: (msg: string) => void;
  onError: (msg: string) => void;
}) {
  const [captionEn, setCaptionEn] = React.useState(slide.captionEn ?? "");
  const [captionNl, setCaptionNl] = React.useState(slide.captionNl ?? "");
  const [linkUrl, setLinkUrl] = React.useState(slide.linkUrl ?? "");
  const [active, setActive] = React.useState<boolean>(slide.active);
  const [busy, setBusy] = React.useState(false);

  React.useEffect(() => {
    setCaptionEn(slide.captionEn ?? "");
    setCaptionNl(slide.captionNl ?? "");
    setLinkUrl(slide.linkUrl ?? "");
    setActive(slide.active);
  }, [slide]);

  async function save() {
    setBusy(true);
    try {
      const res = await fetch(`/api/admin/carousel/${slide.id}`, {
        method: "PUT",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({
          captionEn: captionEn || null,
          captionNl: captionNl || null,
          linkUrl: linkUrl || null,
          active,
        }),
      });
      if (res.ok) onSaved("Slide saved.");
      else onError("Could not save slide.");
    } finally { setBusy(false); }
  }

  return (
    <div className="flex flex-col gap-4 rounded-xl border border-border bg-card p-4 shadow-sm md:flex-row">
      <div className="relative w-full shrink-0 overflow-hidden rounded-lg border border-border bg-muted md:w-56">
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img src={slide.imageUrl} alt={captionEn || "Slide"} className="h-36 w-full object-cover" />
        <div className="absolute left-2 top-2 flex gap-1">
          <Badge variant="secondary">{index + 1}</Badge>
          {slide.kind === "pdf" && (
            <Badge variant="outline" className="bg-background/80">PDF p{(slide.pageIndex ?? 0) + 1}</Badge>
          )}
        </div>
      </div>

      <div className="flex-1 space-y-3">
        <div className="grid gap-3 sm:grid-cols-2">
          <div className="space-y-1">
            <label className={lbl}>Caption (EN)</label>
            <input className={inp} value={captionEn} onChange={(e) => setCaptionEn(e.target.value)} />
          </div>
          <div className="space-y-1">
            <label className={lbl}>Caption (NL)</label>
            <input className={inp} value={captionNl} onChange={(e) => setCaptionNl(e.target.value)} />
          </div>
        </div>
        <div className="space-y-1">
          <label className={lbl}>Link URL (optional)</label>
          <input className={inp} value={linkUrl} onChange={(e) => setLinkUrl(e.target.value)} placeholder="/contact" />
        </div>
        <div className="flex items-center justify-between">
          <label className="flex items-center gap-2 text-sm text-muted-foreground">
            <Toggle on={active} onChange={setActive} label="Visible on site" />
            {active ? "Visible on site" : "Hidden"}
          </label>
          <div className="flex items-center gap-1">
            <Button variant="ghost" size="icon" disabled={index === 0} onClick={() => onMove(index, -1)} title="Move up">
              <ArrowUp className="h-4 w-4" />
            </Button>
            <Button variant="ghost" size="icon" disabled={index === count - 1} onClick={() => onMove(index, 1)} title="Move down">
              <ArrowDown className="h-4 w-4" />
            </Button>
            <Button variant="ghost" size="icon" className="text-muted-foreground hover:text-destructive" onClick={() => onDelete(slide.id)} title="Delete">
              <Trash2 className="h-4 w-4" />
            </Button>
            <Button size="sm" onClick={save} disabled={busy}>
              <Save className="h-4 w-4" /> {busy ? "Saving…" : "Save"}
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
