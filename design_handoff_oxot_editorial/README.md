# Handoff: OXOT — Editorial Homepage (Hero + Diensten)

## Overview
A redesign of two sections of the OXOT (OT-cybersecurity) website:
- **Hero / front page** — direction "1b Editorial Authority"
- **Diensten / services** grid — direction "2a"

The goal is a more professional, editorial look than the current site: a light "paper" background, a refined serif for headings, a calm two-column hero, and a single connected services grid. The brand accent is **Dutch orange**, used sparingly.

## About the Design Files
The files in this bundle — `hero_1b.html` and `services_2a.html` — are **design references created in plain HTML/CSS**. They are prototypes that show the intended look, layout, type, and color — **not production code to ship as-is**.

The task is to **recreate these designs inside the OXOT website's existing environment** (whatever framework/CMS/component system it already uses), following that codebase's established patterns, components, and conventions. Treat the HTML here as the visual spec, not the delivery format. Copy the CSS values (colors, fonts, spacing, sizes) exactly; adapt the markup to your stack.

## Fidelity
**High-fidelity.** Colors, typography, spacing, and layout are final and should be matched precisely. The one thing intentionally simplified is the hero's right-hand illustration (an inline SVG "risk map") — reproduce it as-is, or swap it for the site's real product screenshot/diagram at the same size.

## Screens / Views

### 1. Hero (front page) — `hero_1b.html`
- **Purpose:** Top of the homepage. Communicate what OXOT does and drive "praat met een expert".
- **Layout:** Centered content column, `max-width: 1280px`.
  - **Top nav bar:** flex row, space-between, padding `24px 44px`, 1px bottom border (`rgba(22,29,43,.1)`). Left: "OXOT" wordmark (Newsreader 600, 19px). Center: 6 text links (Instrument Sans 500, 14px, `rgba(22,29,43,.62)`; active link full ink). Right: "Contact" button (ink background `#161d2b`, paper text, radius 8px, padding `11px 18px`).
  - **Hero body:** CSS grid, 2 columns `1.1fr .9fr`, gap `56px`, padding `64px 44px 68px`, vertically centered.
- **Left column components:**
  - **Eyebrow:** "OT-Cybersecurity · Operational Technology" — Instrument Sans 600, 12px, letter-spacing `.18em`, uppercase, color Dutch orange `#e8700a`, margin-bottom 26px.
  - **H1:** Newsreader 400, 60px, line-height 1.04, letter-spacing `-.01em`, color `#12192a`. Copy: "Beveilig industriële operaties met heldere, risicogebaseerde besluiten."
  - **Lede paragraph:** Instrument Sans 400, 18px, line-height 1.66, color `rgba(22,29,43,.62)`, max-width 490px.
  - **Actions row:** flex, gap 16px.
    - Primary button: ink bg `#161d2b`, paper text, 15px/600, padding `16px 26px`, radius 9px — "Praat met een OT-securityexpert".
    - Text link with orange underline: "Ontdek onze aanpak" (border-bottom 1.5px `#e8700a`).
  - **Trust row (margin-top 46px):** small uppercase label + serif industry list "Energie · Water · Maakindustrie · Logistiek".
- **Right column — "insight card":** white `#fff`, 1px border, radius 16px, padding 26px, shadow `0 30px 60px -34px rgba(22,29,43,.3)`.
  - Header row: serif title "Eén gestructureerd beeld" + uppercase tag "assets · risks · controls".
  - Inline SVG risk-map diagram (findings → central orange RISK node → zone/control cluster).
  - Stats footer: 3 columns — `86 / assets in scope`, `3 / kritieke risico's` (orange), `62443 / IEC-kader`. Numbers in Newsreader 22px.

### 2. Diensten (services) — `services_2a.html`
- **Purpose:** List the 7 OXOT services in a scannable, professional grid.
- **Layout:** Centered column, `max-width: 1280px`.
  - **Section header:** flex, align-items flex-end, space-between, padding `66px 52px 40px`, 1px bottom border. Left: eyebrow "Onze diensten" (uppercase, letter-spacing `.2em`, Dutch orange) + H2 "OXOT-diensten" (Newsreader 400, 46px). Right: right-aligned intro paragraph, max-width 400px.
  - **Grid:** CSS grid, `repeat(3, 1fr)`, **no gap** — cells are separated by 1px hairline borders (right + bottom, `rgba(22,29,43,.09)`); remove the right border on every 3rd cell.
