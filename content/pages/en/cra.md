---
title: The Cyber Resilience Act (CRA)
meta_title: Cyber Resilience Act (CRA) for OT & Products with Digital Elements | OXOT
meta_description: The EU Cyber Resilience Act (Regulation (EU) 2024/2847) explained for OT — scope, product classes, Annex I security & vulnerability-handling requirements, SBOM, 24-hour reporting, ~5-year support periods, the 2024→2027 timeline, penalties, and IEC 62443 mapping.
excerpt: Security-by-design becomes a legal condition of market access. A field guide to CRA scope, product classes, Annex I, SBOM, 24-hour reporting, support periods and what it means for OT manufacturers and buyers.
content_type: page
published: true
---

The Cyber Resilience Act is the European Union's answer to a simple, uncomfortable fact: for decades, digital products have shipped with security treated as optional, and the cost has landed on the people who use them. The CRA changes the deal. For the first time, **security becomes a legal condition of placing a product with digital elements on the EU market** — from consumer gadgets to the industrial controllers, gateways and software that run operational environments.

If [NIS2](/en/nis2) is a law for the *operators* who run systems, the CRA is the law for the *makers* of the products those systems are built from. Industrial organisations tend to meet it from both sides at once: as a buyer who can finally demand security as a right, and — if you build, integrate or substantially modify products — as a manufacturer who now carries obligations backed by turnover-linked fines.

## The short version

