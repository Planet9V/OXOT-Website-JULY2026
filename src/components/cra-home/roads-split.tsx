"use client";
import * as React from "react";
import { motion, useInView, useReducedMotion } from "motion/react";
import { ArrowRight, TriangleAlert, Truck, RefreshCw, BadgeCheck } from "lucide-react";
import { cn } from "@/lib/utils";
import type { CraHomeRoadsSplit, RoadsSplitRoad, RoadStatusTone } from "@/lib/cra-home";

// Road -> the business segment most likely to ask about that road, so a click
// preselects something sensible in the intake form's segment dropdown. Roads are
// conformity paths (A / B+C / H), not the 5 SEGMENTS themselves, so this is a
// best-fit mapping rather than a 1:1 contract.
const ROAD_SEGMENT: Record<string, string> = {
  a: "manufacturer",
  bc: "integrator",
  h: "oem"
};

function goToIntake(roadId: string) {
  const segment = ROAD_SEGMENT[roadId];
  window.dispatchEvent(
    new CustomEvent("oxot:intake-preselect", { detail: segment ? { segment } : {} })
  );
}

const EASE = [0.22, 1, 0.36, 1] as const;

// Fixed asphalt slate that reads on both the light and dark panel gradients,
// separated from the panel by a lighter casing stroke. Emerald = the CE-mark
// destination; primary (OXOT orange) = the live highlight on hover.
const ASPHALT = "#334155";
const CASING = "#94a3b8";
const LANE = "#f8fafc";

type Geo = {
  d: string;
  width: number;
  endX: number;
  endY: number;
  /** Sign card anchor as a % of the viewport box. */
  signTop: number;
};

// viewBox 0 0 952 430 — trunk splits at (210,215) into three roads.
const GEO: Record<string, Geo> = {
  a: { d: "M 210 215 C 340 215 370 82 500 82 L 952 82", width: 42, endX: 952, endY: 82, signTop: 5 },
  bc: { d: "M 210 215 L 952 215", width: 42, endX: 952, endY: 215, signTop: 40.5 },
  h: { d: "M 210 215 C 340 215 370 348 500 348 L 952 348", width: 42, endX: 952, endY: 348, signTop: 76 }
};
const TRUNK = "M 0 215 L 210 215";
const ORDER = ["a", "bc", "h"] as const;

const TONE_ICON: Record<RoadStatusTone, typeof TriangleAlert> = {
  closed: TriangleAlert,
  reserved: Truck,
  scales: RefreshCw
};

const TONE: Record<
  RoadStatusTone,
  { badge: string; status: string; ring: string; bar: string }
> = {
  closed: {
    badge: "bg-destructive/10 text-destructive",
    status: "border-destructive/40 bg-destructive/5 text-destructive",
    ring: "border-destructive/50",
    bar: "bg-destructive"
  },
  reserved: {
    badge: "bg-primary/10 text-primary",
    status: "border-primary/40 bg-primary/5 text-primary",
    ring: "border-primary/50",
    bar: "bg-primary"
  },
  scales: {
    badge: "bg-emerald-500/10 text-emerald-600 dark:text-emerald-400",
    status:
      "border-emerald-500/40 bg-emerald-500/5 text-emerald-600 dark:text-emerald-400",
    ring: "border-emerald-500/50",
    bar: "bg-emerald-500"
  }
};

const DISPLAY = { fontFamily: "var(--font-display)" } as const;

