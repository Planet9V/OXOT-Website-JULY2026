# OXOT Go-to-Market Content Campaign — 12 Weeks

**Owner:** Marketing (small team, founder as primary voice)
**Duration:** 12 weeks, rolling thereafter on the same cadence
**Primary channel:** LinkedIn. Supporting: X/Twitter, Website Insights hub.
**Language:** Every asset ships in `nl` and `en` per CLAUDE.md — see §6 for the workflow.

---

## Assumptions (update as confirmed)

- The six framework pages and the founder essay are final, published, and stable at their current URLs (`/en/{nis2,cra,ai-act,machine-act,iec-62443,ts-50701,frameworks}`, `/en/cdt-fooled-by-randomness`, `/en/cyber-digital-twin`).
- The founder is available and willing to publish under their own name on LinkedIn/X (not just as house copy). If not, the plan still works with "OXOT" as the byline, but engagement projections in §1 will run lower — LinkedIn's own benchmarks show 2–3x higher reach for personal profiles than company pages in B2B.
- No paid budget is assumed. This is organic-first. If paid budget becomes available, LinkedIn document ads boosting the top-performing carousel per pillar is the highest-leverage add — not covered in detail here.
- CRM/inbound tracking (which conversations originated from which LinkedIn post) is assumed to be manual for now (UTM links + a shared tracker), not a marketing-automation platform. Flag if HubSpot/similar exists — the tracking section would change.
- "Demo/assessment request" is treated as the bottom-of-funnel conversion event; the campaign does not assume a self-serve trial exists (OT security sales is consultative).

---

## 1. Objectives & KPIs

Three-stage funnel: **awareness → engagement → qualified conversation.** Each stage has a leading metric the team reviews weekly, and a lagging metric reviewed monthly.

