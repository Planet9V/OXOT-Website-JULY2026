# Reference content scraped from the alternate OXOT app (frameworks pages) — for enhancing the current framework pages. This is OXOT's own copy.

## /frameworks INDEX (rich narrative — the current index is scarce; enhance it with this)

### How the pieces fit
Industrial cybersecurity in Europe is no longer governed by good intentions and voluntary guidance. In the space of a few years, the EU has built an interlocking framework of laws and standards that reach directly into Operational Technology — from the operators who run critical services, to the manufacturers who build the products those services depend on, to the AI now embedded in machines.

Understanding how these pieces fit together is the difference between a coherent security programme and a scramble of disconnected compliance projects.

OXOT works across all of them. This page is the map — start with your role, then open any framework for the detailed, individually-cited guide.

### The frameworks
Five major EU instruments now govern OT security, each targeting a different slice of the ecosystem:
- **Cyber Resilience Act (CRA)** — mandatory cybersecurity requirements for any product with digital elements placed on the EU market, effective December 2027. This is the broadest horizontal obligation: if it has a chip and connects to a network, the CRA applies.
- **NIS2 Directive** — extends the original NIS to a far wider set of essential and important entities, including OT operators in energy, transport, water and manufacturing above certain thresholds.
- **EU AI Act** — a risk-based framework for AI systems. Safety functions in OT — predictive maintenance that stops a line, AI that controls physical actuators — often fall into the high-risk or safety-critical categories.
- **Machinery Regulation 2023/1230** — replaces the old Machinery Directive and explicitly requires cybersecurity as a safety property for safety-related control systems.
- **IEC 62443** — the reference standard for industrial automation security. Not an EU regulation, but the framework the others point to for technical substance.

### Who answers to what
The EU frameworks divide obligations between two distinct groups — and most industrial organisations straddle both:

Operators of essential services fall primarily under NIS2. They must maintain risk management measures, report incidents within 24 hours, and ensure their supply chains (including the OT products they buy) meet adequate security standards. IEC 62443-2-1 is the typical implementation reference.

Manufacturers and integrators of products with digital elements face the CRA, the Machinery Regulation, and potentially the AI Act. They must CE-mark their products against cybersecurity requirements, maintain a software bill of materials, handle vulnerabilities for the product's supported lifetime, and generate a conformity dossier a notified body can audit.

### Why it pays to treat them as one
Each regulation was drafted by a different DG, with a different set of policy objectives — yet they share a large common core. Secure-by-design, vulnerability management, access control, logging and incident response appear across all five. Treating each compliance project independently means writing the same evidence four times over.

OXOT's control library maps the shared obligations once, then traces each one to its specific citations in every applicable regulation. A single piece of evidence — a network segmentation design, a penetration test, a patching process — can satisfy requirements in CRA Annex I, NIS2 Article 21, IEC 62443-3-3 SR 5.1, and the Machinery Regulation's essential health and safety requirements simultaneously.

### How OXOT helps
- **Unified control library.** Every obligation across CRA, NIS2, AI Act, Machinery and IEC 62443 is modelled in a single, deduplicated requirement set — so teams work against one list, not five.
- **Cyber Digital Twin.** A living model of your OT environment that maps assets, zones, conduits and trust boundaries to the specific controls that apply to each. As your environment changes, the compliance picture updates automatically.
- **Audit-ready evidence.** Link engineering artefacts — tickets, tests, SBOMs, design documents — to controls. OXOT generates structured technical files and declarations of conformity that a notified body can actually follow.

---

## /machinery (machine-act) — structure to add

Intro: Regulation (EU) 2023/1230 on machinery, repealing Directive 2006/42/EC. Essential health and safety requirements for machinery, now including explicit cybersecurity provisions for safety-related control systems (protection against corruption, reliability of control systems). Requires a technical file, risk assessment, EU Declaration of Conformity, and — for high-risk categories — third-party conformity assessment.

Key dates: 2023-07-19 Machinery Regulation enters into force; 2027-01-20 Full application — repeals Directive 2006/42/EC.

### Product classes & entity types
- **Standard machinery** (standard) — Machinery not listed in Annex I. Conformity via the manufacturer's internal checks.
- **Annex I Part A (high-risk)** (high) — High-risk machinery categories for which third-party involvement is mandatory even where harmonised standards are applied.
- **Annex I Part B** (elevated) — Listed categories where self-assessment is possible only if harmonised standards are fully applied; otherwise third-party assessment.

### Conformity routes
- **Module A — Internal checks** — Conformity based on internal checks on the manufacture of machinery.
- **Module B+C — EU-type examination** (Third-party required) — EU-type examination by a notified body followed by conformity to type.
- **Module H — Full quality assurance** (Third-party required) — Conformity based on full quality assurance assessed by a notified body.
- **Module G — Unit verification** (Third-party required) — Conformity based on unit verification by a notified body.

### The 8 cybersecurity-relevant requirements
| Ref | Type | Theme | Title | Description |
|---|---|---|---|---|
| Annex III 1.1.9 | Product req. | Secure by Design & Default | Protection against corruption | Machinery shall be designed and constructed so that connection to it of another device does not lead to a hazardous situation, and that hardware/software transmitting safety signals are protected against corruption. |
| Annex III 1.2.1 | Product req. | Resilience & Availability | Safety and reliability of control systems | Control systems shall be designed and constructed to prevent hazardous situations, withstanding intended operating stresses and external influences, including malicious attempts from third parties to create a hazardous situation. |
| Annex III 1.2.1(a) | Product req. | Access Control | Protection of safety-related control software | Safety-related control software and access to it shall be protected against unintended or intentional corruption and unauthorised modification. |
| Annex III 1.2.1(b) | Product req. | Logging & Monitoring | Recording of intervention data | Evidence of intervention and of a fault, where it affects safety functions, shall be recorded to support fault detection and traceability. |
| Annex III 1.2.1(c) | Product req. | Secure Update Management | Software updates preserving safety | Modifications to safety-related software, including updates, shall not compromise the safety of the machinery. |
| Annex III (general) | Process | Risk Management | Risk assessment | The manufacturer shall carry out a risk assessment to determine the health and safety requirements that apply, and design and construct the machinery taking its results into account. |
| Annex IV | Documentation | Technical Documentation | Technical file | Compile a technical file demonstrating that the machinery complies with the applicable essential health and safety requirements. |
| Annex II | Documentation | Conformity Declaration | EU Declaration of Conformity | Draw up the EU declaration of conformity and affix the CE marking before placing the machinery on the market. |

---

## /nis2 — enhance from conformity_source.json (NIS2 has 12 requirements: Art 20, 21(2)(a-j), 23, etc.) + this description:
NIS2 Directive — EU-wide cybersecurity directive imposing risk-management, governance and incident-reporting obligations on essential and important entities across critical sectors (energy, transport, water, health, digital infrastructure, manufacturing and more). Unlike the product-focused CRA, NIS2 governs the operator: management accountability, a defined set of technical and organisational measures (Art 21), and strict incident notification timelines (Art 23).
Key NIS2 dates (from data): 2023-01-16 enters into force; 2024-10-17 Member State transposition deadline; 2024-10-18 national measures apply; 2025-04-17 Member States establish registers of entities.