function RoadSign({
  road,
  active,
  dimmed,
  onEnter,
  onLeave,
  onClick,
  index,
  show
}: {
  road: RoadsSplitRoad;
  active: boolean;
  dimmed: boolean;
  onEnter: () => void;
  onLeave: () => void;
  onClick: () => void;
  index: number;
  show: boolean;
}) {
  const tone = TONE[road.statusTone];
  const StatusIcon = TONE_ICON[road.statusTone];
  const geo = GEO[road.id];
  return (
    <motion.button
      type="button"
      onMouseEnter={onEnter}
      onMouseLeave={onLeave}
      onFocus={onEnter}
      onBlur={onLeave}
      onClick={onClick}
      initial={{ opacity: 0, x: 24 }}
      animate={show ? { opacity: dimmed ? 0.45 : 1, x: 0 } : { opacity: 0, x: 24 }}
      transition={{ duration: 0.55, ease: EASE, delay: show ? 0.9 + index * 0.14 : 0 }}
      style={{ top: `${geo.signTop}%` }}
      className={cn(
        "group absolute left-[31%] z-10 w-[36%] rounded-[var(--radius)] border bg-card/95 p-3 text-left shadow-lg backdrop-blur transition-all duration-300",
        active ? cn("-translate-y-1 shadow-xl", tone.ring) : "border-border"
      )}
    >
      <span className={cn("inline-block rounded px-1.5 py-0.5 text-[10px] font-bold tracking-wide", tone.badge)}>
        {road.laneLabel}
      </span>
      <h3 className="mt-2 text-sm font-semibold text-foreground" style={DISPLAY}>
        {road.title}
      </h3>
      <p className="mt-1 text-[11px] leading-snug text-muted-foreground">{road.segment}</p>
      <p className={cn("mt-2 flex items-start gap-1.5 rounded border px-2 py-1.5 text-[11px] font-medium leading-snug", tone.status)}>
        <StatusIcon className="mt-0.5 h-3 w-3 shrink-0" aria-hidden />
        <span>{road.status}</span>
      </p>
      <p className="mt-2 text-[11px] leading-snug text-foreground/80">
        <span className="font-semibold text-primary">OXOT does · </span>
        {road.oxotDoes}
      </p>
      <span className="mt-2 inline-flex items-center gap-1 text-[11px] font-semibold text-primary opacity-0 transition-opacity group-hover:opacity-100">
        Start intake <ArrowRight className="h-3 w-3" aria-hidden />
      </span>
    </motion.button>
  );
}

