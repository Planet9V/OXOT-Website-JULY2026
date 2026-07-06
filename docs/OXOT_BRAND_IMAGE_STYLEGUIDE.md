# OXOT — Brand & Image Style Guide

The single reference for OXOT's visual voice. Applies to the website, generated
images and SVG diagrams, LinkedIn/X assets, and PDF/deck exports. Derived from
the OXOT CRA Readiness Annex A sheet and the OXOT content voice.

> [!NOTE]
> If you generate an image or an SVG for OXOT, it must obey this guide. When in
> doubt: **deep navy, one confident orange accent, editorial serif headline,
> clean sans body, plenty of space, no stock-photo clichés.**

## 1. Voice (so images carry the right tone)

OXOT sounds like a senior OT engineer who has seen the plant floor and the
boardroom, and refuses to waste either's time.

- **Contrarian and clarifying.** Lead by dismantling a comfortable misconception, then replace it with the real picture. ("The CRA is a conformity case you must defend — not a test you pass." "CRA is just testing and SBOMs. It isn't.")
- **Plain, declarative, confident.** Short sentences. Em-dashes for the turn. No hedging, no hype, no jargon-as-decoration.
- **Risk-based and evidence-first.** Numbers, dates, consequences. "Prefer evidence over confidence."
- **OT-first.** Safety, availability and production come before IT reflexes.
- **European.** Dutch, EU-sovereignty-aware, regulation-literate.

Words we use: *evidence, defensible, proportionate, zones and conduits, operational risk, decision-ready, structured view.* Words we avoid: *cutting-edge, leverage, unlock, seamless, world-class, delve, in today's landscape.*

## 2. Colour

The palette is a **deep navy field, an off-white page, and a single vivid orange
accent** — steel-blue tones carry structure between them.

| Token | Hex | HSL | Use |
|---|---|---|---|
| **OXOT Navy** (primary dark surface) | `#102030` | `210 50% 12%` | Hero bands, dark callouts, diagram backgrounds |
| **OXOT Orange** (accent) | `#F07000` | `28 100% 47%` | Kicker labels, key figures, CTAs, the left rule, one focal element per image |
| **Steel 700** | `#304050` | `210 25% 25%` | Structure lines, secondary shapes |
| **Steel 500** | `#506070` | `210 17% 38%` | Muted shapes, borders on navy |
| **Steel 300** | `#C0C0D0` | `240 17% 78%` | Faint mesh/telemetry lines on navy |
| **Paper** | `#F7F7F0` | `60 33% 96%` | Light page background |
| **Ink** | `#0E1B2B` | `212 51% 11%` | Body text on paper |
| **Off-white** | `#E5E7EB` | `220 13% 91%` | Text/lines on navy |

Rules:
- **One orange per composition.** Orange is emphasis, not fill. If everything is orange, nothing is. Use it for the single thing the eye should land on (a node, a number, a label, a CTA).
- Blue is *structure*, not brand. Steel-blues build the scaffold; orange marks meaning.
- Never place orange text on navy below ~14px without weight — keep it bold and legible.
- Diagrams for the dark site use: background `#102030`/transparent, strokes `#94A3B8`, structure `#3b82f6`/steel, accent `#f07000`, text `#E5E7EB`.

## 3. Typography

- **Display / headlines: editorial serif.** Transitional old-style serif (site stack: `Fraunces`/`Newsreader` → `Georgia`, `Palatino`, serif). Headlines read like a considered argument, not a banner.
- **Body & UI: humanist sans.** The system UI sans. Comfortable measure (~66 characters), generous line-height.
- **Kicker labels: UPPERCASE sans, letter-spaced (~0.15em), small, orange or steel.** The signature OXOT eyebrow above a headline (e.g., `THE COMFORTABLE MISCONCEPTION`, `THE IEC 62443 FOUNDATION`).
- Bold is for load-bearing phrases inside a sentence, used sparingly.

## 4. Layout motifs

- **The left orange rule.** A thin vertical orange bar down the left of a hero band — OXOT's most recognisable device.
- **Kicker → serif headline → sans deck.** Every section opens this way.
- **Bordered evidence cards** with a coloured left/top border (orange for "what's required", steel for "what's assumed", blue for standards). Assumption-vs-reality pairs are a recurring pattern.
- **Dark consequence band.** A navy block near the end stating the stakes (market lockout, penalty, scrutiny) in short orange-labelled columns.
- **Generous whitespace.** The design breathes; it never fills every pixel.

## 5. Imagery & diagrams

Prefer **built vector (SVG) over photography.** OXOT visuals are diagrammatic and
conceptual, not stock imagery.

Recurring concepts to illustrate (never literal clip-art):
- **Zones & conduits** — nested/adjacent rectangles joined by controlled channels.
- **The Cyber Digital Twin** — a node-and-edge graph (a *structured view*) rising from a schematic industrial base; fragmented inputs resolving into one model.
- **Safety ∩ Security** — two disciplines meeting; corruption threatening a safety function.
- **Timelines** — milestone rails with orange markers for the binding date.
- **Evidence, not events** — the distribution/turkey idea (a long calm line, then a break) for the "we've never had an incident" fallacy.

Avoid: padlocks, hooded hackers, glowing blue globes, binary rain, generic "shield" icons, faux-3D, gradients-for-their-own-sake, and photographic control rooms.

## 6. Quick spec for a generated OXOT image/SVG

1. Background **OXOT Navy `#102030`** (or transparent for inline diagrams).
2. One **serif headline** (if any text), one **orange kicker** label.
3. Structure in **steel-blue**; exactly one **orange `#F07000`** focal accent.
4. Text/lines in **off-white `#E5E7EB`**; keep type legible on navy.
5. A concept from §5 — diagrammatic, not decorative. Whitespace over density.
6. Legible at LinkedIn size (1200×627) and as a square (1080×1080).
