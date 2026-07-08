# OXOT — Motion, Depth & Micro-interaction Review (July 2026)

Critical review of the *feel* of the site: micro-movements, shading/depth, and scroll
transitions between blocks. Goal is a restrained, expensive, "quietly high-end" experience
built on Tailwind + shadcn/ui + lucide + `motion/react`. Grounded in the current code, not
generic advice.

Constraints that bind every recommendation (project law): global stylesheet is the single
source of truth; dark + light both verified; every string bilingual (nl/en); `prefers-reduced-motion`
respected; surgical changes only.

---

## 1. What's already good (keep it)

The foundation is better than most. Real primitives already exist in `src/components/motion/fx.tsx`:

- **`Reveal`** — fade + 26px rise, `once`, `margin:"-70px"`, easing `[0.22,1,0.36,1]`, 0.65s. This is a tasteful curve (a soft "expo-out"). Good default.
- **`Stagger` / `Stagger.Item`** — 0.08s child stagger. Correct instinct.
- **`CountUp`** — 1.4s expo count, reduced-motion aware.
- **`SpotlightCard`** — cursor-follow radial glow + `whileHover:{y:-3}` on a `spring(300,24)`. This is the single best interaction on the site.
- **`article-shell.tsx`** — reading-progress bar + scroll-spy TOC. Genuinely premium touches.

`prefers-reduced-motion` is handled per-component via `useReducedMotion()`. Dark/light are tokenized.

**The problem is not the primitives — it's that they're applied unevenly, and the depth/easing/elevation layer underneath them was never tokenized.** Fixing that is what moves the site from "nicely animated" to "cohesively expensive."

---

## 2. The three gaps holding back the "high-end" feel

### Gap A — No elevation system (depth is ad hoc)

Today cards are almost all flat: `border border-border bg-card`. Where shadow appears it's a raw Tailwind `shadow` or `shadow-2xl` dropped in by hand (e.g. the carousel fullscreen frame). There are **no shadow tokens** in `globals.css` or `tailwind.config.ts`.

Consequences:
- Depth reads as inconsistent — some surfaces float, most are pasted flat onto the page.
- Dark mode gets no real elevation cue at all (drop shadows are nearly invisible on navy; elevation on dark surfaces must come from a lighter surface tint + a hairline top highlight + a soft ambient glow, not `box-shadow: black`).

This is the highest-leverage fix. A 3-step, theme-aware elevation scale makes every card, popover, dropdown, and the nav feel intentional.

### Gap B — No shared motion vocabulary (easing/duration are magic numbers)

Durations are scattered: 0.65s, 0.6s, 0.3s, 1.4s, spring(300,24), `duration-300`, `transition-colors`. Each was reasonable in isolation, but there's no scale, so nothing rhymes. High-end motion feels *authored* precisely because everything shares 2–3 easing curves and a 3-step duration ramp.

### Gap C — Inter-block scroll rhythm is inconsistent

`Reveal`/`Stagger` are used well inside article blocks, but section-to-section entrance is not uniform across the marketing pages (home, services, about, frameworks hub). The eye notices when block A rises in and block B just pops. A single `Section` reveal wrapper applied at each `<section>` boundary creates the calm, metronomic descent that reads as "designed."

---

## 3. Recommendations — prioritized

### P0 — Tokenize elevation + motion (the foundation)

Add to `globals.css` `:root` and `.dark`. These are tuned so dark-mode elevation comes from tint + highlight + ambient glow, not black drop shadow.

```css
:root {
  /* Elevation — warm, low-spread, layered. Light mode. */
  --elev-1: 0 1px 2px hsl(212 51% 11% / 0.04), 0 1px 1px hsl(212 51% 11% / 0.03);
  --elev-2: 0 4px 12px hsl(212 51% 11% / 0.06), 0 2px 4px hsl(212 51% 11% / 0.04);
  --elev-3: 0 12px 32px hsl(212 51% 11% / 0.10), 0 4px 10px hsl(212 51% 11% / 0.05);
  /* Motion scale */
  --ease-out: cubic-bezier(0.22, 1, 0.36, 1);   /* matches fx.tsx EASE */
  --ease-in-out: cubic-bezier(0.65, 0, 0.35, 1);
  --dur-1: 150ms;  --dur-2: 250ms;  --dur-3: 400ms;
}
.dark {
  /* On navy: inset top highlight + ambient depth, minimal black. */
  --elev-1: inset 0 1px 0 hsl(0 0% 100% / 0.04), 0 1px 2px hsl(0 0% 0% / 0.30);
  --elev-2: inset 0 1px 0 hsl(0 0% 100% / 0.05), 0 6px 16px hsl(0 0% 0% / 0.38);
  --elev-3: inset 0 1px 0 hsl(0 0% 100% / 0.06), 0 16px 40px hsl(0 0% 0% / 0.45);
}
```

Map them in `tailwind.config.ts`:

```ts
extend: {
  boxShadow: { 'e1': 'var(--elev-1)', 'e2': 'var(--elev-2)', 'e3': 'var(--elev-3)' },
  transitionTimingFunction: { 'brand': 'cubic-bezier(0.22,1,0.36,1)' },
}
```

Then depth becomes `shadow-e1/e2/e3` everywhere and behaves correctly in both themes. Rest position for content cards: `shadow-e1`; hover lift: `shadow-e2`; popovers/dropdowns/dialogs: `shadow-e3`.

### P0 — Global reduced-motion + smooth-scroll guard

Belt-and-suspenders in `globals.css` so nothing animates for users who opted out, regardless of component:

