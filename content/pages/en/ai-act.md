---
title: The EU AI Act and Industrial AI
meta_title: EU AI Act for Industrial & OT AI | OXOT
meta_description: The EU AI Act (Regulation (EU) 2024/1689) for industry and OT — risk tiers with plant-floor examples, the two routes to high-risk, the Machinery Regulation link, provider vs deployer duties, Article 15 cybersecurity, revised 2026 timeline and penalties.
excerpt: How the EU AI Act applies when AI enters the plant — high-risk classification, the machinery link, provider and deployer duties, Article 15 robustness, the revised 2026 timeline and penalties.
content_type: page
published: true
---

Artificial intelligence arrived on the plant floor without a launch date. It crept in through a vision system that a vendor bundled into an inspection cell, a predictive-maintenance module inside a drive, an "adaptive" loop in a controller firmware release. Nobody signed a policy. Nobody drew a boundary. And now AI tunes processes, grades product, forecasts failures, balances energy, and — increasingly — sits close to the safety and control functions that decide whether a line runs or trips.

The EU AI Act is the first comprehensive law in the world to govern that shift. For most people, "AI regulation" conjures chatbots and deepfakes. For an industrial operator, the provisions that bite are the quiet ones: the rules for **AI embedded in machinery, safety components and regulated products**. That is where the law reaches into operational technology, and where AI governance stops being a legal abstraction and becomes an engineering problem.

This page explains what the AI Act requires, how an industrial AI system crosses the line into "high-risk," how the law is deliberately stitched to the Machinery Regulation and the wider product-safety regime, what providers and deployers each owe, and what a proportionate response looks like in an OT environment where a manipulated model is a manipulated process.

## The short version

