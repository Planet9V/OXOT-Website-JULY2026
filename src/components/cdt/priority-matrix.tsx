"use client";
import * as React from "react";
import { motion, AnimatePresence, useInView, useReducedMotion } from "motion/react";
import { cn } from "@/lib/utils";
import type {
  CdtPriority,
  BomPriority,
  PriorityConsequence,
  PriorityExploit,
  PriorityItem
} from "@/lib/cdt";

const CONS: PriorityConsequence[] = ["critical", "high", "med", "low"];
const EXP: PriorityExploit[] = ["kev", "high-epss", "low-epss", "no-path"];

const CONS_LABEL: Record<PriorityConsequence, string> = {
  critical: "Critical",
  high: "High",
  med: "Medium",
  low: "Low"
};
const EXP_LABEL: Record<PriorityExploit, string> = {
  kev: "KEV",
  "high-epss": "High EPSS",
  "low-epss": "Low EPSS",
  "no-path": "No path"
};

const CELL_TONE: Record<BomPriority, string> = {
  now: "bg-destructive/15 hover:bg-destructive/25 border-destructive/30",
  next: "bg-amber-500/10 hover:bg-amber-500/20 border-amber-500/30",
  never: "bg-muted/50 hover:bg-muted border-border"
};
const BUCKET_TONE: Record<BomPriority, string> = {
  now: "text-destructive",
  next: "text-amber-600 dark:text-amber-400",
  never: "text-muted-foreground"
};

/** Static cell classification: consequence × exploitability → bucket. */
function cellPriority(cons: PriorityConsequence, exp: PriorityExploit): BomPriority {
  if (exp === "no-path") return "never";
  if ((cons === "critical" || cons === "high") && (exp === "kev" || exp === "high-epss")) return "now";
  if (cons === "low" && exp === "low-epss") return "never";
  return "next";
}

