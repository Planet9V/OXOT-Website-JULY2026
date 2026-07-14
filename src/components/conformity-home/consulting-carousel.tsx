"use client";
import * as React from "react";
import Link from "next/link";
import { ArrowRight, ChevronLeft, ChevronRight } from "lucide-react";
import { useReducedMotion } from "motion/react";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

export interface CarouselSlide {
  eyebrow: string;
  title: string;
  body: string;
  cta: string;
  href: string;
}

/**
 * Auto-advancing consultancy carousel. Promotes the alternative
 * industrial-operations / frameworks pages. Client-only: autoplay, hover-pause,
 * keyboard-accessible controls, and reduced-motion aware (no autoplay when the
 * visitor prefers reduced motion).
 */
export function ConsultingCarousel({
  slides,
  locale,
  labels
}: {
  slides: CarouselSlide[];
  locale: string;
  labels: { prev: string; next: string; goTo: string };
}) {
  const count = slides.length;
  const [index, setIndex] = React.useState(0);
  const [paused, setPaused] = React.useState(false);
  const reduce = useReducedMotion();

  const go = React.useCallback(
    (n: number) => setIndex(((n % count) + count) % count),
    [count]
  );
  const next = React.useCallback(() => go(index + 1), [go, index]);
  const prev = React.useCallback(() => go(index - 1), [go, index]);

  React.useEffect(() => {
    if (reduce || paused || count <= 1) return;
    const id = setInterval(() => setIndex((i) => (i + 1) % count), 6000);
    return () => clearInterval(id);
  }, [reduce, paused, count]);

  return (
    <div
      className="relative overflow-hidden rounded-[var(--radius)] border border-border bg-card shadow-sm"
      onMouseEnter={() => setPaused(true)}
      onMouseLeave={() => setPaused(false)}
      role="region"
      aria-roledescription="carousel"
      aria-label={slides[index]?.eyebrow}
    >
      {/* Aurora / gradient accent */}
      <div
        aria-hidden
        className="pointer-events-none absolute inset-0 bg-gradient-to-br from-primary/15 via-transparent to-sky-500/10"
      />
      <div className="relative overflow-hidden">
        <div
          className="flex transition-transform duration-700 ease-out motion-reduce:transition-none"
          style={{ transform: `translateX(-${index * 100}%)` }}
        >
          {slides.map((s, i) => (
            <div
              key={i}
              className="min-w-full p-8 pb-20 sm:p-10 sm:pb-20"
              aria-hidden={i !== index}
            >
              <p className="text-xs font-semibold uppercase tracking-[0.2em] text-primary">
                {s.eyebrow}
              </p>
              <h3
                className="mt-3 max-w-xl text-2xl font-bold leading-tight tracking-tight text-foreground sm:text-3xl"
                style={{ fontFamily: "var(--font-display)" }}
              >
                {s.title}
              </h3>
              <p className="mt-3 max-w-lg text-sm leading-relaxed text-muted-foreground sm:text-base">
                {s.body}
              </p>
              <Button asChild variant="secondary" className="mt-6" tabIndex={i === index ? 0 : -1}>
                <Link href={`/${locale}${s.href}`}>
                  {s.cta}
                  <ArrowRight />
                </Link>
              </Button>
            </div>
          ))}
        </div>
      </div>

      {/* Controls */}
      <div className="absolute inset-x-0 bottom-0 flex items-center justify-between p-4">
        <div className="flex items-center gap-2">
          {slides.map((_, i) => (
            <button
              key={i}
              type="button"
              onClick={() => go(i)}
              aria-label={`${labels.goTo} ${i + 1}`}
              aria-current={i === index}
              className={cn(
                "h-2.5 w-2.5 rounded-full transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background",
                i === index ? "bg-primary" : "bg-muted-foreground/40 hover:bg-muted-foreground"
              )}
            />
          ))}
        </div>
        <div className="flex items-center gap-2">
          <Button type="button" size="icon" variant="outline" aria-label={labels.prev} onClick={prev}>
            <ChevronLeft />
          </Button>
          <Button type="button" size="icon" variant="outline" aria-label={labels.next} onClick={next}>
            <ChevronRight />
          </Button>
        </div>
      </div>
    </div>
  );
}
