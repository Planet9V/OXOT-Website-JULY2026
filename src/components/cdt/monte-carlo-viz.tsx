"use client";
import * as React from "react";
import { motion, useInView, useReducedMotion } from "motion/react";
import { cn } from "@/lib/utils";
import type { CdtMonteCarlo } from "@/lib/cdt";

const VB_W = 560;
const VB_H = 260;
const PAD_L = 40;
const PAD_R = 20;
const PAD_T = 20;
const PAD_B = 44;
const DOMAIN_MAX = 16; // percent axis headroom for the "under stress" scenario

/**
 * Monte Carlo distribution: a histogram of P(adversary reaches a safety-critical
 * system) across simulated campaigns, with a shaded 95% confidence-interval band
 * and a mean marker. Scenario buttons re-shift the whole curve (shiftPct) with a
 * spring transition. Token-themed, dark+light safe, reduced-motion aware.
 */
export function MonteCarloViz({ data }: { data: CdtMonteCarlo }) {
  const ref = React.useRef<HTMLDivElement>(null);
  const inView = useInView(ref, { once: true, margin: "-60px" });
  const reduce = useReducedMotion();
  const [scenarioId, setScenarioId] = React.useState(data.scenarios[0]?.id ?? "base");

  const scenario = data.scenarios.find((s) => s.id === scenarioId) ?? data.scenarios[0];
  const shift = scenario?.shiftPct ?? 0;

  const plotW = VB_W - PAD_L - PAD_R;
  const plotH = VB_H - PAD_T - PAD_B;
  const maxP = Math.max(...data.bins.map((b) => b.p), 0.01);

  const xToPx = (pct: number) => PAD_L + (Math.max(0, Math.min(DOMAIN_MAX, pct)) / DOMAIN_MAX) * plotW;
  const pxPerPct = plotW / DOMAIN_MAX;
  const translatePx = shift * pxPerPct;

  const mean = Math.max(0, data.ci.meanPct + shift);
  const lower = Math.max(0, data.ci.lowerPct + shift);
  const upper = Math.max(0, data.ci.upperPct + shift);

  const barW = Math.max(6, (plotW / DOMAIN_MAX) * 0.8);
  const spring = { type: "spring" as const, stiffness: 120, damping: 18 };

  return (
    <div ref={ref}>
      <div className="rounded-[calc(var(--radius)+2px)] border border-border bg-card p-4 sm:p-6">
        <div className="flex flex-wrap items-baseline justify-between gap-2">
          <p className="text-[11px] font-semibold uppercase tracking-wide text-muted-foreground">
            {data.runsLabel}
          </p>
          <motion.p
            key={mean.toFixed(1)}
            initial={reduce ? false : { opacity: 0, y: -4 }}
            animate={{ opacity: 1, y: 0 }}
            className="text-sm font-bold text-foreground"
          >
            <span className="text-primary">{mean.toFixed(1)}%</span>{" "}
            <span className="font-normal text-muted-foreground">
              (95% CI {lower.toFixed(1)}–{upper.toFixed(1)}%)
            </span>
          </motion.p>
        </div>
        <p className="mt-1 text-[11px] text-muted-foreground">{data.ci.label}</p>

        <svg viewBox={`0 0 ${VB_W} ${VB_H}`} className="mt-3 w-full" role="img" aria-label={data.ci.label}>
          {/* baseline */}
          <line x1={PAD_L} y1={PAD_T + plotH} x2={VB_W - PAD_R} y2={PAD_T + plotH} stroke="hsl(var(--border))" strokeWidth={1} />

          {/* Confidence-interval band */}
          <motion.rect
            y={PAD_T}
            height={plotH}
            fill="hsl(var(--primary) / 0.10)"
            stroke="hsl(var(--primary) / 0.30)"
            strokeWidth={1}
            initial={false}
            animate={{ x: xToPx(lower), width: Math.max(2, xToPx(upper) - xToPx(lower)) }}
            transition={reduce ? { duration: 0 } : spring}
          />

          {/* Histogram bars — the whole group translates on scenario change */}
          <motion.g
            initial={false}
            animate={{ x: translatePx }}
            transition={reduce ? { duration: 0 } : spring}
          >
            {data.bins.map((b, i) => {
              const h = (b.p / maxP) * plotH;
              const cx = xToPx(b.x);
              return (
                <motion.rect
                  key={b.x}
                  x={cx - barW / 2}
                  width={barW}
                  rx={2}
                  fill="hsl(var(--primary) / 0.55)"
                  initial={reduce ? undefined : { height: 0, y: PAD_T + plotH }}
                  animate={inView || reduce ? { height: h, y: PAD_T + plotH - h } : undefined}
                  transition={{ duration: 0.5, delay: reduce ? 0 : i * 0.03, ease: [0.22, 1, 0.36, 1] }}
                />
              );
            })}
          </motion.g>

          {/* Mean marker */}
          <motion.g initial={false} animate={{ x: xToPx(mean) }} transition={reduce ? { duration: 0 } : spring}>
            <line y1={PAD_T - 4} y2={PAD_T + plotH} stroke="hsl(var(--destructive))" strokeWidth={2} strokeDasharray="4 4" />
            <text y={PAD_T - 8} textAnchor="middle" fontSize={11} fontWeight={700} fill="hsl(var(--destructive))">
              mean
            </text>
          </motion.g>

          {/* X-axis ticks */}
          {[0, 4, 8, 12, 16].map((t) => (
            <text key={t} x={xToPx(t)} y={PAD_T + plotH + 16} textAnchor="middle" fontSize={10} fill="hsl(var(--muted-foreground))">
              {t}%
            </text>
          ))}
          <text x={PAD_L + plotW / 2} y={VB_H - 6} textAnchor="middle" fontSize={10} fill="hsl(var(--muted-foreground))">
            P(reach a safety-critical system) across simulated campaigns
          </text>
        </svg>
      </div>

      {/* Scenario toggles */}
      <div className="mt-4 flex flex-wrap gap-2">
        {data.scenarios.map((s) => (
          <button
            key={s.id}
            type="button"
            onClick={() => setScenarioId(s.id)}
            aria-pressed={scenarioId === s.id}
            className={cn(
              "rounded-full border px-3 py-1.5 text-xs font-medium transition-colors",
              scenarioId === s.id
                ? "border-primary bg-primary text-primary-foreground"
                : "border-border bg-card text-muted-foreground hover:border-primary/40 hover:text-foreground"
            )}
          >
            {s.label}
            {s.shiftPct !== 0 && (
              <span className={cn("ml-1.5 font-bold", s.shiftPct < 0 ? "text-emerald-400" : "text-amber-300")}>
                {s.shiftPct > 0 ? "+" : ""}
                {s.shiftPct}
              </span>
            )}
          </button>
        ))}
      </div>
      <motion.p
        key={scenario?.id}
        initial={reduce ? false : { opacity: 0 }}
        animate={{ opacity: 1 }}
        className="mt-2 text-xs leading-relaxed text-muted-foreground"
      >
        {scenario?.note}
      </motion.p>
    </div>
  );
}
