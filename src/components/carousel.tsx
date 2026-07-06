"use client";
import { useState } from "react";

export interface Slide {
  title?: string;
  body: string; // plain text / simple inline
}

/**
 * Lightweight, dependency-free carousel for CMS content.
 * Authored in markdown via a ```carousel fenced block (see MarkdownContent).
 */
export function Carousel({ slides }: { slides: Slide[] }) {
  const [i, setI] = useState(0);
  if (!slides.length) return null;
  const n = slides.length;
  const go = (d: number) => setI((p) => (p + d + n) % n);
  const s = slides[i];

  return (
    <figure className="my-8 overflow-hidden rounded-xl border border-border bg-muted/30">
      <div className="flex min-h-[220px] flex-col justify-center gap-3 p-8">
        <div className="text-xs font-medium uppercase tracking-widest text-primary">
          {i + 1} / {n}
        </div>
        {s.title && <h3 className="text-2xl font-semibold tracking-tight">{s.title}</h3>}
        <p className="leading-relaxed text-muted-foreground">{s.body}</p>
      </div>
      <div className="flex items-center justify-between border-t border-border px-4 py-3">
        <button
          onClick={() => go(-1)}
          className="rounded-lg border border-border px-3 py-1.5 text-sm hover:bg-muted"
          aria-label="Previous slide"
        >
          ← Prev
        </button>
        <div className="flex gap-1.5">
          {slides.map((_, k) => (
            <button
              key={k}
              onClick={() => setI(k)}
              aria-label={`Go to slide ${k + 1}`}
              className={`h-2 w-2 rounded-full transition-colors ${
                k === i ? "bg-primary" : "bg-border hover:bg-muted-foreground"
              }`}
            />
          ))}
        </div>
        <button
          onClick={() => go(1)}
          className="rounded-lg border border-border px-3 py-1.5 text-sm hover:bg-muted"
          aria-label="Next slide"
        >
          Next →
        </button>
      </div>
    </figure>
  );
}
