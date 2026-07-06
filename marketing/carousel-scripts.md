# OXOT LinkedIn Carousel Scripts

Ready-to-paste scripts for `/tools/carousel-builder.html`. Each block below is a complete script —
copy everything inside one ```text``` fence into the builder's textarea, click **Update preview**,
then **Export PDF** and upload as a LinkedIn document post.

Syntax reference: slides separated by a line containing only `---`. Within a slide: `#` = kicker
(first) or title (second) · `!` = one big stat · `-` = bullet · `@` = footer. `#COVER` as the first
line styles a cover slide. Voice: plain, contrarian, evidence-first — no buzzwords.

---

## 1. Founder essay — "We've never had an incident" is not evidence

```text
#COVER
"We've never had an incident"
#is not evidence. It's one sample path.
@OXOT · Fooled by Randomness
---
#THE COMFORTABLE SENTENCE
A clean audit. A quiet year.
Neither one tells you the controls work. They tell you the attack hasn't converged yet.
---
#THE TURKEY
!1,000
Days fed, growing more confident with every meal — right up to the day before Thanksgiving. Confidence was never tracking risk.
---
#THE ILLUSION
The reference architecture illusion
The diagram on the wall shows clean segmentation. What's running is three years of workarounds nobody closed.
---
#THE ILLUSION
The vendor survivorship illusion
Ten happy customers go on stage. The twenty that got breached signed an NDA and aren't in the room.
---
#THE HARDER QUESTION
Not "do we have controls?"
Given the full probability space of how an adversary could move through this facility — where are we exposed, and by how much?
---
#THE ANSWER
A probability landscape, not a score
Not a checklist. Not a maturity rating. The paths most likely to succeed, ranked by consequence — and what actually reduces them.
---
#COVER
Talk to an OT security expert
#oxot.nl
@Evidence over confidence
```

---

## 2. Cyber Digital Twin — one structured view of OT risk

```text
#COVER
Your OT risk lives in six tools
#none of which talk to each other
@OXOT · Cyber Digital Twin
---
#THE PROBLEM
Documentation. Diagrams. Inventories.
Configs, security tools, operator knowledge — each source tells part of the story. None of them tell the whole one.
---
#THE SHIFT
One structured view, not six reports
The Cyber Digital Twin brings every source into a single living model of assets, risks and controls.
---
#WHY IT MATTERS
Severity is not the same as risk
A critical CVE on an isolated historian is not the same problem as a medium one on a safety-adjacent PLC. Context decides priority.
---
#WHAT IT SUPPORTS
- Site risk assessments
- Attack path analysis
- Control gap analysis
- Investment prioritization
---
#NOT A REPLACEMENT
It doesn't replace your tools
It uses their output, adds context, and turns fragmented findings into decisions leadership can actually act on.
---
#COVER
Talk to an OT security expert
#oxot.nl
@One model. Decision-ready.
```

---

## 3. NIS2 (Article 21 · 24/72h · €10M/2% · management liability)

```text
#COVER
NIS2 is not an IT problem
#The plant floor is in scope now
@OXOT · NIS2 for OT
---
#THE MISCONCEPTION
"It's the IT team's compliance project."
NIS2 reaches directly into the OT that keeps production running and people safe.
---
#ARTICLE 21
Ten measures. All-hazards.
Risk analysis, incident handling, supply-chain security, MFA on remote access — proportionate to your actual risk, not a shopping list.
---
#THE CLOCK
!24h
Early warning for a significant incident. Then 72 hours for notification. Then a final report within one month.
---
#ACCOUNTABILITY
Management is on the hook
Article 20: the board approves the measures, oversees them, and can be held personally liable. Security follows accountability.
---
#THE PENALTY
!€10M
or 2% of global turnover for essential entities — whichever is higher. A board-level financial risk, not a rounding error.
---
#WHERE TO START
You can't manage what you can't see
Most operators can't produce a current, structured view of their OT estate. That gap is now a compliance exposure.
---
#COVER
Talk to an OT security expert
#oxot.nl
@NIS2 is the law. IEC 62443 is the method.
```

---

## 4. CRA (24h reporting 11 Sep 2026 · main obligations 11 Dec 2027 · €15M/2.5%)

```text
#COVER
Security just became
#a condition of market access
@OXOT · The Cyber Resilience Act
---
#THE SHIFT
For decades, security was optional
The CRA makes it a legal condition of placing a product with digital elements on the EU market.
---
#THE FIRST DEADLINE
!11 Sep 2026
Vulnerability and incident reporting duties apply — to every in-scope product already on the market, not just new ones.
---
#THE RETROACTIVE TRAP
A 2019 SCADA system counts too
If a vendor learns of active exploitation after that date, the 24-hour reporting clock starts the same way it would for a 2028 product.
---
#THE MAIN DEADLINE
!11 Dec 2027
Essential requirements, conformity assessment and CE marking apply in full. The runway is already short.
---
#THE SUPPORT PERIOD
Five years, as a rule
A PLC installed in 2028 can run for twenty years. Unless a vendor commits contractually, most of that life is unsupported.
---
#THE PENALTY
!€15M
or 2.5% of worldwide turnover — applied per non-conformant product. Multiple product lines, multiple fines.
---
#COVER
Talk to an OT security expert
#oxot.nl
@Security-by-design, or no CE mark
```

