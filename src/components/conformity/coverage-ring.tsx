"use client";
import * as React from "react";
import { motion, useInView, useReducedMotion } from "motion/react";

const EASE = [0.22, 1, 0.36, 1] as const;

/**
 * Radial gauge showing how many of the tracked themes a regulation touches.
 * Center shows "covered / total"; the regulation shortName sits below. The
 * stroke animates on scroll into view, honouring reduced-motion. Colours use
 * the primary/muted tokens so it adapts to dark/light.
 */
export function CoverageRing({
  covered,
  total,
  shortName
}: {
  covered: number;
  total: number;
  shortName: string;
}) {
  const ref = React.useRef<HTMLDivElement>(null);
  const inView = useInView(ref, { once: true, margin: "-40px" });
  const reduce = useReducedMotion();

  // Fallback so the ring never stays empty if IntersectionObserver never fires.
  const [fallback, setFallback] = React.useState(false);
  React.useEffect(() => {
    const t = setTimeout(() => setFallback(true), 1400);
    return () => clearTimeout(t);
  }, []);
  const show = inView || fallback;

  const size = 120;
  const stroke = 10;
  const radius = (size - stroke) / 2;
  const circ = 2 * Math.PI * radius;
  const pct = total > 0 ? covered / total : 0;
  const offset = circ * (1 - pct);

  return (
    <div ref={ref} className="flex flex-col items-center gap-2">
      <div className="relative" style={{ width: size, height: size }}>
        <svg
          width={size}
          height={size}
          viewBox={`0 0 ${size} ${size}`}
          className="-rotate-90"
          aria-hidden
        >
          <circle
            cx={size / 2}
            cy={size / 2}
            r={radius}
            fill="none"
            strokeWidth={stroke}
            style={{ stroke: "hsl(var(--muted))" }}
          />
          <motion.circle
            cx={size / 2}
            cy={size / 2}
            r={radius}
            fill="none"
            strokeWidth={stroke}
            strokeLinecap="round"
            strokeDasharray={circ}
            style={{ stroke: "hsl(var(--primary))" }}
            initial={{ strokeDashoffset: reduce ? offset : circ }}
            animate={{ strokeDashoffset: show ? offset : reduce ? offset : circ }}
            transition={{ duration: 1.1, ease: EASE }}
          />
        </svg>
        <div className="absolute inset-0 flex items-center justify-center">
          <span className="text-lg font-bold tabular-nums text-foreground">
            {covered} / {total}
          </span>
        </div>
      </div>
      <span className="text-sm font-medium text-foreground">{shortName}</span>
    </div>
  );
}
