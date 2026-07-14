"use client";
import * as React from "react";
import { cn } from "@/lib/utils";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import type { Requirement } from "@/lib/conformity";

interface Option {
  value: string;
  label: string;
}

export interface RequirementsExplorerLabels {
  regulation: string;
  theme: string;
  obligation: string;
  allRegulations: string;
  allThemes: string;
  allObligations: string;
  search: string;
  searchPlaceholder: string;
  of: string;
  countSuffix: string;
  empty: string;
  table: {
    regulation: string;
    ref: string;
    requirement: string;
    theme: string;
    obligation: string;
    mappings: string;
  };
  obligationTypes: Record<string, string>;
}

/**
 * Client-side filter/search over the requirement corpus. Filters (regulation,
 * theme, obligation type) + free-text search are combined with useMemo. Fully
 * tokenized for dark/light. All chrome strings come from the dictionary.
 */
export function RequirementsExplorer({
  requirements,
  regulations,
  themes,
  obligationTypeKeys,
  labels
}: {
  requirements: Requirement[];
  regulations: Option[];
  themes: Option[];
  obligationTypeKeys: string[];
  labels: RequirementsExplorerLabels;
}) {
  const [regulation, setRegulation] = React.useState("");
  const [theme, setTheme] = React.useState("");
  const [obligation, setObligation] = React.useState("");
  const [query, setQuery] = React.useState("");

  const filtered = React.useMemo(() => {
    const q = query.trim().toLowerCase();
    return requirements.filter((r) => {
      if (regulation && r.regulationKey !== regulation) return false;
      if (theme && r.themeKey !== theme) return false;
      if (obligation && r.obligationType !== obligation) return false;
      if (q) {
        const hay = `${r.title} ${r.description ?? ""} ${r.refCode}`.toLowerCase();
        if (!hay.includes(q)) return false;
      }
      return true;
    });
  }, [requirements, regulation, theme, obligation, query]);

  const obligationLabel = (key: string) => labels.obligationTypes[key] ?? key;

  const selectClass =
    "h-9 w-full rounded-lg border border-input bg-background px-3 text-sm text-foreground shadow-sm transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring";

  return (
    <div className="space-y-5">
      {/* Filters */}
      <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
        <label className="block text-sm">
          <span className="mb-1 block font-medium text-foreground">{labels.regulation}</span>
          <select
            className={selectClass}
            value={regulation}
            onChange={(e) => setRegulation(e.target.value)}
          >
            <option value="">{labels.allRegulations}</option>
            {regulations.map((o) => (
              <option key={o.value} value={o.value}>
                {o.label}
              </option>
            ))}
          </select>
        </label>

        <label className="block text-sm">
          <span className="mb-1 block font-medium text-foreground">{labels.theme}</span>
          <select className={selectClass} value={theme} onChange={(e) => setTheme(e.target.value)}>
            <option value="">{labels.allThemes}</option>
            {themes.map((o) => (
              <option key={o.value} value={o.value}>
                {o.label}
              </option>
            ))}
          </select>
        </label>

        <label className="block text-sm">
          <span className="mb-1 block font-medium text-foreground">{labels.obligation}</span>
          <select
            className={selectClass}
            value={obligation}
            onChange={(e) => setObligation(e.target.value)}
          >
            <option value="">{labels.allObligations}</option>
            {obligationTypeKeys.map((k) => (
              <option key={k} value={k}>
                {obligationLabel(k)}
              </option>
            ))}
          </select>
        </label>

        <label className="block text-sm">
          <span className="mb-1 block font-medium text-foreground">{labels.search}</span>
          <Input
            type="search"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder={labels.searchPlaceholder}
          />
        </label>
      </div>

      {/* Count */}
      <p className="text-sm text-muted-foreground" aria-live="polite">
        <span className="font-semibold text-foreground">{filtered.length}</span> {labels.of}{" "}
        {requirements.length} {labels.countSuffix}
      </p>

      {/* Results */}
      {filtered.length === 0 ? (
        <div className="rounded-[var(--radius)] border border-dashed border-border p-8 text-center text-sm text-muted-foreground">
          {labels.empty}
        </div>
      ) : (
        <>
          {/* Table (md+) */}
          <div className="hidden overflow-x-auto rounded-[var(--radius)] border border-border md:block">
            <table className="w-full text-sm">
              <thead className="bg-muted/50 text-left text-xs uppercase tracking-wide text-muted-foreground">
                <tr>
                  <th className="px-3 py-2 font-medium">{labels.table.regulation}</th>
                  <th className="px-3 py-2 font-medium">{labels.table.ref}</th>
                  <th className="px-3 py-2 font-medium">{labels.table.requirement}</th>
                  <th className="px-3 py-2 font-medium">{labels.table.theme}</th>
                  <th className="px-3 py-2 font-medium">{labels.table.obligation}</th>
                  <th className="px-3 py-2 text-right font-medium">{labels.table.mappings}</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {filtered.map((r) => (
                  <tr key={r.id} className="align-top hover:bg-accent/30">
                    <td className="px-3 py-3">
                      <Badge variant="secondary">{r.regulationShortName}</Badge>
                    </td>
                    <td className="px-3 py-3 font-mono text-xs text-muted-foreground">
                      {r.refCode}
                    </td>
                    <td className="px-3 py-3">
                      <div className="font-medium text-foreground">{r.title}</div>
                      {r.description && (
                        <div className="mt-0.5 max-w-md text-xs leading-relaxed text-muted-foreground">
                          {r.description}
                        </div>
                      )}
                    </td>
                    <td className="px-3 py-3 text-muted-foreground">{r.themeName ?? "—"}</td>
                    <td className="px-3 py-3">
                      <Badge variant="outline">{obligationLabel(r.obligationType)}</Badge>
                    </td>
                    <td className="px-3 py-3 text-right tabular-nums text-muted-foreground">
                      {r.mappingCount}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {/* Card list (mobile) */}
          <ul className="space-y-3 md:hidden">
            {filtered.map((r) => (
              <li
                key={r.id}
                className="rounded-[var(--radius)] border border-border bg-card p-4"
              >
                <div className="flex flex-wrap items-center gap-2">
                  <Badge variant="secondary">{r.regulationShortName}</Badge>
                  <span className="font-mono text-xs text-muted-foreground">{r.refCode}</span>
                </div>
                <div className="mt-2 font-medium text-foreground">{r.title}</div>
                {r.description && (
                  <p className="mt-1 text-xs leading-relaxed text-muted-foreground">
                    {r.description}
                  </p>
                )}
                <div className="mt-3 flex flex-wrap items-center gap-2 text-xs text-muted-foreground">
                  {r.themeName && <span>{r.themeName}</span>}
                  <Badge variant="outline">{obligationLabel(r.obligationType)}</Badge>
                  <span className={cn("tabular-nums")}>
                    {r.mappingCount} {labels.table.mappings}
                  </span>
                </div>
              </li>
            ))}
          </ul>
        </>
      )}
    </div>
  );
}
