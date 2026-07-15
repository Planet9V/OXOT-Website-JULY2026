"use client";
import * as React from "react";
import { Button } from "@/components/ui/button";
import { Info, BookOpen, X } from "lucide-react";

// Lightweight, dependency-free setup guidance for admin panels. No Radix
// tooltip/portal is wired up anywhere else in this app (the ui/tooltip.tsx
// Radix wrapper is unused and would need a <TooltipProvider> added to the
// admin layout) — these components use plain hover/focus + toggled <div>s so
// they can be dropped into any card without touching app-wide providers.

/**
 * Small inline "info" affordance. Shows `text` on hover or keyboard focus.
 * Uses a native `title` attribute plus a custom popover so it also works
 * for touch (tap to toggle) and is reachable by keyboard (Tab + Enter/Space,
 * Esc to close).
 */
export function HelpTip({ text }: { text: string }) {
  const [open, setOpen] = React.useState(false);
  const ref = React.useRef<HTMLSpanElement>(null);

  React.useEffect(() => {
    if (!open) return;
    function onKeyDown(e: KeyboardEvent) {
      if (e.key === "Escape") setOpen(false);
    }
    function onClickAway(e: MouseEvent) {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false);
    }
    document.addEventListener("keydown", onKeyDown);
    document.addEventListener("mousedown", onClickAway);
    return () => {
      document.removeEventListener("keydown", onKeyDown);
      document.removeEventListener("mousedown", onClickAway);
    };
  }, [open]);

  return (
    <span ref={ref} className="relative inline-flex">
      <button
        type="button"
        title={text}
        aria-label={text}
        aria-expanded={open}
        onClick={() => setOpen((v) => !v)}
        onFocus={() => setOpen(true)}
        onBlur={() => setOpen(false)}
        onMouseEnter={() => setOpen(true)}
        onMouseLeave={() => setOpen(false)}
        className="inline-flex h-4 w-4 shrink-0 items-center justify-center rounded-full text-muted-foreground/70 hover:text-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
      >
        <Info className="h-3.5 w-3.5" />
      </button>
      {open && (
        <span
          role="tooltip"
          className="absolute bottom-full left-1/2 z-50 mb-1.5 w-56 -translate-x-1/2 rounded-md border border-border bg-foreground px-2.5 py-1.5 text-xs text-background shadow-md"
        >
          {text}
        </span>
      )}
    </span>
  );
}

/**
 * Toggleable "Setup guide" button + dismissible numbered-steps panel.
 * Renders inline (not a portal) so it can sit inside any card header.
 */
export function SetupGuide({ title, steps }: { title: string; steps: React.ReactNode[] }) {
  const [open, setOpen] = React.useState(false);
  const containerRef = React.useRef<HTMLDivElement>(null);

  React.useEffect(() => {
    if (!open) return;
    function onKeyDown(e: KeyboardEvent) {
      if (e.key === "Escape") setOpen(false);
    }
    document.addEventListener("keydown", onKeyDown);
    return () => document.removeEventListener("keydown", onKeyDown);
  }, [open]);

  return (
    <div ref={containerRef} className="relative inline-block">
      <Button
        type="button"
        variant="outline"
        size="sm"
        aria-expanded={open}
        onClick={() => setOpen((v) => !v)}
      >
        <BookOpen className="h-3.5 w-3.5" /> Setup guide
      </Button>
      {open && (
        <div className="absolute left-0 top-full z-50 mt-2 w-80 max-w-[90vw] rounded-xl border border-border bg-card p-4 text-left shadow-e2 sm:w-96">
          <div className="mb-2 flex items-center justify-between gap-2">
            <h4 className="text-sm font-semibold">{title}</h4>
            <button
              type="button"
              aria-label="Close setup guide"
              onClick={() => setOpen(false)}
              className="rounded-md p-1 text-muted-foreground hover:bg-accent hover:text-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
            >
              <X className="h-4 w-4" />
            </button>
          </div>
          <ol className="list-decimal space-y-2 pl-4 text-xs text-muted-foreground marker:font-semibold marker:text-foreground">
            {steps.map((step, i) => (
              <li key={i} className="leading-relaxed">{step}</li>
            ))}
          </ol>
        </div>
      )}
    </div>
  );
}