export function PriorityMatrix({ priority }: { priority: CdtPriority }) {
  const ref = React.useRef<HTMLDivElement>(null);
  const inView = useInView(ref, { once: true, margin: "-60px" });
  const reduce = useReducedMotion();

  // Index every bucket item into its (consequence, exploit) cell.
  const itemsByCell = React.useMemo(() => {
    const m = new Map<string, PriorityItem[]>();
    for (const b of priority.buckets) {
      for (const it of b.items) {
        const key = `${it.consequence}|${it.exploit}`;
        const arr = m.get(key) ?? [];
        arr.push(it);
        m.set(key, arr);
      }
    }
    return m;
  }, [priority.buckets]);

  const [active, setActive] = React.useState<string | null>(null);
  const activeItems = active ? itemsByCell.get(active) ?? [] : [];
  const [aCons, aExp] = active ? (active.split("|") as [PriorityConsequence, PriorityExploit]) : [null, null];

  return (
    <div ref={ref} className="grid gap-6 lg:grid-cols-[minmax(0,1.4fr)_minmax(0,1fr)]">
      {/* The matrix */}
      <div>
        <div className="flex">
          {/* Y-axis label */}
          <div className="flex w-6 items-center justify-center">
            <span className="rotate-180 text-[10px] font-semibold uppercase tracking-widest text-muted-foreground [writing-mode:vertical-rl]">
              Consequence →
            </span>
          </div>
          <div className="flex-1">
            <div className="grid grid-cols-4 gap-1.5">
              {CONS.map((cons, ri) =>
                EXP.map((exp, ci) => {
                  const key = `${cons}|${exp}`;
                  const p = cellPriority(cons, exp);
                  const items = itemsByCell.get(key) ?? [];
                  const isActive = active === key;
                  return (
                    <motion.button
                      key={key}
                      type="button"
                      onMouseEnter={() => setActive(key)}
                      onFocus={() => setActive(key)}
                      onClick={() => setActive(key)}
                      initial={reduce ? false : { opacity: 0, scale: 0.9 }}
                      animate={inView || reduce ? { opacity: 1, scale: 1 } : undefined}
                      transition={{ duration: 0.35, delay: reduce ? 0 : (ri + ci) * 0.04, ease: [0.22, 1, 0.36, 1] }}
                      className={cn(
                        "relative flex aspect-[4/3] flex-col items-center justify-center rounded-md border p-1 text-center transition-colors",
                        CELL_TONE[p],
                        isActive && "ring-2 ring-primary"
                      )}
                      aria-label={`${CONS_LABEL[cons]} consequence, ${EXP_LABEL[exp]}: ${p.toUpperCase()}${items.length ? `, ${items.length} item(s)` : ""}`}
                    >
                      <span className={cn("text-[10px] font-bold uppercase tracking-wide", BUCKET_TONE[p])}>
                        {p}
                      </span>
                      {items.length > 0 && (
                        <span className="mt-0.5 inline-flex h-4 min-w-4 items-center justify-center rounded-full bg-foreground/80 px-1 text-[9px] font-bold text-background">
                          {items.length}
                        </span>
                      )}
                    </motion.button>
                  );
                })
              )}
            </div>
            {/* X-axis ticks */}
            <div className="mt-1.5 grid grid-cols-4 gap-1.5">
              {EXP.map((exp) => (
                <span key={exp} className="text-center text-[10px] leading-tight text-muted-foreground">
                  {EXP_LABEL[exp]}
                </span>
              ))}
            </div>
            <p className="mt-1 text-center text-[10px] font-semibold uppercase tracking-widest text-muted-foreground">
              Exploitability pathway →
            </p>
          </div>
        </div>
        {/* Row labels under the axis for reference */}
        <div className="mt-3 flex flex-wrap gap-x-4 gap-y-1 pl-6 text-[10px] text-muted-foreground">
          {CONS.map((c) => (
            <span key={c}>{CONS_LABEL[c]}</span>
          ))}
        </div>
      </div>

      {/* Reveal panel */}
      <div className="rounded-[calc(var(--radius)+2px)] border border-border bg-card p-5">
        <AnimatePresence mode="wait">
          {active && aCons && aExp ? (
            <motion.div
              key={active}
              initial={reduce ? false : { opacity: 0, x: 16 }}
              animate={{ opacity: 1, x: 0 }}
              exit={reduce ? undefined : { opacity: 0, x: -16 }}
              transition={{ duration: 0.28, ease: [0.22, 1, 0.36, 1] }}
            >
              <p className="text-[11px] font-semibold uppercase tracking-wide text-muted-foreground">
                {CONS_LABEL[aCons]} consequence · {EXP_LABEL[aExp]}
              </p>
              <p className={cn("mt-1 text-lg font-bold uppercase tracking-wide", BUCKET_TONE[cellPriority(aCons, aExp)])}>
                {cellPriority(aCons, aExp)}
              </p>
              {activeItems.length > 0 ? (
                <ul className="mt-3 space-y-2">
                  {activeItems.map((it) => (
                    <li key={it.label} className="rounded-lg border border-border bg-background p-2.5 text-xs leading-snug text-foreground">
                      {it.label}
                    </li>
                  ))}
                </ul>
              ) : (
                <p className="mt-3 text-xs leading-relaxed text-muted-foreground">
                  No findings land in this cell for the sample estate — but any that did would be triaged here.
                </p>
              )}
            </motion.div>
          ) : (
            <motion.div
              key="idle"
              initial={reduce ? false : { opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={reduce ? undefined : { opacity: 0 }}
            >
              <p className="text-sm font-semibold text-foreground">{priority.rule}</p>
              <div className="mt-4 space-y-3">
                {priority.buckets.map((b) => (
                  <div key={b.key}>
                    <p className={cn("text-xs font-bold uppercase tracking-wide", BUCKET_TONE[b.key])}>{b.label}</p>
                    <p className="mt-0.5 text-xs leading-relaxed text-muted-foreground">{b.rule}</p>
                  </div>
                ))}
              </div>
              <p className="mt-4 text-[11px] text-muted-foreground">Hover a cell to see the findings triaged there.</p>
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </div>
  );
}