```css
html { scroll-behavior: smooth; }
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after { animation-duration: 0.01ms !important; animation-iteration-count: 1 !important; transition-duration: 0.01ms !important; scroll-behavior: auto !important; }
}
```

### P1 — A single `Section` reveal wrapper for block rhythm

One wrapper, applied at each marketing `<section>`, so every block enters identically. Reuses the existing `Reveal`:

```tsx
// fx.tsx — thin alias with the house defaults baked in
export function Section({ children, className, delay = 0 }: {children: React.ReactNode; className?: string; delay?: number}) {
  return <Reveal y={20} delay={delay} className={className}>{children}</Reveal>;
}
```

Wrap sections on home / services / about / frameworks. Headline + body + media can stagger by 60–90ms using `Stagger` for the "settling" cascade. Keep `y` small (16–24px) — large travel reads as cheap.

### P1 — Nav: scroll-aware elevation + animated link underline

`site-nav.tsx` is a static server component: `border-b`, links only `hover:text-primary` (instant, no transition), not sticky, no blur. Three cheap upgrades that read as expensive:

1. **Sticky + condense on scroll** — split a tiny `"use client"` shell that toggles a `scrolled` state past ~12px: at rest transparent with a hairline border; scrolled → `backdrop-blur-md bg-background/80 shadow-e1` and slightly reduced vertical padding. Transition on `--dur-2 ease-brand`.
2. **Animated underline on links** — replace the color-only hover with a growing underline:
   ```tsx
   className="relative py-1 text-foreground/80 transition-colors duration-150 hover:text-foreground
     after:absolute after:inset-x-0 after:-bottom-0.5 after:h-px after:origin-left after:scale-x-0
     after:bg-primary after:transition-transform after:duration-200 after:ease-brand hover:after:scale-x-100"
   ```
3. **Active route** — same underline held at `scale-x-100` for the current page (you already resolve locale/path in the switcher).

### P1 — Unify interactive states (buttons, cards, links)

Standardize the "press/lift" language so every interactive surface behaves the same:

- **Buttons**: add `active:scale-[0.98] transition-[transform,background-color,box-shadow] duration-150 ease-brand`, and on primary/secondary buttons `shadow-e1 hover:shadow-e2`. The tactile 2% press is the detail people feel but don't consciously notice.
- **Content cards**: standardize on `SpotlightCard` (or its lift) so hover is `-3px + shadow-e1→e2`. Right now only some cards lift; the framework/related cards use border-color hover only. Pick one and apply everywhere.
- **Icon-only controls** (lucide): `transition-colors` + a `hover:bg-accent` pill and `active:scale-95`. The carousel arrows/close already got the dark-glass treatment — extend that consistency to chat launcher, locale switcher, admin icons.

### P2 — Subtle shading & depth details (the "grain")

- **Hairline top highlight on dark cards** — `.dark .card { box-shadow: var(--elev-1) }` already gives the inset white top edge; make sure cards use `shadow-e1` not bare borders so the highlight shows. This single pixel of light is what makes dark UIs look crafted.
- **Sectional background modulation** — alternate sections between `bg-background` and a 2–3% tint (`bg-muted/30`) so blocks separate by shading, not just whitespace. Keep it barely perceptible.
- **Gradient hairlines** — replace some flat `border-t` dividers with a masked gradient rule (`bg-gradient-to-r from-transparent via-border to-transparent`) for section breaks. Subtle, editorial.
- **Hero media parallax** — a very small scroll-linked translate (`useScroll` + `useTransform`, max ~24px) on the hero carousel/figure gives depth without motion sickness. Reduced-motion off.

### P2 — Scroll-linked flourishes (use sparingly)

- **Sticky section eyebrows** — the orange `oxot-kicker` label can `position: sticky; top: 88px` within long article sections so the reader always knows where they are. Pairs with the existing scroll-spy TOC.
- **Progress-tied kicker** — you already have the reading-progress bar; consider a 1px orange accent that shares its scale so the two read as one system.
- **`framer` layout transitions** on the compare/tab blocks so the indicator slides (`layoutId`) rather than cutting.

---

## 4. What to explicitly NOT do

- No parallax beyond ~24px, no scroll-jacking, no full-section pinning. This is a compliance/OT-security consultancy — gravitas over spectacle.
- No `shadow-2xl` black drop shadows on dark mode (they muddy navy). Use the tokens.
- No new animation library. `motion/react` + `tailwindcss-animate` (already installed) cover everything above.
- Don't animate on every element — the luxury signal is *restraint*: one entrance per block, one hover language, 2–3 easing curves total.

---

## 5. Suggested rollout (surgical, verifiable)

1. **PR 1 — Tokens** (`globals.css` + `tailwind.config.ts`): elevation scale, motion scale, reduced-motion guard. Zero visual risk; verify both themes.
2. **PR 2 — Nav**: sticky/condense client shell + animated underline + active state. bilingual, verify dark/light/mobile.
3. **PR 3 — Interactive states**: button press/lift, card hover unification, icon controls.
4. **PR 4 — Section rhythm**: `Section` wrapper across home/services/about/frameworks; hero parallax.
5. **PR 5 — Shading details**: sectional tints, gradient hairlines, sticky eyebrows.

Each PR: screenshot dark + light, confirm `prefers-reduced-motion` disables it, confirm nl + en. Small diffs, easy to review, easy to revert.

---

### One-line summary
The motion *craft* is already here; what's missing is a **tokenized depth + easing foundation** and **consistent application**. Ship P0 (elevation + motion tokens + reduced-motion guard) first — it's low-risk and makes every subsequent polish land coherently.
