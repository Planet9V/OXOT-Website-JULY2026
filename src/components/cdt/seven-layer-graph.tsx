"use client";
import * as React from "react";
import { motion, useInView, useReducedMotion } from "motion/react";
import { cn } from "@/lib/utils";
import type { CdtLivingModel, GraphLayerTone } from "@/lib/cdt";

/** Token-driven fills so the graph is correct in dark AND light without hex. */
const TONE_FILL: Record<GraphLayerTone, string> = {
  asset: "hsl(var(--primary) / 0.16)",
  risk: "hsl(var(--destructive) / 0.14)",
  control: "hsl(var(--primary) / 0.10)",
  dependency: "hsl(var(--muted-foreground) / 0.14)"
};
const TONE_STROKE: Record<GraphLayerTone, string> = {
  asset: "hsl(var(--primary))",
  risk: "hsl(var(--destructive))",
  control: "hsl(var(--primary))",
  dependency: "hsl(var(--muted-foreground))"
};

const VB_W = 460;
const SLAB_H = 46;
const GAP = 14;
const PAD_TOP = 18;

/**
 * The seven-layer graph: stacked isometric-ish slabs that slide in on scroll,
 * reveal their caption on hover/focus, and carry an animated consequence-path
 * edge that travels from the top asset layer down to the bottom control layer
 * (asset → control). Pure SVG + motion/react, fully token-themed.
 */
export function SevenLayerGraph({ model }: { model: CdtLivingModel }) {
  const ref = React.useRef<HTMLDivElement>(null);
  const inView = useInView(ref, { once: true, margin: "-60px" });
  const reduce = useReducedMotion();
  const [active, setActive] = React.useState<number | null>(null);

  const layers = model.layers;
  const n = layers.length;
  const vbH = PAD_TOP * 2 + n * SLAB_H + (n - 1) * GAP;
  const slabW = VB_W - 120;
  const skew = 26; // horizontal offset for the faux-3D right edge

  const rowY = (i: number) => PAD_TOP + i * (SLAB_H + GAP);
  const centerX = 60 + slabW / 2;

  return (
    <div ref={ref} className="w-full">
      <svg
        viewBox={`0 0 ${VB_W} ${vbH}`}
        className="w-full"
        role="img"
        aria-label={model.graphAriaLabel}
      >
        <defs>
          <linearGradient id="cdt-edge" x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%" stopColor="hsl(var(--primary))" stopOpacity="0.9" />
            <stop offset="100%" stopColor="hsl(var(--destructive))" stopOpacity="0.9" />
          </linearGradient>
        </defs>

        {/* Consequence-path edge: asset (top) → control (bottom). */}
        <motion.line
          x1={centerX}
          y1={rowY(0) + SLAB_H / 2}
          x2={centerX}
          y2={rowY(n - 1) + SLAB_H / 2}
          stroke="url(#cdt-edge)"
          strokeWidth={2.5}
          strokeDasharray="5 6"
          initial={reduce ? undefined : { pathLength: 0, opacity: 0 }}
          animate={inView || reduce ? { pathLength: 1, opacity: 1 } : undefined}
          transition={{ duration: 1.1, delay: 0.5, ease: [0.22, 1, 0.36, 1] }}
        />
        {!reduce && (
          <motion.circle
            r={4}
            fill="hsl(var(--primary))"
            initial={{ opacity: 0 }}
            animate={
              inView
                ? {
                    opacity: [0, 1, 1, 0],
                    cx: centerX,
                    cy: [rowY(0) + SLAB_H / 2, rowY(n - 1) + SLAB_H / 2]
                  }
                : undefined
            }
            transition={{ duration: 1.6, delay: 1.2, repeat: Infinity, repeatDelay: 1.4, ease: "easeInOut" }}
          />
        )}

        {layers.map((layer, i) => {
          const y = rowY(i);
          const isActive = active === i;
          return (
            <motion.g
              key={layer.id}
              initial={reduce ? undefined : { opacity: 0, x: -28 }}
              animate={inView || reduce ? { opacity: 1, x: 0 } : undefined}
              transition={{ duration: 0.55, delay: reduce ? 0 : i * 0.09, ease: [0.22, 1, 0.36, 1] }}
              onMouseEnter={() => setActive(i)}
              onMouseLeave={() => setActive((a) => (a === i ? null : a))}
              onFocus={() => setActive(i)}
              onBlur={() => setActive((a) => (a === i ? null : a))}
              tabIndex={0}
              style={{ cursor: "pointer", outline: "none" }}
              aria-label={`${layer.name}. ${layer.caption}`}
            >
              {/* faux-3D side */}
              <path
                d={`M ${60 + slabW} ${y} l ${skew} -10 l 0 ${SLAB_H} l ${-skew} 10 Z`}
                fill={TONE_STROKE[layer.tone]}
                opacity={isActive ? 0.32 : 0.16}
              />
              {/* top face */}
              <path
                d={`M 60 ${y} l ${skew} -10 l ${slabW} 0 l ${-skew} 10 Z`}
                fill={TONE_STROKE[layer.tone]}
                opacity={isActive ? 0.26 : 0.12}
              />
              {/* front face */}
              <rect
                x={60}
                y={y}
                width={slabW}
                height={SLAB_H}
                rx={6}
                fill={TONE_FILL[layer.tone]}
                stroke={TONE_STROKE[layer.tone]}
                strokeWidth={isActive ? 2 : 1}
              />
              <text
                x={72}
                y={y + SLAB_H / 2 + 4}
                fontSize={13}
                fontWeight={600}
                fill="hsl(var(--foreground))"
              >
                {layer.name}
              </text>
            </motion.g>
          );
        })}
      </svg>

      {/* Caption reveal — the hovered/focused layer's detail, live-region for a11y. */}
      <div
        className={cn(
          "mt-3 min-h-[3.5rem] rounded-[var(--radius)] border p-3 text-xs leading-relaxed transition-colors",
          active === null
            ? "border-border bg-muted/30 text-muted-foreground"
            : "border-primary/30 bg-primary/5 text-foreground"
        )}
        aria-live="polite"
      >
        {active === null ? (
          <span>{model.graphHint}</span>
        ) : (
          <span>
            <strong className="text-foreground">{layers[active].name}</strong> — {layers[active].caption}
          </span>
        )}
      </div>
    </div>
  );
}
