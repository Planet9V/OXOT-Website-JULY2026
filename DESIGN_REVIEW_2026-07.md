# OXOT Website — Expert Design, Content & Engagement Review

**Date:** 7 July 2026 · **Reviewers:** synthesized from three expert personas (Principal Interaction Designer · Staff Front-End Engineer, React/shadcn/data-viz · Editorial Director / B2B conversion), each grounded in the actual source files (`article-shell.tsx`, `markdown.tsx`, `motion/fx.tsx`, `globals.css`, the 8 content `.md` files) and a live check of the running site.

Scale: **7 = solid & professional**, **8 = genuinely engaging / best-in-class-adjacent**, **9–10 = award-tier.** Honest ratings — dense static text-walls score low on engagement even when the writing is excellent.

---

## The one finding that explains every score

The **homepage is an 8** — custom animated risk-map, `CountUp` stats, spotlight cards, marquee, staggered reveals. It proves the team can build modern, interactive UI.

Every **content page is a 5–7** — and for one structural reason. All 8 content pages render through a single template: `ArticleShell` (a genuinely good animated hero + sticky scroll-spy TOC) wrapping `MarkdownContent`. But `MarkdownContent` emits **100% static HTML**: plain GFM tables (no sort/sticky/hover), hand-drawn static SVG "charts", and `keyfacts`/`timeline`/`compare` blocks with no motion. The excellent motion primitives in `fx.tsx` — `Reveal`, `Stagger`, `CountUp` — are imported **only by the homepage**. `recharts` is installed but used **only in the admin** — never on a public page. shadcn `Tabs`/`Tooltip` exist but are never used in an article body.

**So the content is 8–9, the writing is 8–9, but engagement and component sophistication sit at 3–6 — and they drag every page down.**

The upside: because all 8 pages share **two files** (`markdown.tsx` + `article-shell.tsx`) and reuse primitives that **already exist**, roughly 80% of the lift needed to move all eight pages to 8/10 is edits to those two files — near-zero new invention.

---

## The ratings — 9 distinct page designs (= all 16 localized EN + NL URLs)

> The 8 content pages each ship in English **and** Dutch on the *same* template, so their design/layout/engagement/component scores are identical per locale (I verified EN↔NL content parity while writing them). The 16 URLs = 8 content pages × 2 locales; the homepage also ships EN + NL. Ratings below are per distinct design.

| # | Page | Content | Layout | Engagement | Style | Adv. Components | **Overall** | Biggest gap holding it back |
|---|------|:---:|:---:|:---:|:---:|:---:|:---:|---|
| 1 | **Home** | 7 | 8 | 8 | 8 | 8 | **8** | Only truly modern page. Ceiling: hero viz is decorative not data-bound; hard cut into services. |
| 2 | **CRA** | 9 | 7 | 5 | 7 | 5 | **6** | Densest page (≈10k words, 28 H2s) rendered as one static scroll. Richest data on the site, zero interactive viz. |
| 3 | **IEC 62443** | 9 | 7 | 5 | 7 | 5 | **6** | 100+ table-rows of static SL/FR matrices; the 3 zone-and-conduit SVGs (the one visual idea) don't move. |
| 4 | **NIS2** | 8 | 8 | 6 | 7 | 5 | **7** | Best block mix (timeline + compare + keyfacts) but all static; the 24h/72h clock and penalty %s just sit there. |
| 5 | **AI Act** | 9 | 7 | 5 | 7 | 5 | **6** | 2nd-densest; the "Is my AI high-risk?" decision-tree is static art — the site's best interactive candidate, unused. |
| 6 | **Machinery Reg.** | 9 | 8 | 6 | 7 | 4 | **6** | Great "corruptible = not compliant" hook buried; the 20 Jan 2027 date wants a live countdown. |
| 7 | **TS 50701** | 8 | 8 | 6 | 7 | 4 | **6** | Worst table-UX-to-data ratio: ~10 dense static tables, thin use of its own block vocabulary. |
| 8 | **Frameworks (hub)** | 7 | 6 | 6 | 6 | 3 | **5** | The site's *router page* is a plain prose + link list. Its whole job is relational and it has no visual, no selector. |
| 9 | **Cyber Digital Twin** (*Fooled by Randomness*) | 9 | 6 | 5 | 7 | 4 | **6** | Category-leading essay, but a pure text-wall: 14 H2, **zero** visual blocks; its Monte-Carlo numbers are described, never shown. |

