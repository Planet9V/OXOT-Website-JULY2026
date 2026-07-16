"use client";
import * as React from "react";
import { motion, AnimatePresence, useReducedMotion } from "motion/react";
import { ChevronRight } from "lucide-react";
import { cn } from "@/lib/utils";
import type { CdtDrilldown, BomRow, BomRowLevel, BomPriority } from "@/lib/cdt";

const LEVEL_ORDER: BomRowLevel[] = ["org", "facility", "productLine", "equipment", "component"];

const PRIORITY_PILL: Record<BomPriority, string> = {
  now: "bg-destructive/15 text-destructive border-destructive/30",
  next: "bg-amber-500/15 text-amber-600 border-amber-500/30 dark:text-amber-400",
  never: "bg-muted text-muted-foreground border-border"
};
/** Cell tint for a 0–10 CVSS score — token-driven, dark+light safe. */
function cvssClass(v: number): string {
  if (v >= 9) return "bg-destructive/20 text-destructive font-semibold";
  if (v >= 7) return "bg-destructive/10 text-destructive";
  if (v >= 4) return "bg-amber-500/15 text-amber-600 dark:text-amber-400";
  return "bg-muted text-muted-foreground";
}
/** Cell tint for a 0–1 EPSS probability. */
function epssClass(v: number): string {
  if (v >= 0.5) return "bg-destructive/20 text-destructive font-semibold";
  if (v >= 0.2) return "bg-amber-500/15 text-amber-600 dark:text-amber-400";
  return "bg-muted text-muted-foreground";
}

type SortKey = "cvss" | "epss" | null;

