"use client";
import * as React from "react";
import { ChevronDown } from "lucide-react";
import { cn } from "@/lib/utils";

export interface FaqItem {
  question: string;
  answer: string;
}

/** Client-only accordion. First item open by default; no localStorage. */
export function Faq({ items }: { items: FaqItem[] }) {
  const [open, setOpen] = React.useState<number | null>(0);

  return (
    <div className="divide-y divide-border overflow-hidden rounded-[var(--radius)] border border-border bg-card">
      {items.map((it, i) => {
        const isOpen = open === i;
        const panelId = `faq-panel-${i}`;
        const buttonId = `faq-button-${i}`;
        return (
          <div key={i}>
            <h3 className="m-0">
              <button
                id={buttonId}
                type="button"
                onClick={() => setOpen(isOpen ? null : i)}
                aria-expanded={isOpen}
                aria-controls={panelId}
                className="flex w-full items-center justify-between gap-4 p-5 text-left"
              >
                <span className="text-sm font-medium text-foreground sm:text-base">{it.question}</span>
                <ChevronDown
                  className={cn(
                    "h-4 w-4 shrink-0 text-muted-foreground transition-transform",
                    isOpen && "rotate-180"
                  )}
                  aria-hidden
                />
              </button>
            </h3>
            {isOpen && (
              <div id={panelId} role="region" aria-labelledby={buttonId}>
                <p className="px-5 pb-5 text-sm leading-relaxed text-muted-foreground">{it.answer}</p>
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
}
