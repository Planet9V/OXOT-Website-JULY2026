-- 016_seed_remaining_pages.sql
-- Seed the markdown CMS pages that migration 003 does not cover, so they exist
-- deterministically via db:migrate (the seed:pages importer was not populating
-- them in the deployed container). Idempotent: ON CONFLICT (slug,locale) DO UPDATE.

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('architecture-segmentation', 'en', 'Architecture & Segmentation', 'Flat OT networks turn a single foothold into a plant-wide incident. OXOT designs OT network architectures that contain that blast radius — zones and conduits aligned to IEC 62443 — while respecting the reality that you cannot simply re-cable a running plant.

We start from your actual traffic and data flows, define a target you can migrate to in phases, and validate every step against operations so segmentation improves security without interrupting production.

```keyfacts
Standard :: IEC 62443-3-2 (zones) and 3-3 (controls)
Unit of design :: zones and conduits, not flat VLANs
Approach :: segment without breaking production
Includes :: DMZ, data flows, remote access, firewall baselines
Deliverable :: target architecture + a phased migration plan
Validation :: designed and checked against real traffic
```

## What you get

```cards
Zone & conduit model :: /en/contact :: Your environment expressed as IEC 62443 zones and conduits, with trust boundaries made explicit.
Target reference architecture :: /en/contact :: A concrete to-be design — DMZ, data diodes where warranted, controlled data flows.
Segmentation migration plan :: /en/contact :: A phased path from where you are to the target, staged so operations never stop.
Firewall & rule baselines :: /en/contact :: Conduit rule-sets and change patterns your team can own and maintain.
```

## How it works

```timeline
1. Map flows :: Capture the real communication and data flows across your estate.
2. Define zones & conduits :: Group assets by risk and function; make every trust boundary explicit.
3. Design the target :: A reference architecture with DMZ, controlled flows and clear conduit rules.
4. Phased migration :: Move toward the target in stages that operations can absorb safely.
5. Verify :: Validate segmentation against real traffic and confirm nothing operational broke.
```

## Where it fits

This is the practical application of **IEC 62443** zones and conduits, and it underpins the network-security expectations in **NIS2**. It pairs naturally with **Secure Remote Access** and a **Cyber Digital Twin** that keeps the architecture model accurate over time.

```cta
Contain the blast radius
Design an OT architecture that limits how far an incident can spread — without stopping production.
Talk to an OT security expert :: /en/contact
```', true, 'OT Architecture & Network Segmentation | OXOT', 'Secure OT network architecture — zones, conduits and practical segmentation aligned to IEC 62443, designed to reduce blast radius without breaking production.', 'Define secure OT network architectures — zones, conduits and practical segmentation patterns aligned to IEC 62443, designed for operations.', NULL, 'page', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('capability-transfer', 'en', 'Capability Transfer', 'The best OT security engagement ends with you not needing us. Capability transfer is how OXOT makes that happen: we build the operating model, the roles, the runbooks and the confidence your internal team needs to run OT security themselves.

We embed rather than hand over a document. Your people learn by doing the work alongside us, and leave the engagement with owned capability — not a dependency.

```keyfacts
Goal :: self-sufficiency — your team owns OT security
Format :: coaching, playbooks and working side by side
Audience :: OT engineering, IT security and operations
Artefacts :: operating model, RACI, runbooks, training
Duration :: embedded across a programme, not a workshop
Outcome :: capability you keep after we leave
```

## What you get

```cards
OT security operating model :: /en/contact :: How OT security runs day to day — decisions, cadences and interfaces between OT, IT and operations.
Roles & RACI :: /en/contact :: Clear ownership: who decides, who does, who is consulted and who is informed.
Runbooks & playbooks :: /en/contact :: Repeatable procedures for the things that recur — from onboarding a vendor to responding to an alert.
Training & coaching :: /en/contact :: Your team builds the skills by doing the work with us, not by reading about it.
```

## How it works

```timeline
1. Assess capability :: Understand your current skills, structure and gaps honestly.
2. Define the target operating model :: Agree how OT security should run and who owns what.
3. Coach & document :: Work side by side; capture what you learn as runbooks and playbooks.
4. Handover :: Shift ownership to your team, with us stepping back deliberately.
5. Review :: Check in after handover to make sure the capability holds.
```

## Where it fits

Capability transfer is what makes **NIS2** governance and management accountability real — someone in your organisation genuinely owns it. It sustains the **IEC 62443** lifecycle long after any single project, and keeps a **programme** running once we step back.

```cta
Own it, don''t rent it
Build the internal capability to sustain OT security — so the improvement outlives the engagement.
Talk to an OT security expert :: /en/contact
```', true, 'OT Security Capability Transfer | OXOT', 'Build the knowledge, structure and ownership your internal team needs to sustain OT security over time — an operating model, RACI, runbooks and coaching, so you don''t depend on consultants.', 'Help internal teams build the knowledge, structure and ownership needed to maintain OT security over time.', NULL, 'page', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('cdt-fooled-by-randomness', 'en', 'Fooled by Randomness — Why "We''ve Never Had an Incident" Is Not Evidence', 'I did not read *Fooled by Randomness* looking for a cybersecurity book. I read it on a plane, years into a career spent inside substations, battery storage yards, rail control rooms, and water treatment plants across several continents, because someone had recommended it as a good book about markets. Somewhere over the Atlantic I stopped reading it as a book about markets at all. Nassim Taleb was describing, with total precision, something I had been watching my entire working life and had never had the language for. Not a metaphor. Not an analogy I was stretching to make a point. The same mathematics, the same psychology, the same structural blindness — just wearing a hard hat instead of a suit.

This piece is my attempt to lay that recognition out in full, because once you see it, you cannot stop seeing it in every audit report, every vendor pitch, and every board presentation that says a facility is secure because nothing bad has happened yet.

## What Taleb actually argued

Strip away the trading-floor color and Taleb''s thesis is simple to state and uncomfortable to accept: **humans are constitutionally bad at recognizing randomness, and we systematically mistake outcomes for skill.** We see a pattern, we build a story to explain it, and we forget that the story was written after the fact by someone who already knew the ending.

His favorite illustration is a thought experiment, and it is worth running in full because everything downstream depends on it. Take ten thousand fund managers. Give each one a fifty-fifty chance of making money in any given year — pure coin-flip odds, no skill involved at all. Run it for five years. Simple binomial math says that around three hundred of them will have made money every single year, five years running, by chance alone. Those three hundred did nothing. They flipped a coin and it came up heads five times. But they do not experience it as chance, and neither does anyone watching them. They get profiled in magazines. Business schools study their "philosophy." Institutional money flocks to their fund because the track record looks like proof of a system.

The other 9,700 managers are gone. They lost, they closed their funds, they left the industry, and — this is Taleb''s sharpest point — **they left no trace**. They are not a footnote in anyone''s case study. They do not appear in the database the next analyst pulls up to study "what winning managers have in common." Taleb calls this the cemetery: the silent evidence of everyone who ran the identical strategy and was wiped out, structurally invisible to anyone evaluating the survivors.

He carries this into a wider set of ideas that all point the same direction:

- **Survivorship bias manufactures false expertise.** We study winners and copy their habits, never seeing the much larger population that tried the same habits and failed.
- **Skewness and asymmetry are the norm, not the exception.** Many real bets are not fair coin flips — they are small, steady gains punctuated by rare, catastrophic losses. Taleb''s option sellers "eat like chickens and go to the bathroom like elephants": collecting small premiums for years, then losing it all in an afternoon when the tail event finally arrives.
- **The narrative fallacy rewrites the past.** After something happens, we build a tidy causal story to explain why it was bound to happen, and in doing so we erase how contingent and random it actually was.
- **Probability blindness runs both directions.** We overweight vivid, rare risks we can picture (a plane crash) and underweight slow-burning, statistically dominant risks we can''t (a compounding, unpatched vulnerability sitting quietly for years).
- **Optionality beats narrow cleverness.** In a nonlinear world, being positioned so good tail events help you and bad tail events can''t ruin you is worth more than being the smartest person in the room about the average case.

> [!NOTE]
> Taleb''s deepest claim is not that skill doesn''t exist. It''s that in noisy, complex domains, skill is often parasitic on randomness — riding on top of it, indistinguishable from it in the short run, and only separable from it by looking at far more trials than any one person''s career provides.

## The two sides of the table

The organizing image of the book, the one I have not been able to put down since, is what Taleb calls the two sides of the table.

One side — the left — is where the world actually operates. It is a full probability space: every outcome that could happen, weighted by how likely it is, including the fat-tailed, rare, catastrophic events that dominate real long-run results even though they almost never show up in any single stretch of history you happen to observe. The left side does not care about your story. It contains all the parallel universes where your winning streak turned into a bankruptcy, sitting right alongside the one universe you actually live in.

The other side — the right — is where people believe they operate. It is orderly, sequential, and explicable. Things happen for reasons. Effort and success are causally linked. History is a reliable teacher, because the future is assumed to look like a slightly updated version of the past. It is comfortable, socially rewarded, and almost entirely a construction of the human need for a story that makes sense.

Taleb''s argument is that the financial industry built its entire risk-management apparatus — Value-at-Risk models, backtests, Sharpe ratios, the whole professional edifice — on the right side of the table, using tools explicitly designed to confirm the narrative rather than probe the underlying distribution. And that periodically, without warning proportional to the calm that preceded it, the left side reasserts itself. LTCM in 1998. The global financial crisis in 2008. Each time, the destruction was described afterward as a failure of execution, a rogue trader, a black swan nobody could have seen. Taleb''s point is sharper than that: it was a failure of epistemology. The map described a world that had never existed, and the people using it had convinced themselves, and everyone paying them, that it had.

Formally: let X be a random variable representing some outcome — a year''s profit and loss, say. The real distribution P(X) may be heavy-tailed, skewed, dominated by rare events. The illusion that most people act on is a truncated, smoothed stand-in for P(X) — usually just its mean and standard deviation, with the tails quietly assumed away because they are inconvenient to model and psychologically unpleasant to sit with.

You cannot tell which side of the table you are actually on by looking at outcomes. Taleb''s other favorite illustration makes this vivid: two people at a casino. Person A plays a game that pays a small amount most of the time and occasionally wipes them out. They win for months, feel like a genius, and brag about their system. Person B plays a game that loses a little bit almost every time but carries a rare, explosive payout. They lose for a long stretch, get quietly written off as untalented, and then one day hit the jackpot. To any outside observer studying only the visible record, Person A looks like the expert and Person B looks like the fool. The observable history tells you almost nothing about which one actually has the better long-run bet.

## Where I''ve watched this exact thing happen — in facilities, not funds

Here is where the recognition became impossible to shake. I have stood in enough control rooms, walked enough substations, sat through enough post-incident debriefs to tell you that the language changes but the underlying error does not move an inch.

Instead of "we had a positive year," it''s "we passed the audit." Instead of "our Sharpe ratio is strong," it''s "we''re IEC 62443 compliant." Instead of "our strategy is validated by a decade of returns," it''s "we haven''t had a significant incident."

When a facility hasn''t been breached, the instinct is to read that as evidence the controls are working. What it actually is: evidence that the specific combination of adversary capability, timing, target selection, and internal vulnerability state has not yet converged into a realized attack path. The facility is sitting on one sample path through a probability space that contains thousands of other paths, some of which end in loss of control, a tripped safety system, physical damage, or worse. The absence of visible compromise tells you almost nothing about which path you''re actually on. It is Taleb''s turkey, fed every day for a thousand days and growing more confident in the arrangement with every meal, right up to the day before Thanksgiving, when the model gets revised with maximum prejudice. The compliance score does not dip the week before the breach. The audit passes. The dashboard is green. And somewhere in the gap between what the architecture diagram says should be running and what is actually installed, patched, modified, or quietly connected for operational convenience during a maintenance window three years ago, an adversary has already found the path none of the controls were built to see.

I have come to recognize a small set of illusions that recur, facility after facility, sector after sector, continent after continent:

**The reference architecture illusion.** The diagram on the wall shows a properly segmented network — IT cleanly separated from OT, the DMZ where it belongs, every connection routed through a controlled chokepoint. The diagram is accurate. It''s accurate for the system as it was designed. What''s actually running is the accumulated residue of years of operational decisions: an emergency workaround from an outage eighteen months ago, a vendor access path opened for a maintenance window and never closed, legacy equipment older than the current architecture, firmware that hasn''t been touched since commissioning. The audit checked the diagram.

**The compliance-as-security illusion.** IEC 62443, NERC CIP, NIS2, NIST CSF — these frameworks encode genuine, hard-won knowledge about how to build a defensible system, and I have no quarrel with any of them. What I reject is the quiet substitution that happens in boardrooms everywhere: conflating compliance with a framework and actual security posture. Frameworks are built from known patterns, past incidents, and consensus principles. That means, by construction, they describe the right side of the table extremely well. They cannot account for the specific, unrepeatable combination of configuration, people, software dependency, geopolitical context, and organizational culture that constitutes the actual risk surface of one facility on one Tuesday.

**The vendor survivorship illusion.** This is Taleb''s fund-manager cemetery wearing a trade-show badge. A vendor sells an endpoint product to five hundred enterprises. Perhaps four hundred and eighty go a year without a major incident — for reasons that mostly have nothing to do with the product: the threat actors were busy elsewhere that year, the attacker tried a vector the org happened to have segmented off for unrelated reasons, plain chance. Ten of those four hundred and eighty go on stage at the annual conference. *"We deployed this and haven''t had a major incident in three years."* The twenty that were breached signed NDAs, quietly replaced the product, and are not in the room. They are the silent evidence. No one at the vendor lied. The survivor on stage told the truth. The buyer in the audience — the CISO of a utility, a water authority, a battery storage operator — applied entirely reasonable judgment and still arrived at the wrong conclusion, because the method for evaluating the product only ever shows you what happened, never what could have happened to the four hundred and eighty who weren''t breached for reasons that had nothing to do with the tool.

**The "we''ve always done it this way" illusion.** Critical infrastructure has deep institutional memory, for good reason — you cannot disrupt a live process for every security theory that walks through the gate. But fifteen years of incident-free operation, in a world where the adversary environment, the software dependency chain, and the geopolitical backdrop have all shifted underneath you, tells you far less about the future than it feels like it should. You are on a sample path. The path having been smooth so far is not evidence the road ahead is smooth too.

> [!IMPORTANT]
> The absence of a breach is an outcome. It is not proof of a working system. Taleb''s warning about mistaking outcomes for skill applies with equal force whether the outcome in question is a five-year winning streak or five years without an incident report.

## Noise vs. signal, made concrete

| | What it looks like | What it actually tells you |
|---|---|---|
| **A clean audit** | Green dashboard, controls "in place" | The reference architecture was checked, not the operational reality |
| **"No incidents in three years"** | A quiet track record | One sample path avoided the disaster zone; says little about the other paths |
| **A vendor''s reference customers** | Success stories on stage | The visible survivors of a population whose failures are under NDA |
| **A penetration test with findings remediated** | A point-in-time snapshot | A single adversarial posture, tested once, against a system that keeps drifting |
| **94% security-awareness completion** | A training metric | Compliance with a policy, not evidence of behavior under real stress |
| **Board slide: 14 KPIs trending up** | A narrative of improvement | Confirmation of the story leadership already wanted to tell |

The right-hand column is the left side of the table. It is where the actual risk lives, and it is exactly the part that conventional security reporting is not built to show you.

## What building the Cyber Digital Twin taught me about taking this seriously

Recognizing the parallel is the easy part — it takes an afternoon and a plane ride. Building something that actually operationalizes it is the hard part, and it''s what my team and I have spent years doing with the OXOT [Cyber Digital Twin](/en/cyber-digital-twin).

The starting discipline is refusing the comfort of the right side of the table. Where conventional practice asks *do we have the controls in place?*, we ask a different question: given the full probability space of how an adversary could move through this specific facility, with these specific people, at this specific moment — where are we actually exposed, and by how much?

Answering that honestly means building a model of the facility that captures not what the reference architecture says should exist, but what actually exists: every piece of equipment with its real firmware, its real configuration, its real patch state, its real connectivity. It means tracing the software inside every device down through its transitive dependencies, because a vulnerability sitting five levels deep in a library nobody thinks about is exactly the kind of thing a patient adversary finds and a scheduled compliance scan never reaches. It means treating threat intelligence not as a generic TTP list but as the actual live campaigns actual adversaries are running against actual sectors right now.

And it means — this is the part the industry avoids most consistently, because it is the hardest to reduce to a checkbox — modeling the human beings inside the facility with the same rigor applied to the equipment. I have watched, in real incidents and in exercises designed to feel like real incidents, the SOC analyst who waves off the third alert because the first two were noise. The plant manager convinced the cyber team is overreacting because "these systems have run fine for twenty years." The incident commander whose own reporting structure blocks the escalation that would have mattered. The team whose collective judgment simply degrades under cognitive load at precisely the moment clarity is most needed. None of that is a character flaw. It is a predictable, measurable property of human organizations under stress, and Taleb spent his career arguing that human cognition distorts risk perception in specific, computable directions — biases and heuristics that served small groups well for most of human history and become active liabilities inside complex, nonlinear, high-consequence systems. Field experience confirms it at every scale, from the individual analyst up through the organization''s culture to the constraints built into the regulatory environment itself.

The methodology we built treats human behavior not as an unpredictable variable to be handled with a training video and a signed policy, but as a **dynamical system with its own structure, thresholds, and failure modes** — modeled with the same seriousness applied to the technical layers around it.

## The Monte Carlo mind

Taleb''s actual antidote to right-side thinking is not "think harder." It''s a change of method: run the Monte Carlo. Generate thousands of alternative histories and study the distribution of outcomes that produces, rather than staring at the single history that happened to occur. You cannot understand your true exposure by studying what happened. You have to study what *could* happen — across the full space of possibility, including the regions you haven''t visited yet and hope never to.

That is the literal design principle underneath the Cyber Digital Twin. The question we build systematic methodology to answer is not "what has gone wrong before?" It''s "in how many ways could this facility be broken, through what sequence of steps, exploiting what specific combination of technical and human vulnerability — and which of those pathways are most probable, which are most catastrophic, and what would we actually have to change to reduce the exposure, not just to pass next quarter''s audit?"

None of this is desk theory. It comes from walking the facility floor, talking to the operators who actually touch the equipment, understanding the organizational culture from the inside, mapping the software that''s genuinely running on genuine devices, and thinking adversarially about what a patient, well-resourced attacker would do with the vulnerabilities that actually exist — not the hypothetical ones a compliance framework was designed around.

The output looks nothing like a compliance report. Not a score. Not a checklist. Not a maturity rating on a five-point scale. A **probability landscape**: these are the paths most likely to succeed, ranked by consequence, given this specific facility, these specific people, this specific threat environment right now. Here is where the risk actually concentrates. Here is what would genuinely reduce it. Here is what looks impressive on paper and would move the needle by almost nothing.

## How the twin is built, in plain terms

The Cyber Digital Twin is a seven-layer graph of the facility, and the two layers that matter most for this argument are the first two, because between them they are Taleb''s two sides of the table rendered as data.

**L0 — the Equipment Catalog** is the Platonic reference: the vendor datasheet, the reference firmware, the designed configuration. It is the map, and it is a perfectly accurate map — of the world the vendor sold you, not the world you''re standing in.

**L1 — Customer Equipment** is the territory: the actual serial-numbered assets, their actual firmware versions, their actual patch states, their actual network configuration, mapped down to geo-spatial location and cross-sector interdependency. Every attack that has ever succeeded inside a hardened OT facility has exploited the gap between L0 and L1 — the delta between what was designed and what actually exists. The twin measures that gap as a first-class mathematical object rather than an unstated assumption. Every audit that checks against the reference model and returns "compliant" has committed the fundamental Talebian error: it audited the map and never surveyed the territory.

From there the graph builds outward: **L2** is the software bill of materials, traced through transitive dependencies five levels deep and enriched with exploit-probability scoring, because the vulnerability that matters is rarely the obvious one at the surface. **L3** is threat intelligence built from kill-chain modeling and live campaign attribution — the adversaries actually active against this sector and this asset class, not a generic list. **L4** is psychology: the gap between the Real threat (the actual attack surface, mostly unperceived) and the Imaginary fear (the CISO''s threat model, the risk register, the compliance score — always partial, always a little self-serving). **L5** is the real-time information environment — geopolitical events, sentiment, the news cycle that can redirect an adversary''s targeting with no warning. **L6** is prediction: breach likelihood, remediation lag, return on a given investment, expressed as a distribution with a stated confidence interval, not a single number pretending to be certain.

The engine that runs across this graph applies Monte Carlo trajectory sampling — extracting the current state, computing its rate of change, running a thousand simulated futures forward with randomized shocks and organizational resilience factored in, then aggregating the results into a posterior distribution with an explicit entropy measure and 95% confidence intervals. It generates MITRE ATT&CK-aligned attack sequences and runs them against the graph a thousand times, with randomized variation in adversary capability, timing, and human response. Each run is a parallel universe: a slightly different adversary, with slightly different tools, at a slightly different time, against your team on a slightly different day.

The output tells you something like: in 73% of simulated campaigns, the adversary reaches the Level 2 network. In 31%, they achieve persistence in the OT zone. In 8.4%, they reach a safety-critical system. In 2.1%, the combination of cyber compromise and human response failure produces a bifurcation — a state transition with no stable operating condition on the other side of it — and the 95% confidence interval on that 2.1% is [1.4%, 3.2%]. That is the left side of the table, in engineering-grade mathematics, and it is the difference between believing you are secure because a compliance score says so, and knowing the actual distribution of what happens when an adversary engages the facility you actually operate.

> [!TIP]
> A probability distribution with a confidence interval is a more honest deliverable than a single compliance score, even when the number in the distribution is worse. Taleb''s whole argument is that the discomfort of an honest number is cheaper than the catastrophe of a comforting one.

## Left side vs. right side, in a table

| | **Right side of the table** (the comforting model) | **Left side of the table** (the probabilistic reality) |
|---|---|---|
| What it models | Controls present vs. absent | Full probability distribution of attack outcomes across every layer |
| What it measures | Compliance scores, point-in-time assessments | Continuous Monte Carlo distributions with stated confidence intervals |
| How it treats humans | Training completion rates, policy sign-offs | Behavior as a dynamical system with thresholds and phase transitions |
| How it finds threats | Known CVEs, known TTPs, vendor signature updates | Randomized multi-hop simulation, including paths no analyst would think to construct |
| How it treats the future | Assumes the future resembles the past | Generates many alternative futures and shows the spread |
| What it tells the board | "We are 87% compliant" | "In 8.4% of simulated campaigns the attacker reaches a safety-critical system; here is what reduces that to 3.1%, and here is the confidence interval" |
| How it handles the unimagined | Cannot, by definition — the checklist only contains what was already checked | Actively searches for the rare, high-consequence path precisely because it''s rare |

## Why the human variable is not a soft add-on

The part of this work that draws the most skepticism, in my experience, is treating psychology as engineering. It shouldn''t be the controversial part. Taleb''s deepest point in the whole book is that randomness is not only "out there" in the market or the facility — it is *in us*, in how we perceive, rationalize, overfit patterns onto noise, and construct after-the-fact stories that make chance look like inevitability. If that is true of a fund manager staring at a P&L statement, it is at least as true of a SOC analyst staring at an alert queue at 3 a.m.

So the human layer of the twin is built to be computable rather than anecdotal. A psychometric profile for every actor in the system — defender and, where modeled, attacker — describes baseline tendencies under normal conditions and predicts how each person''s decision-making deforms under stress: which biases activate, which shortcuts take over, which lines of communication break down first. An interaction model treats a response team the way you''d treat a physical system with kinetic and potential energy: cognitive load in motion, plus the friction or flow between every pair of people working the incident together. Under calm conditions that friction is manageable. Under crisis conditions it can spike the same way asset correlations spike to one during a market crash — everything that looked independent suddenly moves together, and not in a good direction.

There is an organizational-culture model that borrows the mathematics of a phase transition: below a critical level of stress, an organization''s security culture "locks in" — people follow procedure, escalate what should be escalated, hold vigilance. Above that critical threshold — staff turnover, budget pressure, alert fatigue, a distracted leadership team — the coherence breaks down, individuals start acting inconsistently, and the organization can no longer sustain a coordinated response regardless of how much technology sits on the network. And this is the unsettling part: the organization looks identical on paper in both states. The compliance score doesn''t move. The vendor stack is unchanged. But the human system has crossed a threshold, and the capacity to respond in concert has quietly evaporated. It is Taleb''s turkey again, just measured with a different instrument: confidence peaks the day before the knife, because confidence was never actually tracking risk.

There is also a cascade model for how a compromise spreads — the mathematics of a contagion crossing the point where it becomes self-sustaining, needing no further input from the adversary to keep growing — and a model for the approach to a genuine crisis point, where two possible outcomes for the system (a stable state and an unstable boundary) converge and disappear, after which there is no stable state left to return to. The distance to that point shrinks nonlinearly as you approach it, which is exactly why these events feel sudden from the inside: the system was drifting toward the edge for months, and the visible warning signs only became legible in the final stretch of the approach.

None of this is offered as decoration. It is what it takes to stop treating "the human factor" as an unmodeled wildcard managed with a training video, and start treating it as what it actually is: a variable with structure, thresholds, and failure modes, sitting inside the same simulation as the firewalls and the firmware.

## What the old assumptions get wrong

Conventional OT/ICS security rests on five assumptions that are, in Taleb''s framework, epistemologically identical to the assumptions that preceded the worst blowups in financial history:

1. **The past is representative of the future.** If controls have prevented breaches for three years, they are assumed to be working.
2. **Risk is additive and linear.** Add more controls, get proportionally more security.
3. **Compliance implies security.** If the audit says the standard is met, the facility is assumed protected.
4. **The threat landscape is knowable.** Monitor the right feeds, follow the right framework, and the defending team assumes it knows what it''s up against.
5. **Human behavior is a constant.** The team is assumed to respond to the next real incident the way it responded to the last tabletop exercise.

Every one of those lives on the right side of the table. And the corrected version of each is not a nicer story — it''s a harder one:

1. **The past is one sample path.** Three years without a breach is a single trajectory through the probability space. Run the Monte Carlo and most of the other trajectories contain breaches; some contain catastrophes. History tells you almost nothing about future risk.
2. **Risk is nonlinear and correlated.** A firewall that blocks one path can create a false sense of security that erodes vigilance on the adjacent paths. There are real phase transitions where adding complexity increases net risk rather than reducing it.
3. **Compliance is the map; the facility is the territory.** The distance between the two is large in most facilities, growing, and invisible to every compliance tool currently on the market.
4. **The threat landscape includes what you cannot yet imagine.** A simulation built to generate randomized sequences finds paths no human analyst would think to construct, because they live in regions of the state space that haven''t shown up in any feed — precisely because they haven''t happened yet.
5. **Human behavior is a dynamical system with phase transitions**, a function of stress, organizational temperature, cognitive load, and interpersonal dynamics that changes *during* the incident in ways that are mathematically predictable at the population level, even if unpredictable for any one individual.

## Asymmetric positioning: NOW / NEXT / NEVER

Taleb doesn''t counsel paralysis in the face of all this uncertainty. He counsels asymmetric positioning — structuring your exposure so catastrophic downside is bounded and upside stays open, favoring strategies where the worst case is survivable over strategies that look good on average but carry a hidden chance of ruin.

That translates directly into how we prioritize investment once the simulation has run. We call it **NOW / NEXT / NEVER**, and it deliberately does not rank the same way a compliance checklist would.

**NOW** is the small number of attack paths that show up across a high share of simulations, reach a high-consequence target, and are fixable at reasonable cost. These are rarely what a compliance framework would flag first. They are what the probability distribution flags first, and the case for acting on them comes with a stated confidence interval, not a hunch.

**NEXT** is structural change: segmentation that reduces the network''s largest eigenvalue and slows contagion, SBOM remediation aimed at the highest-centrality dependency nodes, organizational changes that strengthen the human bridges that tend to snap first under stress, engineering controls that add real barriers between the cyber domain and the physical process.

**NEVER** is everything that scores well on a checklist and moves the simulated risk by almost nothing — the vendor products whose reference customers are survivorship-biased anecdotes, the "best practices" that are best for the average facility on the right side of the table and irrelevant to your specific facility on the left, the awareness training that treats human cognition as a constant when the organizational-temperature model shows you are already close to the point where that assumption stops holding.

Because you cannot do infinite work, and pretending you can is itself a right-side-of-the-table delusion — just a more expensive one.

## What choosing this actually means

When you evaluate a Cyber Digital Twin approach against a conventional security program, you are not choosing between two products. You are choosing between two answers to the same question: *how do I know if I am secure?*

The conventional answer says: I am secure because I have the controls the framework asks for, and the audit confirms it. The answer built on Taleb''s worldview says something less comfortable and more honest: here is the probability distribution of what happens when a real adversary engages this specific facility, here is where the risk concentrates, here is the confidence interval, and here is what would actually move the number.

Frameworks like [IEC 62443](/en/iec-62443) and [NIS2](/en/nis2) are not the enemy in this picture — they encode real, hard-earned knowledge, and no serious operator should ignore them. But they were built to describe the right side of the table well, and they were never going to be able to describe the left side, because the left side is specific to your equipment, your people, your patch history, and this week''s geopolitics — not to the average facility the framework had to be written for. See our broader [Frameworks](/en/frameworks) overview for how these standards relate to one another and where each one''s blind spots sit.

```cta
Would you rather see your own probability landscape than argue about averages?
The Cyber Digital Twin turns your OT estate into a model you can stress-test — so the few paths that reach a safety-critical system show up before an attacker finds them.
See your probability landscape :: /en/contact
```

## The bottom line

Nassim Taleb spent his career arguing that the financial world was systematically fooling itself — that the tools it used to measure risk were quietly built to hide risk instead, that the narratives constructed to explain success were artifacts of survivorship bias, and that the only honest position was the uncomfortable one: full probability space, epistemic humility, mathematical rigor, no shortcuts back to a comforting story.

Critical infrastructure security has made every mistake he identified, at higher stakes, because the failure mode here is not a blown-up fund. It''s a tripped safety system, a contaminated water supply, a grid that doesn''t come back on. The [Cyber Digital Twin](/en/cyber-digital-twin) is not a promise that your facility is safe — nothing honest can promise that. It is an attempt to tell you, with as much precision and as much stated uncertainty as the mathematics allow, how unsafe it actually is, where, along which paths, with what probability, and what would genuinely change that number — prioritized by data, bounded by confidence intervals, not by which vendor got the loudest stage time this year.

The threats to critical infrastructure are not going to become simpler or more predictable. The systems the world depends on are not going to become less networked, less automated, or less targeted. The only real question is whether the people responsible for defending them choose the comfort of the right side of the table, or do the harder, more honest work of the left.

The randomness is not the enemy. Pretending it doesn''t exist is.

## Sources & further reading

This piece draws on Nassim Nicholas Taleb''s *Fooled by Randomness* (2001) — its treatment of survivorship bias, the narrative fallacy, skewed payoff structures, and the "two sides of the table" — and on OXOT''s internal Cyber Digital Twin architecture briefs describing the seven-layer graph, the Monte Carlo prediction pipeline, and the NOW/NEXT/NEVER prioritization framework. For the underlying technology, see [Cyber Digital Twin](/en/cyber-digital-twin); for the standards landscape this approach sits alongside, see [IEC 62443](/en/iec-62443), [NIS2](/en/nis2), and [Frameworks](/en/frameworks).', true, 'Fooled by Randomness in OT Security | OXOT', 'Taleb showed markets confuse luck with skill. OT security makes the same error — here''s how the Cyber Digital Twin measures risk a clean audit can''t see.', 'A clean audit and a quiet year are not proof your OT security works — they are one sample path through a much larger space of outcomes, and the Cyber Digital Twin exists to show you the rest of that space.', NULL, 'article', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('ot-security-assessments', 'en', 'OT Security Assessments', 'An OT security assessment from OXOT starts where your risk actually lives: on the plant floor. We reason about process, safety and continuity first — not office IT copied onto operational technology. The goal is not another binder of findings, but a clear, prioritised picture of where you stand and what to do next, backed by evidence you own.

We work passive-first. Discovery is designed to run without disrupting production, and every conclusion traces back to something observable in your environment — not an assumption.

```keyfacts
Scope :: a site, a line or a defined zone — your choice
Duration :: typically 2–6 weeks depending on scope
Basis :: IEC 62443-3-2 risk assessment + your operational risk
Approach :: passive-first — no production impact
Output :: a prioritised risk register and a defensible roadmap
Deliverable :: decisions you can defend to a board or a regulator
```

## What you get

```cards
Asset & zone picture :: /en/contact :: A clear inventory of assets, connections and zones — the map most OT environments are missing.
Prioritised risk register :: /en/contact :: Risks ranked by impact to safety, continuity and production, not by raw CVSS.
Quick wins vs. structural fixes :: /en/contact :: A short list you can act on now, separated from the deeper investments that need a programme.
Board-ready summary :: /en/contact :: One page your leadership and auditors can actually use to make decisions.
```

## How it works

```timeline
1. Scope & safety :: Agree the boundary, the crown jewels, and the rules of engagement — safety first.
2. Passive discovery & interviews :: Observe traffic and assets without touching production; talk to the people who run the plant.
3. Risk analysis :: Map findings to zones and conduits and rank them by operational impact (IEC 62443-3-2).
4. Findings workshop :: Walk your team through what we found and agree priorities together.
5. Roadmap :: A sequenced set of actions — quick wins first, structural fixes staged.
```

## Where it fits

An OXOT assessment is structured around **IEC 62443-3-2** risk assessment, and its output feeds directly into your **NIS2** risk-management obligations and any **Cyber Resilience Act** product work. It is also the natural first step before a security **baseline**, a **programme**, or a **Cyber Digital Twin**.

```cta
Start with an assessment
Get a clear, defensible picture of your OT security posture — scoped to one site to begin.
Talk to an OT security expert :: /en/contact
```', true, 'OT Security Assessments | OXOT', 'An OT-first security assessment that starts from your plant, not a generic checklist — asset and zone visibility, a prioritised risk register, and a defensible roadmap aligned to IEC 62443 and NIS2.', 'Understand your current OT security posture, the risks that actually matter, and the practical next steps — scoped to your operational reality.', NULL, 'page', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('ot-security-baseline', 'en', 'OT Security Baseline', 'A baseline is the floor everyone has to meet — the controls that must be true everywhere before you argue about the advanced stuff. OXOT defines an OT security baseline that is realistic for your plants, repeatable across sites, and mapped to IEC 62443 security levels, so "secure enough" means the same thing everywhere.

The point is consistency and evidence: a baseline you can roll out site by site, prove you''ve met, and hand to an auditor without a scramble.

```keyfacts
Purpose :: a minimum standard every site can actually meet
Basis :: IEC 62443 target security levels (SL-1 / SL-2)
Scope :: defined per zone and asset class
Format :: a control checklist with evidence requirements
Rollout :: applied site by site, with an exception process
Outcome :: consistent, auditable OT security
```

## What you get

```cards
Tailored control baseline :: /en/contact :: A minimum control set written for your environment and risk appetite, not a generic template.
Per-zone applicability :: /en/contact :: Which controls apply where — mapped to zones and asset classes, so it''s realistic on the plant floor.
Evidence templates :: /en/contact :: Simple, repeatable ways to prove each control is in place.
Rollout & exception process :: /en/contact :: A path to apply the baseline site by site, and a disciplined way to handle exceptions.
```

## How it works

```timeline
1. Define :: Set the target security levels and the controls that make up the floor.
2. Tailor :: Adapt the baseline to your zones, asset classes and operational constraints.
3. Pilot :: Apply it at one site and refine what''s practical.
4. Roll out :: Extend site by site, tracking coverage and exceptions.
5. Assure :: Collect evidence and confirm the baseline holds over time.
```

## Where it fits

A baseline expresses your **IEC 62443** target security levels concretely, satisfies the **NIS2** requirement for appropriate minimum measures, and gives product teams a **Cyber Resilience Act** starting point. It''s the natural companion to an **assessment** and the backbone of a **programme**.

```cta
Set the floor, everywhere
Define an OT security baseline that''s realistic to meet and simple to prove.
Talk to an OT security expert :: /en/contact
```', true, 'OT Security Baseline | OXOT', 'A minimum set of OT security controls that are realistic, repeatable and aligned to how your plants actually run — a defensible floor mapped to IEC 62443 security levels, NIS2 minimum measures and the CRA.', 'Define minimum security controls that are realistic, repeatable and aligned with operational needs.', NULL, 'page', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('ot-security-programmes', 'en', 'OT Security Programmes', 'Most organisations don''t lack findings — they lack a way to deliver on them. An OXOT security programme turns a pile of recommendations into a sequenced, governed, multi-site effort that produces measurable risk reduction, not just activity.

We prioritise by operational risk, work in waves you can absorb, and report progress in terms your board and regulators understand. The result is a programme your own team increasingly owns.

```keyfacts
Horizon :: typically 12–36 months, staged in waves
Scope :: across sites, business units or regions
Governance :: a steering model with clear KPIs
Basis :: risk-based prioritisation, IEC 62443 lifecycle
Model :: an owned Cyber Digital Twin keeps priorities current
Outcome :: measurable, reportable risk reduction
```

## What you get

```cards
Programme plan & business case :: /en/contact :: A costed, sequenced plan tied to risk reduction — something leadership can fund with confidence.
Governance & KPIs :: /en/contact :: A steering structure, roles and metrics so the programme stays on track and accountable.
Prioritised remediation backlog :: /en/contact :: Every action ranked by operational impact, grouped into deliverable waves.
Board-level reporting :: /en/contact :: Progress and residual risk in language your leadership and auditors can act on.
```

## How it works

```timeline
1. Mobilise :: Stand up governance, confirm scope and baseline the current risk picture.
2. Prioritise :: Rank the backlog by operational impact and sequence it into waves.
3. Execute in waves :: Deliver improvements site by site, absorbing change at a rate operations can sustain.
4. Measure :: Track risk reduction against the baseline and report it up.
5. Sustain :: Transfer ownership so the programme keeps running without external dependence.
```

## Where it fits

A programme operationalises **NIS2** governance and management accountability, and runs improvements across the full **IEC 62443** lifecycle. It typically follows an **assessment** and is anchored by a **Cyber Digital Twin** so priorities stay current as your estate changes.

```cta
Turn findings into delivery
Give your OT security effort the governance, sequencing and evidence it needs to succeed.
Talk to an OT security expert :: /en/contact
```', true, 'OT Security Programmes | OXOT', 'Turn assessment findings into a structured, multi-site OT security improvement programme that actually gets delivered — governance, KPIs, a prioritised backlog and measurable risk reduction.', 'Design and execute structured OT security improvement programmes across sites, business units or regions — with governance and measurable outcomes.', NULL, 'page', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('secure-remote-access', 'en', 'Secure Remote Access', 'Remote access is where most OT incidents start: OEM maintenance tunnels, forgotten vendor accounts, and connectivity that grew organically and was never inventoried. OXOT replaces that sprawl with least-privilege, brokered, monitored access — designed so maintenance still gets done.

Every path in and out is inventoried, every session is authenticated and recorded, and vendors get exactly the access they need, only when they need it.

```keyfacts
Problem :: vendor/OEM access sprawl, no single inventory
Principle :: least privilege, brokered, always monitored
Coverage :: employees, vendors and OEMs
Controls :: MFA, just-in-time access, session recording
Standard :: IEC 62443 access control, NIS2 supply-chain
Outcome :: fully auditable remote access
```

## What you get

```cards
Remote access inventory :: /en/contact :: Every path into OT — who, from where, to what — with the risk of each made visible.
Brokered access design :: /en/contact :: A single, controlled entry point that mediates and records every session.
MFA, JIT & session recording :: /en/contact :: Strong authentication, time-boxed access and a full record of what was done.
Vendor access policy :: /en/contact :: Clear rules for OEMs and third parties that your team can enforce and audit.
```

## How it works

```timeline
1. Inventory access :: Find and document every remote path into your OT environment.
2. Design the brokered model :: A single mediated entry point with least-privilege by default.
3. Pilot :: Prove the model with one vendor or one site before scaling.
4. Roll out :: Migrate access paths onto the brokered model and retire the rest.
5. Monitor :: Record sessions and review access continuously.
```

## Where it fits

Secure remote access directly serves **IEC 62443** access-control requirements and the **NIS2** supply-chain and access-management expectations. It works hand in hand with **Architecture & Segmentation** — the broker sits at a controlled conduit between zones.

```cta
Close the most common way in
Turn remote access from your biggest exposure into a controlled, auditable capability.
Talk to an OT security expert :: /en/contact
```', true, 'Secure OT Remote Access | OXOT', 'Reduce risk from vendor access, remote maintenance and external connectivity to OT — least-privilege, brokered, monitored access with MFA, just-in-time and session recording, aligned to IEC 62443 and NIS2.', 'Reduce risk from vendor access, remote maintenance and external connectivity — without breaking operations.', NULL, 'page', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('ts-50701', 'en', 'TS 50701 — Railway Cybersecurity', 'A modern train is a data centre on wheels running through a network that stretches across an entire country. Signalling interlockings, on-board control units, traffic-management systems, passenger information, trackside sensors, remote maintenance links — all of it now digital, much of it connected, and every piece expected to keep working safely for thirty years or more. Rail is one of the hardest places on earth to do cybersecurity: safety-critical, geographically sprawling, assembled from a long chain of suppliers, and governed by a safety culture that predates the internet.

For a long time, rail had no cybersecurity standard of its own. Engineers borrowed generic industrial guidance, stretched it over railway architecture, and hoped the fit was close enough. **CLC/TS 50701 ended that improvisation.** Published in July 2021, it is the first cybersecurity specification written specifically for railway applications, and it has become the reference point for securing signalling, control-command, rolling stock and rail infrastructure across Europe and beyond.

## The short version

- **CLC/TS 50701** is a CENELEC Technical Specification for **cybersecurity in railway applications**. Its first edition was published in **July 2021** — the world''s first comprehensive cybersecurity specification built for rail. A **second edition (CLC/TS 50701:2023)** followed in August 2023. ([CLC/TS 50701:2023 guide, iTeh](https://standards.iteh.ai/catalog/standards/clc/db257ea9-8ba0-4f4c-a791-df34a6030541/clc-ts-50701-2023))
- It is **not standalone**. It **applies the [IEC 62443](/en/iec-62443) series** to the railway context, adapting its security models, concepts and risk-assessment process — leaning especially on **IEC 62443-3-2** and **62443-3-3**. ([ENISA / CENELEC](https://www.enisa.europa.eu/sites/default/files/all_files/05-standards-02-cenelec-christian-schlehuber.pdf))
- It integrates with the railway **RAMS lifecycle** defined in **EN 50126-1**, so cybersecurity is engineered alongside reliability, availability, maintainability and safety — not bolted on afterwards.
- It was authored by **CENELEC TC 9X/WG 26**, a working group of dozens of European rail and security experts, and now feeds directly into the coming **international standard IEC 63452**. ([Alstom](https://www.alstom.com/press-releases-news/2024/3/towards-first-railway-cybersecurity-international-standard-why-standards-are-important-secure-railways))

> [!NOTE]
> A note on naming. You will see this document written as **CLC/TS 50701**, **TS 50701**, or with a year suffix (**:2021**, **:2023**). "CLC" marks it as a CENELEC deliverable; "TS" marks it as a Technical Specification rather than a full European Norm. The 2021 first edition and the 2023 second edition are the same document maturing, not two competing standards.

```keyfacts
Type :: CENELEC Technical Specification (CLC/TS) — not a full EN
First edition :: July 2021 — world''s first rail-specific cybersecurity spec
Current edition :: CLC/TS 50701:2023
Built on :: IEC 62443 (esp. 3-2, 3-3, 4-2, 4-1)
Safety lifecycle :: integrates with EN 50126-1 (RAMS)
Scope domains :: Communications · Signalling & Processing · Rolling Stock · Fixed Installations
Safety–security bridge :: CSM-RA + IEC 62443-3-3
Authored by :: CENELEC TC 9X/WG 26
Becoming :: IEC 63452 — the first international rail cybersecurity standard
Regulatory pull :: NIS2 (essential entities) + CRA (products with digital elements)
```

## Why rail needed its own specification

Rail lives at the intersection of two worlds that rarely speak the same language.

On one side sits a mature, deeply codified **safety** discipline. The CENELEC EN 5012x family — EN 50126 for the RAMS lifecycle, EN 50128/EN 50716 for software, EN 50129 for safety-related electronic systems — has governed how the industry proves its systems are safe for decades. It is rigorous, evidence-driven, and built around a single guiding question: will this system fail dangerously?

On the other side sits **cybersecurity**, a faster-moving field shaped first by IT and then by generic industrial control systems. Its guiding question is different: can an adversary make this system do something it should not?

Neither world fit rail on its own. The safety standards were written for random failures and human error, not deliberate, intelligent attackers who probe, adapt and wait. Generic security standards, meanwhile, knew nothing of the RAMS lifecycle, the peculiar architecture of interlockings and balises, or the fact that a firewall rule tightened for security reasons could, if it dropped the wrong packet, degrade a safety function.

TS 50701 was written to close that gap. It takes the proven machinery of [IEC 62443](/en/iec-62443) — zones and conduits, security levels, a structured risk-assessment process — and re-expresses it in terms a railway engineer already recognises, wired directly into the safety lifecycle they already follow. Its stated aim is blunt and worth quoting in spirit: to ensure that the RAMS characteristics of railway systems cannot be reduced, lost or compromised by an intentional attack. ([Shieldworkz](https://shieldworkz.com/blogs/a-deep-dive-into-cenelec-ts-50701-for-railway-cybersecurity))

> [!IMPORTANT]
> The premise underneath the whole specification: in rail, **if a system is not secure, its safety cannot be guaranteed.** Security is not adjacent to safety here. It is a precondition for it.

## Built on IEC 62443

TS 50701 does not reinvent cybersecurity engineering — it inherits it. The specification is explicit that its security models, concepts and risk-assessment process are based on or derived from the [IEC 62443](/en/iec-62443) series. Two parts do most of the heavy lifting.

- **IEC 62443-3-2 — Security risk assessment for system design.** This is the source of the zones-and-conduits methodology and the workflow that produces a target security level for each zone. TS 50701 adopts this risk process almost wholesale, then adapts it to railway realities.
- **IEC 62443-3-3 — System security requirements and security levels.** This supplies the catalogue of technical requirements grouped under the seven **foundational requirements** (identification and authentication, use control, system integrity, data confidentiality, restricted data flow, timely response to events, resource availability), and the SL-1 through SL-4 scale that says how strong protection must be.

Component-level work reaches further into the series — **IEC 62443-4-2** for the technical security requirements of individual products, and **IEC 62443-4-1** for the secure development lifecycle a supplier follows. TS 50701 also draws in a threat library to feed the assessment; later editions cite **MITRE ATT&CK for ICS** as an example. ([iTeh](https://standards.iteh.ai/catalog/standards/clc/db257ea9-8ba0-4f4c-a791-df34a6030541/clc-ts-50701-2023))

The table below maps the relationship part by part.

| IEC 62443 part | What it provides | How TS 50701 uses it |
| --- | --- | --- |
| 62443-1-1 | Concepts, terminology, models | Baseline vocabulary — zones, conduits, security levels — carried into rail |
| 62443-2-1 | Security management system for the asset owner | Informs how operators and infrastructure managers run their programme |
| 62443-3-2 | Risk assessment for system design | Core of the TS 50701 risk process; adapted to railway assets and the RAMS lifecycle |
| 62443-3-3 | System security requirements & security levels | Requirement catalogue and SL 1–4 scale, referenced alongside safety methods |
| 62443-4-1 | Secure product development lifecycle | Expectation placed on suppliers building rail components |
| 62443-4-2 | Component technical security requirements | Referenced directly for component-level specification and testing |

> [!TIP]
> If your organisation already understands [IEC 62443](/en/iec-62443), you are most of the way to understanding TS 50701. The engineering logic is identical; what changes is the vocabulary of the assets and the lifecycle you plug it into. Work done for one is transferable to the other.

### The seven foundational requirements, in railway terms

The requirement catalogue TS 50701 inherits from IEC 62443-3-3 is organised under **seven foundational requirements (FRs)**. They sound abstract until you translate each into a railway asset — at which point they become an inspection checklist for a signalling estate.

| FR | IEC 62443 name | What it means on the railway |
| --- | --- | --- |
| **FR 1** | Identification & authentication control | Every maintainer, engineer and remote tool that touches an interlocking or on-board unit is uniquely identified and authenticated — no shared "maintenance" logins on safety-critical kit |
| **FR 2** | Use control | An authenticated user can do only what their role permits; a diagnostic session cannot become a route-setting command |
| **FR 3** | System integrity | Signalling logic, ETCS data and firmware cannot be altered undetected — integrity checks and signed updates guard the safety function |
| **FR 4** | Data confidentiality | Timetables, keys and configuration in transit over trackside or radio links are protected from disclosure where disclosure would enable an attack |
| **FR 5** | Restricted data flow | Zones and conduits enforce that a passenger network cannot reach a signalling zone; the conduit is the only path, and it is controlled |
| **FR 6** | Timely response to events | The estate can detect and log a security event on a lineside controller and respond before it becomes a safety event |
| **FR 7** | Resource availability | Denial-of-service against a traffic-management system or a train-control network cannot be allowed to degrade availability — the RAMS "A" is a security target too |

The higher the target security level of a zone, the more of each FR''s requirement enhancements apply — which is exactly how a signalling interlocking (SL-3/SL-4) ends up with far stricter controls than a passenger-information display (SL-1/SL-2), even though both are assessed against the same seven headings.

```svg
<svg viewBox="0 0 700 430" xmlns="http://www.w3.org/2000/svg" font-family="system-ui, sans-serif">
  <rect width="700" height="430" fill="none"/>
  <text x="350" y="30" fill="#e5e7eb" font-size="19" font-weight="700" text-anchor="middle">TS 50701 — what it stands on, what it plugs into</text>

  <!-- Foundation: IEC 62443 -->
  <rect x="70" y="330" width="560" height="70" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="350" y="360" fill="#e5e7eb" font-size="15" font-weight="700" text-anchor="middle">IEC 62443 series — foundation</text>
  <text x="350" y="382" fill="#94a3b8" font-size="12" text-anchor="middle">zones &amp; conduits · security levels SL 1–4 · risk process (3-2, 3-3, 4-2)</text>

  <!-- TS 50701 middle layer -->
  <rect x="130" y="200" width="440" height="90" rx="8" fill="none" stroke="#f97316" stroke-width="2.5"/>
  <text x="350" y="235" fill="#e5e7eb" font-size="17" font-weight="700" text-anchor="middle">CLC/TS 50701</text>
  <text x="350" y="258" fill="#94a3b8" font-size="12" text-anchor="middle">IEC 62443 adapted to rail · manages the safety–security interface</text>
  <text x="350" y="276" fill="#94a3b8" font-size="12" text-anchor="middle">railway asset types · railway threat &amp; consequence model</text>

  <!-- Top left: RAMS lifecycle -->
  <rect x="70" y="70" width="250" height="90" rx="8" fill="none" stroke="#94a3b8" stroke-width="2"/>
  <text x="195" y="100" fill="#e5e7eb" font-size="14" font-weight="700" text-anchor="middle">EN 50126 RAMS lifecycle</text>
  <text x="195" y="122" fill="#94a3b8" font-size="12" text-anchor="middle">security woven into the</text>
  <text x="195" y="138" fill="#94a3b8" font-size="12" text-anchor="middle">phases rail already uses</text>

  <!-- Top right: regulation -->
  <rect x="380" y="70" width="250" height="90" rx="8" fill="none" stroke="#94a3b8" stroke-width="2"/>
  <text x="505" y="100" fill="#e5e7eb" font-size="14" font-weight="700" text-anchor="middle">Regulation &amp; safety method</text>
  <text x="505" y="122" fill="#94a3b8" font-size="12" text-anchor="middle">NIS2 · CRA · CSM-RA</text>
  <text x="505" y="138" fill="#94a3b8" font-size="12" text-anchor="middle">obligations rail must meet</text>

  <!-- connectors -->
  <line x1="350" y1="330" x2="350" y2="290" stroke="#3b82f6" stroke-width="2" marker-end="url(#ar)"/>
  <line x1="250" y1="200" x2="220" y2="160" stroke="#94a3b8" stroke-width="2" marker-end="url(#ar)"/>
  <line x1="450" y1="200" x2="480" y2="160" stroke="#94a3b8" stroke-width="2" marker-end="url(#ar)"/>

  <defs>
    <marker id="ar" markerWidth="9" markerHeight="9" refX="7" refY="4.5" orient="auto">
      <path d="M0,0 L9,4.5 L0,9 Z" fill="#94a3b8"/>
    </marker>
  </defs>
</svg>
```

## Integration with the RAMS lifecycle

What makes TS 50701 unmistakably a *railway* document, rather than IEC 62443 with a new cover, is how it locks into **EN 50126-1** — the standard that defines the RAMS lifecycle: Reliability, Availability, Maintainability and Safety. Rather than run a separate, parallel cybersecurity process off to one side, TS 50701 embeds security into the same phases the railway already uses to specify, design, verify, accept and operate a system. ([Cylus](https://www.cylus.com/post/navigating-ts-50701-unpacking-the-impact-of-the-cybersecurity-standard-for-rail))

The point is not administrative tidiness. It is that a security decision made in isolation from the safety lifecycle is a security decision made blind. By threading through EN 50126, the specification forces security and safety engineers to reach the same design gates at the same time, looking at the same system.

| EN 50126 lifecycle phase | What happens for safety | What TS 50701 adds for security |
| --- | --- | --- |
| Concept | Define system purpose and context | Establish cybersecurity context, high-level assets and threat landscape |
| Risk analysis & evaluation | Hazard identification, safety risk assessment | Cybersecurity risk assessment; define zones, conduits, target security levels |
| Specification of requirements | Derive RAMS requirements | Derive cybersecurity requirements from target SLs and the threat model |
| Design & implementation | Build to safety requirements | Apply security controls; check they do not undermine safety functions |
| Manufacture / integration | Assemble and integrate | Verify component security requirements (IEC 62443-4-2 references) |
| Validation & acceptance | Demonstrate RAMS is met | Demonstrate security requirements are met; document residual risk |
| Operation & maintenance | Keep the system safe in service | Vulnerability management, patching, monitoring, incident response |
| Decommissioning | Retire safely | Secure disposal, key and data destruction, revocation |

> [!NOTE]
> Because TS 50701 can be applied to systems developed **inside or outside** the EN 50126-1 process, it is usable for legacy estates and greenfield builds alike. Older assets rarely followed the modern RAMS lifecycle to the letter, but the risk logic still applies.

## The safety–security interface

This is the part of TS 50701 that has no equivalent in generic OT security standards, and the reason a railway needs a railway specification.

In most industries, safety and security can be reasoned about in relative isolation. In rail they are entangled. A control introduced to improve security can degrade a safety function — add latency to a safety-critical message path, block a diagnostic channel a safety system depends on, or lock out an operator during an emergency. Conversely, a safety measure can open or close a security exposure — a "fail-safe" default that drops to a known state might be exactly the state an attacker wants to force.

TS 50701 gives this interface a formal home. It requires that cybersecurity work take into account relevant safety-related aspects, and it draws on established safety machinery — notably the **Common Safety Method for Risk Assessment (CSM-RA)**, the EU regulation that governs how significant changes to the railway system are risk-assessed — alongside security sources such as IEC 62443-3-3. ([Shieldworkz](https://shieldworkz.com/blogs/a-deep-dive-into-ts-50701-based-risk-and-security-assessment)) The specification''s later editions go further, recommending **joint design reviews** so that safety and security engineers assess changes together rather than in sequence.

The contrast between the two disciplines is worth laying out plainly, because managing the interface means respecting where they differ.

| Concern | Safety (EN 5012x world) | Security (IEC 62443 world) |
| --- | --- | --- |
| Primary threat | Random failure, systematic fault, human error | Deliberate, adaptive adversary |
| Guiding question | Will it fail dangerously? | Can it be made to misbehave? |
| Timescale | Fixed once certified; stable for years | Threat landscape shifts continuously |
| Evidence | Safety case, hazard log, formal proof | Risk assessment, controls, monitoring, testing |
| Change | Tightly controlled, re-certified | Expected and frequent (patches, updates) |
| Failure mode | Move to a known safe state | Deny the adversary an objective |

> [!WARNING]
> The classic rail trap is treating a security patch like a routine IT update. In a safety-critical system, a change that alters timing or behaviour can invalidate the safety case. TS 50701''s insistence on a managed safety–security interface exists precisely so that a well-intentioned security action does not quietly become a safety hazard.

```compare
The security instinct
- **Patch fast** — a known vulnerability is an open door; close it now
- Change is **expected and frequent**; the estate should be easy to update
- Success = the adversary is denied an objective
- The threat landscape **shifts weekly**; controls must keep pace
---
The rail-safety reality
- A patch can **alter timing or behaviour** and invalidate a certified safety case
- Change is **tightly controlled** and may require re-validation or re-certification
- Success = the system still **fails to a known safe state**
- The safety argument is **stable for years** by design
```

Neither instinct is wrong; the discipline TS 50701 imposes is to reconcile them deliberately, at a defined interface, rather than let one quietly override the other. A patch reaches a safety-critical zone only after a joint review has confirmed it does not disturb the safety case — and the fact that it *was* reviewed is itself part of the evidence.

```svg
<svg viewBox="0 0 700 380" xmlns="http://www.w3.org/2000/svg" font-family="system-ui, sans-serif">
  <rect width="700" height="380" fill="none"/>
  <text x="350" y="30" fill="#e5e7eb" font-size="18" font-weight="700" text-anchor="middle">Railway risk assessment — the TS 50701 flow</text>

  <!-- boxes -->
  <g>
    <rect x="30" y="70" width="150" height="60" rx="7" fill="none" stroke="#3b82f6" stroke-width="2"/>
    <text x="105" y="95" fill="#e5e7eb" font-size="12.5" font-weight="700" text-anchor="middle">Define system</text>
    <text x="105" y="113" fill="#94a3b8" font-size="11" text-anchor="middle">under consideration</text>
  </g>
  <g>
    <rect x="210" y="70" width="150" height="60" rx="7" fill="none" stroke="#3b82f6" stroke-width="2"/>
    <text x="285" y="95" fill="#e5e7eb" font-size="12.5" font-weight="700" text-anchor="middle">Partition into</text>
    <text x="285" y="113" fill="#94a3b8" font-size="11" text-anchor="middle">zones &amp; conduits</text>
  </g>
  <g>
    <rect x="390" y="70" width="150" height="60" rx="7" fill="none" stroke="#3b82f6" stroke-width="2"/>
    <text x="465" y="95" fill="#e5e7eb" font-size="12.5" font-weight="700" text-anchor="middle">Assess threats</text>
    <text x="465" y="113" fill="#94a3b8" font-size="11" text-anchor="middle">&amp; consequences</text>
  </g>
  <g>
    <rect x="390" y="180" width="150" height="60" rx="7" fill="none" stroke="#f97316" stroke-width="2"/>
    <text x="465" y="205" fill="#e5e7eb" font-size="12.5" font-weight="700" text-anchor="middle">Set target</text>
    <text x="465" y="223" fill="#94a3b8" font-size="11" text-anchor="middle">security levels</text>
  </g>
  <g>
    <rect x="210" y="180" width="150" height="60" rx="7" fill="none" stroke="#f97316" stroke-width="2"/>
    <text x="285" y="205" fill="#e5e7eb" font-size="12.5" font-weight="700" text-anchor="middle">Specify security</text>
    <text x="285" y="223" fill="#94a3b8" font-size="11" text-anchor="middle">requirements</text>
  </g>
  <g>
    <rect x="30" y="180" width="150" height="60" rx="7" fill="none" stroke="#f97316" stroke-width="2"/>
    <text x="105" y="205" fill="#e5e7eb" font-size="12.5" font-weight="700" text-anchor="middle">Verify &amp; document</text>
    <text x="105" y="223" fill="#94a3b8" font-size="11" text-anchor="middle">residual risk</text>
  </g>

  <!-- safety-security interface band -->
  <rect x="30" y="290" width="510" height="60" rx="7" fill="none" stroke="#94a3b8" stroke-width="2" stroke-dasharray="6 4"/>
  <text x="285" y="315" fill="#e5e7eb" font-size="13" font-weight="700" text-anchor="middle">Safety–security interface (CSM-RA + IEC 62443-3-3)</text>
  <text x="285" y="335" fill="#94a3b8" font-size="11" text-anchor="middle">checked at every step: does a security control affect safety, or a safety measure affect security?</text>

  <!-- arrows across top -->
  <line x1="180" y1="100" x2="208" y2="100" stroke="#94a3b8" stroke-width="2" marker-end="url(#a2)"/>
  <line x1="360" y1="100" x2="388" y2="100" stroke="#94a3b8" stroke-width="2" marker-end="url(#a2)"/>
  <line x1="465" y1="130" x2="465" y2="178" stroke="#94a3b8" stroke-width="2" marker-end="url(#a2)"/>
  <line x1="390" y1="210" x2="362" y2="210" stroke="#94a3b8" stroke-width="2" marker-end="url(#a2)"/>
  <line x1="210" y1="210" x2="182" y2="210" stroke="#94a3b8" stroke-width="2" marker-end="url(#a2)"/>
  <!-- dashed link to interface band -->
  <line x1="285" y1="240" x2="285" y2="288" stroke="#94a3b8" stroke-width="1.5" stroke-dasharray="4 4"/>

  <defs>
    <marker id="a2" markerWidth="9" markerHeight="9" refX="7" refY="4.5" orient="auto">
      <path d="M0,0 L9,4.5 L0,9 Z" fill="#94a3b8"/>
    </marker>
  </defs>
</svg>
```

## Zones, conduits and target security levels — the railway cut

At its core, TS 50701 runs the same risk-assessment logic as IEC 62443-3-2: identify the system under consideration, partition it into **zones** (groups of assets with a shared security need) connected by **conduits** (the controlled pathways between them), assess the threats and their consequences, determine a **target security level** for each zone, and specify the measures needed to reach it. ENISA has published dedicated guidance on applying zoning and conduits to railways, a sign of how central this step is to the sector. ([ENISA — Zoning and Conduits for Railways](https://www.enisa.europa.eu/publications/zoning-and-conduits-for-railways))

The railway adaptation shows up in *which* assets fall into *which* zones, and in how consequences are weighted by safety criticality. A signalling interlocking sits in a different world from a passenger Wi-Fi access point, and TS 50701''s zoning reflects that. The illustrative pattern below is typical of how criticality drives target SLs.

| Zone (illustrative) | Example assets | Safety criticality | Typical target SL |
| --- | --- | --- | --- |
| Signalling & interlocking | Interlockings, object controllers, ETCS on-board/trackside | Safety-critical | SL-3 / SL-4 |
| Control-command & traffic management | TMS, dispatching, ATS | High operational | SL-2 / SL-3 |
| Rolling stock control | Train control units, on-board networks (TCN) | Safety-related | SL-2 / SL-3 |
| Operational support | SCADA for power, HVAC, tunnel systems | Operational | SL-2 |
| Passenger & non-vital | CCTV, passenger information, on-board Wi-Fi | Low / non-vital | SL-1 / SL-2 |

The output is what any good OT security assessment should produce: a structured, defensible model of where risk concentrates, what protection each zone needs, and where the current design falls short — expressed in the language of both the security standard and the railway lifecycle.

### A worked example: the trackside-to-on-board conduit

Consider one concrete pathway: the **radio conduit** carrying movement authorities between a trackside **ETCS/RBC** (radio block centre) and a train''s on-board unit. It is the artery of modern signalling, and it crosses an open medium.

- **Zone and conduit.** The RBC and the on-board unit sit in **safety-critical** zones (target SL-3/SL-4); the radio link is the **conduit** between them. Everything about the conduit — who may speak on it, how messages are authenticated, what happens if it is jammed — is in scope.
- **Threats and consequences.** Message forgery, replay, and jamming are the classic ones. The *consequence* weighting is what makes this a railway problem: a forged or replayed movement authority is not a data-integrity nuisance, it is a potential collision. The consequence axis is scored in safety terms, not IT terms.
- **Which FRs bite.** FR 3 (integrity) and FR 1 (authentication) protect the authenticity of the movement authority; FR 7 (availability) addresses jamming and denial-of-service; FR 5 (restricted data flow) ensures nothing else can inject onto the conduit.
- **The safety–security interface.** A security control that adds latency to the authority message could itself create a hazard — a train braking because a valid authority arrived late is a safety event caused by a security measure. This is precisely the interface TS 50701 forces you to review jointly, not in sequence.

One conduit, and the zoning model, the seven FRs, the target-SL logic and the safety–security interface all come into play at once. That is the specification working as intended: the same asset, examined through the security lens and the safety lens together.

### Legacy estates and compensating controls

Rail runs assets for thirty, forty, sometimes fifty years. Much of the installed base predates any notion of authenticated commands or signed firmware, and cannot simply be patched to an SL-3 posture. TS 50701 does not pretend otherwise. Because its risk logic can be applied to systems built **outside** the modern EN 50126-1 process, it accommodates brownfield reality: where a legacy interlocking cannot meet a control directly, the assessment reaches for **compensating controls** — tighter zoning around the old asset, a hardened and monitored conduit, strict access control on the maintenance path, and enhanced detection so that an attempt on the weak component is at least seen. The target security level still names the goal; the compensating controls are the defensible, documented route toward it when the asset itself cannot change. This is the same pragmatic move OXOT applies across ageing OT estates, and it is why an accurate model of *what actually exists* matters more than an idealised design.

```cta
Signalling, rolling stock, fixed installations — can you show a defensible security level per zone?
NIS2 assessors expect the TS 50701 method now. We apply zones, conduits and target security levels to your rail estate, aligned to the safety case.
Assess my rail estate :: /en/contact
```

## Scope — what TS 50701 covers

TS 50701 addresses cybersecurity across the railway system broadly. Its formal scope spans four domains: **Communications; Signalling and Processing; Rolling Stock; and Fixed Installations.** ([iTeh](https://standards.iteh.ai/catalog/standards/clc/db257ea9-8ba0-4f4c-a791-df34a6030541/clc-ts-50701-2023)) In practice that reaches from the interlocking in a lineside cabinet to the control unit under a train, from the traffic-management system in an operations centre to the power-SCADA feeding the catenary.

It also speaks to the whole delivery ecosystem — mirroring the asset-owner / integrator / supplier structure of [IEC 62443](/en/iec-62443).

| Role | Who they are | What TS 50701 asks of them |
| --- | --- | --- |
| Railway operator / infrastructure manager | Owns and runs the estate and its operational risk | Set security policy, define the risk appetite, run the security management system, meet regulatory duties |
| System integrator | Assembles, commissions and validates rail systems | Perform the risk assessment, design zones and conduits, verify security requirements at system level |
| Product / component supplier | Builds the equipment (interlockings, on-board units, sensors) | Meet component security requirements, follow a secure development lifecycle, document capabilities |
| Safety-case owner | Accountable for the safety argument | Manage the safety–security interface so security work strengthens rather than complicates the safety case |

## The regulatory context — NIS2, CRA and the road to IEC 63452

TS 50701 does not exist in a vacuum, and its regulatory weight is growing.

Railway undertakings and infrastructure managers are, in most Member States, exactly the transport operators captured by **[NIS2](/en/nis2)** as *essential entities* — which means binding cybersecurity risk-management and incident-reporting obligations, backed by real enforcement. TS 50701 gives rail a sector-appropriate method for meeting those duties instead of improvising against a generic checklist. On the product side, the equipment going into rail systems increasingly falls under the **[CRA](/en/cra)** as products with digital elements, carrying secure-by-design and vulnerability-handling requirements across their lifecycle. TS 50701 is increasingly treated as the baseline that connects rail engineering practice to both regimes. ([Cervello](https://cervello.security/blog/regulations/what-is-rail-cybersecurity-compliance/))

The specification is also a stepping stone. TS 50701 was developed by CENELEC TC 9X/WG 26 and is now feeding into **IEC 63452**, the first *international* railway cybersecurity standard, expected to consolidate and globalise the approach TS 50701 pioneered in Europe. ([Alstom](https://www.alstom.com/press-releases-news/2024/3/towards-first-railway-cybersecurity-international-standard-why-standards-are-important-secure-railways)) Investing in TS 50701 today is not a dead end — it is the on-ramp to the standard the whole sector is converging on.

```timeline
July 2021 :: **CLC/TS 50701 first edition** — the world''s first cybersecurity specification written specifically for railway applications.
August 2023 :: **CLC/TS 50701:2023 second edition** — the specification matures: refined risk process, MITRE ATT&CK for ICS referenced as a threat library, clearer safety–security interface guidance.
2024 onward :: **IEC 63452 in development** — CENELEC''s rail cybersecurity work feeds the first international standard, globalising the TS 50701 approach.
Now :: **NIS2 + CRA in force** — rail operators (essential entities) and rail-equipment suppliers already carry binding duties that TS 50701 is the sector-appropriate way to meet.
```

> [!TIP]
> Do not wait for IEC 63452 before acting. The engineering it will standardise — zones and conduits, target security levels, the safety–security interface — is already defined in TS 50701 and already what NIS2 assessors expect to see. Work done to TS 50701 carries forward almost unchanged.

## What it means for your role

**If you are a railway operator or infrastructure manager,** TS 50701 gives you a sector-specific way to define and demonstrate cybersecurity across your estate, aligned to the RAMS lifecycle you already run and to your [NIS2](/en/nis2) obligations. It turns "are we secure?" from a matter of opinion into a matter of documented target security levels and verified controls.

**If you are a rail system integrator or supplier,** it gives you a shared reference for what "secure" means in rail — target security levels, component requirements grounded in [IEC 62443](/en/iec-62443), and a risk process your customers and their assessors already recognise. It shortens the argument at acceptance.

**If you own the safety case,** TS 50701 gives you a structured way to handle the safety–security interface so that cybersecurity reinforces your safety argument instead of quietly eroding it — with joint reviews and CSM-RA alignment rather than two teams talking past each other.

## How to start

1. **Map the system under consideration.** Inventory the assets, networks and conduits in scope — signalling, rolling stock, control-command, fixed installations. You cannot zone what you cannot see.
2. **Zone by criticality and consequence.** Group assets by security need, weighted by safety impact, and define the conduits between them.
3. **Run the risk assessment.** Assess threats and consequences, then set a target security level per zone using the IEC 62443-derived process.
4. **Check the safety–security interface.** For every proposed control, ask whether it touches a safety function — and run a joint review where it does.
5. **Specify, verify, document.** Derive requirements from the target SLs, verify them (including component-level checks against IEC 62443-4-2), and record residual risk against your NIS2 and safety obligations.

A [Cyber Digital Twin](/en/cyber-digital-twin) makes steps 1 through 5 durable: it holds the assets, zones, conduits, safety–security interfaces and security-level gaps as a living model rather than a one-off report that ages the moment it is signed.

## How OXOT helps

OXOT''s method is built on [IEC 62443](/en/iec-62443) — the exact foundation TS 50701 extends — so our approach maps directly onto rail. Our **OT security assessments** apply the same zones-and-conduits and target-security-level logic that TS 50701 shares with IEC 62443, framed in railway terms and mindful of the safety lifecycle. Our **[Cyber Digital Twin](/en/cyber-digital-twin)** holds the resulting model — assets, zones, conduits, safety–security interfaces and security-level gaps — as a living structure that serves both the security programme and the safety case at once.

For rail operators facing [NIS2](/en/nis2) duties and suppliers facing the [CRA](/en/cra), that means a single, coherent way to understand risk, prioritise investment, and stay ready for the coming IEC 63452 baseline — across a complex, safety-critical estate. See our wider view of the standards landscape on the [Frameworks](/en/frameworks) page.

## Frequently asked questions

**Is TS 50701 a standard or a specification?**
It is a CENELEC **Technical Specification** (CLC/TS), a rung below a full harmonised European Norm. Its concepts are now feeding into the international standard **IEC 63452**, which is expected to become the global rail cybersecurity reference.

**Do we still need IEC 62443 if we use TS 50701?**
Yes, and in a good way. TS 50701 is built on IEC 62443 and points back to it — especially Parts 3-2 and 3-3 for the risk process and 4-2 for components. Understanding IEC 62443 makes TS 50701 far easier to apply, and the two bodies of work reinforce each other.

**How does it relate to the EN 5012x safety standards?**
TS 50701 integrates with the **EN 50126-1** RAMS lifecycle and manages the safety–security interface, drawing on safety methods such as CSM-RA. It sits alongside the railway safety standards, not in place of them.

**What exactly does TS 50701 cover?**
Four domains: Communications; Signalling and Processing; Rolling Stock; and Fixed Installations. It can be applied to systems built inside or outside the EN 50126-1 process, so it works for both legacy and new assets.

**Does NIS2 apply to us as a railway?**
Very likely. Rail transport is an essential-entity sector under NIS2 in most Member States. TS 50701 is the sector-appropriate method for meeting those obligations — confirm the specifics in your national transposition law.

**What about IEC 63452 — should we wait for it?**
No. IEC 63452 builds on the same engineering TS 50701 already defines. Work done to TS 50701 will carry forward, so the pragmatic move is to start now.

**Can we apply TS 50701 to a decades-old signalling estate?**
Yes. Its risk logic applies to systems built inside or outside the modern EN 50126-1 process. Where a legacy asset cannot meet a control directly, the assessment uses **compensating controls** — tighter zoning, hardened and monitored conduits, strict maintenance-access control, enhanced detection — with the target security level still naming the goal. Brownfield is the norm in rail, and the specification is built for it.

**How do the seven foundational requirements apply to rail?**
They are the IEC 62443-3-3 headings — identification/authentication, use control, system integrity, data confidentiality, restricted data flow, timely response, resource availability — read against railway assets. Integrity and authentication protect signalling logic and movement authorities; restricted data flow is the zone/conduit boundary between passenger and signalling networks; resource availability makes the RAMS "A" a security target.

**Who has to do what — operator, integrator, supplier?**
Mirroring IEC 62443: the operator/infrastructure manager sets policy and runs the security management system; the integrator performs the risk assessment and designs zones and conduits; the component supplier meets component security requirements and follows a secure development lifecycle. The safety-case owner manages the interface so security strengthens the safety argument.

## Sources

- CLC/TS 50701:2023 — railway applications cybersecurity — [iTeh Standards](https://standards.iteh.ai/catalog/standards/clc/db257ea9-8ba0-4f4c-a791-df34a6030541/clc-ts-50701-2023)
- Hands-on CLC/TS 50701 (railway cybersecurity), Christian Schlehuber — [ENISA / CENELEC](https://www.enisa.europa.eu/sites/default/files/all_files/05-standards-02-cenelec-christian-schlehuber.pdf)
- Zoning and Conduits for Railways — [ENISA](https://www.enisa.europa.eu/publications/zoning-and-conduits-for-railways)
- A deep dive into CENELEC TS 50701 — [Shieldworkz](https://shieldworkz.com/blogs/a-deep-dive-into-cenelec-ts-50701-for-railway-cybersecurity)
- A deep dive into TS 50701-based risk and security assessment — [Shieldworkz](https://shieldworkz.com/blogs/a-deep-dive-into-ts-50701-based-risk-and-security-assessment)
- Navigating TS 50701 — [Cylus](https://www.cylus.com/post/navigating-ts-50701-unpacking-the-impact-of-the-cybersecurity-standard-for-rail)
- What is rail cybersecurity compliance? — [Cervello](https://cervello.security/blog/regulations/what-is-rail-cybersecurity-compliance/)
- Towards the first railway cybersecurity international standard (IEC 63452) — [Alstom](https://www.alstom.com/press-releases-news/2024/3/towards-first-railway-cybersecurity-international-standard-why-standards-are-important-secure-railways)

*This page is general educational information. Refer to the official CENELEC CLC/TS 50701 (and the forthcoming EN / IEC 63452) documents for authoritative requirements.*', true, 'CLC/TS 50701 Railway Cybersecurity Explained | OXOT', 'CLC/TS 50701 explained in depth — the first cybersecurity specification for rail, how it applies IEC 62443 to railway systems, its integration with the EN 50126 RAMS lifecycle, the safety–security interface, zones and conduits, NIS2 and CRA relevance, and the road to IEC 63452.', 'The cybersecurity specification for rail — IEC 62443 adapted to railway applications and welded into the safety lifecycle.', NULL, 'page', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('architecture-segmentation', 'nl', 'Architectuur & segmentatie', 'Platte OT-netwerken maken van één voet-aan-de-grond een plantbreed incident. OXOT ontwerpt OT-netwerkarchitecturen die die blast radius inperken — zones en conduits afgestemd op IEC 62443 — met respect voor de realiteit dat u een draaiende installatie niet zomaar opnieuw kunt bekabelen.

We beginnen bij uw werkelijke verkeer en datastromen, definiëren een doelarchitectuur waar u in fasen naartoe migreert, en toetsen elke stap aan de operatie zodat segmentatie de beveiliging verbetert zonder de productie te onderbreken.

```keyfacts
Norm :: IEC 62443-3-2 (zones) en 3-3 (maatregelen)
Ontwerpeenheid :: zones en conduits, geen platte VLAN''s
Aanpak :: segmenteren zonder de productie te verstoren
Omvat :: DMZ, datastromen, externe toegang, firewall-baselines
Oplevering :: doelarchitectuur + een gefaseerd migratieplan
Validatie :: ontworpen en getoetst aan echt verkeer
```

## Wat u krijgt

```cards
Zone- en conduitmodel :: /nl/contact :: Uw omgeving uitgedrukt in IEC 62443-zones en -conduits, met expliciete vertrouwensgrenzen.
Doelreferentiearchitectuur :: /nl/contact :: Een concreet to-be-ontwerp — DMZ, datadiodes waar gerechtvaardigd, gecontroleerde datastromen.
Segmentatiemigratieplan :: /nl/contact :: Een gefaseerd pad van uw huidige situatie naar het doel, zo ingericht dat de operatie nooit stilvalt.
Firewall- & regelbaselines :: /nl/contact :: Conduit-regelsets en wijzigingspatronen die uw team kan bezitten en onderhouden.
```

## Hoe het werkt

```timeline
1. Stromen in kaart :: Leg de werkelijke communicatie- en datastromen over uw omgeving vast.
2. Zones & conduits bepalen :: Groepeer assets op risico en functie; maak elke vertrouwensgrens expliciet.
3. Doel ontwerpen :: Een referentiearchitectuur met DMZ, gecontroleerde stromen en heldere conduit-regels.
4. Gefaseerde migratie :: Beweeg naar het doel in stappen die de operatie veilig kan absorberen.
5. Verifiëren :: Toets segmentatie aan echt verkeer en bevestig dat er operationeel niets brak.
```

## Waar het past

Dit is de praktische toepassing van **IEC 62443**-zones en -conduits, en het onderbouwt de netwerkbeveiligingsverwachtingen in **NIS2**. Het gaat natuurlijk samen met **Veilige externe toegang** en een **Cyber Digital Twin** die het architectuurmodel actueel houdt.

```cta
Perk de blast radius in
Ontwerp een OT-architectuur die beperkt hoe ver een incident zich kan verspreiden — zonder de productie te stoppen.
Praat met een OT-beveiligingsexpert :: /nl/contact
```', true, 'OT-architectuur & netwerksegmentatie | OXOT', 'Veilige OT-netwerkarchitectuur — zones, conduits en praktische segmentatie afgestemd op IEC 62443, ontworpen om de blast radius te beperken zonder de productie te verstoren.', 'Definieer veilige OT-netwerkarchitecturen — zones, conduits en praktische segmentatiepatronen afgestemd op IEC 62443, ontworpen voor de operatie.', NULL, 'page', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('capability-transfer', 'nl', 'Kennisoverdracht', 'De beste OT-securityopdracht eindigt ermee dat u ons niet meer nodig hebt. Kennisoverdracht is hoe OXOT dat waarmaakt: we bouwen het operating model, de rollen, de runbooks en het vertrouwen die uw interne team nodig heeft om OT-security zelf te draaien.

We werken ingebed in plaats van een document te overhandigen. Uw mensen leren door het werk naast ons te doen, en verlaten de opdracht met eigen capaciteit — geen afhankelijkheid.

```keyfacts
Doel :: zelfvoorzienendheid — uw team bezit OT-security
Vorm :: coaching, playbooks en zij-aan-zij werken
Doelgroep :: OT-engineering, IT-security en operatie
Artefacten :: operating model, RACI, runbooks, training
Duur :: ingebed over een programma, geen workshop
Resultaat :: capaciteit die u houdt nadat wij weg zijn
```

## Wat u krijgt

```cards
OT-security operating model :: /nl/contact :: Hoe OT-security dagelijks draait — besluiten, ritmes en raakvlakken tussen OT, IT en operatie.
Rollen & RACI :: /nl/contact :: Helder eigenaarschap: wie beslist, wie doet, wie wordt geraadpleegd en wie geïnformeerd.
Runbooks & playbooks :: /nl/contact :: Herhaalbare procedures voor wat terugkeert — van het onboarden van een leverancier tot reageren op een alert.
Training & coaching :: /nl/contact :: Uw team bouwt de vaardigheden op door het werk mét ons te doen, niet door erover te lezen.
```

## Hoe het werkt

```timeline
1. Capaciteit beoordelen :: Begrijp uw huidige vaardigheden, structuur en hiaten eerlijk.
2. Doel-operating-model bepalen :: Spreek af hoe OT-security moet draaien en wie wat bezit.
3. Coachen & documenteren :: Werk zij-aan-zij; leg wat u leert vast als runbooks en playbooks.
4. Overdracht :: Verschuif eigenaarschap naar uw team, terwijl wij bewust terugtreden.
5. Evalueren :: Check na de overdracht of de capaciteit standhoudt.
```

## Waar het past

Kennisoverdracht maakt **NIS2**-governance en bestuurlijke verantwoordelijkheid echt — iemand in uw organisatie bezit het daadwerkelijk. Het bestendigt de **IEC 62443**-levenscyclus lang na één project, en houdt een **programma** draaiend zodra wij terugtreden.

```cta
Bezit het, huur het niet
Bouw de interne capaciteit om OT-security te onderhouden — zodat de verbetering de opdracht overleeft.
Praat met een OT-beveiligingsexpert :: /nl/contact
```', true, 'OT-security kennisoverdracht | OXOT', 'Bouw de kennis, structuur en het eigenaarschap op die uw interne team nodig heeft om OT-security duurzaam te onderhouden — een operating model, RACI, runbooks en coaching, zodat u niet afhankelijk bent van consultants.', 'Help interne teams de kennis, structuur en het eigenaarschap op te bouwen om OT-security over tijd te onderhouden.', NULL, 'page', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('cdt-fooled-by-randomness', 'nl', 'Fooled by Randomness — Waarom "We hebben nog nooit een incident gehad" geen bewijs is', 'Ik las *Fooled by Randomness* niet op zoek naar een boek over cyberbeveiliging. Ik las het in een vliegtuig, jaren in een carrière die zich afspeelde in onderstations, batterij-opslagterreinen, spoorwegcontrolekamers en waterzuiveringsinstallaties op meerdere continenten, omdat iemand het mij had aanbevolen als een goed boek over markten. Ergens boven de Atlantische Oceaan hield ik op het als een boek over markten te lezen. Nassim Taleb beschreef, met totale precisie, iets wat ik mijn hele werkzame leven had gadegeslagen en waarvoor ik nooit de taal had gehad. Geen metafoor. Geen analogie die ik met kunst- en vliegwerk toepasselijk maakte. Dezelfde wiskunde, dezelfde psychologie, dezelfde structurele blindheid — alleen met een veiligheidshelm in plaats van een pak.

Dit stuk is mijn poging om die herkenning volledig uiteen te zetten, want als u het eenmaal ziet, kunt u niet meer stoppen het te zien in elk auditrapport, elke leverancierspitch en elke bestuurspresentatie die beweert dat een faciliteit veilig is omdat er nog niets ergs is gebeurd.

## Wat Taleb werkelijk beweerde

Haal de kleur van de handelsvloer weg en Talebs these is eenvoudig te formuleren en ongemakkelijk om te accepteren: **mensen zijn constitutioneel slecht in het herkennen van willekeur, en we verwarren systematisch uitkomsten met vaardigheid.** We zien een patroon, we bouwen een verhaal om het te verklaren, en we vergeten dat het verhaal achteraf is geschreven door iemand die het einde al kende.

Zijn favoriete illustratie is een gedachte-experiment, en het loont om het volledig te doorlopen, want alles wat volgt hangt ervan af. Neem tienduizend fondsbeheerders. Geef elk van hen een vijftig-vijftig kans om in een willekeurig jaar geld te verdienen — pure muntworp-kansen, geen enkele vaardigheid in het spel. Laat het vijf jaar lopen. Eenvoudige binomiale wiskunde zegt dat ongeveer driehonderd van hen, puur door toeval, elk van die vijf jaar geld zullen hebben verdiend. Die driehonderd deden niets. Ze gooiden een munt op en die kwam vijf keer op kop. Maar zij ervaren het niet als toeval, en niemand die naar hen kijkt evenmin. Ze worden geportretteerd in tijdschriften. Business schools bestuderen hun "filosofie." Institutioneel geld stroomt naar hun fonds omdat het trackrecord eruitziet als het bewijs van een systeem.

De andere 9.700 beheerders zijn verdwenen. Ze verloren, sloten hun fondsen, verlieten de sector, en — dit is Talebs scherpste punt — **ze lieten geen spoor na.** Ze zijn geen voetnoot in iemands case study. Ze verschijnen niet in de database die de volgende analist erbij pakt om te bestuderen "wat winnende beheerders gemeen hebben." Taleb noemt dit het kerkhof: het stille bewijs van iedereen die dezelfde strategie volgde en werd weggevaagd, structureel onzichtbaar voor iedereen die de overlevenden evalueert.

Hij trekt dit door naar een breder geheel van ideeën die allemaal dezelfde kant op wijzen:

- **Survivorship bias fabriceert valse expertise.** We bestuderen winnaars en kopiëren hun gewoontes, zonder ooit de veel grotere populatie te zien die dezelfde gewoontes probeerde en faalde.
- **Scheefheid en asymmetrie zijn de norm, niet de uitzondering.** Veel echte weddenschappen zijn geen eerlijke muntworpen — het zijn kleine, gestage winsten die af en toe worden onderbroken door zeldzame, catastrofale verliezen. Talebs optieverkopers "eten als kippen en gaan naar het toilet als olifanten": jarenlang kleine premies innen, en dan alles verliezen op een middag wanneer de staartgebeurtenis eindelijk arriveert.
- **De narratieve drogreden herschrijft het verleden.** Nadat iets is gebeurd, bouwen we een net causaal verhaal om te verklaren waarom het onvermijdelijk was, en daarmee wissen we uit hoe toevallig en willekeurig het in werkelijkheid was.
- **Kansblindheid werkt in beide richtingen.** We overschatten levendige, zeldzame risico''s die we ons kunnen voorstellen (een vliegtuigongeluk) en onderschatten langzaam smeulende, statistisch dominante risico''s die we niet kunnen visualiseren (een zich opstapelende, ongepatchte kwetsbaarheid die jarenlang stilletjes aanwezig is).
- **Optionaliteit verslaat nauwe slimheid.** In een niet-lineaire wereld is het meer waard om zo gepositioneerd te zijn dat goede staartgebeurtenissen u helpen en slechte staartgebeurtenissen u niet kunnen ruïneren, dan om de slimste persoon in de kamer te zijn over het gemiddelde geval.

> [!NOTE]
> Talebs diepste bewering is niet dat vaardigheid niet bestaat. Het is dat vaardigheid, in ruizige, complexe domeinen, vaak parasitair is op willekeur — erbovenop meerijdend, er op korte termijn niet van te onderscheiden, en alleen ervan te scheiden door naar veel meer proeven te kijken dan de carrière van één persoon oplevert.

## De twee kanten van de tafel

Het organiserende beeld van het boek, dat waar ik sindsdien niet meer los van kan komen, is wat Taleb de twee kanten van de tafel noemt.

De ene kant — de linkerkant — is waar de wereld daadwerkelijk opereert. Het is een volledige kansruimte: elke uitkomst die zou kunnen gebeuren, gewogen naar waarschijnlijkheid, inclusief de dikstaartige, zeldzame, catastrofale gebeurtenissen die de werkelijke resultaten op lange termijn domineren, ook al komen ze bijna nooit voor in het ene stukje geschiedenis dat u toevallig waarneemt. De linkerkant geeft niets om uw verhaal. Ze bevat alle parallelle universums waarin uw winnende reeks omsloeg in een faillissement, naast het ene universum waarin u daadwerkelijk leeft.

De andere kant — de rechterkant — is waar mensen denken dat ze opereren. Het is ordelijk, opeenvolgend en verklaarbaar. Dingen gebeuren om redenen. Inspanning en succes zijn causaal verbonden. De geschiedenis is een betrouwbare leermeester, omdat wordt aangenomen dat de toekomst eruitziet als een licht bijgewerkte versie van het verleden. Het is comfortabel, sociaal beloond, en bijna volledig een constructie van de menselijke behoefte aan een verhaal dat ergens op slaat.

Talebs argument is dat de financiële sector zijn hele risicobeheerapparaat — Value-at-Risk-modellen, backtests, Sharpe-ratio''s, het hele professionele bouwwerk — bouwde op de rechterkant van de tafel, met instrumenten die expliciet zijn ontworpen om het narratief te bevestigen in plaats van de onderliggende verdeling te onderzoeken. En dat periodiek, zonder waarschuwing die evenredig is aan de rust die eraan voorafging, de linkerkant zich opnieuw laat gelden. LTCM in 1998. De mondiale financiële crisis in 2008. Elke keer werd de verwoesting achteraf beschreven als een uitvoeringsfout, een malafide handelaar, een zwarte zwaan die niemand had kunnen zien aankomen. Talebs punt is scherper dan dat: het was een kennistheoretisch falen. De kaart beschreef een wereld die nooit had bestaan, en de mensen die haar gebruikten hadden zichzelf — en iedereen die hen betaalde — ervan overtuigd dat ze wél bestond.

Formeel: laat X een stochastische variabele zijn die een uitkomst representeert — bijvoorbeeld de winst en het verlies van een jaar. De werkelijke verdeling P(X) kan dikstaartig zijn, scheef, gedomineerd door zeldzame gebeurtenissen. De illusie waarop de meeste mensen handelen is een afgeknotte, gladgestreken vervanging voor P(X) — meestal alleen het gemiddelde en de standaardafwijking, waarbij de staarten stilletjes worden weggeredeneerd omdat ze lastig te modelleren zijn en psychologisch onaangenaam om bij stil te staan.

U kunt niet aan de uitkomsten zien aan welke kant van de tafel u zich daadwerkelijk bevindt. Talebs andere favoriete illustratie maakt dit levendig: twee mensen in een casino. Persoon A speelt een spel dat de meeste tijd een klein bedrag uitbetaalt en hen af en toe volledig wegvaagt. Ze winnen maandenlang, voelen zich een genie, en scheppen op over hun systeem. Persoon B speelt een spel dat bijna altijd een beetje verliest, maar een zeldzame, explosieve uitbetaling kent. Ze verliezen een lange periode, worden stilletjes afgeschreven als talentloos, en op een dag valt de jackpot. Voor elke buitenstaander die alleen het zichtbare verslag bestudeert, lijkt Persoon A de expert en Persoon B de dwaas. De waarneembare geschiedenis vertelt u bijna niets over wie eigenlijk de betere langetermijnweddenschap heeft.

## Waar ik precies dit heb zien gebeuren — in faciliteiten, niet in fondsen

Hier werd de herkenning onmogelijk om van me af te schudden. Ik heb in genoeg controlekamers gestaan, genoeg onderstations doorlopen, genoeg debriefings na incidenten bijgewoond om u te kunnen vertellen dat de taal verandert, maar de onderliggende fout geen millimeter verschuift.

In plaats van "we hadden een positief jaar" is het "we zijn geslaagd voor de audit." In plaats van "onze Sharpe-ratio is sterk" is het "we zijn IEC 62443-compliant." In plaats van "onze strategie is gevalideerd door een decennium aan rendementen" is het "we hebben geen significant incident gehad."

Wanneer een faciliteit niet is aangevallen, is de instinctieve reactie dat te lezen als bewijs dat de beheersmaatregelen werken. Wat het werkelijk is: bewijs dat de specifieke combinatie van tegenstander-capaciteit, timing, doelselectie en interne kwetsbaarheidstoestand nog niet is samengekomen tot een gerealiseerd aanvalspad. De faciliteit zit op één steekproefpad door een kansruimte die duizenden andere paden bevat, waarvan sommige eindigen in verlies van controle, een geactiveerd veiligheidssysteem, fysieke schade, of erger. De afwezigheid van zichtbare compromittering vertelt u bijna niets over op welk pad u zich daadwerkelijk bevindt. Het is Talebs kalkoen, duizend dagen gevoed en met elke maaltijd zekerder wordend van de regeling, tot aan de dag vóór Thanksgiving, wanneer het model met maximale vooringenomenheid wordt herzien. De compliancescore daalt niet in de week voor de inbraak. De audit wordt gehaald. Het dashboard is groen. En ergens in de kloof tussen wat het architectuurdiagram zegt dat er zou moeten draaien en wat er daadwerkelijk is geïnstalleerd, gepatcht, gewijzigd, of stilletjes aangesloten voor operationeel gemak tijdens een onderhoudsvenster drie jaar geleden, heeft een tegenstander al het pad gevonden dat geen van de beheersmaatregelen was gebouwd om te zien.

Ik ben een klein aantal illusies gaan herkennen die zich herhalen, faciliteit na faciliteit, sector na sector, continent na continent:

**De illusie van de referentiearchitectuur.** Het diagram aan de muur toont een correct gesegmenteerd netwerk — IT netjes gescheiden van OT, de DMZ waar hij hoort, elke verbinding gerouteerd via een gecontroleerd knelpunt. Het diagram is accuraat. Het is accuraat voor het systeem zoals het is ontworpen. Wat er daadwerkelijk draait, is het opgestapelde residu van jaren aan operationele beslissingen: een noodoplossing van een storing anderhalf jaar geleden, een leverancierstoegangspad geopend voor een onderhoudsvenster en nooit gesloten, verouderde apparatuur ouder dan de huidige architectuur, firmware die niet is aangeraakt sinds ingebruikname. De audit controleerde het diagram.

**De illusie van compliance-als-beveiliging.** IEC 62443, NERC CIP, NIS2, NIST CSF — deze raamwerken coderen oprechte, hard bevochten kennis over hoe je een verdedigbaar systeem bouwt, en ik heb geen bezwaar tegen een van hen. Wat ik afwijs, is de stille vervanging die overal in bestuurskamers plaatsvindt: het gelijkstellen van compliance met een raamwerk aan werkelijke beveiligingspositie. Raamwerken zijn opgebouwd uit bekende patronen, eerdere incidenten en consensusprincipes. Dat betekent, per constructie, dat ze de rechterkant van de tafel uitstekend beschrijven. Ze kunnen geen rekenschap geven van de specifieke, onherhaalbare combinatie van configuratie, mensen, softwareafhankelijkheid, geopolitieke context en organisatiecultuur die het werkelijke risico-oppervlak van één faciliteit op één dinsdag vormt.

**De illusie van leveranciers-survivorship.** Dit is Talebs kerkhof van fondsbeheerders met een badge van een vakbeurs om. Een leverancier verkoopt een endpoint-product aan vijfhonderd ondernemingen. Wellicht gaan vierhonderdtachtig een jaar zonder groot incident — om redenen die meestal niets met het product te maken hebben: de dreigingsactoren waren dat jaar elders druk bezig, de aanvaller probeerde een vector die de organisatie toevallig om ongerelateerde redenen had gesegmenteerd, gewoon toeval. Tien van die vierhonderdtachtig staan op het podium tijdens de jaarlijkse conferentie. *"We hebben dit ingezet en hebben al drie jaar geen groot incident gehad."* De twintig die werden aangevallen, tekenden geheimhoudingsverklaringen, vervingen stilletjes het product, en zijn niet in de zaal. Zij zijn het stille bewijs. Niemand bij de leverancier loog. De overlevende op het podium sprak de waarheid. De koper in het publiek — de CISO van een nutsbedrijf, een waterschap, een exploitant van batterijopslag — paste volstrekt redelijk oordeel toe en kwam toch tot de verkeerde conclusie, omdat de methode om het product te evalueren u alleen ooit laat zien wat is gebeurd, nooit wat had kunnen gebeuren met de vierhonderdtachtig die om redenen die niets met het instrument te maken hadden, niet werden aangevallen.

**De illusie van "zo hebben we het altijd gedaan."** Kritieke infrastructuur heeft een diep institutioneel geheugen, om goede reden — je kunt geen live proces verstoren voor elke beveiligingstheorie die de poort binnenkomt. Maar vijftien jaar incidentvrije werking, in een wereld waarin de dreigingsomgeving, de softwareafhankelijkheidsketen en de geopolitieke achtergrond allemaal onder u zijn verschoven, vertelt u veel minder over de toekomst dan het aanvoelt. U bevindt zich op een steekproefpad. Dat het pad tot nu toe glad is geweest, is geen bewijs dat de weg vooruit ook glad is.

> [!IMPORTANT]
> De afwezigheid van een inbraak is een uitkomst. Het is geen bewijs van een werkend systeem. Talebs waarschuwing om uitkomsten niet met vaardigheid te verwarren, geldt met evenveel kracht of de uitkomst in kwestie nu een winstreeks van vijf jaar is, of vijf jaar zonder incidentrapport.

## Ruis versus signaal, concreet gemaakt

| | Hoe het eruitziet | Wat het werkelijk zegt |
|---|---|---|
| **Een schone audit** | Groen dashboard, beheersmaatregelen "aanwezig" | De referentiearchitectuur is gecontroleerd, niet de operationele werkelijkheid |
| **"Geen incidenten in drie jaar"** | Een rustig trackrecord | Eén steekproefpad ontweek de rampzone; zegt weinig over de andere paden |
| **De referentieklanten van een leverancier** | Succesverhalen op het podium | De zichtbare overlevenden van een populatie wier mislukkingen onder geheimhouding vallen |
| **Een penetratietest met verholpen bevindingen** | Een momentopname | Eén tegenstanderspositie, één keer getest, tegen een systeem dat blijft verschuiven |
| **94% voltooiing van beveiligingsbewustzijnstraining** | Een trainingsmetriek | Naleving van een beleid, geen bewijs van gedrag onder echte stress |
| **Bestuursslide: 14 KPI''s stijgend** | Een verbeteringsnarratief | Bevestiging van het verhaal dat de leiding al wilde vertellen |

De rechterkolom is de linkerkant van de tafel. Daar leeft het werkelijke risico, en dat is precies het deel dat conventionele beveiligingsrapportage niet is gebouwd om u te tonen.

## Wat het bouwen van de Cyber Digital Twin mij leerde over dit serieus nemen

Het herkennen van de parallel is het makkelijke deel — het kost een middag en een vliegreis. Iets bouwen dat dit daadwerkelijk operationaliseert is het moeilijke deel, en dat is waar mijn team en ik jarenlang mee bezig zijn geweest met de OXOT [Cyber Digital Twin](/nl/cyber-digital-twin).

De basisdiscipline is het weigeren van het comfort van de rechterkant van de tafel. Waar conventionele praktijk vraagt *hebben we de beheersmaatregelen op orde?*, stellen wij een andere vraag: gegeven de volledige kansruimte van hoe een tegenstander zich door deze specifieke faciliteit zou kunnen bewegen, met deze specifieke mensen, op dit specifieke moment — waar zijn we werkelijk blootgesteld, en in welke mate?

Dat eerlijk beantwoorden betekent een model van de faciliteit bouwen dat niet vastlegt wat de referentiearchitectuur zegt dat zou moeten bestaan, maar wat daadwerkelijk bestaat: elk stuk apparatuur met zijn werkelijke firmware, zijn werkelijke configuratie, zijn werkelijke patchstatus, zijn werkelijke connectiviteit. Het betekent het traceren van de software binnen elk apparaat tot diep in de transitieve afhankelijkheden, want een kwetsbaarheid die vijf niveaus diep in een bibliotheek zit waar niemand aan denkt, is precies het soort dat een geduldige tegenstander vindt en een geplande compliancescan nooit bereikt. Het betekent dreigingsinformatie behandelen niet als een generieke TTP-lijst, maar als de daadwerkelijke, live campagnes die daadwerkelijke tegenstanders op dit moment tegen daadwerkelijke sectoren voeren.

En het betekent — dit is het deel dat de sector het meest consistent vermijdt, omdat het het moeilijkst tot een vinkje te herleiden is — het modelleren van de mensen binnen de faciliteit met dezelfde nauwgezetheid die op de apparatuur wordt toegepast. Ik heb, in echte incidenten en in oefeningen die zijn ontworpen om als echte incidenten aan te voelen, de SOC-analist gezien die de derde melding wegwuift omdat de eerste twee ruis waren. De plantmanager die ervan overtuigd is dat het cyberteam overdrijft omdat "deze systemen al twintig jaar prima draaien." De incidentcommandant wiens eigen rapportagestructuur precies de escalatie blokkeert die ertoe zou hebben gedaan. Het team wiens collectieve oordeel simpelweg verslechtert onder cognitieve belasting, precies op het moment dat helderheid het hardst nodig is. Niets daarvan is een karakterfout. Het is een voorspelbare, meetbare eigenschap van menselijke organisaties onder stress, en Taleb heeft zijn hele carrière betoogd dat menselijke cognitie risicoperceptie vervormt in specifieke, berekenbare richtingen — vooroordelen en heuristieken die kleine groepen het grootste deel van de menselijke geschiedenis goed van dienst waren en die actieve aansprakelijkheden worden binnen complexe, niet-lineaire systemen met hoge inzet. Praktijkervaring bevestigt dit op elke schaal, van de individuele analist tot en met de organisatiecultuur tot en met de beperkingen die in de regelgevende omgeving zelf zijn ingebouwd.

De methodologie die wij hebben gebouwd, behandelt menselijk gedrag niet als een onvoorspelbare variabele die wordt afgehandeld met een trainingsvideo en een ondertekend beleid, maar als een **dynamisch systeem met een eigen structuur, drempelwaarden en faalmodi** — gemodelleerd met dezelfde ernst die wordt toegepast op de technische lagen eromheen.

## De Monte Carlo-geest

Talebs werkelijke tegengif voor rechterkant-denken is niet "denk harder na." Het is een verandering van methode: draai de Monte Carlo-simulatie. Genereer duizenden alternatieve geschiedenissen en bestudeer de verdeling van uitkomsten die dat oplevert, in plaats van te staren naar de ene geschiedenis die toevallig heeft plaatsgevonden. U kunt uw werkelijke blootstelling niet begrijpen door te bestuderen wat is gebeurd. U moet bestuderen wat *zou kunnen* gebeuren — over de volledige ruimte van mogelijkheden, inclusief de gebieden die u nog niet hebt bezocht en hoopt nooit te bezoeken.

Dat is het letterlijke ontwerpprincipe onder de Cyber Digital Twin. De vraag waarvoor wij systematische methodologie bouwen om te beantwoorden, is niet "wat is er eerder misgegaan?" Het is "op hoeveel manieren zou deze faciliteit kapot kunnen gaan, via welke reeks stappen, met welke specifieke combinatie van technische en menselijke kwetsbaarheid — en welke van die paden zijn het meest waarschijnlijk, welke zijn het meest catastrofaal, en wat zouden we daadwerkelijk moeten veranderen om de blootstelling te verminderen, niet alleen om de audit van volgend kwartaal te halen?"

Niets hiervan is bureautheorie. Het komt voort uit het lopen over de vloer van de faciliteit, praten met de operators die de apparatuur daadwerkelijk aanraken, de organisatiecultuur van binnenuit begrijpen, de software in kaart brengen die daadwerkelijk draait op echte apparaten, en op tegenstrijdige wijze nadenken over wat een geduldige, goed toegeruste aanvaller zou doen met de kwetsbaarheden die daadwerkelijk bestaan — niet de hypothetische waaromheen een compliance-raamwerk was ontworpen.

De output ziet er totaal niet uit als een compliancerapport. Geen score. Geen checklist. Geen volwassenheidsbeoordeling op een schaal van vijf punten. Een **kanslandschap**: dit zijn de paden die het meest waarschijnlijk succesvol zijn, gerangschikt naar gevolg, gegeven deze specifieke faciliteit, deze specifieke mensen, deze specifieke dreigingsomgeving op dit moment. Hier concentreert het risico zich daadwerkelijk. Dit zou het daadwerkelijk verminderen. Dit ziet er indrukwekkend uit op papier en zou de naald met bijna niets verschuiven.

## Hoe de tweeling is gebouwd, in gewone taal

De Cyber Digital Twin is een graaf van de faciliteit met zeven lagen, en de twee lagen die het belangrijkst zijn voor dit betoog zijn de eerste twee, want samen zijn ze Talebs twee kanten van de tafel, weergegeven als data.

**L0 — de Apparatuurcatalogus** is de Platonische referentie: het datasheet van de leverancier, de referentiefirmware, de ontworpen configuratie. Het is de kaart, en het is een perfect accurate kaart — van de wereld die de leverancier u verkocht, niet de wereld waarin u staat.

**L1 — Klantapparatuur** is het territorium: de daadwerkelijke assets met hun serienummer, hun daadwerkelijke firmwareversies, hun daadwerkelijke patchstatus, hun daadwerkelijke netwerkconfiguratie, in kaart gebracht tot op geospatiale locatie en cross-sectorale onderlinge afhankelijkheid. Elke aanval die ooit is geslaagd binnen een gehardende OT-faciliteit heeft de kloof tussen L0 en L1 uitgebuit — het verschil tussen wat is ontworpen en wat daadwerkelijk bestaat. De tweeling meet die kloof als een volwaardig wiskundig object in plaats van als een ongenoemde aanname. Elke audit die toetst aan het referentiemodel en "compliant" terugmeldt, heeft de fundamentele Talebiaanse fout gemaakt: hij heeft de kaart geauditeerd en nooit het territorium onderzocht.

Van daaruit bouwt de graaf zich naar buiten: **L2** is de software bill of materials, getraceerd door transitieve afhankelijkheden vijf niveaus diep en verrijkt met exploit-kansscores, want de kwetsbaarheid die ertoe doet, is zelden de voor de hand liggende aan de oppervlakte. **L3** is dreigingsinformatie opgebouwd uit kill-chain-modellering en live-campagneattributie — de tegenstanders die daadwerkelijk actief zijn tegen deze sector en deze assetklasse, geen generieke lijst. **L4** is psychologie: de kloof tussen de Werkelijke dreiging (het daadwerkelijke aanvalsoppervlak, grotendeels onopgemerkt) en de Denkbeeldige angst (het dreigingsmodel van de CISO, het risicoregister, de compliancescore — altijd gedeeltelijk, altijd een beetje zelfdienend). **L5** is de realtime-informatieomgeving — geopolitieke gebeurtenissen, sentiment, de nieuwscyclus die zonder waarschuwing de doelselectie van een tegenstander kan omleiden. **L6** is voorspelling: waarschijnlijkheid van een inbraak, vertraging bij verhelpen, rendement op een gegeven investering, uitgedrukt als een verdeling met een vermeld betrouwbaarheidsinterval, geen enkel getal dat doet alsof het zeker is.

De engine die over deze graaf draait, past Monte Carlo-trajectbemonstering toe — de huidige toestand wordt geëxtraheerd, de veranderingssnelheid ervan wordt berekend, duizend gesimuleerde toekomsten worden vooruit gedraaid met gerandomiseerde schokken en organisatorische veerkracht meegewogen, waarna de resultaten worden samengevoegd tot een posterieure verdeling met een expliciete entropiemaat en 95%-betrouwbaarheidsintervallen. Het genereert aanvalsreeksen die zijn afgestemd op MITRE ATT&CK en voert deze duizend keer uit tegen de graaf, met gerandomiseerde variatie in tegenstander-capaciteit, timing en menselijke respons. Elke run is een parallel universum: een iets andere tegenstander, met iets andere instrumenten, op een iets ander moment, tegen uw team op een iets andere dag.

De output vertelt u zoiets als: in 73% van de gesimuleerde campagnes bereikt de tegenstander het Level 2-netwerk. In 31% bereiken ze persistentie in de OT-zone. In 8,4% bereiken ze een veiligheidskritiek systeem. In 2,1% produceert de combinatie van cybercompromittering en falende menselijke respons een bifurcatie — een toestandsovergang zonder stabiele operationele toestand aan de andere kant — en het 95%-betrouwbaarheidsinterval op die 2,1% is [1,4%, 3,2%]. Dat is de linkerkant van de tafel, in engineering-grade wiskunde, en het is het verschil tussen geloven dat u veilig bent omdat een compliancescore dat zegt, en weten wat de werkelijke verdeling is van wat er gebeurt wanneer een tegenstander de faciliteit aangaat die u daadwerkelijk exploiteert.

> [!TIP]
> Een kansverdeling met een betrouwbaarheidsinterval is een eerlijker product dan een enkele compliancescore, zelfs wanneer het getal in de verdeling slechter is. Talebs hele argument is dat het ongemak van een eerlijk getal goedkoper is dan de catastrofe van een geruststellend getal.

## Linkerkant versus rechterkant, in een tabel

| | **Rechterkant van de tafel** (het geruststellende model) | **Linkerkant van de tafel** (de probabilistische werkelijkheid) |
|---|---|---|
| Wat het modelleert | Beheersmaatregelen aanwezig versus afwezig | Volledige kansverdeling van aanvalsuitkomsten over elke laag |
| Wat het meet | Compliancescores, momentopnames | Continue Monte Carlo-verdelingen met vermelde betrouwbaarheidsintervallen |
| Hoe het mensen behandelt | Voltooiingspercentages van training, ondertekende beleidsdocumenten | Gedrag als een dynamisch systeem met drempelwaarden en faseovergangen |
| Hoe het dreigingen vindt | Bekende CVE''s, bekende TTP''s, signature-updates van leveranciers | Gerandomiseerde multi-hop-simulatie, inclusief paden die geen enkele analist zou bedenken |
| Hoe het de toekomst behandelt | Neemt aan dat de toekomst op het verleden lijkt | Genereert vele alternatieve toekomsten en toont de spreiding |
| Wat het aan het bestuur vertelt | "We zijn 87% compliant" | "In 8,4% van de gesimuleerde campagnes bereikt de aanvaller een veiligheidskritiek systeem; dit is wat dat terugbrengt naar 3,1%, en dit is het betrouwbaarheidsinterval" |
| Hoe het omgaat met het onvoorstelbare | Kan het per definitie niet — de checklist bevat alleen wat al is gecontroleerd | Zoekt actief naar het zeldzame pad met grote gevolgen, juist omdat het zeldzaam is |

## Waarom de menselijke variabele geen zachte toevoeging is

Het deel van dit werk dat de meeste scepsis oproept, in mijn ervaring, is het behandelen van psychologie als engineering. Dat zou het minst controversiële deel moeten zijn. Talebs diepste punt in het hele boek is dat willekeur niet alleen "daarbuiten" zit in de markt of de faciliteit — ze zit *in ons*, in hoe wij waarnemen, rationaliseren, patronen op ruis overprojecteren, en achteraf verhalen construeren die toeval als onvermijdelijkheid laten lijken. Als dat waar is voor een fondsbeheerder die naar een winst-en-verliesrekening staart, is het minstens even waar voor een SOC-analist die om drie uur ''s nachts naar een meldingenwachtrij staart.

Daarom is de menselijke laag van de tweeling gebouwd om berekenbaar te zijn in plaats van anekdotisch. Een psychometrisch profiel voor elke actor in het systeem — verdediger en, waar gemodelleerd, aanvaller — beschrijft basisneigingen onder normale omstandigheden en voorspelt hoe de besluitvorming van elke persoon vervormt onder stress: welke vooroordelen worden geactiveerd, welke kortere wegen het overnemen, welke communicatielijnen als eerste falen. Een interactiemodel behandelt een responsteam zoals u een fysiek systeem met kinetische en potentiële energie zou behandelen: cognitieve belasting in beweging, plus de wrijving of de vloeiing tussen elk paar mensen dat samen aan het incident werkt. Onder rustige omstandigheden is die wrijving beheersbaar. Onder crisisomstandigheden kan zij pieken, net zoals assetcorrelaties pieken naar één tijdens een marktcrash — alles wat onafhankelijk leek, beweegt plotseling samen, en niet in een goede richting.

Er is een model van organisatiecultuur dat de wiskunde van een faseovergang leent: onder een kritiek stressniveau "verankert" de veiligheidscultuur van een organisatie zich — mensen volgen procedures, escaleren wat geëscaleerd moet worden, houden waakzaamheid vast. Boven die kritieke drempel — personeelsverloop, budgetdruk, meldingsmoeheid, een afgeleid leiderschapsteam — breekt de coherentie af, gaan individuen inconsistent handelen, en kan de organisatie geen gecoördineerde respons meer volhouden, ongeacht hoeveel technologie er op het netwerk zit. En dit is het verontrustende deel: de organisatie ziet er in beide toestanden identiek uit op papier. De compliancescore beweegt niet. De leveranciersstack is ongewijzigd. Maar het menselijke systeem is een drempel overgestoken, en het vermogen om gezamenlijk te reageren is stilletjes verdampt. Het is opnieuw Talebs kalkoen, alleen gemeten met een ander instrument: vertrouwen piekt de dag voor het mes, want vertrouwen volgde nooit werkelijk het risico.

Er is ook een cascademodel voor hoe een compromittering zich verspreidt — de wiskunde van een besmetting die het punt oversteekt waarop ze zelfvoorzienend wordt, geen verdere input van de tegenstander meer nodig heeft om te blijven groeien — en een model voor de nadering van een werkelijk crisispunt, waar twee mogelijke uitkomsten voor het systeem (een stabiele toestand en een instabiele grens) samenkomen en verdwijnen, waarna er geen stabiele toestand meer over is om naar terug te keren. De afstand tot dat punt krimpt niet-lineair naarmate u het nadert, wat precies is waarom deze gebeurtenissen van binnenuit plotseling aanvoelen: het systeem dreef al maandenlang naar de rand, en de zichtbare waarschuwingssignalen werden pas leesbaar in het laatste stuk van de nadering.

Niets hiervan wordt aangeboden als decoratie. Het is wat nodig is om te stoppen "de menselijke factor" te behandelen als een ongemodelleerde onbekende die wordt afgehandeld met een trainingsvideo, en te beginnen het te behandelen als wat het werkelijk is: een variabele met structuur, drempelwaarden en faalmodi, die in dezelfde simulatie zit als de firewalls en de firmware.

## Wat de oude aannames verkeerd doen

Conventionele OT/ICS-beveiliging rust op vijf aannames die, in Talebs raamwerk, kennistheoretisch identiek zijn aan de aannames die voorafgingen aan de ergste ontploffingen in de financiële geschiedenis:

1. **Het verleden is representatief voor de toekomst.** Als beheersmaatregelen drie jaar lang inbraken hebben voorkomen, wordt aangenomen dat ze werken.
2. **Risico is additief en lineair.** Voeg meer beheersmaatregelen toe, krijg evenredig meer beveiliging.
3. **Compliance impliceert beveiliging.** Als de audit zegt dat aan de norm is voldaan, wordt aangenomen dat de faciliteit beschermd is.
4. **Het dreigingslandschap is kenbaar.** Volg de juiste feeds, volg het juiste raamwerk, en het verdedigende team neemt aan dat het weet waartegen het opboksen is.
5. **Menselijk gedrag is een constante.** Aangenomen wordt dat het team op het volgende echte incident reageert zoals het reageerde op de laatste tabletop-oefening.

Elk van die aannames leeft aan de rechterkant van de tafel. En de gecorrigeerde versie van elk is geen mooier verhaal — het is een harder verhaal:

1. **Het verleden is één steekproefpad.** Drie jaar zonder inbraak is één traject door de kansruimte. Draai de Monte Carlo-simulatie en de meeste andere trajecten bevatten inbraken; sommige bevatten catastrofes. De geschiedenis vertelt u bijna niets over het toekomstige risico.
2. **Risico is niet-lineair en gecorreleerd.** Een firewall die één pad blokkeert, kan een vals gevoel van veiligheid creëren dat de waakzaamheid op de aangrenzende paden ondermijnt. Er zijn echte faseovergangen waarbij het toevoegen van complexiteit het nettorisico verhoogt in plaats van vermindert.
3. **Compliance is de kaart; de faciliteit is het territorium.** De afstand tussen de twee is groot in de meeste faciliteiten, groeit, en is onzichtbaar voor elk compliance-instrument dat momenteel op de markt is.
4. **Het dreigingslandschap omvat wat u zich nog niet kunt voorstellen.** Een simulatie die is gebouwd om gerandomiseerde reeksen te genereren, vindt paden die geen menselijke analist zou bedenken, omdat ze zich bevinden in delen van de toestandsruimte die nog niet in een feed zijn verschenen — juist omdat ze nog niet zijn gebeurd.
5. **Menselijk gedrag is een dynamisch systeem met faseovergangen**, een functie van stress, organisatorische temperatuur, cognitieve belasting en interpersoonlijke dynamiek die *tijdens* het incident verandert op manieren die wiskundig voorspelbaar zijn op populatieniveau, ook al zijn ze onvoorspelbaar voor elk individu.

## Asymmetrische positionering: NU / VOLGENDE / NOOIT

Taleb pleit niet voor verlamming in het licht van al deze onzekerheid. Hij pleit voor asymmetrische positionering — het structureren van uw blootstelling zodat catastrofale neerwaartse risico''s begrensd zijn en opwaarts potentieel open blijft, met een voorkeur voor strategieën waarbij het slechtste geval overleefbaar is boven strategieën die er gemiddeld goed uitzien maar een verborgen kans op ondergang dragen.

Dat vertaalt zich rechtstreeks in hoe wij investeringen prioriteren zodra de simulatie is gedraaid. Wij noemen het **NU / VOLGENDE / NOOIT**, en het rangschikt bewust niet op dezelfde manier als een compliancechecklist dat zou doen.

**NU** is het kleine aantal aanvalspaden dat voorkomt in een hoog aandeel van de simulaties, een doelwit met grote gevolgen bereikt, en tegen redelijke kosten te verhelpen is. Dit zijn zelden de zaken die een compliance-raamwerk als eerste zou signaleren. Het zijn de zaken die de kansverdeling als eerste signaleert, en het argument om ernaar te handelen komt met een vermeld betrouwbaarheidsinterval, niet met een onderbuikgevoel.

**VOLGENDE** is structurele verandering: segmentatie die de grootste eigenwaarde van het netwerk verlaagt en besmetting vertraagt, SBOM-remediatie gericht op de afhankelijkheidsknooppunten met de hoogste centraliteit, organisatorische veranderingen die de menselijke bruggen versterken die onder stress als eerste plegen te breken, technische beheersmaatregelen die echte barrières toevoegen tussen het cyberdomein en het fysieke proces.

**NOOIT** is alles wat goed scoort op een checklist en het gesimuleerde risico met bijna niets verplaatst — de leveranciersproducten wier referentieklanten survivorship-bevooroordeelde anekdotes zijn, de "best practices" die het beste zijn voor de gemiddelde faciliteit aan de rechterkant van de tafel en irrelevant voor uw specifieke faciliteit aan de linkerkant, de bewustzijnstraining die menselijke cognitie als een constante behandelt terwijl het model van organisatorische temperatuur laat zien dat u al dicht bij het punt bent waarop die aanname ophoudt te gelden.

Omdat u niet oneindig veel werk kunt verrichten, en doen alsof dat wel kan is zelf een rechterkant-van-de-tafel-waanidee — alleen een duurdere.

## Wat deze keuze werkelijk betekent

Wanneer u een Cyber Digital Twin-aanpak evalueert tegenover een conventioneel beveiligingsprogramma, kiest u niet tussen twee producten. U kiest tussen twee antwoorden op dezelfde vraag: *hoe weet ik of ik veilig ben?*

Het conventionele antwoord zegt: ik ben veilig omdat ik de beheersmaatregelen heb die het raamwerk vraagt, en de audit bevestigt het. Het antwoord dat is gebouwd op Talebs wereldbeeld zegt iets minder comfortabels en eerlijkers: dit is de kansverdeling van wat er gebeurt wanneer een echte tegenstander deze specifieke faciliteit aangaat, hier concentreert het risico zich, dit is het betrouwbaarheidsinterval, en dit is wat het getal daadwerkelijk zou verplaatsen.

Raamwerken zoals [IEC 62443](/nl/iec-62443) en [NIS2](/nl/nis2) zijn in dit beeld niet de vijand — ze coderen echte, hard bevochten kennis, en geen serieuze exploitant moet ze negeren. Maar ze zijn gebouwd om de rechterkant van de tafel goed te beschrijven, en ze zouden nooit in staat zijn geweest de linkerkant te beschrijven, omdat de linkerkant specifiek is voor uw apparatuur, uw mensen, uw patchgeschiedenis, en de geopolitiek van deze week — niet voor de gemiddelde faciliteit waarvoor het raamwerk moest worden geschreven. Zie ons bredere [Raamwerken](/nl/frameworks)-overzicht voor hoe deze normen zich tot elkaar verhouden en waar de blinde vlek van elk zich bevindt.

```cta
Wilt u liever uw eigen waarschijnlijkheidslandschap zien dan discussiëren over gemiddelden?
De Cyber Digital Twin maakt van uw OT-areaal een model dat u kunt stress-testen — zodat de weinige paden naar een veiligheidskritisch systeem zichtbaar worden voordat een aanvaller ze vindt.
Bekijk uw waarschijnlijkheidslandschap :: /nl/contact
```

## De kern van de zaak

Nassim Taleb heeft zijn hele carrière betoogd dat de financiële wereld zichzelf systematisch voor de gek hield — dat de instrumenten die zij gebruikte om risico te meten stilletjes waren gebouwd om risico juist te verbergen, dat de narratieven die werden geconstrueerd om succes te verklaren artefacten van survivorship bias waren, en dat de enige eerlijke positie de ongemakkelijke was: volledige kansruimte, kennistheoretische bescheidenheid, wiskundige nauwgezetheid, geen kortere wegen terug naar een geruststellend verhaal.

De beveiliging van kritieke infrastructuur heeft elke fout gemaakt die hij identificeerde, met hogere inzet, omdat de faalmodus hier geen opgeblazen fonds is. Het is een geactiveerd veiligheidssysteem, een besmette watervoorziening, een elektriciteitsnet dat niet meer aangaat. De [Cyber Digital Twin](/nl/cyber-digital-twin) is geen belofte dat uw faciliteit veilig is — niets eerlijks kan dat beloven. Het is een poging om u, met zoveel precisie en zoveel vermelde onzekerheid als de wiskunde toelaat, te vertellen hoe onveilig zij daadwerkelijk is, waar, via welke paden, met welke waarschijnlijkheid, en wat dat getal daadwerkelijk zou veranderen — geprioriteerd op data, begrensd door betrouwbaarheidsintervallen, niet door welke leverancier dit jaar het luidste podium kreeg.

De dreigingen voor kritieke infrastructuur gaan niet eenvoudiger of voorspelbaarder worden. De systemen waarvan de wereld afhankelijk is, gaan niet minder genetwerkt, minder geautomatiseerd, of minder doelwit worden. De enige echte vraag is of de mensen die verantwoordelijk zijn voor het verdedigen ervan kiezen voor het comfort van de rechterkant van de tafel, of het moeilijkere, eerlijkere werk van de linkerkant doen.

De willekeur is niet de vijand. Doen alsof zij niet bestaat, is dat wel.

## Bronnen en verder lezen

Dit stuk put uit Nassim Nicholas Talebs *Fooled by Randomness* (2001) — de behandeling daarin van survivorship bias, de narratieve drogreden, scheve uitbetalingsstructuren, en de "twee kanten van de tafel" — en uit de interne architectuurbriefings van OXOT over de Cyber Digital Twin, die de graaf met zeven lagen, de Monte Carlo-voorspellingspijplijn, en het NU/VOLGENDE/NOOIT-prioriteringsraamwerk beschrijven. Voor de onderliggende technologie, zie [Cyber Digital Twin](/nl/cyber-digital-twin); voor het normenlandschap waarnaast deze aanpak staat, zie [IEC 62443](/nl/iec-62443), [NIS2](/nl/nis2), en [Raamwerken](/nl/frameworks).', true, 'Fooled by Randomness in OT-beveiliging | OXOT', 'Taleb toonde aan dat markten geluk met vaardigheid verwarren. OT-beveiliging maakt dezelfde fout — zo meet de Cyber Digital Twin risico dat een schone audit niet ziet.', 'Een schone audit en een rustig jaar zijn geen bewijs dat uw OT-beveiliging werkt — het is één steekproefpad door een veel grotere ruimte van uitkomsten, en de Cyber Digital Twin bestaat om u de rest van die ruimte te laten zien.', NULL, 'article', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('ot-security-assessments', 'nl', 'OT-securityassessments', 'Een OT-securityassessment van OXOT begint waar uw risico daadwerkelijk zit: op de werkvloer. We redeneren eerst vanuit proces, veiligheid en continuïteit — niet vanuit kantoor-IT die op operationele technologie is gekopieerd. Het doel is geen nieuwe map met bevindingen, maar een helder, geprioriteerd beeld van waar u staat en wat u vervolgens moet doen, onderbouwd met bewijs dat van u is.

We werken passief-eerst. De inventarisatie is ontworpen om zonder verstoring van de productie te draaien, en elke conclusie is te herleiden tot iets waarneembaars in uw omgeving — geen aanname.

```keyfacts
Scope :: een locatie, een lijn of een afgebakende zone — uw keuze
Duur :: doorgaans 2–6 weken, afhankelijk van de scope
Basis :: IEC 62443-3-2 risicobeoordeling + uw operationele risico
Aanpak :: passief-eerst — geen impact op de productie
Resultaat :: een geprioriteerd risicoregister en een verdedigbare routekaart
Oplevering :: besluiten die u kunt verdedigen tegenover directie of toezichthouder
```

## Wat u krijgt

```cards
Asset- en zonebeeld :: /nl/contact :: Een helder overzicht van assets, verbindingen en zones — de kaart die de meeste OT-omgevingen missen.
Geprioriteerd risicoregister :: /nl/contact :: Risico''s gerangschikt op impact voor veiligheid, continuïteit en productie, niet op ruwe CVSS.
Quick wins vs. structurele fixes :: /nl/contact :: Een korte lijst om nu op te handelen, gescheiden van de diepere investeringen die een programma vragen.
Directieklare samenvatting :: /nl/contact :: Eén pagina waarmee uw leiding en auditors daadwerkelijk besluiten kunnen nemen.
```

## Hoe het werkt

```timeline
1. Scope & veiligheid :: Bepaal de grens, de kroonjuwelen en de spelregels — veiligheid eerst.
2. Passieve inventarisatie & interviews :: Observeer verkeer en assets zonder de productie te raken; spreek met wie de installatie draait.
3. Risicoanalyse :: Koppel bevindingen aan zones en conduits en rangschik ze op operationele impact (IEC 62443-3-2).
4. Bevindingenworkshop :: Neem uw team mee door wat we vonden en bepaal samen de prioriteiten.
5. Routekaart :: Een gefaseerde set acties — quick wins eerst, structurele fixes in stappen.
```

## Waar het past

Een OXOT-assessment is opgebouwd rond de **IEC 62443-3-2** risicobeoordeling, en de uitkomst voedt direct uw **NIS2**-risicobeheerverplichtingen en eventueel **Cyber Resilience Act**-productwerk. Het is ook de logische eerste stap vóór een security-**baseline**, een **programma** of een **Cyber Digital Twin**.

```cta
Begin met een assessment
Krijg een helder, verdedigbaar beeld van uw OT-securityhouding — om te beginnen op één locatie.
Praat met een OT-beveiligingsexpert :: /nl/contact
```', true, 'OT-securityassessments | OXOT', 'Een OT-first securityassessment dat begint bij uw installatie, niet bij een generieke checklist — inzicht in assets en zones, een geprioriteerd risicoregister en een verdedigbare routekaart, afgestemd op IEC 62443 en NIS2.', 'Begrijp uw huidige OT-securityhouding, de risico''s die er echt toe doen en de praktische vervolgstappen — afgestemd op uw operationele realiteit.', NULL, 'page', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('ot-security-baseline', 'nl', 'OT-securitybaseline', 'Een baseline is de ondergrens die iedereen moet halen — de maatregelen die overal waar moeten zijn voordat u over het geavanceerde werk begint. OXOT definieert een OT-securitybaseline die realistisch is voor uw installaties, herhaalbaar over locaties en gekoppeld aan IEC 62443-securityniveaus, zodat "veilig genoeg" overal hetzelfde betekent.

Het gaat om consistentie en bewijs: een baseline die u locatie voor locatie kunt uitrollen, kunt aantonen te hebben gehaald en zonder haastwerk aan een auditor kunt overhandigen.

```keyfacts
Doel :: een minimumstandaard die elke locatie echt kan halen
Basis :: IEC 62443-doelsecurityniveaus (SL-1 / SL-2)
Scope :: gedefinieerd per zone en assetklasse
Vorm :: een maatregelenchecklist met bewijseisen
Uitrol :: locatie voor locatie, met een uitzonderingsproces
Resultaat :: consistente, auditbare OT-security
```

## Wat u krijgt

```cards
Maatwerk-maatregelenbaseline :: /nl/contact :: Een minimale set maatregelen geschreven voor uw omgeving en risicobereidheid, geen generiek sjabloon.
Toepasbaarheid per zone :: /nl/contact :: Welke maatregelen waar gelden — gekoppeld aan zones en assetklassen, zodat het op de werkvloer realistisch is.
Bewijssjablonen :: /nl/contact :: Eenvoudige, herhaalbare manieren om aan te tonen dat elke maatregel op orde is.
Uitrol- & uitzonderingsproces :: /nl/contact :: Een pad om de baseline locatie voor locatie toe te passen, en een gedisciplineerde omgang met uitzonderingen.
```

## Hoe het werkt

```timeline
1. Definiëren :: Bepaal de doelsecurityniveaus en de maatregelen die de ondergrens vormen.
2. Op maat maken :: Pas de baseline aan uw zones, assetklassen en operationele beperkingen aan.
3. Piloteren :: Pas hem toe op één locatie en verfijn wat praktisch is.
4. Uitrollen :: Breid uit locatie voor locatie, met bijhouden van dekking en uitzonderingen.
5. Borgen :: Verzamel bewijs en bevestig dat de baseline standhoudt over tijd.
```

## Waar het past

Een baseline drukt uw **IEC 62443**-doelsecurityniveaus concreet uit, voldoet aan de **NIS2**-eis van passende minimummaatregelen en geeft productteams een **Cyber Resilience Act**-vertrekpunt. Het is de natuurlijke aanvulling op een **assessment** en de ruggengraat van een **programma**.

```cta
Leg overal de ondergrens
Definieer een OT-securitybaseline die realistisch te halen en eenvoudig aan te tonen is.
Praat met een OT-beveiligingsexpert :: /nl/contact
```', true, 'OT-securitybaseline | OXOT', 'Een minimale set OT-beveiligingsmaatregelen die realistisch, herhaalbaar en afgestemd zijn op hoe uw installaties echt draaien — een verdedigbare ondergrens, gekoppeld aan IEC 62443-securityniveaus, NIS2-minimummaatregelen en de CRA.', 'Definieer minimale beveiligingsmaatregelen die realistisch, herhaalbaar en afgestemd op operationele behoeften zijn.', NULL, 'page', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('ot-security-programmes', 'nl', 'OT-securityprogramma''s', 'De meeste organisaties hebben geen gebrek aan bevindingen — ze missen een manier om ze te realiseren. Een OXOT-securityprogramma vertaalt een stapel aanbevelingen naar een gefaseerde, bestuurde, meerlocatie-inspanning die meetbare risicoreductie oplevert, niet alleen activiteit.

We prioriteren op operationeel risico, werken in golven die u kunt absorberen, en rapporteren voortgang in taal die uw directie en toezichthouders begrijpen. Het resultaat is een programma dat uw eigen team steeds meer zelf draagt.

```keyfacts
Horizon :: doorgaans 12–36 maanden, in golven
Scope :: over locaties, bedrijfsonderdelen of regio''s
Governance :: een stuurmodel met heldere KPI''s
Basis :: risicogebaseerde prioritering, IEC 62443-levenscyclus
Model :: een eigen Cyber Digital Twin houdt prioriteiten actueel
Resultaat :: meetbare, rapporteerbare risicoreductie
```

## Wat u krijgt

```cards
Programmaplan & business case :: /nl/contact :: Een gebudgetteerd, gefaseerd plan gekoppeld aan risicoreductie — iets wat de leiding met vertrouwen kan financieren.
Governance & KPI''s :: /nl/contact :: Een stuurstructuur, rollen en metrics zodat het programma op koers en aanspreekbaar blijft.
Geprioriteerde remediatie-backlog :: /nl/contact :: Elke actie gerangschikt op operationele impact, gegroepeerd in haalbare golven.
Rapportage op directieniveau :: /nl/contact :: Voortgang en restrisico in taal waarmee uw leiding en auditors kunnen handelen.
```

## Hoe het werkt

```timeline
1. Mobiliseren :: Zet governance op, bevestig de scope en bepaal het huidige risicobeeld.
2. Prioriteren :: Rangschik de backlog op operationele impact en zet hem in golven.
3. In golven uitvoeren :: Lever verbeteringen locatie voor locatie, in een tempo dat de operatie aankan.
4. Meten :: Volg risicoreductie ten opzichte van de nulmeting en rapporteer erover.
5. Bestendigen :: Draag eigenaarschap over zodat het programma zonder externe afhankelijkheid doorloopt.
```

## Waar het past

Een programma maakt **NIS2**-governance en bestuurlijke verantwoordelijkheid operationeel, en voert verbeteringen door over de volledige **IEC 62443**-levenscyclus. Het volgt doorgaans op een **assessment** en wordt verankerd door een **Cyber Digital Twin** zodat prioriteiten actueel blijven.

```cta
Van bevindingen naar realisatie
Geef uw OT-securityinspanning de governance, fasering en het bewijs die nodig zijn om te slagen.
Praat met een OT-beveiligingsexpert :: /nl/contact
```', true, 'OT-securityprogramma''s | OXOT', 'Vertaal assessmentbevindingen naar een gestructureerd, meerlocatie OT-securityverbeterprogramma dat ook echt wordt gerealiseerd — governance, KPI''s, een geprioriteerde backlog en meetbare risicoreductie.', 'Ontwerp en voer gestructureerde OT-securityverbeterprogramma''s uit over locaties, bedrijfsonderdelen of regio''s — met governance en meetbare resultaten.', NULL, 'page', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('secure-remote-access', 'nl', 'Veilige externe toegang', 'Externe toegang is waar de meeste OT-incidenten beginnen: OEM-onderhoudstunnels, vergeten leveranciersaccounts en connectiviteit die organisch groeide en nooit werd geïnventariseerd. OXOT vervangt die wildgroei door least-privilege, gebrokerde en gemonitorde toegang — zo ontworpen dat onderhoud gewoon doorgaat.

Elk pad in en uit wordt geïnventariseerd, elke sessie wordt geauthenticeerd en opgenomen, en leveranciers krijgen precies de toegang die ze nodig hebben, alleen wanneer ze die nodig hebben.

```keyfacts
Probleem :: wildgroei van leverancier-/OEM-toegang, geen inventaris
Principe :: least privilege, gebrokerd, altijd gemonitord
Dekking :: medewerkers, leveranciers en OEM''s
Maatregelen :: MFA, just-in-time toegang, sessieopname
Norm :: IEC 62443-toegangsbeheer, NIS2-toeleveringsketen
Resultaat :: volledig auditbare externe toegang
```

## Wat u krijgt

```cards
Inventaris externe toegang :: /nl/contact :: Elk pad naar OT — wie, vanwaar, naar wat — met het risico van elk pad zichtbaar gemaakt.
Gebrokerd toegangsontwerp :: /nl/contact :: Eén gecontroleerd toegangspunt dat elke sessie bemiddelt en opneemt.
MFA, JIT & sessieopname :: /nl/contact :: Sterke authenticatie, tijdgebonden toegang en een volledig verslag van wat er gebeurde.
Leverancierstoegangsbeleid :: /nl/contact :: Heldere regels voor OEM''s en derden die uw team kan handhaven en auditen.
```

## Hoe het werkt

```timeline
1. Toegang inventariseren :: Vind en documenteer elk extern pad naar uw OT-omgeving.
2. Gebrokerd model ontwerpen :: Eén bemiddeld toegangspunt met standaard least-privilege.
3. Piloteren :: Bewijs het model met één leverancier of één locatie vóór opschaling.
4. Uitrollen :: Migreer toegangspaden naar het gebrokerde model en ontmantel de rest.
5. Monitoren :: Neem sessies op en beoordeel toegang doorlopend.
```

## Waar het past

Veilige externe toegang dient direct de **IEC 62443**-toegangsbeheervereisten en de **NIS2**-verwachtingen rond toeleveringsketen en toegangsbeheer. Het werkt hand in hand met **Architectuur & segmentatie** — de broker zit op een gecontroleerde conduit tussen zones.

```cta
Sluit de meest gebruikte ingang
Maak van externe toegang — uw grootste blootstelling — een gecontroleerde, auditbare capaciteit.
Praat met een OT-beveiligingsexpert :: /nl/contact
```', true, 'Veilige externe OT-toegang | OXOT', 'Verminder risico van leverancierstoegang, onderhoud op afstand en externe connectiviteit naar OT — least-privilege, gebrokerde en gemonitorde toegang met MFA, just-in-time en sessieopname, afgestemd op IEC 62443 en NIS2.', 'Verminder risico van leverancierstoegang, onderhoud op afstand en externe connectiviteit — zonder de bedrijfsvoering te verstoren.', NULL, 'page', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('ts-50701', 'nl', 'TS 50701 — Cybersecurity voor spoorwegen', 'Een moderne trein is een datacenter op wielen dat door een netwerk rijdt dat zich uitstrekt over een heel land. Seingevingsinterlockings, boordbesturingseenheden, verkeersmanagementsystemen, reizigersinformatie, langs het spoor geplaatste sensoren, remote-onderhoudsverbindingen — het is allemaal inmiddels digitaal, veel ervan verbonden, en elk onderdeel moet dertig jaar of langer veilig blijven functioneren. Het spoor is een van de moeilijkste plekken ter wereld om cybersecurity toe te passen: veiligheidskritisch, geografisch wijdverspreid, opgebouwd uit een lange keten van leveranciers, en geregeerd door een veiligheidscultuur die ouder is dan het internet.

Lange tijd had het spoor geen eigen cybersecuritynorm. Ingenieurs leenden generieke industriële richtlijnen, rekten die uit over de spoorwegarchitectuur en hoopten dat de pasvorm goed genoeg was. **CLC/TS 50701 maakte een einde aan die improvisatie.** Gepubliceerd in juli 2021, is dit de eerste cybersecurityspecificatie die specifiek is geschreven voor spoorwegtoepassingen, en het is uitgegroeid tot het referentiepunt voor het beveiligen van seingeving, control-command, rollend materieel en spoorweginfrastructuur in heel Europa en daarbuiten.

## De korte versie

- **CLC/TS 50701** is een CENELEC Technical Specification voor **cybersecurity in spoorwegtoepassingen**. De eerste editie werd gepubliceerd in **juli 2021** — ''s werelds eerste uitgebreide cybersecurityspecificatie die speciaal voor het spoor is gebouwd. Een **tweede editie (CLC/TS 50701:2023)** volgde in augustus 2023. ([CLC/TS 50701:2023-gids, iTeh](https://standards.iteh.ai/catalog/standards/clc/db257ea9-8ba0-4f4c-a791-df34a6030541/clc-ts-50701-2023))
- Het is **geen op zichzelf staand document**. Het **past de [IEC 62443](/nl/iec-62443)-reeks toe** op de spoorwegcontext, waarbij de beveiligingsmodellen, concepten en het risicobeoordelingsproces worden aangepast — met name steunend op **IEC 62443-3-2** en **62443-3-3**. ([ENISA / CENELEC](https://www.enisa.europa.eu/sites/default/files/all_files/05-standards-02-cenelec-christian-schlehuber.pdf))
- Het integreert met de **RAMS-levenscyclus** voor spoorwegen zoals gedefinieerd in **EN 50126-1**, zodat cybersecurity samen met betrouwbaarheid, beschikbaarheid, onderhoudbaarheid en veiligheid wordt ontworpen — en niet achteraf wordt toegevoegd.
- Het is opgesteld door **CENELEC TC 9X/WG 26**, een werkgroep van tientallen Europese spoorweg- en beveiligingsexperts, en voedt nu rechtstreeks de komende **internationale norm IEC 63452**. ([Alstom](https://www.alstom.com/press-releases-news/2024/3/towards-first-railway-cybersecurity-international-standard-why-standards-are-important-secure-railways))

> [!NOTE]
> Een opmerking over de naamgeving. U ziet dit document geschreven als **CLC/TS 50701**, **TS 50701**, of met een jaartalsuffix (**:2021**, **:2023**). "CLC" markeert het als een CENELEC-uitgave; "TS" markeert het als een Technical Specification in plaats van een volwaardige Europese Norm. De eerste editie uit 2021 en de tweede editie uit 2023 zijn hetzelfde document dat rijper wordt, niet twee concurrerende normen.

```keyfacts
Type :: CENELEC Technical Specification (CLC/TS) — geen volwaardige EN
Eerste editie :: juli 2021 — ''s werelds eerste spoorspecifieke cybersecurityspec
Huidige editie :: CLC/TS 50701:2023
Gebouwd op :: IEC 62443 (m.n. 3-2, 3-3, 4-2, 4-1)
Veiligheidslevenscyclus :: integreert met EN 50126-1 (RAMS)
Reikwijdtedomeinen :: Communicatie · Seingeving & Verwerking · Rollend Materieel · Vaste Installaties
Veiligheid–security-brug :: CSM-RA + IEC 62443-3-3
Opgesteld door :: CENELEC TC 9X/WG 26
Wordt :: IEC 63452 — de eerste internationale cybersecuritynorm voor het spoor
Regelgevende druk :: NIS2 (essentiële entiteiten) + CRA (producten met digitale elementen)
```

## Waarom het spoor een eigen specificatie nodig had

Het spoor bevindt zich op het snijvlak van twee werelden die zelden dezelfde taal spreken.

Aan de ene kant staat een volwassen, diepgaand gecodificeerde **veiligheidsdiscipline** (safety). De CENELEC EN 5012x-familie — EN 50126 voor de RAMS-levenscyclus, EN 50128/EN 50716 voor software, EN 50129 voor veiligheidsgerelateerde elektronische systemen — bepaalt al decennialang hoe de sector aantoont dat haar systemen veilig zijn. Het is rigoureus, bewijsgedreven en gebouwd rond één leidende vraag: kan dit systeem op gevaarlijke wijze falen?

Aan de andere kant staat **cybersecurity**, een sneller bewegend vakgebied dat eerst werd gevormd door IT en vervolgens door generieke industriële besturingssystemen. De leidende vraag daar is anders: kan een tegenstander dit systeem iets laten doen wat het niet zou mogen doen?

Geen van beide werelden paste op zichzelf bij het spoor. De veiligheidsnormen waren geschreven voor willekeurige storingen en menselijke fouten, niet voor doelbewuste, intelligente aanvallers die aftasten, zich aanpassen en wachten. Generieke beveiligingsnormen wisten op hun beurt niets van de RAMS-levenscyclus, de bijzondere architectuur van interlockings en balises, of het feit dat een firewallregel die om beveiligingsredenen wordt aangescherpt — als deze het verkeerde pakket laat vallen — een veiligheidsfunctie kan aantasten.

TS 50701 is geschreven om die kloof te dichten. Het neemt de beproefde machinerie van [IEC 62443](/nl/iec-62443) — zones en conduits, security levels, een gestructureerd risicobeoordelingsproces — en herformuleert deze in termen die een spoorwegingenieur al herkent, rechtstreeks verweven met de veiligheidslevenscyclus die hij of zij al volgt. Het gestelde doel is bot en het is de moeite waard om de essentie te citeren: waarborgen dat de RAMS-eigenschappen van spoorwegsystemen niet kunnen worden verminderd, verloren of gecompromitteerd door een opzettelijke aanval. ([Shieldworkz](https://shieldworkz.com/blogs/a-deep-dive-into-cenelec-ts-50701-for-railway-cybersecurity))

> [!IMPORTANT]
> De veronderstelling onder de hele specificatie: in het spoor geldt dat **als een systeem niet veilig (security) is, de veiligheid (safety) ervan niet kan worden gegarandeerd.** Security staat hier niet naast safety. Het is er een voorwaarde voor.

## Gebouwd op IEC 62443

TS 50701 vindt cybersecurity-engineering niet opnieuw uit — het erft het. De specificatie stelt expliciet dat haar beveiligingsmodellen, concepten en risicobeoordelingsproces zijn gebaseerd op of afgeleid van de [IEC 62443](/nl/iec-62443)-reeks. Twee delen doen het meeste werk.

- **IEC 62443-3-2 — Risicobeoordeling van beveiliging voor systeemontwerp.** Dit is de bron van de zones-en-conduits-methodologie en de workflow die voor elke zone een target security level oplevert. TS 50701 neemt dit risicoproces vrijwel integraal over en past het vervolgens aan aan de realiteit van het spoor.
- **IEC 62443-3-3 — Systeembeveiligingseisen en security levels.** Dit levert de catalogus van technische eisen, gegroepeerd onder de zeven **fundamentele eisen** (identificatie en authenticatie, gebruikscontrole, systeemintegriteit, vertrouwelijkheid van gegevens, beperkte gegevensstroom, tijdige reactie op gebeurtenissen, beschikbaarheid van middelen), en de schaal SL-1 tot en met SL-4 die aangeeft hoe sterk de bescherming moet zijn.

Op componentniveau reikt het werk verder de reeks in — **IEC 62443-4-2** voor de technische beveiligingseisen van individuele producten, en **IEC 62443-4-1** voor de secure development lifecycle die een leverancier volgt. TS 50701 put ook uit een dreigingsbibliotheek om de beoordeling te voeden; latere edities noemen **MITRE ATT&CK for ICS** als voorbeeld. ([iTeh](https://standards.iteh.ai/catalog/standards/clc/db257ea9-8ba0-4f4c-a791-df34a6030541/clc-ts-50701-2023))

Onderstaande tabel brengt de relatie deel voor deel in kaart.

| IEC 62443-deel | Wat het biedt | Hoe TS 50701 het gebruikt |
| --- | --- | --- |
| 62443-1-1 | Concepten, terminologie, modellen | Basiswoordenschat — zones, conduits, security levels — meegenomen naar het spoor |
| 62443-2-1 | Beveiligingsmanagementsysteem voor de asset owner | Bepaalt hoe operators en infrastructuurbeheerders hun programma uitvoeren |
| 62443-3-2 | Risicobeoordeling voor systeemontwerp | Kern van het TS 50701-risicoproces; aangepast aan spoorwegassets en de RAMS-levenscyclus |
| 62443-3-3 | Systeembeveiligingseisen & security levels | Eisencatalogus en SL 1–4-schaal, waarnaar wordt verwezen naast veiligheidsmethoden |
| 62443-4-1 | Secure product development lifecycle | Verwachting die aan leveranciers van spoorwegcomponenten wordt gesteld |
| 62443-4-2 | Technische beveiligingseisen op componentniveau | Rechtstreeks aangehaald voor specificatie en testen op componentniveau |

> [!TIP]
> Als uw organisatie [IEC 62443](/nl/iec-62443) al begrijpt, bent u al een heel eind op weg om TS 50701 te begrijpen. De engineeringlogica is identiek; wat verandert, is de woordenschat van de assets en de levenscyclus waarin u het inpast. Werk dat voor de ene norm is verricht, is overdraagbaar naar de andere.

### De zeven fundamentele eisen, in spoorwegtermen

De eisencatalogus die TS 50701 erft van IEC 62443-3-3 is geordend onder **zeven fundamentele eisen (FR''s)**. Ze klinken abstract totdat u elke eis vertaalt naar een spoorwegasset — waarna ze een inspectiechecklist voor een seingevingsareaal worden.

| FR | IEC 62443-naam | Wat het op het spoor betekent |
| --- | --- | --- |
| **FR 1** | Identificatie- & authenticatiecontrole | Elke onderhoudsmonteur, engineer en tool op afstand die een interlocking of boordeenheid raakt, is uniek geïdentificeerd en geauthenticeerd — geen gedeelde "onderhouds"-logins op veiligheidskritische apparatuur |
| **FR 2** | Gebruikscontrole | Een geauthenticeerde gebruiker mag alleen doen wat zijn rol toestaat; een diagnostische sessie mag geen rijweginstellingscommando worden |
| **FR 3** | Systeemintegriteit | Seingevingslogica, ETCS-data en firmware kunnen niet ongemerkt worden gewijzigd — integriteitscontroles en ondertekende updates bewaken de veiligheidsfunctie |
| **FR 4** | Vertrouwelijkheid van gegevens | Dienstregelingen, sleutels en configuratie in transit over baan- of radioverbindingen worden beschermd tegen openbaarmaking waar die openbaarmaking een aanval mogelijk zou maken |
| **FR 5** | Beperkte gegevensstroom | Zones en conduits dwingen af dat een reizigersnetwerk geen seingevingszone kan bereiken; de conduit is het enige pad, en die is gecontroleerd |
| **FR 6** | Tijdige reactie op gebeurtenissen | Het areaal kan een beveiligingsgebeurtenis op een baancontroller detecteren en loggen en reageren voordat deze een veiligheidsgebeurtenis wordt |
| **FR 7** | Beschikbaarheid van middelen | Denial-of-service tegen een verkeersmanagementsysteem of een treinbesturingsnetwerk mag de beschikbaarheid niet aantasten — de RAMS-"A" is ook een beveiligingsdoel |

Hoe hoger het target security level van een zone, hoe meer van de eisverzwaringen van elke FR van toepassing zijn — precies zo eindigt een seingevingsinterlocking (SL-3/SL-4) met veel strengere maatregelen dan een reizigersinformatiedisplay (SL-1/SL-2), ook al worden beide beoordeeld aan de hand van dezelfde zeven kopjes.

```svg
<svg viewBox="0 0 700 430" xmlns="http://www.w3.org/2000/svg" font-family="system-ui, sans-serif">
  <rect width="700" height="430" fill="none"/>
  <text x="350" y="30" fill="#e5e7eb" font-size="19" font-weight="700" text-anchor="middle">TS 50701 — waarop het steunt, waarop het aansluit</text>

  <!-- Foundation: IEC 62443 -->
  <rect x="70" y="330" width="560" height="70" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="350" y="360" fill="#e5e7eb" font-size="15" font-weight="700" text-anchor="middle">IEC 62443-reeks — fundament</text>
  <text x="350" y="382" fill="#94a3b8" font-size="12" text-anchor="middle">zones &amp; conduits · security levels SL 1–4 · risicoproces (3-2, 3-3, 4-2)</text>

  <!-- TS 50701 middle layer -->
  <rect x="130" y="200" width="440" height="90" rx="8" fill="none" stroke="#f97316" stroke-width="2.5"/>
  <text x="350" y="235" fill="#e5e7eb" font-size="17" font-weight="700" text-anchor="middle">CLC/TS 50701</text>
  <text x="350" y="258" fill="#94a3b8" font-size="12" text-anchor="middle">IEC 62443 aangepast aan het spoor · beheert de veiligheid–security-interface</text>
  <text x="350" y="276" fill="#94a3b8" font-size="12" text-anchor="middle">spoorweg-assettypen · dreigings- &amp; gevolgmodel voor het spoor</text>

  <!-- Top left: RAMS lifecycle -->
  <rect x="70" y="70" width="250" height="90" rx="8" fill="none" stroke="#94a3b8" stroke-width="2"/>
  <text x="195" y="100" fill="#e5e7eb" font-size="14" font-weight="700" text-anchor="middle">EN 50126 RAMS-levenscyclus</text>
  <text x="195" y="122" fill="#94a3b8" font-size="12" text-anchor="middle">security verweven in de</text>
  <text x="195" y="138" fill="#94a3b8" font-size="12" text-anchor="middle">fasen die het spoor al gebruikt</text>

  <!-- Top right: regulation -->
  <rect x="380" y="70" width="250" height="90" rx="8" fill="none" stroke="#94a3b8" stroke-width="2"/>
  <text x="505" y="100" fill="#e5e7eb" font-size="14" font-weight="700" text-anchor="middle">Regelgeving &amp; veiligheidsmethode</text>
  <text x="505" y="122" fill="#94a3b8" font-size="12" text-anchor="middle">NIS2 · CRA · CSM-RA</text>
  <text x="505" y="138" fill="#94a3b8" font-size="12" text-anchor="middle">verplichtingen waaraan het spoor moet voldoen</text>

  <!-- connectors -->
  <line x1="350" y1="330" x2="350" y2="290" stroke="#3b82f6" stroke-width="2" marker-end="url(#ar)"/>
  <line x1="250" y1="200" x2="220" y2="160" stroke="#94a3b8" stroke-width="2" marker-end="url(#ar)"/>
  <line x1="450" y1="200" x2="480" y2="160" stroke="#94a3b8" stroke-width="2" marker-end="url(#ar)"/>

  <defs>
    <marker id="ar" markerWidth="9" markerHeight="9" refX="7" refY="4.5" orient="auto">
      <path d="M0,0 L9,4.5 L0,9 Z" fill="#94a3b8"/>
    </marker>
  </defs>
</svg>
```

## Integratie met de RAMS-levenscyclus

Wat TS 50701 onmiskenbaar tot een *spoorweg*-document maakt, in plaats van IEC 62443 met een nieuw omslag, is hoe het aansluit op **EN 50126-1** — de norm die de RAMS-levenscyclus definieert: Reliability, Availability, Maintainability en Safety (betrouwbaarheid, beschikbaarheid, onderhoudbaarheid en veiligheid). In plaats van een apart, parallel cybersecurityproces naast het bestaande proces te laten lopen, verankert TS 50701 security in dezelfde fasen die het spoor al gebruikt om een systeem te specificeren, ontwerpen, verifiëren, accepteren en bedrijven. ([Cylus](https://www.cylus.com/post/navigating-ts-50701-unpacking-the-impact-of-the-cybersecurity-standard-for-rail))

Het punt is geen administratieve netheid. Het is dat een beveiligingsbeslissing die los van de veiligheidslevenscyclus wordt genomen, een beslissing is die blind wordt genomen. Door zich door EN 50126 heen te weven, dwingt de specificatie security- en safety-engineers om op hetzelfde moment bij dezelfde ontwerppoorten uit te komen, kijkend naar hetzelfde systeem.

| EN 50126-levenscyclusfase | Wat er gebeurt voor safety | Wat TS 50701 toevoegt voor security |
| --- | --- | --- |
| Concept | Doel en context van het systeem bepalen | Cybersecuritycontext, assets op hoog niveau en dreigingslandschap vaststellen |
| Risicoanalyse & -evaluatie | Identificatie van gevaren, veiligheidsrisicobeoordeling | Cybersecurity-risicobeoordeling; zones, conduits en target security levels bepalen |
| Specificatie van eisen | RAMS-eisen afleiden | Cybersecurity-eisen afleiden uit target SL''s en het dreigingsmodel |
| Ontwerp & implementatie | Bouwen volgens veiligheidseisen | Beveiligingsmaatregelen toepassen; controleren dat ze veiligheidsfuncties niet ondermijnen |
| Fabricage / integratie | Assembleren en integreren | Beveiligingseisen op componentniveau verifiëren (verwijzingen naar IEC 62443-4-2) |
| Validatie & acceptatie | Aantonen dat aan RAMS wordt voldaan | Aantonen dat aan beveiligingseisen wordt voldaan; restrisico documenteren |
| Exploitatie & onderhoud | Het systeem veilig houden tijdens gebruik | Kwetsbaarhedenbeheer, patchen, monitoring, incidentrespons |
| Buitendienststelling | Veilig uit dienst nemen | Veilige verwerking, vernietiging van sleutels en gegevens, intrekking |

> [!NOTE]
> Omdat TS 50701 kan worden toegepast op systemen die **binnen of buiten** het EN 50126-1-proces zijn ontwikkeld, is het bruikbaar voor zowel bestaande installaties als nieuwbouw. Oudere assets hebben zelden de moderne RAMS-levenscyclus letterlijk gevolgd, maar de risicologica blijft van toepassing.

## De veiligheid–security-interface

Dit is het onderdeel van TS 50701 dat geen equivalent kent in generieke OT-beveiligingsnormen, en de reden waarom het spoor een eigen spoorwegspecificatie nodig heeft.

In de meeste sectoren kunnen safety en security relatief los van elkaar worden beschouwd. In het spoor zijn ze verstrengeld. Een maatregel die wordt ingevoerd om de security te verbeteren, kan een veiligheidsfunctie aantasten — latentie toevoegen aan een veiligheidskritisch berichtenpad, een diagnostisch kanaal blokkeren waarvan een veiligheidssysteem afhankelijk is, of een operator buitensluiten tijdens een noodsituatie. Omgekeerd kan een veiligheidsmaatregel een beveiligingsrisico openen of sluiten — een "fail-safe"-standaardinstelling die naar een bekende toestand terugvalt, kan precies de toestand zijn die een aanvaller wil afdwingen.

TS 50701 geeft deze interface een formele plaats. Het vereist dat cybersecuritywerk relevante veiligheidsgerelateerde aspecten meeneemt, en het put uit gevestigde veiligheidsmachinerie — met name de **Common Safety Method for Risk Assessment (CSM-RA)**, de EU-verordening die regelt hoe significante wijzigingen aan het spoorwegsysteem worden risicobeoordeeld — naast beveiligingsbronnen zoals IEC 62443-3-3. ([Shieldworkz](https://shieldworkz.com/blogs/a-deep-dive-into-ts-50701-based-risk-and-security-assessment)) Latere edities van de specificatie gaan verder en bevelen **gezamenlijke ontwerpbeoordelingen** aan, zodat safety- en security-engineers wijzigingen samen beoordelen in plaats van na elkaar.

Het contrast tussen de twee disciplines is de moeite waard om duidelijk uiteen te zetten, want het beheren van de interface betekent dat de verschillen worden gerespecteerd.

| Aandachtspunt | Safety (EN 5012x-wereld) | Security (IEC 62443-wereld) |
| --- | --- | --- |
| Voornaamste dreiging | Willekeurige storing, systematische fout, menselijke fout | Doelbewuste, adaptieve tegenstander |
| Leidende vraag | Zal het gevaarlijk falen? | Kan het worden verleid tot ongewenst gedrag? |
| Tijdshorizon | Vastgesteld na certificering; jarenlang stabiel | Dreigingslandschap verandert voortdurend |
| Bewijs | Veiligheidsdossier (safety case), gevarenlogboek, formeel bewijs | Risicobeoordeling, maatregelen, monitoring, testen |
| Verandering | Strikt beheerst, opnieuw gecertificeerd | Verwacht en frequent (patches, updates) |
| Faalmodus | Overgaan naar een bekende veilige toestand | De tegenstander zijn doel ontzeggen |

> [!WARNING]
> De klassieke valkuil in het spoor is het behandelen van een beveiligingspatch als een routinematige IT-update. In een veiligheidskritisch systeem kan een wijziging die timing of gedrag verandert, de safety case ongeldig maken. TS 50701''s aandringen op een beheerste veiligheid–security-interface bestaat precies om te voorkomen dat een goedbedoelde beveiligingsactie stilletjes een veiligheidsrisico wordt.

```compare
Het security-instinct
- **Snel patchen** — een bekende kwetsbaarheid is een open deur; sluit die nu
- Verandering is **verwacht en frequent**; het areaal moet makkelijk te updaten zijn
- Succes = de tegenstander wordt zijn doel ontzegd
- Het dreigingslandschap **verschuift wekelijks**; maatregelen moeten meebewegen
---
De spoorveiligheidsrealiteit
- Een patch kan **timing of gedrag veranderen** en een gecertificeerde safety case ongeldig maken
- Verandering is **strikt beheerst** en kan hervalidatie of hercertificering vereisen
- Succes = het systeem **valt nog steeds terug naar een bekende veilige toestand**
- Het veiligheidsargument is **door ontwerp jarenlang stabiel**
```

Geen van beide instincten is verkeerd; de discipline die TS 50701 oplegt, is ze bewust te verzoenen, op een gedefinieerde interface, in plaats van de ene stilletjes de andere te laten overrulen. Een patch bereikt een veiligheidskritische zone pas nadat een gezamenlijke beoordeling heeft bevestigd dat hij de safety case niet verstoort — en het feit dát hij is beoordeeld, maakt zelf deel uit van het bewijs.

```svg
<svg viewBox="0 0 700 380" xmlns="http://www.w3.org/2000/svg" font-family="system-ui, sans-serif">
  <rect width="700" height="380" fill="none"/>
  <text x="350" y="30" fill="#e5e7eb" font-size="18" font-weight="700" text-anchor="middle">Risicobeoordeling voor het spoor — het TS 50701-proces</text>

  <!-- boxes -->
  <g>
    <rect x="30" y="70" width="150" height="60" rx="7" fill="none" stroke="#3b82f6" stroke-width="2"/>
    <text x="105" y="95" fill="#e5e7eb" font-size="12.5" font-weight="700" text-anchor="middle">Systeem</text>
    <text x="105" y="113" fill="#94a3b8" font-size="11" text-anchor="middle">bepalen (SuC)</text>
  </g>
  <g>
    <rect x="210" y="70" width="150" height="60" rx="7" fill="none" stroke="#3b82f6" stroke-width="2"/>
    <text x="285" y="95" fill="#e5e7eb" font-size="12.5" font-weight="700" text-anchor="middle">Indelen in</text>
    <text x="285" y="113" fill="#94a3b8" font-size="11" text-anchor="middle">zones &amp; conduits</text>
  </g>
  <g>
    <rect x="390" y="70" width="150" height="60" rx="7" fill="none" stroke="#3b82f6" stroke-width="2"/>
    <text x="465" y="95" fill="#e5e7eb" font-size="12.5" font-weight="700" text-anchor="middle">Dreigingen</text>
    <text x="465" y="113" fill="#94a3b8" font-size="11" text-anchor="middle">&amp; gevolgen beoordelen</text>
  </g>
  <g>
    <rect x="390" y="180" width="150" height="60" rx="7" fill="none" stroke="#f97316" stroke-width="2"/>
    <text x="465" y="205" fill="#e5e7eb" font-size="12.5" font-weight="700" text-anchor="middle">Target</text>
    <text x="465" y="223" fill="#94a3b8" font-size="11" text-anchor="middle">security levels bepalen</text>
  </g>
  <g>
    <rect x="210" y="180" width="150" height="60" rx="7" fill="none" stroke="#f97316" stroke-width="2"/>
    <text x="285" y="205" fill="#e5e7eb" font-size="12.5" font-weight="700" text-anchor="middle">Beveiligingseisen</text>
    <text x="285" y="223" fill="#94a3b8" font-size="11" text-anchor="middle">specificeren</text>
  </g>
  <g>
    <rect x="30" y="180" width="150" height="60" rx="7" fill="none" stroke="#f97316" stroke-width="2"/>
    <text x="105" y="205" fill="#e5e7eb" font-size="12.5" font-weight="700" text-anchor="middle">Restrisico</text>
    <text x="105" y="223" fill="#94a3b8" font-size="11" text-anchor="middle">verifiëren &amp; documenteren</text>
  </g>

  <!-- safety-security interface band -->
  <rect x="30" y="290" width="510" height="60" rx="7" fill="none" stroke="#94a3b8" stroke-width="2" stroke-dasharray="6 4"/>
  <text x="285" y="315" fill="#e5e7eb" font-size="13" font-weight="700" text-anchor="middle">Veiligheid–security-interface (CSM-RA + IEC 62443-3-3)</text>
  <text x="285" y="335" fill="#94a3b8" font-size="11" text-anchor="middle">bij elke stap gecontroleerd: raakt een beveiligingsmaatregel de veiligheid, of andersom?</text>

  <!-- arrows across top -->
  <line x1="180" y1="100" x2="208" y2="100" stroke="#94a3b8" stroke-width="2" marker-end="url(#a2)"/>
  <line x1="360" y1="100" x2="388" y2="100" stroke="#94a3b8" stroke-width="2" marker-end="url(#a2)"/>
  <line x1="465" y1="130" x2="465" y2="178" stroke="#94a3b8" stroke-width="2" marker-end="url(#a2)"/>
  <line x1="390" y1="210" x2="362" y2="210" stroke="#94a3b8" stroke-width="2" marker-end="url(#a2)"/>
  <line x1="210" y1="210" x2="182" y2="210" stroke="#94a3b8" stroke-width="2" marker-end="url(#a2)"/>
  <!-- dashed link to interface band -->
  <line x1="285" y1="240" x2="285" y2="288" stroke="#94a3b8" stroke-width="1.5" stroke-dasharray="4 4"/>

  <defs>
    <marker id="a2" markerWidth="9" markerHeight="9" refX="7" refY="4.5" orient="auto">
      <path d="M0,0 L9,4.5 L0,9 Z" fill="#94a3b8"/>
    </marker>
  </defs>
</svg>
```

## Zones, conduits en target security levels — de spoorwegvariant

In de kern volgt TS 50701 dezelfde risicobeoordelingslogica als IEC 62443-3-2: het systeem in kwestie identificeren, dit indelen in **zones** (groepen assets met een gedeelde beveiligingsbehoefte) die worden verbonden door **conduits** (de gecontroleerde paden ertussen), de dreigingen en hun gevolgen beoordelen, een **target security level** per zone bepalen, en de maatregelen specificeren die nodig zijn om dat niveau te bereiken. ENISA heeft speciale richtlijnen gepubliceerd over het toepassen van zone-indeling en conduits op spoorwegen, een teken van hoe centraal deze stap is voor de sector. ([ENISA — Zoning and Conduits for Railways](https://www.enisa.europa.eu/publications/zoning-and-conduits-for-railways))

De aanpassing aan het spoor komt tot uiting in *welke* assets in *welke* zones vallen, en in hoe gevolgen worden gewogen naar veiligheidskritikaliteit. Een seingevingsinterlocking bevindt zich in een andere wereld dan een wifi-toegangspunt voor reizigers, en de zone-indeling van TS 50701 weerspiegelt dat. Het onderstaande illustratieve patroon is typerend voor hoe kritikaliteit de target SL''s bepaalt.

| Zone (illustratief) | Voorbeeldassets | Veiligheidskritikaliteit | Typisch target SL |
| --- | --- | --- | --- |
| Seingeving & interlocking | Interlockings, objectcontrollers, ETCS boord-/baanapparatuur | Veiligheidskritisch | SL-3 / SL-4 |
| Control-command & verkeersmanagement | TMS, dispatching, ATS | Hoog operationeel | SL-2 / SL-3 |
| Besturing rollend materieel | Treinbesturingseenheden, boordnetwerken (TCN) | Veiligheidsgerelateerd | SL-2 / SL-3 |
| Operationele ondersteuning | SCADA voor stroomvoorziening, HVAC, tunnelsystemen | Operationeel | SL-2 |
| Reizigers & niet-vitaal | CCTV, reizigersinformatie, wifi aan boord | Laag / niet-vitaal | SL-1 / SL-2 |

Het resultaat is wat elke goede OT-beveiligingsbeoordeling zou moeten opleveren: een gestructureerd, verdedigbaar model van waar risico zich concentreert, welke bescherming elke zone nodig heeft, en waar het huidige ontwerp tekortschiet — uitgedrukt in de taal van zowel de beveiligingsnorm als de spoorweglevenscyclus.

### Een uitgewerkt voorbeeld: de baan-naar-boord-conduit

Neem één concreet pad: de **radioconduit** die rijmachtigingen draagt tussen een **ETCS/RBC** langs het spoor (radio block centre) en de boordeenheid van een trein. Het is de slagader van de moderne seingeving, en het kruist een open medium.

- **Zone en conduit.** De RBC en de boordeenheid bevinden zich in **veiligheidskritische** zones (target SL-3/SL-4); de radioverbinding is de **conduit** ertussen. Alles aan de conduit — wie erop mag spreken, hoe berichten worden geauthenticeerd, wat er gebeurt bij storing — valt binnen de reikwijdte.
- **Dreigingen en gevolgen.** Berichtvervalsing, replay en jamming zijn de klassieke. De weging van het *gevolg* maakt dit tot een spoorwegprobleem: een vervalste of herhaalde rijmachtiging is geen data-integriteitsongemak, maar een potentiële botsing. De gevolgas wordt gescoord in veiligheidstermen, niet in IT-termen.
- **Welke FR''s bijten.** FR 3 (integriteit) en FR 1 (authenticatie) beschermen de authenticiteit van de rijmachtiging; FR 7 (beschikbaarheid) adresseert jamming en denial-of-service; FR 5 (beperkte gegevensstroom) waarborgt dat niets anders op de conduit kan injecteren.
- **De veiligheid–security-interface.** Een beveiligingsmaatregel die latentie toevoegt aan het machtigingsbericht kan zelf een gevaar creëren — een trein die remt omdat een geldige machtiging te laat aankwam, is een veiligheidsgebeurtenis veroorzaakt door een beveiligingsmaatregel. Dit is precies de interface die TS 50701 u dwingt gezamenlijk te beoordelen, niet na elkaar.

Eén conduit, en het zonemodel, de zeven FR''s, de target-SL-logica en de veiligheid–security-interface komen allemaal tegelijk in het spel. Zo werkt de specificatie zoals bedoeld: hetzelfde asset, bekeken door de securitylens en de safetylens tegelijk.

### Bestaande installaties en compenserende maatregelen

Het spoor gebruikt assets dertig, veertig, soms vijftig jaar. Een groot deel van de geïnstalleerde basis dateert van vóór enig idee van geauthenticeerde commando''s of ondertekende firmware, en kan niet simpelweg naar een SL-3-houding worden gepatcht. TS 50701 doet niet alsof dat wel kan. Omdat de risicologica kan worden toegepast op systemen die **buiten** het moderne EN 50126-1-proces zijn gebouwd, houdt het rekening met de brownfield-realiteit: waar een oude interlocking een maatregel niet rechtstreeks kan halen, grijpt de beoordeling naar **compenserende maatregelen** — strakkere zone-indeling rond het oude asset, een geharde en gemonitorde conduit, strikte toegangscontrole op het onderhoudspad, en verbeterde detectie zodat een poging op het zwakke component in elk geval wordt gezien. Het target security level benoemt nog steeds het doel; de compenserende maatregelen zijn de verdedigbare, gedocumenteerde route ernaartoe wanneer het asset zelf niet kan veranderen. Dit is dezelfde pragmatische zet die OXOT toepast op verouderende OT-arealen, en het is waarom een nauwkeurig model van *wat er werkelijk bestaat* meer telt dan een geïdealiseerd ontwerp.

```cta
Seingeving, rollend materieel, vaste installaties — kunt u per zone een verdedigbaar beveiligingsniveau aantonen?
NIS2-beoordelaars verwachten nu de TS 50701-methode. Wij passen zones, conduits en target security levels toe op uw spoorareaal, afgestemd op de safety case.
Beoordeel mijn spoorareaal :: /nl/contact
```

## Reikwijdte — wat TS 50701 omvat

TS 50701 behandelt cybersecurity breed over het spoorwegsysteem. De formele reikwijdte omvat vier domeinen: **Communicatie; Seingeving en Verwerking; Rollend Materieel; en Vaste Installaties.** ([iTeh](https://standards.iteh.ai/catalog/standards/clc/db257ea9-8ba0-4f4c-a791-df34a6030541/clc-ts-50701-2023)) In de praktijk reikt dit van de interlocking in een kast langs het spoor tot de besturingseenheid onder een trein, van het verkeersmanagementsysteem in een operationeel centrum tot de stroom-SCADA die de bovenleiding voedt.

Het spreekt ook het hele leveringsecosysteem aan — en weerspiegelt daarmee de structuur van asset owner / integrator / leverancier uit [IEC 62443](/nl/iec-62443).

| Rol | Wie zij zijn | Wat TS 50701 van hen vraagt |
| --- | --- | --- |
| Spoorwegoperator / infrastructuurbeheerder | Bezit en beheert het areaal en het operationele risico ervan | Beveiligingsbeleid vaststellen, risicobereidheid bepalen, het beveiligingsmanagementsysteem uitvoeren, aan regelgevende verplichtingen voldoen |
| Systeemintegrator | Assembleert, neemt in bedrijf en valideert spoorwegsystemen | De risicobeoordeling uitvoeren, zones en conduits ontwerpen, beveiligingseisen op systeemniveau verifiëren |
| Product-/componentleverancier | Bouwt de apparatuur (interlockings, boordapparatuur, sensoren) | Voldoen aan beveiligingseisen op componentniveau, een secure development lifecycle volgen, capaciteiten documenteren |
| Eigenaar van de safety case | Verantwoordelijk voor het veiligheidsargument | De veiligheid–security-interface beheren zodat beveiligingswerk de safety case versterkt in plaats van compliceert |

## De regelgevende context — NIS2, CRA en de weg naar IEC 63452

TS 50701 bestaat niet in een vacuüm, en het regelgevende gewicht ervan groeit.

Spoorwegondernemingen en infrastructuurbeheerders zijn in de meeste lidstaten precies de vervoersoperators die onder **[NIS2](/nl/nis2)** vallen als *essentiële entiteiten* — wat bindende verplichtingen inhoudt op het gebied van cybersecurity-risicobeheer en incidentmelding, ondersteund door echte handhaving. TS 50701 geeft het spoor een sectorspecifieke methode om aan die verplichtingen te voldoen in plaats van te improviseren aan de hand van een generieke checklist. Aan de productzijde valt de apparatuur die in spoorwegsystemen wordt geplaatst, in toenemende mate onder de **[CRA](/nl/cra)** als producten met digitale elementen, met eisen op het gebied van secure-by-design en kwetsbaarheidsbeheer gedurende hun hele levenscyclus. TS 50701 wordt steeds vaker beschouwd als de basis die spoorwegtechnische praktijk verbindt met beide regimes. ([Cervello](https://cervello.security/blog/regulations/what-is-rail-cybersecurity-compliance/))

De specificatie is ook een opstap. TS 50701 is ontwikkeld door CENELEC TC 9X/WG 26 en voedt nu **IEC 63452**, de eerste *internationale* cybersecuritynorm voor het spoor, die naar verwachting de door TS 50701 in Europa gepionierde aanpak zal consolideren en mondiaal zal maken. ([Alstom](https://www.alstom.com/press-releases-news/2024/3/towards-first-railway-cybersecurity-international-standard-why-standards-are-important-secure-railways)) Investeren in TS 50701 vandaag is geen doodlopende weg — het is de oprit naar de norm waarop de hele sector convergeert.

```timeline
juli 2021 :: **CLC/TS 50701 eerste editie** — ''s werelds eerste cybersecurityspecificatie die specifiek voor spoorwegtoepassingen is geschreven.
augustus 2023 :: **CLC/TS 50701:2023 tweede editie** — de specificatie rijpt: verfijnd risicoproces, MITRE ATT&CK for ICS als dreigingsbibliotheek aangehaald, duidelijker richtsnoeren voor de veiligheid–security-interface.
2024 e.v. :: **IEC 63452 in ontwikkeling** — het CENELEC-werk voor spoorcybersecurity voedt de eerste internationale norm, die de TS 50701-aanpak mondiaal maakt.
Nu :: **NIS2 + CRA van kracht** — spooroperators (essentiële entiteiten) en leveranciers van spoorapparatuur dragen al bindende plichten die TS 50701 de sectorspecifieke manier is om aan te voldoen.
```

> [!TIP]
> Wacht niet op IEC 63452 voordat u in actie komt. De engineering die deze norm zal standaardiseren — zones en conduits, target security levels, de veiligheid–security-interface — is al gedefinieerd in TS 50701 en is al wat NIS2-beoordelaars verwachten te zien. Werk dat is verricht volgens TS 50701 blijft vrijwel ongewijzigd bruikbaar.

## Wat het betekent voor uw rol

**Als u een spoorwegoperator of infrastructuurbeheerder bent,** geeft TS 50701 u een sectorspecifieke manier om cybersecurity over uw areaal te definiëren en aan te tonen, afgestemd op de RAMS-levenscyclus die u al hanteert en op uw [NIS2](/nl/nis2)-verplichtingen. Het maakt van "zijn we veilig?" geen kwestie van mening, maar van gedocumenteerde target security levels en geverifieerde maatregelen.

**Als u een spoorwegsysteemintegrator of -leverancier bent,** geeft het u een gedeeld referentiekader voor wat "veilig" betekent in het spoor — target security levels, componenteisen gebaseerd op [IEC 62443](/nl/iec-62443), en een risicoproces dat uw klanten en hun beoordelaars al herkennen. Het verkort de discussie bij acceptatie.

**Als u de eigenaar bent van de safety case,** geeft TS 50701 u een gestructureerde manier om de veiligheid–security-interface te beheren, zodat cybersecurity uw veiligheidsargument versterkt in plaats van het stilletjes te ondermijnen — met gezamenlijke beoordelingen en afstemming op CSM-RA in plaats van twee teams die langs elkaar heen praten.

## Hoe te beginnen

1. **Breng het systeem in kaart (system under consideration).** Inventariseer de assets, netwerken en conduits binnen de reikwijdte — seingeving, rollend materieel, control-command, vaste installaties. U kunt niet zoneren wat u niet kunt zien.
2. **Zoneer op kritikaliteit en gevolg.** Groepeer assets naar beveiligingsbehoefte, gewogen naar veiligheidsimpact, en definieer de conduits ertussen.
3. **Voer de risicobeoordeling uit.** Beoordeel dreigingen en gevolgen, en bepaal vervolgens een target security level per zone met het van IEC 62443 afgeleide proces.
4. **Controleer de veiligheid–security-interface.** Vraag u voor elke voorgestelde maatregel af of deze een veiligheidsfunctie raakt — en voer waar dat het geval is een gezamenlijke beoordeling uit.
5. **Specificeer, verifieer, documenteer.** Leid eisen af uit de target SL''s, verifieer ze (inclusief controles op componentniveau tegen IEC 62443-4-2), en leg het restrisico vast tegen uw NIS2- en veiligheidsverplichtingen.

Een [Cyber Digital Twin](/nl/cyber-digital-twin) maakt stappen 1 tot en met 5 duurzaam: het houdt de assets, zones, conduits, veiligheid–security-interfaces en hiaten in security levels vast als een levend model in plaats van een eenmalig rapport dat veroudert op het moment dat het wordt ondertekend.

## Hoe OXOT helpt

De methode van OXOT is gebouwd op [IEC 62443](/nl/iec-62443) — precies het fundament dat TS 50701 uitbreidt — waardoor onze aanpak rechtstreeks aansluit op het spoor. Onze **OT-beveiligingsbeoordelingen** passen dezelfde zones-en-conduits- en target-security-level-logica toe die TS 50701 deelt met IEC 62443, geformuleerd in spoorwegtermen en met oog voor de veiligheidslevenscyclus. Onze **[Cyber Digital Twin](/nl/cyber-digital-twin)** houdt het resulterende model vast — assets, zones, conduits, veiligheid–security-interfaces en hiaten in security levels — als een levende structuur die zowel het beveiligingsprogramma als de safety case tegelijk bedient.

Voor spoorwegoperators die te maken hebben met [NIS2](/nl/nis2)-verplichtingen en leveranciers die te maken hebben met de [CRA](/nl/cra), betekent dat een enkele, samenhangende manier om risico te begrijpen, investeringen te prioriteren en klaar te blijven voor de komende IEC 63452-basislijn — over een complex, veiligheidskritisch areaal. Zie ons bredere overzicht van het normenlandschap op de pagina [Frameworks](/nl/frameworks).

## Veelgestelde vragen

**Is TS 50701 een norm of een specificatie?**
Het is een CENELEC **Technical Specification** (CLC/TS), een trede onder een volwaardige geharmoniseerde Europese Norm. De concepten ervan voeden nu de internationale norm **IEC 63452**, die naar verwachting de mondiale referentie voor cybersecurity in het spoor zal worden.

**Hebben we IEC 62443 nog nodig als we TS 50701 gebruiken?**
Ja, en dat is een goede zaak. TS 50701 is gebouwd op IEC 62443 en verwijst ernaar terug — met name Deel 3-2 en 3-3 voor het risicoproces en 4-2 voor componenten. Inzicht in IEC 62443 maakt het toepassen van TS 50701 veel eenvoudiger, en beide werken versterken elkaar.

**Hoe verhoudt het zich tot de EN 5012x-veiligheidsnormen?**
TS 50701 integreert met de **EN 50126-1** RAMS-levenscyclus en beheert de veiligheid–security-interface, waarbij het put uit veiligheidsmethoden zoals CSM-RA. Het staat naast de spoorwegveiligheidsnormen, niet in de plaats ervan.

**Wat omvat TS 50701 precies?**
Vier domeinen: Communicatie; Seingeving en Verwerking; Rollend Materieel; en Vaste Installaties. Het kan worden toegepast op systemen die binnen of buiten het EN 50126-1-proces zijn gebouwd, zodat het werkt voor zowel bestaande als nieuwe assets.

**Is NIS2 op ons van toepassing als spoorwegonderneming?**
Zeer waarschijnlijk. Spoorvervoer is in de meeste lidstaten een sector van essentiële entiteiten onder NIS2. TS 50701 is de sectorspecifieke methode om aan die verplichtingen te voldoen — bevestig de specifieke details in uw nationale omzettingswetgeving.

**Hoe zit het met IEC 63452 — moeten we daarop wachten?**
Nee. IEC 63452 bouwt voort op dezelfde engineering die TS 50701 al definieert. Werk dat volgens TS 50701 is verricht, blijft bruikbaar, dus de pragmatische keuze is om nu te beginnen.

**Kunnen we TS 50701 toepassen op een decennia-oud seingevingsareaal?**
Ja. De risicologica geldt voor systemen die binnen of buiten het moderne EN 50126-1-proces zijn gebouwd. Waar een oud asset een maatregel niet rechtstreeks kan halen, gebruikt de beoordeling **compenserende maatregelen** — strakkere zone-indeling, geharde en gemonitorde conduits, strikte toegangscontrole op onderhoud, verbeterde detectie — waarbij het target security level nog steeds het doel benoemt. Brownfield is de norm in het spoor, en de specificatie is ervoor gebouwd.

**Hoe passen de zeven fundamentele eisen op het spoor?**
Het zijn de kopjes uit IEC 62443-3-3 — identificatie/authenticatie, gebruikscontrole, systeemintegriteit, vertrouwelijkheid van gegevens, beperkte gegevensstroom, tijdige reactie, beschikbaarheid van middelen — gelezen tegen spoorwegassets. Integriteit en authenticatie beschermen seingevingslogica en rijmachtigingen; beperkte gegevensstroom is de zone/conduit-grens tussen reizigers- en seingevingsnetwerken; beschikbaarheid van middelen maakt de RAMS-"A" tot een beveiligingsdoel.

**Wie moet wat doen — operator, integrator, leverancier?**
Naar het model van IEC 62443: de operator/infrastructuurbeheerder stelt beleid vast en voert het beveiligingsmanagementsysteem uit; de integrator voert de risicobeoordeling uit en ontwerpt zones en conduits; de componentleverancier voldoet aan beveiligingseisen op componentniveau en volgt een secure development lifecycle. De eigenaar van de safety case beheert de interface zodat security het veiligheidsargument versterkt.

## Sources

- CLC/TS 50701:2023 — railway applications cybersecurity — [iTeh Standards](https://standards.iteh.ai/catalog/standards/clc/db257ea9-8ba0-4f4c-a791-df34a6030541/clc-ts-50701-2023)
- Hands-on CLC/TS 50701 (railway cybersecurity), Christian Schlehuber — [ENISA / CENELEC](https://www.enisa.europa.eu/sites/default/files/all_files/05-standards-02-cenelec-christian-schlehuber.pdf)
- Zoning and Conduits for Railways — [ENISA](https://www.enisa.europa.eu/publications/zoning-and-conduits-for-railways)
- A deep dive into CENELEC TS 50701 — [Shieldworkz](https://shieldworkz.com/blogs/a-deep-dive-into-cenelec-ts-50701-for-railway-cybersecurity)
- A deep dive into TS 50701-based risk and security assessment — [Shieldworkz](https://shieldworkz.com/blogs/a-deep-dive-into-ts-50701-based-risk-and-security-assessment)
- Navigating TS 50701 — [Cylus](https://www.cylus.com/post/navigating-ts-50701-unpacking-the-impact-of-the-cybersecurity-standard-for-rail)
- What is rail cybersecurity compliance? — [Cervello](https://cervello.security/blog/regulations/what-is-rail-cybersecurity-compliance/)
- Towards the first railway cybersecurity international standard (IEC 63452) — [Alstom](https://www.alstom.com/press-releases-news/2024/3/towards-first-railway-cybersecurity-international-standard-why-standards-are-important-secure-railways)

*Deze pagina bevat algemene educatieve informatie. Raadpleeg de officiële CENELEC CLC/TS 50701-documenten (en de aankomende EN-/IEC 63452-documenten) voor gezaghebbende eisen.*', true, 'CLC/TS 50701 Cybersecurity voor spoorwegen uitgelegd | OXOT', 'CLC/TS 50701 uitgebreid uitgelegd — de eerste cybersecurityspecificatie voor het spoor, hoe deze IEC 62443 toepast op spoorwegsystemen, de integratie met de EN 50126 RAMS-levenscyclus, de veiligheid–security-interface, zones en conduits, de relevantie van NIS2 en CRA, en de weg naar IEC 63452.', 'De cybersecurityspecificatie voor het spoor — IEC 62443 aangepast aan spoorwegtoepassingen en verankerd in de veiligheidslevenscyclus.', NULL, 'page', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();
