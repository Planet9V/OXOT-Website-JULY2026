-- 017_seed_cra_reference_pages.sql
-- Seed the two new CRA deep-reference pages (technical reference, CE-marking
-- pathways) and refresh /cra with cross-links. EN only in this migration; NL is
-- added in a later migration. Idempotent: ON CONFLICT (slug,locale) DO UPDATE.

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('cra', 'en', 'The Cyber Resilience Act (CRA)', 'The Cyber Resilience Act is the European Union''s answer to a simple, uncomfortable fact: for decades, digital products have shipped with security treated as optional, and the cost has landed on the people who use them. The CRA changes the deal. For the first time, **security becomes a legal condition of placing a product with digital elements on the EU market** — from consumer gadgets to the industrial controllers, gateways and software that run operational environments.

If [NIS2](/en/nis2) is a law for the *operators* who run systems, the CRA is the law for the *makers* of the products those systems are built from. Industrial organisations tend to meet it from both sides at once: as a buyer who can finally demand security as a right, and — if you build, integrate or substantially modify products — as a manufacturer who now carries obligations backed by turnover-linked fines.

```keyfacts
Instrument :: Regulation (EU) 2024/2847 — directly applicable
Entered into force :: 10 December 2024
Reporting obligations :: from 11 September 2026
Main obligations :: from 11 December 2027
Support period :: as a rule ≥ 5 years
Early-warning clock :: 24 hours to ENISA + CSIRT
Conformity :: Annex I + CE marking
Max penalty :: €15M or 2.5% of global turnover
Aligns with :: [IEC 62443](/en/iec-62443)
```

## The short version

- The CRA is **Regulation (EU) 2024/2847**, a directly applicable Regulation — not a Directive — so it takes effect identically across all 27 Member States with no national transposition step. ([EUR-Lex, official text](https://eur-lex.europa.eu/eli/reg/2024/2847/oj/eng))
- It **entered into force on 10 December 2024** and applies to **products with digital elements** (PDEs) — hardware and software whose intended or foreseeable use includes a direct or indirect data connection to a device or network.
- **Manufacturers** carry the core duties: security by design and by default, vulnerability handling, an SBOM, and a defined **support period** of as a rule at least five years.
- **Vulnerability and incident reporting** obligations apply from **11 September 2026**; the **main obligations** apply from **11 December 2027**. ([European Commission](https://digital-strategy.ec.europa.eu/en/policies/cyber-resilience-act))
- Products must meet the **essential requirements in Annex I** and carry the **CE marking**. Classification against **Commission Implementing Regulation (EU) 2025/2392** — published 1 December 2025 — fixes which conformity route applies.
- **Actively exploited vulnerabilities** and **severe incidents** trigger an **early warning within 24 hours** to ENISA and the national CSIRT, via a single reporting platform.
- Penalties reach **€15 million or 2.5% of worldwide annual turnover**, whichever is higher.

> [!IMPORTANT]
> The reporting clock starts before the main obligations, and it does not wait for a product to be new. Detection and disclosure machinery has to be running by **11 September 2026** — more than a year before you need a CE mark on the product itself — and it applies to **every in-scope product already on the market**, including one sold in 2019. If a vendor becomes aware that an old SCADA deployment has an actively exploited vulnerability after that date, the 24-hour clock still starts.

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
  <text x="510" y="58" fill="#e5e7eb" font-size="12" font-weight="bold" text-anchor="middle">~Q2 2027</text>
  <text x="510" y="150" fill="#e5e7eb" font-size="12" text-anchor="middle">Harmonised</text>
  <text x="510" y="166" fill="#e5e7eb" font-size="12" text-anchor="middle">standards cited</text>
  <!-- milestone 4 -->
  <circle cx="640" cy="120" r="9" fill="#f97316" stroke="#e5e7eb" stroke-width="2"/>
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
| **11 June 2026** | Chapter IV applies — conformity assessment bodies (CABs) begin notification and accreditation as **notified bodies**. Important Class I/II and Critical manufacturers should begin notified-body engagement from this point. |
| **11 September 2026** | **Vulnerability and incident reporting obligations (Article 14)** apply to **all** in-scope products, including those placed on the market years earlier. The ENISA single reporting platform is due to be operational. ([EC — reporting](https://digital-strategy.ec.europa.eu/en/policies/cra-reporting)) |
| **30 August 2026** | Standards deadline: Type A horizontal security standard and Type B vulnerability-handling standard due from CENELEC/ETSI. |
| **30 October 2026** | Standards deadline: Type C vertical/product-specific standards, covering Annex III/IV categories, due. |
| **~Q2 2027** | Expected formal OJEU citation of the first harmonised standards — including **EN IEC 62443-4-1:2018/A11:2026** and **EN IEC 62443-4-2:2019/A11:2026** — activating the presumption of conformity. |
| **11 December 2027** | The **main obligations** — essential requirements, conformity assessment, CE marking — apply in full. |

Building secure-development and vulnerability-handling processes, producing SBOMs, and arranging third-party assessment for important and critical products are multi-year programmes, not last-quarter projects. As of mid-2026, **no CRA harmonised standard has been formally cited in the EU Official Journal** — which means no manufacturer can yet invoke the presumption of conformity, and Important Class I products have, for now, no self-assessment route open to them at all.

## What counts as a "product with digital elements"

The scope is deliberately broad. Under **Article 3(1)**, a **product with digital elements** is:

> *"a software or hardware product and its remote data processing solutions, including software or hardware components being placed on the market separately."*

A product is in scope if it connects, directly or indirectly, to a device or network during normal use; contains digital elements (software or programmable hardware); and is not already covered by an EU sectoral regulation providing equivalent cybersecurity requirements. Remote data processing operated by or on behalf of the manufacturer independently triggers scope on its own.

In an industrial setting that captures a great deal:

- **PLCs, RTUs and industrial controllers** — the logic that runs the process.
- **Protocol gateways and network devices** — the translators and routers between OT and IT.
- **HMIs and engineering workstations software** — the human-facing and configuration layers.
- **Industrial IoT sensors and edge devices** — the growing population of connected endpoints.
- **Firmware and application software** running on all of the above, including standalone software sold on its own.

Some categories are carved out because they are already regulated elsewhere — national security and defence products, type-approved vehicles, and products for which a sector-specific EU regulation already sets an equal-or-higher cybersecurity bar. If your product sits at a boundary (say, machinery with a digital control system), you may be reading the CRA alongside the [Machinery Regulation](/en/machine-act).

## Who carries the obligations

The CRA follows the value chain, and the weight is not evenly spread.

| Role | Core duty under the CRA |
|---|---|
| **Manufacturer** | Substantive obligations: secure design, Annex I compliance, SBOM, vulnerability handling, support period, reporting, conformity assessment, CE marking. |
| **Importer** | Verify the manufacturer''s conformity assessment, technical documentation and CE marking; add own contact details; keep 10-year traceability records; act on non-conformity. |
| **Distributor** | Act with due care; verify CE marking and DoC accompany the product; must not make available products they know or should know are non-compliant; keep 10-year traceability records. |

> [!WARNING]
> **You can become a "manufacturer" without ever calling yourself one.** Under **Article 21**, importers and distributors assume full manufacturer obligations if they place a product on the market under their own name or trademark, or make a **substantial modification** to a product already on the market. An OEM that contracts manufacturing to a non-EU entity and sells under its own brand in the EU bears all Article 13 obligations regardless of the contract terms — contractual pass-through of liability to the ODM does not work in front of a market surveillance authority. System integrators and operators who rebrand, re-flash firmware, or significantly alter a device need to know exactly where that line sits — per product, before 2027.

That "substantial modification" trigger is the one that surprises OT teams. A modification is "substantial" if it either affects compliance with Annex I, or changes the product''s intended purpose (**Article 3(30)**). Routine maintenance, like-for-like repairs and security patches are **not** substantial modifications by default (**Recital 42**) — but a full SCADA platform upgrade, or adding IIoT connectivity to a previously non-networked device, typically is. A machine builder who integrates a third-party controller and ships the line under their own name, or an integrator who performs a post-2027 refit that crosses this line, inherits the full manufacturer stack — including the 5-year minimum support period, counted from the date of the modification.

## Product classes and conformity assessment

Not all products are treated alike. The CRA sorts PDEs by criticality, and the class determines how rigorously conformity must be demonstrated. Classification is fixed by **Commission Implementing Regulation (EU) 2025/2392** (published 1 December 2025), which gives technical descriptions for the Annex III (Important) and Annex IV (Critical) categories. Classification is not a paperwork exercise — it is the decision that sets your timeline, your budget, and whether a notified body sits between you and the CE mark. ([EC — conformity assessment](https://digital-strategy.ec.europa.eu/en/policies/cra-conformity-assessment))

| Class | Examples (Annex III / IV) | Conformity route |
|---|---|---|
| **Default** | The large majority of products, listed in neither annex — consumer IoT, smart speakers, mobile apps, video games, most non-safety industrial devices. | **Self-assessment** (Module A, internal control) against the essential requirements — always permitted. |
| **Important — Class I** | Operating systems (desktop/server/mobile), browsers, password managers, VPN software, SIEM, network routers/switches, physical and virtual network interfaces, non-safety-critical IACS products. | Self-assessment (Module A) **only if** a harmonised standard is fully applied; otherwise **Module B+C or H** via a notified body. |
| **Important — Class II** | Firewalls, IDS/IPS, hypervisors, HSMs, tamper-resistant microprocessors, safety-critical IACS, industrial robots. | **Always Module B+C or Module H** via a notified body — self-assessment is legally unavailable, full stop. |
| **Critical** | Smart cards, HSMs, smart meter gateways in critical infrastructure, certain chip-level security products (Annex IV). | Mandatory **European cybersecurity certification**; where no scheme exists yet, Important Class II rules apply. |

> **OXOT''s read on this table:** many ICS components — including safety-critical IACS products — land in Important Class II, which forecloses self-assessment entirely. That single classification decision is the one most OT manufacturers underestimate: it is the difference between an internal engineering sign-off and a multi-month notified-body queue.

### Class I in practice — what "self-assess or not" actually depends on

Class I is the one class where the manufacturer has a real choice, and that choice is dictated entirely by engineering discipline, not intent.

- **Pathway A — Self-assessment (Module A, internal control).** Permitted **if and only if** the manufacturer fully applies EU-harmonised standards or common specifications (the forthcoming harmonised EN IEC 62443 profiles, once cited). Until that citation lands, this pathway is closed for OT Class I products.
- **Pathway B — Mandatory third-party assessment (Module B+C or Module H).** If a manufacturer does not fully apply a harmonised standard, they forfeit the right to self-assess and face the same third-party route as a Class II product: an independent notified body conducting an EU-type examination (Module B+C) or a full quality assurance audit of the manufacturer''s development lifecycle (Module H).

Whichever pathway applies, Class I manufacturers must produce the same evidence base to prove the product is "secure-by-design" and free of known exploitable vulnerabilities at release:

| Evidence area | What it demonstrates |
|---|---|
| Threat modelling & design-stage risk assessment | Security risk was assessed before code was written; trust boundaries and intended use cases are mapped. |
| Automated code analysis (SAST/DAST) | Source code and running application are both tested for flaws as part of the development pipeline. |
| Software composition analysis (SCA) & SBOM generation | Third-party and open-source components are continuously scanned; a machine-readable SBOM is generated and maintained for the whole support period. |
| Penetration testing & vulnerability handling | Active testing to eliminate weaknesses before launch, plus a mechanism for secure, integrity-protected update delivery when new flaws surface. |
| Deep hardware/firmware verification (physical Class I devices) | For routers, network interfaces and similar hardware, standard IT scanning is not enough — access controls, state-of-the-art cryptography for data at rest/in transit, secure boot integrity, and attack-surface reduction (disabling unused physical ports) must all be validated. |

### Class II in practice — the notified body evaluates two things

Class II products are treated as a materially higher cybersecurity risk, and self-assessment is **legally prohibited** — there is no version of this class where an internal sign-off is sufficient. To affix a CE mark, the manufacturer must go through a mandatory third-party audit by a notified body, or use an applicable European cybersecurity certification scheme at a "substantial" or "high" assurance level.

The notified body assesses the product against two categories:

**1. The assessment procedure ("how")**

- **Module B + C (EU-type examination):** the notified body conducts a rigorous examination of the product''s technical design, development and vulnerability-handling processes, and tests a physical or digital sample directly. Module C then requires the manufacturer to ensure every subsequent production unit conforms to that approved sample.
- **Module H (full quality assurance):** instead of sampling one unit, the notified body audits the manufacturer''s entire secure development lifecycle and quality management system. If the audit confirms the process inherently and consistently produces CRA-compliant output, production can proceed.

**2. The essential cybersecurity requirements ("what")**

- No known exploitable vulnerabilities at release, backed by a documented risk assessment.
- Security-by-design and by-default: minimal attack surface, strict access controls, secure out-of-the-box configuration.
- State-of-the-art cryptography for data at rest and in transit — no obsolete or home-grown algorithms.
- Hardware-level protections for devices like tamper-resistant microprocessors: hardware roots of trust, secure boot integrity, physical tamper resilience.
- Secure, largely automatic updates with a clear opt-out for professional users.
- A machine-readable SBOM (SPDX or CycloneDX) tracking all dependencies to enable rapid patching.
- A committed support period — as a rule, not shorter than 5 years.

All of this is compiled into a technical documentation file — risk assessments, architectural designs, SBOM, test reports — retained for at least 10 years or the support period, whichever is longer.

## Annex I, Part I — the product''s security properties

Annex I is where the CRA becomes concrete, and it has two parts. **Part I** governs how the product itself must behave. The overarching standard, in **point (1)**, is that products must be designed, developed and produced to ensure *"an appropriate level of cybersecurity based on the risks."* Point (2) then lists 13 specific properties implementing that standard. ([CRA annexes](https://www.cyberresilienceact.eu/annexes.html))

| Security property | What it demands in practice |
|---|---|
| **No known exploitable vulnerabilities** | Ship without known, exploitable flaws — vulnerability management before release, not after. |
| **Secure by default** | Delivered with a secure configuration out of the box; no universal default passwords; a way to reset to factory-default secure state. |
| **Security update capability** | Automatic security updates on by default, with a clear opt-out, user notification, and the ability to postpone. |
| **Access control & authentication** | Protect against unauthorised access with appropriate authentication, identity management and role-based access control; report possible unauthorised access attempts. |
| **Confidentiality** | Data at rest and in transit protected with state-of-the-art encryption — stored data, transmitted data, command-and-control traffic, credentials and keys alike. |
| **Integrity** | Protect stored/transmitted data, commands and configuration against corruption; report integrity violations. |
| **Data minimisation** | Process only data that is adequate, relevant and limited to what the product needs. |
| **Availability & resilience** | Protect essential functions; resist and recover from denial-of-service; maintain degraded-mode operation where feasible. |
| **Minimised attack surface** | Disable unnecessary services, ports and protocols by default; reduce the software footprint. |
| **Limit incident impact** | Fallback operation, graceful degradation, network segmentation, isolation of compromised components. |
| **Security logging & monitoring** | Record and monitor security-relevant events; make logs available to users; allow (but default-enable) an opt-out. |
| **Secure data deletion** | A user capability to securely and permanently delete data and configuration, especially at decommissioning. |
| **Reduce attack exposure** | The catch-all engineering obligation — secure coding, supply-chain component security, build integrity, architectural choices that shrink the exploitable surface. |

> [!NOTE]
> **Not every requirement applies to every product, but silence is not an option.** Under **Article 13(3)–(4)**, the risk assessment must state which of these 13 requirements are applicable and how they are implemented — and where one genuinely is not applicable (a product that never transmits data has no data-in-transit confidentiality obligation to build), the manufacturer must include a **clear, written justification** in the technical documentation. An undocumented "not applicable" is a compliance failure, not a shortcut.

## Annex I, Part II — vulnerability handling and the SBOM

**Part II** governs the process a manufacturer must run across the support period. This is the operational discipline behind the product''s security properties, and it applies to every manufacturer regardless of product class.

| Vulnerability-handling duty | What it means |
|---|---|
| **Identify & document components** | Know what is inside the product, including a **software bill of materials (SBOM)** covering at least top-level dependencies, in a commonly used machine-readable format. |
| **Remediate without delay** | Address and fix vulnerabilities promptly, including via **free security updates** for the support period; separate security fixes from feature releases where feasible. |
| **Regular testing** | An ongoing, scheduled programme — periodic penetration testing, automated CVE scanning against the live SBOM, and regression testing — not a single pre-release check. |
| **Public disclosure of fixes** | Once a fix is available, publish its severity, impact and remediation — comparable to CVE/CNA advisory practice. |
| **Coordinated disclosure** | Operate and publish a CVD policy, with a designated single point of contact that is easily identifiable to users. |
| **Upstream reporting** | On identifying a vulnerability in a third-party or open-source component, report it to that component''s maintainer — and share any patch developed, where appropriate. |
| **Secure distribution** | Distribute updates with integrity protection and authentication, so the update channel itself cannot become a supply-chain attack vector. |
| **Information sharing** | Provide vulnerability count, severity and handling-policy information to competent authorities on request. |

> [!NOTE]
> **Why the SBOM matters more than it looks.** Industrial products are assembled from layers of third-party and open-source components. The SBOM obligation forces manufacturers to actually know what is inside their products and to track the vulnerabilities those components carry. A stale SBOM is a compliance risk in its own right — it cannot support the 24-hour Article 14 reporting clock if you don''t know a vulnerable component is even in the product. For operators, a vendor SBOM is a direct input to your own risk picture — and a reasonable thing to demand in procurement well before 2027.

## Full obligations reference — the manufacturer''s lifecycle

Read end to end, the CRA describes a lifecycle, not a one-time gate, and it is useful to see the whole thing laid out against the articles that create it.

| Lifecycle stage | Legal basis | What must exist |
|---|---|---|
| **Classify** | Articles 6–8, Annex III/IV, Impl. Reg. 2025/2392 | Product mapped to Default / Important I / Important II / Critical — fixes the conformity route. |
| **Design & build** | Article 13(1)–(3) | Security considered through *"planning, design, development, production, delivery and maintenance"*; risk assessment documents which Annex I requirements apply and how. |
| **Vulnerability handling** | Article 13(2)–(3), Annex I Part II | SBOM pipeline, CVD policy, single point of contact, regular testing — operational before 11 September 2026. |
| **Technical documentation** | Article 31, Annex VII | Product description, risk assessment, Annex I compliance evidence, SBOM, standards applied, test reports, conformity assessment results, DoC, support-period rationale. Retained 10 years or the support period, whichever is longer. |
| **Conformity assessment** | Article 32 | Module A (self), Module B+C (notified body type-examination + production control), Module H (full QA), or European cybersecurity certification for Critical products. |
| **Declaration & marking** | Articles 28, 30, Annex V | EU Declaration of Conformity referencing Regulation (EU) 2024/2847; CE mark affixed only once the DoC exists. |
| **User information** | Article 13(18), Annex II | Manufacturer contact, CVD URL, intended purpose, known risks, DoC reference, support-period end-date, secure-use instructions — in a language users understand. |
| **Support period** | Article 13(8) | As a rule, **at least 5 years** of free security updates; shorter only where genuinely justified by expected product life. |
| **Reporting** | Article 14 | 24h early warning → 72h detailed notification → 14-day/1-month final report to ENISA + CSIRT, for actively exploited vulnerabilities and severe incidents — live from **11 September 2026**, for all in-scope products regardless of placement date. |
| **Retention** | Article 13(13) | Technical file and DoC retained 10 years from market placement, or the support period, whichever is longer. |

```svg
<svg viewBox="0 0 700 300" xmlns="http://www.w3.org/2000/svg" font-family="system-ui, sans-serif">
  <!-- top row blocks -->
  <rect x="20" y="40" width="150" height="60" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="95" y="66" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Secure design</text>
  <text x="95" y="84" fill="#94a3b8" font-size="11" text-anchor="middle">Annex I Part I</text>

  <rect x="200" y="40" width="150" height="60" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="275" y="66" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">SBOM &amp;</text>
  <text x="275" y="84" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">components</text>

  <rect x="380" y="40" width="150" height="60" rx="8" fill="none" stroke="#f97316" stroke-width="2"/>
  <text x="455" y="66" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Conformity</text>
  <text x="455" y="84" fill="#94a3b8" font-size="11" text-anchor="middle">assessment + CE</text>

  <rect x="540" y="40" width="140" height="60" rx="8" fill="#f97316" fill-opacity="0.12" stroke="#f97316" stroke-width="2"/>
  <text x="610" y="76" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">On the market</text>

  <!-- arrows top row -->
  <line x1="170" y1="70" x2="200" y2="70" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr)"/>
  <line x1="350" y1="70" x2="380" y2="70" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr)"/>
  <line x1="530" y1="70" x2="540" y2="70" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr)"/>

  <!-- down into lifecycle band -->
  <line x1="610" y1="100" x2="610" y2="160" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr)"/>

  <!-- lifecycle band -->
  <rect x="60" y="170" width="440" height="70" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
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

## The conformity assessment route by product class

The class you land in determines who signs off on the product and how long that takes to arrange. This is the decision that drives the schedule more than the engineering itself does.

```svg
<svg viewBox="0 0 700 320" xmlns="http://www.w3.org/2000/svg" font-family="system-ui, sans-serif">
  <rect x="20" y="20" width="200" height="50" rx="8" fill="none" stroke="#94a3b8" stroke-width="2"/>
  <text x="120" y="50" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Classify the product</text>

  <line x1="120" y1="70" x2="120" y2="100" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr2)"/>

  <!-- Default -->
  <rect x="20" y="100" width="150" height="60" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="95" y="124" fill="#e5e7eb" font-size="12" font-weight="bold" text-anchor="middle">Default</text>
  <text x="95" y="142" fill="#94a3b8" font-size="10" text-anchor="middle">Module A</text>
  <text x="95" y="155" fill="#94a3b8" font-size="10" text-anchor="middle">self-assessment</text>

  <!-- Class I -->
  <rect x="190" y="100" width="150" height="60" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="265" y="120" fill="#e5e7eb" font-size="12" font-weight="bold" text-anchor="middle">Important Class I</text>
  <text x="265" y="138" fill="#94a3b8" font-size="10" text-anchor="middle">Module A if standard</text>
  <text x="265" y="151" fill="#94a3b8" font-size="10" text-anchor="middle">fully applied — else B+C/H</text>

  <!-- Class II -->
  <rect x="360" y="100" width="150" height="60" rx="8" fill="none" stroke="#f97316" stroke-width="2"/>
  <text x="435" y="120" fill="#e5e7eb" font-size="12" font-weight="bold" text-anchor="middle">Important Class II</text>
  <text x="435" y="138" fill="#94a3b8" font-size="10" text-anchor="middle">Always Module B+C</text>
  <text x="435" y="151" fill="#94a3b8" font-size="10" text-anchor="middle">or Module H</text>

  <!-- Critical -->
  <rect x="530" y="100" width="150" height="60" rx="8" fill="#f97316" fill-opacity="0.12" stroke="#f97316" stroke-width="2"/>
  <text x="605" y="120" fill="#e5e7eb" font-size="12" font-weight="bold" text-anchor="middle">Critical</text>
  <text x="605" y="138" fill="#94a3b8" font-size="10" text-anchor="middle">European cyber</text>
  <text x="605" y="151" fill="#94a3b8" font-size="10" text-anchor="middle">certification scheme</text>

  <line x1="120" y1="70" x2="95" y2="100" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#arr2)"/>
  <line x1="120" y1="70" x2="265" y2="100" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#arr2)"/>
  <line x1="120" y1="70" x2="435" y2="100" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#arr2)"/>
  <line x1="120" y1="70" x2="605" y2="100" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#arr2)"/>

  <line x1="95" y1="160" x2="95" y2="200" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr2)"/>
  <line x1="265" y1="160" x2="265" y2="200" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr2)"/>
  <line x1="435" y1="160" x2="435" y2="200" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr2)"/>
  <line x1="605" y1="160" x2="605" y2="200" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr2)"/>

  <rect x="20" y="200" width="660" height="55" rx="8" fill="none" stroke="#94a3b8" stroke-width="1.5" stroke-dasharray="3 3"/>
  <text x="350" y="222" fill="#e5e7eb" font-size="12" font-weight="bold" text-anchor="middle">Technical file (Annex VII) + EU Declaration of Conformity (Article 28)</text>
  <text x="350" y="240" fill="#94a3b8" font-size="10" text-anchor="middle">Same documentation backbone regardless of route — only who signs it off differs</text>

  <line x1="350" y1="255" x2="350" y2="275" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr2)"/>
  <rect x="250" y="275" width="200" height="35" rx="8" fill="#f97316" fill-opacity="0.15" stroke="#f97316" stroke-width="2"/>
  <text x="350" y="297" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">CE marking affixed</text>

  <defs>
    <marker id="arr2" markerWidth="8" markerHeight="8" refX="6" refY="3" orient="auto">
      <path d="M0,0 L6,3 L0,6 Z" fill="#94a3b8"/>
    </marker>
  </defs>
</svg>
```

## The support period — a new shape for vendor relationships

One of the CRA''s most practically significant demands is the **support period**: manufacturers must provide security updates for a period appropriate to the product, and **as a rule at least five years** (shorter only where the product is expected to be in use for less time). Technical documentation and the EU declaration of conformity must be kept for at least ten years, or the support period if longer.

For industrial equipment that routinely runs for a decade or more, this reframes the commercial relationship — and creates a real procurement risk for greenfield facilities. A PLC installed in 2028 at a facility expected to operate until 2048 has a 20-year operational horizon; the CRA''s floor is only 5 years. Unless a vendor contractually commits to a longer support period, the facility will be running CRA-unsupported components for most of its operating life. Security support stops being a goodwill gesture that lapses when a product line is discontinued, and becomes a legal expectation over a defined lifetime. For buyers, the support period is a negotiating anchor: you can hold a vendor to a stated window, and you can ask what happens at end of support before you sign.

## Reporting — the 24-hour clock

The CRA introduces a sharp, staged reporting regime under **Article 14**. **Actively exploited vulnerabilities** and **severe incidents** affecting product security must be notified through a single reporting platform to the manufacturer''s national **CSIRT** and, simultaneously, **ENISA**. ([EC — reporting](https://digital-strategy.ec.europa.eu/en/policies/cra-reporting))

| Stage | Deadline | Content |
|---|---|---|
| **Early warning** | Within **24 hours** of becoming aware | First alert that an actively exploited vulnerability or severe incident exists, and which Member States the product has reached — so CSIRTs can cascade the alert to each other. |
| **Detailed notification** | Within **72 hours** | Product information, nature of the exploit and vulnerability, corrective/mitigating measures taken and available to users, sensitivity classification of the report. |
| **Final report** | **14 days** (vulnerability, after a fix is available) / **1 month** (severe incident) | Description, severity, impact, information on the malicious actor if known, and details of the security update delivered. ([CRA reporting deadlines](https://www.cyberresilienceact.eu/reporting.html)) |

> [!WARNING]
> **The 24-hour duty is retroactive in effect, even though the product is not.** Article 14 reporting applies from 11 September 2026 to *all* in-scope products, regardless of when they were placed on the market. A vendor does not get to argue "this SCADA system predates the CRA" — if they become aware of active exploitation after that date, the clock starts the same way it would for a 2028 product. Build the detection-and-disclosure pipeline first; it has to exist well before the product-conformity work is finished.

Two further operational consequences. First, user notification under **Article 14(8)** runs in parallel with the regulatory report, not after it — affected users must be told, ideally in a structured, machine-readable format, at the same time ENISA and the CSIRT are notified. Second, the reporting is single-submission: one report through the platform reaches the CSIRT and ENISA, which then propagates to other affected CSIRTs. Microenterprises and small enterprises get some relief from penalties for missing the 24-hour vulnerability deadline, but the obligation itself still applies.

> [!TIP]
> Treat CRA reporting and your [NIS2](/en/nis2) incident reporting as one detection-and-response capability, not two. The underlying muscle — spotting a severe event, deciding it is reportable, and getting a first notification out within a day — is the same. Build it once.

## Penalties — CRA and NIS2 compared

Non-compliance with the **essential requirements or the core manufacturer obligations** can attract fines of up to **€15 million or 2.5% of total worldwide annual turnover**, whichever is higher. Enforcement is by national market surveillance authorities, and fines apply **per product** — a manufacturer with several non-conformant product lines can face multiple, cumulative penalties.

| Tier | Violation | CRA ceiling (higher of) |
|---|---|---|
| **Tier 1** | Annex I essential requirements; Article 13 manufacturer obligations; Article 14 reporting obligations | **€15,000,000** or **2.5%** of worldwide annual turnover |
| **Tier 2** | Economic operator duties (Articles 18–23); Declaration of Conformity (Article 28); CE marking / technical documentation (Articles 30–31); conformity assessment (Article 32) | **€10,000,000** or **2%** of worldwide annual turnover |
| **Tier 3** | Supplying incorrect, incomplete or misleading information to a notified body or market surveillance authority | **€5,000,000** or **1%** of worldwide annual turnover |

**How this compares to NIS2:** the two regimes are structurally different, not just numerically. NIS2 caps essential-entity fines at **€10 million**, but its sharper edge is **personal liability** — it holds management bodies directly accountable for cybersecurity risk-management failures, independent of the corporate fine. The CRA has no equivalent personal-liability clause; its leverage is purely the turnover-linked fine, applied per non-conformant product. Together they close the loop from both directions: NIS2 makes an executive personally answerable for how their organisation manages risk; the CRA makes the products that organisation buys or builds carry an enforceable cybersecurity floor.

As with NIS2 and the [AI Act](/en/ai-act), the turnover linkage is deliberate: product security is now a board-level commercial risk, not a line item that lives and dies in engineering. ([Pillsbury — CRA requirements](https://www.pillsburylaw.com/en/news-and-insights/eu-cyber-resilience-act-requirements-products-software.html))

```cta
Not sure if you''re a manufacturer, integrator, or importer under the CRA?
Getting your role and product class wrong is the most expensive mistake in CRA readiness — and the support-period and reporting clocks are already running. We map it before they run out.
Scope my CRA obligations :: /en/contact
```

## Product or system? The scoping question that changes everything

Before a single Annex I control is chosen, one deceptively simple question decides the entire compliance path: **what, exactly, is your "product"?** The CRA answers it in **Article 3(1)** — a product with digital elements is *"a software or hardware product and its remote data processing solutions, including software or hardware components being placed on the market separately."* ([EUR-Lex, official text](https://eur-lex.europa.eu/eli/reg/2024/2847/oj/eng))

The consequence is easy to miss and expensive to get wrong. The CRA applies to **each individual product unit placed on the EU market** — not to a system, an installation, or a configured solution. This is the fundamental architectural break with [IEC 62443](/en/iec-62443), which reasons at the level of a *System Under Consideration* built from zones and conduits. Two manufacturers shipping the same hardware can therefore face completely different obligations depending on how they place it on the market:

- If a packaged automation solution with four internal zones is placed on the market as **one integrated product**, the CRA treats it as a single product with a single Declaration of Conformity under **Article 28**.
- If each zone-device is placed on the market **separately**, each becomes an **independently assessed product** — its own risk assessment, its own technical file, potentially its own conformity route.

> [!IMPORTANT]
> This product-versus-system scoping is the single most common point of confusion for OT and ICS manufacturers, most of whom think natively in *systems*, not *products*. Getting it wrong cascades: it determines the conformity assessment pathway, whether a Notified Body is mandatory, and the entire scope of the technical file. It is the first thing to settle — before design, before controls, before any 62443 mapping.

## How the CRA calibrates risk — the "where applicable" mechanism

The CRA never uses Security Levels. Its calibration mechanism is the **cybersecurity risk assessment** mandated by **Article 13(2) and (3)** — and understanding it is the difference between rigorous, defensible compliance and either over-engineering or non-compliance.

**Article 13(2)** requires manufacturers to *"undertake an assessment of the cybersecurity risks associated with a product with digital elements and take the outcome of that assessment into account during the planning, design, development, production, delivery and maintenance phases."* **Article 13(3)** then ties that assessment directly to the controls: it must *"indicate whether and, if so in what manner, the security requirements set out in Part I, point (2), of Annex I are applicable."* ([EUR-Lex](https://eur-lex.europa.eu/eli/reg/2024/2847/oj/eng))

The proportionality gateway sits in two phrases. **Annex I, Part I, point (1)** sets the overarching standard — products must ensure *"an appropriate level of cybersecurity based on the risks."* The word **"appropriate"** is the legal hook for proportionality. **Annex I, Part I, point (2)** then lists the specific technical properties (access control, confidentiality, integrity, availability, minimal attack surface, and more) that apply *"on the basis of the risk assessment referred to in Article 13(2) and **where applicable**."*

That phrase — **"where applicable"**, reinforced by **Recital 55** — is the whole game. Where a specific essential requirement is not relevant to a product''s intended purpose or risk profile, the manufacturer need not implement it, **provided** a clear written justification is recorded in the technical documentation under **Article 13(4)**. The official multi-stakeholder guidance (ORCWG) is explicit that manufacturers *"determine on the basis of the cybersecurity risk assessment which of those requirements are relevant"* and must document any non-application.

```keyfacts
Scope unit :: The individual product (Art. 3(1)) — not the system
Risk mechanism :: Cybersecurity risk assessment (Art. 13(2)–(3))
Proportionality hook :: "appropriate" + "where applicable" (Annex I, Part I)
Non-application :: Allowed with written justification (Art. 13(4), Recital 55)
Equivalent to :: IEC 62443 SL-T differentiation — expressed as outcomes
```

The commercial stakes are real. A manufacturer who can write a rigorous, defensible Article 13(2)–(3) assessment and map it precisely to Annex I avoids over-implementing controls that its risk profile does not warrant. A manufacturer who cannot faces the opposite: either the penalties of Article 64, or the dead-weight cost of engineering every product to a maximal specification it never needed.

## Mapping IEC 62443 Security Levels to CRA conformity

Most in-scope OT manufacturers already hold [IEC 62443](/en/iec-62443) certifications — and discover that **none of those certificates automatically satisfy the CRA.** The two frameworks are architected around different units of conformity, so the mapping has to be built deliberately. This is where OXOT''s analysis goes beyond the general compliance literature.

| Dimension | IEC 62443 | Cyber Resilience Act |
|---|---|---|
| Unit of conformity | System Under Consideration; zones & conduits | The individual product placed on the market |
| Risk calibration | Security Levels SL-1 → SL-4 per zone | Risk assessment (Art. 13(2)–(3)), "where applicable" |
| Compliance evidence | SL-C certificate per component; SL-A per zone | Technical file (Annex VII) + Declaration of Conformity |
| Third-party assessment | Optional (62443-4-2 SL-C certification) | Mandatory for Important Class I (absent a harmonised standard) and Class II |
| Target/Capability/Achieved | SL-T / SL-C / SL-A are distinct | Collapsed into one documented, risk-justified outcome |

The bridge is conceptual as much as technical: **SL-T** (the target a zone requires) becomes the *input* to the Article 13(2) risk assessment; **SL-C** (a component''s certified capability) becomes *evidence* toward Annex I, Part II component requirements; and **SL-A** (what a zone actually achieves) has no direct CRA analogue, because the CRA stops at the product boundary and does not certify the operator''s installed system. A 62443-4-2 SL-C certificate is powerful supporting evidence in a CRA technical file — but it is not a substitute for the Annex I traceability the CRA demands.

## The harmonised-standards gap — and the Notified Body queue

The CRA''s conformity routes lean heavily on **harmonised standards**: cite one in the Official Journal of the EU, and a manufacturer of an Important Class I product can self-assess against it with a presumption of conformity. The problem in 2026–2027 is timing. As of mid-2026, **no harmonised standard for the CRA has yet been cited in the Official Journal**, and the expected candidate — **EN IEC 62443-4-2 with an A11 CRA-alignment annex** — is not anticipated until roughly **Q2 2027**, only months before the main obligations bite on **11 December 2027**.

> [!WARNING]
> Until a harmonised standard is cited, **every Important Class I product without one — and every Class II product regardless — must go through a Notified Body** for conformity assessment. Notified Body capacity for the CRA is finite and being built now. Manufacturers who wait for the standard risk arriving at a queue that has already formed, with the deadline fixed and immovable.

This is the practical reason CRA readiness cannot be deferred to 2027: the reporting machinery is already due in **September 2026**, and the conformity route for higher-class products runs through third-party bodies whose capacity is scarce well before the deadline.

## The scale of the deadline — 100,000 manufacturers, one date

The CRA is not a niche obligation. The European Commission''s own impact assessment identifies on the order of **100,000–110,000 economic operators** placing products with digital elements on the EU market — the overwhelming majority of whom must reach conformity by the **same 11 December 2027 date**. Layered on top is the reporting duty from **11 September 2026** covering **every in-scope product already on the market**, including long-lived industrial equipment sold years ago.

For OT specifically, that convergence is unusually sharp: industrial products are long-lived, assembled from deep supply chains, and frequently sit inside safety-related functions where the [Machinery Regulation](/en/machine-act) and, for AI-driven components, the [AI Act](/en/ai-act) apply simultaneously. The manufacturers who treat the CRA as one more standalone checklist will meet it late and expensively. The ones who fold it into a single, risk-based product-security programme — anchored in the 62443 work most already have — meet it once.

## OXOT''s CRA ↔ IEC 62443 alignment methodology

This is where OXOT''s own analysis goes further than the general compliance literature. IEC 62443''s zone-differentiated Security Level (SL) framework does **not** map one-to-one onto the CRA — the two regimes are architected around different units. But the CRA''s own risk-based proportionality mechanism produces a functionally equivalent outcome, and OXOT has built a repeatable methodology for translating between them.

### Why the two frameworks don''t line up by default

| | IEC 62443 | CRA |
|---|---|---|
| **Unit of assessment** | System Under Consideration (SuC) — zones and conduits | The individual product placed on the EU market (Article 3(1)) |
| **Risk calibration** | Security Levels, SL-1 to SL-4, assigned per zone | Article 13(2)–(3) risk assessment, applied "where applicable" per Annex I requirement |
| **Compliance evidence** | SL-C certificate per component; SL-A per zone post-deployment | Technical file under Annex VII + EU Declaration of Conformity |
| **Third-party assessment** | Optional (IEC 62443-4-2 SL-C certification) | Mandatory for Important Class I without a harmonised standard, and always for Class II |
| **Harmonised standard status** | N/A | EN IEC 62443-4-1/A11:2026 and -4-2/A11:2026 not yet cited in the OJEU (expected ~Q2 2027) |

If your "product" under the CRA is a complete integrated system with four zones, the CRA treats it as **one product** with **one Declaration of Conformity**. If each zone-device is separately placed on the market, each is independently assessed. Deciding which of those two you actually are is, in OXOT''s experience, the single most common point of confusion for OT manufacturers — most of whom think in systems, not products — and it is the first question our methodology answers.

### The proportionality bridge: SL-T as the CRA''s risk-assessment input

The CRA does not use Security Levels. Its calibration mechanism is the Article 13(2)–(3) risk assessment, gated by the word **"appropriate"** in Annex I, Part I, point (1) — *"an appropriate level of cybersecurity based on the risks"* — and operationalised through the **"where applicable"** language in point (2).

OXOT''s core finding: **an IEC 62443-3-2 zone/conduit risk assessment, which produces zone-specific SL-T values, is a fully legitimate methodology for satisfying the CRA''s Article 13(2)–(3) risk assessment requirement.** A component at SL-C = 2 in a genuinely low-risk zone (SL-T = 2) is not an under-implementation — it is the correct, defensible CRA baseline for that zone, provided the risk assessment documents why. The higher-SL Requirement Enhancements that a Zone 1 or Zone 4 component would need are legitimately marked "not applicable" for the Zone 3 component — but only with a written, risk-based justification under **Article 13(4)**. Undocumented non-applicability is not a shortcut; it is a compliance failure waiting to be found in an audit.

> [!IMPORTANT]
> **The caveat that breaks most self-assessments:** IEC 62443 permits a zone''s achieved security (SL-A) to meet its target (SL-T) through **compensating controls** — a firewall, an IDPS, a network policy — even where an individual component''s capability (SL-C) is lower. The CRA''s product-level assessment evaluates the **integrated** security posture, not isolated component specs. If a component sits at SL-C = 2 in a zone with SL-T = 3, the technical file must explicitly document *how* the compensating controls raise that zone''s SL-A to 3 — a compensating-control claim with no documentation is a CRA non-conformity, not a technicality.

### FR-to-Annex-I mapping — the traceability matrix a notified body expects

The seven IEC 62443-4-2 Foundational Requirements (FRs) — each built from stacked, cumulative Component Requirements (CRs) and Requirement Enhancements (REs) across SL-1 to SL-4 — map directly to specific CRA Annex I, Part I, point (2) sub-requirements. This mapping is the traceability matrix a notified body will expect to see in a Class I or II technical file, and it is the backbone of OXOT''s Phase 1 assessment deliverable.

| CRA Annex I (2) requirement | Primary IEC 62443 FR | What SL-2 typically provides | What SL-3 adds |
|---|---|---|---|
| **(b)** Protection from unauthorised access | FR1 Identification & Authentication Control, FR2 Use Control | Unique accounts, RBAC, PKI for inter-component auth | MFA for all humans, per-user ACLs, hardware authenticators |
| **(c)** Confidentiality of data | FR4 Data Confidentiality | AES-128+ in transit, secure deletion | At-rest encryption with hardware key management |
| **(d)** Integrity of data and programs | FR3 System Integrity | TLS, code-signing for updates, defined error states | Hardware root of trust, secure boot, measured launch |
| **(e)** Minimisation / restricted data flow | FR5 Restricted Data Flow | Logical segmentation, zone-boundary filtering | Physical segmentation, deep packet inspection for OT protocols (Modbus, OPC UA, DNP3) |
| **(f)** Availability of essential functions | FR7 Resource Availability | Basic DoS protection, resource limits | Application-layer DoS resistance, graceful degradation |
| **(h)** Limiting attack surfaces | FR5 (RDF), FR3 (SI) | Zone boundary filtering | Least functionality, deny-by-default |
| **(j)** Security event logging and monitoring | FR6 Timely Response to Events | Accessible audit logs, real-time detection | SIEM export (Syslog/CEF/LEEF), anomaly detection, tamper-evident logs |

The SL-2 → SL-3 escalation on FR1 — adding multi-factor authentication and hardware authenticators — is, in OXOT''s experience delivering these assessments, the single most common gap finding for OT components moving from a low-risk to a high-risk zone classification.

### The synergistic method, in five steps

OXOT''s methodology treats IEC 62443 not as a substitute for CRA conformity, but as the engineering content that fills the CRA''s deliberately outcome-based requirements:

1. **Scope the "product."** Determine what constitutes a single product under Article 3(1) — a full system with one Declaration of Conformity, or separately placed zone-devices each requiring independent assessment.
2. **Run the zone/conduit risk assessment (IEC 62443-3-2).** Produce SL-T values per zone, with documented threat-actor characterisation per IEC 62443-1-1. This *is* the CRA Article 13(2) risk assessment — not a parallel exercise.
3. **Map FR/CR/RE depth to Annex I, per zone.** For each Annex I point (2) sub-requirement, record which FR/CR/RE combination implements it, at what SL depth, in each zone.
4. **Document non-applicability and compensating controls.** Every Requirement Enhancement not implemented gets an Article 13(4) justification; every SL-C < SL-T gap gets a compensating-control demonstration that the zone still reaches SL-A ≥ SL-T.
5. **Assemble the Annex VII technical file.** Risk assessment, Annex I compliance matrix (with FR/CR/RE traceability), SBOM, standards referenced (citing IEC 62443-4-1/4-2 as "other relevant technical specification" under Annex VII §5 until formal harmonisation), and the conformity assessment pathway — Module A, B+C, or H as classification dictates.

**Until EN IEC 62443-4-1/A11:2026 and -4-2/A11:2026 are formally cited in the OJEU**, IEC 62443 certificates support the technical argument in the file but do not, on their own, confer a presumption of conformity. Manufacturers who have already built to 62443 have done most of the underlying engineering work — the gap OXOT closes is the documented, article-referenced translation from SL-C certificates to an Annex I compliance matrix a notified body or market surveillance authority will actually accept.

## The CRA synergy flow

```svg
<svg viewBox="0 0 700 380" xmlns="http://www.w3.org/2000/svg" font-family="system-ui, sans-serif">
  <rect x="30" y="20" width="290" height="60" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="175" y="46" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">IEC 62443-3-2</text>
  <text x="175" y="64" fill="#94a3b8" font-size="11" text-anchor="middle">Zone/conduit risk assessment → SL-T per zone</text>

  <rect x="380" y="20" width="290" height="60" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="525" y="46" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">CRA Article 13(2)–(3)</text>
  <text x="525" y="64" fill="#94a3b8" font-size="11" text-anchor="middle">Cybersecurity risk assessment — "where applicable"</text>

  <line x1="320" y1="50" x2="380" y2="50" stroke="#f97316" stroke-width="2.5" marker-end="url(#arr3)"/>
  <text x="350" y="40" fill="#f97316" font-size="10" text-anchor="middle">satisfies</text>

  <line x1="175" y1="80" x2="175" y2="110" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr3)"/>
  <line x1="525" y1="80" x2="525" y2="110" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr3)"/>

  <rect x="30" y="110" width="290" height="60" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="175" y="136" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">FR / CR / RE per zone</text>
  <text x="175" y="154" fill="#94a3b8" font-size="11" text-anchor="middle">SL-C achieved by each component</text>

  <rect x="380" y="110" width="290" height="60" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="525" y="136" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Annex I, Part I point (2)</text>
  <text x="525" y="154" fill="#94a3b8" font-size="11" text-anchor="middle">13 essential requirements, mapped per zone</text>

  <line x1="320" y1="140" x2="380" y2="140" stroke="#f97316" stroke-width="2.5" marker-end="url(#arr3)"/>
  <text x="350" y="130" fill="#f97316" font-size="10" text-anchor="middle">maps to</text>

  <line x1="175" y1="170" x2="175" y2="200" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr3)"/>
  <line x1="525" y1="170" x2="525" y2="200" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr3)"/>

  <rect x="30" y="200" width="290" height="60" rx="8" fill="none" stroke="#94a3b8" stroke-width="2" stroke-dasharray="3 3"/>
  <text x="175" y="226" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Gaps: SL-C &lt; SL-T</text>
  <text x="175" y="244" fill="#94a3b8" font-size="11" text-anchor="middle">Compensating controls documented</text>

  <rect x="380" y="200" width="290" height="60" rx="8" fill="none" stroke="#94a3b8" stroke-width="2" stroke-dasharray="3 3"/>
  <text x="525" y="226" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Non-applicable REs</text>
  <text x="525" y="244" fill="#94a3b8" font-size="11" text-anchor="middle">Article 13(4) written justification</text>

  <line x1="320" y1="230" x2="380" y2="230" stroke="#f97316" stroke-width="2.5" marker-end="url(#arr3)"/>

  <line x1="175" y1="260" x2="350" y2="300" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr3)"/>
  <line x1="525" y1="260" x2="350" y2="300" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr3)"/>

  <rect x="200" y="300" width="300" height="60" rx="8" fill="#f97316" fill-opacity="0.15" stroke="#f97316" stroke-width="2"/>
  <text x="350" y="326" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Annex VII technical file</text>
  <text x="350" y="344" fill="#94a3b8" font-size="11" text-anchor="middle">Traceability matrix a notified body will expect</text>

  <defs>
    <marker id="arr3" markerWidth="8" markerHeight="8" refX="6" refY="3" orient="auto">
      <path d="M0,0 L6,3 L0,6 Z" fill="#94a3b8"/>
    </marker>
  </defs>
