"use client";
import * as React from "react";
import { useReducedMotion } from "motion/react";
import { ChevronLeft, ChevronRight } from "lucide-react";
import { cn } from "@/lib/utils";

// Auto-advancing hero showcase on the right of the home hero. Renders the
// pre-rendered pages of the OXOT CRA hero deck (public/hero/<locale>/slide-N.png,
// 6 slides, 16:9). Pauses on hover/focus, honours reduced-motion, keyboard-
// accessible controls. Bilingual control labels (no single-language strings).
const COUNT = 6;
const STR = {
  en: {
    prev: "Previous slide",
    next: "Next slide",
    goto: (n: number) => `Go to slide ${n}`,
    region: "OXOT Cyber Resilience Act highlights"
  },
  nl: {
    prev: "Vorige dia",
    next: "Volgende dia",
    goto: (n: number) => `Ga naar dia ${n}`,
    region: "OXOT Cyberweerbaarheidsverordening — hoogtepunten"
  }
} as const;

export function HeroCarousel({ locale }: { locale: string }) {
  const l = locale === "nl" ? "nl" : "en";
  const t = STR[l];
  const reduce = useReducedMotion();
  const [index, setIndex] = React.useState(0);
  const [paused, setPaused] = React.useState(false);

  const slides = React.useMemo(
    () => Array.from({ length: COUNT }, (_, k) => `/hero/${l}/slide-${k + 1}.png`),
    [l]
  );

  React.useEffect(() => {
    if (reduce || paused) return;
    const id = setInterval(() => setIndex((p) => (p + 1) % COUNT), 5200);
    return () => clearInterval(id);
  }, [reduce, paused]);

  const go = (n: number) => setIndex((n + COUNT) % COUNT);

  return (
    <div
      className="group relative w-full"
      role="group"
      aria-roledescription="carousel"
      aria-label={t.region}
      onMouseEnter={() => setPaused(true)}
      onMouseLeave={() => setPaused(false)}
      onFocusCapture={() => setPaused(true)}
      onBlurCapture={() => setPaused(false)}
    >
      <div className="relative aspect-[16/9] w-full overflow-hidden rounded-xl border border-border bg-card shadow-xl ring-1 ring-primary/10">
        {slides.map((src, k) => (
          // eslint-disable-next-line @next/next/no-img-element
          <img
            key={src}
            src={src}
            alt=""
            aria-hidden={k !== index}
            draggable={false}
            loading={k === 0 ? "eager" : "lazy"}
            className={cn(
              "absolute inset-0 h-full w-full object-cover transition-opacity duration-700 ease-out",
              k === index ? "opacity-100" : "opacity-0"
            )}
          />
        ))}

        <button
          type="button"
          onClick={() => go(index - 1)}
          aria-label={t.prev}
          className="absolute left-2 top-1/2 -translate-y-1/2 rounded-full border border-border bg-background/70 p-1.5 text-foreground opacity-0 backdrop-blur transition hover:bg-background focus-visible:opacity-100 group-hover:opacity-100"
        >
          <ChevronLeft className="h-4 w-4" />
        </button>
        <button
          type="button"
          onClick={() => go(index + 1)}
          aria-label={t.next}
          className="absolute right-2 top-1/2 -translate-y-1/2 rounded-full border border-border bg-background/70 p-1.5 text-foreground opacity-0 backdrop-blur transition hover:bg-background focus-visible:opacity-100 group-hover:opacity-100"
        >
          <ChevronRight className="h-4 w-4" />
        </button>
      </div>

      <div className="mt-3 flex justify-center gap-2">
        {slides.map((_, k) => (
          <button
            key={k}
            type="button"
            onClick={() => go(k)}
            aria-label={t.goto(k + 1)}
            aria-current={k === index}
            className={cn(
              "h-1.5 rounded-full transition-all duration-300",
              k === index ? "w-6 bg-primary" : "w-1.5 bg-muted-foreground/40 hover:bg-muted-foreground"
            )}
          />
        ))}
      </div>
    </div>
  );
}
