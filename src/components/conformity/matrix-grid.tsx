"use client";
import * as React from "react";
import { cn } from "@/lib/utils";
import { Badge } from "@/components/ui/badge";
import type { MatrixCell } from "@/lib/conformity";

interface Item {
  key: string;
  label: string;
}

export interface MatrixLabels {
  themeColumn: string;
  legend: string;
  empty: string;
  detailTitle: string;
  refsLabel: string;
}

/**
 * Theme × regulation coverage matrix. Rows = themes, columns = regulations.
 * A filled cell is selectable and reveals its mapped requirement references in a
 * detail panel below. Sticky theme column + header row; scrolls horizontally on
 * mobile. Fully tokenized (dark/light).
 */
export function MatrixGrid({
  themes,
  regulations,
  cells,
  labels
}: {
  themes: Item[];
  regulations: Item[];
  cells: MatrixCell[];
  labels: MatrixLabels;
}) {
  const byKey = React.useMemo(() => {
    const m = new Map<string, MatrixCell>();
    for (const c of cells) m.set(`${c.themeKey}|${c.regulationKey}`, c);
    return m;
  }, [cells]);

  const [selected, setSelected] = React.useState<{ themeKey: string; regulationKey: string } | null>(
    null
  );

  const selectedCell = selected ? byKey.get(`${selected.themeKey}|${selected.regulationKey}`) : null;
  const selectedTheme = selected ? themes.find((t) => t.key === selected.themeKey) : null;
  const selectedReg = selected ? regulations.find((r) => r.key === selected.regulationKey) : null;

  return (
    <div className="space-y-5">
      <p className="text-sm text-muted-foreground">{labels.legend}</p>

      <div className="overflow-x-auto rounded-[var(--radius)] border border-border">
        <table className="w-full border-collapse text-sm">
          <thead>
            <tr>
              <th className="sticky left-0 top-0 z-20 min-w-[12rem] border-b border-r border-border bg-card px-3 py-2 text-left text-xs font-medium uppercase tracking-wide text-muted-foreground">
                {labels.themeColumn}
              </th>
              {regulations.map((r) => (
                <th
                  key={r.key}
                  className="sticky top-0 z-10 border-b border-border bg-card px-3 py-2 text-center text-xs font-semibold text-foreground"
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
                  className="sticky left-0 z-10 min-w-[12rem] border-r border-border bg-card px-3 py-2 text-left font-medium text-foreground"
                >
                  {th.label}
                </th>
                {regulations.map((r) => {
                  const cell = byKey.get(`${th.key}|${r.key}`);
                  const count = cell?.requirementCount ?? 0;
                  const isSelected =
                    selected?.themeKey === th.key && selected?.regulationKey === r.key;
                  if (!count) {
                    return (
                      <td
                        key={r.key}
                        className="border-l border-border/60 px-3 py-2 text-center text-muted-foreground/40"
                      >
                        ·
                      </td>
                    );
                  }
                  return (
                    <td key={r.key} className="border-l border-border/60 p-1 text-center">
                      <button
                        type="button"
                        onClick={() => setSelected({ themeKey: th.key, regulationKey: r.key })}
                        aria-pressed={isSelected}
                        className={cn(
                          "inline-flex h-8 w-full min-w-[2.5rem] items-center justify-center rounded-md text-sm font-semibold tabular-nums transition-colors",
                          isSelected
                            ? "bg-primary text-primary-foreground"
                            : "bg-primary/10 text-primary hover:bg-primary/20"
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

      {/* Detail panel */}
      <div className="rounded-[var(--radius)] border border-border bg-card p-5">
        {selectedCell && selectedTheme && selectedReg ? (
          <div>
            <div className="flex flex-wrap items-center gap-2">
              <h3 className="font-semibold text-foreground">{labels.detailTitle}</h3>
              <Badge variant="secondary">{selectedReg.label}</Badge>
              <span className="text-sm text-muted-foreground">· {selectedTheme.label}</span>
            </div>
            <p className="mt-3 text-xs font-medium uppercase tracking-wide text-muted-foreground">
              {labels.refsLabel}
            </p>
            <ul className="mt-2 flex flex-wrap gap-2">
              {selectedCell.requirementRefs.map((ref) => (
                <li
                  key={ref}
                  className="rounded-md border border-border bg-background px-2 py-1 font-mono text-xs text-foreground"
                >
                  {ref}
                </li>
              ))}
            </ul>
          </div>
        ) : (
          <p className="text-sm text-muted-foreground">{labels.empty}</p>
        )}
      </div>
    </div>
  );
}
