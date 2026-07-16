"use client";
import * as React from "react";
import { ArrowRight } from "lucide-react";
import { cn } from "@/lib/utils";
import type { CraHomeRoadsSplit } from "@/lib/cra-home";

// Road -> the business segment most likely to ask about that road, so a click
// preselects something sensible in the intake form's segment dropdown. Roads
// are conformity paths (A / B+C / H), not the 5 SEGMENTS themselves, so this
// is a best-fit mapping rather than a 1:1 contract.
const ROAD_SEGMENT: Record<string, string> = {
  a: "manufacturer",
  bc: "integrator",
  h: "oem"
};

function preselect(roadId: string) {
  const segment = ROAD_SEGMENT[roadId];
  if (!segment) return;
  window.dispatchEvent(new CustomEvent("oxot:intake-preselect", { detail: { segment } }));
}

export function RoadsSplit({ split }: { split: CraHomeRoadsSplit }) {
  const [hovered, setHovered] = React.useState<string | null>(null);

  return (
    <div>
      <div className="mb-4 inline-flex items-center gap-2 rounded-full bg-primary/10 px-3 py-1 text-xs font-semibold text-primary">
        {split.startBadge}
      </div>
      <div className="grid gap-5 sm:grid-cols-3">
        {split.roads.map((road) => (
          <button
            key={road.id}
            type="button"
            onClick={() => preselect(road.id)}
            onMouseEnter={() => setHovered(road.id)}
            onMouseLeave={() => setHovered((h) => (h === road.id ? null : h))}
            className={cn(
              "group flex h-full flex-col rounded-[var(--radius)] border border-border bg-card p-5 text-left transition-all duration-300",
              hovered === road.id && "-translate-y-2 border-primary/50 shadow-lg",
              hovered && hovered !== road.id && "opacity-60"
            )}
          >
            <span className="text-xs font-semibold uppercase tracking-wide text-primary">{road.segment}</span>
            <h3 className="mt-2 text-base font-semibold text-foreground">{road.title}</h3>
            <p className="mt-2 flex-1 text-sm leading-relaxed text-muted-foreground">{road.body}</p>
            <p className="mt-4 text-xs font-medium text-foreground">{road.ceMarkNote}</p>
            <span className="mt-4 inline-flex items-center gap-1 text-xs font-semibold text-primary opacity-0 transition-opacity group-hover:opacity-100">
              <ArrowRight className="h-3.5 w-3.5" aria-hidden />
            </span>
          </button>
        ))}
      </div>
      <div className="mt-6 rounded-[var(--radius)] border border-dashed border-border bg-muted/40 p-4 text-xs leading-relaxed text-muted-foreground">
        {split.wrongTurns}
      </div>
      <p className="mt-4 text-center text-sm text-muted-foreground">{split.footnote}</p>
    </div>
  );
}
