"use client";
import * as React from "react";
import { ChevronLeft, ChevronRight, Loader2 } from "lucide-react";
import { cn } from "@/lib/utils";

export type CarouselItem =
  | { kind: "image"; src: string; caption?: string }
  | { kind: "pdf"; src: string };

/* Load the vendored pdf.js (UMD) once; expose window.pdfjsLib. */
let pdfjsPromise: Promise<any> | null = null;
function loadPdfJs(): Promise<any> {
  if (typeof window === "undefined") return Promise.reject("ssr");
  if ((window as any).pdfjsLib) return Promise.resolve((window as any).pdfjsLib);
  if (pdfjsPromise) return pdfjsPromise;
  pdfjsPromise = new Promise((resolve, reject) => {
    const s = document.createElement("script");
    s.src = "/vendor/pdfjs/pdf.min.js";
    s.onload = () => {
      const lib = (window as any).pdfjsLib;
      if (!lib) return reject("pdfjs missing");
      lib.GlobalWorkerOptions.workerSrc = "/vendor/pdfjs/pdf.worker.min.js";
      resolve(lib);
    };
    s.onerror = reject;
    document.head.appendChild(s);
  });
  return pdfjsPromise;
}

type Slide =
  | { type: "image"; src: string; caption?: string }
  | { type: "pdfpage"; doc: any; page: number };

function PdfPage({ doc, page, active }: { doc: any; page: number; active: boolean }) {
  const ref = React.useRef<HTMLCanvasElement>(null);
  const [done, setDone] = React.useState(false);
  React.useEffect(() => {
    if (!active || done || !doc) return;
    let cancelled = false;
    (async () => {
      const p = await doc.getPage(page);
      const base = p.getViewport({ scale: 1 });
      const scale = Math.min(2, 1100 / base.width);
      const viewport = p.getViewport({ scale });
      const canvas = ref.current;
      if (!canvas || cancelled) return;
      canvas.width = viewport.width;
      canvas.height = viewport.height;
      await p.render({ canvasContext: canvas.getContext("2d"), viewport }).promise;
      if (!cancelled) setDone(true);
    })().catch(() => {});
    return () => { cancelled = true; };
  }, [active, done, doc, page]);
  return (
    <div className="flex h-full w-full items-center justify-center bg-muted/30">
      {!done && <Loader2 className="absolute h-6 w-6 animate-spin text-muted-foreground" />}
      <canvas ref={ref} className="max-h-full max-w-full object-contain" />
    </div>
  );
}

export function MediaCarousel({ items, ratio = "16 / 9", className = "my-8" }: { items: CarouselItem[]; ratio?: string; className?: string }) {
  const [slides, setSlides] = React.useState<Slide[]>(
    items.filter((i) => i.kind === "image").map((i) => ({ type: "image", src: (i as any).src, caption: (i as any).caption }))
  );
  const [i, setI] = React.useState(0);
  const drag = React.useRef<{ x: number } | null>(null);
  const hasPdf = items.some((it) => it.kind === "pdf");

  // Expand PDFs into page-slides once pdf.js is ready.
  React.useEffect(() => {
    if (!hasPdf) return;
    let cancelled = false;
    (async () => {
      const lib = await loadPdfJs();
      const built: Slide[] = [];
      for (const it of items) {
        if (it.kind === "image") built.push({ type: "image", src: it.src, caption: it.caption });
        else {
          const doc = await lib.getDocument(it.src).promise;
          for (let p = 1; p <= doc.numPages; p++) built.push({ type: "pdfpage", doc, page: p });
        }
      }
      if (!cancelled) setSlides(built);
    })().catch(() => {});
    return () => { cancelled = true; };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [hasPdf]);

  const n = slides.length;
  const go = React.useCallback((d: number) => setI((v) => (n ? (v + d + n) % n : 0)), [n]);
  React.useEffect(() => {
    const onKey = (e: KeyboardEvent) => { if (e.key === "ArrowLeft") go(-1); if (e.key === "ArrowRight") go(1); };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [go]);

  if (!n) {
    return (
      <div className={cn(className, "flex items-center justify-center rounded-2xl border border-border bg-muted/30")} style={{ aspectRatio: ratio }}>
        <Loader2 className="h-6 w-6 animate-spin text-muted-foreground" />
      </div>
    );
  }

  return (
    <figure className={className}>
      <div
        className="relative overflow-hidden rounded-2xl border border-border bg-card"
        style={{ aspectRatio: ratio }}
        onPointerDown={(e) => (drag.current = { x: e.clientX })}
        onPointerUp={(e) => { if (drag.current) { const dx = e.clientX - drag.current.x; if (Math.abs(dx) > 40) go(dx < 0 ? 1 : -1); drag.current = null; } }}
      >
        <div className="flex h-full w-full transition-transform duration-300 ease-out" style={{ transform: `translateX(-${i * 100}%)` }}>
          {slides.map((s, idx) => (
            <div key={idx} className="h-full w-full shrink-0">
              {s.type === "image"
                ? <img src={s.src} alt={s.caption ?? ""} className="h-full w-full object-cover" draggable={false} />
                : <PdfPage doc={s.doc} page={s.page} active={Math.abs(idx - i) <= 1} />}
            </div>
          ))}
        </div>

        {n > 1 && (
          <>
            <button onClick={() => go(-1)} aria-label="Previous"
              className="absolute left-2 top-1/2 grid h-9 w-9 -translate-y-1/2 place-items-center rounded-full bg-background/80 text-foreground shadow ring-1 ring-border backdrop-blur transition hover:bg-background">
              <ChevronLeft className="h-5 w-5" />
            </button>
            <button onClick={() => go(1)} aria-label="Next"
              className="absolute right-2 top-1/2 grid h-9 w-9 -translate-y-1/2 place-items-center rounded-full bg-background/80 text-foreground shadow ring-1 ring-border backdrop-blur transition hover:bg-background">
              <ChevronRight className="h-5 w-5" />
            </button>
            <div className="absolute bottom-2 right-3 rounded-full bg-background/80 px-2 py-0.5 text-xs font-medium text-muted-foreground ring-1 ring-border backdrop-blur">
              {i + 1} / {n}
            </div>
          </>
        )}
      </div>

      {/* dots (only when few) */}
      {n > 1 && n <= 12 && (
        <div className="mt-3 flex justify-center gap-1.5">
          {slides.map((_, idx) => (
            <button key={idx} onClick={() => setI(idx)} aria-label={`Go to slide ${idx + 1}`}
              className={cn("h-1.5 rounded-full transition-all", idx === i ? "w-5 bg-primary" : "w-1.5 bg-border hover:bg-primary/50")} />
          ))}
        </div>
      )}
      {slides[i]?.type === "image" && (slides[i] as any).caption && (
        <figcaption className="mt-2 text-center text-sm text-muted-foreground">{(slides[i] as any).caption}</figcaption>
      )}
    </figure>
  );
}