- **Service cell (×7):** padding `38px 40px`.
  - Number row: mono index (IBM Plex Mono 700, 13px, orange) + a 1px hairline rule tinted orange (`rgba(232,112,10,.35)`).
  - H3: Newsreader 500, 21px, `#12192a`.
  - Paragraph: Instrument Sans 400, 15px, line-height 1.62, `rgba(22,29,43,.62)`.
  - Link: "Meer over deze dienst →" — Instrument Sans 600, 13px, Dutch orange.
- **8th cell — CTA panel (fills the empty grid slot):** dark background `#12192a`, flex column centered. Serif heading "Niet zeker waar te beginnen?", muted paragraph, orange button "Praat met een expert".
- **Service copy (exact):**
  1. OT-securityassessments — "Begrijp uw huidige OT-securityhouding, belangrijkste risico's en praktische vervolgstappen."
  2. Cyber Digital Twin — "Creëer een levend model van uw OT-omgeving om risicogebaseerde beslissingen op schaal te ondersteunen."
  3. OT-securityprogramma's — "Ontwerp en voer gestructureerde OT-securityverbeterprogramma's uit over locaties, bedrijfsonderdelen of regio's."
  4. Architectuur & segmentatie — "Definieer veilige OT-netwerkarchitecturen, zones, conduits en praktische segmentatiepatronen."
  5. Veilige externe toegang — "Verminder risico van leverancierstoegang, onderhoud op afstand en externe connectiviteit."
  6. OT-securitybaseline — "Definieer minimale beveiligingsmaatregelen die realistisch, herhaalbaar en afgestemd op operationele behoeften zijn."
  7. Kennisoverdracht — "Help interne teams de kennis, structuur en eigenaarschap op te bouwen om OT-security duurzaam te onderhouden."

## Interactions & Behavior
- **Nav links / service links / buttons:** standard navigation (`<a href>`). Wire to real routes.
- **Suggested hover states** (not shown in the static mock — add to match the site's conventions):
  - Service cell: subtle background lift (e.g. `#fff` fill or `rgba(0,0,0,.02)`) and the "Meer …" link nudges its arrow right ~2px.
  - Primary/CTA buttons: darken ink ~6%, or orange → `#d5650a` for the orange button.
  - Nav links: transition color to full ink `#161d2b` on hover.
- **Transitions:** use `150–200ms ease` for color/background changes.
- **Responsive:** below ~900px, collapse the hero to a single column (text over card) and the services grid to 2 columns, then 1 column below ~600px. The hairline-border scheme should recompute which cells drop their right border per row.

## State Management
Static content sections — no client state required beyond the site's existing nav/menu behavior. If services are CMS-driven, map each cell to a `{ index, title, description, href }` record; the 8th CTA cell is a fixed element appended after the list.

## Design Tokens
Colors:
- Ink (primary text / dark surfaces): `#161d2b`
- Ink-2 (headings / darkest): `#12192a`
- Paper (page background): `#f6f4ef`
- White (cards): `#ffffff`
- **Dutch orange (accent): `#e8700a`** — replaces the previous burnt orange. Hover/pressed: `#d5650a`.
- Orange hairline tint: `rgba(232,112,10,.35)`
- Hairline border: `rgba(22,29,43,.09)` – `rgba(22,29,43,.1)`
- Muted body text: `rgba(22,29,43,.62)`
- Faint label text: `rgba(22,29,43,.4)–.5`

Typography:
- Display / headings: **Newsreader** (serif), weights 300/400/500. H1 60px, H2 46px, H3 21px, card titles 17–24px.
- Body / UI: **Instrument Sans**, weights 400/500/600. Body 15–18px, labels/eyebrows 12px uppercase.
- Mono (service indices, small tags): **IBM Plex Mono**, 13px.
- (All three are Google Fonts; imports are in each file's `<head>`.)

Spacing / radius / shadow:
- Section padding: `64–66px` top-area, `44–52px` horizontal.
- Card radius: 16px; button radius: 8–9px.
- Card shadow: `0 30px 60px -34px rgba(22,29,43,.3)`.
- Content max-width: 1280px.

## Assets
- **Fonts:** Newsreader, Instrument Sans, IBM Plex Mono — loaded from Google Fonts. Self-host if the site requires it.
- **Hero diagram:** inline SVG in `hero_1b.html` (no external asset). Replace with a real product screenshot/diagram if available, keeping the same footprint.
- No raster images or icons are required.

## Files
- `hero_1b.html` — standalone hero / front-page section.
- `services_2a.html` — standalone diensten (services) grid section.

Both are self-contained (open directly in a browser). Use them side-by-side with this README as the implementation spec.