- The AI Act is **Regulation (EU) 2024/1689**. It entered into force on **1 August 2024** and switches on in phases. ([EUR-Lex, official text](https://eur-lex.europa.eu/eli/reg/2024/1689/oj/eng))
- It is **risk-based**: a short list of **prohibited** practices, a demanding **high-risk** tier, lighter **transparency** duties for limited-risk systems, and no new obligations for minimal-risk AI.
- Industrial AI most often becomes high-risk through **Annex I** — where the AI is a safety component of, or is itself, a product covered by EU harmonisation law such as the **Machinery Regulation**. A second route runs through **Annex III** critical-infrastructure use.
- **Providers** (who develop or place AI on the market) carry the heavy obligations; **deployers** (who use it) carry a lighter but real set of duties. Modify a system enough and a deployer *becomes* a provider.
- High-risk systems must satisfy Articles 8–15: risk management, data governance, logging, transparency, human oversight, and — the line OT teams should read twice — **accuracy, robustness and cybersecurity** under **Article 15**.
- Penalties reach **€35 million or 7% of worldwide turnover** for prohibited practices, and **€15 million or 3%** for breaching high-risk obligations. ([Article 99](https://artificialintelligenceact.eu/article/99/))
- The high-risk deadlines were **pushed back** by the **Digital Omnibus** agreed on **7 May 2026** — standalone Annex III systems now apply from **2 December 2027**, and product-embedded Annex I AI from **2 August 2028**. ([Gibson Dunn](https://www.gibsondunn.com/eu-ai-act-omnibus-agreement-postponed-high-risk-deadlines-and-other-key-changes/))

> [!NOTE]
> The honest headline for industry: **most industrial AI is not high-risk.** Process optimisation, quality analytics and maintenance forecasting that never touch a safety or control function sit in the minimal tier. The real work is finding the handful of systems that *do*, classifying them correctly, and governing them without smothering the useful ninety percent.

## The risk-based structure

The Act sorts AI by the risk it poses, not by the technology it uses. A neural network and a linear model are treated identically if they do the same job in the same place. Four tiers, from banned to unregulated.

```svg
<svg viewBox="0 0 700 430" xmlns="http://www.w3.org/2000/svg" font-family="system-ui, sans-serif">
  <rect width="700" height="430" fill="none"/>
  <text x="350" y="30" fill="#e5e7eb" font-size="20" font-weight="700" text-anchor="middle">The four risk tiers of the EU AI Act</text>

  <!-- Pyramid: prohibited (top) to minimal (bottom) -->
  <polygon points="350,60 430,130 270,130" fill="#f97316" opacity="0.9" stroke="#94a3b8" stroke-width="1"/>
  <polygon points="270,130 430,130 490,210 210,210" fill="#3b82f6" opacity="0.9" stroke="#94a3b8" stroke-width="1"/>
  <polygon points="210,210 490,210 550,290 150,290" fill="#3b82f6" opacity="0.55" stroke="#94a3b8" stroke-width="1"/>
  <polygon points="150,290 550,290 610,370 90,370" fill="#94a3b8" opacity="0.45" stroke="#94a3b8" stroke-width="1"/>

  <text x="350" y="102" fill="#e5e7eb" font-size="14" font-weight="700" text-anchor="middle">PROHIBITED</text>
  <text x="350" y="177" fill="#e5e7eb" font-size="15" font-weight="700" text-anchor="middle">HIGH RISK</text>
  <text x="350" y="256" fill="#e5e7eb" font-size="14" font-weight="700" text-anchor="middle">LIMITED RISK</text>
  <text x="350" y="336" fill="#e5e7eb" font-size="14" font-weight="700" text-anchor="middle">MINIMAL RISK</text>

  <!-- Right-side annotations -->
  <line x1="430" y1="95" x2="640" y2="95" stroke="#94a3b8" stroke-width="1" stroke-dasharray="3,3"/>
  <text x="645" y="99" fill="#f97316" font-size="12">Banned outright (Art. 5)</text>

  <line x1="500" y1="170" x2="640" y2="170" stroke="#94a3b8" stroke-width="1" stroke-dasharray="3,3"/>
  <text x="645" y="174" fill="#3b82f6" font-size="12">Allowed with full controls</text>

  <line x1="560" y1="250" x2="640" y2="250" stroke="#94a3b8" stroke-width="1" stroke-dasharray="3,3"/>
  <text x="565" y="270" fill="#94a3b8" font-size="12">Transparency duties</text>

  <line x1="620" y1="330" x2="648" y2="330" stroke="#94a3b8" stroke-width="1" stroke-dasharray="3,3"/>
  <text x="470" y="405" fill="#94a3b8" font-size="12" text-anchor="middle">No new obligations — voluntary codes</text>

  <text x="350" y="420" fill="#94a3b8" font-size="11" text-anchor="middle">Most industrial AI lives at the base. The compliance effort concentrates in the blue band.</text>
</svg>
```

### Unacceptable risk — prohibited

A short list of practices is banned outright under **Article 5**: manipulative or exploitative techniques that distort behaviour, social scoring, untargeted scraping of facial images, emotion inference in the workplace and in education, certain biometric categorisation, and real-time remote biometric identification in public spaces (with narrow law-enforcement exceptions). These rarely surface in OT — but the prohibition is absolute wherever they do, and it carries the heaviest fine in the Act. The Digital Omnibus added one more banned practice: AI-generated non-consensual intimate imagery and child sexual abuse material, applying from **2 December 2026**. ([Winston Taylor](https://www.winstontaylor.com/insights/ai-act-rules-on-high-risk-ai-delayed-as-ai-digital-omnibus-agreed))

### High risk — permitted, but heavily regulated

This is the tier that matters for industry. High-risk systems are allowed on the market only if they meet the full set of Article 8–15 requirements and pass conformity assessment. Most industrial AI that touches a safety or control function lands here — and the rest of this page is largely about how to tell which of your systems belong in this band, and what to do about them once they do.

### Limited risk — transparency duties

Systems that interact with people or generate content must disclose it: a chatbot has to say it is a machine, synthetic media has to be labelled. This is relevant to customer-facing tools — the assistant on your website, a generated marketing image — far more than to the plant. Get the disclosure right and the obligation is discharged.

### Minimal risk — no new obligations

The vast majority of AI sits here: optimisation, analytics, energy balancing, maintenance forecasting that informs a human but does not act inside a safety loop. Subject only to voluntary codes of conduct. The tier is large on purpose — the Act was written to leave room for innovation and to concentrate scrutiny where harm is plausible.

Here is the same structure with plant-floor examples, so the tiers stop being abstract.

| Risk tier | What the law does | Typical industrial / OT examples |
|---|---|---|
| **Unacceptable** | Prohibited under Art. 5 | Emotion-inference on workers for productivity scoring; covert behaviour-manipulation. Rare in OT, banned where present. |
| **High risk** | Full Art. 8–15 requirements + conformity assessment | AI-based safety guard or light-curtain logic; vision system that halts a press; adaptive controller governing a hazardous process; AI as a safety component in grid, water, gas or heat supply. |
| **Limited risk** | Transparency / disclosure only | Operator-facing chat assistant; customer-service bot; generated documentation. |
| **Minimal risk** | No new obligations | Predictive maintenance that advises a planner; process-optimisation and yield analytics; anomaly detection that alerts a human. |

## The revised timeline — and the Digital Omnibus caveat

The AI Act was published in the Official Journal and entered into force on **1 August 2024**, with obligations phased in so that industry, notified bodies and regulators could prepare. Two milestones have already passed:

- **2 February 2025** — the **Article 5 prohibitions** applied, and organisations became responsible for a baseline of **AI literacy** among staff who operate AI systems.
- **2 August 2025** — governance provisions and the obligations for **general-purpose AI (GPAI) models** applied.

Then the timeline moved. On **7 May 2026**, negotiators from the Council, Parliament and Commission reached a provisional political agreement on the **Digital Omnibus on AI** — a simplification package that, among other things, **deferred the high-risk deadlines**. Under the agreed text, standalone **Annex III** high-risk systems apply from **2 December 2027** (a slip from the original 2 August 2026), and product-embedded **Annex I** AI applies from **2 August 2028**. ([Hogan Lovells](https://www.hoganlovells.com/en/publications/eu-legislators-agree-to-delay-for-highrisk-ai-rules); [ComplianceHub](https://compliancehub.wiki/eu-digital-omnibus-ai-act-deadline-deferral-annex-iii-2027/))

| Date | What applies | Status |
|---|---|---|
| 1 Aug 2024 | Regulation enters into force | In force |
| 2 Feb 2025 | Art. 5 prohibitions; AI-literacy duty | In force |
| 2 Aug 2025 | Governance rules; GPAI model obligations | In force |
| 2 Dec 2026 | New prohibition (AI-generated intimate imagery / CSAM) | Provisional (Omnibus) |
| **2 Dec 2027** | **High-risk obligations for standalone Annex III systems** | **Provisional (Omnibus) — was 2 Aug 2026** |
| **2 Aug 2028** | **High-risk obligations for Annex I product-embedded AI (incl. machinery)** | **Provisional (Omnibus)** |

> [!WARNING]
> Treat these high-risk dates as **provisional**. The Digital Omnibus was politically agreed on 7 May 2026 but takes legal effect only once the amending regulation is formally adopted and published in the Official Journal. Plan against your specific system's route, not against a headline date — and watch the Official Journal, not the press release. ([Gibson Dunn](https://www.gibsondunn.com/eu-ai-act-omnibus-agreement-postponed-high-risk-deadlines-and-other-key-changes/))

The deferral is a gift of time, not a reprieve. The prohibitions and AI-literacy duties are live now, the clock on high-risk classification is running, and the two slowest tasks — building an inventory and reasoning through classification — are exactly the ones you want behind you before the paperwork lands.

## How industrial AI becomes "high-risk"

There are **two distinct routes** into the high-risk tier, and they behave differently. An industrial operator needs to understand both, because a single site can be caught by either — sometimes by both at once.

```svg
<svg viewBox="0 0 700 560" xmlns="http://www.w3.org/2000/svg" font-family="system-ui, sans-serif">
  <rect width="700" height="560" fill="none"/>
  <text x="350" y="30" fill="#e5e7eb" font-size="19" font-weight="700" text-anchor="middle">Is my industrial AI high-risk?</text>

  <!-- Start -->
  <rect x="270" y="50" width="160" height="46" rx="8" fill="#1f2937" stroke="#3b82f6" stroke-width="2"/>
  <text x="350" y="78" fill="#e5e7eb" font-size="13" text-anchor="middle">An AI system in your plant</text>

  <!-- Q1 Annex I -->
  <polygon points="350,116 500,166 350,216 200,166" fill="#1f2937" stroke="#f97316" stroke-width="2"/>
  <text x="350" y="158" fill="#e5e7eb" font-size="12" text-anchor="middle">Is it a safety component</text>
  <text x="350" y="174" fill="#e5e7eb" font-size="12" text-anchor="middle">of an Annex I product</text>
  <text x="350" y="190" fill="#e5e7eb" font-size="12" text-anchor="middle">(e.g. machinery)?</text>

  <line x1="500" y1="166" x2="600" y2="166" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="548" y="158" fill="#f97316" font-size="12" text-anchor="middle">YES</text>

  <!-- High risk Route 1 -->
  <rect x="560" y="143" width="120" height="70" rx="8" fill="#3b82f6" opacity="0.85" stroke="#94a3b8" stroke-width="1"/>
  <text x="620" y="172" fill="#e5e7eb" font-size="13" font-weight="700" text-anchor="middle">HIGH RISK</text>
  <text x="620" y="192" fill="#e5e7eb" font-size="10" text-anchor="middle">Route 1 — Annex I</text>

  <!-- No path down to Q2 -->
  <line x1="350" y1="216" x2="350" y2="256" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="368" y="240" fill="#94a3b8" font-size="12">NO</text>

  <!-- Q2 Annex III -->
  <polygon points="350,256 510,310 350,364 190,310" fill="#1f2937" stroke="#f97316" stroke-width="2"/>
  <text x="350" y="298" fill="#e5e7eb" font-size="12" text-anchor="middle">Is it a safety component in</text>
  <text x="350" y="314" fill="#e5e7eb" font-size="12" text-anchor="middle">an Annex III use — grid, water,</text>
  <text x="350" y="330" fill="#e5e7eb" font-size="12" text-anchor="middle">gas, heat, traffic, digital infra?</text>

  <line x1="510" y1="310" x2="600" y2="310" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="553" y="302" fill="#f97316" font-size="12" text-anchor="middle">YES</text>

  <!-- High risk Route 2 -->
  <rect x="560" y="287" width="120" height="70" rx="8" fill="#3b82f6" opacity="0.85" stroke="#94a3b8" stroke-width="1"/>
  <text x="620" y="316" fill="#e5e7eb" font-size="13" font-weight="700" text-anchor="middle">HIGH RISK*</text>
  <text x="620" y="336" fill="#e5e7eb" font-size="10" text-anchor="middle">Route 2 — Annex III</text>

  <line x1="350" y1="364" x2="350" y2="404" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="368" y="388" fill="#94a3b8" font-size="12">NO</text>

  <!-- Not high risk -->
  <rect x="250" y="404" width="200" height="60" rx="8" fill="#94a3b8" opacity="0.35" stroke="#94a3b8" stroke-width="1"/>
  <text x="350" y="430" fill="#e5e7eb" font-size="13" font-weight="700" text-anchor="middle">Likely NOT high-risk</text>
  <text x="350" y="450" fill="#e5e7eb" font-size="10" text-anchor="middle">but document your reasoning</text>

  <text x="350" y="500" fill="#94a3b8" font-size="11" text-anchor="middle">* Annex III systems can rebut the presumption if they pose no significant risk to</text>
  <text x="350" y="518" fill="#94a3b8" font-size="11" text-anchor="middle">health, safety or fundamental rights — a determination you must record.</text>
  <text x="350" y="540" fill="#94a3b8" font-size="11" text-anchor="middle">Substantially modify or rebrand a system and you may become its provider.</text>
</svg>
```

### Route 1 — Annex I: product-embedded AI

Under **Article 6(1)**, an AI system is high-risk if it is used as a **safety component** of a product — or is itself a product — that is covered by the EU harmonisation legislation listed in **Annex I**, *and* that product must undergo third-party conformity assessment. Annex I is essentially a roll-call of the EU product-safety regime, and it reaches deep into industry. ([Article 6](https://artificialintelligenceact.eu/article/6/); [Annex I explained](https://www.euai-act.com/articles/annex-i-explained))

| Annex I product legislation (selected) | Relevance to OT / industry |
|---|---|
| **Machinery** — Reg. (EU) 2023/1230 (replacing Dir. 2006/42/EC) | The headline case: AI as a machine safety component is auto high-risk. |
| Lifts — Dir. 2014/33/EU | AI in lift safety/control functions. |
| ATEX — Dir. 2014/34/EU (explosive atmospheres) | AI governing equipment in hazardous zones. |
| Pressure equipment — Dir. 2014/68/EU | AI in pressure-vessel safety systems. |
| Personal protective equipment — Reg. (EU) 2016/425 | AI-enabled PPE. |
| Medical devices / IVD — Reg. (EU) 2017/745, 2017/746 | AI in device safety — relevant to pharma/med-manufacturing. |
| Radio equipment — Dir. 2014/53/EU | Connected industrial radio/wireless. |
| Toys — Dir. 2009/48/EC | AI-enabled toy safety. |
| Motor vehicles, agricultural vehicles, aviation, marine equipment | AI safety components in mobility and transport equipment. |

The single most important consequence for OT is blunt: **an AI system that is a safety component under the Machinery Regulation is automatically a high-risk AI system.** Build or buy a machine whose safety depends on an AI component — an AI-driven guard, a vision system that trips a press, an adaptive controller that governs a hazardous process — and that AI is high-risk. Both regimes then apply to the same box at the same time.

> [!IMPORTANT]
> "Safety component" is a term of art, not a mood. If the AI's failure could increase the risk to health or safety of persons or property, it is doing safety-relevant work — regardless of whether anyone labelled it a "safety system." Vision that only sorts good product from bad is minimal-risk; the *same* vision system wired to stop a hazardous motion is a safety component. The wiring changes the classification.

### Route 2 — Annex III: listed use-cases

Article 6(2) makes systems listed in **Annex III** high-risk by their use-case. For industry, the relevant entry is **critical infrastructure**: AI intended to be used as a **safety component in the management and operation of critical digital infrastructure, road traffic, or the supply of water, gas, heating or electricity.** That is where some energy, water, heat and transport operators find their AI captured even when no discrete "machine" is involved. ([Annex III](https://artificialintelligenceact.eu/annex/3/); [AI in critical infrastructure](https://www.aiactblog.nl/en/annex-iii/kritieke-infrastructuur))

Three conditions must line up for the critical-infrastructure route to bite: the AI must be intended for use as a **safety component**; the use must concern the operation of one of those listed sectors; and — per the Commission's draft classification guidance — the deploying entity is generally one designated a **critical entity** under the Critical Entities Resilience framework. ([McCann FitzGerald](https://www.mccannfitzgerald.com/knowledge/construction-and-infrastructure/critical-infrastructure-spotlight-eu-ai-act-draft-guidelines-on-high-risk-ai-classification))

Annex III systems can escape high-risk status only if they genuinely do not pose a significant risk to health, safety or fundamental rights — for example, where the AI performs a narrow procedural task or merely improves a completed human activity. That escape is not a shrug; it is a **documented determination** you have to be able to defend.

This is the natural seam between the AI Act and the operational-security regimes. A grid operator's SCADA-adjacent AI can be an Annex III safety component *and* sit inside a system governed by [NIS2](/en/nis2). The classification questions and the security questions are asked of the same asset.

## What high-risk systems must do — Articles 8–15

High-risk AI systems must be built and operated against a defined set of requirements. Read Articles 8–15 as a lifecycle, not a checklist you clear once.

| Article | Requirement | What it means on the ground |
|---|---|---|
| **9** | Risk management system | Continuous, across the whole lifecycle — identify, evaluate, mitigate, repeat. |
| **10** | Data & data governance | Training/validation/test data fit for purpose, representative, examined for bias and gaps. |
| **11** | Technical documentation | The evidentiary file that demonstrates conformity — kept current. |
| **12** | Record-keeping / logging | Automatic logging of events over the system's lifetime, enabling traceability. |
| **13** | Transparency & instructions for use | Deployers get clear, complete instructions — including accuracy metrics and limits. |
| **14** | Human oversight | Designed *in*, so a competent person can understand, intervene, and stop the system. |
| **15** | Accuracy, robustness & cybersecurity | The security backbone — see below. |

### Article 15 — where AI governance meets OT security

Article 15 is the requirement OT teams should highlight. High-risk systems must achieve an appropriate level of **accuracy** (with the metrics declared in the instructions for use), **robustness** (resilience to errors, faults, inconsistencies and feedback loops, with redundancy where appropriate), and **cybersecurity** (resilience against attempts by unauthorised parties to alter the system's use, outputs or behaviour by exploiting its vulnerabilities). ([Article 15, AI Act Service Desk](https://ai-act-service-desk.ec.europa.eu/en/ai-act/article-15))

Crucially, Article 15 names AI-specific attack classes and requires measures — where appropriate — to prevent, detect, respond to, resolve and control for them:

- **Data poisoning** — corrupting the training dataset so the model learns the attacker's behaviour. For a model that will govern a process, a poisoned training set is a pre-installed backdoor.
- **Model poisoning** — tampering with pre-trained components pulled into training. Your supply chain is now part of your attack surface.
- **Adversarial examples / model evasion** — inputs crafted to make the model err. A physical sticker, a lighting change, a spoofed sensor reading that flips a classifier at exactly the wrong moment.
- **Confidentiality attacks and model flaws** — extraction, inversion, and the exploitation of latent defects.

> [!TIP]
> In IT, a manipulated model produces a wrong answer on a screen. In OT, **a manipulated model is a manipulated process.** An adversarial input that fools a vision-based safety trip, or a poisoned model that misjudges a hazardous condition, is a physical-safety event — not a data-quality issue. This is why Article 15 belongs in your control-system security programme, mapped through methods like [IEC 62443](/en/iec-62443), and not filed away as an AI-team paperwork exercise. It is also why the [CRA](/en/cra) and Article 15 overlap: both demand security-by-design for the digital components inside your products.

## Providers versus deployers

The Act splits duties by role, and getting your role right decides your obligations. The distinction is not academic — the same organisation can be a deployer of one system and, without meaning to, the provider of another.

| | **Provider** (Art. 16) | **Deployer** (Art. 26) |
|---|---|---|
| Who | Develops the AI or has it developed, and places it on the market / puts it into service under its own name | Uses a high-risk AI system under its own authority — most industrial operators |
| Core duties | Quality management system; full technical documentation; conformity assessment; EU declaration of conformity; CE marking; registration in the EU database; post-market monitoring | Use per instructions; ensure human oversight by competent people; ensure input data is relevant/representative; monitor operation, suspend and report on emerging risk; keep logs (min. 6 months) |
| Typical actor in OT | OEM, machine builder, integrator, model vendor | Plant operator, utility, asset owner |
| The trap | — | Substantially modify, retrain, or rebrand a high-risk system and you may **become the provider** — inheriting the full provider obligations |

**Providers** carry the weight, and in practice that is your OEM, integrator or model vendor. ([Article 16](https://artificialintelligenceact.eu/article/16/)) **Deployers** carry a lighter but concrete set of duties, and where you deploy AI that affects workers, you may owe them information as well. ([Article 26](https://artificialintelligenceact.eu/article/26/)) The line between the two is the one to watch at procurement and at every firmware upgrade: the moment you retrain a vendor's safety model on your own data, you have very likely stepped across it.

## A note on general-purpose AI

Separate from the risk tiers, the Act sets rules for **general-purpose AI (GPAI) models** — the large foundation models that can be adapted to many tasks. Their obligations (documentation, copyright policy, training-data summaries, and additional duties for models posing "systemic risk") applied from **2 August 2025**, and the Commission can fine GPAI providers directly. For an industrial operator this is mostly upstream — you consume GPAI through tools rather than train it — but if you fine-tune a foundation model and embed it in a product, the provider questions come back into view.

## Penalties

Article 99 sets the ceilings, and they are the highest in EU digital law. Like the GDPR and NIS2, the structure is deliberately turnover-linked so that non-compliance registers as a board-level financial risk, not a line item.

| Breach | Maximum fine | Article |
|---|---|---|
| Prohibited practices | **€35,000,000 or 7%** of total worldwide annual turnover, whichever is higher | Art. 5 → Art. 99 |
| Breach of other obligations (providers, deployers, importers, distributors, notified bodies, transparency) | **€15,000,000 or 3%** of worldwide turnover | Art. 99 |
| Supplying incorrect, incomplete or misleading information to authorities / notified bodies | **€7,500,000 or 1%** of worldwide turnover | Art. 99 |
| GPAI model provider infringements | **€15,000,000 or 3%** of worldwide turnover | Art. 101 |

Fines are proportionate, and for SMEs and start-ups the figure is capped at whichever of the percentage or the absolute amount is **lower** — a deliberate softening for smaller firms. ([Article 99](https://artificialintelligenceact.eu/article/99/); [Article 101](https://ai-act-service-desk.ec.europa.eu/en/ai-act/article-101))

## The Machinery Regulation connection

The AI Act does not stand alone. The **Machinery Regulation (EU) 2023/1230** — which replaces the old Machinery Directive and applies from **20 January 2027** — modernises machine safety for a world of software, connectivity and AI, and for the first time makes **cybersecurity an essential health-and-safety requirement**. ([EUR-Lex 2023/1230](https://eur-lex.europa.eu/eli/reg/2023/1230/oj/eng); [Nemko](https://www.nemko.com/blog/eu-machinery-regulation-2023/1230))

The revised Annex III essential requirements now address AI behaviour, cybersecurity, human-robot collaboration, IoT connectivity, the safety impact of software updates and functional safety. In plain terms: safety-related control systems and software must be immune to both accidental failure *and* deliberate attack, and connecting a device to a machine must not create a hazard. Cybersecurity in machinery is no longer optional — it is part of the safety case.

The two laws are stitched together on purpose. A safety-related AI component in a machine is high-risk under the AI Act, and the machine itself must satisfy the Machinery Regulation's safety and security requirements. The EU has moved explicitly to clarify the overlap so that a manufacturer does not face two contradictory conformity paths for one machine. ([IAPP](https://iapp.org/news/a/eu-agrees-to-amend-ai-act-clarifies-overlap-with-machinery-rules)) For a machine builder or an operator commissioning new equipment, the compliant route runs through **both at once** — which is exactly why the classification work and the security engineering want to happen in the same room. See the [Machinery Regulation](/en/machine-act) page for the machine-safety side of this story.

## What it means for OT — and for your role

The honest headline bears repeating: **most industrial AI is not high-risk.** The work is in finding the AI that is, classifying it correctly, and governing it without smothering useful innovation. Different people in the organisation feel that work differently.

**If you are a CISO or AI-governance lead**, the AI Act extends your remit into models embedded in OT, and Article 15 makes model robustness and cybersecurity explicitly your problem. You need an inventory of AI systems, a defensible classification for each, and evidence that the high-risk few are governed — including against data poisoning and adversarial manipulation.

**If you are an operations or engineering manager**, the questions become concrete at procurement and at every upgrade: Is this AI a safety component? Who is the provider? Is there a declaration of conformity and a CE marking? Does retraining or modifying it turn *us* into the provider?

**If you sit on the board**, the AI Act adds a second turnover-linked penalty regime on top of NIS2, and the accountability for classification and governance ultimately rests with you. The reassuring part is that the scope is narrower than the headlines suggest; the uncomfortable part is that "we didn't know we had that AI" is not a defence.

## A practical approach — inventory, classify, govern

1. **Inventory your AI.** You cannot classify what you have not listed. Build a register of AI systems across IT and OT, including embedded models inside drives, controllers and vision cells, and vendor-supplied models you may not think of as "AI."
2. **Classify each system.** For each, decide: prohibited, high-risk (via Annex I or Annex III), limited-risk, or minimal-risk — and **document the reasoning**, especially where you conclude a system is *not* high-risk. The Act expects you to be able to justify that call.
3. **Fix your role.** For each high-risk system, establish whether you are provider or deployer, and confirm the provider has done their part — conformity assessment, CE marking, documentation, declaration of conformity.
4. **Govern the high-risk few.** Put human oversight, logging, monitoring and — for anything in a control or safety loop — Article 15 robustness and cybersecurity controls in place. Test the model against adversarial inputs, not just nominal ones.
5. **Align with your OT security programme.** Treat AI robustness as part of control-system security, not a separate silo. Data poisoning and model manipulation are OT threats now, and they belong on the same risk register as ransomware and remote-access exposure. See [Frameworks](/en/frameworks) for how the regimes fit together.

## How OXOT helps

AI classification and Article 15 robustness are, at their core, questions about where AI sits in your operational risk picture — which is precisely what OXOT models. Our **[Cyber Digital Twin](/en/cyber-digital-twin)** gives you a structured, living view of your OT estate, including where AI components sit relative to safety and control functions, so you can find the high-risk few and govern the cybersecurity of the models that actually matter. Our OT security assessments and programmes fold AI robustness into your broader control-system security, and our **[IEC 62443](/en/iec-62443)** alignment gives you an engineering method for demonstrating that the security requirements — Article 15's included — are met. Where the AI Act meets the [CRA](/en/cra), [NIS2](/en/nis2) and the [Machinery Regulation](/en/machine-act), we help you answer all four with one coherent view instead of four disconnected projects.

## Frequently asked questions

**Is our predictive-maintenance model high-risk?**
Almost certainly not, if it only informs maintenance and does not act as a safety component or control a hazardous process. But document that conclusion — the Act expects you to justify a not-high-risk classification, and "we assumed so" is not documentation.

**We buy machines with AI inside from an OEM. Are we the provider?**
Usually the OEM is the provider. But if you substantially modify the AI, retrain it on your own data, or place it on the market under your own name, you can become the provider and inherit those obligations. Check before you modify — the trap springs quietly.

**How does the AI Act relate to NIS2, the CRA and the Machinery Regulation?**
They stack. [NIS2](/en/nis2) governs how you operate your systems; the [CRA](/en/cra) governs the security of products with digital elements; the [Machinery Regulation](/en/machine-act) makes cybersecurity a machine-safety requirement; and the AI Act governs AI systems specifically, with Article 15 as the security bridge. A safety-related industrial AI can be touched by all four at once.

**The high-risk deadlines moved — do I have more time?**
Yes, and no. The Digital Omnibus deferred standalone Annex III systems to 2 December 2027 and product-embedded Annex I AI to 2 August 2028 — but those dates are provisional until the amending act is published, and the prohibitions and AI-literacy duties already apply. Inventory and classification take longer than the paperwork that follows, so starting now is the cheap option.

**Does the Act care which AI technique we used?**
No. It is technology-neutral. A rule-based system and a deep neural network are treated the same if they do the same safety-relevant job in the same place. What matters is the *function and context*, not the algorithm.

## Sources

- Regulation (EU) 2024/1689 (AI Act), official text — [EUR-Lex](https://eur-lex.europa.eu/eli/reg/2024/1689/oj/eng)
- AI Act policy and implementation — [European Commission, Shaping Europe's digital future](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai)
- Article 6 — classification of high-risk systems — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/article/6/)
- Article 15 — accuracy, robustness and cybersecurity — [AI Act Service Desk (EC)](https://ai-act-service-desk.ec.europa.eu/en/ai-act/article-15)
- Article 16 — provider obligations — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/article/16/)
- Article 26 — deployer obligations — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/article/26/)
- Article 99 — penalties — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/article/99/)
- Article 101 — GPAI model fines — [AI Act Service Desk (EC)](https://ai-act-service-desk.ec.europa.eu/en/ai-act/article-101)
- Annex I — Union harmonisation legislation (incl. machinery) — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/annex/1/)
- Annex III — high-risk use-cases (incl. critical infrastructure) — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/annex/3/)
- Digital Omnibus — postponed high-risk deadlines (agreed 7 May 2026) — [Gibson Dunn](https://www.gibsondunn.com/eu-ai-act-omnibus-agreement-postponed-high-risk-deadlines-and-other-key-changes/); [Hogan Lovells](https://www.hoganlovells.com/en/publications/eu-legislators-agree-to-delay-for-highrisk-ai-rules)
- Draft high-risk classification guidance — [McCann FitzGerald](https://www.mccannfitzgerald.com/knowledge/construction-and-infrastructure/critical-infrastructure-spotlight-eu-ai-act-draft-guidelines-on-high-risk-ai-classification)
- EU Machinery Regulation (EU) 2023/1230 — [EUR-Lex](https://eur-lex.europa.eu/eli/reg/2023/1230/oj/eng); cybersecurity overview — [Nemko](https://www.nemko.com/blog/eu-machinery-regulation-2023/1230)
- AI Act / Machinery Regulation overlap clarified — [IAPP](https://iapp.org/news/a/eu-agrees-to-amend-ai-act-clarifies-overlap-with-machinery-rules)

*This page is general information about EU law, not legal advice. Classification under the AI Act is fact-specific; confirm your systems' status against the Regulation and, where needed, qualified counsel.*
