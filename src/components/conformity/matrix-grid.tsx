"use client";
import * as React from "react";
import { X } from "lucide-react";
import { cn } from "@/lib/utils";
import { Badge } from "@/components/ui/badge";
import type { MatrixCell, Requirement } from "@/lib/conformity";

interface Item {
  key: string;
  label: string;
}

export interface MatrixLabels {
  themeColumn: string;
  legend: string;
  detailTitle: string;
  refsLabel: string;
  connector: string;
  close: string;
  heatLess: string;
  heatMore: string;
}

/** Heat tint for a cell, adapting to the active theme via the primary token. */
function heatStyle(count: number, max: number): React.CSSProperties {
  if (count <= 0) return {};
  const alpha = 0.12 + 0.6 * (max > 0 ? count / max : 0);
  return { backgroundColor: `hsl(var(--primary) / ${alpha})` };
}

/**
 * Theme × regulation coverage matrix. Rows = themes, columns = regulations.
 * Filled cells are heat-tinted by how many requirements are mapped there.
 * Hovering a cell or a header highlights that whole row and column; clicking a
 * filled cell opens a side drawer listing the actual mapped requirements.
 * Sticky theme column + header row; scrolls horizontally on mobile. Fully
 * tokenized (dark/light).
 */
export function MatrixGrid({
  themes,
  regulations,
  cells,
  requirements,
  labels,
  obligationLabels
}: {
  themes: Item[];
  regulations: Item[];
  cells: MatrixCell[];
  requirements: Requirement[];
  labels: MatrixLabels;
  obligationLabels: Record<string, string>;
}) {
  const byKey = React.useMemo(() => {
    const m = new Map<string, MatrixCell>();
    for (const c of cells) m.set(`${c.themeKey}|${c.regulationKey}`, c);
    return m;
  }, [cells]);

  const maxCount = React.useMemo(
    () => Math.max(0, ...cells.map((c) => c.requirementCount)),
    [cells]
  );

  const [hovered, setHovered] = React.useState<{ row: string | null; col: string | null }>({
    row: null,
    col: null
  });
  const [selected, setSelected] = React.useState<{ themeKey: string; regulationKey: string } | null>(
    null
  );

  const selectedCell = selected ? byKey.get(`${selected.themeKey}|${selected.regulationKey}`) : null;
  const selectedTheme = selected ? themes.find((t) => t.key === selected.themeKey) : null;
  const selectedReg = selected ? regulations.find((r) => r.key === selected.regulationKey) : null;

  const selectedRequirements = React.useMemo(() => {
    if (!selected) return [];
    return requirements.filter(
      (r) => r.themeKey === selected.themeKey && r.regulationKey === selected.regulationKey
    );
  }, [requirements, selected]);

  const close = React.useCallback(() => setSelected(null), []);

  // Esc closes the drawer.
  React.useEffect(() => {
    if (!selected) return;
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") close();
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [selected, close]);

  return (
    <div className="space-y-5">
      {/* Legend */}
      <div className="flex flex-wrap items-center gap-x-4 gap-y-2">
        <p className="text-sm text-muted-foreground">{labels.legend}</p>
        <div className="flex items-center gap-2" aria-hidden>
          <span className="text-xs text-muted-foreground">{labels.heatLess}</span>
          <div className="flex overflow-hidden rounded-md border border-border">
            {[0.15, 0.3, 0.45, 0.6, 0.72].map((a) => (
              <span
                key={a}
                className="h-4 w-6"
                style={{ backgroundColor: `hsl(var(--primary) / ${a})` }}
              />
            ))}
          </div>
          <span className="text-xs text-muted-foreground">{labels.heatMore}</span>
        </div>
      </div>

      <div className="overflow-x-auto rounded-[var(--radius)] border border-border">
        <table
          className="w-full border-collapse text-sm"
          onMouseLeave={() => setHovered({ row: null, col: null })}
        >
          <thead>
            <tr>
              <th className="sticky left-0 top-0 z-20 min-w-[12rem] border-b border-r border-border bg-card px-3 py-2 text-left text-xs font-medium uppercase tracking-wide text-muted-foreground">
                {labels.themeColumn}
              </th>
              {regulations.map((r) => (
                <th
                  key={r.key}
                  onMouseEnter={() => setHovered({ row: null, col: r.key })}
                  className={cn(
                    "sticky top-0 z-10 border-b border-border px-3 py-2 text-center text-xs font-semibold text-foreground transition-colors",
                    hovered.col === r.key ? "bg-muted" : "bg-card"
                  )}
                >
                  {r.label}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {themes.map((th) => (
              <tr key={th.key} className="border-b border-border last:border-b-0">
                <th
                  scope="row"
                  onMouseEnter={() => setHovered({ row: th.key, col: null })}
                  className={cn(
                    "sticky left-0 z-10 min-w-[12rem] border-r border-border px-3 py-2 text-left font-medium text-foreground transition-colors",
                    hovered.row === th.key ? "bg-muted" : "bg-card"
                  )}
                >
                  {th.label}
                </th>
                {regulations.map((r) => {
                  const cell = byKey.get(`${th.key}|${r.key}`);
                  const count = cell?.requirementCount ?? 0;
                  const isSelected =
                    selected?.themeKey === th.key && selected?.regulationKey === r.key;
                  const inCross = hovered.row === th.key || hovered.col === r.key;

                  if (!count) {
                    return (
                      <td
                        key={r.key}
                        onMouseEnter={() => setHovered({ row: th.key, col: r.key })}
                        className={cn(
                          "border-l border-border/60 px-3 py-2 text-center text-muted-foreground/40 transition-colors",
                          inCross && "bg-muted/50"
                        )}
                      >
                        ·
                      </td>
                    );
                  }
                  return (
                    <td
                      key={r.key}
                      onMouseEnter={() => setHovered({ row: th.key, col: r.key })}
                      className="border-l border-border/60 p-1 text-center"
                    >
                      <button
                        type="button"
                        onClick={() => setSelected({ themeKey: th.key, regulationKey: r.key })}
                        aria-pressed={isSelected}
                        style={heatStyle(count, maxCount)}
                        className={cn(
                          "inline-flex h-8 w-full min-w-[2.5rem] items-center justify-center rounded-md text-sm font-semibold tabular-nums text-foreground transition-[box-shadow,transform]",
                          "hover:ring-2 hover:ring-primary/50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring",
                          (inCross || isSelected) && "ring-2 ring-primary/60",
                          isSelected && "ring-primary"
                        )}
                      >
                        {count}
                      </button>
                    </td>
                  );
                })}
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Drawer */}
      {selected && selectedTheme && selectedReg && (
        <div className="fixed inset-0 z-50" role="dialog" aria-modal="true">
          <div
            className="absolute inset-0 bg-foreground/40 backdrop-blur-sm"
            onClick={close}
            aria-hidden
          />
          <div className="absolute inset-y-0 right-0 flex w-full max-w-md flex-col overflow-y-auto border-l border-border bg-card shadow-xl">
            <div className="flex items-start justify-between gap-4 border-b border-border p-5">
              <div>
                <h3 className="font-semibold text-foreground">
                  {selectedTheme.label} {labels.connector} {selectedReg.label}
                </h3>
                <p className="mt-1 text-xs font-medium uppercase tracking-wide text-muted-foreground">
                  {labels.detailTitle}
                </p>
              </div>
              <button
                type="button"
                onClick={close}
                aria-label={labels.close}
                className="inline-flex h-8 w-8 shrink-0 items-center justify-center rounded-md text-muted-foreground transition-colors hover:bg-muted hover:text-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
              >
                <X className="h-4 w-4" />
              </button>
            </div>
            <div className="p-5">
              {selectedRequirements.length > 0 ? (
                <ul className="space-y-3">
                  {selectedRequirements.map((req) => (
                    <li
                      key={req.id}
                      className="rounded-[var(--radius)] border border-border bg-background p-3"
                    >
                      <div className="flex flex-wrap items-center gap-2">
                        <span className="font-mono text-xs text-muted-foreground">{req.refCode}</span>
                        <Badge variant="secondary">
                          {obligationLabels[req.obligationType] ?? req.obligationType}
                        </Badge>
                      </div>
                      <p className="mt-1.5 text-sm font-medium text-foreground">{req.title}</p>
                    </li>
                  ))}
                </ul>
              ) : (
                <div>
                  <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
                    {labels.refsLabel}
                  </p>
                  <ul className="mt-2 flex flex-wrap gap-2">
                    {(selectedCell?.requirementRefs ?? []).map((ref) => (
                      <li
                        key={ref}
                        className="rounded-md border border-border bg-background px-2 py-1 font-mono text-xs text-foreground"
                      >
                        {ref}
                      </li>
                    ))}
                  </ul>
                </div>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