export function BomDrilldownTable({ data }: { data: CdtDrilldown }) {
  const reduce = useReducedMotion();
  const rows = data.rows;

  const levelLabel: Record<BomRowLevel, string> = {
    org: data.levelNames.organization,
    facility: data.levelNames.facility,
    productLine: data.levelNames.productLine,
    equipment: data.levelNames.equipment,
    component: data.levelNames.component
  };

  // children index
  const childrenOf = React.useMemo(() => {
    const m = new Map<string | null, BomRow[]>();
    for (const r of rows) {
      const arr = m.get(r.parentId) ?? [];
      arr.push(r);
      m.set(r.parentId, arr);
    }
    return m;
  }, [rows]);

  const depthOf = React.useMemo(() => {
    const byId = new Map(rows.map((r) => [r.id, r]));
    const d = new Map<string, number>();
    const calc = (r: BomRow): number => {
      if (d.has(r.id)) return d.get(r.id)!;
      const depth = r.parentId && byId.has(r.parentId) ? calc(byId.get(r.parentId)!) + 1 : 0;
      d.set(r.id, depth);
      return depth;
    };
    rows.forEach(calc);
    return d;
  }, [rows]);

  // Start with the top two levels expanded so there is something to see.
  const [expanded, setExpanded] = React.useState<Set<string>>(() => {
    const s = new Set<string>();
    for (const r of rows) if (r.level === "org" || r.level === "facility") s.add(r.id);
    return s;
  });
  const [maxLevel, setMaxLevel] = React.useState<BomRowLevel>("component");
  const [sort, setSort] = React.useState<SortKey>(null);

  const maxLevelIdx = LEVEL_ORDER.indexOf(maxLevel);
  const toggle = (id: string) =>
    setExpanded((prev) => {
      const s = new Set(prev);
      if (s.has(id)) s.delete(id);
      else s.add(id);
      return s;
    });

  // Flatten the visible tree respecting expansion, the level filter, and sort.
  const visible = React.useMemo(() => {
    const out: BomRow[] = [];
    const walk = (parentId: string | null) => {
      let kids = childrenOf.get(parentId) ?? [];
      kids = kids.filter((k) => LEVEL_ORDER.indexOf(k.level) <= maxLevelIdx);
      if (sort) {
        kids = [...kids].sort((a, b) => (sort === "cvss" ? b.cvss - a.cvss : b.epss - a.epss));
      }
      for (const k of kids) {
        out.push(k);
        const hasKids = (childrenOf.get(k.id) ?? []).some(
          (c) => LEVEL_ORDER.indexOf(c.level) <= maxLevelIdx
        );
        if (hasKids && expanded.has(k.id)) walk(k.id);
      }
    };
    walk(null);
    return out;
  }, [childrenOf, expanded, maxLevelIdx, sort]);

  const SortBtn = ({ k, label }: { k: Exclude<SortKey, null>; label: string }) => (
    <button
      type="button"
      onClick={() => setSort((s) => (s === k ? null : k))}
      className={cn(
        "rounded px-1.5 py-0.5 text-[11px] font-semibold uppercase tracking-wide transition-colors",
        sort === k ? "bg-primary text-primary-foreground" : "text-muted-foreground hover:text-foreground"
      )}
      aria-pressed={sort === k}
    >
      {label} ↓
    </button>
  );

  return (
    <div className="rounded-[calc(var(--radius)+2px)] border border-border bg-card">
      {/* Controls */}
      <div className="flex flex-wrap items-center gap-x-4 gap-y-2 border-b border-border px-4 py-3">
        <div className="flex items-center gap-2 text-xs">
          <span className="text-muted-foreground">{data.deepestLabel}:</span>
          <select
            value={maxLevel}
            onChange={(e) => setMaxLevel(e.target.value as BomRowLevel)}
            className="rounded border border-border bg-background px-2 py-1 text-xs text-foreground"
            aria-label={data.deepestLabel}
          >
            {LEVEL_ORDER.map((l) => (
              <option key={l} value={l}>
                {levelLabel[l]}
              </option>
            ))}
          </select>
        </div>
        <div className="flex items-center gap-1.5">
          <span className="text-[11px] text-muted-foreground">{data.sortLabel}</span>
          <SortBtn k="cvss" label={data.sortOptions.cvss} />
          <SortBtn k="epss" label={data.sortOptions.epss} />
        </div>
      </div>

      {/* Header */}
      <div className="grid grid-cols-[minmax(0,1fr)_64px_44px_52px_56px] items-center gap-2 border-b border-border px-4 py-2 text-[10px] font-semibold uppercase tracking-wide text-muted-foreground sm:grid-cols-[minmax(0,1fr)_84px_64px_44px_52px_56px]">
        <span>{data.columns.component}</span>
        <span className="hidden sm:block">{data.columns.version}</span>
        <span className="text-center">{data.columns.kev}</span>
        <span className="text-center">{data.columns.epss}</span>
        <span className="text-center">{data.columns.cvss}</span>
        <span className="text-center">{data.priorityHeader}</span>
      </div>

      {/* Rows */}
      <div>
        <AnimatePresence initial={false}>
          {visible.map((r) => {
            const depth = depthOf.get(r.id) ?? 0;
            const hasKids = (childrenOf.get(r.id) ?? []).some(
              (c) => LEVEL_ORDER.indexOf(c.level) <= maxLevelIdx
            );
            const isOpen = expanded.has(r.id);
            return (
              <motion.div
                key={r.id}
                layout={!reduce}
                initial={reduce ? false : { opacity: 0, height: 0 }}
                animate={{ opacity: 1, height: "auto" }}
                exit={reduce ? undefined : { opacity: 0, height: 0 }}
                transition={{ duration: 0.22, ease: [0.22, 1, 0.36, 1] }}
                className="border-b border-border/60 last:border-b-0"
              >
                <div className="grid grid-cols-[minmax(0,1fr)_64px_44px_52px_56px] items-center gap-2 px-4 py-2.5 text-xs sm:grid-cols-[minmax(0,1fr)_84px_64px_44px_52px_56px]">
                  <div className="flex min-w-0 items-center gap-1" style={{ paddingLeft: depth * 16 }}>
                    {hasKids ? (
                      <button
                        type="button"
                        onClick={() => toggle(r.id)}
                        className="shrink-0 rounded p-0.5 text-muted-foreground hover:bg-muted hover:text-foreground"
                        aria-expanded={isOpen}
                        aria-label={isOpen ? data.collapseLabel : data.expandLabel}
                      >
                        <ChevronRight
                          className={cn("h-3.5 w-3.5 transition-transform", isOpen && "rotate-90")}
                          aria-hidden
                        />
                      </button>
                    ) : (
                      <span className="inline-block w-[18px] shrink-0" aria-hidden />
                    )}
                    <span className="min-w-0">
                      <span className="block truncate font-medium text-foreground">{r.label}</span>
                      <span className="block text-[10px] uppercase tracking-wide text-muted-foreground">
                        {levelLabel[r.level]}
                        {r.cve && r.cve !== "—" ? ` · ${r.cve}` : ""}
                      </span>
                    </span>
                  </div>

                  <span className="hidden truncate text-[11px] text-muted-foreground sm:block">
                    {r.version ?? "—"}
                  </span>

                  <span className="text-center">
                    {r.kev ? (
                      <span className="inline-block rounded bg-destructive px-1.5 py-0.5 text-[10px] font-bold text-destructive-foreground">
                        KEV
                      </span>
                    ) : (
                      <span className="text-muted-foreground/50">—</span>
                    )}
                  </span>

                  <span className={cn("mx-auto block w-fit rounded px-1.5 py-0.5 text-center text-[11px] tabular-nums", epssClass(r.epss))}>
                    {r.epss.toFixed(2)}
                  </span>
                  <span className={cn("mx-auto block w-fit rounded px-1.5 py-0.5 text-center text-[11px] tabular-nums", cvssClass(r.cvss))}>
                    {r.cvss.toFixed(1)}
                  </span>

                  <span className="text-center">
                    <span className={cn("inline-block rounded-full border px-1.5 py-0.5 text-[9px] font-bold tracking-wide", PRIORITY_PILL[r.priority])}>
                      {data.priorityLabels[r.priority]}
                    </span>
                  </span>
                </div>
                {r.consequence ? (
                  <p className="px-4 pb-2.5 text-[11px] leading-snug text-muted-foreground" style={{ paddingLeft: depth * 16 + 40 }}>
                    <span className="text-foreground/70">{data.columns.consequence}:</span> {r.consequence}
                  </p>
                ) : null}
              </motion.div>
            );
          })}
        </AnimatePresence>
      </div>
    </div>
  );
}