- The CRA is **Regulation (EU) 2024/2847**. It **entered into force on 10 December 2024**. ([EUR-Lex, official text](https://eur-lex.europa.eu/eli/reg/2024/2847/oj/eng))
- It applies to **products with digital elements** (PDEs) — hardware and software whose intended or foreseeable use includes a direct or indirect data connection to a device or network.
- **Manufacturers** carry the core duties: security by design and by default, vulnerability handling, an SBOM, and a defined **support period** of as a rule at least five years.
- **Vulnerability and incident reporting** obligations apply from **11 September 2026**; the **main obligations** apply from **11 December 2027**. ([European Commission](https://digital-strategy.ec.europa.eu/en/policies/cyber-resilience-act))
- Products must meet the **essential requirements in Annex I** and carry the **CE marking**.
- **Actively exploited vulnerabilities** and **severe incidents** trigger an **early warning within 24 hours** to ENISA and the national CSIRT, via a single reporting platform.
- Penalties reach **€15 million or 2.5% of worldwide annual turnover**, whichever is higher.

> [!IMPORTANT]
> The reporting clock starts before the main obligations. Detection and disclosure machinery has to be running by **11 September 2026** — more than a year before you need a CE mark on the product itself.

## Why the CRA exists

Two structural problems drove the law. First, a **low level of cybersecurity** in many digital products — weak default configurations, unpatched vulnerabilities, no clear route to report a flaw. Second, an **insufficient understanding and access to information** among users, who could not tell a secure product from an insecure one at the point of purchase, and often could not obtain security updates even when they wanted them. ([CRA summary, European Commission](https://digital-strategy.ec.europa.eu/en/policies/cra-summary))

The fix pushes responsibility upstream, to the party best placed to act: the manufacturer. It reuses the proven machinery of EU product law — essential requirements, conformity assessment, CE marking, market surveillance — and points it at cybersecurity. "Secure by design" and "secure by default" stop being slogans and become the price of market access.

## The CRA timeline

The Regulation phases in over three years. The dates below are the ones to plan against; the gap between them is where the engineering work has to happen.

```svg
<svg viewBox="0 0 700 240" xmlns="http://www.w3.org/2000/svg" font-family="system-ui, sans-serif">
  <line x1="40" y1="120" x2="660" y2="120" stroke="#94a3b8" stroke-width="2"/>
  <!-- milestone 1 -->
  <circle cx="90" cy="120" r="8" fill="#3b82f6"/>
  <line x1="90" y1="120" x2="90" y2="70" stroke="#94a3b8" stroke-width="1"/>
  <text x="90" y="58" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">10 Dec 2024</text>
  <text x="90" y="150" fill="#e5e7eb" font-size="12" text-anchor="middle">Enters into</text>
  <text x="90" y="166" fill="#e5e7eb" font-size="12" text-anchor="middle">force</text>
  <!-- milestone 2 -->
  <circle cx="300" cy="120" r="8" fill="#f97316"/>
  <line x1="300" y1="120" x2="300" y2="70" stroke="#94a3b8" stroke-width="1"/>
  <text x="300" y="58" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">11 Sep 2026</text>
  <text x="300" y="150" fill="#e5e7eb" font-size="12" text-anchor="middle">Reporting</text>
  <text x="300" y="166" fill="#e5e7eb" font-size="12" text-anchor="middle">obligations apply</text>
  <text x="300" y="182" fill="#e5e7eb" font-size="12" text-anchor="middle">(Art. 14)</text>
  <!-- milestone 3 -->
  <circle cx="510" cy="120" r="8" fill="#94a3b8"/>
  <line x1="510" y1="120" x2="510" y2="70" stroke="#94a3b8" stroke-width="1"/>
  <text x="510" y="58" fill="#e5e7eb" font-size="12" font-weight="bold" text-anchor="middle">Mid–late 2026</text>
  <text x="510" y="150" fill="#e5e7eb" font-size="12" text-anchor="middle">Harmonised</text>
  <text x="510" y="166" fill="#e5e7eb" font-size="12" text-anchor="middle">standards due</text>
  <!-- milestone 4 -->
  <circle cx="640" cy="120" r="9" fill="#3b82f6" stroke="#e5e7eb" stroke-width="2"/>
  <line x1="640" y1="120" x2="640" y2="70" stroke="#94a3b8" stroke-width="1"/>
  <text x="640" y="58" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">11 Dec 2027</text>
  <text x="640" y="150" fill="#e5e7eb" font-size="12" text-anchor="middle">Main</text>
  <text x="640" y="166" fill="#e5e7eb" font-size="12" text-anchor="middle">obligations</text>
  <text x="640" y="182" fill="#e5e7eb" font-size="12" text-anchor="middle">apply</text>
  <text x="350" y="215" fill="#94a3b8" font-size="11" text-anchor="middle">Three-year phase-in — the runway is already short for third-party assessment</text>
</svg>
```

| Date | What applies |
|---|---|
| **10 December 2024** | The CRA enters into force. The clock starts; obligations phase in from here. |
| **Mid–late 2026** | Harmonised standards and product-classification detail expected, giving manufacturers the technical basis for conformity. |
| **11 September 2026** | **Vulnerability and incident reporting obligations (Article 14)** apply. The ENISA single reporting platform is due to be operational. ([EC — reporting](https://digital-strategy.ec.europa.eu/en/policies/cra-reporting)) |
| **11 December 2027** | The **main obligations** — essential requirements, conformity assessment, CE marking — apply in full. |

Building secure-development and vulnerability-handling processes, producing SBOMs, and arranging third-party assessment for important and critical products are multi-year programmes, not last-quarter projects.

## What counts as a "product with digital elements"

The scope is deliberately broad. A **product with digital elements** is any software or hardware product, and its remote data-processing solutions, whose intended or reasonably foreseeable use includes a **direct or indirect logical or physical data connection** to a device or network.

In an industrial setting that captures a great deal:

- **PLCs, RTUs and industrial controllers** — the logic that runs the process.
- **Protocol gateways and network devices** — the translators and routers between OT and IT.
- **HMIs and engineering workstations software** — the human-facing and configuration layers.
- **Industrial IoT sensors and edge devices** — the growing population of connected endpoints.
- **Firmware and application software** running on all of the above, including standalone software sold on its own.

Some categories are carved out because they are already regulated elsewhere — certain medical devices, motor vehicles and aviation products fall under their own sectoral regimes rather than the CRA. If your product sits at a boundary (say, machinery with a digital control system), you may be reading the CRA alongside the [Machinery Regulation](/en/machine-act).

## Who carries the obligations

The CRA follows the value chain, and the weight is not evenly spread.

| Role | Core duty under the CRA |
|---|---|
| **Manufacturer** | Substantive obligations: secure design, Annex I compliance, SBOM, vulnerability handling, support period, reporting, conformity assessment, CE marking. |
| **Importer** | Must not place non-compliant products on the market; verify the manufacturer met its duties; act on non-conformity. |
| **Distributor** | Act with due care; must not make available products they know or should know are non-compliant. |

> [!WARNING]
> **You can become a "manufacturer" without ever calling yourself one.** If you place a product on the market under your own name or trademark, or if you **substantially modify** a product already on the market, you take on the manufacturer's obligations for it. System integrators and operators who rebrand, re-flash firmware, or significantly alter a device need to know exactly where that line sits — per product, before 2027.

That "substantial modification" trigger is the one that surprises OT teams. A machine builder who integrates a third-party controller and ships the line under their own name, or an operator who re-images a device and pushes it back into service materially changed, can inherit the full manufacturer stack. Map your role for each product now, while there is time to design the process rather than react to it.

## Product classes and conformity assessment

Not all products are treated alike. The CRA sorts PDEs by criticality, and the class determines how rigorously conformity must be demonstrated. Classification follows the product's core function: match a category in **Annex III** and it is *important* (Class I or II); match **Annex IV** and it is *critical*; match neither and it is *default*. ([EC — conformity assessment](https://digital-strategy.ec.europa.eu/en/policies/cra-conformity-assessment))

| Class | Examples (Annex III / IV) | Conformity route |
|---|---|---|
| **Default** | The large majority of products, listed in neither annex. | **Self-assessment** (internal control) against the essential requirements. |
| **Important — Class I** | Operating systems, network routers, network interfaces, microcontrollers/microprocessors, boot managers, password managers, antivirus. | Self-assessment **only if** harmonised standards / common specifications are applied; otherwise **third-party** assessment via a notified body. |
| **Important — Class II** | Firewalls, VPNs, virtualisation runtimes supporting OS execution. | **Third-party** conformity assessment via a **notified body**. |
| **Critical** | Highest-sensitivity categories with systemic risk — e.g. hardware devices with secure elements, smart meters. | May require **European cybersecurity certification** under the Cybersecurity Act framework. |

Many industrial devices — network equipment, security components, controllers with safety or security functions — land in the important or higher tiers. That means third-party assessment rather than a self-declaration, which drives both timeline and cost. Classify the portfolio early; the assessment route, not the code, is usually the long pole in the schedule.

## Annex I, Part I — the product's security properties

Annex I is where the CRA becomes concrete, and it has two parts. **Part I** governs how the product itself must behave. Products must be designed, developed and produced to ensure an appropriate level of cybersecurity based on the risks. ([CRA annexes](https://www.cyberresilienceact.eu/annexes.html))

| Security property | What it demands in practice |
|---|---|
| **No known exploitable vulnerabilities** | Ship without known, exploitable flaws — vulnerability management before release, not after. |
| **Secure by default** | Delivered with a secure configuration out of the box; the safe path is the default path. |
| **Access control & authentication** | Protect against unauthorised access with appropriate authentication and identity controls. |
| **Confidentiality & integrity** | Protect data and commands at rest, in transit and in processing — encryption and integrity checks. |
| **Data minimisation** | Process only data that is adequate, relevant and limited to what the product needs. |
| **Availability & resilience** | Protect essential functions; resist and recover from denial-of-service. |
| **Minimised attack surface** | Reduce exposed interfaces, services and external dependencies. |
| **Exploitation mitigation** | Apply appropriate hardening and mitigation techniques. |
| **Security logging & monitoring** | Record and monitor relevant activity; give operators a way to see what happened. |
| **Secure updates** | Provide security updates, where feasible automatic, with a clear opt-out. |

For OT, several of these read like a to-do list the industry has been writing in white papers for a decade — now with a legal force behind them.

## Annex I, Part II — vulnerability handling and the SBOM

**Part II** governs the process a manufacturer must run across the support period. This is the operational discipline behind the product's security properties.

| Vulnerability-handling duty | What it means |
|---|---|
| **Identify & document components** | Know what is inside the product, including a **software bill of materials (SBOM)** covering top-level dependencies. |
| **Remediate without delay** | Address and fix vulnerabilities promptly, including via **free security updates** for the support period. |
| **Regular testing** | Apply effective, regular security testing and reviews. |
| **Coordinated disclosure** | Operate a policy for coordinated vulnerability disclosure. |
| **Public disclosure of fixes** | Once a fix is available, share information about fixed vulnerabilities with a description. |
| **Reporting contact** | Provide a single point of contact for reporting vulnerabilities. |
| **Secure distribution** | Distribute updates securely and, where relevant, promptly and free of charge. |

> [!NOTE]
> **Why the SBOM matters more than it looks.** Industrial products are assembled from layers of third-party and open-source components. The SBOM obligation forces manufacturers to actually know what is inside their products and to track the vulnerabilities those components carry. For operators, a vendor SBOM is a direct input to your own risk picture — and a reasonable thing to demand in procurement well before 2027.

## The manufacturer's lifecycle of obligations

Read end to end, the CRA describes a lifecycle rather than a one-time gate. Secure design feeds an SBOM; the SBOM and Annex I compliance support conformity and the CE mark; once on the market, vulnerability handling and updates run for the whole support period, with reporting layered on top.

```svg
<svg viewBox="0 0 700 300" xmlns="http://www.w3.org/2000/svg" font-family="system-ui, sans-serif">
  <!-- top row blocks -->
  <rect x="20" y="40" width="150" height="60" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="95" y="66" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Secure design</text>
  <text x="95" y="84" fill="#94a3b8" font-size="11" text-anchor="middle">Annex I Part I</text>

  <rect x="200" y="40" width="150" height="60" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="275" y="66" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">SBOM &amp;</text>
  <text x="275" y="84" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">components</text>

  <rect x="380" y="40" width="150" height="60" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="455" y="66" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Conformity</text>
  <text x="455" y="84" fill="#94a3b8" font-size="11" text-anchor="middle">assessment + CE</text>

  <rect x="540" y="40" width="140" height="60" rx="8" fill="#3b82f6" fill-opacity="0.12" stroke="#3b82f6" stroke-width="2"/>
  <text x="610" y="76" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">On the market</text>

  <!-- arrows top row -->
  <line x1="170" y1="70" x2="200" y2="70" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr)"/>
  <line x1="350" y1="70" x2="380" y2="70" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr)"/>
  <line x1="530" y1="70" x2="540" y2="70" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr)"/>

  <!-- down into lifecycle band -->
  <line x1="610" y1="100" x2="610" y2="160" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr)"/>

  <!-- lifecycle band -->
  <rect x="60" y="170" width="440" height="70" rx="8" fill="none" stroke="#f97316" stroke-width="2"/>
  <text x="280" y="198" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Vulnerability handling &amp; security updates</text>
  <text x="280" y="220" fill="#94a3b8" font-size="11" text-anchor="middle">Support period — as a rule ≥ 5 years (Annex I Part II)</text>

  <rect x="530" y="170" width="150" height="70" rx="8" fill="#f97316" fill-opacity="0.12" stroke="#f97316" stroke-width="2"/>
  <text x="605" y="198" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Reporting</text>
  <text x="605" y="218" fill="#94a3b8" font-size="11" text-anchor="middle">24h / 72h / final</text>

  <line x1="530" y1="205" x2="500" y2="205" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr)"/>

  <!-- feedback loop -->
  <path d="M 60 205 Q 20 205 20 140 Q 20 70 20 70" fill="none" stroke="#94a3b8" stroke-width="1.5" stroke-dasharray="4 4" marker-end="url(#arr)"/>
  <text x="30" y="270" fill="#94a3b8" font-size="11" text-anchor="start">Findings feed back into design and updates</text>

  <defs>
    <marker id="arr" markerWidth="8" markerHeight="8" refX="6" refY="3" orient="auto">
      <path d="M0,0 L6,3 L0,6 Z" fill="#94a3b8"/>
    </marker>
  </defs>
</svg>
```

## The support period — a new shape for vendor relationships

One of the CRA's most practically significant demands is the **support period**: manufacturers must provide security updates for a period appropriate to the product, and **as a rule at least five years** (shorter only where the product is expected to be in use for less time). Technical documentation and the EU declaration of conformity must be kept for at least ten years, or the support period if longer.

For industrial equipment that routinely runs for a decade or more, this reframes the commercial relationship. Security support stops being a goodwill gesture that lapses when a product line is discontinued, and becomes a legal expectation over a defined lifetime. For buyers, the support period is a negotiating anchor: you can hold a vendor to a stated window, and you can ask what happens at end of support before you sign.

## Reporting — the 24-hour clock

The CRA introduces a sharp, staged reporting regime under **Article 14**. **Actively exploited vulnerabilities** and **severe incidents** affecting product security must be notified through a single reporting platform to the manufacturer's national **CSIRT** and, simultaneously, **ENISA**. ([EC — reporting](https://digital-strategy.ec.europa.eu/en/policies/cra-reporting))

| Stage | Deadline | Content |
|---|---|---|
| **Early warning** | Within **24 hours** of becoming aware | First alert that an actively exploited vulnerability or severe incident exists. |
| **Notification** | Within **72 hours** | Fuller detail, including corrective or mitigating measures taken. |
| **Final report** | **14 days** (vulnerability, after a fix is available) / **1 month** (severe incident) | Description, severity, impact and remediation. ([CRA reporting deadlines](https://www.cyberresilienceact.eu/reporting.html)) |

Two operational consequences. First, this obligation lands on **11 September 2026**, ahead of the main Act — so the detection, triage and disclosure pipeline has to exist before the product-conformity work is even finished. Second, the reporting is single-submission: one report through the platform reaches the CSIRT and ENISA, which then propagates to other affected CSIRTs. Microenterprises and small enterprises get some relief from penalties for missing the 24-hour vulnerability deadline, but the obligation itself still applies.

> [!TIP]
> Treat CRA reporting and your [NIS2](/en/nis2) incident reporting as one detection-and-response capability, not two. The underlying muscle — spotting a severe event, deciding it is reportable, and getting a first notification out within a day — is the same. Build it once.

## Penalties

Non-compliance with the **essential requirements or the core manufacturer obligations** can attract fines of up to **€15 million or 2.5% of total worldwide annual turnover**, whichever is higher. Lower ceilings apply to other infringements and to supplying incorrect, incomplete or misleading information.

| Infringement | Ceiling (higher of) |
|---|---|
| Essential requirements (Annex I) & core manufacturer obligations | **€15 million or 2.5%** of worldwide annual turnover |
| Other CRA obligations | **€10 million or 2%** of worldwide annual turnover |
| Incorrect, incomplete or misleading information to authorities / notified bodies | **€5 million or 1%** of worldwide annual turnover |

As with NIS2 and the [AI Act](/en/ai-act), the turnover linkage is deliberate: product security is now a board-level commercial risk, not a line item that lives and dies in engineering. ([Pillsbury — CRA requirements](https://www.pillsburylaw.com/en/news-and-insights/eu-cyber-resilience-act-requirements-products-software.html))

## The CRA and OT — two sides of the same coin

The CRA and NIS2 are complementary halves of one strategy. **[NIS2](/en/nis2)** obliges operators to manage the risk of the systems they run; the CRA obliges manufacturers to make those systems securable in the first place. An operator's NIS2 supply-chain duty (Article 21) becomes far easier to discharge when the products in the chain are CRA-compliant — arriving with SBOMs, security updates and a support commitment instead of a shrug.

### Mapping the CRA to IEC 62443

**[IEC 62443](/en/iec-62443)** is the natural engineering bridge for OT vendors. Its process and component standards line up closely with Annex I, so a manufacturer already building to 62443 has done much of the CRA's groundwork. The mapping is not one-to-one, but it is close enough to reuse.

| CRA obligation | Closest IEC 62443 anchor |
|---|---|
| Secure development lifecycle (Annex I Part II process) | **IEC 62443-4-1** — secure product development lifecycle requirements |
| Product/component security properties (Annex I Part I) | **IEC 62443-4-2** — technical security requirements for components |
| System-level security capabilities | **IEC 62443-3-3** — system security requirements and security levels |
| Vulnerability handling, disclosure, patch management | **IEC 62443-4-1** practices (defect / patch management, security update guidelines) |
| SBOM / component inventory | Component management within 62443-4-1, extended by CRA's explicit SBOM duty |

Aligning the two avoids duplicated effort and gives a defensible, internationally recognised basis for conformity. Where the CRA is legally binding but standard-agnostic, 62443 supplies the concrete engineering content — a pairing that also travels well across the broader [frameworks](/en/frameworks) landscape.

For OT specifically, the CRA is the mechanism that should, over time, raise the security floor of the controllers, gateways and software that make up industrial systems — closing the gap operators have spent years papering over with segmentation and monitoring.

## The manufacturer's readiness journey

Getting to CRA conformity is a sequence, not a switch. The five stages below track how most OT product teams will move from "aware of the deadline" to "CE mark defensible."

```carousel
Stage 1 — Scope and classify
Inventory every product with digital elements you place on the EU market. For each, decide the class: default, important Class I/II, or critical. The class fixes your conformity route and therefore your timeline. This is also where you find the products where you have quietly become the "manufacturer" through rebranding or substantial modification.
---
Stage 2 — Gap-assess against Annex I
Measure each product against Annex I Part I (security properties) and Part II (vulnerability handling). Teams already aligned to IEC 62443-4-1/4-2 will find much of this maps across. The output is a prioritised gap list, not a pass/fail — most products need work in a handful of specific areas rather than a rebuild.
---
Stage 3 — Build the vulnerability-handling machine
Stand up the SBOM pipeline, coordinated disclosure policy, reporting contact, testing cadence, and secure update mechanism. This is the part that has to be live by 11 September 2026 for reporting, so it leads the schedule — ahead of the product-conformity work itself.
---
Stage 4 — Conformity assessment and CE
Run the applicable procedure: self-assessment for default and (with harmonised standards) Class I, or a notified body for Class II and critical. Assemble technical documentation, issue the EU declaration of conformity, and affix the CE marking. Notified-body capacity is finite — book early.
---
Stage 5 — Operate across the support period
Sustain updates, monitoring and disclosure for the support period — as a rule at least five years. Keep technical documentation for ten years. Feed field findings back into design. Conformity is a state you maintain, not a certificate you file and forget.
```

## What it means for your role

**If you manufacture, integrate or rebrand industrial products**, the CRA is a direct compliance obligation with a hard 2027 deadline and a 2026 reporting waypoint. Classify the portfolio, build secure-development and vulnerability-handling processes, produce SBOMs, commit to a support period, and — for important and critical products — line up conformity assessment while notified-body slots exist.

**If you are an operator or buyer**, the CRA is leverage. From 2027 the products you buy must meet the essential requirements; before then, you can already write CRA-aligned expectations — an SBOM, free security updates, a stated support window, a disclosure contact — into procurement and tender criteria. The Act hands buyers a vocabulary they never had.

**If you sit on the board of a manufacturer**, the CRA adds another turnover-linked penalty regime and turns product security into a governance matter with a defined runway. The question to ask management is not "are we compliant?" but "which products are on which conformity route, and what is the critical path to 2027?"

## How OXOT helps

OXOT works both sides of the CRA. For **operators**, we fold CRA-aligned requirements into procurement and into the supply-chain dimension of your NIS2 and OT security programmes, and our **[Cyber Digital Twin](/en/cyber-digital-twin)** gives you a structured place to hold vendor SBOMs and component risk so a new CVE in a shared library is a lookup, not a fire drill. For **manufacturers and integrators**, we translate Annex I into an engineering programme aligned to [IEC 62443](/en/iec-62443)-4-1/4-2 — turning the regulation into a concrete, evidenced path to conformity rather than a compliance scramble.

*OXOT's CRA Readiness materials — including our Annex-mapped readiness sheet and preparation service — will be linked here as a deeper resource set.*

## Frequently asked questions

**Does the CRA apply to software as well as hardware?**
Yes. Standalone software is a product with digital elements. Firmware and application software are both in scope, subject to the sectoral carve-outs (certain medical, automotive and aviation products regulated elsewhere).

**We integrate third-party controllers into our machines. Are we a manufacturer under the CRA?**
Possibly. If you place the integrated product on the market under your own name, or substantially modify components, you can take on manufacturer obligations. Map your role per product before 2027 — and watch the "substantial modification" line closely.

**Is an SBOM really mandatory?**
Annex I Part II requires manufacturers to identify and document components, including producing a software bill of materials, as part of vulnerability handling. Treat it as a core deliverable, not an optional extra.

**When exactly do we have to start reporting?**
The Article 14 reporting obligations apply from **11 September 2026** — earlier than the main obligations. An actively exploited vulnerability or severe incident triggers a 24-hour early warning, a 72-hour notification, and a final report (14 days for a vulnerability once fixed, one month for a severe incident).

**How long must we support a product?**
As a rule at least five years, or the product's expected time in use if shorter. Retain technical documentation and the declaration of conformity for at least ten years, or the support period if longer.

**How does the CRA relate to the AI Act, NIS2 and the Machinery Regulation?**
The **[AI Act](/en/ai-act)** governs AI systems, the CRA governs products with digital elements, **[NIS2](/en/nis2)** governs operators, and the **[Machinery Regulation](/en/machine-act)** governs machinery safety including digital control. A connected industrial machine with an AI safety component could engage all four — which is exactly why a single, coherent OT security programme beats four disconnected compliance efforts.

## Sources

- Regulation (EU) 2024/2847 (Cyber Resilience Act), official text — [EUR-Lex](https://eur-lex.europa.eu/eli/reg/2024/2847/oj/eng)
- Cyber Resilience Act policy overview — [European Commission](https://digital-strategy.ec.europa.eu/en/policies/cyber-resilience-act)
- CRA summary of the legislative text — [European Commission](https://digital-strategy.ec.europa.eu/en/policies/cra-summary)
- CRA conformity assessment — [European Commission](https://digital-strategy.ec.europa.eu/en/policies/cra-conformity-assessment)
- CRA reporting obligations — [European Commission](https://digital-strategy.ec.europa.eu/en/policies/cra-reporting)
- CRA scope, classes and deadlines — [cyberresilienceact.eu](https://www.cyberresilienceact.eu/explained.html)
- CRA annexes I–VIII, essential requirements and product lists — [cyberresilienceact.eu](https://www.cyberresilienceact.eu/annexes.html)
- CRA reporting deadlines (Article 14) — [cyberresilienceact.eu](https://www.cyberresilienceact.eu/reporting.html)
- CRA requirements for connected products and software — [Pillsbury Law](https://www.pillsburylaw.com/en/news-and-insights/eu-cyber-resilience-act-requirements-products-software.html)

*This page is general information about EU law, not legal advice. Confirm how the CRA applies to your products and role against the Regulation and, where needed, qualified counsel.*