</svg>
```

## The CRA and OT — two sides of the same coin

The CRA and NIS2 are complementary halves of one strategy. **[NIS2](/en/nis2)** obliges operators to manage the risk of the systems they run; the CRA obliges manufacturers to make those systems securable in the first place. An operator''s NIS2 supply-chain duty (Article 21) becomes far easier to discharge when the products in the chain are CRA-compliant — arriving with SBOMs, security updates and a support commitment instead of a shrug.

For operators bringing greenfield facilities online in 2028 and beyond, procurement specifications should now name the CRA explicitly: CE marking reference, DoC reference number, support-period end-date, SBOM delivery format (SPDX or CycloneDX), and the vendor''s CVD policy URL. For post-2027 refits and retrofits of existing plant, the operative question is whether the change constitutes a **substantial modification** — like-for-like replacement and security patching generally do not trigger full CRA compliance; adding new digital capability, or a platform-level SCADA upgrade, generally does.

**[IEC 62443](/en/iec-62443)** remains the natural engineering bridge for OT vendors, and **[TS 50701](/en/ts-50701)** extends the same discipline into rail. Where the CRA is legally binding but standard-agnostic, 62443 supplies the concrete engineering content — a pairing that also travels well across the broader [frameworks](/en/frameworks) landscape.

## OXOT''s CRA Readiness offering

```carousel
CRA Readiness Assessment (Annex A)
A structured gap assessment against the CRA''s essential requirements, scoped per product. We classify each product against Annex III/IV and Commission Implementing Regulation 2025/2392, determine the conformity route it actually needs, and produce a prioritised gap list against Annex I Part I and Part II — not a pass/fail, but a concrete list of what has to change before a Declaration of Conformity is defensible.
---
CRA Preparation Service
Where the assessment finds gaps, this is the delivery arm: building the vulnerability-handling machine (SBOM pipeline, CVD policy, single point of contact, testing cadence), compiling the Annex VII technical file, and preparing the product for whichever conformity route applies — self-assessment evidence for Default and harmonised-standard Class I, or a notified-body-ready dossier for Class I without a standard, Class II, and Critical products.
---
Statutes 2-Pager companion
A concise, product-specific reference mapping your product category directly to its governing CRA statutes — classification tier, applicable Annex I requirements, conformity route, and the specific articles a market surveillance authority will cite. Built to sit next to the technical file as a quick-reference companion for engineering and legal teams alike.
---
CRA ↔ IEC 62443 harmonisation method
Our core differentiator: the FR/CR/RE-to-Annex-I traceability matrix, applied zone by zone. For manufacturers already built to IEC 62443, this is the fastest route to a CRA-defensible technical file — translating existing SL-C certificates and zone risk assessments into the documented, Article 13(4)-compliant justifications a notified body or market surveillance authority will actually accept.
```

## The manufacturer''s readiness journey

Getting to CRA conformity is a sequence, not a switch. The five stages below track how most OT product teams will move from "aware of the deadline" to "CE mark defensible."

```carousel
Stage 1 — Scope and classify
Inventory every product with digital elements you place on the EU market. For each, decide the class: default, important Class I/II, or critical. The class fixes your conformity route and therefore your timeline. This is also where you find the products where you have quietly become the "manufacturer" through rebranding or substantial modification.
---
Stage 2 — Gap-assess against Annex I
Measure each product against Annex I Part I (security properties) and Part II (vulnerability handling). Teams already aligned to IEC 62443-4-1/4-2 will find much of this maps across — but the mapping has to be documented per requirement, not assumed. The output is a prioritised gap list, not a pass/fail — most products need work in a handful of specific areas rather than a rebuild.
---
Stage 3 — Build the vulnerability-handling machine
Stand up the SBOM pipeline, coordinated disclosure policy, reporting contact, testing cadence, and secure update mechanism. This is the part that has to be live by 11 September 2026 for reporting, so it leads the schedule — ahead of the product-conformity work itself.
---
Stage 4 — Conformity assessment and CE
Run the applicable procedure: self-assessment for default and (with harmonised standards) Class I, or a notified body for Class II and critical. Assemble technical documentation, issue the EU declaration of conformity, and affix the CE marking. Notified-body capacity is finite, and lead times of 4–10 months are common — book early.
---
Stage 5 — Operate across the support period
Sustain updates, monitoring and disclosure for the support period — as a rule at least five years. Keep technical documentation for ten years. Feed field findings back into design. Conformity is a state you maintain, not a certificate you file and forget.
```

## What it means for your role

**If you manufacture, integrate or rebrand industrial products**, the CRA is a direct compliance obligation with a hard 2027 deadline and a 2026 reporting waypoint. Classify the portfolio, build secure-development and vulnerability-handling processes, produce SBOMs, commit to a support period, and — for important and critical products — line up conformity assessment while notified-body slots exist.

**If you are an operator or buyer**, the CRA is leverage. From 2027 the products you buy must meet the essential requirements; before then, you can already write CRA-aligned expectations — an SBOM, free security updates, a stated support window, a disclosure contact — into procurement and tender criteria. The Act hands buyers a vocabulary they never had, and it should shape how you plan greenfield builds and post-2027 refits alike.

**If you sit on the board of a manufacturer**, the CRA adds another turnover-linked penalty regime and turns product security into a governance matter with a defined runway. The question to ask management is not "are we compliant?" but "which products are on which conformity route, and what is the critical path to 2027?"

## How OXOT helps

OXOT works both sides of the CRA. For **operators**, we fold CRA-aligned requirements into procurement and into the supply-chain dimension of your NIS2 and OT security programmes, and our **[Cyber Digital Twin](/en/cyber-digital-twin)** gives you a structured place to hold vendor SBOMs and component risk so a new CVE in a shared library is a lookup, not a fire drill. For **manufacturers and integrators**, we translate Annex I into an engineering programme aligned to [IEC 62443](/en/iec-62443)-4-1/4-2 — using our own FR/CR/RE-to-Annex-I traceability method to turn the regulation into a concrete, evidenced path to conformity rather than a compliance scramble.

*OXOT''s CRA Readiness Assessment, Preparation Service, and Statutes 2-Pager are available as standalone engagements or as a combined programme — reach out to scope your product portfolio.*

## Frequently asked questions

**Does the CRA apply to software as well as hardware?**
Yes. Standalone software is a product with digital elements. Firmware and application software are both in scope, subject to the sectoral carve-outs (certain medical, automotive and aviation products regulated elsewhere).

**We integrate third-party controllers into our machines. Are we a manufacturer under the CRA?**
Possibly. If you place the integrated product on the market under your own name, or substantially modify components, you can take on manufacturer obligations. Map your role per product before 2027 — and watch the "substantial modification" line closely; routine maintenance and like-for-like repairs generally do not trigger it, but adding new digital capability or a platform-level upgrade generally does.

**Is an SBOM really mandatory?**
Annex I Part II requires manufacturers to identify and document components, including producing a software bill of materials, as part of vulnerability handling. Treat it as a core deliverable, not an optional extra — and treat it as a living document, since a stale SBOM cannot support the 24-hour reporting clock.

**When exactly do we have to start reporting?**
The Article 14 reporting obligations apply from **11 September 2026** — earlier than the main obligations, and to products already on the market, not just new ones. An actively exploited vulnerability or severe incident triggers a 24-hour early warning, a 72-hour notification, and a final report (14 days for a vulnerability once fixed, one month for a severe incident).

**How long must we support a product?**
As a rule at least five years, or the product''s expected time in use if shorter. Retain technical documentation and the declaration of conformity for at least ten years, or the support period if longer. For long-life industrial equipment, negotiate a longer commitment explicitly — the CRA sets a floor, not a ceiling.

**Does our existing IEC 62443 SL-C certificate satisfy the CRA?**
Not automatically, and not yet formally. Until EN IEC 62443-4-1/A11:2026 and -4-2/A11:2026 are cited in the EU Official Journal (expected ~Q2 2027), 62443 certification supports your technical argument as "other relevant technical specification" but does not confer a presumption of conformity. It does, however, supply most of the engineering evidence a notified body will want — provided it is mapped to specific Annex I requirements rather than cited in general terms.

**How does the CRA relate to the AI Act, NIS2 and the Machinery Regulation?**
The **[AI Act](/en/ai-act)** governs AI systems, the CRA governs products with digital elements, **[NIS2](/en/nis2)** governs operators, and the **[Machinery Regulation](/en/machine-act)** governs machinery safety including digital control. A connected industrial machine with an AI safety component could engage all four — which is exactly why a single, coherent OT security programme beats four disconnected compliance efforts.

## OXOT CRA Readiness resources

Practical materials from OXOT''s CRA Readiness programme:

- **[CRA Readiness — Annex A sales sheet (PDF)](/media/OXOT-CRA-Readiness-Annex-A.pdf)** — the assessment scope, deliverables and how the readiness engagement maps to CRA obligations.

Watch the CRA Readiness overview:

```html
<video controls preload="metadata" poster="" style="width:100%;border:1px solid rgba(148,163,184,0.35);border-radius:12px;background:#0b1220">
  <source src="/media/OXOT-CRA-Readiness.mp4" type="video/mp4" />
  Your browser does not support the video tag. <a href="/media/OXOT-CRA-Readiness.mp4">Download the video</a>.
