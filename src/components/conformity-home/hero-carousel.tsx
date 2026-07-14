"use client";
import * as React from "react";
import { useReducedMotion } from "motion/react";
import { ChevronLeft, ChevronRight } from "lucide-react";
import { cn } from "@/lib/utils";
import type { HeroSlide } from "@/lib/carousel";

// Auto-advancing hero showcase on the right of the home hero. Now DB-backed:
// the server <Hero> passes `slides` from carousel_slides (migration 033). When
// the DB is empty or unreachable, <Hero> passes the shipped static deck instead
// (public/hero/<locale>/slide-N.png, 6 slides, 16:9) — and this component also
// self-falls-back if it ever receives an empty array, so the hero can never go
// blank. Pauses on hover/focus, honours reduced-motion, keyboard-accessible
// controls. Bilingual control labels (no single-language strings).
const STATIC_COUNT = 6;
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

function staticFallback(l: "en" | "nl"): HeroSlide[] {
  return Array.from({ length: STATIC_COUNT }, (_, k) => ({
    src: `/hero/${l}/slide-${k + 1}.png`,
    caption: null,
    link: null
  }));
}

export function HeroCarousel({ locale, slides }: { locale: string; slides?: HeroSlide[] }) {
  const l = locale === "nl" ? "nl" : "en";
  const t = STR[l];
  const reduce = useReducedMotion();
  const [index, setIndex] = React.useState(0);
  const [paused, setPaused] = React.useState(false);

  // Guaranteed non-empty: fall back to the shipped static deck if no DB slides.
  const items = React.useMemo<HeroSlide[]>(
    () => (slides && slides.length > 0 ? slides : staticFallback(l)),
    [slides, l]
  );
  const count = items.length;

  // Keep index in range if the slide set shrinks.
  React.useEffect(() => {
    setIndex((p) => (p >= count ? 0 : p));
  }, [count]);

  React.useEffect(() => {
    if (reduce || paused || count <= 1) return;
    const id = setInterval(() => setIndex((p) => (p + 1) % count), 5200);
    return () => clearInterval(id);
  }, [reduce, paused, count]);

  const go = (n: number) => setIndex((n + count) % count);

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
        {items.map((slide, k) => {
          // eslint-disable-next-line @next/next/no-img-element
          const img = (
            <img
              src={slide.src}
              alt={slide.caption ?? ""}
              aria-hidden={k !== index}
              draggable={false}
              loading={k === 0 ? "eager" : "lazy"}
              className="absolute inset-0 h-full w-full object-cover"
            />
          );
          return (
            <div
              key={`${slide.src}-${k}`}
              className={cn(
                "absolute inset-0 transition-opacity duration-700 ease-out",
                k === index ? "opacity-100" : "opacity-0"
              )}
            >
              {slide.link ? (
                <a href={slide.link} tabIndex={k === index ? 0 : -1} aria-label={slide.caption ?? t.goto(k + 1)}>
                  {img}
                </a>
              ) : (
                img
              )}
              {slide.caption ? (
                <div
                  aria-hidden={k !== index}
                  className="absolute inset-x-0 bottom-0 bg-gradient-to-t from-background/80 to-transparent p-3 text-sm font-medium text-foreground"
                >
                  {slide.caption}
                </div>
              ) : null}
            </div>
          );
        })}

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
        {items.map((_, k) => (
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
