"use client";
import * as React from "react";
import { Button } from "@/components/ui/button";
import { Trash2, UploadCloud, Copy, Check, FileText } from "lucide-react";

type Media = { id: number; filename: string; mime: string; size: number; width: number | null; height: number | null; alt: string | null; created_at: string };

const ASPECTS: { label: string; value: number }[] = [
  { label: "16:9", value: 16 / 9 },
  { label: "4:3", value: 4 / 3 },
  { label: "1:1", value: 1 },
  { label: "3:4", value: 3 / 4 }
];

function blobToBase64(blob: Blob): Promise<string> {
  return new Promise((res, rej) => {
    const r = new FileReader();
    r.onload = () => res((r.result as string).split(",")[1] ?? "");
    r.onerror = rej;
    r.readAsDataURL(blob);
  });
}

/* ── interactive crop / zoom / pan editor (canvas export) ── */
function ImageCropper({ file, onCancel, onDone }: {
  file: File; onCancel: () => void;
  onDone: (out: { dataBase64: string; mime: string; width: number; height: number; filename: string; alt: string }) => void;
}) {
  const [img, setImg] = React.useState<HTMLImageElement | null>(null);
  const [aspect, setAspect] = React.useState(16 / 9);
  const [zoom, setZoom] = React.useState(1);
  const [off, setOff] = React.useState({ x: 0, y: 0 });
  const [alt, setAlt] = React.useState("");
  const [busy, setBusy] = React.useState(false);
  const vpRef = React.useRef<HTMLDivElement>(null);
  const drag = React.useRef<{ x: number; y: number; ox: number; oy: number } | null>(null);

  React.useEffect(() => {
    const url = URL.createObjectURL(file);
    const im = new Image();
    im.onload = () => setImg(im);
    im.src = url;
    return () => URL.revokeObjectURL(url);
  }, [file]);

  const vp = () => vpRef.current?.getBoundingClientRect() ?? { width: 560, height: 315 };
  const metrics = () => {
    const { width: Vw } = vp();
    const Vh = Vw / aspect;
    if (!img) return { Vw, Vh, base: 1, dispW: Vw, dispH: Vh };
    const base = Math.max(Vw / img.naturalWidth, Vh / img.naturalHeight);
    const dispW = img.naturalWidth * base * zoom;
    const dispH = img.naturalHeight * base * zoom;
    return { Vw, Vh, base, dispW, dispH };
  };
  const clamp = (o: { x: number; y: number }) => {
    const { Vw, Vh, dispW, dispH } = metrics();
    return { x: Math.min(0, Math.max(Vw - dispW, o.x)), y: Math.min(0, Math.max(Vh - dispH, o.y)) };
  };
  React.useEffect(() => { setOff((o) => clamp(o)); /* re-clamp on zoom/aspect */ // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [zoom, aspect, img]);

  const onDown = (e: React.PointerEvent) => {
    (e.target as HTMLElement).setPointerCapture(e.pointerId);
    drag.current = { x: e.clientX, y: e.clientY, ox: off.x, oy: off.y };
  };
  const onMove = (e: React.PointerEvent) => {
    if (!drag.current) return;
    setOff(clamp({ x: drag.current.ox + (e.clientX - drag.current.x), y: drag.current.oy + (e.clientY - drag.current.y) }));
  };
  const onUp = () => { drag.current = null; };

  async function save() {
    if (!img) return;
    setBusy(true);
    const { Vw, Vh, base, dispW, dispH } = metrics();
    const cropSrcW = Vw / (base * zoom);            // crop width in source px
    const outW = Math.min(1600, Math.round(cropSrcW));
    const outH = Math.round(outW / aspect);
    const k = outW / Vw;
    const c = document.createElement("canvas");
    c.width = outW; c.height = outH;
    const ctx = c.getContext("2d")!;
    ctx.imageSmoothingQuality = "high";
    ctx.drawImage(img, off.x * k, off.y * k, dispW * k, dispH * k);
    const wantsAlpha = file.type === "image/png" || file.type === "image/webp" || file.type === "image/gif";
    const type = wantsAlpha ? "image/webp" : "image/webp";
    const blob: Blob = await new Promise((r) => c.toBlob((b) => r(b as Blob), type, 0.85));
    const finalType = blob && blob.type ? blob.type : "image/jpeg";
    const dataBase64 = await blobToBase64(blob ?? new Blob());
    onDone({ dataBase64, mime: finalType, width: outW, height: outH, filename: file.name.replace(/\.[^.]+$/, "") + ".webp", alt });
    setBusy(false);
  }

  const { Vh, dispW, dispH } = metrics();
  return (
    <div className="rounded-xl border border-border bg-card p-4">
      <div className="mb-3 flex flex-wrap items-center gap-2 text-sm">
        <span className="text-muted-foreground">Aspect:</span>
        {ASPECTS.map((a) => (
          <button key={a.label} onClick={() => setAspect(a.value)}
            className={`rounded-md border px-2.5 py-1 text-xs ${Math.abs(aspect - a.value) < 0.01 ? "border-primary bg-primary text-primary-foreground" : "border-border text-muted-foreground hover:border-primary/50"}`}>
            {a.label}
          </button>
        ))}
      </div>
      <div
        ref={vpRef}
        onPointerDown={onDown} onPointerMove={onMove} onPointerUp={onUp} onPointerLeave={onUp}
        className="relative w-full max-w-xl cursor-grab touch-none select-none overflow-hidden rounded-lg border border-border bg-muted active:cursor-grabbing"
        style={{ height: Vh, backgroundImage: img ? `url(${img.src})` : undefined, backgroundRepeat: "no-repeat", backgroundSize: `${dispW}px ${dispH}px`, backgroundPosition: `${off.x}px ${off.y}px` }}
        aria-label="Drag to reposition"
      />
      <div className="mt-3 flex items-center gap-3 text-sm">
        <span className="text-muted-foreground">Zoom</span>
        <input type="range" min={1} max={4} step={0.01} value={zoom} onChange={(e) => setZoom(Number(e.target.value))} className="flex-1" />
      </div>
      <input value={alt} onChange={(e) => setAlt(e.target.value)} placeholder="Alt text (accessibility, optional)"
        className="mt-3 w-full rounded-lg border border-border bg-background px-3 py-2 text-sm" />
      <div className="mt-3 flex gap-2">
        <Button onClick={save} disabled={busy || !img}>{busy ? "Uploading…" : "Crop & upload"}</Button>
        <Button variant="outline" onClick={onCancel}>Cancel</Button>
      </div>
    </div>
  );
}

export function MediaManager() {
  const [media, setMedia] = React.useState<Media[]>([]);
  const [pending, setPending] = React.useState<File | null>(null);
  const [pdfBusy, setPdfBusy] = React.useState(false);
  const [copied, setCopied] = React.useState<number | null>(null);
  const [msg, setMsg] = React.useState("");
  const fileRef = React.useRef<HTMLInputElement>(null);

  const load = React.useCallback(async () => {
    const d = await fetch("/api/admin/media").then((r) => r.json()).catch(() => ({ media: [] }));
    setMedia(d.media ?? []);
  }, []);
  React.useEffect(() => { void load(); }, [load]);

  async function upload(payload: { dataBase64: string; mime: string; width?: number; height?: number; filename: string; alt?: string }) {
    const res = await fetch("/api/admin/media", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(payload) });
    const d = await res.json().catch(() => ({}));
    setMsg(res.ok ? `Uploaded ${payload.filename}.` : (d.error ?? "upload failed"));
    if (res.ok) { setPending(null); void load(); }
  }

  async function onPick(e: React.ChangeEvent<HTMLInputElement>) {
    const f = e.target.files?.[0];
    if (!f) return;
    if (f.type === "application/pdf") {
      setPdfBusy(true);
      const dataBase64 = await blobToBase64(f);
      await upload({ dataBase64, mime: "application/pdf", filename: f.name });
      setPdfBusy(false);
    } else if (f.type.startsWith("image/")) {
      setPending(f); // open cropper
    } else {
      setMsg("Unsupported file type.");
    }
    if (fileRef.current) fileRef.current.value = "";
  }

  async function del(id: number) {
    if (!confirm("Delete this media file? Any page or carousel using it will break.")) return;
    await fetch(`/api/admin/media?id=${id}`, { method: "DELETE" });
    void load();
  }
  function copyRef(m: Media) {
    const ref = m.mime === "application/pdf" ? `pdf:${m.id}` : `media:${m.id}`;
    navigator.clipboard?.writeText(ref);
    setCopied(m.id); setTimeout(() => setCopied(null), 1200);
  }

  return (
    <div className="space-y-5">
      <div>
        <h2 className="text-lg font-semibold">Media library</h2>
        <p className="text-sm text-muted-foreground">
          Upload images (crop/zoom/pan before saving) or PDFs. Use a file&apos;s reference in a{" "}
          <code className="rounded bg-muted px-1">carousel</code> block on any page:{" "}
          <code className="rounded bg-muted px-1">media:ID</code> for images, <code className="rounded bg-muted px-1">pdf:ID</code> for a page-by-page PDF.
        </p>
      </div>

      {!pending && (
        <div>
          <input ref={fileRef} type="file" accept="image/*,application/pdf" onChange={onPick} className="hidden" id="media-file" />
          <label htmlFor="media-file"
            className="inline-flex cursor-pointer items-center gap-2 rounded-lg border border-dashed border-primary/50 bg-primary/5 px-4 py-2.5 text-sm font-medium text-primary hover:bg-primary/10">
            <UploadCloud className="h-4 w-4" /> {pdfBusy ? "Uploading PDF…" : "Upload image or PDF"}
          </label>
        </div>
      )}

      {pending && <ImageCropper file={pending} onCancel={() => setPending(null)} onDone={upload} />}

      {msg && <p className="text-sm text-muted-foreground">{msg}</p>}

      <div className="grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4">
        {media.map((m) => (
          <div key={m.id} className="overflow-hidden rounded-xl border border-border bg-card">
            <div className="flex aspect-video items-center justify-center bg-muted/40">
              {m.mime === "application/pdf"
                ? <div className="flex flex-col items-center text-muted-foreground"><FileText className="h-8 w-8" /><span className="mt-1 text-[11px]">PDF</span></div>
                : <img src={`/api/media/${m.id}`} alt={m.alt ?? m.filename} className="h-full w-full object-cover" />}
            </div>
            <div className="p-2.5">
              <div className="truncate text-xs font-medium" title={m.filename}>{m.filename}</div>
              <div className="mt-0.5 text-[11px] text-muted-foreground">
                {m.width && m.height ? `${m.width}×${m.height} · ` : ""}{Math.round(m.size / 1024)} KB
              </div>
              <div className="mt-2 flex items-center gap-1">
                <button onClick={() => copyRef(m)} title="Copy reference for a carousel block"
                  className="inline-flex items-center gap-1 rounded-md border border-border px-2 py-1 text-[11px] hover:border-primary hover:text-primary">
                  {copied === m.id ? <Check className="h-3 w-3" /> : <Copy className="h-3 w-3" />} {m.mime === "application/pdf" ? `pdf:${m.id}` : `media:${m.id}`}
                </button>
                <button onClick={() => del(m.id)} title="Delete" className="ml-auto rounded-md p-1 text-muted-foreground hover:text-red-500">
                  <Trash2 className="h-3.5 w-3.5" />
                </button>
              </div>
            </div>
          </div>
        ))}
        {media.length === 0 && <p className="col-span-full text-sm text-muted-foreground">No media yet — upload your first image or PDF.</p>}
      </div>
    </div>
  );
}