</video>
```

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
- CENELEC TC65X WG3, "EN IEC 62443 to CRA" webinar — [cencenelec.eu](https://www.cencenelec.eu/news-events/events/2025/2025-09-09-en-iec-62443-to-cra/)
- ENISA, "CRA Practical Insights" — [enisa.europa.eu](https://www.enisa.europa.eu/sites/default/files/2025-12/session%203-1%20-%20reusch%20law%20-%20cra%20practical%20insights.pdf)
- ORCWG, CRA Official FAQ — [cra.orcwg.org](https://cra.orcwg.org/faq/official/faq_4-1-3/)
- CRA Penalties and Sanctions — [eu-cyber-laws.com](https://eu-cyber-laws.com/cra/penalties/)
- OXOT internal analysis: CRA Obligations Reference, CRA Class I/II Products, CRA and NIS2 Penalties, CRA × IEC 62443 Alignment Reference (OXOT B.V. internal strategic reference material, 2026)

*This page is general information about EU law, not legal advice. Confirm how the CRA applies to your products and role against the Regulation and, where needed, qualified counsel. The CRA↔IEC 62443 alignment analysis reflects OXOT''s own methodology and interpretation as of mid-2026; formal harmonised-standard citation may refine specific mappings.*

## Go deeper on the CRA

This overview is the field guide. For exhaustive detail, OXOT maintains two companion references:

- **[CRA — Complete Technical Reference](/en/cra-technical-reference)** — the full clause-by-clause map: regulation structure (8 chapters, 71 articles, 8 annexes), the three-tier product classification, every Annex I essential requirement, and the compliance timeline.
- **[CRA — CE Marking Pathways & Conformity Assessment](/en/cra-ce-marking-pathways)** — how you actually demonstrate conformity: Modules A / B+C / H, the EUCC route, notified-body engagement, the Annex VII technical file and the Annex V Declaration of Conformity, with templates and timelines.', true, 'Cyber Resilience Act (CRA) for OT & Products with Digital Elements | OXOT', 'The EU Cyber Resilience Act (Regulation (EU) 2024/2847) explained for OT — scope, product classes, Annex I security & vulnerability-handling requirements, SBOM, 24-hour reporting, ~5-year support periods, the 2024→2027 timeline, penalties, and OXOT''s IEC 62443 alignment methodology.', 'Security-by-design becomes a legal condition of market access. A field guide to CRA scope, product classes, Annex I, SBOM, 24-hour reporting, support periods, penalties, and OXOT''s own CRA↔IEC 62443 alignment methodology for OT manufacturers and buyers.', NULL, 'page', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('cra-technical-reference', 'en', 'CRA — Complete Technical Reference', '[Frameworks](/en/frameworks) › [Cyber Resilience Act](/en/cra) › Complete Technical Reference

> **In-depth reference.** For the plain-language overview, start with the [Cyber Resilience Act field guide](/en/cra). For the CE-marking / conformity-assessment process, see [CRA CE Marking Pathways](/en/cra-ce-marking-pathways). This page maps the full regulation — every chapter, article class and annex.

***
## Executive Overview
The Cyber Resilience Act (CRA), formally Regulation (EU) 2024/2847, is the EU''s first horizontal cybersecurity regulation applying mandatory, binding requirements to virtually all hardware and software products sold on the EU market. Unlike sector-specific rules (NIS2, MDR, GPSR), the CRA operates as a **product law** framework — extending the CE-marking architecture into cybersecurity — and applies from the silicon supply chain through to the end-user. It entered into force on **10 December 2024** and reaches full applicability on **11 December 2027**, with phased obligations activating earlier.

For OT and critical-infrastructure environments, the CRA is directly relevant: products in scope include OT devices, IoT gateways, SCADA components, smart meter gateways, network infrastructure, and any "product with digital elements" (PDE) in the critical infrastructure supply chain.

***
## Part I: Introduction and Legislative Context
### What the CRA Is and Why It Was Created
The CRA addresses a market failure: manufacturers have historically had little commercial incentive to invest in cybersecurity, and buyers have had no reliable way to assess the security of connected products. The regulation imposes baseline security obligations at manufacture, not after deployment. Its core design principles are:

- **Security by design and secure by default** — products must be designed, developed, and produced with cybersecurity built in
- **Lifecycle security** — obligations run for the duration of a product''s support period, not just at point of sale
- **Supply-chain transparency** — mandatory SBOM requirements tie product security to component-level accountability
- **Harmonised single market access** — one CE marking scheme replaces a patchwork of national rules
### Legislative History
| Milestone | Date |
|-----------|------|
| Commission proposal published | September 2022 |
| European Parliament approval | March 2024 |
| Council adoption | October 2024 |
| Published in EU Official Journal | 20 November 2024 |
| Entry into force | 10 December 2024 |
| Chapter IV (CABs notification) applies | 11 June 2026 |
| Reporting obligations (Art. 14) apply | 11 September 2026 |
| Full applicability | 11 December 2027 |
| Existing type-examination certs valid until | 11 June 2028 |

The Commission has already adopted two supplementary acts: Delegated Regulation (EU) 2025/1535 (motor vehicle product exclusion) and Implementing Regulation (EU) 2025/2392 (technical descriptions of important/critical product categories).

***
## Part II: Scope
### What Is Covered
The CRA applies to any **product with digital elements (PDE)** — defined as "a software or hardware product and its remote data processing solutions, including software or hardware components being placed on the market separately" — where the intended purpose or reasonably foreseeable use includes a **direct or indirect logical or physical data connection** to a device or network.

In practice, this captures:
- Connected hardware: smartphones, laptops, smart home devices, industrial controllers, routers, firewalls, gateways, microprocessors, smart meters
- Software products: operating systems, applications, firmware, mobile apps, games
- Remote data processing tightly coupled to the product''s function
- Components placed on the market separately (e.g., a microcontroller sold independently)

The trigger test is **connectivity in intended normal use** — not theoretical capability. A factory-only debug port does not trigger CRA; an end-user-accessible USB-C interface does.
### What Is Excluded
| Excluded Category | Reason / Legal Basis |
|-------------------|----------------------|
| Non-commercial free and open-source software (FOSS) | Not "made available on the market" per Recital 18 |
| Products exclusively for national security / military | Sector carve-out |
| Products already covered by dedicated EU sector regulations (medical devices, aviation, automotive) | Lex specialis |
| Products not connected to devices or networks in normal use | Outside PDE definition |
| Products not placed on the market (internal use, prototypes at trade fairs) | Outside commercial supply |

Open-source **stewards** (legal entities that sustain FOSS for commercial activity) face a lighter obligation set under Article 24, but are not fully exempt.
### Relationship to Other EU Regulation
The CRA explicitly does **not** replace NIS2 (which governs operators, not products), GDPR (personal data protection), the AI Act (AI system requirements), MDR/IVDR (medical devices), or the Radio Equipment Directive (RED). Where overlap exists, the more specific sectoral rule takes precedence for those specific obligations; CRA cybersecurity requirements fill remaining gaps.

***
## Part III: Regulation Structure — 8 Chapters, 71 Articles, 8 Annexes
### Chapter Map
| Chapter | Articles | Subject |
|---------|----------|---------|
| **I – General Provisions** | 1–12 | Scope, definitions, product classification, relationship to other law |
| **II – Obligations of Economic Operators** | 13–26 | Manufacturer, importer, distributor, FOSS steward obligations |
| **III – Conformity** | 27–34 | Standards, CE marking, DoC, technical documentation, conformity assessment |
| **IV – Notification of CABs** | 35–51 | Notified body designation, requirements, operational rules |
| **V – Market Surveillance & Enforcement** | 52–60 | MSA powers, national/Union procedures, sweeps, ADCO |
| **VI – Delegated Powers** | 61–62 | Commission''s delegated/implementing act authority |
| **VII – Confidentiality & Penalties** | 63–65 | Information protection, fines, representative actions |
| **VIII – Transitional & Final Provisions** | 66–71 | Amendments, transitional rules, evaluation, entry into force |
### Key Articles at a Glance
| Article | Subject | Importance |
|---------|---------|-----------|
| Art. 2 | Scope | Defines which products and situations are covered |
| Art. 3 | Definitions | "PDE", "manufacturer", "substantial modification", "support period" |
| Art. 6 | Requirements for PDEs | Gateway to Annex I essential requirements |
| Art. 7 | Important products | Defines Class I and Class II; links to Annex III |
| Art. 8 | Critical products | Commission may mandate EU cybersecurity certification; links to Annex IV |
| Art. 13 | Manufacturer obligations | Core obligation article — risk assessment, lifecycle, SBOM, support period, CE marking |
| Art. 14 | Reporting obligations | 24h/72h/14-day/30-day notification deadlines; applies from 11 Sep 2026 |
| Art. 32 | Conformity assessment | Module A / B+C / H routes; which products require third-party assessment |
| Art. 64 | Penalties | Tiered fines: €15M/2.5%, €10M/2%, €5M/1% |
| Art. 69 | Transitional provisions | Products already on market before Dec 2027 only caught by substantial modification |

***
## Part IV: Product Classification
### Three-Tier Classification Model
The CRA creates three product risk tiers:

```
┌─────────────────────────────────────────────────────┐
│  CRITICAL Products (Annex IV)                       │
│  Highest risk; Commission may mandate EUCC cert     │
├─────────────────────────────────────────────────────┤
│  IMPORTANT Products (Annex III)                     │
│  Class II – Third-party assessment required         │
│  Class I  – Self-assess only if harmonised std used │
├─────────────────────────────────────────────────────┤
│  DEFAULT Products (all others)                      │
│  ~90% of products; Module A self-assessment         │
└─────────────────────────────────────────────────────┘
```

Classification is based on the product''s **core functionality**, not its form factor or ancillary features.

***
### Default Products
**Definition:** All PDEs not listed in Annex III (important) or Annex IV (critical).

**Scale:** Estimated ~90% of all PDEs fall into this tier.

**Requirements:** All Annex I essential requirements apply identically to default products as to higher tiers. Classification only changes the **conformity assessment route**, not the substance of what must be achieved.

**Conformity Assessment:** Module A (self-assessment, no notified body involvement).

**Examples:** Consumer IoT devices, most commercial software, embedded sensors, smart TVs, consumer wearables not meeting Annex III criteria.

***
### Important Products – Class I (Annex III, Part I)
**Definition:** Products whose exploitation could have "significant adverse effects" due to their function or criticality in the supply chain.

**Conformity Assessment Options:**
- Module A (self-assessment) **if** harmonised standards or common specifications are applied
- Module B+C or Module H (third-party) if no harmonised standards are used
- FOSS important Class I products may self-assess if technical documentation is made public

**Annex III, Part I Product Examples:**

| Category | Examples |
|----------|---------|
| Identity & access management | IAM software/hardware, biometric readers, authentication readers |
| Browsers | Standalone and embedded browsers |
| Password managers | All password manager software/hardware |
| Anti-malware | Products that search for, remove, or quarantine malicious software |
| VPN | Products with virtual private network function |
| Network management | Network management systems |
| SIEM | Security information and event management systems |
| Boot managers | Secure boot components |
| PKI | Public key infrastructure, digital certificate issuance software |
| Network interfaces | Physical and virtual network interfaces |
| Operating systems | General-purpose OS (not already covered by higher tiers) |
| Routers / modems / switches | Internet-facing routers, modems for internet connection, switches |
| Security microprocessors | Microprocessors with security-related functionalities |
| Security microcontrollers | Microcontrollers with security-related functionalities |
| ASICs / FPGAs | With security-related functionalities |
| Smart home assistants | General purpose virtual assistants |
| Smart home security | Smart door locks, security cameras, baby monitors, alarm systems |
| Connected toys | IoT toys with social interactive or location-tracking features |
| Health wearables | Non-MDR personal health monitoring or children''s wearables |

***
### Important Products – Class II (Annex III, Part II)
**Definition:** Products with "higher level of criticality" — failure could have "far greater systemic effects," disrupting, controlling or damaging many other products.

**Conformity Assessment:** Always third-party (Module B+C or Module H) or EUCC certification. No self-assessment route except for FOSS products making their technical documentation public.

**Annex III, Part II Product Examples:**

| Category | Examples |
|----------|---------|
| Hypervisors | Hypervisors and container runtime systems supporting virtualized OS execution |
| Industrial firewalls / IDS / IPS | Firewalls, intrusion detection/prevention systems for **industrial use** |
| Tamper-resistant microprocessors | TPM-type hardened processors |
| Tamper-resistant microcontrollers | Secure element microcontrollers with tamper resistance |

> **OT/ICS Relevance (OXOT):** Industrial firewalls and intrusion detection/prevention systems used in OT environments are explicitly Class II. Any OXOT customer deploying OT-purpose IDS/IPS (e.g., Claroty, Dragos, Nozomi sensors as products) must be Class II assessed.

***
### Critical Products (Annex IV)
**Definition:** The narrowest, highest-consequence tier. The Commission may by delegated act impose **mandatory European cybersecurity certification** at assurance level "substantial" or higher under the EUCC scheme (Article 8).

**Annex IV Product List:**

| # | Category |
|---|---------|
| 1 | Hardware Devices with Security Boxes (HSMs) |
| 2 | Smart meter gateways within smart metering systems (per Directive (EU) 2019/944); other devices for advanced security purposes including secure cryptoprocessing |
| 3 | Smartcards or similar devices, including secure elements |

**Conformity Assessment:** Third-party assessment by a notified body, or mandatory EUCC certification where specified by Commission delegated act.

> **Note:** As of May 2025, zero CDU products held IEC 62443-4-2 security level registry certification — a parallel gap that applies equally to CRA critical-product certification readiness.

***
## Part V: Essential Requirements (Annex I)
All three product tiers must meet the **same substantive requirements** in Annex I. Classification only affects how conformity is assessed and documented.

Annex I is split into two Parts:

***
### Annex I – Part I: Security Properties of Products (13 Requirements)
Manufacturers must ensure products are **designed, developed, and produced** to meet these properties at point of placing on the market:

| Req. | Requirement | Technical Detail |
|------|-------------|-----------------|
| **1** | **No known exploitable vulnerabilities at release** | Products must be delivered free of exploitable vulnerabilities; risk assessment must confirm this |
| **2(a)** | **Secure by default configuration** | Default settings must be secure; option to reset to original state must be available |
| **2(b)** | **Unauthorised access protection** | Authentication, identity and access management (IAM), access control mechanisms appropriate to environment |
| **2(c)** | **Confidentiality of data** | Protection of stored, transmitted, and processed data (personal and other) via state-of-the-art cryptography at rest and in transit |
| **2(d)** | **Integrity protection** | Protect integrity of stored/transmitted data, commands, programs, configuration; report corruptions |
| **2(e)** | **Data minimisation** | Process only data adequate, relevant, and limited to what is necessary for intended use |
| **2(f)** | **Availability and resilience** | Protect availability of essential functions; resilience against and mitigation of DoS attacks |
| **2(g)** | **Minimise negative network impact** | Design to minimise the product''s own negative impact on availability of services on other devices or networks |
| **2(h)** | **Minimised attack surface** | Limit attack surfaces including external interfaces; by design and production |
| **2(i)** | **Incident impact reduction** | Exploit mitigation mechanisms and techniques to reduce impact of incidents |
| **2(j)** | **Security logging and monitoring** | Record and/or monitor relevant internal activity to detect and investigate incidents |
| **2(k)** | **Secure updates** | Update mechanism must not introduce additional vulnerabilities; updates must be authenticated and protect integrity |
| **2(l)** | **Secure factory reset / recovery** | Product must allow return to a known-good state |

> **Applicability note (Art. 13(3)):** The risk assessment determines which of requirements 2(a)–2(l) are applicable to a given product. Not all 13 apply to every product — the risk assessment drives the determination and must be documented.

***
### Annex I – Part II: Vulnerability Handling Requirements (8 Requirements)
Manufacturers must comply with these requirements both **at placement on the market** and **throughout the support period**:

| Req. | Code (BSI TR-03183) | Requirement | Detail |
|------|---------------------|-------------|--------|
| **1** | REQ_VH1 | **Identify & document vulnerabilities (SBOM)** | Maintain an SBOM in a commonly used, machine-readable format; must cover at minimum top-level dependencies; document all known vulnerabilities per component |
| **2** | REQ_VH2 | **Address & remediate vulnerabilities** | Remediate and fix exploitable vulnerabilities without delay; where technically feasible, security updates must be separate from functional updates |
| **3** | REQ_VH3 | **Regular testing** | Effective and regular security tests and reviews; minimum every 3 months or on every major change, whichever is more frequent |
| **4** | REQ_VH4 | **Publish addressed vulnerabilities** | Publicly disclose fixed vulnerabilities including description, affected product identification, impact, severity, and remediation guidance; may delay until patch is available |
| **5** | REQ_VH5 | **Coordinated Vulnerability Disclosure (CVD) policy** | Implement and enforce a CVD policy; respond to reports within 5 working days (simple acknowledgement) and 10 working days (detailed feedback) |
| **6** | REQ_VH5 | **Contact address / security.txt** | Provide a contact address for vulnerability reports; publish `security.txt` per RFC 9116 at `/.well-known/security.txt` |
| **7** | REQ_VH6 | **Secure distribution of updates** | Mechanisms to securely distribute updates (encrypted, integrity-protected); where applicable, automatic security updates |
| **8** | REQ_VH7 | **Disseminate updates without delay, free of charge** | Security updates must be free of charge (consumer default); disseminated without delay; accompanied by advisory messages informing users of the vulnerability and action required |

**Support Period Minimum:** At least 5 years, or the expected lifetime of the product if shorter. Security updates must remain available for **10 years** after release. Technical file and EU DoC must be retained for **10 years**.

**Vulnerability Reporting Deadlines (Art. 14, applies from 11 September 2026):**

| Notification | Deadline | Recipient |
|-------------|----------|-----------|
| Early warning | **24 hours** of becoming aware | ENISA + national CSIRT |
| Main notification | **72 hours** | ENISA + national CSIRT |
| Final report (actively exploited vulnerability) | **14 days** after corrective/mitigating measure available | ENISA + national CSIRT |
| Final report (severe incident) | **30 days** from 72h submission | ENISA + national CSIRT |

Reporting applies to **all PDEs on the EU market**, including legacy products placed before 11 December 2027.

***
## Part VI: Technical Specifications and Conformity Assessment
### Conformity Assessment Modules (Annex VIII)
| Module | Article 32 Path | Who Performs | When Used |
|--------|----------------|--------------|-----------|
| **Module A** – Internal Control | Art. 32(1)(a) | Manufacturer (self-assessment) | Default products; Class I important products where harmonised standards applied |
| **Module B** – EU-Type Examination | Art. 32(1)(b), Part I + II Annex VIII | Notified body examines design | Class I without harmonised std; Class II; Critical |
| **Module C** – Conformity to Type (Internal Production Control) | Art. 32(1)(b), Part II Annex VIII | Manufacturer, based on Module B certificate | Always follows Module B |
| **Module H** – Full Quality Assurance | Art. 32(1)(c), Part IV Annex VIII | Notified body assesses entire QMS | Class II; Critical; manufacturers with multiple/frequent product types |
| **EUCC / European Cybersecurity Certification** | Art. 32(1)(d) + Art. 27(9) | ENISA-recognised certification scheme | Where Commission has specified scheme applicability; critical products |

**Module H advantage:** Covers an entire catalogue of products under one quality management system assessment. Particularly useful for manufacturers with frequent updates or multiple product types, as it eliminates per-product type examination.
### Standards and Technical Specifications
The CRA relies on **harmonised European standards** developed by CEN/CENELEC/ETSI to provide concrete implementation guidance for the Annex I requirements. Using harmonised standards creates a **legal presumption of conformity** (Article 27).

Key standardisation bodies and efforts:

| Body | Role |
|------|------|
| CEN/CENELEC JTC 13 | General horizontal cybersecurity standards (EN 18045, etc.) |
| ETSI | Telecommunications-specific standards; ETSI EN 303 645 (IoT) |
| BSI (Germany) | Technical Guidelines TR-03183 (Parts 1–3): manufacturer implementation guidance |
| ENISA | CRA Single Reporting Platform; EUCC scheme |

> **Status (June 2026):** Harmonised standards under the CRA are still being finalised by CEN/CENELEC/ETSI. The BSI TR-03183 technical guidelines provide the most concrete current implementation reference.
### CE Marking Requirements (Art. 28–30)
Before placing a PDE on the EU market, the manufacturer must:
1. Complete the applicable conformity assessment procedure
2. Draw up and sign the **EU Declaration of Conformity (DoC)**
3. Affix the **CE marking** visibly to the product
4. Provide user information per Annex II (including the support period end date, month and year)

***
## Part VII: Annexes — Full Descriptions and Checklists
### Annex I – Essential Cybersecurity Requirements
**Description:** The core technical standard of the CRA. Split into Part I (product security properties, 13 requirements) and Part II (vulnerability handling, 8 requirements). All PDEs in scope must meet both parts — the risk assessment determines the applicability and implementation approach for Part I requirements 2(a)–2(l).

**Checklist:**
- [ ] Cybersecurity risk assessment completed and documented (Art. 13(2))
- [ ] Risk assessment covers intended purpose, foreseeable use, operational environment, assets, expected lifetime
- [ ] Product released with no known exploitable vulnerabilities (Req. 1)
- [ ] Secure-by-default configuration implemented (Req. 2a)
- [ ] Access control / authentication mechanisms in place (Req. 2b)
- [ ] Data at rest and in transit encrypted using current-state cryptography (Req. 2c)
- [ ] Data and command integrity protection implemented (Req. 2d)
- [ ] Data minimisation principle applied (Req. 2e)
- [ ] DoS resilience mechanisms for essential functions (Req. 2f)
- [ ] Product designed to minimise negative network impact (Req. 2g)
- [ ] Attack surface minimised, external interfaces limited (Req. 2h)
- [ ] Exploit mitigation techniques implemented (Req. 2i)
- [ ] Security logging and monitoring capability present (Req. 2j)
- [ ] Secure update mechanism implemented (Req. 2k)
- [ ] Secure factory reset / recovery state available (Req. 2l)
- [ ] SBOM created in machine-readable format (VH Req. 1)
- [ ] Vulnerability remediation process documented (VH Req. 2)
- [ ] Regular security testing schedule established (VH Req. 3)
- [ ] CVD policy and security.txt published (VH Req. 5/6)
- [ ] Secure update distribution mechanism implemented (VH Req. 7)
- [ ] Free security update distribution process in place (VH Req. 8)
- [ ] Support period of minimum 5 years declared

***
### Annex II – Information and Instructions to Users
**Description:** Defines the mandatory information that must accompany products on the EU market, in a language easily understood by users. This is the user-facing compliance layer.

**Required information includes:**
- Product type, batch or serial number for identification
- Manufacturer name, registered trademark, postal/email address, website
- Conditions for intended use, misuse scenarios, known risks
- The EU Declaration of Conformity (or where to find it)
- Security support period end date (month and year), displayed at point of purchase
- How to report vulnerabilities (contact address)
- Instructions for secure installation, operation, and decommissioning
- Description of cybersecurity properties relevant to users

**Checklist:**
- [ ] Product identification element (type, batch, serial)
- [ ] Manufacturer contact details (postal + digital)
- [ ] Intended use conditions documented
- [ ] Security support period end date prominently displayed
- [ ] Vulnerability reporting contact address included
- [ ] User instructions cover secure installation, operation, decommission
- [ ] EU DoC included or referenced with URL
- [ ] Language appropriate for target market(s)

***
### Annex III – Important Products with Digital Elements
**Description:** The definitive list of product categories classified as "important," split into Part I (Class I — moderate third-party risk) and Part II (Class II — higher systemic risk). Products are classified based on core functionality.

Technical descriptions of these categories were adopted via Commission Implementing Regulation (EU) 2025/2392 on 28 November 2025.

**Checklist (for manufacturers of products with functionality matching Annex III):**
- [ ] Core functionality assessed against all Annex III Part I and Part II categories
- [ ] Classification as Class I or Class II determined and documented
- [ ] Conformity assessment route selected (Module A only if Class I with harmonised standards; Module B+C or H if Class II or Class I without standards)
- [ ] FOSS exception assessed if applicable (requires public technical documentation)
- [ ] Notified body identified and engaged (if required)
- [ ] Enhanced technical documentation prepared for third-party review

***
### Annex IV – Critical Products with Digital Elements
**Description:** Three specific product categories subject to the most stringent obligations, with potential for mandatory EUCC certification by Commission delegated act:

1. **Hardware Devices with Security Boxes** (HSMs)
2. **Smart meter gateways** within smart metering systems (Directive (EU) 2019/944) and other devices for advanced security purposes including secure cryptoprocessing
3. **Smartcards or similar devices, including secure elements**

**Checklist:**
- [ ] Product assessed against all three Annex IV categories
- [ ] Critical classification documented
- [ ] Third-party notified body assessment initiated
- [ ] EUCC certification applicability checked (Commission delegated acts)
- [ ] Enhanced post-market monitoring plan established
- [ ] Coordination with ENISA on reporting platform registration

***
### Annex V – EU Declaration of Conformity (Full Model)
**Description:** Provides the mandatory template structure for the full EU Declaration of Conformity that manufacturers must draw up and sign before CE marking.

**Required DoC Elements:**
- Product identification (name, model, batch/serial number)
- Manufacturer name and full address
- Statement that the DoC is issued under the sole responsibility of the manufacturer
- Object of declaration identified sufficiently to trace to the product
- Reference to the CRA (Regulation (EU) 2024/2847) and Annex I
- Reference to any harmonised standards applied
- Reference to any common specifications applied
- Reference to any European cybersecurity certification used
- Identification of notified body (if third-party assessment used), assessment module, and certificate number
- Signed declaration by or on behalf of the manufacturer, date and place

**Checklist:**
- [ ] All required fields completed
- [ ] Standards/specifications applied cited with version/date
- [ ] Notified body number and certificate number included (if applicable)
- [ ] DoC signed by authorised person
- [ ] DoC retained for 10 years
- [ ] DoC available to market surveillance authorities on request
- [ ] Simplified DoC (Annex VI) used for Class I products if permitted

***
### Annex VI – Simplified EU Declaration of Conformity
**Description:** Abbreviated DoC format permitted for products where regulations allow a simplified declaration (primarily for space-constrained products). The simplified DoC must reference where the full DoC can be found.

**Required Simplified DoC Elements:**
- Product name and type
- Manufacturer name and address
- Statement of conformity with Regulation (EU) 2024/2847
- Website URL where full DoC can be accessed

**Checklist:**
- [ ] Check whether simplified DoC is permitted for product category
- [ ] URL to full DoC active and accessible
- [ ] Simplified DoC included in product packaging or documentation

***
### Annex VII – Technical Documentation
**Description:** Specifies the minimum content of the Technical Documentation (Technical File) that must be drawn up before placing the product on the market and kept available for market surveillance authorities.

Technical Documentation must be assembled **before** market placement and maintained for **10 years after**.

**Annex VII Content Requirements:**

| Part | Content |
|------|---------|
| **Product description and intended use** | Type, model, version, intended use, operational environment, connectivity, dependencies |
| **Design and manufacturing information** | Architecture (hardware and software), module breakdown, firmware, network architecture, data flow diagrams, third-party components |
| **Cybersecurity risk assessment** | Per Article 13(2)–(3); threat identification, risk determination, Annex I applicability determination |
| **Essential requirements implementation** | Mapping of each applicable Annex I requirement to implemented technical controls |
| **SBOM** | Machine-readable SBOM covering top-level dependencies; component names, versions, suppliers, known CVEs, licences |
| **Update and patch management** | Update architecture, signing/validation, rollback prevention, lifecycle policy |
| **Vulnerability handling processes** | CVD policy, intake and triage process, remediation workflows, disclosure timelines |
| **Security testing evidence** | Penetration test summaries, SAST/DAST results, fuzzing results, third-party test reports |
| **Conformity assessment evidence** | Module A self-declaration or Module B certificate / Module H QMS certificate |
| **EU Declaration of Conformity** | Copy of completed Annex V DoC |
| **Post-market monitoring plan** (Annex VII, post-market component) | Monitoring strategy, threat intel sources, incident response documentation, vulnerability register |

**Checklist:**
- [ ] Product description and intended use — complete
- [ ] Architecture diagrams (hardware, software, network, data flow) — complete
- [ ] Cybersecurity risk assessment documented and signed
- [ ] Annex I requirements mapping matrix — complete
- [ ] SBOM generated in machine-readable format (SPDX, CycloneDX, or SWID)
- [ ] All SBOM dependencies — name, version, supplier, CVE status, licence
- [ ] Secure development lifecycle (SDL) documentation included
- [ ] Security testing evidence (pentest, SAST, DAST, fuzzing) archived
- [ ] Update mechanism architecture documented
- [ ] Vulnerability handling process documented
- [ ] CVD policy and security.txt file documented
- [ ] EU DoC (Annex V) included
- [ ] Post-market monitoring plan included
- [ ] Technical file retained for 10 years from market placement
- [ ] Designated contact for MSA data requests

***
### Annex VIII – Conformity Assessment Procedures
**Description:** Specifies the four assessment modules available under Article 32, defining the obligations of the manufacturer and notified body for each:

**Part I – Module A (Internal Control / Self-Assessment):**
- Manufacturer performs all conformity assessment activities
- No notified body involvement
- Manufacturer compiles technical documentation and signs EU DoC
- Available for: Default products; Class I Important products where harmonised standards or common specifications are applied

**Part II – Module B (EU-Type Examination):**
- Manufacturer submits technical documentation and representative sample to notified body
- Notified body examines product design and issues EU-Type Examination Certificate
- Certificate valid 5 years, renewable
- Must be followed by Module C

**Part III – Module C (Conformity to EU-Type Based on Internal Production Control):**
- Follows Module B
- Manufacturer declares production conforms to approved type
- No further notified body involvement in production phase

**Part IV – Module H (Full Quality Assurance):**
- Manufacturer implements a complete quality management system covering design through production
- Notified body assesses the entire QMS (can be based on ISO 9000 series, but ISO 9000 certification alone is insufficient)
- Notified body conducts periodic audits
- Manufacturer declares conformity based on QMS
- Best for manufacturers with multiple product types or frequent updates
- One notified body covers the whole QMS

**Checklist:**
- [ ] Product classification confirmed (Default / Class I / Class II / Critical)
- [ ] Harmonised standards availability checked (determines Module A eligibility for Class I)
- [ ] Conformity assessment route documented and justified
- [ ] Notified body identified and contracted (if required)
- [ ] Module A: Technical documentation complete; self-declaration signed
- [ ] Module B: Application submitted to notified body; EU-Type certificate received
- [ ] Module C: Production conformity declaration signed referencing Module B certificate
- [ ] Module H: QMS documented and submitted; notified body approval received; periodic audit schedule set
- [ ] Notified body ID number recorded in EU DoC

***
## Part VIII: Enforcement, Penalties, and Market Surveillance
### Penalty Tiers (Article 64)
| Violation | Maximum Fine | % of Global Annual Turnover |
|-----------|-------------|----------------------------|
| Non-compliance with essential cybersecurity requirements (Annex I) or Art. 13/14 manufacturer obligations | **€15,000,000** | **2.5%** (whichever is higher) |
| Non-compliance with other obligations (importers, distributors, conformity, CE marking, technical documentation) | **€10,000,000** | **2.0%** (whichever is higher) |
| Supplying incorrect, incomplete, or misleading information to notified bodies or market surveillance authorities | **€5,000,000** | **1.0%** (whichever is higher) |

**SME exemption:** Microenterprises and small enterprises cannot be fined for failures to meet the 24-hour early warning reporting deadline. Open-source software stewards are not subject to penalties for any CRA infringement.

**Non-monetary enforcement:** Market surveillance authorities can require product withdrawal or corrective action; products found non-compliant may be barred from the EU market.
### Market Surveillance Structure
- Each Member State designates one or more **Market Surveillance Authorities (MSAs)** under Article 52
- Cross-border coordination via **Administrative Cooperation Group (ADCO)** — Article 52
- **Joint sweeps** and coordinated control actions enabled under Article 60
- MSAs can access technical documentation, test products, and issue orders for corrective action, withdrawal, or recall

***
## Part IX: Timeline Summary and Compliance Roadmap
| Date | Obligation |
|------|-----------|
| **10 Dec 2024** | CRA entered into force |
| **11 Jun 2026** | Member States must notify conformity assessment bodies (Ch. IV applies) |
| **11 Sep 2026** | Reporting obligations (Art. 14) apply — 24h/72h/14d/30d deadlines active for all PDEs on EU market including legacy |
| **11 Dec 2027** | Full CRA applicability — CE marking, DoC, conformity assessment, and all obligations mandatory for new products |
| **11 Jun 2028** | Existing EU-type examination certificates and approval decisions expire |

**Substantial modification rule:** Products placed on the market **before 11 December 2027** are exempt unless they undergo a "substantial modification" after that date (defined in Article 3(30), Recitals 38–41).

**Immediate action items (pre-December 2027):**
1. Classify all products against Annex III/IV
2. Conduct cybersecurity risk assessment per Art. 13(2)
3. Establish SBOM tooling and CVD policy infrastructure
4. Register on ENISA Single Reporting Platform (for Art. 14 compliance by Sep 2026)
5. Identify notified body for Class II or Critical products
6. Begin technical documentation compilation
7. Map Annex I requirements to existing security controls and identify gaps

---

## References

1. [Exclusions and Transitional Scope under the EU Cyber Resilience Act](https://www.linkedin.com/pulse/exclusions-transitional-scope-under-eu-cyber-resilience-ian-gauci-frwce) - The Cyber Resilience Act, Regulation (EU) 2024/2847, introduces for the first time a horizontal fram...

2. [The Cyber Resilience Act: an overview - Cyberstand](https://cyberstand.eu/cyber-resilience-act-overview) - The Cyber Resilience Act (CRA) was published in the EU Official Journal on 20 November 2024 and offi...

3. [The Cyber Resilience Act - Summary of the legislative text](https://digital-strategy.ec.europa.eu/en/policies/cra-summary) - The text below summarises the main provisions of Regulation (EU) 2024/2847, in order to support the ...

4. [Cyber Resilience Act: Overview for affected companies](https://www.taylorwessing.com/en/insights-and-events/insights/2025/11/cyber-resilience-act-overview) - Under Article 64 CRA, violations can result in fines of up to EUR 15 million or 2.5 % of the company...

5. [Cyber Resilience Act - BSI](https://www.bsi.bund.de/EN/Themen/Unternehmen-und-Organisationen/Informationen-und-Empfehlungen/Cyber_Resilience_Act/cyber_resilience_act_node.html) - The Cyber Resilience Act is the first European regulation to set a minimum level of cyber security f...

6. [Beyond the Checklist: Which products fall under scope of the EU ...](https://nohau.eu/blogs/knowledge-center/beyond-the-checklist-which-products-fall-under-scope-of-the-eu-cyber-resilience-act-cra) - Critical (Annex IV) – Highest-risk PDEs, such as smart meter gateways, secure elements, or hardware ...

7. [Cyber Resilience Act text, Article 13](https://www.european-cyber-resilience-act.com/Cyber_Resilience_Act_Article_13.html) - Manufacturers shall undertake an assessment of the cybersecurity risks associated with a product wit...

8. [CRA guide for manufacturers - Cyber Resilience Act](https://www.cyberresilienceact.eu/cra-guide-for-manufacturers/) - 01Confirm scope and classification ; 02Run a cybersecurity risk assessment ; 03Meet the essential re...

9. [Mandatory SBOMs: What CRA is — and why it matters | RL Blog](https://www.reversinglabs.com/blog/mandatory-sbom-cra) - The EU''s Cyber Resilience Act introduces a legal obligation for software producers to create, mainta...

10. [CRA SBOM Requirements: Complete Guide - Regulus](https://goregulus.com/cra-requirements/cra-sbom-requirements/) - SBOMs are directly tied to Annex I Section 2 of the CRA, which defines vulnerability handling rules....

11. [Does the EU Cyber Resilience Act Apply to Your Product? Functions ...](https://testofthings.com/blog/does-cra-apply-to-your-product-product-functions-boundaries-and-components) - Depending on the core functionality your product may be categorized as default, important class I, i...

12. [The 3 product categories covered by the Cyber Resilience Act](https://theembeddedkit.io/blog/product-categories-cyber-resilience-act/) - The CRA classifies products with digital components into 3 product categories: default, important, a...

13. [How to Classify IoT Products under the CRA - Tributech](https://www.tributech.io/blog/classify-iot-products-cyber-resilience-act) - All classes must meet the same 13 essential cybersecurity requirements in Annex I. Your classificati...

14. [Step 6: Which Conformity Assessment Procedure Applies? - LinkedIn](https://www.linkedin.com/pulse/step-6-which-conformity-assessment-procedure-applies-michael-jesse-szpkf) - Module H, set out in Part IV of Annex VIII CRA, is the most comprehensive conformity assessment opti...

15. [Understanding the EU Cyber Resilience Act Requirements](https://finitestate.io/blog/conformity-assessments-eu-cra-requirements) - TL;DR A CRA conformity assessment is how you prove a connected product meets the EU Cyber Resilience...

16. [CRA - Annex IV - StreamLex](https://streamlex.eu/annexes/cra-en-annex-iv/) - Annex IV. CRITICAL PRODUCTS WITH DIGITAL ELEMENTS 1. Hardware Devices with Security Boxes 2. Smart m...

17. [Cyber Resilience Act text, Annex 1 (15.9.2022)](https://www.european-cyber-resilience-act.com/Cyber_Resilience_Act_Annex_1.html) - VULNERABILITY HANDLING REQUIREMENTS. Manufacturers of the products with digital elements shall: (1) ...

18. [EU CRA: Essential Requirements Related to Vulnerability Handling](https://www.smallstepsystems.com/eu-cra-essential-requirements-related-to-vulnerability-handling/) - The eight requirements define how the manufacturer''s process for vulnerability handling must look. T...

19. [Penalties for CRA Non-Compliance Explained - © Complyd 2025](https://complyd.io/en/blog/compliance-info-penalties-for-cra-non-compliance-explained/) - Max Fine, % of Global Turnover. Core cybersecurity obligations (manufacturers), €15 million, 2.5%. I...

20. [What is module H? How does it work? - CRA FAQ](https://cra.orcwg.org/faq/official/faq_6-3/) - Module H, set out in Part IV of Annex VIII, is a conformity assessment procedure in which the manufa...

21. [Cyber Resilience Act Technical Documentation Guide (Annex II & VII)](https://goregulus.com/cra-documentation/technical-documentation/) - Annex II defines the core Technical Documentation for conformity assessment. ... Part 6 — Conformity...

22. [Cyber Resilience Act text, Article 53 (15.9.2022)](https://www.european-cyber-resilience-act.com/Cyber_Resilience_Act_Article_53_15.9.2022.html) - The non-compliance with any other obligations under this Regulation shall be subject to administrati...

---

_Related: [Cyber Resilience Act overview](/en/cra) · [CRA CE Marking Pathways](/en/cra-ce-marking-pathways) · [CRA Complete Technical Reference](/en/cra-technical-reference) · [IEC 62443](/en/iec-62443) · [NIS2](/en/nis2)_', true, 'Cyber Resilience Act — Complete Technical Reference (Reg (EU) 2024/2847) | OXOT', 'A complete technical reference to the EU Cyber Resilience Act (Regulation (EU) 2024/2847): scope and exclusions, the three-tier product classification, every Annex I essential requirement, conformity-assessment modules, all eight annexes, penalties and the compliance timeline.', 'Deep technical reference to Regulation (EU) 2024/2847 — regulation structure (8 chapters, 71 articles, 8 annexes), product classification, Annex I essential requirements, conformity assessment, CE marking, penalties and the compliance roadmap.', NULL, 'article', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('cra-ce-marking-pathways', 'en', 'CRA — CE Marking Pathways & Conformity Assessment', '[Frameworks](/en/frameworks) › [Cyber Resilience Act](/en/cra) › CE Marking Pathways

> **Practitioner reference.** This page covers how you actually demonstrate conformity and CE-mark under the CRA. For the plain-language overview see the [Cyber Resilience Act field guide](/en/cra); for the full clause-by-clause map see the [CRA Complete Technical Reference](/en/cra-technical-reference).

> **Intended Use:** This reference is designed for product teams, compliance leads, and security architects planning CE marking campaigns under the CRA. It covers every conformity pathway, process architecture, DoC requirements, notified body engagement mechanics, and practical capability blocks organisations can adapt as programme blueprints.

***

## Part I — Architecture of the CRA Conformity System

### 1.1 Statutory Basis

The conformity assessment obligation derives from **Article 32** of Regulation (EU) 2024/2847:

> *"The manufacturer shall demonstrate conformity with the essential cybersecurity requirements by one of the following procedures: (a) internal control (based on Module A) in accordance with Annex VIII; (b) EU-type examination (based on Module B) in accordance with Annex VIII, followed by conformity to type based on internal production control (based on Module C) in accordance with Annex VIII; (c) conformity based on full quality assurance (based on Module H) in accordance with Annex VIII; or (d) where available and applicable, a European cybersecurity certification scheme pursuant to Article 27(9)."*

The modules originate from the EU **New Legislative Framework (NLF)** — Decision 768/2008/EC — and are well-established across other CE-marking regulations (Radio Equipment Directive, Medical Device Regulation, Machinery Regulation). The CRA adapts them to the cybersecurity domain.

### 1.2 CE Marking as the Market Access Gate

From **11 December 2027**, no product with digital elements may be legally placed on the EU market without a valid CE marking demonstrating CRA conformity. The CE mark is affixed **only** after:
1. The conformity assessment procedure is completed
2. The EU Declaration of Conformity is drawn up and signed
3. All technical documentation is compiled

The CE marking does not have an expiry date, but must be removed or updated if the product undergoes a substantial modification that affects compliance.

### 1.3 The Classification Gate Controls the Module

The choice of module is **not free** — it is determined by the product''s risk classification under Articles 6–8:

| Product Classification | Available Modules | Self-Assessment Permitted? |
|---|---|---|
| **Default** | Module A only | Yes — always |
| **Important Class I** (Annex III, Class I) | Module A if full harmonised standard applied; else Module B+C or H | Yes, IF harmonised standard covers all requirements |
| **Important Class II** (Annex III, Class II) | Module B+C or Module H only | No — never |
| **Critical** (Annex IV) | European cybersecurity certification scheme; if none, Module B+C or H | No — never |

The single most consequential compliance decision is therefore the classification, not the technical implementation. Getting classification wrong late in the programme can invalidate the entire conformity assessment.

***

## Part II — Module A: Internal Control (Self-Assessment)

### 2.1 Legal Basis and When It Applies

Module A is set out in **Part I of Annex VIII** of the CRA. It is the "default" path: no notified body, no external audit, manufacturer-sole-responsibility declaration. It applies to:
- All Default products, regardless of how the manufacturer demonstrates compliance technically (even if they use no harmonised standard)
- Important Class I products where the manufacturer has **fully applied** a harmonised standard or relevant European cybersecurity certification scheme covering all applicable Annex I requirements

> *"Module A, laid down in Part I of Annex VIII CRA, is the most straightforward conformity assessment procedure. It is a self-assessment, carried out entirely under the manufacturer''s sole responsibility. No notified body is involved."*

### 2.2 Critical Constraint: Harmonised Standard Timing for Class I

As of June 2026, **no harmonised CRA standards have been cited in the EU Official Journal**. This means that as of today, all Important Class I manufacturers are using the third-party pathway (Module B+C or H) by default — the Module A self-assessment path for Class I is temporarily blocked until OJEU citation occurs, expected approximately Q2 2027. Manufacturers of Class I products targeting a December 2027 CE marking must plan for a two-phase approach:
- **Phase 1 (now–Q2 2027):** Execute Module B+C or H with a notified body, or pre-develop all evidence against the anticipated harmonised standard
- **Phase 2 (after OJEU citation):** Where the harmonised standard fully covers the product, transition to Module A self-assessment for future product versions

### 2.3 Module A Process Steps — Step-by-Step

#### Step 1 — Product Scope and Classification Verification

Before initiating Module A, confirm the product is genuinely in the Default category or that the full harmonised standard covers all applicable Annex I requirements for Class I. Maintain a documented **Classification Decision Record** (CDR) with references to specific Annex III exclusion analysis, product boundary definition, and intended-use statement.

*Capability Block: CDR Template*
```
CLASSIFICATION DECISION RECORD
Product: [Name, Model, Version(s)]
Author: [Name, Role]           Date: [YYYY-MM-DD]
---------------------------------------------------------
Section A: CRA Scope Assessment
  A1. Is this a PDE per Article 3(1)?         [Y/N + justification]
  A2. Any Article 2 exclusion applicable?     [Y/N + justification]
  A3. Remote data processing present?         [Y/N + description]