---

## 5. AI Act (industrial AI · machinery safety-component = high-risk)

```text
#COVER
Most industrial AI
#is not high-risk. Some of it is.
@OXOT · The EU AI Act
---
#THE ARRIVAL
AI crept in without a launch date
A vision system bundled into an inspection cell. A predictive-maintenance module. Nobody drew a boundary.
---
#THE REAL QUESTION
Function decides risk, not technology
A rule-based system and a neural network are treated identically if they do the same safety-relevant job.
---
#THE LINE THAT MATTERS
Vision that sorts good from bad?
Minimal risk. The same vision system wired to stop a hazardous motion? A safety component — and automatically high-risk.
---
#ARTICLE 15
A manipulated model is
a manipulated process. Data poisoning and adversarial inputs are OT threats now, not IT data-quality issues.
---
#THE TRAP
Retrain a vendor's model on your data
and you may become the provider — inheriting the full high-risk obligation stack.
---
#THE PENALTY
!€35M
or 7% of worldwide turnover for prohibited practices. €15M or 3% for breaching high-risk obligations.
---
#COVER
Talk to an OT security expert
#oxot.nl
@Find the few. Govern them properly.
```

---

## 6. Machinery Regulation (cyber = safety · 20 Jan 2027)

```text
#COVER
A corruptible machine
#is not a safe machine
@OXOT · The Machinery Regulation
---
#THE OLD WORLD
Safety engineers reasoned about guards.
Security, if anyone owned it, stopped at the office firewall. The Machinery Regulation ends that separation.
---
#THE CLAUSE
Annex III §1.1.9
A machine must resist accidental or intentional corruption of the software that affects safety. Security is now inside the safety case.
---
#THE DEADLINE
!20 Jan 2027
A hard wall, not a soft target. From that date, machinery on the EU market must meet the new requirements.
---
#THE LOGIC
A forged network command
that retracts a guard. Firmware silently overwritten. A perfectly rated relay driven by an unauthenticated instruction. Not safe.
---
#THE TRAP
Re-flash a safety PLC. Add remote access.
That can be a "substantial modification" — and it makes you the manufacturer of the machine, digital changes included.
---
#THE OVERLAP
AI safety component in the machine?
It's automatically high-risk under the AI Act too. Two regimes, one product, at the same time.
---
#COVER
Talk to an OT security expert
#oxot.nl
@Cyber is now a safety requirement
```

---

## 7. IEC 62443 (zones & conduits · component security · the programme)

```text
#COVER
The law tells you what.
#IEC 62443 tells you how.
@OXOT · IEC 62443 for OT
---
#THE CORE IDEA
Zones and conduits
Group assets by shared security need. Control the conduits between them. Effort concentrates at the boundaries.
---
#THE RULE
Draw zones by consequence
not by network topology. Two devices on the same VLAN can belong to different zones if impact differs.
---
#SECURITY LEVELS
!SL 1–4
From casual misuse to nation-state-grade attackers. Most zones need SL 1–2. Only the highest-consequence functions need more.
---
#THREE FLAVORS
Target, capability, achieved
SL-T is what a zone needs. SL-C is what a component can deliver. SL-A is what's actually in place. The gap is your backlog.
---
#THE PROGRAMME
A control is only as good
as the process that sustains it. 62443-2-1 is the operator's security programme — not a one-off project.
---
#WHY IT MATTERS
One engineering method,
many regimes satisfied. NIS2, the CRA, TS 50701 — all point back to the same zones-and-conduits logic.
---
#COVER
Talk to an OT security expert
#oxot.nl
@The method behind a defensible answer
```

---

## 8. TS 50701 (rail cybersecurity on IEC 62443)

```text
#COVER
A modern train is
#a data centre on wheels
@OXOT · TS 50701 for Rail
---
#THE GAP
Safety asks: will it fail dangerously?
Security asks: can an adversary make it misbehave? For decades, rail had no standard that asked both at once.
---
#THE ANSWER
!2021
CLC/TS 50701 published — the first cybersecurity specification written specifically for rail, built on IEC 62443.
---
#THE FOUNDATION
Zones, conduits, security levels
borrowed directly from IEC 62443-3-2 and 3-3, then re-expressed in language a railway engineer already knows.
---
#THE HARD PART
A security patch can break a safety case
Tighten a firewall rule, drop the wrong packet, degrade a safety function. The safety–security interface exists for exactly this.
---
#THE PRINCIPLE
If it's not secure,
its safety cannot be guaranteed. Security is a precondition for safety here, not an add-on.
---
#WHAT'S NEXT
IEC 63452 is coming
Work done to TS 50701 carries forward almost unchanged. The pragmatic move is to start now, not wait.
---
#COVER
Talk to an OT security expert
#oxot.nl
@Safety and security, one lifecycle
```