export function RoadsSplit({ split }: { split: CraHomeRoadsSplit }) {
  const ref = React.useRef<HTMLDivElement>(null);
  const inView = useInView(ref, { once: true, margin: "-80px" });
  const reduce = useReducedMotion();
  const show = inView || !!reduce;
  const [hovered, setHovered] = React.useState<string | null>(null);
  const byId = React.useMemo(
    () => Object.fromEntries(split.roads.map((r) => [r.id, r])),
    [split.roads]
  );

  return (
    <div ref={ref}>
      {/* Desktop / tablet: the interactive SVG pathway map. */}
      <div className="relative hidden lg:block">
        <div className="mb-4 inline-flex items-center gap-2 rounded-full bg-primary/10 px-3 py-1 text-xs font-semibold text-primary">
          {split.startBadge}
        </div>
        <div className="relative aspect-[952/430] w-full overflow-hidden rounded-[calc(var(--radius)+4px)] border border-border bg-gradient-to-br from-slate-100 to-slate-200 dark:from-slate-800 dark:to-slate-900">
          <svg viewBox="0 0 952 430" className="absolute inset-0 h-full w-full" role="img" aria-label={split.title}>
            {/* Casing (road borders) + asphalt, drawn in on scroll. */}
            {[{ id: "trunk", d: TRUNK, width: 46 }, ...ORDER.map((id) => ({ id, d: GEO[id].d, width: GEO[id].width }))].map(
              (r, i) => (
                <g key={r.id}>
                  <motion.path
                    d={r.d}
                    fill="none"
                    stroke={CASING}
                    strokeOpacity={0.55}
                    strokeWidth={r.width + 7}
                    strokeLinecap="round"
                    initial={{ pathLength: 0 }}
                    animate={{ pathLength: show ? 1 : 0 }}
                    transition={{ duration: 1, ease: EASE, delay: reduce ? 0 : i * 0.12 }}
                  />
                  <motion.path
                    d={r.d}
                    fill="none"
                    stroke={ASPHALT}
                    strokeWidth={r.width}
                    strokeLinecap="round"
                    style={{
                      opacity: hovered && r.id !== "trunk" && hovered !== r.id ? 0.5 : 1,
                      transition: "opacity .3s"
                    }}
                    initial={{ pathLength: 0 }}
                    animate={{ pathLength: show ? 1 : 0 }}
                    transition={{ duration: 1, ease: EASE, delay: reduce ? 0 : i * 0.12 }}
                  />
                </g>
              )
            )}

            {/* Primary highlight overlay for the hovered road. */}
            {ORDER.map((id) => (
              <path
                key={`hl-${id}`}
                d={GEO[id].d}
                fill="none"
                stroke="hsl(var(--primary))"
                strokeWidth={GEO[id].width}
                strokeLinecap="round"
                style={{ opacity: hovered === id ? 1 : 0, transition: "opacity .3s" }}
              />
            ))}

            {/* White dashed lane markings, faded in after the roads draw. */}
            {[{ id: "trunk", d: TRUNK }, ...ORDER.map((id) => ({ id, d: GEO[id].d }))].map((r) => (
              <motion.path
                key={`lane-${r.id}`}
                d={r.d}
                fill="none"
                stroke={LANE}
                strokeWidth={2.4}
                strokeDasharray="11 10"
                strokeOpacity={0.85}
                initial={{ opacity: 0 }}
                animate={{ opacity: show ? 1 : 0 }}
                transition={{ duration: 0.6, delay: reduce ? 0 : 1.1 }}
              />
            ))}

            {/* START node + CE-mark destination nodes. */}
            <motion.circle
              cx={210}
              cy={215}
              r={13}
              fill="hsl(var(--primary))"
              initial={{ scale: 0 }}
              animate={{ scale: show ? 1 : 0 }}
              transition={{ duration: 0.4, delay: reduce ? 0 : 0.2 }}
              style={{ transformOrigin: "210px 215px" }}
            />
            {ORDER.map((id, i) => (
              <motion.circle
                key={`ce-${id}`}
                cx={930}
                cy={GEO[id].endY}
                r={12}
                fill="#10b981"
                initial={{ scale: 0 }}
                animate={{ scale: show ? 1 : 0 }}
                transition={{ duration: 0.4, delay: reduce ? 0 : 1.3 + i * 0.12 }}
                style={{ transformOrigin: `930px ${GEO[id].endY}px` }}
              />
            ))}
          </svg>

          {/* START badge overlay. */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: show ? 1 : 0 }}
            transition={{ duration: 0.5, delay: reduce ? 0 : 0.3 }}
            className="absolute left-[1.5%] top-[38%] w-[20%] rounded-[var(--radius)] border border-primary/40 bg-primary/10 p-2 text-center"
          >
            <p className="text-[10px] font-bold uppercase tracking-wide text-primary" style={DISPLAY}>
              Start · Phase 1
            </p>
            <p className="mt-0.5 text-[10px] leading-snug text-foreground/70">Intake & classification — always OXOT</p>
          </motion.div>

          {/* Road signs (interactive). */}
          {ORDER.map((id, i) => {
            const road = byId[id];
            if (!road) return null;
            return (
              <RoadSign
                key={id}
                road={road}
                index={i}
                show={show}
                active={hovered === id}
                dimmed={!!hovered && hovered !== id}
                onEnter={() => setHovered(id)}
                onLeave={() => setHovered((h) => (h === id ? null : h))}
                onClick={() => goToIntake(id)}
              />
            );
          })}

          {/* CE-mark destination chips at each road end. */}
          {ORDER.map((id, i) => {
            const road = byId[id];
            if (!road) return null;
            return (
              <motion.div
                key={`cechip-${id}`}
                initial={{ opacity: 0, scale: 0.9 }}
                animate={show ? { opacity: hovered && hovered !== id ? 0.45 : 1, scale: 1 } : { opacity: 0, scale: 0.9 }}
                transition={{ duration: 0.5, ease: EASE, delay: show ? 1.35 + i * 0.12 : 0 }}
                style={{ top: `${GEO[id].signTop + (id === "a" ? 8 : id === "h" ? 4 : 6)}%` }}
                className="absolute right-[1.5%] z-10 w-[16%] rounded-lg border border-emerald-500/40 bg-emerald-500/10 p-2 text-center"
              >
                <BadgeCheck className="mx-auto h-4 w-4 text-emerald-600 dark:text-emerald-400" aria-hidden />
                <p className="mt-1 text-[10px] font-semibold leading-snug text-emerald-700 dark:text-emerald-300">
                  {road.ceMarkNote}
                </p>
              </motion.div>
            );
          })}
        </div>
      </div>

      {/* Mobile / small tablet: rich stacked road cards carrying the same copy. */}
      <div className="space-y-4 lg:hidden">
        <div className="inline-flex items-center gap-2 rounded-full bg-primary/10 px-3 py-1 text-xs font-semibold text-primary">
          {split.startBadge}
        </div>
        {split.roads.map((road) => {
          const tone = TONE[road.statusTone];
          const StatusIcon = TONE_ICON[road.statusTone];
          return (
            <button
              key={road.id}
              type="button"
              onClick={() => goToIntake(road.id)}
              className={cn(
                "flex w-full flex-col rounded-[var(--radius)] border border-border bg-card p-5 text-left transition-all duration-200 hover:-translate-y-0.5 hover:shadow-md",
                "border-l-4",
                road.statusTone === "closed" && "border-l-destructive",
                road.statusTone === "reserved" && "border-l-primary",
                road.statusTone === "scales" && "border-l-emerald-500"
              )}
            >
              <span className={cn("inline-block w-fit rounded px-1.5 py-0.5 text-[10px] font-bold tracking-wide", tone.badge)}>
                {road.laneLabel}
              </span>
              <h3 className="mt-2 text-base font-semibold text-foreground" style={DISPLAY}>
                {road.title}
              </h3>
              <p className="mt-1 text-xs text-muted-foreground">{road.segment}</p>
              <p className={cn("mt-3 flex items-start gap-1.5 rounded border px-2 py-1.5 text-xs font-medium leading-snug", tone.status)}>
                <StatusIcon className="mt-0.5 h-3.5 w-3.5 shrink-0" aria-hidden />
                <span>{road.status}</span>
              </p>
              <p className="mt-3 text-xs leading-relaxed text-muted-foreground">{road.body}</p>
              <p className="mt-2 text-xs leading-relaxed text-foreground/80">
                <span className="font-semibold text-primary">OXOT does · </span>
                {road.oxotDoes}
              </p>
              <p className="mt-3 flex items-center gap-1.5 rounded-lg border border-emerald-500/40 bg-emerald-500/10 px-2 py-1.5 text-xs font-semibold text-emerald-700 dark:text-emerald-300">
                <BadgeCheck className="h-4 w-4 shrink-0" aria-hidden />
                {road.ceMarkNote}
              </p>
            </button>
          );
        })}
      </div>

      {/* WRONG TURNS callout. */}
      <div className="mt-6 rounded-[var(--radius)] border border-dashed border-destructive/40 bg-destructive/5 p-4">
        <p className="flex items-center gap-2 text-xs font-bold uppercase tracking-wide text-destructive">
          <TriangleAlert className="h-3.5 w-3.5" aria-hidden />
          {split.wrongTurnsTitle}
        </p>
        <p className="mt-2 text-xs leading-relaxed text-muted-foreground">{split.wrongTurns}</p>
      </div>
      <p className="mt-4 text-center text-sm text-muted-foreground">{split.footnote}</p>
    </div>
  );
}
