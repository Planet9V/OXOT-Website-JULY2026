"use client";
import type { PersonaCard as PersonaCardData } from "@/lib/cra-home";

/** Clickable persona teaser: preselects this segment in the intake form and
 *  scrolls to it (src/components/cra-home/intake-form.tsx listens for
 *  "oxot:intake-preselect"). */
export function PersonaCard({ card }: { card: PersonaCardData }) {
  function onClick() {
    window.dispatchEvent(
      new CustomEvent("oxot:intake-preselect", { detail: { segment: card.segment } })
    );
  }
  return (
    <button
      type="button"
      onClick={onClick}
      className="flex h-full w-full flex-col rounded-[var(--radius)] border border-border bg-card p-5 text-left transition-transform duration-200 hover:-translate-y-1 hover:border-primary/50 hover:shadow-md"
    >
      <h3 className="text-sm font-semibold text-foreground" style={{ fontFamily: "var(--font-display)" }}>
        {card.title}
      </h3>
      <p className="mt-2 flex-1 text-xs leading-relaxed text-muted-foreground">&ldquo;{card.quote}&rdquo;</p>
      <span className="mt-3 block rounded bg-primary/5 px-2 py-1.5 text-[10px] font-bold leading-snug tracking-wide text-primary">
        BUYS → {card.buys}
      </span>
      <span className="mt-3 text-[11px] font-bold uppercase tracking-wide text-primary">{card.cta} →</span>
    </button>
  );
}
