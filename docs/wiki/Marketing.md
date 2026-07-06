For: admins / marketing team

# Marketing

The OXOT campaign kit: the 12-week content plan, the ready-to-post social copy (English +
Dutch), and the carousel builder tool used to turn scripts into LinkedIn document-post
graphics. See also [Admin-Guide](Admin-Guide.md) for publishing pages/articles on the site
itself, and [Content-Authoring](Content-Authoring.md) for Markdown/body content conventions.

## 1. The campaign plan

`marketing/CAMPAIGN_PLAN.md` — "OXOT Go-to-Market Content Campaign — 12 Weeks." Sections:

- **Assumptions** — the stated starting premises for the plan (kept explicit and updatable,
  per the project's Karpathy rules on tracking assumptions).
- **Objectives & KPIs** — what the campaign is trying to achieve and how success is measured.
- **Audience & personas** — who the content is written for.
- **Positioning & messaging pillars** — four core pillars, each mapped to the kinds of content
  that support it.
- **Channel strategy** — LinkedIn, X, and the website, with channel-specific notes.
- **12-week content calendar** — a week-by-week table of what ships when.
- **Cadence & workflow** — how content moves from draft to published.
- **Measurement & iteration** — how the plan gets revisited.

Use this as the source of truth for *what* to post and *when*; the actual copy lives in the
files below.

## 2. LinkedIn / X post copy

Two parallel files, one per language, same structure:

- `marketing/linkedin-x-posts.md` — English.
- `marketing/linkedin-x-posts.nl.md` — Dutch.

Each covers eight topics, and for each topic gives you **both** a LinkedIn post and an X
thread, ready to copy-paste:

1. Founder essay
2. Cyber Digital Twin
3. NIS2
4. CRA (Cyber Resilience Act)
5. AI Act
6. Machinery Regulation
7. IEC 62443
8. TS 50701

Per the site's non-negotiable bilingual rule, never ship one language's post without also
publishing the other — pull the matching entry from both files together.

## 3. Carousel scripts (ready-made)

Paste-ready scripts for the carousel builder (below), also shipped in both languages:

- `marketing/carousel-scripts.md` — English, eight scripts (same topic list as the posts above).
- `marketing/carousel-scripts.nl.md` — Dutch equivalents.

These are already written in the builder's slide syntax — open the builder, paste one straight
in, and it renders.

## 4. The carousel builder

A static, no-login tool at:

```
/tools/carousel-builder.html
```

It turns a short plain-text script into a set of styled, on-brand LinkedIn carousel slides
(OXOT navy/orange palette, serif display headings) that you export as a PDF.

### Slide syntax

Slides are separated by a line containing only `---`. Within a slide, each line is interpreted
by its leading character:

| Prefix | Meaning | Notes |
|---|---|---|
| `#COVER` (whole line) | Marks this slide as a cover slide | Gives it the cover gradient background style. Use on the first and/or last slide. |
| `#` | Kicker (first `#` line) or title (second `#` line) | The first `#`-prefixed line in a slide becomes the small uppercase kicker label; the next becomes the big serif heading, if no plain title line was already used. |
| `!` | Giant stat | Renders large, in orange — e.g. `!24h` or `!€10M`. |
| `-` | Bullet point | Rendered as a list item with an orange tick mark. |
| `@` | Footer | Small text pinned to the bottom of the slide, alongside the handle. |
| (plain line, no prefix) | Title (if none set yet) or body paragraph | The first unprefixed line becomes the title if `#` hasn't already supplied one; subsequent plain lines become body paragraphs. |

Example (from the builder's own built-in default script):

```
#COVER
NIS2 is not an IT problem
#The plant floor is in scope now
@OXOT · NIS2 for OT
---
#THE MISCONCEPTION
"It's the IT team's compliance project."
It reaches directly into the OT that keeps production running and people safe.
---
#THE NUMBER
!24h
Early warning for a significant incident. Then 72 hours. Then a final report in one month.
---
#TEN MEASURES
Article 21 is the core
- Risk analysis & asset inventory
- Incident handling that fits OT
- Business continuity & recovery
- Supply-chain security
- MFA on remote & privileged access
```

### Step by step: from script to LinkedIn post

1. Open `/tools/carousel-builder.html` in a browser.
2. In the left panel, paste your script (from `marketing/carousel-scripts.md` or
   `carousel-scripts.nl.md`) into the text box, replacing the default sample.
3. Pick a **Format**:
   - `4:5 portrait (1080×1350)` — the default, standard LinkedIn document post size.
   - `1:1 square (1080×1080)`.
4. Set the **Handle** field (defaults to `oxot.nl`) — this appears in the bottom-right of every
   slide's footer.
5. Click **Update preview** to re-render the slide stage on the right with your content.
6. Click **Export PDF** (labeled "Export PDF (Print → Save as PDF)") — this opens your browser's
   print dialog. Choose **Save as PDF** as the destination (the tool's own print stylesheet
   hides the editor chrome and paginates one slide per page automatically).
7. Go to LinkedIn, start a post, and upload the exported PDF as a **document** post (not an
   image post) — this gives you the native swipeable-carousel viewer.

Keep carousels to roughly 6–10 slides, per the hint text built into the tool itself.

## 5. Brand and imagery

Before producing any new visual asset (carousel art, OG images, campaign graphics), check the
brand style guide for colour palette, typography, and imagery rules:

[`docs/OXOT_BRAND_IMAGE_STYLEGUIDE.md`](../OXOT_BRAND_IMAGE_STYLEGUIDE.md)

It defines the OXOT Navy / OXOT Orange / Steel palette (with hex values), the serif/sans
typography pairing, layout motifs, and a quick spec checklist — the same palette the carousel
builder is hard-coded to use.

## Quick reference

| I want to... | Go to |
|---|---|
| See the 12-week plan | `marketing/CAMPAIGN_PLAN.md` |
| Get ready-to-post copy | `marketing/linkedin-x-posts.md` (+ `.nl.md`) |
| Get a ready-made carousel script | `marketing/carousel-scripts.md` (+ `.nl.md`) |
| Build/export a carousel | `/tools/carousel-builder.html` |
| Check brand colours/type | `docs/OXOT_BRAND_IMAGE_STYLEGUIDE.md` |
| Publish something on the site | [Admin-Guide](Admin-Guide.md) |