**Column read:** Content is consistently 8–9 (authoritative, well-cited, genuinely differentiated). Style is 6–8 (good tokens, drop caps, numbered H2s). **Engagement (5–6) and Advanced Components (3–5) are the two levers holding the set below 8** — not the writing.

---

## How each page gets to 8/10

Most fixes are shared (they live in the template/renderer and lift all pages at once). Page-specific fixes are called out.

**Shared — do these once, all 8 content pages benefit:**
1. Wrap article body sections in the existing `Reveal` / `Stagger` (scroll-in pacing). → +2 engagement everywhere.
2. `CountUp` the `keyfacts` values (the numbers *are* the hook: 24h, €35M/7%, ≥5yr). `CountUp` already exists. → +1 engagement, +2 motion.
3. Sortable + sticky-header + row-hover tables via `@tanstack/react-table` in the GFM renderer. → fixes the single worst issue on IEC/TS 50701/CRA at once.
4. Scroll-draw the static SVG diagrams (the homepage `RiskMap` already shows the exact path-draw pattern). → +2 motion on IEC/TS 50701/NIS2/CRA.
5. Sticky reading-progress bar + collapsible reference sections (shadcn `Tabs`/accordion) for the 3 densest pages (CRA, AI Act, IEC). → +2 engagement on the walls.
6. Mid-page CTAs. Today nearly every page saves its only CTA for the final paragraph, so a reader who bails at the penalties table (the emotional peak) converts on nothing. Add a CTA after each page's peak-anxiety moment.

**Page-specific:**
- **CRA →** collapse the two near-duplicate IEC-62443-mapping sections; add a 5-line "If you only read one thing" box; penalty tables → grouped bar chart (recharts).
- **IEC 62443 →** SL-2-vs-SL-3 "what SL-3 adds" tables → a `Tabs` SL-selector driving the FR list; animate the zone/conduit SVGs.
- **NIS2 →** turn "essential vs important" `compare` into a segmented toggle; animate the reporting timeline; add an inline "Am I in scope?" scoped check.
- **AI Act →** promote the 400-tonne-press worked example near the top; lead with "most industrial AI is *not* high-risk"; build the interactive high-risk classifier from the existing decision-tree.
- **Machinery →** live countdown to 20 Jan 2027 + progress bar; conformity-route table → small decision widget.
- **TS 50701 →** all mapping tables → `@tanstack/react-table`; add animated stat cards.
- **Frameworks →** rebuild as a `SpotlightCard` grid + a one-question role selector ("operator / manufacturer / machine builder / rail →") that renders the personalized framework subset + an interconnect diagram. This page has the most to gain (5 → 8).
- **Cyber Digital Twin →** scroll-reveal per section; turn the 73%/31%/8.4% distribution into a real recharts probability chart; pull-quote the Taleb "10,000 → 300 survivors" as an animated stat.

---

## Build backlog — prioritized, implementable in this exact stack

Already installed: `motion`, `recharts`, `lucide-react`, `class-variance-authority`, `tailwind-merge`, shadcn `tabs`/`tooltip`/`card`/etc. New libs flagged explicitly.