| Funnel stage | Leading metric (weekly) | Target by week 12 | Lagging metric (monthly) | Target by week 12 |
|---|---|---|---|---|
| Awareness | LinkedIn impressions per post | 3,000–6,000 avg (founder profile), 800–1,500 (company page) | Follower growth, founder + company | +400 combined |
| Awareness | X impressions per thread | 1,500–3,000 avg | X follower growth | +150 |
| Engagement | Engagement rate (reactions+comments+reposts / impressions) | ≥4% LinkedIn, ≥2% X | Comments from target-persona accounts (CISO/OT/compliance titles) | 15+/month by week 12 |
| Engagement | Website Insights hub sessions from social | 250+/week by week 8 | Avg. time on framework pages | ≥2:30 |
| Conversion | Profile clicks / website clicks per post | 20+ per LinkedIn post by week 6 | Inbound DMs/comments requesting more detail | 8+/month |
| Conversion | — | — | Demo/assessment requests attributed to campaign (UTM'd) | 3–5 by week 12, building to a steady monthly rate thereafter |

**Why these numbers, not bigger ones:** OXOT sells into a narrow, senior, EU-regulated buyer. This is not a volume play — 5 qualified assessment requests from the right CISOs is a better week-12 outcome than 50 generic leads. Do not chase vanity impressions at the cost of persona precision (rule 2, YAGNI — don't build a broad-reach campaign nobody asked for).

**Primary KPI for the whole 12 weeks:** qualified conversations started (DM, comment thread that moves to email, or direct assessment request) attributable to campaign content. Everything else is a leading indicator toward that.

---

## 2. Audience & personas

Sectors in scope: energy, water, rail, manufacturing, logistics — all EU, all NIS2 "essential" or "important" entities or their supply chain.

| Persona | Role | Pain they feel | Message that lands | Where they are |
|---|---|---|---|---|
| **CISO / Head of OT Security** | Owns the risk register, answers to the board on incidents, reports to compliance | Drowning in fragmented findings — pentest here, vendor scan there, an audit that "passed" but doesn't tell them where the real exposure is. Knows IT tools don't map to OT reality. | "Evidence over confidence." One structured view instead of five disconnected reports. IEC 62443 as the engineering method, not another audit to survive. | LinkedIn (daily), X (technical threads), OT security conferences/vendor webinars |
| **COO / Plant manager** | Owns uptime, safety, production — security is a means, not an end | Terrified security work will disrupt the process. Has heard "cybersecurity" pitched by IT vendors who don't understand a PLC, a safety instrumented system, or a maintenance window. | "OT-first, not IT copied into the plant." Safety and availability come first — security serves the process, not the other way round. | LinkedIn (less frequent, skims), trade press, industry association briefings |
| **Compliance & legal** | Owns the paper trail for NIS2/CRA/AI Act/Machinery Regulation, personally exposed under some regimes (NIS2 management liability) | Needs to know exactly what's binding, when, and what the penalty exposure is — in plain terms, not vendor FUD. Cannot afford to guess. | Dates, numbers, penalties, stated plainly. "Here's what's binding, when, and what happens if you're not ready." Defensibility — can you show your work if asked? | LinkedIn, legal/compliance newsletters, direct search for framework specifics |
| **Board / executive sponsor** | Owns risk appetite and capital allocation, sees security as a line item until it isn't | Wants a straight answer to "are we secure?" and is tired of being told yes by people who then get breached. Fears reputational and personal (NIS2) liability. | "A clean audit is not proof." The Cyber Digital Twin gives a probability, not a false yes/no. EU sovereignty as a board-level risk-reduction argument (fewer non-EU dependencies to explain in a crisis). | LinkedIn (occasional, high-attention when it appears), briefed by the CISO/COO who shares the content upward |

**Cross-cutting note:** the founder essay ("Fooled by Randomness") is written to land with all four personas at once — it's the hook precisely because "we've never had an incident" is a sentence every one of these roles has said or heard said in a board meeting.

---

## 3. Positioning & messaging pillars

Four pillars. Every framework page and the founder essay maps to at least one; most map to two.

### Pillar 1 — OT-first, not IT copied into the plant
The engineering discipline runs the other way from IT: safety and availability come before confidentiality; a patch cycle that's fine for a laptop can stop a turbine. OXOT was built by people who worked the plant floor, not people who repackaged an IT security stack with OT stickers on it.
**Maps to:** IEC 62443 (zones/conduits as an OT-native method), TS 50701 (rail safety-security interface), Machinery Regulation (Annex III §1.1.9 — corruption of software as a safety failure, not an IT ticket).

### Pillar 2 — Evidence over confidence
A clean audit, a quiet year, a vendor's reference customers — none of it is proof. It's a sample path through a much larger space of outcomes. The only honest answer to "are we secure?" is a probability with a stated confidence interval, not a green dashboard.
**Maps to:** the founder essay (its entire argument), Cyber Digital Twin (the product that operationalizes this), NIS2 (governance/risk-management obligations reward organizations that can show their reasoning, not just their controls).

### Pillar 3 — One structured view / Cyber Digital Twin
Fragmented technical findings — a pentest, a vendor scan, an SBOM, a compliance checklist — don't add up to a decision. The Cyber Digital Twin resolves them into one model: what's actually running (not what the reference architecture says), where the risk concentrates, and what would genuinely reduce it.
**Maps to:** Cyber Digital Twin, CRA (SBOM/vulnerability-handling obligations feed directly into the L2 software layer), AI Act (finding the few systems that are genuinely safety/control-relevant instead of over-governing everything).

### Pillar 4 — EU sovereignty
Critical infrastructure risk is not just technical, it's geopolitical. Dependencies on non-EU vendors, cloud, and AI models are themselves a risk surface — and a board-level, NIS2-relevant question about who has access to the operational picture of your facility.
**Maps to:** NIS2 (EU-wide baseline, member-state transposition), CRA (EU market-access regulation), Frameworks overview (the map of who in the EU regulatory system is responsible for what).

### Pillar-to-content map (summary)

| Content asset | Pillar 1 (OT-first) | Pillar 2 (Evidence) | Pillar 3 (Structured view) | Pillar 4 (Sovereignty) |
|---|---|---|---|---|
| Founder essay (Fooled by Randomness) | | Primary | Secondary | |
| NIS2 | | Secondary | | Primary |
| CRA | | | Secondary | Primary |
| AI Act | | Secondary | Primary | |
| Machinery Regulation | Primary | | | |
| IEC 62443 | Primary | | Secondary | |
| TS 50701 | Primary | | | |
| Frameworks overview | | | Secondary | Primary |
| Cyber Digital Twin (product) | Secondary | Primary | Primary | |

---

## 4. Channel strategy

### LinkedIn — primary
- **Format mix:** short text posts (3–5x/week), document/PDF carousels (1–2x/week, tied to a framework or the essay), founder long-form posts (1x/week) positioning them as the person who's seen the plant floor and the boardroom.
- **Why:** this is where CISOs, compliance leads, and boards actually spend attention during the workday. Document carousels perform well for regulation-heavy B2B because they let a busy compliance reader skim 6–8 slides instead of a full article.
- **Founder-first:** per the assumption in the header, the founder's personal profile should carry the thought-leadership pieces (the essay, the "why OXOT exists" narrative); the company page carries framework explainers and reposts/amplifies the founder's posts.

### X/Twitter — secondary, technical amplification
- **Format:** threads (6–10 tweets), one per framework/essay, written for a slightly more technical/international audience (OT security researchers, EU policy-watchers). Threads compress the LinkedIn carousel into a faster-reading, more shareable format and reach outside the Netherlands.
- **Cadence:** 1 thread/week, timed a day or two after the corresponding LinkedIn carousel so it can quote/link back.

### Website Insights hub — the anchor
- Every framework page and the essay already exists here. Social content's job is to **drive traffic to these pages**, not to duplicate them. The hub is where a compliance lead actually reads the dates and penalties in full, and where a demo/assessment CTA lives.
- Each week's LinkedIn/X content links back to the relevant page with a UTM'd link, and closes with a single clear CTA (see calendar).

### How the three reinforce each other
Website page (source of truth, full depth) → LinkedIn carousel (visual summary, drives clicks back) → LinkedIn text post (the sharpest single argument from the page, drives comments) → X thread (technical/international amplification, drives clicks back) → founder LinkedIn post (personal framing, "why this matters," drives DMs). One piece of source content, four distribution shapes, one destination.

---

## 5. 12-week content calendar

Sequencing logic: open with the founder essay to earn attention and establish "evidence over confidence" as the lens for everything after. Then move through the six frameworks in order of urgency (nearest binding date / broadest audience first), closing on IEC 62443 and TS 50701 as the "how" once the reader has felt the "why." Introduce the Cyber Digital Twin as the running answer threaded through every week, then give it a dedicated close in week 11. Week 12 synthesizes and pivots to the next cycle.

| Week | Theme / framework | LinkedIn post angle | Carousel | X thread | Website link | CTA |
|---|---|---|---|---|---|---|
| 1 | Founder essay — "We've never had an incident" | Founder long-form: open with the turkey/Taleb hook — a clean audit is an outcome, not proof. Plain, personal, first-person. | Yes — "Why 'No Incidents' Isn't Evidence" (6 slides: the illusion, the turkey, the twin as answer) | Thread: the fund-manager cemetery, translated to OT — "10,000 managers, 300 look like geniuses by chance alone" | `/en/cdt-fooled-by-randomness` | "Read the full argument" (soft CTA, awareness stage) |
| 2 | Founder essay, part 2 — the four illusions | Text post: the reference-architecture illusion — "the diagram on the wall is accurate for a system that no longer exists" | No (carry-over week from week 1's carousel, avoid overproduction) | Thread: vendor survivorship — the reference customers on stage vs. the silent NDA'd failures | `/en/cdt-fooled-by-randomness` | "See how we measure the gap" → Cyber Digital Twin page |
| 3 | NIS2 | Text post: NIS2 is a governance and risk-management law, not a shopping list — most OT orgs are optimizing for the wrong compliance shape | Yes — "NIS2 in 7 Slides: Who's In, What's Binding, What It Costs" (transposition status, essential vs. important, €10M/2%, personal liability) | Thread: NIS2 management liability — why the board, not just the CISO, now owns this | `/en/nis2` | "Check your NIS2 exposure" → assessment request |
| 4 | CRA | Text post: security becomes a legal condition of market access — the 24-hour reporting clock is retroactive, even for products already shipped | Yes — "CRA Timeline: 11 Sep 2026 to 11 Dec 2027" (milestone rail graphic, orange markers) | Thread: what SBOM and vulnerability-handling obligations actually require, in plain terms | `/en/cra` | "Get the CRA readiness view" → assessment request |
| 5 | AI Act | Text post: most industrial AI is not high-risk — the real work is finding the few systems that are safety/control components | Yes — "AI Act for OT: Find the 5%, Not the 100%" | Thread: "a manipulated model is a manipulated process" — why AI Act matters for control systems, not just chatbots | `/en/ai-act` | "Map your AI systems against the Act" |
| 6 | Machinery Regulation | Text post: a machine that can be made dangerous by corrupting its software is not compliant — cybersecurity is now part of the safety case | Yes — "Machinery Regulation 2027: Annex III §1.1.9 Explained" | Thread: "substantial modification" — how an integrator can silently inherit full manufacturer obligations | `/en/machine-act` | "Talk to us before 20 Jan 2027" |
| 7 | Mid-campaign recap + engagement week | Founder text post: reply to the best comment/question from weeks 1–6, expand on it publicly (shows the agent is listening, drives more comments) | No — repurpose top-performing carousel from weeks 1–6 as a repost with new commentary | Thread: a "so what have we covered" recap thread with links to all prior threads | Insights hub (index) | "Which framework applies to you?" (soft, diagnostic) |
| 8 | IEC 62443 | Text post: the laws set the outcomes, IEC 62443 sets the method — zones, conduits, security levels turn "make it secure" into a checkable spec | Yes — "IEC 62443 in Plain Terms: Zones, Conduits, SL-T/C/A" | Thread: why "compliant with a framework" and "actually secure" are not the same claim (ties back to week 1–2 pillar 2) | `/en/iec-62443` | "See the engineering method behind the law" |
| 9 | TS 50701 | Text post (rail-sector focus): "if a system is not secure, its safety cannot be guaranteed" — the rail safety-security interface | Yes — "TS 50701: Where Rail Safety Meets Security" | Thread: EN 50126 RAMS lifecycle + TS 50701, for a rail-specific technical audience | `/en/ts-50701` | "Rail operator? Start here" |
| 10 | Frameworks overview — synthesis | Founder text post: "build to the standard once, satisfy much of the law across the board" — the map of who owns what across NIS2/CRA/AI Act/Machinery Regulation | Yes — "The EU OT Regulation Map: Who's Responsible for What" (operators/manufacturers/machine builders/AI deployers, IEC 62443+TS 50701 underneath) | Thread: a "start here" thread for anyone confused which law applies to them | `/en/frameworks` | "Not sure which frameworks apply? Ask us" |
| 11 | Cyber Digital Twin — the answer | Founder long-form: full-circle back to week 1 — this is what "evidence over confidence" looks like built, not just argued. The seven-layer graph, NOW/NEXT/NEVER | Yes — "The Cyber Digital Twin: One Structured View" (L0–L6 layers as a node-and-edge graph, per style guide motif) | Thread: NOW/NEXT/NEVER — how the twin prioritizes spend against a compliance checklist's instincts | `/en/cyber-digital-twin` | "Request a Cyber Digital Twin assessment" (hard CTA) |
| 12 | Campaign synthesis + next cycle | Founder text post: what 12 weeks of "evidence over confidence" looked like — plain recap, no self-congratulation, point to what's next (case study or sector-specific deep dive) | Yes — "12 Weeks, 6 Frameworks, One Argument" (single-slide summary graphic + carousel recap) | Thread: link every prior thread in sequence, framed as a syllabus ("start here if you're new") | Insights hub (index) | "Book an assessment" + "Subscribe to Insights" |

**Carousel cadence check:** 8 of 12 weeks carry a carousel (weeks 1, 3–6, 8–11 plus a lighter one in week 12) — roughly the "1–2x/week" target from §4 averaged over the campaign, with weeks 2, 7 deliberately carousel-light to avoid overproduction and let repurposed/engagement content carry the week.

---

## 6. Cadence & workflow

### Weekly rhythm (per calendar week)
- **Monday:** LinkedIn text post goes out (morning, CET business hours — this audience reads at their desk, not on a commute).
- **Tuesday/Wednesday:** carousel goes out (if scheduled that week), timed a day after the text post so the text post's comments have already started and can be pointed to the carousel.
- **Thursday:** X thread goes out, referencing/linking the week's LinkedIn content.
- **Friday:** light engagement day — reply to comments, no new post, review the week's numbers against §1 targets.

### Who does what (small team)
- **Founder:** writes/records the personal-voice posts and the essay-adjacent content (weeks 1, 2, 7, 11, 12). This is the highest-leverage use of founder time — do not delegate the voice, only the production.
- **Marketing/content owner:** drafts the framework-explainer text posts and X threads from the existing page copy (this is summarization, not new research — the page is the source of truth), builds the carousels, schedules everything, tracks UTMs and the weekly metrics table.
- **Whoever owns the Insights hub CMS:** confirms each week's target page is live, correctly localized (nl + en), and that the CTA link/assessment-request path works before the post goes out. This is a five-minute check, not optional — a dead link on a CISO's click is a wasted week.

### Repurposing flow (page → carousel → post → thread)
1. Start from the published page (`content/pages/en/{slug}.md` or `content/en/{slug}.md`) — it is the single source of truth for facts, dates, and figures. Never re-derive a date or penalty figure from memory; copy it from the page.
2. Pull the page's core contrarian claim (its opening "comfortable misconception" framing) as the carousel's title slide and the text post's opening line.
3. Compress the page's evidence table or milestone list into 6–8 carousel slides using the carousel builder (see below).
4. Cut the single sharpest paragraph from the page as the LinkedIn text post — do not summarize the whole page, pick the one argument that stops a scroll.
5. Expand the same argument into 6–10 tweets for the X thread, written slightly more technically since X skews toward a practitioner audience.
6. Every asset links back to the page with a UTM (`?utm_source=linkedin&utm_medium=organic&utm_campaign=w{N}-{slug}` or `utm_source=x`).

### Using the carousel builder (`/tools/carousel-builder.html`)
- Open the tool locally (`public/tools/carousel-builder.html`) or via the deployed site path.
- Follow the OXOT style guide defaults it should already encode: deep navy background (`#102030`), one orange (`#F07000`) focal accent per slide, editorial serif headline + sans body, kicker label in uppercase steel/orange.
- One idea per slide. The title slide carries the contrarian hook (e.g., "CRA is just testing and SBOMs. It isn't."); the closing slide always carries the CTA and the page URL.
- Export at 1200×627 (LinkedIn feed) — the tool should also produce the 1080×1080 square variant per the style guide's dual-size requirement; check both render legibly before publishing.
- **Every carousel ships in nl and en as two separate exports** — same design, translated copy, per CLAUDE.md §3. Do not publish an English-only carousel.

### Localization workflow (non-negotiable per CLAUDE.md)
- Draft in English first (source pages are typically drafted `en` then translated), then produce the `nl` version before either goes live — not after. If the `nl` version isn't ready, the post waits.
- Post the `nl` version to a Netherlands/EU-focused schedule slot if audience segmentation on LinkedIn allows it; otherwise alternate primary language by week or post both language versions as separate posts.

---

## 7. Measurement & iteration

### Weekly review (15 minutes, Friday)
Check the leading metrics in §1 against the running average. Specifically watch:
- **Engagement rate by pillar:** which of the four pillars is producing the highest comment rate? Early signal for which pillar to lean into for weeks not yet scripted.
- **Carousel vs. text-only performance:** if carousels are meaningfully outperforming text posts (or vice versa) by week 4, shift the week 7–12 format mix accordingly rather than sticking rigidly to the plan.
- **Which persona is commenting:** check commenter titles. If CISOs are engaging but compliance/legal isn't, the penalty/date framing may need to be sharper and more prominent, not buried mid-post.

### Monthly review (end of week 4, 8, 12)
- Review lagging metrics: follower growth, website sessions from social, demo/assessment requests attributed via UTM.
- **Double down when:** a specific framework or angle produces disproportionate profile clicks or DMs — commission a follow-up asset (e.g., a sector-specific version, a downloadable one-pager) rather than moving on to the next topic on schedule. Rule 9 applies: evidence of what's working beats sticking to the calendar for its own sake.
- **Cut or change when:** a format (e.g., X threads) consistently underperforms its target after 4 weeks with no persona engagement — do not keep producing it out of habit; reallocate that time to the format that's working.

### What "iteration" looks like concretely
- Week 4 checkpoint: if NIS2 (week 3) or CRA (week 4) content is driving noticeably more assessment-request interest than the founder essay did, that's evidence compliance urgency outperforms philosophical framing for this audience — consider moving IEC 62443/TS 50701 earlier in a future cycle, since they're the "how" a compliance-anxious reader wants next.
- Week 8 checkpoint: assess whether the founder's personal-voice posts (weeks 1, 2, 7) are meaningfully outperforming the company-page framework posts. If so, shift more of weeks 9–12's authorship to the founder's voice even for framework content.
- Week 12 checkpoint: decide the next 12-week cycle's spine. Candidates: sector-specific deep dives (energy vs. water vs. rail, using the same frameworks but sector-cut), a customer/case-study arc once the campaign has produced qualified conversations worth writing up, or a second pass on the same six frameworks now anchored to their next milestone (e.g., CRA's 11 Sep 2026 reporting-duty date, if still in the future at that point).

### Reporting cadence
Weekly numbers go in a shared tracker (spreadsheet is sufficient at this volume — no need for a marketing-automation platform yet, per YAGNI). Monthly, produce a one-page summary against the §1 KPI table for the founder/leadership: what moved, what didn't, and the one change being made for the next four weeks.