Section B: Classification Analysis
  B1. Is product listed in Annex III Class I? [Y/N + specific item]
  B2. Is product listed in Annex III Class II?[Y/N + specific item]
  B3. Is product listed in Annex IV?          [Y/N + specific item]
  B4. Classification result:                  [Default / Imp.I / Imp.II / Critical]

Section C: Module Selection
  C1. If Default: Module A confirmed          [confirm]
  C2. If Important Class I: Harmonised std?   [Std ref + OJEU date / Not available]
  C3. Module selected:                        [A / B+C / H / EUCC]

Approved by: [Signatory]        Role: [Position with legal authority]
```

#### Step 2 — Cybersecurity Risk Assessment (Article 13(2)–(3))

The risk assessment is the foundational document for Module A. It must:
- Identify the threat profile and intended operational environment
- Map each Annex I, Part I, point (2)(a)–(m) requirement to a determination of applicability
- Document how applicable requirements are implemented
- Document non-applicable requirements with *"a clear justification"* (Article 13(4))
- Cover both security properties (Part I) and vulnerability handling (Part II)

*Capability Block: Risk Assessment Structure for Module A*
```
CRA CYBERSECURITY RISK ASSESSMENT
Product: [Name, Model, Version]       Classification: [Default/Class I]
Risk Assessment Version: [x.y]        Date: [YYYY-MM-DD]
-----------------------------------------------------------------------
1. PRODUCT PROFILE
   1.1 Intended purpose and use cases
   1.2 Connectivity interfaces (wired, wireless, protocols)
   1.3 Operational environment (home/enterprise/industrial/critical)
   1.4 User types (consumer/professional/administrator)
   1.5 Expected product lifetime and support period rationale