| # | Upgrade | Library | Where | Effort | Lifts |
|---|---------|---------|-------|:---:|---|
| 1 | `CountUp` animated stat cards for `keyfacts` | **already installed** (`fx.tsx`) | `markdown.tsx` keyfacts branch | **S** | every regulation page |
| 2 | Reveal/Stagger on body sections | **already installed** | thin client wrapper in `markdown.tsx` | **S–M** | all 8 pages |
| 3 | Sticky reading-progress bar | `motion useScroll` (installed) | `article-shell.tsx` | **S** | all pages, esp. mobile |
| 4 | Sortable/sticky/hover data tables | **NEW: `@tanstack/react-table`** (~14kb, headless) | GFM table renderer in `markdown.tsx` | **M** | IEC, TS 50701, CRA, Machinery |
| 5 | Real charts for quantitative tables | `recharts` (installed, promote from admin) | new `` ```chart `` block | **M** | CRA/NIS2/AI-Act penalties, CDT distribution |
| 6 | `compare` blocks → segmented `Tabs` | shadcn `Tabs` (installed, unused in body) | `markdown.tsx` compare branch | **S** | NIS2, AI Act |
| 7 | FAQ sections → accordion | **NEW: `@radix-ui/react-accordion`** | `markdown.tsx` FAQ parser | **M** | NIS2, AI Act, IEC, Machinery |
| 8 | Scroll-draw static SVG diagrams | `motion` (installed) | `markdown.tsx` svg branch | **M** | IEC, TS 50701, NIS2, CRA |
| 9 | Interactive "Is my AI high-risk?" classifier | `motion` + shadcn (installed) | new client component on AI Act | **L** | AI Act (signature interactive piece) |
| 10 | Hover-card citation previews | **NEW: `@radix-ui/react-hover-card`** | inline-link renderer | **M** | all pages (trust signal) |

**Optional / lower ROI:** `embla-carousel-react` (replace the hand-rolled carousel with swipe/drag/keyboard), `react-wrap-balancer` (heading balancing). And fix the perpetual `Aurora` animation so pages can reach `document_idle` (pause when off-screen / respect `prefers-reduced-motion` harder) — it currently blocks idle callbacks.

---

## Interactive content — turn authority into engagement + leads

These reuse content already written as static prose/SVG, and hit the two weak levers (scannability, mid-funnel conversion) directly.

1. **"Am I in scope for NIS2?"** decision tool (sector → size → exceptions → Essential/Important + fine ceiling + supervision model). *NIS2 + Frameworks.* **Med.** — highest lead-gen value.
2. **"Which frameworks apply to me?"** role selector as the Frameworks-page centerpiece. *Frameworks.* **Med.**
3. **Compliance deadline countdowns** (CRA, Machinery 20 Jan 2027, AI Act 2 Dec 2027 / 2 Aug 2028) — reuses existing timeline data, manufactures urgency. *CRA/AI Act/Machinery.* **Low.**
4. **Penalties / exposure calculator** (turnover in → higher-of € vs % per regime). The NIS2 page already hand-works "€800M → €16M." *NIS2/CRA/AI Act.* **Low.**
5. **IEC 62443 self-scoring SL maturity checklist** → radar chart of SL-A vs SL-T gap + "your remediation backlog." *IEC 62443.* **Med.**
6. **"Are you high-risk under the AI Act?"** classifier from the existing decision-tree. *AI Act.* **Med.**
7. **"Have you become the manufacturer?"** substantial-modification checker (CRA Art. 21 / Machinery Art. 3(16) / AI Act Art. 25) — the set's most differentiated fear-hook, currently buried as prose on 3 pages. *CRA/Machinery/AI Act.* **Med.**
8. **Zones-and-conduits explorer** — interactive version of the static reference-architecture SVG. *IEC/TS 50701.* **High.**
9. **Mini "probability landscape" demo** (sliders → % of simulated campaigns reaching a safety-critical system) for the CDT essay. *CDT.* **High.**

**Suggested first sprint (biggest lift, least new code):** backlog items 1, 2, 3, 4, 6 + shared fix 6 (mid-page CTAs). That alone moves every content page from 6 → ~8 by making the template do what the homepage already does. Then the Frameworks rebuild (5 → 8) and the AI-Act classifier as the signature interactive piece.
