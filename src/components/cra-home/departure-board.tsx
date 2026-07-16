"use client";
import * as React from "react";
import { motion, useInView, useReducedMotion } from "motion/react";
import { cn } from "@/lib/utils";
import type { CraHomeDepartureBoard, RoadSegmentTone } from "@/lib/cra-home";

const TONE_BAR: Record<RoadSegmentTone, string> = {
  safe: "bg-emerald-600/80 dark:bg-emerald-500/80",
  tight: "bg-amber-500/90",
  late: "bg-destructive/75",
  closed: ""
};

const CLOSED_STRIPES: React.CSSProperties = {
  backgroundImage:
    "repeating-linear-gradient(45deg, hsl(var(--muted)) 0, hsl(var(--muted)) 8px, hsl(var(--border)) 8px, hsl(var(--border)) 16px)"
};

const TONE_DOT: Record<RoadSegmentTone, string> = {
  safe: "bg-emerald-600 dark:bg-emerald-500",
  tight: "bg-amber-500",
  late: "bg-destructive",
  closed: "bg-muted-foreground/40"
};

/** One road's segmented, scroll-animated bar. Shared between the desktop
 *  axis-aligned rows and the mobile stacked road cards. */
function RoadBar({
  segments,
  inView
}: {
  segments: CraHomeDepartureBoard["roads"][number]["segments"];
  inView: boolean;
}) {
  const reduce = useReducedMotion();
  return (
    <div className="relative h-9 overflow-hidden rounded-md bg-muted/60">
      {segments.map((seg, i) => (
        <motion.div
          key={i}
          className={cn("absolute inset-y-0 flex items-center overflow-hidden", TONE_BAR[seg.tone])}
          style={{ left: `${seg.startPct}%`, ...(seg.tone === "closed" ? CLOSED_STRIPES : {}) }}
          initial={reduce ? undefined : { width: 0 }}
          animate={{ width: inView || reduce ? `${seg.widthPct}%` : 0 }}
          transition={{ duration: 0.6, ease: [0.22, 1, 0.36, 1], delay: reduce ? 0 : i * 0.08 }}
        >
          {seg.caption && (
            <span className="truncate px-2 text-[11px] font-medium text-white/95">{seg.caption}</span>
          )}
        </motion.div>
      ))}
    </div>
  );
}

export function DepartureBoard({ board }: { board: CraHomeDepartureBoard }) {
  const ref = React.useRef<HTMLDivElement>(null);
  const inView = useInView(ref, { once: true, margin: "-60px" });

  return (
    <div ref={ref}>
      {/* Desktop / tablet: horizontal axis with milestones, then the three road rows. */}
      <div className="hidden sm:block">
        <div className="relative mt-4 h-24">
          <div className="absolute inset-x-0 top-[70px] h-[2px] bg-foreground/70" />
          {board.milestones.map((m, i) => (
            <div
              key={i}
              className="absolute top-0 flex -translate-x-1/2 flex-col items-center text-center"
              style={{ left: `${m.pct}%` }}
            >
              <span
                className={cn(
                  "mb-1 whitespace-nowrap rounded px-1.5 py-0.5 text-[10px] font-bold",
                  m.tone === "start" && "bg-primary text-primary-foreground",
                  m.tone === "end" && "bg-foreground text-background",
                  (m.tone === "info" || m.tone === "warning") && "text-transparent"
                )}
              >
                {m.tone === "start" || m.tone === "end" ? m.note : m.dateLabel}
              </span>
              <span
                className={cn(
                  "block w-px flex-1",
                  m.tone === "warning" || m.tone === "end" ? "bg-destructive" : "bg-foreground/40"
                )}
                style={{ height: 30 }}
              />
              <span
                className={cn(
                  "mt-1 w-[9rem] text-[11px] leading-tight",
                  m.tone === "warning" ? "font-semibold text-destructive" : "text-muted-foreground"
                )}
              >
                <strong className="block text-foreground">{m.dateLabel}</strong>
                {m.note}
              </span>
            </div>
          ))}
        </div>
        <div className="mt-2 flex justify-between text-[10px] uppercase tracking-wide text-muted-foreground">
          {board.axisLabels.map((l) => (
            <span key={l}>{l}</span>
          ))}
        </div>

        <div className="mt-8 space-y-4">
          {board.roads.map((road) => (
            <div key={road.id} className="grid grid-cols-[190px_1fr] items-center gap-4">
              <div className="text-right text-xs">
                <strong className="text-foreground">{road.label}</strong>
                <br />
                <span className="text-muted-foreground">{road.sub}</span>
              </div>
              <RoadBar segments={road.segments} inView={inView} />
            </div>
          ))}
        </div>
      </div>

      {/* Mobile: vertical timeline of milestones, then stacked road cards. */}
      <div className="space-y-6 sm:hidden">
        <ol className="relative space-y-4 border-l border-border pl-4">
          {board.milestones.map((m, i) => (
            <li key={i} className="relative">
              <span
                className={cn(
                  "absolute -left-[21px] top-1 h-2.5 w-2.5 rounded-full",
                  m.tone === "start" && "bg-primary",
                  m.tone === "end" && "bg-foreground",
                  m.tone === "warning" && "bg-destructive",
                  m.tone === "info" && "bg-muted-foreground/50"
                )}
                aria-hidden
              />
              <p className="text-xs font-semibold text-foreground">{m.dateLabel}</p>
              <p
                className={cn(
                  "text-xs",
                  m.tone === "warning" ? "font-medium text-destructive" : "text-muted-foreground"
                )}
              >
                {m.note}
              </p>
            </li>
          ))}
        </ol>
        <div className="space-y-4">
          {board.roads.map((road) => (
            <div key={road.id} className="rounded-lg border border-border bg-card p-4">
              <p className="text-sm font-semibold text-foreground">{road.label}</p>
              <p className="mb-3 text-xs text-muted-foreground">{road.sub}</p>
              <RoadBar segments={road.segments} inView={inView} />
            </div>
          ))}
        </div>
      </div>

      <div className="mt-6 flex flex-wrap gap-x-5 gap-y-2 text-[11px] text-muted-foreground">
        {board.legend.map((l) => (
          <span key={l.label} className="inline-flex items-center gap-1.5">
            <span className={cn("inline-block h-2.5 w-2.5 rounded-sm", TONE_DOT[l.tone])} aria-hidden />
            {l.label}
          </span>
        ))}
      </div>
    </div>
  );
}