2. THREAT LANDSCAPE
   2.1 Threat actor profile (opportunistic / targeted / IACS-specific)
   2.2 Attack vectors (network / local / physical / supply chain)
   2.3 Assets requiring protection (data, functionality, users)
   2.4 Relevant threat intelligence sources consulted

3. ANNEX I PART I REQUIREMENTS MAPPING
   For each sub-requirement (a) through (m):
   | Req | Applicable? | Justification | Implementation |
   |-----|-------------|---------------|----------------|
   |(a) No known vulns | YES | Connected product | SBOM-gated release + pre-release scan |
   |(b) Secure by default | YES | Consumer-facing | No default passwords; factory reset |
   |(c) Security updates | YES | Networked | Auto-update default with opt-out |
   |(d) Access control | YES | Multi-user API | MFA for admin; RBAC |
   |(e) Data confidentiality | YES | PII in transit | TLS 1.3; AES-256 at rest |
   |(f) Data integrity | YES | Config protected | HMAC on config; signed firmware |
   |(g) Data minimisation | YES | Telemetry collected | Scope-limited collection policy |
   |(h) Availability | YES | Network-connected | Rate limiting; DoS protections |
   |(i) Attack surface | YES | Internet-facing | Closed unnecessary ports/services |
   |(j) Incident impact | YES | Networked | Network segmentation; containment |
   |(k) Logging | YES | Enterprise use | Audit log with opt-out |
   |(l) Data deletion | YES | User data stored | Secure wipe on factory reset |
   |(m) Reduce exposure | YES | All products | SDL applied; minimal footprint |

