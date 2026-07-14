"use client";
import * as React from "react";
import { cn } from "@/lib/utils";
import { Badge } from "@/components/ui/badge";
import type { Locale } from "@/i18n/config";
import type { TimelineEvent } from "@/lib/conformity";

export interface TimelineLabels {
  inForce: string;
  upcoming: string;
  today: string;
}

/**
 * Vertical implementation timeline. Each event is marked in-force (date on or
 * before today, filled dot) or upcoming (date after today, outlined dot). A
 * clearly styled "Today" marker is inserted at the correct chronological
 * position. Ordered-list semantics; date formatting is locale-aware. Client
 * component: it reads today's date at render time.
 */
export function Timeline({
  events,
  regShortNames,
  today,
  locale,
  labels
}: {
  events: TimelineEvent[];
  regShortNames: Record<string, string>;
  today: string;
  locale: Locale;
  labels: TimelineLabels;
}) {
  const todayMs = new Date(today).getTime();

  const dateFmt = React.useCallback(
    (d: string) =>
      new Date(d).toLocaleDateString(locale === "nl" ? "nl-NL" : "en-GB", {
        year: "numeric",
        month: "short",
        day: "numeric"
      }),
    [locale]
  );

  // Events arrive sorted ascending by date. Find where "today" belongs.
  const insertAt = events.findIndex((e) => new Date(e.date).getTime() > todayMs);
  const todayIndex = insertAt === -1 ? events.length : insertAt;

  return (
    <ol className="mt-5 space-y-4 border-l border-border pl-6">
      {events.map((e, i) => {
        const rows: React.ReactNode[] = [];
        if (i === todayIndex) {
          rows.push(<TodayMarker key="today" label={labels.today} date={dateFmt(today)} />);
        }
        const inForce = new Date(e.date).getTime() <= todayMs;
        rows.push(
          <li key={`${e.date}-${i}`} className="relative">
            <span
              className={cn(
                "absolute -left-[27px] top-1.5 h-2.5 w-2.5 rounded-full border-2 border-primary",
                inForce ? "bg-primary" : "bg-background"
              )}
            />
            <div className="flex flex-wrap items-center gap-x-3 gap-y-1">
              <time
                className={cn(
                  "text-sm font-semibold tabular-nums",
                  inForce ? "text-foreground" : "text-muted-foreground"
                )}
              >
                {dateFmt(e.date)}
              </time>
              <Badge variant={inForce ? "secondary" : "outline"}>
                {inForce ? labels.inForce : labels.upcoming}
              </Badge>
              {e.regulationKey && regShortNames[e.regulationKey] && (
                <Badge variant="secondary">{regShortNames[e.regulationKey]}</Badge>
              )}
            </div>
            <p
              className={cn(
                "mt-1 text-sm",
                inForce ? "text-muted-foreground" : "text-muted-foreground/80"
              )}
            >
              {e.label}
            </p>
          </li>
        );
        return rows;
      })}
      {todayIndex === events.length && (
        <TodayMarker label={labels.today} date={dateFmt(today)} />
      )}
    </ol>
  );
}

function TodayMarker({ label, date }: { label: string; date: string }) {
  return (
    <li className="relative">
      <span className="absolute -left-[30px] top-1 h-3.5 w-3.5 rounded-full border-2 border-primary bg-primary ring-4 ring-primary/20" />
      <div className="flex flex-wrap items-center gap-x-2">
        <span className="text-sm font-bold uppercase tracking-wide text-primary">{label}</span>
        <time className="text-sm font-semibold tabular-nums text-primary">— {date}</time>
      </div>
    </li>
  );
}