4. ANNEX I PART II REQUIREMENTS MAPPING
   [Same table format for each of the 8 VH requirements]

5. RISK CONCLUSION
   5.1 Overall risk profile
   5.2 Residual risks and mitigations
   5.3 Support period determination and rationale
```

#### Step 3 — Implement Security Controls and Validate

Implement all applicable Annex I requirements. For Module A, the manufacturer is responsible for selecting the validation methods — test reports, static/dynamic analysis, penetration test summaries, or design analysis — and retaining evidence. There is no external verification requirement for Module A.

Recommended evidence set for Default products:
- Pre-release vulnerability scan report (tooling: Grype, Trivy, Semgrep, or equivalent)
- SBOM for each release version (CycloneDX or SPDX format)
- Penetration test summary or design-based security analysis (proportionate to product risk)
- Secure configuration review documentation
- Test cases demonstrating: authentication lockout, update mechanism integrity, factory reset function, access control enforcement

#### Step 4 — Compile Technical Documentation (Article 31, Annex VII)

Assemble the complete technical file. This is the same evidence package required regardless of module, and is the document an assessor or market surveillance authority will examine. See Part V of this report for the full Annex VII element list.

#### Step 5 — Draw Up and Sign EU Declaration of Conformity (Article 28, Annex V)

Issue the DoC using the Annex V structure (see Part VI). The DoC may not be signed before the conformity assessment is completed and evidence compiled. The DoC must be reviewed and updated if the product is substantially modified.

#### Step 6 — Affix CE Marking and Manage Production Conformity

Affix the CE mark visibly, legibly, and indelibly to the product, packaging, or — for software — accompanying documentation or download page. For Module A, the manufacturer must have internal controls to ensure that production units (subsequent releases) continue to conform to the assessed version. Where a new software version is released, an assessment of whether it constitutes a substantial modification is required.

### 2.4 Module A Timing Benchmark

A well-prepared organisation with existing SBOM tooling and a security development lifecycle (SDL) should allow:

| Activity | Duration |
|---|---|
| Classification decision and risk assessment | 4–8 weeks |
| Security implementation and internal testing | 8–16 weeks (product-dependent) |
| Technical documentation compilation | 4–6 weeks |
| DoC preparation, legal review, and signature | 1–2 weeks |
| **Total (new product, Module A)** | **17–32 weeks** |

For existing products with a mature security posture, technical documentation compilation is typically the critical-path item.

***

## Part III — Module B+C: EU-Type Examination with Notified Body

### 3.1 Legal Basis and When It Applies

Module B+C is set out in **Parts II and III of Annex VIII**. It combines:
- **Module B** — EU-type examination by a notified body of the product *type* (design and architecture)
- **Module C** — ongoing conformity to type based on the manufacturer''s internal production control

Module B+C is required for:
- Important Class I products where no applicable harmonised standard has been fully applied
- **All** Important Class II products
- Critical products where no mandatory EUCC certification scheme has been designated

> *"Under this procedure, the manufacturer remains responsible for implementing cybersecurity measures, testing the product and preparing the technical documentation. The notified body, however, plays a central role by assessing the technical design of the product based on documentation and samples, and by performing or commissioning the necessary tests."*

### 3.2 What a Notified Body Is and How It Is Designated

A notified body (NB) is a **conformity assessment body (CAB) designated by an EU Member State** to carry out third-party assessment under the CRA. Designation requires:
1. The CAB applies to the national authority (Notifying Authority) for designation
2. The national authority verifies the CAB meets Article 43 CRA requirements: technical competence, independence, impartiality, adequate insurance, and domain knowledge
3. Accreditation by a National Accreditation Body (NAB) under EN ISO/IEC 17065 (product certification) or EN ISO/IEC 17021 (management system certification)
4. Formal notification to the European Commission via NANDO (Notification And Database Online)
5. Listing in the NANDO database, after which the NB may receive its identification number (a 4-digit NANDO number printed alongside the CE mark)

**CRA Notified Body Availability — June 2026 Status:**

> *"On 11 June 2026, the CRA''s rules on notified bodies started to apply, but none are designated yet."*

The notified body designation and accreditation process typically takes **12 to 18 months**. This means the pool of CRA-designated notified bodies will remain extremely small well into 2027. Several organisations that serve as notified bodies under the Radio Equipment Directive (RED), the Medical Device Regulation (MDR), and the Machinery Regulation have announced CRA readiness programmes, including TÜV Rheinland, TÜV SÜD, BSI Group, SGS, Bureau Veritas, and Applus+ Laboratories.

The practical consequence: **demand for CRA notified body services will far exceed capacity in 2026–2027**. Manufacturers requiring Module B+C or H must enter the queue immediately.

### 3.3 Module B: EU-Type Examination — Step-by-Step Process

The notified body conducts the EU-type examination (Module B) against the technical documentation and a representative product sample. The examination covers both the technical design and the vulnerability handling processes.

#### Phase 1 — Pre-Engagement and Notified Body Selection

Before submitting an application:
- Identify candidate notified bodies via NANDO database (search for CRA scope once designations appear)
- Verify the NB has technical competence in the product domain (software products, IoT, industrial control systems, embedded systems — different NBs may have different scopes)
- Request a scoping call to understand NB-specific submission requirements and timelines
- Obtain a preliminary cost and timeline estimate — costs vary significantly by NB, product complexity, and assessment scope

*Capability Block: Notified Body Evaluation Scorecard*
```
NOTIFIED BODY EVALUATION MATRIX
Evaluation Date: [YYYY-MM-DD]    Product: [Name, Class]
---------------------------------------------------------
Candidate NB: [Name]
  NANDO Number: [####]           NANDO Scope: [CRA / RED / MDR]
  Domain Expertise:
    - Software/firmware:         [High / Medium / Low / Unknown]
    - ICS/OT products:           [High / Medium / Low / Unknown]
    - Consumer IoT:              [High / Medium / Low / Unknown]
    - Industrial Class II:       [High / Medium / Low / Unknown]
  Capacity Assessment:
    - Current backlog (months):  [estimate from scoping call]
    - Earliest intake date:      [YYYY-MM]
    - Estimated assessment duration: [months]
    - Surveillance commitment:   [annual / biennial / other]
  Cost Estimate:
    - Module B examination:      [€ range]
    - Annual surveillance:       [€ range]
  Communication Quality:         [Score 1–5]
  Geographic Coverage:           [EU / Global]
  Languages:                     [list]
  Reference clients available?   [Y/N]
  ---------------------------------------------------------
  RECOMMENDATION: [Selected / Reserve / Rejected]
  Rationale: [notes]
```

#### Phase 2 — Application Submission

Submit a formal application to the chosen NB. Standard submission content:

- Completed NB application form (NB-specific format)
- Annex VII technical documentation package (see Part V) — provided as a structured PDF or document portal submission
- One or more representative product samples for physical examination (hardware products) or access credentials (software/cloud)
- Draft EU Declaration of Conformity (pre-signature version)
- Confirmation of the Annex I applicability decisions made by the manufacturer
- List of harmonised standards, common specifications, or technical specifications applied

The NB will issue an **acceptance confirmation** within typically 2–4 weeks of submission, confirming the application is complete and examination is scheduled.

#### Phase 3 — Technical Documentation Review (Module B, Phase 1)

The NB conducts a desk review of the technical documentation:

- Verifies completeness of Annex VII content
- Reviews the risk assessment and Annex I applicability decisions
- Assesses the cybersecurity architecture against Annex I Part I requirements
- Reviews the SBOM and vulnerability handling process documentation
- Reviews CVD policy, single point of contact, and Article 14 reporting capability documentation
- Reviews test plans and existing test evidence
- Issues a **Technical Documentation Review Report** identifying any gaps (non-conformities or observations)

The manufacturer must resolve all identified non-conformities before the NB proceeds. Gaps identified during review that require remediation extend the total timeline — often by 4–8 weeks per remediation cycle.

#### Phase 4 — Product Testing and Examination

For hardware products, the NB examines the submitted sample(s). For software, the NB assesses in a test environment or via documented analysis. The examination may include:

- Functional security testing of implemented controls (authentication, access control, cryptographic implementations)
- Review of update mechanism integrity (signing, rollback protection)
- Validation of secure default configuration
- Assessment of SBOM accuracy against the actual product binary
- Verification that no known exploitable vulnerabilities exist in the submitted version (live CVE check against SBOM)
- Vulnerability handling process walk-through (procedural assessment)

#### Phase 5 — EU-Type Examination Certificate Issuance

If the examination is successful:

> *"If the notified body concludes that the product complies with the CRA, it issues an EU-type examination certificate, valid for a defined period."*

The EU-type examination certificate contains:
- NB name and identification number
- Manufacturer name and address
- Product identification (type, model, versions examined)
- Examination result and conditions/limitations
- Validity period (typically 5 years, subject to surveillance)
- References to the standards or technical specifications applied in the examination
- Signed by the responsible NB examiner

The certificate covers the specific product *type* — the design examined. All production units (Module C) must conform to this type.

#### Phase 6 — Module C: Conformity to Type (Manufacturer Responsibility)

Module C is the manufacturer''s obligation to ensure ongoing production conformity to the approved type. Under the CRA, Module C requires:

- Internal production controls that prevent manufactured units (or software releases) from deviating from the examined type
- Where a new version deviates from the examined type in a security-relevant way, the manufacturer must notify the NB to determine whether a new examination is required
- Any modification affecting the Annex I security properties or intended purpose that constitutes a substantial modification requires a new Module B examination and a new certificate

*Capability Block: Module C Production Conformity Procedure*
```
MODULE C: PRODUCTION CONFORMITY PROCEDURE

Purpose: Ensure each release conforms to the Module B examined type.
Applies to: All releases of [Product Name] post-certificate issuance.
Owner: [Product Security Lead / QMS Owner]

CHANGE CLASSIFICATION GATE (per release):
For every proposed change, assess against the examined type:

  1. Does the change affect any Annex I security property?     [Y/N]
  2. Does the change modify a component listed in the SBOM?    [Y/N]
  3. Does the change alter the product''s intended purpose?     [Y/N]
  4. Does the change modify a security-relevant architecture element? [Y/N]

  If ALL answers = N: Minor change, Module C controls apply, no NB notification needed.
  If ANY answer = Y: Assess severity:
    - Security improvement only (no new risk): Document, update tech file, notify NB informally.
    - New security risk or changed intended purpose: Treat as substantial modification.
      Action: Suspend CE marking for affected versions; initiate new Module B examination.

RELEASE GATE CHECKLIST:
  □ Change Classification Gate completed and documented
  □ SBOM updated to reflect release component set
  □ CVE scan against updated SBOM — zero known exploitable vulnerabilities
  □ Test report confirming conformity to examined type
  □ Technical documentation updated (version incremented)
  □ DoC updated if product version scope changes
  □ NB notification completed (if required by classification gate)
```

### 3.4 Module B+C Timing Benchmark

| Phase | Estimated Duration |
|---|---|
| Notified body selection and scoping | 4–8 weeks |
| Application preparation and submission | 6–12 weeks |
| NB intake acceptance | 2–4 weeks |
| Technical documentation review | 4–8 weeks |
| Remediation cycle (if non-conformities identified) | 4–8 weeks per cycle |
| Product examination and testing | 4–8 weeks |
| Certificate issuance | 2–4 weeks |
| DoC preparation, review, signing | 1–2 weeks |
| **Total (well-prepared organisation)** | **4–8 months** |
| **Total (gaps requiring remediation)** | **8–14 months** |

These estimates are based on analogous experience under other EU NLF frameworks (RED, MDR) and reflect the anticipated CRA process. Given notified body capacity constraints in 2026–2027, add 2–4 months for queue wait time for most manufacturers entering the process in late 2026 or early 2027.

**Critical implication:** For Important Class II products targeting 11 December 2027, the Module B+C process must be initiated by approximately **February–March 2027** at the absolute latest — ideally Q4 2026.

***

## Part IV — Module H: Full Quality Assurance

### 4.1 Legal Basis and Concept

Module H is set out in **Part IV of Annex VIII** and represents the most flexible third-party pathway for organisations with a broad product portfolio:

> *"Module H, set out in Part IV of Annex VIII, is a conformity assessment procedure in which the manufacturer implements a full quality control system that ensures that the products subject to this system comply with the essential requirements of the CRA in both the design and the production phases."*

Unlike Module B+C, which focuses on a specific product *type*, Module H assesses the manufacturer''s **quality management system (QMS)** across a defined product portfolio. Individual products do not each undergo separate examination — instead, the NB verifies that the QMS is capable of consistently producing CRA-compliant products.

### 4.2 Module H vs. Module B+C: Strategic Comparison

| Dimension | Module B+C | Module H |
|---|---|---|
| Assessment focus | Individual product type design | Manufacturer''s QMS across product portfolio |
| NB involvement | Per-product examination + certificate | QMS audit + ongoing surveillance visits |
| Scalability | Low — each new product type needs new examination | High — new products added to existing QMS scope via extension |
| Initial investment | Lower (single product) | Higher (QMS design, documentation, audit preparation) |
| Ongoing cost | Per-product + surveillance | Annual/biennial surveillance, product addition assessments |
| Best for | Narrow product portfolio; few new products per year | Broad portfolio; frequent new product introductions |
| ISO 9000 relevance | None | ISO 9000/9001 provides useful framework, but does NOT automatically qualify — NB assessment is still required |
| Flexibility for product updates | Requires NB notification for type changes | Updates assessed through QMS change control; NB review of changes |
| Documentation overhead | Per-product technical file | QMS documentation + per-product conformity records within QMS |

> *"Module H is built around a full quality control system covering design, development, testing, production and vulnerability handling. Instead of focusing on individual products, it provides a more versatile and flexible framework compared to module B+C."*

### 4.3 Module H QMS Structure and Content

The QMS under Module H must cover the full product lifecycle. CRA Annex VIII Part IV requires the QMS to document and control:

**Design and Development Controls:**
- Procedures for conducting cybersecurity risk assessments (Article 13(2)–(3))
- Secure development lifecycle (SDL) methodologies applied
- Methods for determining Annex I requirement applicability
- Security architecture review processes
- Criteria for selecting cryptographic algorithms and key lengths (state-of-the-art assessment)
- Methods for generating and maintaining SBOMs per release

**Testing and Verification Controls:**
- Security testing programme: penetration testing, fuzzing, static analysis, dynamic analysis
- Test coverage requirements per product risk class
- Test evidence retention standards
- Pre-release CVE scanning against SBOM — gating criteria for release

**Vulnerability Handling Controls:**
- CVD policy maintenance and publication processes
- Internal vulnerability intake, triage, and prioritisation procedures
- Patch development, testing, and release pipeline for security updates
- ENISA Single Reporting Platform (SRP) reporting procedures (24h/72h/14d cascade)
- Third-party component vulnerability upstream reporting (Article 13(6))

**Production and Release Controls:**
- Change classification gate (substantial modification assessment)
- Module C-equivalent production conformity checks
- SBOM update controls per release
- CE marking and DoC update controls triggered by product changes

**Post-Market Monitoring:**
- CVE feed monitoring against the product SBOM
- Security incident monitoring and response
- User notification procedures
- End-of-support lifecycle management

*Capability Block: Module H QMS Document Structure*
```
MODULE H QMS DOCUMENT STRUCTURE

Level 1 — Quality Manual (QM-001)
  Scope of products covered
  Legal basis and regulatory context (CRA Art. 32, Annex VIII Part IV)
  QMS architecture and interaction of processes
  Management responsibility and resources

Level 2 — Procedures (PRO-xxx)
  PRO-001: Product classification and scope assessment
  PRO-002: Cybersecurity risk assessment
  PRO-003: Secure development lifecycle (SDL)
  PRO-004: SBOM generation and management
  PRO-005: Security testing and test evidence management
  PRO-006: Vulnerability intake and triage
  PRO-007: CVD policy management
  PRO-008: Security update development and release
  PRO-009: ENISA/CSIRT reporting (Article 14)
  PRO-010: Change classification and substantial modification assessment
  PRO-011: Technical documentation compilation and maintenance
  PRO-012: Declaration of Conformity management
  PRO-013: CE marking controls
  PRO-014: Post-market monitoring and surveillance
  PRO-015: End-of-support lifecycle management
  PRO-016: Internal audit and management review
  PRO-017: NB relationship management and surveillance coordination

Level 3 — Work Instructions (WI-xxx)
  [Tool-specific procedures, e.g. SBOM generation in CycloneDX,
   Trivy scan procedure, NB submission packaging]

Level 4 — Records (REC-xxx)
  Risk assessment records, test reports, vulnerability logs,
  SBOM versions, DoC versions, NB correspondence, audit records
```

### 4.4 Module H Notified Body Assessment Process

The NB conducts an initial QMS assessment followed by periodic surveillance:

**Initial Assessment:**
1. Submit QMS documentation package to NB
2. NB conducts documentation review (desk audit) — typically 4–6 weeks
3. NB conducts on-site audit of QMS implementation — reviews QMS implementation against CRA Annex VIII Part IV requirements, examines representative products, interviews process owners
4. NB issues assessment report with any non-conformities
5. Manufacturer addresses non-conformities (typically 4–12 weeks)
6. NB issues **Module H quality system approval certificate**
7. First products placed on market under Module H; manufacturer affixes CE marking with NB NANDO number

**Ongoing Surveillance:**
- Periodic surveillance audits by NB — typically annual or biennial
- Unannounced inspections are permitted
- Manufacturer must notify NB of planned changes to the QMS or product scope additions
- New products added to the QMS scope require an extension assessment (not a full initial assessment)

### 4.5 Module H Timing Benchmark

| Phase | Estimated Duration |
|---|---|
| QMS design and documentation | 3–6 months |
| Internal QMS audit and dry run | 4–8 weeks |
| NB application and intake | 2–4 weeks |
| NB documentation review | 4–6 weeks |
| NB on-site audit | 1–2 weeks |
| Non-conformity remediation | 4–12 weeks |
| Certificate issuance | 2–4 weeks |
| **Total (new QMS, Module H)** | **8–14 months** |
| **Adding a new product to established QMS** | **4–8 weeks** |

The initial investment in Module H is therefore higher than Module B+C for a single product, but the per-product cost for subsequent products within scope is substantially lower.

***

## Part V — The European Cybersecurity Certification Pathway (EUCC)

### 5.1 Article 27 — Presumption of Conformity via Certification

**Article 27(9)** establishes that products certified under a European cybersecurity certification scheme at assurance level **"substantial" or higher** benefit from a presumption of conformity with the CRA requirements covered by the scheme:

> *"Products with digital elements that have been certified under a European cybersecurity certification scheme pursuant to Article 52 of Regulation (EU) 2019/881 shall be presumed to be in conformity with the essential cybersecurity requirements of this Regulation in so far as those requirements are covered by the cybersecurity certificate or parts thereof."*

### 5.2 EUCC — EU Cybersecurity Certification Scheme on Common Criteria

The **EUCC (EU Cybersecurity Certification Scheme on Common Criteria)** is the primary operational certification scheme under the EU Cybersecurity Act (Regulation (EU) 2019/881). It is based on the international standard **ISO/IEC 15408 (Common Criteria)**:

- **EUCC Substantial:** Maps to Common Criteria assurance levels **EAL 1–EAL 4+** — covers most commercial products
- **EUCC High:** Maps to Common Criteria assurance levels **EAL 5–EAL 7** — required for high-assurance products such as HSMs, smart cards, and critical security modules

A valid EUCC certificate at Substantial or High assurance provides presumption of conformity with the CRA requirements covered by the scheme — meaning the manufacturer can reference the EUCC certificate in their DoC rather than demonstrating compliance through Module B+C or H.

### 5.3 EUCC vs. NLF Module Comparison

| Dimension | EUCC Certification | Module B+C | Module H |
|---|---|---|---|
| Based on | ISO/IEC 15408 (Common Criteria) + EU scheme rules | CRA Annex VIII + Annex I requirements | CRA Annex VIII + Annex I requirements |
| Conducted by | ITSEF (IT Security Evaluation Facility) + National Certification Body (NCCA) | CRA Notified Body | CRA Notified Body |
| Output document | EUCC Certificate | EU-type examination certificate | Quality system approval certificate |
| Validity | Typically 5 years, subject to maintenance | Defined period, subject to surveillance | Subject to annual/biennial surveillance |
| Scope | ICT products (broad) | Products with digital elements under CRA | Products with digital elements under CRA |
| Mutual recognition | EU-wide + some international under SOG-IS framework | EU-wide | EU-wide |
| Existing investment | YES — organisations with existing CC/EUCC certification can leverage it | No — CRA-specific process | No — CRA-specific process |
| Mandatory for Critical? | Where Commission mandates by Implementing Regulation | Where no mandatory scheme | Where no mandatory scheme |
| Timeline | 6–18 months (product complexity dependent) | 4–14 months | 8–14 months |

### 5.4 EUCC Process Overview

1. Manufacturer selects a licensed **ITSEF** (IT Security Evaluation Facility) accredited by the relevant national NCCA
2. Manufacturer and ITSEF define the **Target of Evaluation (TOE)** — product boundaries, security objectives, evaluation assurance level
3. Manufacturer develops the **Security Target (ST)** document — claims, threats, security objectives, and security functional requirements
4. ITSEF conducts evaluation against ISO/IEC 15408 and ISO/IEC 18045 (evaluation methodology)
5. ITSEF submits evaluation results to the **Certification Body (CB/NCCA)**
6. CB issues the EUCC certificate
7. Manufacturer references the EUCC certificate in the DoC; the certificate provides presumption of conformity for covered requirements

***

## Part VI — Technical Documentation: Annex VII Complete Reference

### 6.1 Legal Basis

The technical documentation is required by **Article 31** and structured by **Annex VII** of the CRA. It is the evidentiary package that supports both the conformity assessment (whether Module A, B+C, H, or EUCC) and the Declaration of Conformity. It must be maintained and updated throughout the product lifecycle.

### 6.2 Annex VII — Complete Element List with Evidence Guidance

**Element 1 — General Product Description (Annex VII §1)**

Statutory requirement:
> *"a general description of the product with digital elements, including: its intended purpose; versions of software affecting compliance with essential cybersecurity requirements; where the product with digital elements is a hardware product, photographs or illustrations showing external features, marking and internal layout; user information and instructions as set out in Annex II"*

Evidence items:
- Product datasheet or specification document
- Version matrix (hardware versions × software versions covered by this technical file)
- Hardware photographs showing connectors, markings, board layout (for hardware products)
- Complete Annex II user information package (see Part VII)

**Element 2 — Design, Development, Production, and Vulnerability Handling Description (Annex VII §2)**

Statutory requirement:
> *"a description of the design, development and production of the product with digital elements and vulnerability handling processes, including: necessary information on the design and development of the product with digital elements, including, where applicable, drawings and schemes and a description of the system architecture explaining how software components build on or feed into each other and integrate into the overall processing; necessary information and specifications of the vulnerability handling processes put in place by the manufacturer, including the software bill of materials, the coordinated vulnerability disclosure policy, evidence of the provision of a contact address for the reporting of the vulnerabilities and a description of the technical solutions chosen for the secure distribution of updates; necessary information and specifications of the production and monitoring processes of the product with digital elements and the validation of those processes"*

Evidence items:
- System architecture diagram (component decomposition, trust boundaries, data flow)
- Software component dependency diagram
- SDL process documentation (threat modelling methodology, secure coding standards)
- SBOM in CycloneDX or SPDX format (covering all top-level dependencies minimum)
- CVD policy document (publicly accessible URL)
- Single point of contact (security email, `security.txt` URL)
- Update mechanism description (signing infrastructure, distribution channel security, rollback protection)
- Production / CI-CD process documentation (build integrity, reproducibility)
- Post-market monitoring process description

**Element 3 — Cybersecurity Risk Assessment (Annex VII §3)**

Statutory requirement:
> *"an assessment of the cybersecurity risks against which the product with digital elements is designed, developed, produced, delivered and maintained pursuant to Article 13, including how the essential cybersecurity requirements set out in Part I of Annex I are applicable"*

Evidence items:
- Complete risk assessment document (see Capability Block in Part II, Step 2)
- Annex I Part I applicability determination (all 13 requirements addressed; non-applicable documented with justification per Article 13(4))
- Annex I Part II applicability determination (all 8 VH requirements)
- Threat model (STRIDE, PASTA, LINDDUN, or equivalent)

**Element 4 — Support Period Determination (Annex VII §4)**

Statutory requirement:
> *"relevant information that was taken into account to determine the support period pursuant to Article 13(8) of the product with digital elements"*

Evidence items:
- Support period rationale document
- Expected useful life analysis (market research, user surveys, product domain norms)
- Support period end-date declaration (minimum: 5 years from market placement, unless shorter justified)
- Support period communicated at point of purchase (evidence of label or webpage)

**Element 5 — Standards and Technical Specifications (Annex VII §5)**

Statutory requirement:
> *"a list of the harmonised standards applied in full or in part the references of which have been published in the Official Journal of the European Union, common specifications... and, where those harmonised standards, common specifications or European cybersecurity certification schemes have not been applied, descriptions of the solutions adopted to meet the essential cybersecurity requirements set out in Parts I and II of Annex I, including a list of other relevant technical specifications applied. In the event of partly applied harmonised standards, common specifications or European cybersecurity certification schemes, the technical documentation shall specify the parts which have been applied"*

Evidence items:
- Standards table: for each harmonised standard cited, specify standard number, title, OJEU publication date, and which Annex I requirements it covers
- Where no harmonised standard exists: requirements-to-solutions mapping table (mapping each Annex I requirement to the specific technical measure implemented, with evidence reference)
- Other relevant technical specifications (e.g., IEC 62443-4-2:2019 as non-harmonised technical reference, NIST SP 800-82, ISO/IEC 27001)
- Partially applied standards: table of which clauses applied and which excluded, with justification

**Element 6 — Test Reports (Annex VII §6)**

Statutory requirement:
> *"reports of the tests carried out to verify the conformity of the product with digital elements and of the vulnerability handling processes with the applicable essential cybersecurity requirements as set out in Parts I and II of Annex I"*

Evidence items:
- Penetration test report (summarised; must cover all relevant Annex I security properties at appropriate depth for product risk class)
- Static application security testing (SAST) report
- Dynamic application security testing (DAST) report (where applicable)
- Dependency vulnerability scan report (Trivy, Grype, or equivalent — scanned against current SBOM)
- Secure configuration review report
- Update mechanism integrity test evidence (signing verification, rollback test)
- Authentication and access control test results
- Vulnerability handling process test/dry-run evidence

**Element 7 — EU Declaration of Conformity (Annex VII §7)**

Statutory requirement: *"a copy of the EU declaration of conformity"*

Evidence items: Signed copy of the complete Annex V DoC (see Part VI below).

**Element 8 — SBOM (Annex VII §8)**

Statutory requirement:
> *"where applicable, the software bill of materials, further to a reasoned request from a market surveillance authority provided that it is necessary in order for that authority to be able to check compliance with the essential cybersecurity requirements set out in Annex I"*

Note: Element 8 is not proactively disclosed publicly by default — it is provided to market surveillance authorities on reasoned request. However, the SBOM must exist and be current as part of the technical file. In practice, for Module B+C and H, the NB will request the SBOM as part of the examination.

### 6.3 Technical File Version Control and Retention

- Version the technical file with a clear change log
- Retain for **10 years** from the date of first EU market placement **or** the support period end-date, whichever is longer
- The technical file must be available to market surveillance authorities within a reasonable period of a reasoned request — plan for retrieval within 24–48 hours
- Where products are updated, update the technical file before CE marking the new version

*Capability Block: Technical File Structure*
```
TECHNICAL FILE STRUCTURE — CRA REGULATION (EU) 2024/2847

Product: [Name]          Model: [Model]       Version: [HW/SW]
File Ref: TF-[Code]-[Year]-[Rev]    Date: [YYYY-MM-DD]
Prepared by: [Name, Role]    Reviewed by: [Name, Role]

PART 1 — PRODUCT OVERVIEW (Annex VII §1)
  1.1 Product description and intended purpose
  1.2 Version matrix (HW × SW versions in scope)
  1.3 Hardware photographs and layout diagrams
  1.4 Annex II user information (copy)

PART 2 — DESIGN AND DEVELOPMENT (Annex VII §2)
  2.1 System architecture diagram
  2.2 Software component architecture and dependency diagram
  2.3 Data flow diagrams (DFDs)
  2.4 SDL process documentation
  2.5 SBOM — [product-vX.Y.Z.cdx.json / spdx.xml]
  2.6 CVD policy (current version + URL)
  2.7 Single point of contact evidence
  2.8 Update mechanism security description
  2.9 CI/CD and build integrity documentation

PART 3 — CYBERSECURITY RISK ASSESSMENT (Annex VII §3)
  3.1 Threat model (STRIDE / PASTA / other)
  3.2 Risk assessment report [RA-version-date.pdf]
  3.3 Annex I Part I applicability matrix
  3.4 Annex I Part II applicability matrix
  3.5 Non-applicability justifications (Article 13(4))

PART 4 — SUPPORT PERIOD DOCUMENTATION (Annex VII §4)
  4.1 Support period rationale
  4.2 Expected useful life analysis
  4.3 Support period end-date declaration
  4.4 Evidence of point-of-purchase communication

PART 5 — STANDARDS AND SPECIFICATIONS (Annex VII §5)
  5.1 Harmonised standards applied table
  5.2 Requirements-to-solutions mapping (where no hEN)
  5.3 Other technical specifications referenced
  5.4 Partial application declarations

PART 6 — TEST REPORTS (Annex VII §6)
  6.1 Penetration test report [pentest-vX.Y.pdf]
  6.2 SAST/DAST results summary
  6.3 Dependency vulnerability scan report [scan-YYYY-MM-DD.pdf]
  6.4 Secure configuration review
  6.5 Update mechanism integrity test evidence
  6.6 Authentication / access control test results
  6.7 VH process dry-run evidence

PART 7 — DECLARATION OF CONFORMITY (Annex VII §7)
  7.1 Signed EU Declaration of Conformity [DoC-[code]-[date].pdf]

PART 8 — SBOM (Annex VII §8)
  8.1 SBOM file [product-vX.Y.Z.cdx.json]
  [ACCESS: Available to market surveillance authorities on request only]

APPENDICES
  A: NB EU-type examination certificate (Module B+C) or NB approval certificate (Module H)
  B: EUCC certificate (if applicable)
  C: Vulnerability log (live record, restricted access)
  D: Incident log (live record, restricted access)
  E: Document change log
```

***

## Part VII — EU Declaration of Conformity (Annex V): Complete Requirements

### 7.1 Legal Basis

The EU Declaration of Conformity (DoC) is required by **Article 28** and structured by **Annex V**. It is the manufacturer''s formal legal declaration of product compliance. It is the capstone document of the conformity assessment — it cannot be signed until assessment is complete.

### 7.2 Mandatory Elements — Annex V

The following eight elements are mandatory in every CRA DoC:

| # | Element | Statutory Basis | Detail |
|---|---|---|---|
| 1 | **Product name and type** | Annex V §1 | Product name, model/type designation, and sufficient additional information to uniquely identify the product — may include batch/serial number scope, HW and SW version identifiers, and a photograph where appropriate for traceability |
| 2 | **Manufacturer identification** | Annex V §2 | Full legal name and registered postal address of the manufacturer; for non-EU manufacturers, also the EU authorised representative''s name and address |
| 3 | **Sole responsibility statement** | Annex V §3 | Verbatim: *"This declaration of conformity is issued under the sole responsibility of the manufacturer."* — This exact wording is legally required |
| 4 | **Object of the declaration** | Annex V §4 | Identification of the product allowing traceability; where helpful, a short description of the product''s intended purpose |
| 5 | **Conformity statement** | Annex V §5 | *"The object of the declaration described above is in conformity with the relevant Union harmonisation legislation: Regulation (EU) 2024/2847 of the European Parliament and of the Council of 23 October 2024 on horizontal cybersecurity requirements for products with digital elements."* Include any other applicable EU legislation (RED, MDR, Machinery Regulation, etc.) if a combined DoC is issued |
| 6 | **Standards and specifications applied** | Annex V §6 | List of harmonised standards (with OJEU publication date), common specifications, or European cybersecurity certification schemes applied; if no harmonised standard applied, state: *"No harmonised standards applied. Conformity demonstrated through [approach description]"* |
| 7 | **Notified body reference** | Annex V §7 | Required only when a notified body was involved: NB name, NANDO number, description of conformity assessment procedure performed, EU-type examination certificate reference number (Module B+C) or quality system approval certificate reference (Module H) |
| 8 | **Signature block** | Annex V §8 | Place and date of issue; name and function of authorised signatory; handwritten or qualified electronic signature |

### 7.3 Recommended Additional Information

The following are not mandatory in Annex V but are strongly recommended by compliance practitioners and regulators:

| Optional Field | Rationale |
|---|---|
| Declaration number (e.g., `DoC-SSP3000-2027-001`) | Version control and cross-referencing in the technical file |
| Support period end-date (month/year) | CRA Article 13(8) requires communication at point of purchase; including in DoC aids compliance demonstration |
| Vulnerability reporting contact / CVD policy URL | Supports Article 13(17) obligations |
| Link to full technical documentation | Facilitates market surveillance authority access |
| First EU market placement date | Establishes the 10-year retention clock |

### 7.4 Complete DoC Template

```
─────────────────────────────────────────────────────────────────
                EU DECLARATION OF CONFORMITY
        Regulation (EU) 2024/2847 (Cyber Resilience Act)
─────────────────────────────────────────────────────────────────
DECLARATION NUMBER: DoC-[ProductCode]-[YYYY]-[Sequence]

1. PRODUCT IDENTIFICATION
   Product name:      [Full product name]
   Model / type:      [Model designation]
   Hardware version:  [HW-vX.Y] (if applicable)
   Software version:  [SW-vX.Y.Z] (if firmware/software)
   Batch / serial:    [Batch range or serial number format]
   Description:       [One sentence: product type, connectivity,
                       intended use environment]

2. MANUFACTURER
   Legal name:   [Registered company name]
   Address:      [Street, City, Postcode, Country]
   Website:      [https://www.company.com]
   Email:        [legal@company.com]

   [If non-EU manufacturer, add:]
   EU Authorised Representative:
   Legal name:   [EU Rep company name]
   Address:      [EU address]

3. SOLE RESPONSIBILITY
   This declaration of conformity is issued under the sole
   responsibility of the manufacturer.

4. OBJECT OF THE DECLARATION
   The product identified in Section 1 above is the object of
   this declaration.

5. CONFORMITY STATEMENT
   The object of the declaration described above is in conformity
   with the relevant Union harmonisation legislation:

   ■ Regulation (EU) 2024/2847 of the European Parliament and
     of the Council of 23 October 2024 on horizontal
     cybersecurity requirements for products with digital
     elements (Cyber Resilience Act).

   [Add other applicable regulations as applicable, e.g.:]
   □ Directive 2014/53/EU (Radio Equipment Directive — RED)
   □ Regulation (EU) 2017/745 (Medical Device Regulation — MDR)
   □ Directive 2006/42/EC (Machinery Directive)

6. HARMONISED STANDARDS AND TECHNICAL SPECIFICATIONS APPLIED
   [If harmonised CRA standard is available and applied:]
   ■ [EN XXXXX:YYYY] — [Standard title] — Published in OJEU
     [date], covering Annex I Part I/II requirements [(list)]

   [If no harmonised CRA standard available (current situation):]
   No harmonised CRA standards published in the Official Journal
   of the European Union were applied. Conformity with
   Regulation (EU) 2024/2847 Annex I has been demonstrated
   through the following technical specifications and measures:

   Other technical specifications applied:
   ■ IEC 62443-4-2:2019 — Technical security requirements for
     IACS components (applied as technical reference, not
     harmonised standard)
   ■ ISO/IEC 27001:2022 — Information security management
   ■ [Other standards as applicable]

   See Technical Documentation Ref. [TF-code-date] for the
   full Annex I requirements-to-solutions mapping.

7. CONFORMITY ASSESSMENT PROCEDURE AND NOTIFIED BODY
   [Module A — No notified body:]
   Conformity assessment procedure: Internal control
   (Module A, Annex VIII Part I of Regulation (EU) 2024/2847).
   No notified body was involved in this assessment.

   [Module B+C — Notified body involved:]
   Conformity assessment procedure: EU-type examination
   (Module B) followed by conformity to type based on internal
   production control (Module C), Annex VIII Parts II and III
   of Regulation (EU) 2024/2847.
   Notified Body: [NB Legal Name]
   NANDO Number: [####]
   EU-Type Examination Certificate No.: [Certificate Ref]
   Certificate date: [YYYY-MM-DD]
   Certificate validity: [YYYY-MM-DD]

   [Module H — Full QA:]
   Conformity assessment procedure: Conformity based on full
   quality assurance (Module H), Annex VIII Part IV of
   Regulation (EU) 2024/2847.
   Notified Body: [NB Legal Name]
   NANDO Number: [####]
   Quality System Approval Certificate No.: [Certificate Ref]

   [EUCC certification:]
   European Cybersecurity Certification:
   Scheme: EU Cybersecurity Certification Scheme on Common
   Criteria (EUCC), pursuant to Regulation (EU) 2019/881.
   Assurance Level: [Substantial / High]
   Certificate No.: [Certificate Ref]
   Issuing body: [NCCA name]
   Certificate validity: [YYYY-MM-DD]

8. ADDITIONAL INFORMATION (RECOMMENDED)
   Declaration number:   DoC-[code]-[YYYY]-[seq]
   Security support until: [Month YYYY] (minimum 5 years from
                          first EU market placement)
   First EU placement:   [YYYY-MM-DD]
   Vulnerability reports: security@company.com
   CVD Policy:           https://company.com/security
   Technical documentation: Available to competent authorities
                          upon reasoned request at address above.

─────────────────────────────────────────────────────────────────
   Signed for and on behalf of [Company Legal Name]:

   Place:  [City, Country]
   Date:   [DD Month YYYY]

   Name:      [Full Name]
   Function:  [Title, e.g. Head of Product Compliance /
               Chief Technology Officer / Director of Engineering]
   Signature: ___________________________________
               [Handwritten or qualified electronic signature]
─────────────────────────────────────────────────────────────────
```

### 7.5 DoC Management Obligations

- The DoC must be **translated** into the official language(s) of each EU Member State where the product is sold
- A **simplified DoC** (Annex VI) may be provided with the product, containing only the internet address at which the full DoC can be accessed; the full DoC must be genuinely accessible at that URL throughout the retention period
- The DoC must be **updated** when:
  - A substantial modification occurs
  - Product versions added to the scope
  - A new conformity assessment procedure is completed
  - New harmonised standards are applied
- The DoC must be retained for **10 years** from the date of market placement, or for the support period, whichever is longer
- The signed DoC must travel with the product (or be accessible via simplified DoC URL)

***

## Part VIII — The Notified Body Capacity Crisis: Practical Guidance

### 8.1 The Scale of the Problem

The notified body system under the CRA faces a structural capacity problem that manufacturers must factor into their planning:

- **Designation lag:** Accreditation and designation of a new NB typically takes 12–18 months from application
- **No designated NBs as of June 2026:** The CRA''s notified body rules began applying on 11 June 2026, but as of the same date, no CRA notified bodies had been formally designated
- **Demand concentration:** Important Class I (without harmonised standard) + Important Class II + Critical products all require NB involvement — representing thousands of product types across the EU
- **Timeline concentration:** Full CRA application is 11 December 2027 — all manufacturers requiring NB assessment must complete it within approximately 18 months of the first designations appearing

> *"Accreditation and designation of new bodies typically takes 12 to 18 months, which means the pool of CRA Notified Bodies will remain small well into 2027."*

### 8.2 Practical Mitigation Strategies

**Strategy 1 — Engage Early with Candidate Bodies**

Several existing conformity assessment bodies active under RED, MDR, and other CE marking frameworks have announced CRA readiness programmes. Contact them now for:
- Scoping calls (at no cost) to assess their likely CRA scope and capability
- Preliminary submissions to identify technical documentation gaps before formal engagement
- Queue registration (informal, not binding, but establishes relationship)

Organisations known to be preparing CRA notified body capacity include: Applus+ Laboratories, TÜV Rheinland, TÜV SÜD, BSI Group (UK, also operates in EU), SGS, Bureau Veritas, and NMi (Netherlands).

**Strategy 2 — Complete All Technical Documentation Before Engagement**

NB fees and timelines are driven by the amount of deficiency-remediation work required. A manufacturer who submits a complete, high-quality technical file will complete assessment faster and at lower cost than one who uses the NB process to discover gaps.

**Strategy 3 — Consider EUCC if CC Certification is Already Planned**

For organisations with products that already undergo or are planned for Common Criteria evaluation, the EUCC pathway is the most efficient route to CRA presumption of conformity — the same evaluation process that generates the CC/EUCC certificate simultaneously addresses CRA conformity.

**Strategy 4 — Consider Module H if Product Portfolio is Broad**

For manufacturers with five or more Important Class II products, Module H is almost certainly more economical than repeated Module B+C assessments. The one-time QMS investment pays back quickly when new products can be added to the approved QMS scope via extension assessments rather than full re-examination.

**Strategy 5 — Do Not Wait for Harmonised Standards for Class I**

For Important Class I products, the temptation is to wait until harmonised standards are published (expected Q2 2027) to use Module A self-assessment. This is a high-risk strategy: if standards are delayed, or if the standard does not fully cover the product''s specific requirements, the manufacturer faces the notified body backlog in the final months before December 2027.

### 8.3 NB Engagement Readiness Checklist

```
NOTIFIED BODY ENGAGEMENT READINESS CHECKLIST
Product: [Name, Version]         Classification: [Important Class I/II / Critical]
Target CE Date: [YYYY-MM-DD]     Module: [B+C / H / EUCC]
---------------------------------------------------------------------------
PRE-ENGAGEMENT (Complete before first NB contact)
  □ Product classification confirmed and documented (CDR completed)
  □ Annex I applicability matrix drafted (identifies which requirements apply)
  □ Cybersecurity risk assessment at ≥ draft stage
  □ System architecture diagram available
  □ SBOM generated for current version
  □ CVD policy drafted and published (or URL prepared)
  □ Pre-release vulnerability scan conducted
  □ SDL process documented
  □ Support period determined and rationale documented
  □ Technical file structure created (even if not all evidence complete)

ENGAGEMENT INITIATION (At first NB contact)
  □ NANDO verified as covering CRA (or confirmed as preparing for designation)
  □ Scoping call completed; NB domain competence assessed
  □ Preliminary evidence review agreed (desk review before formal application)
  □ Timeline discussed; estimated certificate date confirmed vs target CE date
  □ Cost estimate obtained

APPLICATION SUBMISSION
  □ Complete Annex VII technical documentation packaged and QC''d
  □ Representative product sample or test access arranged
  □ NB application form completed
  □ Draft DoC prepared (unsigned)
  □ Application submitted; intake confirmation received

ASSESSMENT PHASE
  □ Technical documentation review report received
  □ Non-conformities logged and remediation owner assigned
  □ All non-conformities resolved; evidence of resolution submitted
  □ Product examination completed
  □ Certificate issuance confirmed

POST-CERTIFICATE
  □ EU-type examination certificate received and stored in technical file
  □ DoC signed by authorised signatory
  □ CE marking applied to product/packaging/documentation
  □ Surveillance schedule confirmed with NB
  □ Technical documentation updated with certificate reference
```

***

## Part IX — CE Marking Rules and Common Mistakes

### 9.1 CE Marking Application Requirements

**Article 30** governs CE marking. The CE mark must be:
- **Visible:** Clearly visible on the product, packaging, or accompanying documentation
- **Legible:** Proportionate to the size of the product; minimum height 5mm where product size allows
- **Indelible:** Not easily removed or detached; for physical products, permanently affixed (engraved, printed, or labelled with tamper-evidence)
- **Accompanied by the NB number:** Where Module B+C or H was used, the CE mark must be followed by the NB''s NANDO number (4 digits)

**For software-only products:**
- The CE mark may be included in the accompanying digital documentation, on the product download page, or in the Declaration of Conformity
- It is not required to appear in the software''s user interface, though this is common practice

**Timing:** The CE mark may only be affixed **after** the conformity assessment is complete, the DoC is drawn up and signed, and all technical documentation is compiled. Premature affixation of CE marking is a violation of Article 30 and triggers Tier 2 penalties.

### 9.2 Common Mistakes to Avoid

| Mistake | Consequence | Prevention |
|---|---|---|
| Classifying as Default without checking Annex III/IV | Invalid Module A assessment; CE mark invalidated | Conduct structured classification analysis against Implementing Reg. 2025/2392 |
| Signing DoC before conformity assessment complete | Legal violation under Article 28; DoC legally invalid | DoC signature is always the final step, after all evidence exists |
| Using DoC as substitute for technical documentation | Market surveillance authority will find no evidence file | Maintain separate full technical file; DoC is a summary, not the evidence |
| Not updating DoC after software update that constitutes substantial modification | CE mark becomes invalid for updated version | Implement Module C change classification gate for every release |
| Failing to translate DoC into Member State languages | Non-compliance with market access requirements | Identify all EU markets at market launch; plan translations in advance |
| Using a stale SBOM (from a different version) | Inaccurate conformity evidence; vulnerability monitoring failure | Integrate SBOM generation into every CI/CD build |
| Missing NB identification number on CE mark (Module B+C/H) | CE mark does not meet Article 30 requirements | Include NANDO number immediately after CE symbol |
| Using a simplified DoC URL that becomes dead link | Violation — simplified DoC URL must remain accessible for 10 years | Use a permanent, stable URL; include in long-term URL management policy |
| Failing to retain technical documentation for 10 years | Violation of Article 13(13); Tier 2 penalty | Implement document lifecycle management with 10-year retention policy |

***

## Part X — Master CE Marking Programme Gantt: Suggested Timeline

The following programme timeline applies to a new product targeting 11 December 2027 CE marking that requires Module B+C (Important Class II):

| Month | Activity | Owner | Output |
|---|---|---|---|
| M1 | Product classification and scope assessment | Compliance Lead | Classification Decision Record |
| M1–M2 | Cybersecurity risk assessment initiation; threat modelling | Security Architect | Draft Risk Assessment |
| M2–M3 | Annex I requirements mapping; identify gaps | Product Security | Requirements gap analysis |
| M3–M6 | Security control implementation (remediate gaps) | Engineering | Implemented controls |
| M3–M4 | SBOM tooling integration into CI/CD | DevOps / Engineering | SBOM per build |
| M4–M5 | CVD policy published; single point of contact live | Legal / Security | CVD policy URL |
| M4–M5 | Support period decision; point-of-purchase communication prepared | Product / Legal | Support period documentation |
| M5–M6 | Internal security testing (pentest, SAST/DAST, vuln scan) | Security Testing | Test reports |
| M5–M6 | Technical documentation Part 1–5 compiled | Compliance Lead | Draft Technical File |
| M6 | Notified body identified; scoping call; queue registration | Compliance Lead | NB shortlist |
| M7 | Preliminary evidence review with NB | NB + Manufacturer | Gaps identified |
| M7–M8 | Remediate NB pre-submission observations | Engineering | Remediation evidence |
| M8 | Formal application submission to NB | Compliance Lead | Application submitted |
| M8–M9 | NB technical documentation review | NB | Review report |
| M9 | Remediate NB documentation findings (if any) | Engineering/Compliance | Updated tech file |
| M9–M10 | NB product examination and testing | NB | Examination report |
| M10 | EU-type examination certificate issued | NB | Certificate |
| M10–M11 | DoC prepared, reviewed by legal, signed | Legal + Compliance + CTO/CEO | Signed DoC |
| M11 | CE marking applied to product/documentation | Product/Design | CE-marked product |
| M11–M12 | Buffer for unexpected delays | — | — |
| **M12** | **Product placed on EU market; fully CRA compliant** | Management | **CE-marked product on market** |

This timeline assumes a **well-prepared organisation** with no major technical gaps discovered. Organisations discovering significant Annex I implementation gaps in months M3–M5 should add 2–4 months for remediation. The earliest viable start for a December 2027 deadline is therefore approximately January–February 2027.

---

## References

1. [Step 6: Which Conformity Assessment Procedure Applies? - LinkedIn](https://www.linkedin.com/pulse/step-6-which-conformity-assessment-procedure-applies-michael-jesse-szpkf) - If the notified body concludes that the product complies with the CRA, it issues an EU-type examinat...

2. [Decoding the Cyber Resilience Act – Part 2: A lifecycle approach to ...](https://www.freshfields.com/en/our-thinking/blogs/technology-quotient/decoding-the-cyber-resilience-act-part-2-a-lifecycle-approach-to-compliance-102mkdk) - Module H (full quality assurance) mandates that the manufacturer operate and maintain a documented q...

3. [Cyber Resilience Act | Shaping Europe''s digital future](https://digital-strategy.ec.europa.eu/en/policies/cyber-resilience-act) - Introducing the Cyber Resilience Act: the EU''s new plan to make sure all digital products are safe f...

4. [CRA Compliance Matrix: Every Obligation, with Article References](https://www.cyberresilienceact.eu/compliance-matrix.html) - Complete the conformity assessmentNEWCarry out the applicable procedure (Module A, or B+C / H / Noti...

5. [CRA EU Declaration of Conformity: Template and Elements](https://craevidence.com/cra-compliance/declaration-of-conformity) - Technical Documentation. What CRA technical documentation must contain (Annex VII section by section...

6. [Cyber Resilience Act - Conformity assessment](https://digital-strategy.ec.europa.eu/en/policies/cra-conformity-assessment) - Default category of products (e.g., memory chips, mobile apps, smart speakers, computer games): self...

7. [CRA Conformity Assessment: Self-Assessment vs Third-Party ...](https://complaro.com/blog/cra-conformity-assessment-guide) - Module A — Internal Control (Self-Assessment): The manufacturer assesses conformity internally. No e...

8. [Cyber-Resilience Act (CRA) - Secure-by-Design Handbook](https://www.securebydesignhandbook.com/docs/standards/eu/cra-overview) - Technical documentation. CRA Art. 31, Annex VII, Create & maintain technical file with risk assessme...

9. [Understanding the EU Cyber Resilience Act Requirements](https://finitestate.io/blog/conformity-assessments-eu-cra-requirements) - TL;DR A CRA conformity assessment is how you prove a connected product meets the EU Cyber Resilience...

10. [Notified Bodies Under the CRA: When You Need One and ... - Seentrix](https://seentrix.com/blog/cra-notified-bodies) - Notified body always involved. You choose between Module B+C (EU-type examination plus conformity to...

11. [On 11 June 2026, the CRA''s Rules on Notified Bodies Started to ...](https://www.cyberresilienceact.eu/news/cra-notified-bodies-rules-apply-11-june-2026.html) - On 11 June 2026, the CRA''s Rules on Notified Bodies Started to Apply, but None Are Designated Yet. T...

12. [CRA Harmonised Standards Guide — Type A, B and C](https://eu-cyber-laws.com/cra/standards-guide/) - CENELEC developing A11:2026 amendments for EN IEC 62443-4-1 and -4-2. Expected. First harmonised sta...

13. [Cyber Resilience Act text, Article 13](https://www.european-cyber-resilience-act.com/Cyber_Resilience_Act_Article_13.html) - Manufacturers shall ensure that products with digital elements are accompanied by the information an...

14. [CE Marking to Show CRA compliance - Qt](https://www.qt.io/cyber-resilience-act/ce-marking) - 1. Meet the essential CRA requirements. · 2. Create the required technical documentation. · 3. Under...

15. [Notified bodies - Internal Market, Industry, Entrepreneurship and SMEs](https://single-market-economy.ec.europa.eu/single-market/goods/building-blocks/notified-bodies_en) - Notified bodies. A notified body is an organisation designated by an EU country to assess the confor...

16. [The CRA Deadline Is Fixed. Assessment Capacity Isn''t - NMi](https://nmi.nl/cra-assessment-capacity-lab-scarcity/) - Accreditation and designation of new bodies typically takes 12 to 18 months, which means the pool of...

17. [EU Cyber Resilience Act (CRA) Compliance - Applus+ Laboratories](https://www.appluslaboratories.com/global/en/resource-center/eu-cyber-resilience-act/cra-compliance-services) - Module H – Conformity. The notified body evaluates the system and conducts ongoing surveillance to e...

18. [CRA Conformity Assessment: Self-Assessment or Notified Body](https://craevidence.com/cra-compliance/conformity-assessment) - Module B · EU-Type exam. Notified Body selected; Application submitted; Technical documentation prov...

19. [Cyber Resilience Act—Notified Body Services - Applus+ Laboratories](https://www.appluslaboratories.com/global/en/what-we-do/service-sheet/cyber-resilience-act-notified-body) - Module B + C is the primary third-party route under the CRA for many products: Module B (EU-type exa...

20. [EU Cyber Resilience Act: What Product Teams Should Do Now](https://www.linkedin.com/pulse/eu-cyber-resilience-act-what-product-teams-should-do-now-leitner-ll66f) - Months 2-4 handle gap analysis requiring cross-functional assessment. Months 3-8 establish the vulne...

21. [What is module H? How does it work? - CRA FAQ](https://cra.orcwg.org/faq/official/faq_6-3/) - Module H, set out in Part IV of Annex VIII, is a conformity assessment procedure in which the manufa...

22. [Cyber Resilience Act: The Complete Survival Guide for Manufacturers](https://www.cclab.com/news/cyber-resilience-act-the-complete-survival-guide-for-manufacturers) - Coordination with Notified Bodies: Guiding you through Module B+C or the comprehensive Module H asse...

23. [Cyber Resilience Act implementation via EUCC and its applicable ...](https://certification.enisa.europa.eu/publications/cyber-resilience-act-implementation-eucc-and-its-applicable-technical-elements_en) - The CRA applies to all products with digital elements and categorizes them by risk level, including ...

24. [EU Cybersecurity Certification Scheme on Common Criteria (EUCC)](https://www.brightsight.com/eucc) - The EUCC scheme provides a unified framework for cybersecurity certification, ensuring that a single...

25. [[PDF] EUCC, differences with CCRA/SOGIS Common Criteria scheme.](https://www.appluslaboratories.com/en/dam/jcr:d65e3db0-9f1f-4fd0-a0f5-1266877db673/EUCC_vs_CCRA_SOGIS.pdf) - The assurance levels of EUCC scheme are ''HIGH'' and ''SUBSTANTIAL'' depending on the assurance levels o...

26. [Mapping EUCC to Common Criteria: A Technical Overview of ...](https://blog.qima.com/due-cybersecurity/mapping-eucc-to-common-criteria-a-technical-overview-of-assurance-levels-and-evaluation-requirements) - Products certified at EUCC Substantial or High level qualify for a presumption of conformity with th...

27. [Common Criteria (EUCC) | Dutch NCCA](https://www.dutchncca.nl/eu-cybersecurity-certification/common-criteria) - The EUCC scheme covers a wide range of security requirements, by offering two of the security assura...

28. [Annex VII Cyber Resilience Act – CONTENT OF THE TECHNICAL ...](https://enobyte.com/en/legal/cra/annex-vii/) - Annex VII. CONTENT OF THE TECHNICAL DOCUMENTATION. 1. a general description of the product with digi...

29. [[PDF] CRA Standards Unlocked - CEN-CENELEC](https://www.cencenelec.eu/media/CEN-CENELEC/Events/Webinars/2026/2026-03-18_cra_unlocked_cybersecurity_requirements_deep-dive_tc224wg17_cra.pdf) - Article 13(13) Manufacturers shall keep the technical documentation and the EU declaration of confor...

30. [CRA Annex V: EU Declaration of Conformity Template - CVD Portal](https://cvdportal.com/cra/annex-v) - CRA Annex V specifies all required fields in the EU Declaration of Conformity: product name, manufac...

31. [CRA Declaration of Conformity (DoC) Guide: How to Build ... - Regulus](https://goregulus.com/cra-documentation/cra-declaration-of-conformity/) - Learn how to draft a CRA Declaration of Conformity for the Cyber Resilience Act. Structure, mandator...

32. [On 11 June 2026, the CRA''s Rules on Notified Bodies Started to ...](https://www.cyberresilienceact.eu/nl/news/cra-notified-bodies-rules-apply-11-june-2026.html) - On 11 september 2026 the 24-hour vulnerability reporting duty under Article 14 begins. Three months ...

33. [No Market Approval Without Cybersecurity: Implementing the CRA](https://www.onekey.com/resource/no-market-approval-without-cybersecurity-how-companies-can-successfully-implement-the-cra) - The EU Cyber Resilience Act (CRA) makes cybersecurity a must for CE marking. Learn how companies can...

34. [CE Marking for Software Under the CRA: Step-by-Step - Complaro](https://complaro.com/blog/cra-ce-marking-software) - Learn when CE marking is required for software under the CRA, how to complete conformity assessment,...

35. [When Is Software "Placed on the Market" Under the EU Cyber ...](https://www.cybercertlabs.com/case_studies/software-placed-on-market-eu-cyber-resilience-act/) - If an update does cross the substantial modification threshold, you''ll need to comply with the CRA i...

36. [Understanding The EU CRA''s SBOM & Technical Documentation ...](https://finitestate.io/blog/eu-cra-sbom-technical-documentation-guide) - CRA SBOMs must use a commonly used, machine-readable format such as SPDX, CycloneDX, or SWID, and co...

---

_Related: [Cyber Resilience Act overview](/en/cra) · [CRA CE Marking Pathways](/en/cra-ce-marking-pathways) · [CRA Complete Technical Reference](/en/cra-technical-reference) · [IEC 62443](/en/iec-62443) · [NIS2](/en/nis2)_', true, 'CRA CE Marking Pathways: Conformity Assessment Deep Reference | OXOT', 'How to CE-mark a product with digital elements under the Cyber Resilience Act: Module A self-assessment, Module B+C EU-type examination, Module H full quality assurance, the EUCC route, notified-body engagement, the Annex VII technical file and the Annex V Declaration of Conformity — with templates and timelines.', 'A practitioner''s deep reference to CRA conformity assessment: Modules A / B+C / H, the EUCC certification route, notified-body engagement, Annex VII technical documentation and the Annex V Declaration of Conformity, with templates and suggested timelines.', NULL, 'article', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();
