-- 028_seed_full_framework_content.sql
-- Seed the full, rich framework/regulation page content (EN+NL) from
-- content/pages/*.md into the pages table. seed:pages does not run on Railway,
-- so the DB was left with thin early-migration stubs while the rich .md files
-- (nis2 50KB, ai-act 60KB, machine-act 44KB, etc.) never reached production.
-- Guard: only overwrite when the stored body is SHORTER than the rich one, so
-- this fixes the thin stubs once and then leaves future admin edits alone.

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ($MDBODY$frameworks$MDBODY$, $MDBODY$en$MDBODY$, $MDBODY$European Frameworks for OT Security$MDBODY$, $MDBODY$Industrial cybersecurity in Europe is no longer governed by good intentions and voluntary guidance. In the space of a few years, the EU has built an interlocking framework of laws and standards that reach directly into Operational Technology — from the operators who run critical services, to the manufacturers who build the products those services depend on, to the AI now embedded in machines. Understanding how these pieces fit together is the difference between a coherent security programme and a scramble of disconnected compliance projects.

OXOT works across all of them. This page is the map — start with your role, then open any framework for the detailed, individually-cited guide.

```widget
framework-selector
```

```keyfacts
Laws (outcomes) :: NIS2 · CRA · AI Act · Machinery Regulation
Standards (the how) :: IEC 62443 · TS 50701 (rail)
Operators answer to :: NIS2
Manufacturers answer to :: the Cyber Resilience Act
The method underneath :: IEC 62443
Single source of truth :: the Cyber Digital Twin
```

## How the pieces fit

The European framework divides, roughly, into **who is responsible for what**. The laws set the outcomes; the standards provide the how. Build to the standards once, and you satisfy much of the law across the board.

- **Operators** — utilities, plants and infrastructure managers running essential and important services — answer to **NIS2**.
- **Manufacturers** of products with digital elements answer to the **Cyber Resilience Act**.
- **Machine builders** answer to the **Machinery Regulation**, which now folds cybersecurity into machine safety.
- **Anyone deploying AI** in a safety or high-risk role answers to the **AI Act**.
- Underpinning all of it, **IEC 62443** — and, for rail, **TS 50701** — provides the engineering method to actually meet these obligations and prove it.

## The frameworks

Each has its own detailed guide — open the one that applies to you.

```cards
NIS2 — Directive (EU) 2022/2555 :: /en/nis2 :: The EU's baseline cybersecurity law for operators of essential and important services: ten risk-management measures, 24/72-hour reporting, management accountability and turnover-linked penalties.
Cyber Resilience Act — Regulation (EU) 2024/2847 :: /en/cra :: Security-by-design for products with digital elements: securable products, vulnerability handling, a support period, and 24-hour reporting of actively exploited vulnerabilities.
AI Act — Regulation (EU) 2024/1689 :: /en/ai-act :: The world's first comprehensive AI law. Industrial AI used as a safety component is automatically high-risk, with robustness, oversight and cybersecurity under Article 15.
Machinery Regulation — Regulation (EU) 2023/1230 :: /en/machine-act :: Machine safety for the connected, software and AI era. From January 2027, protection against corruption becomes part of the safety case.
IEC 62443 :: /en/iec-62443 :: The international standard for industrial automation and control-system security — zones, conduits, security levels and a lifecycle. The engineering backbone for the rest.
TS 50701 :: /en/ts-50701 :: The first cybersecurity specification written for railways — IEC 62443 adapted to rail and integrated with the EN 50126 safety lifecycle.
```

## Who answers to what

| Framework | Type | Primarily lands on |
| --- | --- | --- |
| [NIS2](/en/nis2) | Directive | Operators of essential / important services |
| [Cyber Resilience Act](/en/cra) | Regulation | Manufacturers of products with digital elements |
| [AI Act](/en/ai-act) | Regulation | Providers & deployers of AI systems |
| [Machinery Regulation](/en/machine-act) | Regulation | Machine builders & substantial modifiers |
| [IEC 62443](/en/iec-62443) | Standard | Operators, integrators & product suppliers |
| [TS 50701](/en/ts-50701) | Specification | Rail operators & suppliers |

## Why it pays to treat them as one

A connected industrial product with an AI safety component, sold to an operator of an essential service, can engage **all of these at once**. Handled separately, that is four or five overlapping compliance efforts with duplicated cost and inconsistent evidence.

```compare
Handled as separate projects
- Four or five overlapping audits, each from scratch
- Duplicated cost and effort across teams
- Inconsistent, sometimes contradictory evidence
- No single owner of the risk picture
---
Handled as one programme
- One risk-based engineering effort
- Build the evidence once, satisfy many obligations
- A single, coherent body of work
- One source of truth: the Cyber Digital Twin
```

That single source of truth is what our **[Cyber Digital Twin](/en/cyber-digital-twin)** provides: a structured model of your OT estate against which every one of these obligations can be assessed, prioritised and evidenced.

```cta
Not sure which frameworks apply — or where to start?
Use the selector above, then talk to us. We turn this landscape from a compliance burden into a single, manageable, risk-based programme.
Talk to us about which apply :: /en/contact
```

## How OXOT helps

We turn this landscape from a compliance burden into a manageable programme. Our **[OT Security Assessments](/en/services)** establish where you stand; our **[Cyber Digital Twin](/en/cyber-digital-twin)** holds the risk picture every obligation draws on; our **OT Security Programmes** deliver remediation aligned to [IEC 62443](/en/iec-62443); and our **Capability Transfer** leaves your team able to sustain it. One method, many obligations met.$MDBODY$, true, $MDBODY$EU OT Cybersecurity Frameworks & Regulations | OXOT$MDBODY$, $MDBODY$A guide to the European frameworks shaping OT cybersecurity — NIS2, the Cyber Resilience Act, the AI Act, the Machinery Regulation, IEC 62443 and TS 50701 — with an interactive selector that shows which apply to your role and how they fit together.$MDBODY$, $MDBODY$NIS2, the CRA, the AI Act, the Machinery Regulation, IEC 62443 and TS 50701 — which apply to you, and how Europe's OT rules fit together.$MDBODY$, NULL, $MDBODY$page$MDBODY$, now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET
  title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published,
  meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description,
  excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type,
  published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now()
WHERE length(pages.body) < length(EXCLUDED.body);

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ($MDBODY$frameworks$MDBODY$, $MDBODY$nl$MDBODY$, $MDBODY$Europese kaders voor OT-beveiliging$MDBODY$, $MDBODY$Industriële cyberbeveiliging in Europa wordt niet langer geregeerd door goede bedoelingen en vrijwillige richtlijnen. In enkele jaren heeft de EU een samenhangend geheel van wetten en normen gebouwd dat rechtstreeks tot in Operational Technology reikt — van de operators die kritieke diensten draaien, tot de fabrikanten die de producten bouwen waarop die diensten steunen, tot de AI die nu in machines is ingebed. Begrijpen hoe deze stukken samenhangen is het verschil tussen een samenhangend beveiligingsprogramma en een wirwar van losstaande complianceprojecten.

OXOT werkt met ze allemaal. Deze pagina is de kaart — begin met uw rol, en open vervolgens elk kader voor de gedetailleerde, individueel geciteerde gids.

```widget
framework-selector
```

```keyfacts
Wetten (uitkomsten) :: NIS2 · CRA · AI-verordening · Machineverordening
Normen (het hoe) :: IEC 62443 · TS 50701 (spoor)
Operators vallen onder :: NIS2
Fabrikanten vallen onder :: de Cyber Resilience Act
De methode eronder :: IEC 62443
Eén bron van waarheid :: de Cyber Digital Twin
```

## Hoe de stukken samenhangen

Het Europese kader verdeelt zich, grofweg, naar **wie waarvoor verantwoordelijk is**. De wetten stellen de uitkomsten; de normen leveren het hoe. Bouw één keer naar de normen, en u voldoet aan een groot deel van de wet over de hele linie.

- **Operators** — nutsbedrijven, fabrieken en infrastructuurbeheerders die essentiële en belangrijke diensten draaien — vallen onder **NIS2**.
- **Fabrikanten** van producten met digitale elementen vallen onder de **Cyber Resilience Act**.
- **Machinebouwers** vallen onder de **Machineverordening**, die cyberbeveiliging nu in machineveiligheid vouwt.
- **Iedereen die AI inzet** in een veiligheids- of hoogrisicorol valt onder de **AI-verordening**.
- Onder dit alles levert **IEC 62443** — en, voor het spoor, **TS 50701** — de technische methode om daadwerkelijk aan deze verplichtingen te voldoen en het aan te tonen.

## De kaders

Elk heeft zijn eigen gedetailleerde gids — open degene die voor u geldt.

```cards
NIS2 — Richtlijn (EU) 2022/2555 :: /nl/nis2 :: De basiscybersecuritywet van de EU voor operators van essentiële en belangrijke diensten: tien risicobeheersmaatregelen, 24/72-uursmelding, bestuurdersaansprakelijkheid en aan omzet gekoppelde boetes.
Cyber Resilience Act — Verordening (EU) 2024/2847 :: /nl/cra :: Security-by-design voor producten met digitale elementen: beveiligbare producten, kwetsbaarheidsbeheer, een ondersteuningsperiode, en 24-uurs melding van actief misbruikte kwetsbaarheden.
AI-verordening — Verordening (EU) 2024/1689 :: /nl/ai-act :: 's Werelds eerste allesomvattende AI-wet. Industriële AI als veiligheidscomponent is automatisch hoogrisico, met robuustheid, toezicht en cyberbeveiliging onder Artikel 15.
Machineverordening — Verordening (EU) 2023/1230 :: /nl/machine-act :: Machineveiligheid voor het tijdperk van connectiviteit, software en AI. Vanaf januari 2027 wordt bescherming tegen corruptie onderdeel van het veiligheidsdossier.
IEC 62443 :: /nl/iec-62443 :: De internationale norm voor de beveiliging van industriële automatiserings- en besturingssystemen — zones, conduits, security levels en een levenscyclus. De ruggengraat voor de rest.
TS 50701 :: /nl/ts-50701 :: De eerste cybersecurityspecificatie voor spoorwegen — IEC 62443 aangepast aan het spoor en geïntegreerd met de EN 50126-veiligheidslevenscyclus.
```

## Wie valt onder wat

| Kader | Type | Komt vooral neer op |
| --- | --- | --- |
| [NIS2](/nl/nis2) | Richtlijn | Operators van essentiële / belangrijke diensten |
| [Cyber Resilience Act](/nl/cra) | Verordening | Fabrikanten van producten met digitale elementen |
| [AI-verordening](/nl/ai-act) | Verordening | Aanbieders & gebruiksverantwoordelijken van AI |
| [Machineverordening](/nl/machine-act) | Verordening | Machinebouwers & ingrijpende wijzigers |
| [IEC 62443](/nl/iec-62443) | Norm | Operators, integrators & productleveranciers |
| [TS 50701](/nl/ts-50701) | Specificatie | Spoorwegoperators & -leveranciers |

## Waarom het loont ze als één te behandelen

Een connected industrieel product met een AI-veiligheidscomponent, verkocht aan een operator van een essentiële dienst, kan **al deze tegelijk** raken. Afzonderlijk behandeld zijn dat vier of vijf overlappende compliance-inspanningen met dubbele kosten en inconsistent bewijs.

```compare
Als losse projecten behandeld
- Vier of vijf overlappende audits, elk vanaf nul
- Dubbele kosten en inspanning over teams heen
- Inconsistent, soms tegenstrijdig bewijs
- Geen enkele eigenaar van het risicobeeld
---
Als één programma behandeld
- Eén risicogebaseerde technische inspanning
- Bouw het bewijs één keer, voldoe aan vele verplichtingen
- Eén samenhangend geheel van werk
- Eén bron van waarheid: de Cyber Digital Twin
```

Die ene bron van waarheid is wat onze **[Cyber Digital Twin](/nl/cyber-digital-twin)** biedt: een gestructureerd model van uw OT-omgeving waartegen elk van deze verplichtingen kan worden beoordeeld, geprioriteerd en onderbouwd.

```cta
Niet zeker welke kaders gelden — of waar te beginnen?
Gebruik de keuzehulp hierboven, en praat dan met ons. Wij veranderen dit landschap van een compliancelast in één beheersbaar, risicogebaseerd programma.
Praat met ons over welke gelden :: /nl/contact
```

## Hoe OXOT helpt

Wij veranderen dit landschap van een compliancelast in een beheersbaar programma. Onze **[OT-securityassessments](/nl/services)** bepalen waar u staat; onze **[Cyber Digital Twin](/nl/cyber-digital-twin)** houdt het risicobeeld vast waar elke verplichting uit put; onze **OT-securityprogramma's** leveren sanering afgestemd op [IEC 62443](/nl/iec-62443); en onze **kennisoverdracht** laat uw team achter dat het kan volhouden. Eén methode, vele verplichtingen vervuld.$MDBODY$, true, $MDBODY$EU OT-cybersecuritykaders & regelgeving | OXOT$MDBODY$, $MDBODY$Een gids voor de Europese kaders die OT-cybersecurity vormgeven — NIS2, de Cyber Resilience Act, de AI-verordening, de Machineverordening, IEC 62443 en TS 50701 — met een interactieve keuzehulp die toont welke voor uw rol gelden en hoe ze samenhangen.$MDBODY$, $MDBODY$NIS2, de CRA, de AI-verordening, de Machineverordening, IEC 62443 en TS 50701 — welke voor u gelden, en hoe de Europese OT-regels samenhangen.$MDBODY$, NULL, $MDBODY$page$MDBODY$, now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET
  title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published,
  meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description,
  excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type,
  published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now()
WHERE length(pages.body) < length(EXCLUDED.body);

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ($MDBODY$cra$MDBODY$, $MDBODY$en$MDBODY$, $MDBODY$The Cyber Resilience Act (CRA)$MDBODY$, $MDBODY$The Cyber Resilience Act is the European Union's answer to a simple, uncomfortable fact: for decades, digital products have shipped with security treated as optional, and the cost has landed on the people who use them. The CRA changes the deal. For the first time, **security becomes a legal condition of placing a product with digital elements on the EU market** — from consumer gadgets to the industrial controllers, gateways and software that run operational environments.

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
| **Importer** | Verify the manufacturer's conformity assessment, technical documentation and CE marking; add own contact details; keep 10-year traceability records; act on non-conformity. |
| **Distributor** | Act with due care; verify CE marking and DoC accompany the product; must not make available products they know or should know are non-compliant; keep 10-year traceability records. |

> [!WARNING]
> **You can become a "manufacturer" without ever calling yourself one.** Under **Article 21**, importers and distributors assume full manufacturer obligations if they place a product on the market under their own name or trademark, or make a **substantial modification** to a product already on the market. An OEM that contracts manufacturing to a non-EU entity and sells under its own brand in the EU bears all Article 13 obligations regardless of the contract terms — contractual pass-through of liability to the ODM does not work in front of a market surveillance authority. System integrators and operators who rebrand, re-flash firmware, or significantly alter a device need to know exactly where that line sits — per product, before 2027.

That "substantial modification" trigger is the one that surprises OT teams. A modification is "substantial" if it either affects compliance with Annex I, or changes the product's intended purpose (**Article 3(30)**). Routine maintenance, like-for-like repairs and security patches are **not** substantial modifications by default (**Recital 42**) — but a full SCADA platform upgrade, or adding IIoT connectivity to a previously non-networked device, typically is. A machine builder who integrates a third-party controller and ships the line under their own name, or an integrator who performs a post-2027 refit that crosses this line, inherits the full manufacturer stack — including the 5-year minimum support period, counted from the date of the modification.

## Product classes and conformity assessment

Not all products are treated alike. The CRA sorts PDEs by criticality, and the class determines how rigorously conformity must be demonstrated. Classification is fixed by **Commission Implementing Regulation (EU) 2025/2392** (published 1 December 2025), which gives technical descriptions for the Annex III (Important) and Annex IV (Critical) categories. Classification is not a paperwork exercise — it is the decision that sets your timeline, your budget, and whether a notified body sits between you and the CE mark. ([EC — conformity assessment](https://digital-strategy.ec.europa.eu/en/policies/cra-conformity-assessment))

| Class | Examples (Annex III / IV) | Conformity route |
|---|---|---|
| **Default** | The large majority of products, listed in neither annex — consumer IoT, smart speakers, mobile apps, video games, most non-safety industrial devices. | **Self-assessment** (Module A, internal control) against the essential requirements — always permitted. |
| **Important — Class I** | Operating systems (desktop/server/mobile), browsers, password managers, VPN software, SIEM, network routers/switches, physical and virtual network interfaces, non-safety-critical IACS products. | Self-assessment (Module A) **only if** a harmonised standard is fully applied; otherwise **Module B+C or H** via a notified body. |
| **Important — Class II** | Firewalls, IDS/IPS, hypervisors, HSMs, tamper-resistant microprocessors, safety-critical IACS, industrial robots. | **Always Module B+C or Module H** via a notified body — self-assessment is legally unavailable, full stop. |
| **Critical** | Smart cards, HSMs, smart meter gateways in critical infrastructure, certain chip-level security products (Annex IV). | Mandatory **European cybersecurity certification**; where no scheme exists yet, Important Class II rules apply. |

> **OXOT's read on this table:** many ICS components — including safety-critical IACS products — land in Important Class II, which forecloses self-assessment entirely. That single classification decision is the one most OT manufacturers underestimate: it is the difference between an internal engineering sign-off and a multi-month notified-body queue.

### Class I in practice — what "self-assess or not" actually depends on

Class I is the one class where the manufacturer has a real choice, and that choice is dictated entirely by engineering discipline, not intent.

- **Pathway A — Self-assessment (Module A, internal control).** Permitted **if and only if** the manufacturer fully applies EU-harmonised standards or common specifications (the forthcoming harmonised EN IEC 62443 profiles, once cited). Until that citation lands, this pathway is closed for OT Class I products.
- **Pathway B — Mandatory third-party assessment (Module B+C or Module H).** If a manufacturer does not fully apply a harmonised standard, they forfeit the right to self-assess and face the same third-party route as a Class II product: an independent notified body conducting an EU-type examination (Module B+C) or a full quality assurance audit of the manufacturer's development lifecycle (Module H).

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

- **Module B + C (EU-type examination):** the notified body conducts a rigorous examination of the product's technical design, development and vulnerability-handling processes, and tests a physical or digital sample directly. Module C then requires the manufacturer to ensure every subsequent production unit conforms to that approved sample.
- **Module H (full quality assurance):** instead of sampling one unit, the notified body audits the manufacturer's entire secure development lifecycle and quality management system. If the audit confirms the process inherently and consistently produces CRA-compliant output, production can proceed.

**2. The essential cybersecurity requirements ("what")**

- No known exploitable vulnerabilities at release, backed by a documented risk assessment.
- Security-by-design and by-default: minimal attack surface, strict access controls, secure out-of-the-box configuration.
- State-of-the-art cryptography for data at rest and in transit — no obsolete or home-grown algorithms.
- Hardware-level protections for devices like tamper-resistant microprocessors: hardware roots of trust, secure boot integrity, physical tamper resilience.
- Secure, largely automatic updates with a clear opt-out for professional users.
- A machine-readable SBOM (SPDX or CycloneDX) tracking all dependencies to enable rapid patching.
- A committed support period — as a rule, not shorter than 5 years.

All of this is compiled into a technical documentation file — risk assessments, architectural designs, SBOM, test reports — retained for at least 10 years or the support period, whichever is longer.

## Annex I, Part I — the product's security properties

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

**Part II** governs the process a manufacturer must run across the support period. This is the operational discipline behind the product's security properties, and it applies to every manufacturer regardless of product class.

| Vulnerability-handling duty | What it means |
|---|---|
| **Identify & document components** | Know what is inside the product, including a **software bill of materials (SBOM)** covering at least top-level dependencies, in a commonly used machine-readable format. |
| **Remediate without delay** | Address and fix vulnerabilities promptly, including via **free security updates** for the support period; separate security fixes from feature releases where feasible. |
| **Regular testing** | An ongoing, scheduled programme — periodic penetration testing, automated CVE scanning against the live SBOM, and regression testing — not a single pre-release check. |
| **Public disclosure of fixes** | Once a fix is available, publish its severity, impact and remediation — comparable to CVE/CNA advisory practice. |
| **Coordinated disclosure** | Operate and publish a CVD policy, with a designated single point of contact that is easily identifiable to users. |
| **Upstream reporting** | On identifying a vulnerability in a third-party or open-source component, report it to that component's maintainer — and share any patch developed, where appropriate. |
| **Secure distribution** | Distribute updates with integrity protection and authentication, so the update channel itself cannot become a supply-chain attack vector. |
| **Information sharing** | Provide vulnerability count, severity and handling-policy information to competent authorities on request. |

> [!NOTE]
> **Why the SBOM matters more than it looks.** Industrial products are assembled from layers of third-party and open-source components. The SBOM obligation forces manufacturers to actually know what is inside their products and to track the vulnerabilities those components carry. A stale SBOM is a compliance risk in its own right — it cannot support the 24-hour Article 14 reporting clock if you don't know a vulnerable component is even in the product. For operators, a vendor SBOM is a direct input to your own risk picture — and a reasonable thing to demand in procurement well before 2027.

## Full obligations reference — the manufacturer's lifecycle

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

One of the CRA's most practically significant demands is the **support period**: manufacturers must provide security updates for a period appropriate to the product, and **as a rule at least five years** (shorter only where the product is expected to be in use for less time). Technical documentation and the EU declaration of conformity must be kept for at least ten years, or the support period if longer.

For industrial equipment that routinely runs for a decade or more, this reframes the commercial relationship — and creates a real procurement risk for greenfield facilities. A PLC installed in 2028 at a facility expected to operate until 2048 has a 20-year operational horizon; the CRA's floor is only 5 years. Unless a vendor contractually commits to a longer support period, the facility will be running CRA-unsupported components for most of its operating life. Security support stops being a goodwill gesture that lapses when a product line is discontinued, and becomes a legal expectation over a defined lifetime. For buyers, the support period is a negotiating anchor: you can hold a vendor to a stated window, and you can ask what happens at end of support before you sign.

## Reporting — the 24-hour clock

The CRA introduces a sharp, staged reporting regime under **Article 14**. **Actively exploited vulnerabilities** and **severe incidents** affecting product security must be notified through a single reporting platform to the manufacturer's national **CSIRT** and, simultaneously, **ENISA**. ([EC — reporting](https://digital-strategy.ec.europa.eu/en/policies/cra-reporting))

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
Not sure if you're a manufacturer, integrator, or importer under the CRA?
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

That phrase — **"where applicable"**, reinforced by **Recital 55** — is the whole game. Where a specific essential requirement is not relevant to a product's intended purpose or risk profile, the manufacturer need not implement it, **provided** a clear written justification is recorded in the technical documentation under **Article 13(4)**. The official multi-stakeholder guidance (ORCWG) is explicit that manufacturers *"determine on the basis of the cybersecurity risk assessment which of those requirements are relevant"* and must document any non-application.

```keyfacts
Scope unit :: The individual product (Art. 3(1)) — not the system
Risk mechanism :: Cybersecurity risk assessment (Art. 13(2)–(3))
Proportionality hook :: "appropriate" + "where applicable" (Annex I, Part I)
Non-application :: Allowed with written justification (Art. 13(4), Recital 55)
Equivalent to :: IEC 62443 SL-T differentiation — expressed as outcomes
```

The commercial stakes are real. A manufacturer who can write a rigorous, defensible Article 13(2)–(3) assessment and map it precisely to Annex I avoids over-implementing controls that its risk profile does not warrant. A manufacturer who cannot faces the opposite: either the penalties of Article 64, or the dead-weight cost of engineering every product to a maximal specification it never needed.

## Mapping IEC 62443 Security Levels to CRA conformity

Most in-scope OT manufacturers already hold [IEC 62443](/en/iec-62443) certifications — and discover that **none of those certificates automatically satisfy the CRA.** The two frameworks are architected around different units of conformity, so the mapping has to be built deliberately. This is where OXOT's analysis goes beyond the general compliance literature.

| Dimension | IEC 62443 | Cyber Resilience Act |
|---|---|---|
| Unit of conformity | System Under Consideration; zones & conduits | The individual product placed on the market |
| Risk calibration | Security Levels SL-1 → SL-4 per zone | Risk assessment (Art. 13(2)–(3)), "where applicable" |
| Compliance evidence | SL-C certificate per component; SL-A per zone | Technical file (Annex VII) + Declaration of Conformity |
| Third-party assessment | Optional (62443-4-2 SL-C certification) | Mandatory for Important Class I (absent a harmonised standard) and Class II |
| Target/Capability/Achieved | SL-T / SL-C / SL-A are distinct | Collapsed into one documented, risk-justified outcome |

The bridge is conceptual as much as technical: **SL-T** (the target a zone requires) becomes the *input* to the Article 13(2) risk assessment; **SL-C** (a component's certified capability) becomes *evidence* toward Annex I, Part II component requirements; and **SL-A** (what a zone actually achieves) has no direct CRA analogue, because the CRA stops at the product boundary and does not certify the operator's installed system. A 62443-4-2 SL-C certificate is powerful supporting evidence in a CRA technical file — but it is not a substitute for the Annex I traceability the CRA demands.

## The harmonised-standards gap — and the Notified Body queue

The CRA's conformity routes lean heavily on **harmonised standards**: cite one in the Official Journal of the EU, and a manufacturer of an Important Class I product can self-assess against it with a presumption of conformity. The problem in 2026–2027 is timing. As of mid-2026, **no harmonised standard for the CRA has yet been cited in the Official Journal**, and the expected candidate — **EN IEC 62443-4-2 with an A11 CRA-alignment annex** — is not anticipated until roughly **Q2 2027**, only months before the main obligations bite on **11 December 2027**.

> [!WARNING]
> Until a harmonised standard is cited, **every Important Class I product without one — and every Class II product regardless — must go through a Notified Body** for conformity assessment. Notified Body capacity for the CRA is finite and being built now. Manufacturers who wait for the standard risk arriving at a queue that has already formed, with the deadline fixed and immovable.

This is the practical reason CRA readiness cannot be deferred to 2027: the reporting machinery is already due in **September 2026**, and the conformity route for higher-class products runs through third-party bodies whose capacity is scarce well before the deadline.

## The scale of the deadline — 100,000 manufacturers, one date

The CRA is not a niche obligation. The European Commission's own impact assessment identifies on the order of **100,000–110,000 economic operators** placing products with digital elements on the EU market — the overwhelming majority of whom must reach conformity by the **same 11 December 2027 date**. Layered on top is the reporting duty from **11 September 2026** covering **every in-scope product already on the market**, including long-lived industrial equipment sold years ago.

For OT specifically, that convergence is unusually sharp: industrial products are long-lived, assembled from deep supply chains, and frequently sit inside safety-related functions where the [Machinery Regulation](/en/machine-act) and, for AI-driven components, the [AI Act](/en/ai-act) apply simultaneously. The manufacturers who treat the CRA as one more standalone checklist will meet it late and expensively. The ones who fold it into a single, risk-based product-security programme — anchored in the 62443 work most already have — meet it once.

## OXOT's CRA ↔ IEC 62443 alignment methodology

This is where OXOT's own analysis goes further than the general compliance literature. IEC 62443's zone-differentiated Security Level (SL) framework does **not** map one-to-one onto the CRA — the two regimes are architected around different units. But the CRA's own risk-based proportionality mechanism produces a functionally equivalent outcome, and OXOT has built a repeatable methodology for translating between them.

### Why the two frameworks don't line up by default

| | IEC 62443 | CRA |
|---|---|---|
| **Unit of assessment** | System Under Consideration (SuC) — zones and conduits | The individual product placed on the EU market (Article 3(1)) |
| **Risk calibration** | Security Levels, SL-1 to SL-4, assigned per zone | Article 13(2)–(3) risk assessment, applied "where applicable" per Annex I requirement |
| **Compliance evidence** | SL-C certificate per component; SL-A per zone post-deployment | Technical file under Annex VII + EU Declaration of Conformity |
| **Third-party assessment** | Optional (IEC 62443-4-2 SL-C certification) | Mandatory for Important Class I without a harmonised standard, and always for Class II |
| **Harmonised standard status** | N/A | EN IEC 62443-4-1/A11:2026 and -4-2/A11:2026 not yet cited in the OJEU (expected ~Q2 2027) |

If your "product" under the CRA is a complete integrated system with four zones, the CRA treats it as **one product** with **one Declaration of Conformity**. If each zone-device is separately placed on the market, each is independently assessed. Deciding which of those two you actually are is, in OXOT's experience, the single most common point of confusion for OT manufacturers — most of whom think in systems, not products — and it is the first question our methodology answers.

### The proportionality bridge: SL-T as the CRA's risk-assessment input

The CRA does not use Security Levels. Its calibration mechanism is the Article 13(2)–(3) risk assessment, gated by the word **"appropriate"** in Annex I, Part I, point (1) — *"an appropriate level of cybersecurity based on the risks"* — and operationalised through the **"where applicable"** language in point (2).

OXOT's core finding: **an IEC 62443-3-2 zone/conduit risk assessment, which produces zone-specific SL-T values, is a fully legitimate methodology for satisfying the CRA's Article 13(2)–(3) risk assessment requirement.** A component at SL-C = 2 in a genuinely low-risk zone (SL-T = 2) is not an under-implementation — it is the correct, defensible CRA baseline for that zone, provided the risk assessment documents why. The higher-SL Requirement Enhancements that a Zone 1 or Zone 4 component would need are legitimately marked "not applicable" for the Zone 3 component — but only with a written, risk-based justification under **Article 13(4)**. Undocumented non-applicability is not a shortcut; it is a compliance failure waiting to be found in an audit.

> [!IMPORTANT]
> **The caveat that breaks most self-assessments:** IEC 62443 permits a zone's achieved security (SL-A) to meet its target (SL-T) through **compensating controls** — a firewall, an IDPS, a network policy — even where an individual component's capability (SL-C) is lower. The CRA's product-level assessment evaluates the **integrated** security posture, not isolated component specs. If a component sits at SL-C = 2 in a zone with SL-T = 3, the technical file must explicitly document *how* the compensating controls raise that zone's SL-A to 3 — a compensating-control claim with no documentation is a CRA non-conformity, not a technicality.

### FR-to-Annex-I mapping — the traceability matrix a notified body expects

The seven IEC 62443-4-2 Foundational Requirements (FRs) — each built from stacked, cumulative Component Requirements (CRs) and Requirement Enhancements (REs) across SL-1 to SL-4 — map directly to specific CRA Annex I, Part I, point (2) sub-requirements. This mapping is the traceability matrix a notified body will expect to see in a Class I or II technical file, and it is the backbone of OXOT's Phase 1 assessment deliverable.

| CRA Annex I (2) requirement | Primary IEC 62443 FR | What SL-2 typically provides | What SL-3 adds |
|---|---|---|---|
| **(b)** Protection from unauthorised access | FR1 Identification & Authentication Control, FR2 Use Control | Unique accounts, RBAC, PKI for inter-component auth | MFA for all humans, per-user ACLs, hardware authenticators |
| **(c)** Confidentiality of data | FR4 Data Confidentiality | AES-128+ in transit, secure deletion | At-rest encryption with hardware key management |
| **(d)** Integrity of data and programs | FR3 System Integrity | TLS, code-signing for updates, defined error states | Hardware root of trust, secure boot, measured launch |
| **(e)** Minimisation / restricted data flow | FR5 Restricted Data Flow | Logical segmentation, zone-boundary filtering | Physical segmentation, deep packet inspection for OT protocols (Modbus, OPC UA, DNP3) |
| **(f)** Availability of essential functions | FR7 Resource Availability | Basic DoS protection, resource limits | Application-layer DoS resistance, graceful degradation |
| **(h)** Limiting attack surfaces | FR5 (RDF), FR3 (SI) | Zone boundary filtering | Least functionality, deny-by-default |
| **(j)** Security event logging and monitoring | FR6 Timely Response to Events | Accessible audit logs, real-time detection | SIEM export (Syslog/CEF/LEEF), anomaly detection, tamper-evident logs |

The SL-2 → SL-3 escalation on FR1 — adding multi-factor authentication and hardware authenticators — is, in OXOT's experience delivering these assessments, the single most common gap finding for OT components moving from a low-risk to a high-risk zone classification.

### The synergistic method, in five steps

OXOT's methodology treats IEC 62443 not as a substitute for CRA conformity, but as the engineering content that fills the CRA's deliberately outcome-based requirements:

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

The CRA and NIS2 are complementary halves of one strategy. **[NIS2](/en/nis2)** obliges operators to manage the risk of the systems they run; the CRA obliges manufacturers to make those systems securable in the first place. An operator's NIS2 supply-chain duty (Article 21) becomes far easier to discharge when the products in the chain are CRA-compliant — arriving with SBOMs, security updates and a support commitment instead of a shrug.

For operators bringing greenfield facilities online in 2028 and beyond, procurement specifications should now name the CRA explicitly: CE marking reference, DoC reference number, support-period end-date, SBOM delivery format (SPDX or CycloneDX), and the vendor's CVD policy URL. For post-2027 refits and retrofits of existing plant, the operative question is whether the change constitutes a **substantial modification** — like-for-like replacement and security patching generally do not trigger full CRA compliance; adding new digital capability, or a platform-level SCADA upgrade, generally does.

**[IEC 62443](/en/iec-62443)** remains the natural engineering bridge for OT vendors, and **[TS 50701](/en/ts-50701)** extends the same discipline into rail. Where the CRA is legally binding but standard-agnostic, 62443 supplies the concrete engineering content — a pairing that also travels well across the broader [frameworks](/en/frameworks) landscape.

## OXOT's CRA Readiness offering

```carousel
CRA Readiness Assessment (Annex A)
A structured gap assessment against the CRA's essential requirements, scoped per product. We classify each product against Annex III/IV and Commission Implementing Regulation 2025/2392, determine the conformity route it actually needs, and produce a prioritised gap list against Annex I Part I and Part II — not a pass/fail, but a concrete list of what has to change before a Declaration of Conformity is defensible.
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

## The manufacturer's readiness journey

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

*OXOT's CRA Readiness Assessment, Preparation Service, and Statutes 2-Pager are available as standalone engagements or as a combined programme — reach out to scope your product portfolio.*

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
As a rule at least five years, or the product's expected time in use if shorter. Retain technical documentation and the declaration of conformity for at least ten years, or the support period if longer. For long-life industrial equipment, negotiate a longer commitment explicitly — the CRA sets a floor, not a ceiling.

**Does our existing IEC 62443 SL-C certificate satisfy the CRA?**
Not automatically, and not yet formally. Until EN IEC 62443-4-1/A11:2026 and -4-2/A11:2026 are cited in the EU Official Journal (expected ~Q2 2027), 62443 certification supports your technical argument as "other relevant technical specification" but does not confer a presumption of conformity. It does, however, supply most of the engineering evidence a notified body will want — provided it is mapped to specific Annex I requirements rather than cited in general terms.

**How does the CRA relate to the AI Act, NIS2 and the Machinery Regulation?**
The **[AI Act](/en/ai-act)** governs AI systems, the CRA governs products with digital elements, **[NIS2](/en/nis2)** governs operators, and the **[Machinery Regulation](/en/machine-act)** governs machinery safety including digital control. A connected industrial machine with an AI safety component could engage all four — which is exactly why a single, coherent OT security programme beats four disconnected compliance efforts.

## OXOT CRA Readiness resources

Practical materials from OXOT's CRA Readiness programme:

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

*This page is general information about EU law, not legal advice. Confirm how the CRA applies to your products and role against the Regulation and, where needed, qualified counsel. The CRA↔IEC 62443 alignment analysis reflects OXOT's own methodology and interpretation as of mid-2026; formal harmonised-standard citation may refine specific mappings.*

## Go deeper on the CRA

This overview is the field guide. For exhaustive detail, OXOT maintains two companion references:

- **[CRA — Complete Technical Reference](/en/cra-technical-reference)** — the full clause-by-clause map: regulation structure (8 chapters, 71 articles, 8 annexes), the three-tier product classification, every Annex I essential requirement, and the compliance timeline.
- **[CRA — CE Marking Pathways & Conformity Assessment](/en/cra-ce-marking-pathways)** — how you actually demonstrate conformity: Modules A / B+C / H, the EUCC route, notified-body engagement, the Annex VII technical file and the Annex V Declaration of Conformity, with templates and timelines.$MDBODY$, true, $MDBODY$Cyber Resilience Act (CRA) for OT & Products with Digital Elements | OXOT$MDBODY$, $MDBODY$The EU Cyber Resilience Act (Regulation (EU) 2024/2847) explained for OT — scope, product classes, Annex I security & vulnerability-handling requirements, SBOM, 24-hour reporting, ~5-year support periods, the 2024→2027 timeline, penalties, and OXOT's IEC 62443 alignment methodology.$MDBODY$, $MDBODY$Security-by-design becomes a legal condition of market access. A field guide to CRA scope, product classes, Annex I, SBOM, 24-hour reporting, support periods, penalties, and OXOT's own CRA↔IEC 62443 alignment methodology for OT manufacturers and buyers.$MDBODY$, NULL, $MDBODY$page$MDBODY$, now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET
  title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published,
  meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description,
  excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type,
  published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now()
WHERE length(pages.body) < length(EXCLUDED.body);

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ($MDBODY$cra$MDBODY$, $MDBODY$nl$MDBODY$, $MDBODY$De Cyber Resilience Act (CRA)$MDBODY$, $MDBODY$De Cyber Resilience Act is het antwoord van de Europese Unie op een eenvoudig maar ongemakkelijk feit: digitale producten worden al decennialang op de markt gebracht waarbij beveiliging als optioneel wordt behandeld, en de kosten daarvan komen terecht bij de mensen die ze gebruiken. De CRA verandert die afspraak. Voor het eerst wordt **beveiliging een wettelijke voorwaarde voor het op de EU-markt brengen van een product met digitale elementen** — van consumentengadgets tot de industriële controllers, gateways en software die operationele omgevingen laten draaien.

Als [NIS2](/nl/nis2) een wet is voor de *operatoren* die systemen draaien, is de CRA de wet voor de *makers* van de producten waaruit die systemen zijn opgebouwd. Industriële organisaties krijgen er doorgaans van twee kanten mee te maken: als afnemer die eindelijk beveiliging als recht kan eisen, en — als u producten bouwt, integreert of substantieel wijzigt — als fabrikant die nu verplichtingen draagt die worden ondersteund door aan de omzet gekoppelde boetes.

```keyfacts
Instrument :: Verordening (EU) 2024/2847 — rechtstreeks toepasselijk
In werking getreden :: 10 december 2024
Meldverplichtingen :: vanaf 11 september 2026
Hoofdverplichtingen :: vanaf 11 december 2027
Ondersteuningsperiode :: in de regel ≥ 5 jaar
Vroegwaarschuwing :: 24 uur naar ENISA + CSIRT
Conformiteit :: Bijlage I + CE-markering
Max. boete :: €15M of 2,5% van wereldwijde omzet
Sluit aan op :: [IEC 62443](/nl/iec-62443)
```

## De korte versie

- De CRA is **Verordening (EU) 2024/2847**, een rechtstreeks toepasselijke verordening — geen richtlijn — en werkt daardoor identiek in alle 27 lidstaten, zonder nationale omzettingsstap. ([EUR-Lex, officiële tekst](https://eur-lex.europa.eu/eli/reg/2024/2847/oj/eng))
- De verordening **is op 10 december 2024 in werking getreden** en is van toepassing op **producten met digitale elementen** (PDE's) — hardware en software waarvan het beoogde of redelijkerwijs te verwachten gebruik een directe of indirecte gegevensverbinding met een apparaat of netwerk omvat.
- **Fabrikanten** dragen de kernverplichtingen: security by design en by default, kwetsbaarheidsbeheer, een SBOM en een vastgestelde **ondersteuningsperiode** van in de regel ten minste vijf jaar.
- De verplichtingen inzake **melding van kwetsbaarheden en incidenten** gelden vanaf **11 september 2026**; de **hoofdverplichtingen** gelden vanaf **11 december 2027**. ([Europese Commissie](https://digital-strategy.ec.europa.eu/en/policies/cyber-resilience-act))
- Producten moeten voldoen aan de **essentiële eisen in Annex I** en de **CE-markering** dragen. De classificatie op basis van **Uitvoeringsverordening (EU) 2025/2392 van de Commissie** — gepubliceerd op 1 december 2025 — bepaalt welke conformiteitsroute van toepassing is.
- **Actief misbruikte kwetsbaarheden** en **ernstige incidenten** activeren een **vroegtijdige waarschuwing binnen 24 uur** aan ENISA en het nationale CSIRT, via één enkel meldplatform.
- Sancties lopen op tot **€15 miljoen of 2,5% van de wereldwijde jaaromzet**, afhankelijk van welk bedrag hoger is.

> [!IMPORTANT]
> De meldklok start eerder dan de hoofdverplichtingen, en wacht niet tot een product nieuw is. De detectie- en meldstructuur moet operationeel zijn vanaf **11 september 2026** — meer dan een jaar voordat u een CE-markering op het product zelf nodig heeft — en geldt voor **elk product binnen de reikwijdte dat al op de markt is**, inclusief een product dat al in 2019 is verkocht. Als een leverancier na die datum ontdekt dat een oude SCADA-implementatie een actief misbruikte kwetsbaarheid heeft, begint de klok van 24 uur alsnog te lopen.

## Waarom de CRA bestaat

Twee structurele problemen lagen aan de basis van deze wet. Ten eerste een **laag niveau van cyberbeveiliging** in veel digitale producten — zwakke standaardconfiguraties, ongepatchte kwetsbaarheden, geen duidelijke route om een gebrek te melden. Ten tweede een **onvoldoende begrip van en toegang tot informatie** bij gebruikers, die op het moment van aankoop geen onderscheid konden maken tussen een veilig en een onveilig product, en vaak geen beveiligingsupdates konden krijgen, zelfs als ze dat wilden. ([Samenvatting CRA, Europese Commissie](https://digital-strategy.ec.europa.eu/en/policies/cra-summary))

De oplossing legt de verantwoordelijkheid stroomopwaarts, bij de partij die het best in staat is om te handelen: de fabrikant. Daarbij wordt gebruikgemaakt van het beproefde instrumentarium van het EU-productrecht — essentiële eisen, conformiteitsbeoordeling, CE-markering, markttoezicht — en dat wordt gericht op cyberbeveiliging. "Secure by design" en "secure by default" zijn geen slogans meer, maar de prijs van markttoegang.

## Het tijdpad van de CRA

De verordening wordt over drie jaar gefaseerd ingevoerd. Onderstaande data zijn de data om op te plannen; de tijd daartussen is waarin het technische werk moet gebeuren.

```svg
<svg viewBox="0 0 700 240" xmlns="http://www.w3.org/2000/svg" font-family="system-ui, sans-serif">
  <line x1="40" y1="120" x2="660" y2="120" stroke="#94a3b8" stroke-width="2"/>
  <!-- milestone 1 -->
  <circle cx="90" cy="120" r="8" fill="#3b82f6"/>
  <line x1="90" y1="120" x2="90" y2="70" stroke="#94a3b8" stroke-width="1"/>
  <text x="90" y="58" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">10 dec 2024</text>
  <text x="90" y="150" fill="#e5e7eb" font-size="12" text-anchor="middle">Treedt in</text>
  <text x="90" y="166" fill="#e5e7eb" font-size="12" text-anchor="middle">werking</text>
  <!-- milestone 2 -->
  <circle cx="300" cy="120" r="8" fill="#f97316"/>
  <line x1="300" y1="120" x2="300" y2="70" stroke="#94a3b8" stroke-width="1"/>
  <text x="300" y="58" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">11 sep 2026</text>
  <text x="300" y="150" fill="#e5e7eb" font-size="12" text-anchor="middle">Meldverplichtingen</text>
  <text x="300" y="166" fill="#e5e7eb" font-size="12" text-anchor="middle">van toepassing</text>
  <text x="300" y="182" fill="#e5e7eb" font-size="12" text-anchor="middle">(art. 14)</text>
  <!-- milestone 3 -->
  <circle cx="510" cy="120" r="8" fill="#94a3b8"/>
  <line x1="510" y1="120" x2="510" y2="70" stroke="#94a3b8" stroke-width="1"/>
  <text x="510" y="58" fill="#e5e7eb" font-size="12" font-weight="bold" text-anchor="middle">~Q2 2027</text>
  <text x="510" y="150" fill="#e5e7eb" font-size="12" text-anchor="middle">Geharmoniseerde</text>
  <text x="510" y="166" fill="#e5e7eb" font-size="12" text-anchor="middle">normen geciteerd</text>
  <!-- milestone 4 -->
  <circle cx="640" cy="120" r="9" fill="#f97316" stroke="#e5e7eb" stroke-width="2"/>
  <line x1="640" y1="120" x2="640" y2="70" stroke="#94a3b8" stroke-width="1"/>
  <text x="640" y="58" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">11 dec 2027</text>
  <text x="640" y="150" fill="#e5e7eb" font-size="12" text-anchor="middle">Hoofdverplichtingen</text>
  <text x="640" y="166" fill="#e5e7eb" font-size="12" text-anchor="middle">van</text>
  <text x="640" y="182" fill="#e5e7eb" font-size="12" text-anchor="middle">toepassing</text>
  <text x="350" y="215" fill="#94a3b8" font-size="11" text-anchor="middle">Instroom over drie jaar — de aanlooptijd voor toetsing door een derde partij is al krap</text>
</svg>
```

| Datum | Wat van toepassing is |
|---|---|
| **10 december 2024** | De CRA treedt in werking. De klok begint te lopen; verplichtingen worden vanaf hier gefaseerd ingevoerd. |
| **11 juni 2026** | Hoofdstuk IV is van toepassing — conformiteitsbeoordelingsinstanties (CAB's) beginnen met notificatie en accreditatie als **aangemelde instanties**. Fabrikanten van belangrijke producten van Klasse I/II en kritieke producten moeten vanaf dit punt de betrokkenheid van een aangemelde instantie starten. |
| **11 september 2026** | De **verplichtingen voor melding van kwetsbaarheden en incidenten (artikel 14)** gelden voor **alle** producten binnen de reikwijdte, inclusief producten die jaren eerder op de markt zijn gebracht. Het centrale meldplatform van ENISA moet dan operationeel zijn. ([EC — melding](https://digital-strategy.ec.europa.eu/en/policies/cra-reporting)) |
| **30 augustus 2026** | Deadline normen: Type A horizontale beveiligingsnorm en Type B norm voor kwetsbaarheidsbeheer, te leveren door CENELEC/ETSI. |
| **30 oktober 2026** | Deadline normen: Type C verticale/productspecifieke normen, voor de categorieën uit Annex III/IV, te leveren. |
| **~Q2 2027** | Verwachte formele PBEU-vermelding van de eerste geharmoniseerde normen — waaronder **EN IEC 62443-4-1:2018/A11:2026** en **EN IEC 62443-4-2:2019/A11:2026** — waarmee het vermoeden van conformiteit wordt geactiveerd. |
| **11 december 2027** | De **hoofdverplichtingen** — essentiële eisen, conformiteitsbeoordeling, CE-markering — zijn volledig van toepassing. |

Het opzetten van processen voor veilige ontwikkeling en kwetsbaarheidsbeheer, het produceren van SBOM's en het regelen van beoordeling door een derde partij voor belangrijke en kritieke producten zijn meerjarige programma's, geen projecten voor het laatste kwartaal. Medio 2026 is **nog geen enkele geharmoniseerde CRA-norm formeel geciteerd in het Publicatieblad van de EU** — wat betekent dat geen enkele fabrikant nog een beroep kan doen op het vermoeden van conformiteit, en dat belangrijke producten van Klasse I voorlopig helemaal geen route voor zelfbeoordeling open hebben staan.

## Wat telt als een "product met digitale elementen"

De reikwijdte is bewust breed. Onder **artikel 3, lid 1**, is een **product met digitale elementen**:

> *"een software- of hardwareproduct en de bijbehorende oplossingen voor gegevensverwerking op afstand, met inbegrip van software- of hardwarecomponenten die afzonderlijk op de markt worden gebracht."*

Een product valt binnen de reikwijdte als het tijdens normaal gebruik direct of indirect wordt verbonden met een apparaat of netwerk; digitale elementen bevat (software of programmeerbare hardware); en niet al onder een EU-sectorale verordening valt die gelijkwaardige cyberbeveiligingseisen stelt. Gegevensverwerking op afstand die door of namens de fabrikant wordt uitgevoerd, valt op zichzelf al binnen de reikwijdte.

In een industriële omgeving omvat dat heel veel:

- **PLC's, RTU's en industriële controllers** — de logica die het proces aanstuurt.
- **Protocolgateways en netwerkapparatuur** — de vertalers en routers tussen OT en IT.
- **HMI's en software voor engineeringwerkstations** — de mensgerichte en configuratielagen.
- **Industriële IoT-sensoren en edge-apparaten** — de groeiende populatie verbonden eindpunten.
- **Firmware en applicatiesoftware** die op al het bovenstaande draaien, inclusief losse software die op zichzelf wordt verkocht.

Sommige categorieën zijn uitgezonderd omdat ze elders al gereguleerd zijn — producten voor nationale veiligheid en defensie, typegoedgekeurde voertuigen, en producten waarvoor een sectorspecifieke EU-verordening al een gelijke of hogere cyberbeveiligingslat legt. Als uw product op een grensvlak zit (bijvoorbeeld machines met een digitaal besturingssysteem), leest u de CRA mogelijk samen met de [Machineverordening](/nl/machine-act).

## Wie de verplichtingen draagt

De CRA volgt de waardeketen, en het gewicht is niet gelijk verdeeld.

| Rol | Kernverplichting onder de CRA |
|---|---|
| **Fabrikant** | Materiële verplichtingen: veilig ontwerp, naleving van Annex I, SBOM, kwetsbaarheidsbeheer, ondersteuningsperiode, melding, conformiteitsbeoordeling, CE-markering. |
| **Importeur** | Verifieert de conformiteitsbeoordeling, technische documentatie en CE-markering van de fabrikant; voegt eigen contactgegevens toe; bewaart 10 jaar traceerbaarheidsgegevens; treedt op bij non-conformiteit. |
| **Distributeur** | Handelt met de nodige zorgvuldigheid; verifieert dat CE-markering en conformiteitsverklaring het product vergezellen; mag geen producten aanbieden waarvan hij weet of zou moeten weten dat ze niet-conform zijn; bewaart 10 jaar traceerbaarheidsgegevens. |

> [!WARNING]
> **U kunt "fabrikant" worden zonder uzelf ooit zo te noemen.** Onder **artikel 21** nemen importeurs en distributeurs de volledige verplichtingen van een fabrikant op zich als zij een product onder hun eigen naam of merk op de markt brengen, of een **substantiële wijziging** aanbrengen aan een product dat al op de markt is. Een OEM die de fabricage uitbesteedt aan een entiteit buiten de EU en het product onder eigen merk in de EU verkoopt, draagt alle verplichtingen van artikel 13, ongeacht de contractvoorwaarden — contractuele doorschuiving van aansprakelijkheid naar de ODM houdt geen stand tegenover een markttoezichtautoriteit. Systeemintegratoren en operatoren die een apparaat herlabelen, de firmware opnieuw flashen of significant wijzigen, moeten precies weten waar die grens ligt — per product, vóór 2027.

Die trigger van "substantiële wijziging" is degene die OT-teams verrast. Een wijziging is "substantieel" als deze ofwel de naleving van Annex I beïnvloedt, ofwel het beoogde gebruik van het product verandert (**artikel 3, lid 30**). Routinematig onderhoud, gelijkwaardige reparaties en beveiligingspatches zijn **standaard geen** substantiële wijzigingen (**overweging 42**) — maar een volledige upgrade van een SCADA-platform, of het toevoegen van IIoT-connectiviteit aan een voorheen niet-genetwerkt apparaat, is dat doorgaans wel. Een machinebouwer die een controller van een derde integreert en de lijn onder eigen naam levert, of een integrator die na 2027 een renovatie uitvoert die deze grens overschrijdt, erft de volledige verplichtingenstapel van een fabrikant — inclusief de minimale ondersteuningsperiode van 5 jaar, gerekend vanaf de datum van de wijziging.

## Productklassen en conformiteitsbeoordeling

Niet alle producten worden gelijk behandeld. De CRA sorteert PDE's op criticaliteit, en de klasse bepaalt hoe rigoureus de conformiteit moet worden aangetoond. De classificatie ligt vast in **Uitvoeringsverordening (EU) 2025/2392 van de Commissie** (gepubliceerd op 1 december 2025), die technische beschrijvingen geeft voor de categorieën van Annex III (Belangrijk) en Annex IV (Kritiek). Classificatie is geen papierwerkexercitie — het is de beslissing die uw tijdpad, uw budget bepaalt, en of er een aangemelde instantie tussen u en de CE-markering staat. ([EC — conformiteitsbeoordeling](https://digital-strategy.ec.europa.eu/en/policies/cra-conformity-assessment))

| Klasse | Voorbeelden (Annex III / IV) | Conformiteitsroute |
|---|---|---|
| **Standaard** | De grote meerderheid van producten, niet vermeld in een van beide annexen — consumenten-IoT, slimme speakers, mobiele apps, videogames, de meeste niet-veiligheidskritische industriële apparaten. | **Zelfbeoordeling** (Module A, interne controle) tegen de essentiële eisen — altijd toegestaan. |
| **Belangrijk — Klasse I** | Besturingssystemen (desktop/server/mobiel), browsers, wachtwoordmanagers, VPN-software, SIEM, netwerkrouters/-switches, fysieke en virtuele netwerkinterfaces, niet-veiligheidskritische IACS-producten. | Zelfbeoordeling (Module A) **alleen indien** een geharmoniseerde norm volledig wordt toegepast; anders **Module B+C of H** via een aangemelde instantie. |
| **Belangrijk — Klasse II** | Firewalls, IDS/IPS, hypervisors, HSM's, tamperbestendige microprocessoren, veiligheidskritische IACS, industriële robots. | **Altijd Module B+C of Module H** via een aangemelde instantie — zelfbeoordeling is wettelijk niet mogelijk, punt uit. |
| **Kritiek** | Smartcards, HSM's, slimme-metergateways in kritieke infrastructuur, bepaalde beveiligingsproducten op chipniveau (Annex IV). | Verplichte **Europese cyberbeveiligingscertificering**; waar nog geen regeling bestaat, gelden de regels van Belangrijk Klasse II. |

> **De kijk van OXOT op deze tabel:** veel ICS-componenten — inclusief veiligheidskritische IACS-producten — vallen in Belangrijk Klasse II, waarmee zelfbeoordeling volledig wordt uitgesloten. Die ene classificatiebeslissing is degene die de meeste OT-fabrikanten onderschatten: het is het verschil tussen een interne engineering-goedkeuring en een wachtrij van maanden bij een aangemelde instantie.

### Klasse I in de praktijk — waar "wel of niet zelfbeoordelen" werkelijk van afhangt

Klasse I is de enige klasse waarin de fabrikant een echte keuze heeft, en die keuze wordt volledig bepaald door technische discipline, niet door intentie.

- **Traject A — Zelfbeoordeling (Module A, interne controle).** Alleen toegestaan **als en alleen als** de fabrikant volledig EU-geharmoniseerde normen of gemeenschappelijke specificaties toepast (de aankomende geharmoniseerde EN IEC 62443-profielen, zodra deze zijn geciteerd). Tot die vermelding er is, is dit traject gesloten voor OT-producten van Klasse I.
- **Traject B — Verplichte beoordeling door een derde partij (Module B+C of Module H).** Als een fabrikant een geharmoniseerde norm niet volledig toepast, verliest deze het recht op zelfbeoordeling en volgt dezelfde route via een derde partij als bij een Klasse II-product: een onafhankelijke aangemelde instantie die een EU-typeonderzoek uitvoert (Module B+C), of een volledige audit van kwaliteitsborging van de ontwikkelingscyclus van de fabrikant (Module H).

Welk traject ook van toepassing is, fabrikanten van Klasse I moeten dezelfde onderbouwing leveren om aan te tonen dat het product "secure-by-design" is en vrij van bekende exploiteerbare kwetsbaarheden bij release:

| Bewijsgebied | Wat het aantoont |
|---|---|
| Dreigingsmodellering & risicobeoordeling in de ontwerpfase | Beveiligingsrisico is beoordeeld voordat code werd geschreven; vertrouwensgrenzen en beoogde gebruiksscenario's zijn in kaart gebracht. |
| Geautomatiseerde codeanalyse (SAST/DAST) | Zowel broncode als draaiende applicatie worden getest op gebreken als onderdeel van de ontwikkelpijplijn. |
| Software Composition Analysis (SCA) & SBOM-generatie | Componenten van derden en open source worden doorlopend gescand; er wordt een machineleesbare SBOM gegenereerd en onderhouden voor de gehele ondersteuningsperiode. |
| Penetratietesten & kwetsbaarheidsbeheer | Actief testen om zwakheden vóór lancering weg te nemen, plus een mechanisme voor veilige, integriteitsbeschermde levering van updates wanneer nieuwe gebreken aan het licht komen. |
| Diepgaande hardware-/firmwareverificatie (fysieke Klasse I-apparaten) | Voor routers, netwerkinterfaces en vergelijkbare hardware volstaat standaard IT-scannen niet — toegangscontroles, state-of-the-art cryptografie voor data in rust/onderweg, integriteit van secure boot, en beperking van het aanvalsoppervlak (uitschakelen van ongebruikte fysieke poorten) moeten allemaal worden gevalideerd. |

### Klasse II in de praktijk — de aangemelde instantie beoordeelt twee dingen

Producten van Klasse II worden behandeld als een wezenlijk hoger cyberbeveiligingsrisico, en zelfbeoordeling is **wettelijk verboden** — er is geen versie van deze klasse waarin een interne goedkeuring volstaat. Om een CE-markering aan te brengen, moet de fabrikant een verplichte audit door een aangemelde instantie doorlopen, of gebruikmaken van een toepasselijke Europese cyberbeveiligingscertificeringsregeling op "substantieel" of "hoog" betrouwbaarheidsniveau.

De aangemelde instantie beoordeelt het product op twee categorieën:

**1. De beoordelingsprocedure ("hoe")**

- **Module B + C (EU-typeonderzoek):** de aangemelde instantie voert een grondig onderzoek uit van het technisch ontwerp, de ontwikkeling en de processen voor kwetsbaarheidsbeheer van het product, en test rechtstreeks een fysiek of digitaal exemplaar. Module C vereist vervolgens dat de fabrikant ervoor zorgt dat elke volgende productie-eenheid overeenkomt met dat goedgekeurde exemplaar.
- **Module H (volledige kwaliteitsborging):** in plaats van één eenheid te bemonsteren, audit de aangemelde instantie de volledige cyclus van veilige ontwikkeling en het kwaliteitsmanagementsysteem van de fabrikant. Als de audit bevestigt dat het proces inherent en consistent CRA-conforme output oplevert, kan de productie doorgaan.

**2. De essentiële cyberbeveiligingseisen ("wat")**

- Geen bekende exploiteerbare kwetsbaarheden bij release, onderbouwd met een gedocumenteerde risicobeoordeling.
- Security-by-design en by-default: minimaal aanvalsoppervlak, strikte toegangscontroles, veilige configuratie direct uit de doos.
- State-of-the-art cryptografie voor data in rust en onderweg — geen verouderde of zelfgemaakte algoritmes.
- Beveiliging op hardwareniveau voor apparaten zoals tamperbestendige microprocessoren: hardware-vertrouwensankers (roots of trust), integriteit van secure boot, fysieke tamperbestendigheid.
- Veilige, grotendeels automatische updates met een duidelijke opt-out voor professionele gebruikers.
- Een machineleesbare SBOM (SPDX of CycloneDX) die alle afhankelijkheden bijhoudt om snel patchen mogelijk te maken.
- Een toegezegde ondersteuningsperiode — in de regel niet korter dan 5 jaar.

Dit alles wordt samengebracht in een technisch documentatiedossier — risicobeoordelingen, architectuurontwerpen, SBOM, testrapporten — dat ten minste 10 jaar of de ondersteuningsperiode wordt bewaard, welke van beide langer is.

## Annex I, Deel I — de beveiligingseigenschappen van het product

Annex I is waar de CRA concreet wordt, en bestaat uit twee delen. **Deel I** regelt hoe het product zelf zich moet gedragen. De overkoepelende norm, in **punt (1)**, is dat producten zodanig moeten worden ontworpen, ontwikkeld en geproduceerd dat een *"passend niveau van cyberbeveiliging op basis van de risico's"* wordt gewaarborgd. Punt (2) somt vervolgens 13 specifieke eigenschappen op die deze norm invullen. ([Annexen CRA](https://www.cyberresilienceact.eu/annexes.html))

| Beveiligingseigenschap | Wat dit in de praktijk vereist |
|---|---|
| **Geen bekende exploiteerbare kwetsbaarheden** | Leveren zonder bekende, exploiteerbare gebreken — kwetsbaarheidsbeheer vóór release, niet erna. |
| **Secure by default** | Geleverd met een veilige configuratie direct uit de doos; geen universele standaardwachtwoorden; een manier om terug te zetten naar een veilige fabrieksstandaardstaat. |
| **Mogelijkheid tot beveiligingsupdates** | Automatische beveiligingsupdates standaard ingeschakeld, met een duidelijke opt-out, gebruikersmelding en de mogelijkheid om uit te stellen. |
| **Toegangscontrole & authenticatie** | Bescherming tegen ongeautoriseerde toegang met passende authenticatie, identiteitsbeheer en rolgebaseerde toegangscontrole; melding van mogelijke pogingen tot ongeautoriseerde toegang. |
| **Vertrouwelijkheid** | Data in rust en onderweg beschermd met state-of-the-art versleuteling — zowel opgeslagen data, verzonden data, command-and-control-verkeer als inloggegevens en sleutels. |
| **Integriteit** | Bescherming van opgeslagen/verzonden data, commando's en configuratie tegen aantasting; melding van integriteitsschendingen. |
| **Dataminimalisatie** | Alleen data verwerken die adequaat, relevant en beperkt is tot wat het product nodig heeft. |
| **Beschikbaarheid & veerkracht** | Bescherming van essentiële functies; weerstand bieden aan en herstellen van denial-of-service; waar haalbaar functioneren in afgeslankte modus behouden. |
| **Geminimaliseerd aanvalsoppervlak** | Onnodige diensten, poorten en protocollen standaard uitschakelen; de software-footprint verkleinen. |
| **Beperking van incidentimpact** | Terugvalwerking, geleidelijke degradatie, netwerksegmentatie, isolatie van gecompromitteerde onderdelen. |
| **Beveiligingslogging & monitoring** | Beveiligingsrelevante gebeurtenissen registreren en monitoren; logs beschikbaar stellen aan gebruikers; een opt-out toestaan (maar standaard ingeschakeld laten). |
| **Veilig wissen van data** | Een mogelijkheid voor de gebruiker om data en configuratie veilig en permanent te wissen, met name bij buitengebruikstelling. |
| **Beperking van blootstelling aan aanvallen** | De vangnetverplichting op engineeringgebied — veilige codering, beveiliging van supply-chaincomponenten, integriteit van de build, architecturale keuzes die het exploiteerbare oppervlak verkleinen. |

> [!NOTE]
> **Niet elke eis geldt voor elk product, maar stilzwijgen is geen optie.** Onder **artikel 13, leden 3–4**, moet de risicobeoordeling aangeven welke van deze 13 eisen van toepassing zijn en hoe ze zijn geïmplementeerd — en waar een eis werkelijk niet van toepassing is (een product dat nooit data verzendt, heeft geen verplichting tot vertrouwelijkheid van data onderweg), moet de fabrikant een **duidelijke, schriftelijke motivering** opnemen in de technische documentatie. Een ongedocumenteerde "niet van toepassing" is een compliancetekortkoming, geen kortere weg.

## Bijlage I, deel II — kwetsbaarheidsbeheer en de SBOM

**Deel II** regelt het proces dat een fabrikant gedurende de hele ondersteuningsperiode moet uitvoeren. Dit is de operationele discipline achter de beveiligingseigenschappen van het product, en dit geldt voor elke fabrikant, ongeacht de productklasse.

| Verplichting kwetsbaarheidsbeheer | Wat het betekent |
|---|---|
| **Componenten identificeren & documenteren** | Weet wat er in het product zit, inclusief een **software bill of materials (SBOM)** die ten minste de belangrijkste afhankelijkheden dekt, in een algemeen gebruikt machineleesbaar formaat. |
| **Onverwijld verhelpen** | Kwetsbaarheden snel aanpakken en verhelpen, onder meer via **gratis beveiligingsupdates** gedurende de ondersteuningsperiode; beveiligingsfixes waar mogelijk scheiden van functionele releases. |
| **Regelmatig testen** | Een doorlopend, gepland programma — periodieke penetratietests, geautomatiseerde CVE-scans tegen de actuele SBOM, en regressietests — geen eenmalige controle vóór de release. |
| **Openbare bekendmaking van fixes** | Zodra een fix beschikbaar is, de ernst, impact en het herstel ervan publiceren — vergelijkbaar met de CVE/CNA-advisorypraktijk. |
| **Gecoördineerde openbaarmaking** | Een CVD-beleid voeren en publiceren, met een aangewezen centraal contactpunt dat voor gebruikers gemakkelijk te vinden is. |
| **Melding stroomopwaarts** | Bij het identificeren van een kwetsbaarheid in een component van een derde partij of open source, dit melden aan de beheerder van dat component — en waar passend een ontwikkelde patch delen. |
| **Veilige distributie** | Updates distribueren met integriteitsbescherming en authenticatie, zodat het updatekanaal zelf geen aanvalsvector voor de toeleveringsketen kan worden. |
| **Informatie-uitwisseling** | Op verzoek informatie verstrekken aan bevoegde autoriteiten over het aantal kwetsbaarheden, de ernst en het beleid voor de afhandeling ervan. |

> [!NOTE]
> **Waarom de SBOM belangrijker is dan het lijkt.** Industriële producten worden opgebouwd uit lagen van componenten van derden en open source. De SBOM-verplichting dwingt fabrikanten om daadwerkelijk te weten wat er in hun producten zit en om de kwetsbaarheden die deze componenten met zich meebrengen te volgen. Een verouderde SBOM is op zichzelf al een compliancerisico — hij kan de 24-uursmeldingsklok van artikel 14 niet ondersteunen als u niet eens weet dat een kwetsbaar component in het product zit. Voor operators is een SBOM van een leverancier een directe input voor uw eigen risicobeeld — en iets redelijks om ruim vóór 2027 bij inkoop te eisen.

## Volledig overzicht van verplichtingen — de levenscyclus van de fabrikant

Van begin tot eind gelezen beschrijft de CRA een levenscyclus, geen eenmalige poort, en het is nuttig om het geheel te zien uitgezet tegen de artikelen die het creëren.

| Fase van de levenscyclus | Juridische basis | Wat moet bestaan |
|---|---|---|
| **Classificeren** | Artikelen 6–8, Bijlage III/IV, Uitv. Verord. 2025/2392 | Product ingedeeld als Standaard / Belangrijk I / Belangrijk II / Kritiek — bepaalt de conformiteitsroute. |
| **Ontwerp & bouw** | Artikel 13, lid 1–3 | Beveiliging wordt overwogen gedurende *"planning, ontwerp, ontwikkeling, productie, levering en onderhoud"*; de risicobeoordeling documenteert welke eisen van Bijlage I van toepassing zijn en hoe. |
| **Kwetsbaarheidsbeheer** | Artikel 13, lid 2–3, Bijlage I deel II | SBOM-pijplijn, CVD-beleid, centraal contactpunt, regelmatig testen — operationeel vóór 11 september 2026. |
| **Technische documentatie** | Artikel 31, Bijlage VII | Productbeschrijving, risicobeoordeling, bewijs van naleving van Bijlage I, SBOM, toegepaste normen, testrapporten, resultaten van de conformiteitsbeoordeling, DoC, onderbouwing van de ondersteuningsperiode. Bewaard gedurende 10 jaar of de ondersteuningsperiode, indien langer. |
| **Conformiteitsbeoordeling** | Artikel 32 | Module A (zelf), Module B+C (typeonderzoek door aangemelde instantie + productiecontrole), Module H (volledige KA), of Europese cyberbeveiligingscertificering voor kritieke producten. |
| **Verklaring & markering** | Artikelen 28, 30, Bijlage V | EU-conformiteitsverklaring met verwijzing naar Verordening (EU) 2024/2847; CE-markering pas aangebracht zodra de DoC bestaat. |
| **Gebruikersinformatie** | Artikel 13, lid 18, Bijlage II | Contactgegevens fabrikant, CVD-URL, beoogd gebruik, bekende risico's, verwijzing naar de DoC, einddatum ondersteuningsperiode, instructies voor veilig gebruik — in een taal die gebruikers begrijpen. |
| **Ondersteuningsperiode** | Artikel 13, lid 8 | In beginsel **ten minste 5 jaar** gratis beveiligingsupdates; korter alleen indien werkelijk gerechtvaardigd door de verwachte levensduur van het product. |
| **Melding** | Artikel 14 | 24 uur vroegtijdige waarschuwing → 72 uur gedetailleerde melding → 14 dagen/1 maand eindrapport aan ENISA + CSIRT, voor actief misbruikte kwetsbaarheden en ernstige incidenten — van kracht vanaf **11 september 2026**, voor alle producten binnen het toepassingsgebied, ongeacht de datum van marktplaatsing. |
| **Bewaring** | Artikel 13, lid 13 | Technisch dossier en DoC bewaard gedurende 10 jaar vanaf marktplaatsing, of de ondersteuningsperiode, indien langer. |

```svg
<svg viewBox="0 0 700 300" xmlns="http://www.w3.org/2000/svg" font-family="system-ui, sans-serif">
  <!-- top row blocks -->
  <rect x="20" y="40" width="150" height="60" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="95" y="66" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Veilig ontwerp</text>
  <text x="95" y="84" fill="#94a3b8" font-size="11" text-anchor="middle">Bijlage I deel I</text>

  <rect x="200" y="40" width="150" height="60" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="275" y="66" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">SBOM &amp;</text>
  <text x="275" y="84" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">componenten</text>

  <rect x="380" y="40" width="150" height="60" rx="8" fill="none" stroke="#f97316" stroke-width="2"/>
  <text x="455" y="66" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Conformiteit</text>
  <text x="455" y="84" fill="#94a3b8" font-size="11" text-anchor="middle">beoordeling + CE</text>

  <rect x="540" y="40" width="140" height="60" rx="8" fill="#f97316" fill-opacity="0.12" stroke="#f97316" stroke-width="2"/>
  <text x="610" y="76" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Op de markt</text>

  <!-- arrows top row -->
  <line x1="170" y1="70" x2="200" y2="70" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr)"/>
  <line x1="350" y1="70" x2="380" y2="70" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr)"/>
  <line x1="530" y1="70" x2="540" y2="70" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr)"/>

  <!-- down into lifecycle band -->
  <line x1="610" y1="100" x2="610" y2="160" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr)"/>

  <!-- lifecycle band -->
  <rect x="60" y="170" width="440" height="70" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="280" y="198" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Kwetsbaarheidsbeheer &amp; beveiligingsupdates</text>
  <text x="280" y="220" fill="#94a3b8" font-size="11" text-anchor="middle">Ondersteuningsperiode — in beginsel ≥ 5 jaar (Bijlage I deel II)</text>

  <rect x="530" y="170" width="150" height="70" rx="8" fill="#f97316" fill-opacity="0.12" stroke="#f97316" stroke-width="2"/>
  <text x="605" y="198" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Melding</text>
  <text x="605" y="218" fill="#94a3b8" font-size="11" text-anchor="middle">24u / 72u / eindrapport</text>

  <line x1="530" y1="205" x2="500" y2="205" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr)"/>

  <!-- feedback loop -->
  <path d="M 60 205 Q 20 205 20 140 Q 20 70 20 70" fill="none" stroke="#94a3b8" stroke-width="1.5" stroke-dasharray="4 4" marker-end="url(#arr)"/>
  <text x="30" y="270" fill="#94a3b8" font-size="11" text-anchor="start">Bevindingen worden teruggekoppeld naar ontwerp en updates</text>

  <defs>
    <marker id="arr" markerWidth="8" markerHeight="8" refX="6" refY="3" orient="auto">
      <path d="M0,0 L6,3 L0,6 Z" fill="#94a3b8"/>
    </marker>
  </defs>
</svg>
```

## De conformiteitsbeoordelingsroute per productklasse

De klasse waarin u terechtkomt, bepaalt wie het product afkeurt of goedkeurt en hoeveel tijd dat kost om te regelen. Dit is de beslissing die de planning meer stuurt dan het engineeringwerk zelf.

```svg
<svg viewBox="0 0 700 320" xmlns="http://www.w3.org/2000/svg" font-family="system-ui, sans-serif">
  <rect x="20" y="20" width="200" height="50" rx="8" fill="none" stroke="#94a3b8" stroke-width="2"/>
  <text x="120" y="50" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Product classificeren</text>

  <line x1="120" y1="70" x2="120" y2="100" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr2)"/>

  <!-- Default -->
  <rect x="20" y="100" width="150" height="60" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="95" y="124" fill="#e5e7eb" font-size="12" font-weight="bold" text-anchor="middle">Standaard</text>
  <text x="95" y="142" fill="#94a3b8" font-size="10" text-anchor="middle">Module A</text>
  <text x="95" y="155" fill="#94a3b8" font-size="10" text-anchor="middle">zelfbeoordeling</text>

  <!-- Class I -->
  <rect x="190" y="100" width="150" height="60" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="265" y="120" fill="#e5e7eb" font-size="12" font-weight="bold" text-anchor="middle">Belangrijk Klasse I</text>
  <text x="265" y="138" fill="#94a3b8" font-size="10" text-anchor="middle">Module A indien norm</text>
  <text x="265" y="151" fill="#94a3b8" font-size="10" text-anchor="middle">volledig toegepast — anders B+C/H</text>

  <!-- Class II -->
  <rect x="360" y="100" width="150" height="60" rx="8" fill="none" stroke="#f97316" stroke-width="2"/>
  <text x="435" y="120" fill="#e5e7eb" font-size="12" font-weight="bold" text-anchor="middle">Belangrijk Klasse II</text>
  <text x="435" y="138" fill="#94a3b8" font-size="10" text-anchor="middle">Altijd Module B+C</text>
  <text x="435" y="151" fill="#94a3b8" font-size="10" text-anchor="middle">of Module H</text>

  <!-- Critical -->
  <rect x="530" y="100" width="150" height="60" rx="8" fill="#f97316" fill-opacity="0.12" stroke="#f97316" stroke-width="2"/>
  <text x="605" y="120" fill="#e5e7eb" font-size="12" font-weight="bold" text-anchor="middle">Kritiek</text>
  <text x="605" y="138" fill="#94a3b8" font-size="10" text-anchor="middle">Europese cyber-</text>
  <text x="605" y="151" fill="#94a3b8" font-size="10" text-anchor="middle">certificeringsregeling</text>

  <line x1="120" y1="70" x2="95" y2="100" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#arr2)"/>
  <line x1="120" y1="70" x2="265" y2="100" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#arr2)"/>
  <line x1="120" y1="70" x2="435" y2="100" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#arr2)"/>
  <line x1="120" y1="70" x2="605" y2="100" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#arr2)"/>

  <line x1="95" y1="160" x2="95" y2="200" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr2)"/>
  <line x1="265" y1="160" x2="265" y2="200" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr2)"/>
  <line x1="435" y1="160" x2="435" y2="200" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr2)"/>
  <line x1="605" y1="160" x2="605" y2="200" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr2)"/>

  <rect x="20" y="200" width="660" height="55" rx="8" fill="none" stroke="#94a3b8" stroke-width="1.5" stroke-dasharray="3 3"/>
  <text x="350" y="222" fill="#e5e7eb" font-size="12" font-weight="bold" text-anchor="middle">Technisch dossier (Bijlage VII) + EU-conformiteitsverklaring (Artikel 28)</text>
  <text x="350" y="240" fill="#94a3b8" font-size="10" text-anchor="middle">Dezelfde documentatiebasis ongeacht de route — alleen wie ervoor tekent, verschilt</text>

  <line x1="350" y1="255" x2="350" y2="275" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr2)"/>
  <rect x="250" y="275" width="200" height="35" rx="8" fill="#f97316" fill-opacity="0.15" stroke="#f97316" stroke-width="2"/>
  <text x="350" y="297" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">CE-markering aangebracht</text>

  <defs>
    <marker id="arr2" markerWidth="8" markerHeight="8" refX="6" refY="3" orient="auto">
      <path d="M0,0 L6,3 L0,6 Z" fill="#94a3b8"/>
    </marker>
  </defs>
</svg>
```

## De ondersteuningsperiode — een nieuwe vorm voor leveranciersrelaties

Een van de meest praktisch ingrijpende eisen van de CRA is de **ondersteuningsperiode**: fabrikanten moeten beveiligingsupdates leveren gedurende een periode die passend is voor het product, en **in beginsel ten minste vijf jaar** (korter alleen wanneer het product naar verwachting korter in gebruik zal zijn). Technische documentatie en de EU-conformiteitsverklaring moeten ten minste tien jaar worden bewaard, of de ondersteuningsperiode indien langer.

Voor industriële apparatuur die doorgaans een decennium of langer draait, verandert dit de commerciële relatie ingrijpend — en creëert het een reëel inkooprisico voor greenfieldlocaties. Een PLC die in 2028 wordt geïnstalleerd op een locatie die naar verwachting tot 2048 in bedrijf blijft, heeft een operationele horizon van 20 jaar; de ondergrens van de CRA is slechts 5 jaar. Tenzij een leverancier zich contractueel verbindt tot een langere ondersteuningsperiode, draait de locatie het grootste deel van haar operationele levensduur met componenten die niet meer onder de CRA worden ondersteund. Beveiligingsondersteuning is niet langer een geste van goede wil die vervalt zodra een productlijn wordt uitgefaseerd, maar wordt een wettelijke verwachting over een vastgestelde levensduur. Voor kopers is de ondersteuningsperiode een onderhandelingsanker: u kunt een leverancier houden aan een vastgelegde termijn, en u kunt vragen wat er gebeurt bij het einde van de ondersteuning voordat u tekent.

## Melding — de 24-uursklok

De CRA introduceert een scherp, gefaseerd meldingsregime onder **artikel 14**. **Actief misbruikte kwetsbaarheden** en **ernstige incidenten** die de productbeveiliging aantasten, moeten via één enkel meldingsplatform worden gemeld aan de nationale **CSIRT** van de fabrikant en, gelijktijdig, aan **ENISA**. ([EC — melding](https://digital-strategy.ec.europa.eu/en/policies/cra-reporting))

| Fase | Termijn | Inhoud |
|---|---|---|
| **Vroegtijdige waarschuwing** | Binnen **24 uur** nadat men zich ervan bewust wordt | Eerste melding dat een actief misbruikte kwetsbaarheid of ernstig incident bestaat, en welke lidstaten het product heeft bereikt — zodat CSIRT's de waarschuwing aan elkaar kunnen doorgeven. |
| **Gedetailleerde melding** | Binnen **72 uur** | Productinformatie, aard van het misbruik en de kwetsbaarheid, genomen en voor gebruikers beschikbare corrigerende/mitigerende maatregelen, gevoeligheidsclassificatie van het rapport. |
| **Eindrapport** | **14 dagen** (kwetsbaarheid, nadat een fix beschikbaar is) / **1 maand** (ernstig incident) | Beschrijving, ernst, impact, informatie over de kwaadwillende actor indien bekend, en details van de geleverde beveiligingsupdate. ([CRA-meldingstermijnen](https://www.cyberresilienceact.eu/reporting.html)) |

> [!WARNING]
> **De 24-uursplicht werkt met terugwerkende kracht, ook al is het product dat niet.** De meldingsplicht van artikel 14 geldt vanaf 11 september 2026 voor *alle* producten binnen het toepassingsgebied, ongeacht wanneer ze op de markt zijn geplaatst. Een leverancier kan niet stellen "dit SCADA-systeem dateert van vóór de CRA" — als hij na die datum kennis krijgt van actief misbruik, start de klok op precies dezelfde manier als voor een product uit 2028. Bouw eerst de detectie- en meldingspijplijn; die moet al bestaan ruim voordat het conformiteitswerk voor het product is afgerond.

Nog twee operationele gevolgen. Ten eerste loopt de gebruikersmelding onder **artikel 14, lid 8** parallel aan de regelgevende melding, niet erna — getroffen gebruikers moeten worden geïnformeerd, bij voorkeur in een gestructureerd, machineleesbaar formaat, op hetzelfde moment dat ENISA en de CSIRT worden ingelicht. Ten tweede is de melding een eenmalige indiening: één rapport via het platform bereikt de CSIRT en ENISA, die dit vervolgens doorgeven aan andere getroffen CSIRT's. Micro- en kleine ondernemingen krijgen enige verlichting van sancties bij het missen van de 24-uurstermijn voor kwetsbaarheden, maar de verplichting zelf blijft onverkort gelden.

> [!TIP]
> Behandel CRA-melding en uw [NIS2](/nl/nis2)-incidentmelding als één detectie- en responscapaciteit, niet als twee aparte zaken. De onderliggende vaardigheid — een ernstige gebeurtenis herkennen, bepalen dat deze meldingsplichtig is, en binnen een dag een eerste melding versturen — is dezelfde. Bouw het eenmalig.

## Sancties — CRA en NIS2 vergeleken

Niet-naleving van de **essentiële eisen of de kernverplichtingen van de fabrikant** kan boetes opleveren tot **€15 miljoen of 2,5% van de totale wereldwijde jaaromzet**, afhankelijk van welk bedrag hoger is. Handhaving vindt plaats door nationale markttoezichtautoriteiten, en boetes gelden **per product** — een fabrikant met meerdere niet-conforme productlijnen kan met meerdere, cumulatieve sancties worden geconfronteerd.

| Niveau | Overtreding | CRA-plafond (hoogste van) |
|---|---|---|
| **Niveau 1** | Essentiële eisen van Bijlage I; verplichtingen van de fabrikant onder artikel 13; meldingsverplichtingen van artikel 14 | **€15.000.000** of **2,5%** van de wereldwijde jaaromzet |
| **Niveau 2** | Verplichtingen van marktdeelnemers (Artikelen 18–23); Conformiteitsverklaring (Artikel 28); CE-markering / technische documentatie (Artikelen 30–31); conformiteitsbeoordeling (Artikel 32) | **€10.000.000** of **2%** van de wereldwijde jaaromzet |
| **Niveau 3** | Het verstrekken van onjuiste, onvolledige of misleidende informatie aan een aangemelde instantie of markttoezichtautoriteit | **€5.000.000** of **1%** van de wereldwijde jaaromzet |

**Hoe dit zich verhoudt tot NIS2:** de twee regimes verschillen structureel, niet alleen in cijfers. NIS2 begrenst boetes voor essentiële entiteiten op **€10 miljoen**, maar de scherpste kant ervan is **persoonlijke aansprakelijkheid** — het houdt bestuursorganen rechtstreeks verantwoordelijk voor tekortkomingen in het cyberrisicobeheer, los van de bedrijfsboete. De CRA kent geen gelijkwaardige clausule voor persoonlijke aansprakelijkheid; het drukmiddel is uitsluitend de aan de omzet gekoppelde boete, toegepast per niet-conform product. Samen sluiten ze de cirkel vanuit beide richtingen: NIS2 maakt een bestuurder persoonlijk aanspreekbaar op de wijze waarop zijn organisatie risico's beheert; de CRA zorgt ervoor dat de producten die die organisatie koopt of bouwt een afdwingbare cyberbeveiligingsondergrens dragen.

Net als bij NIS2 en de [AI Act](/nl/ai-act) is de koppeling aan de omzet weloverwogen: productbeveiliging is nu een risico op bestuursniveau, geen begrotingspost die leeft en sterft binnen engineering. ([Pillsbury — CRA-vereisten](https://www.pillsburylaw.com/en/news-and-insights/eu-cyber-resilience-act-requirements-products-software.html))

```cta
Niet zeker of u fabrikant, integrator of importeur bent onder de CRA?
Uw rol of productklasse verkeerd inschatten is de duurste fout in CRA-gereedheid — en de klokken voor ondersteuning en melding lopen al. Wij brengen het in kaart voordat ze aflopen.
Bepaal mijn CRA-verplichtingen :: /nl/contact
```

## Product of systeem? De scopingvraag die alles bepaalt

Nog voordat één Bijlage I-maatregel wordt gekozen, bepaalt één bedrieglijk eenvoudige vraag het hele compliancetraject: **wat is precies uw "product"?** De CRA beantwoordt dit in **Artikel 3(1)** — een product met digitale elementen is *"een software- of hardwareproduct en de bijbehorende oplossingen voor gegevensverwerking op afstand, met inbegrip van software- of hardwarecomponenten die afzonderlijk in de handel worden gebracht."* ([EUR-Lex, officiële tekst](https://eur-lex.europa.eu/eli/reg/2024/2847/oj/eng))

Het gevolg is makkelijk te missen en duur om verkeerd te doen. De CRA is van toepassing op **elke individuele producteenheid die op de EU-markt wordt gebracht** — niet op een systeem, een installatie of een geconfigureerde oplossing. Dat is de fundamentele architectonische breuk met [IEC 62443](/nl/iec-62443), dat redeneert op het niveau van een *System Under Consideration* opgebouwd uit zones en conduits. Twee fabrikanten die dezelfde hardware leveren, kunnen daardoor volledig verschillende verplichtingen hebben, afhankelijk van hoe ze die in de handel brengen:

- Wordt een verpakte automatiseringsoplossing met vier interne zones als **één geïntegreerd product** in de handel gebracht, dan behandelt de CRA het als één product met één conformiteitsverklaring onder **Artikel 28**.
- Wordt elk zone-apparaat **afzonderlijk** in de handel gebracht, dan wordt elk een **onafhankelijk beoordeeld product** — met een eigen risicobeoordeling, een eigen technisch dossier en mogelijk een eigen conformiteitsroute.

> [!IMPORTANT]
> Deze product-versus-systeem-scoping is het meest voorkomende punt van verwarring voor OT- en ICS-fabrikanten, die van nature in *systemen* denken, niet in *producten*. Het verkeerd inschatten werkt door: het bepaalt de conformiteitsroute, of een aangemelde instantie verplicht is, en de volledige omvang van het technisch dossier. Dit moet als eerste worden vastgesteld — vóór ontwerp, vóór maatregelen, vóór enige 62443-afstemming.

## Hoe de CRA risico kalibreert — het "waar van toepassing"-mechanisme

De CRA gebruikt nooit Security Levels. Het kalibratiemechanisme is de **cybersecurityrisicobeoordeling** uit **Artikel 13(2) en (3)** — en dit begrijpen is het verschil tussen rigoureuze, verdedigbare compliance en óf over-engineering óf niet-naleving.

**Artikel 13(2)** verplicht fabrikanten om *"een beoordeling uit te voeren van de cybersecurityrisico's die verbonden zijn aan een product met digitale elementen"* en de uitkomst mee te nemen in alle levensfasen. **Artikel 13(3)** koppelt die beoordeling rechtstreeks aan de maatregelen: zij moet *"aangeven of, en zo ja op welke wijze, de beveiligingseisen in Bijlage I, deel I, punt (2), van toepassing zijn."* ([EUR-Lex](https://eur-lex.europa.eu/eli/reg/2024/2847/oj/eng))

De proportionaliteitspoort zit in twee begrippen. **Bijlage I, deel I, punt (1)** stelt de norm — producten moeten *"een passend niveau van cyberbeveiliging op basis van de risico's"* waarborgen. Het woord **"passend"** is de juridische haak voor proportionaliteit. **Bijlage I, deel I, punt (2)** somt vervolgens de specifieke technische eigenschappen op (toegangscontrole, vertrouwelijkheid, integriteit, beschikbaarheid, minimaal aanvalsoppervlak, en meer) die gelden *"op basis van de risicobeoordeling en **waar van toepassing**."*

Die zinsnede — **"waar van toepassing"**, versterkt door **Overweging 55** — is bepalend. Waar een specifieke essentiële eis niet relevant is voor het beoogde doel of risicoprofiel van een product, hoeft de fabrikant die niet te implementeren, **mits** een duidelijke schriftelijke rechtvaardiging is vastgelegd in de technische documentatie onder **Artikel 13(4)**.

```keyfacts
Scope-eenheid :: Het individuele product (Art. 3(1)) — niet het systeem
Risicomechanisme :: Cybersecurityrisicobeoordeling (Art. 13(2)–(3))
Proportionaliteitshaak :: "passend" + "waar van toepassing" (Bijlage I, deel I)
Niet-toepassing :: Toegestaan met schriftelijke rechtvaardiging (Art. 13(4), Overw. 55)
Equivalent aan :: IEC 62443 SL-T-differentiatie — als uitkomst uitgedrukt
```

De commerciële inzet is reëel. Een fabrikant die een rigoureuze, verdedigbare Artikel 13(2)–(3)-beoordeling kan schrijven en nauwkeurig aan Bijlage I koppelt, vermijdt het over-implementeren van maatregelen die het risicoprofiel niet vereist. Wie dat niet kan, staat voor het omgekeerde: óf de boetes van Artikel 64, óf de dode last van elk product engineeren op een maximale specificatie die het nooit nodig had.

## IEC 62443 Security Levels afbeelden op CRA-conformiteit

De meeste betrokken OT-fabrikanten bezitten al [IEC 62443](/nl/iec-62443)-certificeringen — en ontdekken dat **geen van die certificaten automatisch aan de CRA voldoet.** De twee kaders zijn rond verschillende conformiteitseenheden opgebouwd, dus de afbeelding moet bewust worden opgebouwd.

| Dimensie | IEC 62443 | Cyber Resilience Act |
|---|---|---|
| Conformiteitseenheid | System Under Consideration; zones & conduits | Het individuele product op de markt |
| Risicokalibratie | Security Levels SL-1 → SL-4 per zone | Risicobeoordeling (Art. 13(2)–(3)), "waar van toepassing" |
| Bewijs van naleving | SL-C-certificaat per component; SL-A per zone | Technisch dossier (Bijlage VII) + conformiteitsverklaring |
| Beoordeling door derden | Optioneel (62443-4-2 SL-C-certificering) | Verplicht voor Belangrijk Klasse I (zonder geharmoniseerde norm) en Klasse II |
| Target/Capability/Achieved | SL-T / SL-C / SL-A zijn onderscheiden | Samengevoegd tot één gedocumenteerde, risico-gerechtvaardigde uitkomst |

De brug is even conceptueel als technisch: **SL-T** (het doel dat een zone vereist) wordt de *input* voor de Artikel 13(2)-beoordeling; **SL-C** (de gecertificeerde capaciteit van een component) wordt *bewijs* voor de componenteisen van Bijlage I, deel II; en **SL-A** (wat een zone werkelijk bereikt) heeft geen directe CRA-tegenhanger, omdat de CRA stopt bij de productgrens. Een 62443-4-2 SL-C-certificaat is krachtig ondersteunend bewijs in een CRA-technisch dossier — maar geen vervanging voor de Bijlage I-traceerbaarheid die de CRA vereist.

## De kloof in geharmoniseerde normen — en de wachtrij bij aangemelde instanties

De conformiteitsroutes van de CRA leunen sterk op **geharmoniseerde normen**: haal er één aan in het Publicatieblad van de EU, en een fabrikant van een Belangrijk Klasse I-product kan met een vermoeden van conformiteit zelf beoordelen. Het probleem in 2026–2027 is timing. Medio 2026 is **nog geen enkele geharmoniseerde norm voor de CRA in het Publicatieblad aangehaald**, en de verwachte kandidaat — **EN IEC 62443-4-2 met een A11 CRA-afstemmingsbijlage** — wordt pas rond **Q2 2027** verwacht, enkele maanden vóór de hoofdverplichtingen op **11 december 2027**.

> [!WARNING]
> Totdat een geharmoniseerde norm is aangehaald, moet **elk Belangrijk Klasse I-product zonder norm — en elk Klasse II-product ongeacht — via een aangemelde instantie** worden beoordeeld. De capaciteit van aangemelde instanties voor de CRA is eindig en wordt nu opgebouwd. Wie wacht op de norm, riskeert een wachtrij die al is ontstaan, met een vaste en onwrikbare deadline.

Dit is de praktische reden waarom CRA-readiness niet tot 2027 kan wachten: de meldmachinerie is al verschuldigd in **september 2026**, en de conformiteitsroute voor hogere klassen loopt via derden waarvan de capaciteit ruim vóór de deadline schaars is.

## De schaal van de deadline — 100.000 fabrikanten, één datum

De CRA is geen nicheverplichting. De effectbeoordeling van de Europese Commissie identificeert in de orde van **100.000–110.000 marktdeelnemers** die producten met digitale elementen op de EU-markt brengen — die overgrote meerderheid moet conformiteit bereiken vóór **dezelfde datum van 11 december 2027**. Daarbovenop komt de meldplicht vanaf **11 september 2026** voor **elk reeds op de markt gebracht product**, inclusief langlevende industriële apparatuur van jaren geleden.

Voor OT is die samenloop bijzonder scherp: industriële producten zijn langlevend, opgebouwd uit diepe toeleveringsketens, en zitten vaak in veiligheidsgerelateerde functies waar de [Machineverordening](/nl/machine-act) en, voor AI-gestuurde componenten, de [AI Act](/nl/ai-act) tegelijk gelden. Fabrikanten die de CRA als weer een losse checklist behandelen, voldoen laat en duur. Wie hem opneemt in één risicogebaseerd productbeveiligingsprogramma — verankerd in het 62443-werk dat de meesten al hebben — voldoet in één keer.

## OXOT's methodologie voor de afstemming van CRA en IEC 62443

Dit is waar OXOT's eigen analyse verder gaat dan de algemene compliance-literatuur. Het zone-gedifferentieerde Security Level (SL)-raamwerk van IEC 62443 laat zich **niet** één-op-één afbeelden op de CRA — de twee regimes zijn opgebouwd rond verschillende eenheden. Maar het eigen risicogebaseerde proportionaliteitsmechanisme van de CRA levert een functioneel gelijkwaardig resultaat op, en OXOT heeft een herhaalbare methodologie ontwikkeld om tussen beide te vertalen.

### Waarom de twee raamwerken niet standaard op elkaar aansluiten

| | IEC 62443 | CRA |
|---|---|---|
| **Beoordelingseenheid** | System Under Consideration (SuC) — zones en conduits | Het individuele product dat op de EU-markt wordt geplaatst (Artikel 3, lid 1) |
| **Risicokalibratie** | Security Levels, SL-1 tot SL-4, toegekend per zone | Risicobeoordeling onder artikel 13, lid 2–3, toegepast "waar van toepassing" per eis van Bijlage I |
| **Nalevingsbewijs** | SL-C-certificaat per component; SL-A per zone na implementatie | Technisch dossier onder Bijlage VII + EU-conformiteitsverklaring |
| **Beoordeling door derden** | Optioneel (SL-C-certificering volgens IEC 62443-4-2) | Verplicht voor Belangrijk Klasse I zonder geharmoniseerde norm, en altijd voor Klasse II |
| **Status geharmoniseerde norm** | N.v.t. | EN IEC 62443-4-1/A11:2026 en -4-2/A11:2026 nog niet gepubliceerd in het PBEU (verwacht rond Q2 2027) |

Als uw "product" onder de CRA een volledig geïntegreerd systeem is met vier zones, behandelt de CRA dit als **één product** met **één conformiteitsverklaring**. Als elk zone-apparaat afzonderlijk op de markt wordt geplaatst, wordt elk zelfstandig beoordeeld. Bepalen welke van die twee u daadwerkelijk bent, is in de ervaring van OXOT het meest voorkomende punt van verwarring voor OT-fabrikanten — van wie de meesten in systemen denken, niet in producten — en het is de eerste vraag die onze methodologie beantwoordt.

### De proportionaliteitsbrug: SL-T als input voor de CRA-risicobeoordeling

De CRA gebruikt geen Security Levels. Het kalibratiemechanisme is de risicobeoordeling van artikel 13, lid 2–3, gestuurd door het woord **"passend"** in Bijlage I, deel I, punt (1) — *"een passend niveau van cyberbeveiliging op basis van de risico's"* — en geoperationaliseerd via de formulering **"waar van toepassing"** in punt (2).

De kernbevinding van OXOT: **een zone-/conduit-risicobeoordeling volgens IEC 62443-3-2, die zonespecifieke SL-T-waarden oplevert, is een volledig legitieme methodologie om te voldoen aan de risicobeoordelingseis van artikel 13, lid 2–3 van de CRA.** Een component met SL-C = 2 in een werkelijk laagrisicozone (SL-T = 2) is geen onder-implementatie — het is de correcte, verdedigbare CRA-basislijn voor die zone, mits de risicobeoordeling documenteert waarom. De hogere-SL Requirement Enhancements die een component in Zone 1 of Zone 4 nodig zou hebben, worden voor het component in Zone 3 terecht als "niet van toepassing" gemarkeerd — maar alleen met een schriftelijke, risicogebaseerde rechtvaardiging onder **artikel 13, lid 4**. Ongedocumenteerde niet-toepasselijkheid is geen kortere weg; het is een compliancetekortkoming die wacht om bij een audit te worden ontdekt.

> [!IMPORTANT]
> **De voorwaarde die de meeste zelfbeoordelingen doorbreekt:** IEC 62443 staat toe dat de behaalde beveiliging van een zone (SL-A) het doel (SL-T) haalt door middel van **compenserende maatregelen** — een firewall, een IDPS, een netwerkbeleid — zelfs als de capaciteit van een individueel component (SL-C) lager is. De productniveau-beoordeling van de CRA evalueert de **geïntegreerde** beveiligingshouding, niet geïsoleerde componentspecificaties. Als een component op SL-C = 2 zit in een zone met SL-T = 3, moet het technisch dossier expliciet documenteren *hoe* de compenserende maatregelen de SL-A van die zone naar 3 tillen — een claim van compenserende maatregelen zonder documentatie is een CRA-non-conformiteit, geen formaliteit.

### FR-naar-Bijlage-I-mapping — de traceerbaarheidsmatrix die een aangemelde instantie verwacht

De zeven Foundational Requirements (FR's) van IEC 62443-4-2 — elk opgebouwd uit gestapelde, cumulatieve Component Requirements (CR's) en Requirement Enhancements (RE's) over SL-1 tot SL-4 — worden rechtstreeks afgebeeld op specifieke subeisen van Bijlage I, deel I, punt (2) van de CRA. Deze mapping is de traceerbaarheidsmatrix die een aangemelde instantie zal verwachten in een technisch dossier van Klasse I of II, en vormt de ruggengraat van de Fase 1-beoordeling die OXOT oplevert.

| Eis van Bijlage I (2) van de CRA | Primaire IEC 62443 FR | Wat SL-2 doorgaans biedt | Wat SL-3 toevoegt |
|---|---|---|---|
| **(b)** Bescherming tegen ongeautoriseerde toegang | FR1 Identification & Authentication Control, FR2 Use Control | Unieke accounts, RBAC, PKI voor authenticatie tussen componenten | MFA voor alle gebruikers, ACL's per gebruiker, hardware-authenticators |
| **(c)** Vertrouwelijkheid van gegevens | FR4 Data Confidentiality | AES-128+ tijdens transport, veilig verwijderen | Encryptie in rust met hardwarematig sleutelbeheer |
| **(d)** Integriteit van gegevens en programma's | FR3 System Integrity | TLS, codeondertekening voor updates, gedefinieerde foutstatussen | Hardware root of trust, secure boot, measured launch |
| **(e)** Minimalisatie / beperkte gegevensstroom | FR5 Restricted Data Flow | Logische segmentatie, filtering op zonegrenzen | Fysieke segmentatie, deep packet inspection voor OT-protocollen (Modbus, OPC UA, DNP3) |
| **(f)** Beschikbaarheid van essentiële functies | FR7 Resource Availability | Basale DoS-bescherming, resourcelimieten | DoS-bestendigheid op applicatieniveau, gracieuze degradatie |
| **(h)** Beperking van aanvalsoppervlakken | FR5 (RDF), FR3 (SI) | Filtering op zonegrenzen | Minimale functionaliteit, deny-by-default |
| **(j)** Beveiligingslogging en -monitoring | FR6 Timely Response to Events | Toegankelijke auditlogs, real-time detectie | SIEM-export (Syslog/CEF/LEEF), afwijkingsdetectie, tamper-evident logs |

De escalatie van SL-2 naar SL-3 op FR1 — het toevoegen van multifactorauthenticatie en hardware-authenticators — is, in de ervaring van OXOT bij het uitvoeren van deze beoordelingen, de meest voorkomende tekortkoming voor OT-componenten die overgaan van een laagrisico- naar een hoogrisico-zoneclassificatie.

### De synergetische methode, in vijf stappen

De methodologie van OXOT behandelt IEC 62443 niet als vervanging van CRA-conformiteit, maar als de technische inhoud die de bewust op resultaat gerichte eisen van de CRA invult:

1. **Bepaal de reikwijdte van het "product."** Bepaal wat een enkel product vormt onder artikel 3, lid 1 — een volledig systeem met één conformiteitsverklaring, of afzonderlijk op de markt geplaatste zone-apparaten die elk een zelfstandige beoordeling vereisen.
2. **Voer de zone-/conduit-risicobeoordeling uit (IEC 62443-3-2).** Genereer SL-T-waarden per zone, met een gedocumenteerde karakterisering van de dreigingsactor volgens IEC 62443-1-1. Dit *is* de risicobeoordeling van artikel 13, lid 2 van de CRA — geen parallel traject.
3. **Breng FR/CR/RE-diepgang in kaart tegenover Bijlage I, per zone.** Leg voor elke subeis van Bijlage I, punt (2) vast welke FR/CR/RE-combinatie deze implementeert, op welke SL-diepgang, in elke zone.
4. **Documenteer niet-toepasselijkheid en compenserende maatregelen.** Elke niet-geïmplementeerde Requirement Enhancement krijgt een rechtvaardiging onder artikel 13, lid 4; elk gat waarbij SL-C < SL-T krijgt een aantoning van compenserende maatregelen dat de zone toch SL-A ≥ SL-T bereikt.
5. **Stel het technisch dossier volgens Bijlage VII samen.** Risicobeoordeling, nalevingsmatrix van Bijlage I (met FR/CR/RE-traceerbaarheid), SBOM, geraadpleegde normen (met verwijzing naar IEC 62443-4-1/4-2 als "andere relevante technische specificatie" onder Bijlage VII §5 tot formele harmonisatie), en het conformiteitsbeoordelingstraject — Module A, B+C of H, zoals de classificatie voorschrijft.

**Totdat EN IEC 62443-4-1/A11:2026 en -4-2/A11:2026 formeel zijn gepubliceerd in het PBEU**, ondersteunen IEC 62443-certificaten het technische betoog in het dossier, maar leveren zij op zichzelf geen vermoeden van conformiteit op. Fabrikanten die al volgens 62443 hebben gebouwd, hebben het grootste deel van het onderliggende technische werk al verricht — het gat dat OXOT dicht, is de gedocumenteerde, artikelsgewijs onderbouwde vertaling van SL-C-certificaten naar een nalevingsmatrix van Bijlage I die een aangemelde instantie of markttoezichtautoriteit daadwerkelijk zal accepteren.

## De CRA-synergiestroom

```svg
<svg viewBox="0 0 700 380" xmlns="http://www.w3.org/2000/svg" font-family="system-ui, sans-serif">
  <rect x="30" y="20" width="290" height="60" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="175" y="46" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">IEC 62443-3-2</text>
  <text x="175" y="64" fill="#94a3b8" font-size="11" text-anchor="middle">Zone/conduit-risicobeoordeling → SL-T per zone</text>

  <rect x="380" y="20" width="290" height="60" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="525" y="46" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">CRA artikel 13(2)–(3)</text>
  <text x="525" y="64" fill="#94a3b8" font-size="11" text-anchor="middle">Cyberbeveiligingsrisicobeoordeling — "waar van toepassing"</text>

  <line x1="320" y1="50" x2="380" y2="50" stroke="#f97316" stroke-width="2.5" marker-end="url(#arr3)"/>
  <text x="350" y="40" fill="#f97316" font-size="10" text-anchor="middle">voldoet aan</text>

  <line x1="175" y1="80" x2="175" y2="110" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr3)"/>
  <line x1="525" y1="80" x2="525" y2="110" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr3)"/>

  <rect x="30" y="110" width="290" height="60" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="175" y="136" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">FR/CR/RE per zone</text>
  <text x="175" y="154" fill="#94a3b8" font-size="11" text-anchor="middle">SL-C behaald door elk component</text>

  <rect x="380" y="110" width="290" height="60" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="525" y="136" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Bijlage I, deel I, punt (2)</text>
  <text x="525" y="154" fill="#94a3b8" font-size="11" text-anchor="middle">13 essentiële eisen, in kaart gebracht per zone</text>

  <line x1="320" y1="140" x2="380" y2="140" stroke="#f97316" stroke-width="2.5" marker-end="url(#arr3)"/>
  <text x="350" y="130" fill="#f97316" font-size="10" text-anchor="middle">koppelt aan</text>

  <line x1="175" y1="170" x2="175" y2="200" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr3)"/>
  <line x1="525" y1="170" x2="525" y2="200" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr3)"/>

  <rect x="30" y="200" width="290" height="60" rx="8" fill="none" stroke="#94a3b8" stroke-width="2" stroke-dasharray="3 3"/>
  <text x="175" y="226" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Hiaten: SL-C &lt; SL-T</text>
  <text x="175" y="244" fill="#94a3b8" font-size="11" text-anchor="middle">Compenserende maatregelen gedocumenteerd</text>

  <rect x="380" y="200" width="290" height="60" rx="8" fill="none" stroke="#94a3b8" stroke-width="2" stroke-dasharray="3 3"/>
  <text x="525" y="226" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Niet-toepasselijke RE's</text>
  <text x="525" y="244" fill="#94a3b8" font-size="11" text-anchor="middle">Schriftelijke motivering artikel 13(4)</text>

  <line x1="320" y1="230" x2="380" y2="230" stroke="#f97316" stroke-width="2.5" marker-end="url(#arr3)"/>

  <line x1="175" y1="260" x2="350" y2="300" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr3)"/>
  <line x1="525" y1="260" x2="350" y2="300" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr3)"/>

  <rect x="200" y="300" width="300" height="60" rx="8" fill="#f97316" fill-opacity="0.15" stroke="#f97316" stroke-width="2"/>
  <text x="350" y="326" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Technisch dossier bijlage VII</text>
  <text x="350" y="344" fill="#94a3b8" font-size="11" text-anchor="middle">Traceerbaarheidsmatrix die een aangemelde instantie zal verwachten</text>

  <defs>
    <marker id="arr3" markerWidth="8" markerHeight="8" refX="6" refY="3" orient="auto">
      <path d="M0,0 L6,3 L0,6 Z" fill="#94a3b8"/>
    </marker>
  </defs>
</svg>
```

## De CRA en OT — twee kanten van dezelfde medaille

De CRA en NIS2 zijn complementaire helften van één strategie. **[NIS2](/nl/nis2)** verplicht operators om het risico van de systemen die zij gebruiken te beheren; de CRA verplicht fabrikanten om die systemen om te beginnen beveiligbaar te maken. De NIS2-plicht rond de toeleveringsketen van een operator (artikel 21) wordt veel makkelijker na te komen wanneer de producten in de keten CRA-conform zijn — geleverd met SBOM's, beveiligingsupdates en een ondersteuningstoezegging in plaats van een schouderophaal.

Voor operators die vanaf 2028 greenfield-faciliteiten in gebruik nemen, moeten inkoopspecificaties de CRA nu expliciet benoemen: CE-markeringsreferentie, DoC-referentienummer, einddatum van de ondersteuningsperiode, leveringsformaat van de SBOM (SPDX of CycloneDX), en de URL van het CVD-beleid van de leverancier. Voor renovaties en retrofits van bestaande installaties na 2027 is de kernvraag of de wijziging een **substantiële wijziging** vormt — een gelijkwaardige vervanging en beveiligingspatches leiden doorgaans niet tot volledige CRA-conformiteitsplicht; het toevoegen van nieuwe digitale functionaliteit, of een SCADA-upgrade op platformniveau, doorgaans wel.

**[IEC 62443](/nl/iec-62443)** blijft de natuurlijke technische brug voor OT-leveranciers, en **[TS 50701](/nl/ts-50701)** breidt diezelfde discipline uit naar de spoorsector. Waar de CRA juridisch bindend maar standaardagnostisch is, levert 62443 de concrete technische inhoud — een combinatie die ook goed aansluit op het bredere landschap van [raamwerken](/nl/frameworks).

## Het CRA Readiness-aanbod van OXOT

```carousel
CRA Readiness Assessment (bijlage A)
Een gestructureerde hiaatbeoordeling tegen de essentiële eisen van de CRA, per product afgebakend. Wij classificeren elk product volgens bijlage III/IV en Uitvoeringsverordening (EU) 2025/2392, bepalen welke conformiteitsroute daadwerkelijk vereist is, en stellen een geprioriteerde hiaatlijst op tegen bijlage I deel I en deel II — geen pass/fail, maar een concrete lijst van wat moet veranderen voordat een conformiteitsverklaring verdedigbaar is.
---
CRA Preparation Service
Waar de beoordeling hiaten vindt, is dit de uitvoerende arm: het bouwen van de kwetsbaarheidsafhandelingsmachine (SBOM-pijplijn, CVD-beleid, centraal contactpunt, testcadans), het samenstellen van het technisch dossier volgens bijlage VII, en het gereedmaken van het product voor de toepasselijke conformiteitsroute — zelfbeoordelingsbewijs voor Default en Klasse I met een geharmoniseerde norm, of een dossier dat klaar is voor een aangemelde instantie voor Klasse I zonder norm, Klasse II en kritieke producten.
---
Statutes 2-Pager-metgezel
Een beknopt, productspecifiek naslagwerk dat uw productcategorie direct koppelt aan de geldende CRA-statuten — classificatieniveau, toepasselijke eisen uit bijlage I, conformiteitsroute en de specifieke artikelen die een marktoezichtautoriteit zal aanhalen. Ontworpen om naast het technisch dossier te liggen als snel naslagwerk voor zowel engineering- als juridische teams.
---
CRA ↔ IEC 62443-harmonisatiemethode
Ons kernonderscheid: de traceerbaarheidsmatrix van FR/CR/RE naar bijlage I, toegepast zone voor zone. Voor fabrikanten die al volgens IEC 62443 zijn gebouwd, is dit de snelste route naar een CRA-verdedigbaar technisch dossier — het vertaalt bestaande SL-C-certificaten en zonerisicobeoordelingen naar de gedocumenteerde, artikel 13(4)-conforme motiveringen die een aangemelde instantie of marktoezichtautoriteit daadwerkelijk zal accepteren.
```

## De weg naar gereedheid voor fabrikanten

Conformiteit met de CRA bereiken is een reeks stappen, geen schakelaar. De vijf onderstaande fasen volgen hoe de meeste OT-productteams zullen bewegen van "bewust van de deadline" naar "CE-markering verdedigbaar."

```carousel
Fase 1 — Afbakenen en classificeren
Inventariseer elk product met digitale elementen dat u op de EU-markt plaatst. Bepaal voor elk product de klasse: default, belangrijk Klasse I/II, of kritiek. De klasse bepaalt uw conformiteitsroute en dus uw tijdlijn. Dit is ook het moment waarop u ontdekt bij welke producten u stilzwijgend "fabrikant" bent geworden door rebranding of substantiële wijziging.
---
Fase 2 — Hiaatbeoordeling tegen bijlage I
Toets elk product aan bijlage I deel I (beveiligingseigenschappen) en deel II (kwetsbaarheidsafhandeling). Teams die al zijn afgestemd op IEC 62443-4-1/4-2 zullen zien dat veel hiervan overeenkomt — maar de koppeling moet per eis worden gedocumenteerd, niet worden aangenomen. De uitkomst is een geprioriteerde hiaatlijst, geen pass/fail — de meeste producten hebben werk nodig op een handvol specifieke gebieden, geen volledige herbouw.
---
Fase 3 — Bouw de kwetsbaarheidsafhandelingsmachine
Zet de SBOM-pijplijn, het gecoördineerde openbaarmakingsbeleid, het meldingscontact, de testcadans en het veilige updatemechanisme op. Dit is het onderdeel dat vóór 11 september 2026 operationeel moet zijn voor melding, en loopt daarmee voor op het schema — vóór het eigenlijke productconformiteitswerk.
---
Fase 4 — Conformiteitsbeoordeling en CE
Doorloop de toepasselijke procedure: zelfbeoordeling voor default en (met geharmoniseerde normen) Klasse I, of een aangemelde instantie voor Klasse II en kritieke producten. Stel de technische documentatie samen, geef de EU-conformiteitsverklaring af en breng de CE-markering aan. De capaciteit van aangemelde instanties is beperkt en doorlooptijden van 4 tot 10 maanden zijn gebruikelijk — boek vroegtijdig.
---
Fase 5 — Beheer gedurende de ondersteuningsperiode
Houd updates, monitoring en openbaarmaking in stand gedurende de ondersteuningsperiode — als regel ten minste vijf jaar. Bewaar technische documentatie gedurende tien jaar. Voed bevindingen uit het veld terug naar het ontwerp. Conformiteit is een toestand die u onderhoudt, geen certificaat dat u opbergt en vergeet.
```

## Wat het betekent voor uw rol

**Als u industriële producten fabriceert, integreert of rebrandt**, is de CRA een directe compliance-verplichting met een harde deadline in 2027 en een meldingsmijlpaal in 2026. Classificeer de portfolio, bouw processen voor veilige ontwikkeling en kwetsbaarheidsafhandeling, produceer SBOM's, verbind u aan een ondersteuningsperiode, en — voor belangrijke en kritieke producten — regel tijdig een conformiteitsbeoordeling zolang er nog capaciteit is bij aangemelde instanties.

**Als u operator of inkoper bent**, is de CRA een hefboom. Vanaf 2027 moeten de producten die u koopt aan de essentiële eisen voldoen; daarvóór kunt u al CRA-conforme verwachtingen — een SBOM, gratis beveiligingsupdates, een vastgesteld ondersteuningsvenster, een contact voor openbaarmaking — vastleggen in inkoop- en aanbestedingscriteria. De wet geeft inkopers een vocabulaire die ze nooit eerder hadden, en dat zou vorm moeten geven aan zowel uw planning van greenfield-projecten als aan renovaties na 2027.

**Als u in het bestuur van een fabrikant zit**, voegt de CRA nog een aan de omzet gekoppeld sanctieregime toe en maakt productbeveiliging een governancekwestie met een vastgesteld tijdpad. De vraag aan het management is niet "zijn we compliant?" maar "welke producten volgen welke conformiteitsroute, en wat is het kritieke pad naar 2027?"

## Hoe OXOT helpt

OXOT werkt aan beide kanten van de CRA. Voor **operators** verwerken wij CRA-conforme eisen in inkoop en in de toeleveringsketendimensie van uw NIS2- en OT-beveiligingsprogramma's, en onze **[Cyber Digital Twin](/nl/cyber-digital-twin)** geeft u een gestructureerde plek om leverancier-SBOM's en componentrisico vast te leggen, zodat een nieuwe CVE in een gedeelde bibliotheek een opzoekactie is, geen brandoefening. Voor **fabrikanten en integrators** vertalen wij bijlage I naar een technisch programma afgestemd op [IEC 62443](/nl/iec-62443)-4-1/4-2 — waarbij wij onze eigen traceerbaarheidsmethode van FR/CR/RE naar bijlage I gebruiken om van de regelgeving een concreet, onderbouwd pad naar conformiteit te maken in plaats van een compliance-hectiek.

*De CRA Readiness Assessment, Preparation Service en Statutes 2-Pager van OXOT zijn beschikbaar als losse opdrachten of als gecombineerd programma — neem contact op om uw productportfolio af te bakenen.*

## Veelgestelde vragen

**Geldt de CRA ook voor software, naast hardware?**
Ja. Standalone software is een product met digitale elementen. Firmware en applicatiesoftware vallen beide binnen het toepassingsgebied, met inachtneming van de sectorale uitzonderingen (bepaalde medische, automotive en luchtvaartproducten die elders worden gereguleerd).

**Wij integreren controllers van derden in onze machines. Zijn wij fabrikant onder de CRA?**
Mogelijk. Als u het geïntegreerde product onder uw eigen naam op de markt brengt, of componenten substantieel wijzigt, kunt u de verplichtingen van een fabrikant op u nemen. Breng uw rol per product in kaart vóór 2027 — en let scherp op de grens van "substantiële wijziging"; routinematig onderhoud en gelijkwaardige reparaties leiden doorgaans niet tot deze status, maar het toevoegen van nieuwe digitale functionaliteit of een upgrade op platformniveau doorgaans wel.

**Is een SBOM echt verplicht?**
Bijlage I deel II vereist dat fabrikanten componenten identificeren en documenteren, inclusief het opstellen van een software bill of materials, als onderdeel van kwetsbaarheidsafhandeling. Behandel het als een kernresultaat, geen optionele extra — en behandel het als een levend document, aangezien een verouderde SBOM de 24-uursmeldingsklok niet kan ondersteunen.

**Wanneer precies moeten we beginnen met melden?**
De meldingsverplichtingen van artikel 14 gelden vanaf **11 september 2026** — eerder dan de hoofdverplichtingen, en voor producten die al op de markt zijn, niet alleen nieuwe. Een actief misbruikte kwetsbaarheid of ernstig incident triggert een vroegtijdige waarschuwing binnen 24 uur, een melding binnen 72 uur, en een eindrapport (14 dagen voor een kwetsbaarheid zodra deze is verholpen, één maand voor een ernstig incident).

**Hoe lang moeten we een product ondersteunen?**
Als regel ten minste vijf jaar, of de verwachte gebruiksduur van het product indien korter. Bewaar technische documentatie en de conformiteitsverklaring gedurende ten minste tien jaar, of de ondersteuningsperiode indien langer. Onderhandel voor industriële apparatuur met een lange levensduur expliciet over een langere toezegging — de CRA stelt een ondergrens, geen bovengrens.

**Voldoet ons bestaande IEC 62443 SL-C-certificaat aan de CRA?**
Niet automatisch, en nog niet formeel. Totdat EN IEC 62443-4-1/A11:2026 en -4-2/A11:2026 worden aangehaald in het Publicatieblad van de EU (verwacht rond Q2 2027), ondersteunt 62443-certificering uw technische argumentatie als "andere relevante technische specificatie", maar verleent het geen vermoeden van conformiteit. Het levert echter wel het grootste deel van het technische bewijs dat een aangemelde instantie zal willen zien — mits gekoppeld aan specifieke eisen uit bijlage I in plaats van in algemene termen aangehaald.

**Hoe verhoudt de CRA zich tot de AI Act, NIS2 en de Machineverordening?**
De **[AI Act](/nl/ai-act)** regelt AI-systemen, de CRA regelt producten met digitale elementen, **[NIS2](/nl/nis2)** regelt operators, en de **[Machineverordening](/nl/machine-act)** regelt machineveiligheid inclusief digitale besturing. Een verbonden industriële machine met een AI-veiligheidscomponent kan alle vier raken — precies waarom één samenhangend OT-beveiligingsprogramma beter is dan vier losstaande compliance-inspanningen.

## OXOT CRA Readiness-materialen

Praktische materialen uit het CRA Readiness-programma van OXOT:

- **[CRA Readiness — verkoopblad bijlage A (PDF)](/media/OXOT-CRA-Readiness-Annex-A.pdf)** — de reikwijdte van de beoordeling, de resultaten en hoe de readiness-opdracht aansluit op de CRA-verplichtingen.

Bekijk het CRA Readiness-overzicht:

```html
<video controls preload="metadata" poster="" style="width:100%;border:1px solid rgba(148,163,184,0.35);border-radius:12px;background:#0b1220">
  <source src="/media/OXOT-CRA-Readiness.mp4" type="video/mp4" />
  Uw browser ondersteunt de video-tag niet. <a href="/media/OXOT-CRA-Readiness.mp4">Download de video</a>.
</video>
```

## Bronnen

- Verordening (EU) 2024/2847 (Cyber Resilience Act), officiële tekst — [EUR-Lex](https://eur-lex.europa.eu/eli/reg/2024/2847/oj/eng)
- Beleidsoverzicht Cyber Resilience Act — [Europese Commissie](https://digital-strategy.ec.europa.eu/en/policies/cyber-resilience-act)
- Samenvatting van de CRA-wetstekst — [Europese Commissie](https://digital-strategy.ec.europa.eu/en/policies/cra-summary)
- CRA-conformiteitsbeoordeling — [Europese Commissie](https://digital-strategy.ec.europa.eu/en/policies/cra-conformity-assessment)
- CRA-meldingsverplichtingen — [Europese Commissie](https://digital-strategy.ec.europa.eu/en/policies/cra-reporting)
- Reikwijdte, klassen en deadlines van de CRA — [cyberresilienceact.eu](https://www.cyberresilienceact.eu/explained.html)
- CRA-bijlagen I–VIII, essentiële eisen en productlijsten — [cyberresilienceact.eu](https://www.cyberresilienceact.eu/annexes.html)
- CRA-meldingstermijnen (artikel 14) — [cyberresilienceact.eu](https://www.cyberresilienceact.eu/reporting.html)
- CRA-vereisten voor verbonden producten en software — [Pillsbury Law](https://www.pillsburylaw.com/en/news-and-insights/eu-cyber-resilience-act-requirements-products-software.html)
- CENELEC TC65X WG3, webinar "EN IEC 62443 to CRA" — [cencenelec.eu](https://www.cencenelec.eu/news-events/events/2025/2025-09-09-en-iec-62443-to-cra/)
- ENISA, "CRA Practical Insights" — [enisa.europa.eu](https://www.enisa.europa.eu/sites/default/files/2025-12/session%203-1%20-%20reusch%20law%20-%20cra%20practical%20insights.pdf)
- ORCWG, officiële CRA FAQ — [cra.orcwg.org](https://cra.orcwg.org/faq/official/faq_4-1-3/)
- CRA-sancties en boetes — [eu-cyber-laws.com](https://eu-cyber-laws.com/cra/penalties/)
- OXOT interne analyse: CRA Obligations Reference, CRA Class I/II Products, CRA and NIS2 Penalties, CRA × IEC 62443 Alignment Reference (OXOT B.V. intern strategisch referentiemateriaal, 2026)

*Deze pagina bevat algemene informatie over EU-recht en vormt geen juridisch advies. Bevestig hoe de CRA van toepassing is op uw producten en rol aan de hand van de Verordening en, waar nodig, gekwalificeerd juridisch advies. De CRA↔IEC 62443-afstemmingsanalyse weerspiegelt de eigen methodologie en interpretatie van OXOT per medio 2026; formele aanhaling van de geharmoniseerde norm kan specifieke koppelingen nog verfijnen.*$MDBODY$, true, $MDBODY$Cyber Resilience Act (CRA) voor OT & producten met digitale elementen | OXOT$MDBODY$, $MDBODY$De EU Cyber Resilience Act (Verordening (EU) 2024/2847) uitgelegd voor OT — reikwijdte, productklassen, Annex I-eisen voor beveiliging en kwetsbaarheidsbeheer, SBOM, melding binnen 24 uur, ondersteuningsperiodes van ~5 jaar, het tijdpad 2024→2027, sancties en de IEC 62443-alignment-methodologie van OXOT.$MDBODY$, $MDBODY$Security-by-design wordt een wettelijke voorwaarde voor markttoegang. Een praktische gids over de reikwijdte van de CRA, productklassen, Annex I, SBOM, melding binnen 24 uur, ondersteuningsperiodes, sancties en de eigen CRA↔IEC 62443-alignment-methodologie van OXOT voor OT-fabrikanten en -afnemers.$MDBODY$, NULL, $MDBODY$page$MDBODY$, now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET
  title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published,
  meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description,
  excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type,
  published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now()
WHERE length(pages.body) < length(EXCLUDED.body);

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ($MDBODY$ai-act$MDBODY$, $MDBODY$en$MDBODY$, $MDBODY$The EU AI Act and Industrial AI$MDBODY$, $MDBODY$Artificial intelligence arrived on the plant floor without a launch date. It crept in through a vision system that a vendor bundled into an inspection cell, a predictive-maintenance module inside a drive, an "adaptive" loop in a controller firmware release. Nobody signed a policy. Nobody drew a boundary. And now AI tunes processes, grades product, forecasts failures, balances energy, and — increasingly — sits close to the safety and control functions that decide whether a line runs or trips.

The EU AI Act is the first comprehensive law in the world to govern that shift. For most people, "AI regulation" conjures chatbots and deepfakes. For an industrial operator, the provisions that bite are the quiet ones: the rules for **AI embedded in machinery, safety components and regulated products**. That is where the law reaches into operational technology, and where AI governance stops being a legal abstraction and becomes an engineering problem.

This page explains what the AI Act requires, how an industrial AI system crosses the line into "high-risk," how the law is deliberately stitched to the Machinery Regulation and the wider product-safety regime, what providers and deployers each owe, and what a proportionate response looks like in an OT environment where a manipulated model is a manipulated process.

## The short version

- The AI Act is **Regulation (EU) 2024/1689**. It entered into force on **1 August 2024** and switches on in phases. ([EUR-Lex, official text](https://eur-lex.europa.eu/eli/reg/2024/1689/oj/eng))
- It is **risk-based**: a short list of **prohibited** practices, a demanding **high-risk** tier, lighter **transparency** duties for limited-risk systems, and no new obligations for minimal-risk AI.
- Industrial AI most often becomes high-risk through **Annex I** — where the AI is a safety component of, or is itself, a product covered by EU harmonisation law such as the **Machinery Regulation**. A second route runs through **Annex III** critical-infrastructure use.
- **Providers** (who develop or place AI on the market) carry the heavy obligations; **deployers** (who use it) carry a lighter but real set of duties. Modify a system enough and a deployer *becomes* a provider.
- High-risk systems must satisfy Articles 8–15: risk management, data governance, logging, transparency, human oversight, and — the line OT teams should read twice — **accuracy, robustness and cybersecurity** under **Article 15**.
- Penalties reach **€35 million or 7% of worldwide turnover** for prohibited practices, and **€15 million or 3%** for breaching high-risk obligations. ([Article 99](https://artificialintelligenceact.eu/article/99/))
- The high-risk deadlines were **pushed back** by the **Digital Omnibus** — politically agreed on 7 May 2026, **endorsed by the European Parliament on 16 June 2026**, and **given final adoption by the Council on 29 June 2026**, with Official Journal publication imminent. Standalone Annex III systems now apply from **2 December 2027**, and product-embedded Annex I AI from **2 August 2028**. ([Council of the EU, 29 June 2026](https://www.consilium.europa.eu/en/press/press-releases/2026/06/29/artificial-intelligence-council-gives-final-green-light-to-simplify-and-streamline-rules/))

> [!NOTE]
> The honest headline for industry: **most industrial AI is not high-risk.** Process optimisation, quality analytics and maintenance forecasting that never touch a safety or control function sit in the minimal tier. The real work is finding the handful of systems that *do*, classifying them correctly, and governing them without smothering the useful ninety percent.

```keyfacts
Instrument :: Regulation (EU) 2024/1689 — directly applicable, no national transposition
In force since :: 1 August 2024, phased application
Prohibitions live :: 2 February 2025 (Article 5)
AI-literacy duty live :: 2 February 2025 (Article 4)
GPAI obligations live :: 2 August 2025
High-risk (Annex III) :: 2 December 2027 (deferred by Digital Omnibus)
High-risk (Annex I, incl. machinery) :: 2 August 2028 (deferred)
Top fine :: €35 mln or 7% of worldwide turnover (prohibited practices)
The OT-critical article :: Article 15 — accuracy, robustness, cybersecurity
Regulator :: national market-surveillance authorities + the EU AI Office (GPAI)
```

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

Then the timeline moved. On **7 May 2026**, negotiators from the Council, Parliament and Commission reached a provisional political agreement on the **Digital Omnibus on AI** — a simplification package that, among other things, **deferred the high-risk deadlines**. That agreement has since hardened into law: the **European Parliament endorsed it on 16 June 2026**, and the **Council gave its final green light on 29 June 2026**, with publication in the Official Journal expected within weeks and entry into force on the third day after. Under the adopted text, standalone **Annex III** high-risk systems apply from **2 December 2027** (a slip from the original 2 August 2026), and product-embedded **Annex I** AI applies from **2 August 2028**. ([Council of the EU](https://www.consilium.europa.eu/en/press/press-releases/2026/06/29/artificial-intelligence-council-gives-final-green-light-to-simplify-and-streamline-rules/); [White & Case](https://www.whitecase.com/insight-alert/eu-agrees-digital-omnibus-deal-simplify-ai-rules))

```timeline
1 Aug 2024 :: **Regulation enters into force.** The AI Act is published in the Official Journal; the phased application clock starts. *(In force)*
2 Feb 2025 :: **Article 5 prohibitions + Article 4 AI-literacy duty apply.** Banned practices are illegal; staff who operate AI must have baseline literacy. *(In force)*
2 Aug 2025 :: **Governance rules + GPAI model obligations apply.** The AI Office stands up; general-purpose-model providers take on documentation and transparency duties. *(In force)*
2 Aug 2026 :: **Transparency and other non-deferred provisions apply.** These dates were *not* pushed back by the Omnibus and remain live. *(In force)*
2 Dec 2026 :: **New prohibition** on AI-generated non-consensual intimate imagery and CSAM. *(Adopted — Omnibus)*
2 Dec 2027 :: **High-risk obligations for standalone Annex III systems** — deferred from the original 2 Aug 2026. *(Adopted — Omnibus)*
2 Aug 2028 :: **High-risk obligations for Annex I product-embedded AI** (including machinery). *(Adopted — Omnibus)*
```

> [!WARNING]
> The deferral is real and now legally grounded — but read the fine print. The Omnibus moved the *high-risk* dates; it did **not** move the prohibitions (live since February 2025), the AI-literacy duty (also live), the GPAI obligations (live since August 2025), or the transparency provisions due **2 August 2026**. If your organisation deployed anything caught by those, the extra time on high-risk does nothing for you. Plan against your specific system's route and its specific date, not against a single headline. ([Latham & Watkins](https://www.lw.com/en/insights/ai-act-update-eu-resolves-to-change-rules-and-extend-deadlines))

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

### The Article 6(3) escape — and why it is not a shrug

Route 2 has a release valve, and it is worth understanding precisely, because it is the provision most often invoked and most often misapplied. **Article 6(3)** says an AI system listed in Annex III is **not** high-risk if it does not pose a significant risk of harm to health, safety or fundamental rights — *including by not materially influencing the outcome of decision-making* — where **any one** of four conditions is met. ([Article 6, EU AI Act](https://artificialintelligenceact.eu/article/6/))

```compare
Falls OUT of high-risk (Art. 6(3))
- **(a) Narrow procedural task** — the AI does something bounded and mechanical, e.g. structuring or transforming data to a fixed template
- **(b) Improves a completed human activity** — it polishes or refines output a human has already produced, without setting the direction
- **(c) Detects decision-making patterns / deviations** — it flags divergence from a prior human pattern but is *not* meant to replace or influence the human assessment without proper review
- **(d) Performs a preparatory task** — it prepares an input for an assessment, but does not itself make the assessment
---
Stays IN high-risk
- The AI **profiles a natural person** — profiling always keeps a system high-risk, no derogation available
- The AI **materially influences the outcome** of a safety or rights-relevant decision
- The AI **replaces** meaningful human judgement in the loop
- You cannot **document and defend** why one of the four conditions genuinely applies
```

Two cautions make the difference between a defensible classification and a costly mistake. First, the Commission's guidance is explicit that the four conditions must be **interpreted narrowly** — they are exits for genuinely peripheral AI, not a loophole to reclassify a system you would rather not govern. Second, if you rely on Article 6(3) you must **register** the system and **record your assessment** before placing it on the market or putting it into service; the burden of proof sits with you, and a market-surveillance authority can demand the reasoning. ([Data Protection Report, applying the Commission's guidelines](https://www.dataprotectionreport.com/2026/05/is-my-use-case-a-high-risk-ai-system-applying-the-commissions-guidelines-and-next-steps/)) In an OT setting the honest read is that a system genuinely wired into a *safety component* rarely qualifies — the moment its output can move a hazard, it is materially influencing an outcome the law cares about.

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

### Article 9 — a risk-management system that never closes

Article 9 is the spine the other requirements hang from. It demands a **continuous, iterative** risk-management process running across the entire lifecycle of a high-risk system — not a one-time assessment filed at launch. You identify and analyse the known and reasonably foreseeable risks the system can pose to health, safety and fundamental rights; you estimate the risks that emerge from *intended use* and from *reasonably foreseeable misuse*; you evaluate risks from post-market monitoring data; and you adopt targeted measures to manage them. For OT, the phrase that does the work is "reasonably foreseeable misuse." A vision model trained on a clean, well-lit line will meet a night shift, a dirty lens, a swapped fixture and an operator who leans a part against the housing to save a second — and the risk file has to have imagined that world, not the demo. Article 9 also pushes you toward testing against **defined metrics and probabilistic thresholds** appropriate to the intended purpose, which is exactly where a model's failure modes stop being a research curiosity and start being a documented safety boundary.

### Article 10 — data governance, where the risk is often born

Article 10 requires that training, validation and testing datasets be **relevant, sufficiently representative, and to the best extent possible free of errors and complete** in view of the intended purpose, with appropriate attention to the specific setting in which the system will be used. It obliges you to examine datasets for **bias** that could affect health, safety or fundamental rights, and to identify gaps and shortcomings. In an industrial context the fundamental-rights framing feels distant, but the representativeness requirement is pure engineering: a defect-detection model trained only on summer product, or on one supplier's raw material, or on a single machine's tolerances, is not "representative" of the process it will police — and that gap is where both quality failures and Article 10 non-conformities are born. Good data governance here is the same discipline that makes the model *work*; the Act simply makes it auditable.

### Article 14 — human oversight, and the automation-bias trap

Article 14 requires that high-risk systems be designed so that they can be **effectively overseen by natural persons** during use — with the interface, the information and the tooling a person actually needs to understand the system's limits, watch for signs of anomalous behaviour, correctly interpret its output, decide *not* to use it in a given case, and **intervene or stop** it. The subtle requirement is guarding against **automation bias**: the well-documented human tendency to over-trust a confident machine, especially under time pressure. A "human in the loop" who rubber-stamps whatever the model says at line speed is not oversight in the sense Article 14 means. In a control room, meaningful oversight means the operator can see *why* the system acted, has the authority and the physical means to override it, and has been trained to distrust it at the right moments. This is where AI governance and OT human-factors engineering are the same conversation — and where the [Cyber Digital Twin](/en/cyber-digital-twin) view of what-connects-to-what helps an operator reason about a model's blast radius before, not during, an incident.

## Providers versus deployers

The Act splits duties by role, and getting your role right decides your obligations. The distinction is not academic — the same organisation can be a deployer of one system and, without meaning to, the provider of another.

| | **Provider** (Art. 16) | **Deployer** (Art. 26) |
|---|---|---|
| Who | Develops the AI or has it developed, and places it on the market / puts it into service under its own name | Uses a high-risk AI system under its own authority — most industrial operators |
| Core duties | Quality management system; full technical documentation; conformity assessment; EU declaration of conformity; CE marking; registration in the EU database; post-market monitoring | Use per instructions; ensure human oversight by competent people; ensure input data is relevant/representative; monitor operation, suspend and report on emerging risk; keep logs (min. 6 months) |
| Typical actor in OT | OEM, machine builder, integrator, model vendor | Plant operator, utility, asset owner |
| The trap | — | Substantially modify, retrain, or rebrand a high-risk system and you may **become the provider** — inheriting the full provider obligations |

**Providers** carry the weight, and in practice that is your OEM, integrator or model vendor. ([Article 16](https://artificialintelligenceact.eu/article/16/)) **Deployers** carry a lighter but concrete set of duties, and where you deploy AI that affects workers, you may owe them information as well. ([Article 26](https://artificialintelligenceact.eu/article/26/)) The line between the two is the one to watch at procurement and at every firmware upgrade: the moment you retrain a vendor's safety model on your own data, you have very likely stepped across it.

### The modification trap, spelled out

Article 25 is where a deployer quietly turns into a provider. You inherit the **full provider obligations** for a high-risk system if you **put your own name or trademark on it**, if you make a **substantial modification** that keeps it high-risk, or if you **change its intended purpose** such that a previously non-high-risk system becomes high-risk. In an OT context all three are ordinary maintenance events dressed as legal thresholds.

```compare
Stays a deployer (Art. 26 duties)
- Uses the system **as instructed** by the provider
- Applies vendor updates and patches within the intended purpose
- Feeds it representative input data and monitors output
- Keeps logs, ensures competent human oversight, reports emerging risk
---
Becomes a provider (Art. 25 → Art. 16 duties)
- **Retrains** the model on its own data to change performance
- **Re-brands** the system or ships it onward under its own name
- **Repurposes** it — a quality model rewired to make a safety decision
- **Substantially modifies** it beyond the provider's declared design
```

The reason this matters is cost and liability: the provider owns conformity assessment, the technical file, the declaration of conformity, post-market monitoring and the Article 15 evidence. Crossing the line by accident — a well-meant retrain to reduce nuisance trips — can transfer that entire burden to you without anyone signing anything. Check before you modify; document the decision either way.

## A note on general-purpose AI

Separate from the risk tiers, the Act sets rules for **general-purpose AI (GPAI) models** — the large foundation models that can be adapted to many tasks. Their obligations (technical documentation, a copyright-compliance policy, a public summary of training data, and cooperation with the AI Office) applied from **2 August 2025**, and the Commission — through the AI Office — can supervise and fine GPAI providers directly under Article 101.

A second, heavier tier sits on top: models with **systemic risk**. Under **Article 51**, a GPAI model is presumed to carry systemic risk when the cumulative compute used for its training exceeds **10²⁵ floating-point operations (FLOPs)** — a threshold aimed at the largest frontier models. Those providers take on extra duties: model evaluation and adversarial testing (red-teaming), systemic-risk assessment and mitigation, serious-incident tracking and reporting, and a baseline of cybersecurity for the model and its physical infrastructure. Many providers meet these through the **GPAI Code of Practice**, the co-regulatory instrument the Commission facilitated to give a presumption of compliance.

For an industrial operator this is mostly upstream — you consume GPAI through tools rather than train it — but the seam matters in two places. First, if you **fine-tune a foundation model and embed it in a product** or place it on the market under your own name, the provider questions come back into view, and depending on the compute involved you could even inherit downstream GPAI duties. Second, a GPAI-powered assistant that you point at operational data is a **data-governance and confidentiality** decision before it is a convenience — which is exactly the kind of "shadow AI" exposure that turns up uninventoried until someone goes looking.

> [!IMPORTANT]
> Watch for **"shadow AI"** on the OT side of the house. Engineers pasting process logs into a public chatbot to debug a fault, a vendor tool quietly calling a hosted model, an assistant fine-tuned on your maintenance history — each is an AI system that belongs on the inventory and may carry obligations (literacy, transparency, confidentiality, and occasionally more). You cannot classify or govern what nobody has written down.

## AI literacy is already law — Article 4

Amid the debate over deferred high-risk dates, one live obligation is easy to miss: **Article 4** requires providers and deployers to ensure a **sufficient level of AI literacy** among their staff and anyone operating AI systems on their behalf, and it has applied since **2 February 2025**. It is not tied to the high-risk tier and it was **not** deferred by the Omnibus.

"Sufficient" is proportionate to context: it scales with the person's role, the systems they touch, and who is affected. For an industrial operator that means the people who run an AI-assisted inspection cell, tune an adaptive controller, or interpret a model's output should understand — at a level fit for their job — what the system does, where it fails, and when to distrust it. This is the human-factors counterpart to Article 14's oversight requirement: oversight only works if the person overseeing has the literacy to exercise it. A short, role-scoped programme with a record of who was trained and on what is both the compliance artefact and the thing that actually reduces risk on the floor.

## Fundamental-rights framing and the FRIA

The AI Act is, at its root, a fundamental-rights instrument, and that shows up in one deployer obligation worth flagging even though it rarely bites in pure OT: certain deployers of high-risk systems — notably public bodies and some providers of essential services — must carry out a **fundamental-rights impact assessment (FRIA)** under Article 27 before first use, describing the process, the affected persons, the risks, and the human-oversight and governance measures. For a purely mechanical safety component the fundamental-rights surface is small; for AI that touches workers, access, or the public — a utility's customer-affecting decision system, workforce monitoring — it is real, and it stacks on top of any GDPR obligation rather than replacing it. The safe posture is to ask the FRIA question during classification rather than discover it during an audit.

## Penalties

Article 99 sets the ceilings, and they are the highest in EU digital law. Like the GDPR and NIS2, the structure is deliberately turnover-linked so that non-compliance registers as a board-level financial risk, not a line item.

| Breach | Maximum fine | Article |
|---|---|---|
| Prohibited practices | **€35,000,000 or 7%** of total worldwide annual turnover, whichever is higher | Art. 5 → Art. 99 |
| Breach of other obligations (providers, deployers, importers, distributors, notified bodies, transparency) | **€15,000,000 or 3%** of worldwide turnover | Art. 99 |
| Supplying incorrect, incomplete or misleading information to authorities / notified bodies | **€7,500,000 or 1%** of worldwide turnover | Art. 99 |
| GPAI model provider infringements | **€15,000,000 or 3%** of worldwide turnover | Art. 101 |

Fines are proportionate, and for SMEs and start-ups the figure is capped at whichever of the percentage or the absolute amount is **lower** — a deliberate softening for smaller firms. ([Article 99](https://artificialintelligenceact.eu/article/99/); [Article 101](https://ai-act-service-desk.ec.europa.eu/en/ai-act/article-101))

```cta
€35 million or 7% of turnover — but is any of your industrial AI actually high-risk?
Most of it isn't. The value is finding the few systems that are and governing them well. We inventory and classify your AI against the Act.
Classify my AI systems :: /en/contact
```

## Conformity assessment, CE marking and the EU database

A high-risk system does not reach the market on the strength of good intentions. Before it is placed on the market or put into service, the provider must run a **conformity assessment** — the formal check that Articles 8–15 are met — and the route depends on how the system is classified.

For most **Annex III** high-risk systems, the Act allows conformity assessment based on **internal control (Annex VI)**: the provider itself verifies that its quality-management system and technical documentation satisfy the requirements, without a third party. For certain systems — notably some biometric use-cases — assessment must instead involve a **notified body (Annex VII)**, an accredited independent assessor. For **Annex I** product-embedded AI, the AI conformity check is folded into the **existing product conformity assessment** under the relevant harmonisation law (so a machine's AI safety component is assessed through the Machinery Regulation's own procedure, not a separate parallel one). ([Article 43, EU AI Act](https://artificialintelligenceact.eu/article/43/))

The output of a successful assessment is a chain of tangible artefacts:

| Step | What it is | Who holds it |
|---|---|---|
| **Technical documentation (Annex IV)** | The evidentiary file proving conformity | Provider, kept current |
| **EU declaration of conformity** | The provider's signed legal statement of compliance | Provider |
| **CE marking** | The visible mark that the product may circulate in the EU | On the product / accompanying docs |
| **Registration in the EU database** | Standalone Annex III systems logged before market entry | Provider (and deployers, for some public-authority uses) |
| **Post-market monitoring** | Ongoing collection of performance and incident data | Provider |

The practical implication for a deployer is a short procurement checklist that carries real weight: **is there a declaration of conformity, is the system CE-marked, and can the provider produce the instructions for use with the accuracy metrics and limits Article 13 requires?** If the answer is no, you are either not looking at a compliant high-risk system, or you are closer to being its provider than you think.

## Harmonised standards and the presumption of conformity

Nobody wants to argue Articles 8–15 from first principles for every system. The Act uses the classic **New Legislative Framework** mechanism: where a provider follows a **harmonised standard** whose reference has been published in the Official Journal, the system enjoys a **presumption of conformity** with the corresponding requirements. In other words, meet the standard and the burden of proving compliance largely lifts. The standards themselves are being developed by **CEN-CENELEC (Joint Technical Committee 21)** at the Commission's request, covering risk management, data quality, robustness, cybersecurity, transparency and human oversight for AI.

For OT this is the pragmatic path, and it dovetails with the security-engineering standards you may already use. Article 15's cybersecurity requirement, in particular, is where AI-specific standards and control-system security standards like [IEC 62443](/en/iec-62443) converge: the AI harmonised standards give you the presumption of conformity, while 62443's zones, conduits and security-level framework give you the *method* to demonstrate the robustness and cybersecurity the standard expects. Building your evidence once, against both, is far cheaper than building it twice.

## The Machinery Regulation connection

The AI Act does not stand alone. The **Machinery Regulation (EU) 2023/1230** — which replaces the old Machinery Directive and applies from **20 January 2027** — modernises machine safety for a world of software, connectivity and AI, and for the first time makes **cybersecurity an essential health-and-safety requirement**. ([EUR-Lex 2023/1230](https://eur-lex.europa.eu/eli/reg/2023/1230/oj/eng); [Nemko](https://www.nemko.com/blog/eu-machinery-regulation-2023/1230))

The revised Annex III essential requirements now address AI behaviour, cybersecurity, human-robot collaboration, IoT connectivity, the safety impact of software updates and functional safety. In plain terms: safety-related control systems and software must be immune to both accidental failure *and* deliberate attack, and connecting a device to a machine must not create a hazard. Cybersecurity in machinery is no longer optional — it is part of the safety case.

The two laws are stitched together on purpose. A safety-related AI component in a machine is high-risk under the AI Act, and the machine itself must satisfy the Machinery Regulation's safety and security requirements. The EU has moved explicitly to clarify the overlap so that a manufacturer does not face two contradictory conformity paths for one machine. ([IAPP](https://iapp.org/news/a/eu-agrees-to-amend-ai-act-clarifies-overlap-with-machinery-rules)) For a machine builder or an operator commissioning new equipment, the compliant route runs through **both at once** — which is exactly why the classification work and the security engineering want to happen in the same room. See the [Machinery Regulation](/en/machine-act) page for the machine-safety side of this story.

## A worked example: an AI vision trip on a 400-tonne press

Abstraction hides the decisions. Walk one concrete system through the whole chain and the Act stops being a wall of articles.

A stamping line runs a **400-tonne mechanical press**. To protect operators, the builder replaces the fixed light curtain with an **AI vision system** that watches the danger zone and **commands the press to stop** if it detects a hand, arm or body inside the guarded area during the stroke. It learns to distinguish a hand from a shadow, a glove from a part, steam from an intrusion.

- **Is it high-risk?** Yes — via **Route 1 (Annex I)**. The vision system is a **safety component of machinery** (Reg. (EU) 2023/1230), and machinery is Annex I harmonisation law. The classification is automatic; there is no Article 6(3) escape, because the model's output *materially influences* whether a hazardous motion stops. The moment its decision can stop the press, it is doing safety-relevant work.
- **Who is the provider?** The **machine builder** that integrates the vision system and places the press on the market under its own name. It owns the technical documentation, the risk-management file (Article 9), the data governance for the training set (Article 10), the declaration of conformity and CE marking.
- **What does Article 15 demand?** That the model be **accurate** (a declared, tested detection rate under real lighting, dust and speed), **robust** (fails safe — a dropped frame, an occluded lens or an out-of-distribution input must trip the press, not wave it through), and **cyber-secure** (an attacker must not be able to feed a spoofed frame, poison the model, or craft an **adversarial patch** — a sticker or pattern that makes the model classify a hand as background at exactly the wrong instant).
- **Where does the Machinery Regulation bite?** In parallel. The **safety-related control system** must meet the essential health-and-safety requirements — including the new **cybersecurity** requirement — and the AI conformity check folds into the machine's own conformity assessment rather than running as a separate track.
- **What if the operator retrains it?** If the plant operator **retrains the model on its own product** to cut false trips, it may **substantially modify** the system and **become the provider** — inheriting the full documentation, conformity and Article 15 burden it thought belonged to the builder.
- **Where does the security programme live?** The adversarial-patch and data-poisoning risks are **OT threats**, mapped through [IEC 62443](/en/iec-62443) zones and conduits and sitting on the same control-system risk register as remote-access exposure and ransomware — not in a separate AI silo.

One press, one model, and four regimes brushing against it: the AI Act, the Machinery Regulation, [NIS2](/en/nis2) at the operator, and the [CRA](/en/cra) on the digital components inside. This is why OXOT argues for answering them with **one coherent model of the plant**, not four disconnected projects.

## Sector-specific notes

The classification logic is common, but where AI lands differs by sector:

- **Energy and grid.** AI in substation automation, DER orchestration and load forecasting can be an **Annex III** safety component in electricity supply. Availability dominates, and a manipulated forecast or protection-adjacent model is a stability risk, not just a data-quality one.
- **Water and wastewater.** Dosing optimisation and anomaly detection sit close to public-health outcomes; an AI that adjusts a chemical setpoint is materially influencing a safety-relevant process, which pulls it toward high-risk.
- **Discrete manufacturing.** The Annex I / machinery route is the common one: vision-based safety trips, AI-guided cobots, adaptive controllers on hazardous motions. The provider/deployer trap around retraining is most acute here.
- **Pharma and med-manufacturing.** AI in devices and production overlaps the **Medical Devices / IVD** regulations (also Annex I), stacking conformity regimes on the same system.
- **Chemical and process.** AI adjacent to **safety-instrumented systems** must be reconciled with functional-safety regimes — a natural fit for the risk-based zones of IEC 62443 rather than a bolt-on.

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

**Our Annex III system does a "narrow task" — can we skip high-risk?**
Possibly, under the Article 6(3) derogation — but only if you can genuinely place it in one of the four conditions (narrow procedural task, improving a completed human activity, detecting patterns without replacing human judgement, or a preparatory task) *and* it does not profile a person or materially influence a safety- or rights-relevant outcome. You must register the system and record the assessment first, and the conditions are interpreted narrowly. For a real safety component the exit rarely applies.

**Do we need a notified body to assess our high-risk AI?**
Usually not for industrial systems. Most Annex III systems use internal-control conformity assessment (Annex VI); a notified body (Annex VII) is required mainly for certain biometric use-cases. For AI embedded in machinery (Annex I), the AI check is folded into the machine's existing conformity assessment rather than adding a separate one.

**Is following a standard enough to comply?**
Following a harmonised standard whose reference is published in the Official Journal gives a **presumption of conformity** with the matching requirements — which shifts the burden strongly in your favour, though a market-surveillance authority can still investigate. The AI standards are being written by CEN-CENELEC JTC 21, and for Article 15 cybersecurity they align well with IEC 62443.

**What about staff who just use an AI tool — any obligation now?**
Yes. The Article 4 AI-literacy duty is live and was not deferred. Anyone operating AI on your behalf needs a level of understanding proportionate to their role. A short, role-scoped training programme with a record of completion is the expected artefact.

## Sources

- Regulation (EU) 2024/1689 (AI Act), official text — [EUR-Lex](https://eur-lex.europa.eu/eli/reg/2024/1689/oj/eng)
- AI Act policy and implementation — [European Commission, Shaping Europe's digital future](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai)
- Article 6 — classification of high-risk systems — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/article/6/)
- Article 15 — accuracy, robustness and cybersecurity — [AI Act Service Desk (EC)](https://ai-act-service-desk.ec.europa.eu/en/ai-act/article-15)
- Article 16 — provider obligations — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/article/16/)
- Article 26 — deployer obligations — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/article/26/)
- Article 43 — conformity assessment (Annex VI internal control / Annex VII notified body) — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/article/43/)
- Article 6(3) derogation & Commission classification guidelines — [Data Protection Report](https://www.dataprotectionreport.com/2026/05/is-my-use-case-a-high-risk-ai-system-applying-the-commissions-guidelines-and-next-steps/)
- Digital Omnibus — Council final adoption, 29 June 2026 — [Council of the EU](https://www.consilium.europa.eu/en/press/press-releases/2026/06/29/artificial-intelligence-council-gives-final-green-light-to-simplify-and-streamline-rules/); [White & Case](https://www.whitecase.com/insight-alert/eu-agrees-digital-omnibus-deal-simplify-ai-rules)
- Article 99 — penalties — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/article/99/)
- Article 101 — GPAI model fines — [AI Act Service Desk (EC)](https://ai-act-service-desk.ec.europa.eu/en/ai-act/article-101)
- Annex I — Union harmonisation legislation (incl. machinery) — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/annex/1/)
- Annex III — high-risk use-cases (incl. critical infrastructure) — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/annex/3/)
- Digital Omnibus — postponed high-risk deadlines (agreed 7 May 2026) — [Gibson Dunn](https://www.gibsondunn.com/eu-ai-act-omnibus-agreement-postponed-high-risk-deadlines-and-other-key-changes/); [Hogan Lovells](https://www.hoganlovells.com/en/publications/eu-legislators-agree-to-delay-for-highrisk-ai-rules)
- Draft high-risk classification guidance — [McCann FitzGerald](https://www.mccannfitzgerald.com/knowledge/construction-and-infrastructure/critical-infrastructure-spotlight-eu-ai-act-draft-guidelines-on-high-risk-ai-classification)
- EU Machinery Regulation (EU) 2023/1230 — [EUR-Lex](https://eur-lex.europa.eu/eli/reg/2023/1230/oj/eng); cybersecurity overview — [Nemko](https://www.nemko.com/blog/eu-machinery-regulation-2023/1230)
- AI Act / Machinery Regulation overlap clarified — [IAPP](https://iapp.org/news/a/eu-agrees-to-amend-ai-act-clarifies-overlap-with-machinery-rules)

*This page is general information about EU law, not legal advice. Classification under the AI Act is fact-specific; confirm your systems' status against the Regulation and, where needed, qualified counsel.*$MDBODY$, true, $MDBODY$EU AI Act for Industrial & OT AI | OXOT$MDBODY$, $MDBODY$The EU AI Act (Regulation (EU) 2024/1689) for industry and OT — risk tiers with plant-floor examples, the two routes to high-risk, the Machinery Regulation link, provider vs deployer duties, Article 15 cybersecurity, revised 2026 timeline and penalties.$MDBODY$, $MDBODY$How the EU AI Act applies when AI enters the plant — high-risk classification, the machinery link, provider and deployer duties, Article 15 robustness, the revised 2026 timeline and penalties.$MDBODY$, NULL, $MDBODY$page$MDBODY$, now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET
  title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published,
  meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description,
  excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type,
  published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now()
WHERE length(pages.body) < length(EXCLUDED.body);

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ($MDBODY$ai-act$MDBODY$, $MDBODY$nl$MDBODY$, $MDBODY$De EU AI Act en industriële AI$MDBODY$, $MDBODY$Kunstmatige intelligentie is de fabrieksvloer binnengekomen zonder lanceerdatum. Ze sloop naar binnen via een visiesysteem dat een leverancier in een inspectiecel bundelde, een module voor predictief onderhoud in een aandrijving, een "adaptieve" lus in een firmware-release van een controller. Niemand heeft er beleid voor vastgesteld. Niemand heeft er een grens omheen getrokken. En nu stemt AI processen af, keurt ze producten, voorspelt ze storingen, balanceert ze energie en — in toenemende mate — bevindt ze zich dicht bij de veiligheids- en besturingsfuncties die bepalen of een lijn draait of stilvalt.

De EU AI Act is de eerste allesomvattende wet ter wereld die deze verschuiving reguleert. Voor de meeste mensen roept "AI-regelgeving" beelden op van chatbots en deepfakes. Voor een industriële operator zijn de bepalingen die er echt toe doen juist de stille bepalingen: de regels voor **AI die is ingebed in machines, veiligheidscomponenten en gereguleerde producten**. Daar reikt de wet tot in de operationele technologie, en daar houdt AI-governance op een juridische abstractie te zijn en wordt het een technisch vraagstuk.

Deze pagina legt uit wat de AI Act vereist, wanneer een industrieel AI-systeem de grens naar "hoog risico" overschrijdt, hoe de wet doelbewust is verweven met de Machineverordening en het bredere productveiligheidsregime, wat aanbieders en gebruiksverantwoordelijken elk verschuldigd zijn, en hoe een proportionele aanpak eruitziet in een OT-omgeving waar een gemanipuleerd model een gemanipuleerd proces is.

## De korte versie

- De AI Act is **Verordening (EU) 2024/1689**. Ze is op **1 augustus 2024** in werking getreden en wordt in fasen van kracht. ([EUR-Lex, officiële tekst](https://eur-lex.europa.eu/eli/reg/2024/1689/oj/eng))
- Ze is **risicogebaseerd**: een korte lijst van **verboden** praktijken, een veeleisende **hoog-risico**-klasse, lichtere **transparantie**verplichtingen voor systemen met beperkt risico, en geen nieuwe verplichtingen voor AI met minimaal risico.
- Industriële AI wordt meestal hoog risico via **Bijlage I** — waar de AI een veiligheidscomponent is van, of zelf, een product dat onder EU-harmonisatiewetgeving valt, zoals de **Machineverordening**. Een tweede route loopt via gebruik in **Bijlage III**-kritieke infrastructuur.
- **Aanbieders** (providers — die AI ontwikkelen of op de markt brengen) dragen de zware verplichtingen; **gebruiksverantwoordelijken** (deployers — die AI gebruiken) dragen een lichtere maar reële set plichten. Wijzig een systeem voldoende en een gebruiksverantwoordelijke *wordt* een aanbieder.
- Hoog-risicosystemen moeten voldoen aan de Artikelen 8–15: risicobeheer, datagovernance, logging, transparantie, menselijk toezicht en — de regel die OT-teams twee keer moeten lezen — **nauwkeurigheid, robuustheid en cyberbeveiliging** onder **Artikel 15**.
- Sancties lopen op tot **35 miljoen euro of 7% van de wereldwijde omzet** voor verboden praktijken, en **15 miljoen euro of 3%** voor schending van hoog-risicoverplichtingen. ([Artikel 99](https://artificialintelligenceact.eu/article/99/))
- De hoog-risicotermijnen zijn **uitgesteld** door de **Digital Omnibus** — politiek overeengekomen op 7 mei 2026, **op 16 juni 2026 bekrachtigd door het Europees Parlement**, en **op 29 juni 2026 definitief vastgesteld door de Raad**, met publicatie in het Publicatieblad aanstaande. Zelfstandige Bijlage III-systemen gelden nu vanaf **2 december 2027**, en in producten ingebedde Bijlage I-AI vanaf **2 augustus 2028**. ([Raad van de EU, 29 juni 2026](https://www.consilium.europa.eu/en/press/press-releases/2026/06/29/artificial-intelligence-council-gives-final-green-light-to-simplify-and-streamline-rules/))

> [!NOTE]
> De eerlijke hoofdboodschap voor de industrie: **de meeste industriële AI is geen hoog risico.** Procesoptimalisatie, kwaliteitsanalyse en onderhoudsvoorspelling die nooit een veiligheids- of besturingsfunctie raken, vallen in de minimale klasse. Het echte werk is het vinden van de handvol systemen die dat *wel* doen, ze correct classificeren, en ze beheersen zonder de nuttige negentig procent te verstikken.

```keyfacts
Instrument :: Verordening (EU) 2024/1689 — rechtstreeks toepasselijk, geen nationale omzetting
Van kracht sinds :: 1 augustus 2024, gefaseerde toepassing
Verboden praktijken live :: 2 februari 2025 (Artikel 5)
Plicht AI-geletterdheid live :: 2 februari 2025 (Artikel 4)
GPAI-verplichtingen live :: 2 augustus 2025
Hoog risico (Bijlage III) :: 2 december 2027 (uitgesteld door Digital Omnibus)
Hoog risico (Bijlage I, incl. machines) :: 2 augustus 2028 (uitgesteld)
Hoogste boete :: €35 mln of 7% van de wereldwijde omzet (verboden praktijken)
Het OT-kritieke artikel :: Artikel 15 — nauwkeurigheid, robuustheid, cyberbeveiliging
Toezichthouder :: nationale markttoezichtautoriteiten + het EU AI-Bureau (GPAI)
```

## De risicogebaseerde structuur

De verordening rangschikt AI naar het risico dat ze oplevert, niet naar de gebruikte technologie. Een neuraal netwerk en een lineair model worden identiek behandeld als ze dezelfde taak op dezelfde plek uitvoeren. Vier klassen, van verboden tot ongereguleerd.

```svg
<svg viewBox="0 0 700 430" xmlns="http://www.w3.org/2000/svg" font-family="system-ui, sans-serif">
  <rect width="700" height="430" fill="none"/>
  <text x="350" y="30" fill="#e5e7eb" font-size="20" font-weight="700" text-anchor="middle">De vier risicoklassen van de EU AI Act</text>

  <!-- Pyramid: prohibited (top) to minimal (bottom) -->
  <polygon points="350,60 430,130 270,130" fill="#f97316" opacity="0.9" stroke="#94a3b8" stroke-width="1"/>
  <polygon points="270,130 430,130 490,210 210,210" fill="#3b82f6" opacity="0.9" stroke="#94a3b8" stroke-width="1"/>
  <polygon points="210,210 490,210 550,290 150,290" fill="#3b82f6" opacity="0.55" stroke="#94a3b8" stroke-width="1"/>
  <polygon points="150,290 550,290 610,370 90,370" fill="#94a3b8" opacity="0.45" stroke="#94a3b8" stroke-width="1"/>

  <text x="350" y="102" fill="#e5e7eb" font-size="14" font-weight="700" text-anchor="middle">VERBODEN</text>
  <text x="350" y="177" fill="#e5e7eb" font-size="15" font-weight="700" text-anchor="middle">HOOG RISICO</text>
  <text x="350" y="256" fill="#e5e7eb" font-size="14" font-weight="700" text-anchor="middle">BEPERKT RISICO</text>
  <text x="350" y="336" fill="#e5e7eb" font-size="14" font-weight="700" text-anchor="middle">MINIMAAL RISICO</text>

  <!-- Right-side annotations -->
  <line x1="430" y1="95" x2="640" y2="95" stroke="#94a3b8" stroke-width="1" stroke-dasharray="3,3"/>
  <text x="645" y="99" fill="#f97316" font-size="12">Volledig verboden (Art. 5)</text>

  <line x1="500" y1="170" x2="640" y2="170" stroke="#94a3b8" stroke-width="1" stroke-dasharray="3,3"/>
  <text x="645" y="174" fill="#3b82f6" font-size="12">Toegestaan met volledige controles</text>

  <line x1="560" y1="250" x2="640" y2="250" stroke="#94a3b8" stroke-width="1" stroke-dasharray="3,3"/>
  <text x="565" y="270" fill="#94a3b8" font-size="12">Transparantieplichten</text>

  <line x1="620" y1="330" x2="648" y2="330" stroke="#94a3b8" stroke-width="1" stroke-dasharray="3,3"/>
  <text x="470" y="405" fill="#94a3b8" font-size="12" text-anchor="middle">Geen nieuwe verplichtingen — vrijwillige gedragscodes</text>

  <text x="350" y="420" fill="#94a3b8" font-size="11" text-anchor="middle">De meeste industriële AI bevindt zich aan de basis. De compliance-inspanning concentreert zich in de blauwe band.</text>
</svg>
```

### Onaanvaardbaar risico — verboden

Een korte lijst van praktijken is volledig verboden onder **Artikel 5**: manipulatieve of uitbuitende technieken die gedrag verstoren, social scoring, ongerichte scraping van gezichtsbeelden, emotieherkenning op de werkvloer en in het onderwijs, bepaalde biometrische categorisering, en real-time biometrische identificatie op afstand in openbare ruimtes (met beperkte uitzonderingen voor wetshandhaving). Deze komen zelden voor in OT — maar het verbod is absoluut waar ze dat wel doen, en het draagt de zwaarste boete uit de verordening. De Digital Omnibus voegde nog één verboden praktijk toe: door AI gegenereerd niet-consensueel intiem beeldmateriaal en materiaal van seksueel kindermisbruik, van toepassing vanaf **2 december 2026**. ([Winston Taylor](https://www.winstontaylor.com/insights/ai-act-rules-on-high-risk-ai-delayed-as-ai-digital-omnibus-agreed))

### Hoog risico — toegestaan, maar zwaar gereguleerd

Dit is de klasse die ertoe doet voor de industrie. Hoog-risicosystemen zijn alleen toegestaan op de markt als ze voldoen aan de volledige set vereisten van Artikel 8–15 en de conformiteitsbeoordeling doorstaan. De meeste industriële AI die een veiligheids- of besturingsfunctie raakt, valt hierin — en de rest van deze pagina gaat grotendeels over hoe u bepaalt welke van uw systemen in deze band vallen, en wat u eraan doet zodra dat zo is.

### Beperkt risico — transparantieplichten

Systemen die interacteren met mensen of content genereren, moeten dit bekendmaken: een chatbot moet zeggen dat het een machine is, synthetische media moeten worden gelabeld. Dit is relevanter voor klantgerichte tools — de assistent op uw website, een gegenereerde marketingafbeelding — dan voor de fabrieksvloer. Regel de bekendmaking goed en de verplichting is voldaan.

### Minimaal risico — geen nieuwe verplichtingen

De overgrote meerderheid van AI valt hieronder: optimalisatie, analyses, energiebalancering, onderhoudsvoorspelling die een mens informeert maar niet handelt binnen een veiligheidslus. Uitsluitend onderworpen aan vrijwillige gedragscodes. Deze klasse is bewust groot gehouden — de verordening is geschreven om ruimte te laten voor innovatie en controle te concentreren waar schade aannemelijk is.

Hier volgt dezelfde structuur met voorbeelden van de werkvloer, zodat de klassen niet langer abstract zijn.

| Risicoklasse | Wat de wet doet | Typische industriële / OT-voorbeelden |
|---|---|---|
| **Onaanvaardbaar** | Verboden onder Art. 5 | Emotieherkenning bij werknemers voor productiviteitsscoring; verkapte gedragsmanipulatie. Zeldzaam in OT, verboden waar aanwezig. |
| **Hoog risico** | Volledige vereisten Art. 8–15 + conformiteitsbeoordeling | AI-gebaseerde veiligheidsbeveiliging of lichtgordijnlogica; visiesysteem dat een pers stopt; adaptieve controller die een gevaarlijk proces aanstuurt; AI als veiligheidscomponent in elektriciteits-, water-, gas- of warmtevoorziening. |
| **Beperkt risico** | Alleen transparantie / bekendmaking | Chatassistent voor operators; klantenservicebot; gegenereerde documentatie. |
| **Minimaal risico** | Geen nieuwe verplichtingen | Predictief onderhoud dat een planner adviseert; procesoptimalisatie en opbrengstanalyse; afwijkingsdetectie die een mens alarmeert. |

## Het herziene tijdpad — en het voorbehoud van de Digital Omnibus

De AI Act is gepubliceerd in het Publicatieblad en op **1 augustus 2024** in werking getreden, met verplichtingen die gefaseerd ingaan zodat de industrie, aangemelde instanties en toezichthouders zich konden voorbereiden. Twee mijlpalen zijn al gepasseerd:

- **2 februari 2025** — de **verbodsbepalingen van Artikel 5** golden, en organisaties werden verantwoordelijk voor een basisniveau van **AI-geletterdheid** bij personeel dat AI-systemen bedient.
- **2 augustus 2025** — de governancebepalingen en de verplichtingen voor **AI-modellen voor algemene doeleinden (GPAI)** golden.

Toen verschoof het tijdpad. Op **7 mei 2026** bereikten onderhandelaars van de Raad, het Parlement en de Commissie een voorlopig politiek akkoord over de **Digital Omnibus inzake AI** — een vereenvoudigingspakket dat onder meer **de hoog-risicotermijnen uitstelde**. Dat akkoord is inmiddels wet geworden: het **Europees Parlement bekrachtigde het op 16 juni 2026**, en de **Raad gaf op 29 juni 2026 definitief groen licht**, met publicatie in het Publicatieblad binnen enkele weken en inwerkingtreding op de derde dag daarna. Volgens de vastgestelde tekst gelden zelfstandige **Bijlage III**-hoog-risicosystemen vanaf **2 december 2027** (een verschuiving ten opzichte van de oorspronkelijke 2 augustus 2026), en in producten ingebedde **Bijlage I**-AI vanaf **2 augustus 2028**. ([Raad van de EU](https://www.consilium.europa.eu/en/press/press-releases/2026/06/29/artificial-intelligence-council-gives-final-green-light-to-simplify-and-streamline-rules/); [White & Case](https://www.whitecase.com/insight-alert/eu-agrees-digital-omnibus-deal-simplify-ai-rules))

```timeline
1 aug 2024 :: **Verordening treedt in werking.** De AI Act wordt gepubliceerd in het Publicatieblad; de klok voor gefaseerde toepassing start. *(Van kracht)*
2 feb 2025 :: **Verbodsbepalingen Art. 5 + AI-geletterdheidsplicht Art. 4 gelden.** Verboden praktijken zijn onwettig; personeel dat AI bedient moet basisgeletterdheid hebben. *(Van kracht)*
2 aug 2025 :: **Governanceregels + verplichtingen GPAI-modellen gelden.** Het AI-Bureau wordt opgericht; aanbieders van foundation-modellen nemen documentatie- en transparantieplichten op zich. *(Van kracht)*
2 aug 2026 :: **Transparantie- en overige niet-uitgestelde bepalingen gelden.** Deze data zijn *niet* verschoven door de Omnibus en blijven staan. *(Van kracht)*
2 dec 2026 :: **Nieuw verbod** op door AI gegenereerd niet-consensueel intiem beeldmateriaal en CSAM. *(Vastgesteld — Omnibus)*
2 dec 2027 :: **Hoog-risicoverplichtingen voor zelfstandige Bijlage III-systemen** — uitgesteld van de oorspronkelijke 2 aug 2026. *(Vastgesteld — Omnibus)*
2 aug 2028 :: **Hoog-risicoverplichtingen voor in Bijlage I ingebedde AI** (inclusief machines). *(Vastgesteld — Omnibus)*
```

> [!WARNING]
> Het uitstel is echt en nu juridisch verankerd — maar lees de kleine lettertjes. De Omnibus verschoof de *hoog-risicodata*; hij verschoof **niet** de verbodsbepalingen (live sinds februari 2025), de AI-geletterdheidsplicht (eveneens live), de GPAI-verplichtingen (live sinds augustus 2025), of de transparantiebepalingen die op **2 augustus 2026** ingaan. Heeft uw organisatie iets ingezet dat onder die bepalingen valt, dan levert de extra tijd op hoog risico u niets op. Plan op basis van de specifieke route van uw systeem en de bijbehorende datum, niet op basis van één krantenkop. ([Latham & Watkins](https://www.lw.com/en/insights/ai-act-update-eu-resolves-to-change-rules-and-extend-deadlines))

Het uitstel is een geschenk van tijd, geen gratie. De verbodsbepalingen en de AI-geletterdheidsplichten gelden nu al, de klok voor hoog-risicoclassificatie loopt door, en de twee traagste taken — het opbouwen van een inventaris en het doorlopen van de classificatieredenering — zijn precies de taken die u achter de rug wilt hebben voordat het papierwerk landt.

## Hoe industriële AI "hoog risico" wordt

Er zijn **twee afzonderlijke routes** naar de hoog-risicoklasse, en ze werken anders. Een industriële operator moet beide begrijpen, want één locatie kan door beide worden geraakt — soms door beide tegelijk.

```svg
<svg viewBox="0 0 700 560" xmlns="http://www.w3.org/2000/svg" font-family="system-ui, sans-serif">
  <rect width="700" height="560" fill="none"/>
  <text x="350" y="30" fill="#e5e7eb" font-size="19" font-weight="700" text-anchor="middle">Is mijn industriële AI hoog risico?</text>

  <!-- Start -->
  <rect x="270" y="50" width="160" height="46" rx="8" fill="#1f2937" stroke="#3b82f6" stroke-width="2"/>
  <text x="350" y="78" fill="#e5e7eb" font-size="13" text-anchor="middle">Een AI-systeem in uw fabriek</text>

  <!-- Q1 Annex I -->
  <polygon points="350,116 500,166 350,216 200,166" fill="#1f2937" stroke="#f97316" stroke-width="2"/>
  <text x="350" y="158" fill="#e5e7eb" font-size="12" text-anchor="middle">Is het een veiligheidscomponent</text>
  <text x="350" y="174" fill="#e5e7eb" font-size="12" text-anchor="middle">van een Bijlage I-product</text>
  <text x="350" y="190" fill="#e5e7eb" font-size="12" text-anchor="middle">(bv. machines)?</text>

  <line x1="500" y1="166" x2="600" y2="166" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="548" y="158" fill="#f97316" font-size="12" text-anchor="middle">JA</text>

  <!-- High risk Route 1 -->
  <rect x="560" y="143" width="120" height="70" rx="8" fill="#3b82f6" opacity="0.85" stroke="#94a3b8" stroke-width="1"/>
  <text x="620" y="172" fill="#e5e7eb" font-size="13" font-weight="700" text-anchor="middle">HOOG RISICO</text>
  <text x="620" y="192" fill="#e5e7eb" font-size="10" text-anchor="middle">Route 1 — Bijlage I</text>

  <!-- No path down to Q2 -->
  <line x1="350" y1="216" x2="350" y2="256" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="368" y="240" fill="#94a3b8" font-size="12">NEE</text>

  <!-- Q2 Annex III -->
  <polygon points="350,256 510,310 350,364 190,310" fill="#1f2937" stroke="#f97316" stroke-width="2"/>
  <text x="350" y="298" fill="#e5e7eb" font-size="12" text-anchor="middle">Is het een veiligheidscomponent in</text>
  <text x="350" y="314" fill="#e5e7eb" font-size="12" text-anchor="middle">een Bijlage III-gebruik — net, water,</text>
  <text x="350" y="330" fill="#e5e7eb" font-size="12" text-anchor="middle">gas, warmte, verkeer, digitale infra?</text>

  <line x1="510" y1="310" x2="600" y2="310" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="553" y="302" fill="#f97316" font-size="12" text-anchor="middle">JA</text>

  <!-- High risk Route 2 -->
  <rect x="560" y="287" width="120" height="70" rx="8" fill="#3b82f6" opacity="0.85" stroke="#94a3b8" stroke-width="1"/>
  <text x="620" y="316" fill="#e5e7eb" font-size="13" font-weight="700" text-anchor="middle">HOOG RISICO*</text>
  <text x="620" y="336" fill="#e5e7eb" font-size="10" text-anchor="middle">Route 2 — Bijlage III</text>

  <line x1="350" y1="364" x2="350" y2="404" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="368" y="388" fill="#94a3b8" font-size="12">NEE</text>

  <!-- Not high risk -->
  <rect x="250" y="404" width="200" height="60" rx="8" fill="#94a3b8" opacity="0.35" stroke="#94a3b8" stroke-width="1"/>
  <text x="350" y="430" fill="#e5e7eb" font-size="13" font-weight="700" text-anchor="middle">Waarschijnlijk GEEN hoog risico</text>
  <text x="350" y="450" fill="#e5e7eb" font-size="10" text-anchor="middle">maar documenteer uw redenering</text>

  <text x="350" y="500" fill="#94a3b8" font-size="11" text-anchor="middle">* Bijlage III-systemen kunnen het vermoeden weerleggen als ze geen significant risico vormen voor</text>
  <text x="350" y="518" fill="#94a3b8" font-size="11" text-anchor="middle">gezondheid, veiligheid of grondrechten — een vaststelling die u moet vastleggen.</text>
  <text x="350" y="540" fill="#94a3b8" font-size="11" text-anchor="middle">Wijzig of rebrand een systeem substantieel en u kunt de aanbieder ervan worden.</text>
</svg>
```

### Route 1 — Bijlage I: in producten ingebedde AI

Onder **Artikel 6, lid 1** is een AI-systeem hoog risico als het wordt gebruikt als **veiligheidscomponent** van een product — of zelf een product is — dat onder de in **Bijlage I** genoemde EU-harmonisatiewetgeving valt, *en* dat product moet een conformiteitsbeoordeling door een derde partij ondergaan. Bijlage I is in wezen een opsomming van het EU-productveiligheidsregime, en reikt diep in de industrie. ([Artikel 6](https://artificialintelligenceact.eu/article/6/); [Bijlage I toegelicht](https://www.euai-act.com/articles/annex-i-explained))

| Productwetgeving Bijlage I (selectie) | Relevantie voor OT / industrie |
|---|---|
| **Machines** — Verordening (EU) 2023/1230 (vervangt Richtlijn 2006/42/EG) | Het schoolvoorbeeld: AI als veiligheidscomponent van een machine is automatisch hoog risico. |
| Liften — Richtlijn 2014/33/EU | AI in veiligheids-/besturingsfuncties van liften. |
| ATEX — Richtlijn 2014/34/EU (explosieve atmosferen) | AI die apparatuur in gevaarlijke zones aanstuurt. |
| Drukapparatuur — Richtlijn 2014/68/EU | AI in veiligheidssystemen van drukvaten. |
| Persoonlijke beschermingsmiddelen — Verordening (EU) 2016/425 | AI-ondersteunde PBM. |
| Medische hulpmiddelen / IVD — Verordening (EU) 2017/745, 2017/746 | AI in de veiligheid van hulpmiddelen — relevant voor farma/medische productie. |
| Radioapparatuur — Richtlijn 2014/53/EU | Verbonden industriële radio/draadloze apparatuur. |
| Speelgoed — Richtlijn 2009/48/EG | AI-ondersteunde speelgoedveiligheid. |
| Motorvoertuigen, landbouwvoertuigen, luchtvaart, scheepsuitrusting | AI-veiligheidscomponenten in mobiliteits- en transportuitrusting. |

Het belangrijkste gevolg voor OT is bot: **een AI-systeem dat een veiligheidscomponent is onder de Machineverordening, is automatisch een hoog-risico AI-systeem.** Bouw of koop een machine waarvan de veiligheid afhangt van een AI-component — een door AI aangestuurde beveiliging, een visiesysteem dat een pers stopt, een adaptieve controller die een gevaarlijk proces beheert — en die AI is hoog risico. Beide regimes zijn dan tegelijk van toepassing op dezelfde kast.

> [!IMPORTANT]
> "Veiligheidscomponent" is een vaktechnische term, geen stemming. Als een storing van de AI het risico voor de gezondheid of veiligheid van personen of eigendommen kan verhogen, verricht ze veiligheidsrelevant werk — ongeacht of iemand het als "veiligheidssysteem" heeft bestempeld. Visie die alleen goed product van slecht sorteert is minimaal risico; datzelfde visiesysteem, bekabeld om een gevaarlijke beweging te stoppen, is een veiligheidscomponent. De bekabeling verandert de classificatie.

### Route 2 — Bijlage III: opgesomde gebruikscasussen

Artikel 6, lid 2 maakt systemen die zijn opgenomen in **Bijlage III** hoog risico op basis van hun gebruikscasus. Voor de industrie is het relevante onderdeel **kritieke infrastructuur**: AI die bedoeld is voor gebruik als **veiligheidscomponent bij het beheer en de exploitatie van kritieke digitale infrastructuur, wegverkeer, of de levering van water, gas, verwarming of elektriciteit.** Daar vinden sommige energie-, water-, warmte- en transportoperators hun AI gevangen, zelfs als er geen afzonderlijke "machine" bij betrokken is. ([Bijlage III](https://artificialintelligenceact.eu/annex/3/); [AI in kritieke infrastructuur](https://www.aiactblog.nl/en/annex-iii/kritieke-infrastructuur))

Drie voorwaarden moeten samenvallen wil de route via kritieke infrastructuur van toepassing zijn: de AI moet bedoeld zijn voor gebruik als **veiligheidscomponent**; het gebruik moet betrekking hebben op de exploitatie van een van die opgesomde sectoren; en — volgens de conceptclassificatierichtsnoeren van de Commissie — de gebruiksverantwoordelijke entiteit is doorgaans een entiteit die is aangewezen als **kritieke entiteit** onder het kader voor de veerkracht van kritieke entiteiten. ([McCann FitzGerald](https://www.mccannfitzgerald.com/knowledge/construction-and-infrastructure/critical-infrastructure-spotlight-eu-ai-act-draft-guidelines-on-high-risk-ai-classification))

Bijlage III-systemen kunnen alleen aan de hoog-risicostatus ontsnappen als ze werkelijk geen significant risico vormen voor gezondheid, veiligheid of grondrechten — bijvoorbeeld waar de AI een beperkte procedurele taak uitvoert of enkel een reeds voltooide menselijke activiteit verbetert. Die ontsnapping is geen schouderophalen; het is een **gedocumenteerde vaststelling** die u moet kunnen verdedigen.

Dit is de natuurlijke naadlijn tussen de AI Act en de operationele beveiligingsregimes. De SCADA-nabije AI van een netbeheerder kan een veiligheidscomponent zijn onder Bijlage III *én* zich bevinden binnen een systeem dat onder [NIS2](/nl/nis2) valt. De classificatievragen en de beveiligingsvragen worden gesteld over hetzelfde asset.

### De ontsnapping van Artikel 6, lid 3 — en waarom het geen schouderophalen is

Route 2 heeft een ontlastklep, en het loont deze precies te begrijpen, want het is de meest ingeroepen en meest verkeerd toegepaste bepaling. **Artikel 6, lid 3** zegt dat een in Bijlage III opgesomd AI-systeem **niet** hoog risico is als het geen significant risico vormt voor gezondheid, veiligheid of grondrechten — *óók niet door de uitkomst van besluitvorming niet wezenlijk te beïnvloeden* — wanneer aan **één** van vier voorwaarden is voldaan. ([Artikel 6, EU AI Act](https://artificialintelligenceact.eu/article/6/))

```compare
Valt BUITEN hoog risico (Art. 6, lid 3)
- **(a) Beperkte procedurele taak** — de AI doet iets afgebakends en mechanisch, bv. gegevens structureren of omzetten naar een vast sjabloon
- **(b) Verbetert een voltooide menselijke activiteit** — het verfijnt output die een mens al heeft geproduceerd, zonder de richting te bepalen
- **(c) Detecteert besluitvormingspatronen / afwijkingen** — het signaleert afwijking van een eerder menselijk patroon maar is *niet* bedoeld om de menselijke beoordeling te vervangen of te beïnvloeden zonder toetsing
- **(d) Voert een voorbereidende taak uit** — het bereidt een input voor een beoordeling voor, maar maakt de beoordeling niet zelf
---
Blijft BINNEN hoog risico
- De AI **profileert een natuurlijke persoon** — profilering houdt een systeem altijd hoog risico, geen afwijking mogelijk
- De AI **beïnvloedt de uitkomst wezenlijk** van een veiligheids- of rechtenrelevant besluit
- De AI **vervangt** betekenisvol menselijk oordeel in de lus
- U kunt niet **documenteren en verdedigen** waarom een van de vier voorwaarden werkelijk van toepassing is
```

Twee waarschuwingen maken het verschil tussen een verdedigbare classificatie en een kostbare fout. Ten eerste is de richtsnoer van de Commissie expliciet dat de vier voorwaarden **eng moeten worden uitgelegd** — het zijn uitgangen voor werkelijk perifere AI, geen achterdeur om een systeem te herclassificeren dat u liever niet beheerst. Ten tweede moet u, als u zich op Artikel 6, lid 3 beroept, het systeem **registreren** en uw beoordeling **vastleggen** vóór marktintroductie of ingebruikname; de bewijslast ligt bij u, en een markttoezichtautoriteit kan de redenering opvragen. ([Data Protection Report, toepassing van de richtsnoeren van de Commissie](https://www.dataprotectionreport.com/2026/05/is-my-use-case-a-high-risk-ai-system-applying-the-commissions-guidelines-and-next-steps/)) In een OT-context is de eerlijke lezing dat een systeem dat werkelijk is verbonden met een *veiligheidscomponent* zelden kwalificeert — zodra de output een gevaar kan bewegen, beïnvloedt het wezenlijk een uitkomst waar de wet om geeft.

## Wat hoog-risicosystemen moeten doen — Artikelen 8–15

Hoog-risico AI-systemen moeten worden gebouwd en geëxploiteerd tegen een vastgestelde set vereisten. Lees Artikelen 8–15 als een levenscyclus, niet als een checklist die u eenmalig afvinkt.

| Artikel | Vereiste | Wat het in de praktijk betekent |
|---|---|---|
| **9** | Risicobeheersysteem | Continu, over de hele levenscyclus — identificeren, beoordelen, beperken, herhalen. |
| **10** | Gegevens & gegevensgovernance | Trainings-/validatie-/testgegevens die geschikt, representatief en onderzocht zijn op bias en hiaten. |
| **11** | Technische documentatie | Het bewijsdossier dat conformiteit aantoont — actueel gehouden. |
| **12** | Registratie / logging | Automatische logging van gebeurtenissen gedurende de levensduur van het systeem, met traceerbaarheid. |
| **13** | Transparantie & gebruiksaanwijzingen | Gebruiksverantwoordelijken krijgen duidelijke, volledige instructies — inclusief nauwkeurigheidsmetrieken en beperkingen. |
| **14** | Menselijk toezicht | Ingebouwd, zodat een bevoegde persoon het systeem kan begrijpen, ingrijpen en stopzetten. |
| **15** | Nauwkeurigheid, robuustheid & cyberbeveiliging | De beveiligingsruggengraat — zie hieronder. |

### Artikel 15 — waar AI-governance OT-beveiliging ontmoet

Artikel 15 is de vereiste die OT-teams moeten markeren. Hoog-risicosystemen moeten een passend niveau bereiken van **nauwkeurigheid** (met de metrieken vastgelegd in de gebruiksaanwijzing), **robuustheid** (weerbaarheid tegen fouten, storingen, inconsistenties en terugkoppelingslussen, met redundantie waar passend), en **cyberbeveiliging** (weerbaarheid tegen pogingen van onbevoegde partijen om het gebruik, de output of het gedrag van het systeem te wijzigen door misbruik te maken van de kwetsbaarheden ervan). ([Artikel 15, AI Act Service Desk](https://ai-act-service-desk.ec.europa.eu/en/ai-act/article-15))

Cruciaal is dat Artikel 15 AI-specifieke aanvalsklassen benoemt en maatregelen vereist — waar passend — om deze te voorkomen, detecteren, erop te reageren, ze op te lossen en te beheersen:

- **Datavergiftiging (data poisoning)** — het corrumperen van de trainingsdataset zodat het model het gedrag van de aanvaller aanleert. Voor een model dat een proces zal aansturen, is een vergiftigde trainingsset een vooraf geïnstalleerde achterdeur.
- **Modelvergiftiging (model poisoning)** — knoeien met vooraf getrainde componenten die in training worden opgenomen. Uw toeleveringsketen maakt nu deel uit van uw aanvalsoppervlak.
- **Adversariële voorbeelden / model-evasie** — input die zo is opgesteld dat het model fouten maakt. Een fysieke sticker, een lichtverandering, een vervalste sensormeting die een classifier op precies het verkeerde moment omslaat.
- **Vertrouwelijkheidsaanvallen en modelgebreken** — extractie, inversie, en het misbruiken van latente defecten.

> [!TIP]
> In IT levert een gemanipuleerd model een verkeerd antwoord op een scherm op. In OT is **een gemanipuleerd model een gemanipuleerd proces.** Een adversariële input die een op visie gebaseerde veiligheidstrip om de tuin leidt, of een vergiftigd model dat een gevaarlijke toestand verkeerd beoordeelt, is een fysiek veiligheidsincident — geen datakwaliteitskwestie. Daarom hoort Artikel 15 thuis in uw beveiligingsprogramma voor besturingssystemen, in kaart gebracht via methoden zoals [IEC 62443](/nl/iec-62443), en niet weggeborgen als een papierwerkoefening van het AI-team. Het is ook waarom de [CRA](/nl/cra) en Artikel 15 elkaar overlappen: beide eisen security-by-design voor de digitale componenten in uw producten.

### Artikel 9 — een risicobeheersysteem dat nooit sluit

Artikel 9 is de ruggengraat waaraan de andere vereisten hangen. Het eist een **continu, iteratief** risicobeheerproces dat over de volledige levenscyclus van een hoog-risicosysteem loopt — geen eenmalige beoordeling die bij lancering wordt gearchiveerd. U identificeert en analyseert de bekende en redelijkerwijs te voorziene risico's die het systeem kan opleveren voor gezondheid, veiligheid en grondrechten; u schat de risico's uit *beoogd gebruik* én uit *redelijkerwijs te voorzien misbruik*; u beoordeelt risico's uit monitoringgegevens na marktintroductie; en u treft gerichte maatregelen om ze te beheersen. Voor OT is "redelijkerwijs te voorzien misbruik" de zinsnede die het werk doet. Een visiemodel dat is getraind op een schone, goed verlichte lijn krijgt te maken met een nachtdienst, een vuile lens, een verwisselde mal en een operator die een onderdeel tegen de behuizing leunt om een seconde te winnen — en het risicodossier moet die wereld hebben verbeeld, niet de demo. Artikel 9 duwt u ook naar toetsing aan **gedefinieerde metrieken en probabilistische drempels** die passen bij het beoogde doel, precies waar de faalmodi van een model ophouden een onderzoekscuriositeit te zijn en een gedocumenteerde veiligheidsgrens worden.

### Artikel 10 — gegevensgovernance, waar het risico vaak ontstaat

Artikel 10 vereist dat trainings-, validatie- en testdatasets **relevant, voldoende representatief en zoveel mogelijk foutloos en volledig** zijn met het oog op het beoogde doel, met passende aandacht voor de specifieke setting waarin het systeem wordt gebruikt. Het verplicht u datasets te onderzoeken op **bias** die gezondheid, veiligheid of grondrechten kan raken, en hiaten en tekortkomingen te identificeren. In een industriële context voelt het grondrechtenkader ver weg, maar de representativiteitseis is pure techniek: een defectdetectiemodel dat alleen op zomerproduct is getraind, of op de grondstof van één leverancier, of op de toleranties van één machine, is niet "representatief" voor het proces dat het moet bewaken — en dat gat is waar zowel kwaliteitsfalen als niet-conformiteiten onder Artikel 10 ontstaan. Goede gegevensgovernance is hier dezelfde discipline die het model laat *werken*; de wet maakt het slechts auditeerbaar.

### Artikel 14 — menselijk toezicht, en de valkuil van automatiseringsbias

Artikel 14 vereist dat hoog-risicosystemen zo worden ontworpen dat ze tijdens gebruik **effectief kunnen worden overzien door natuurlijke personen** — met de interface, de informatie en het gereedschap dat een mens werkelijk nodig heeft om de grenzen van het systeem te begrijpen, op afwijkend gedrag te letten, de output correct te interpreteren, te besluiten het in een bepaald geval *niet* te gebruiken, en **in te grijpen of te stoppen**. De subtiele eis is bescherming tegen **automatiseringsbias**: de goed gedocumenteerde menselijke neiging om een zelfverzekerde machine te veel te vertrouwen, vooral onder tijdsdruk. Een "mens in de lus" die op lijnsnelheid alles afstempelt wat het model zegt, is geen toezicht in de zin die Artikel 14 bedoelt. In een controlekamer betekent betekenisvol toezicht dat de operator kan zien *waarom* het systeem handelde, de bevoegdheid en de fysieke middelen heeft om het te overrulen, en is getraind om het op de juiste momenten te wantrouwen. Hier zijn AI-governance en OT-human-factors-engineering hetzelfde gesprek — en waar het [Cyber Digital Twin](/nl/cyber-digital-twin)-beeld van wat-met-wat-verbonden-is een operator helpt de blast radius van een model te doordenken vóór, niet tijdens, een incident.

## Aanbieders versus gebruiksverantwoordelijken

De verordening splitst plichten naar rol, en het correct vaststellen van uw rol bepaalt uw verplichtingen. Het onderscheid is niet academisch — dezelfde organisatie kan gebruiksverantwoordelijke zijn voor het ene systeem en, zonder dat te bedoelen, de aanbieder van een ander.

| | **Aanbieder** (provider — Art. 16) | **Gebruiksverantwoordelijke** (deployer — Art. 26) |
|---|---|---|
| Wie | Ontwikkelt de AI of laat deze ontwikkelen, en brengt deze op de markt / in gebruik onder eigen naam | Gebruikt een hoog-risico AI-systeem onder eigen gezag — de meeste industriële operators |
| Kernplichten | Kwaliteitsmanagementsysteem; volledige technische documentatie; conformiteitsbeoordeling; EU-conformiteitsverklaring; CE-markering; registratie in de EU-databank; monitoring na het in de handel brengen | Gebruik volgens instructies; menselijk toezicht door bevoegde personen waarborgen; zorgen dat invoergegevens relevant/representatief zijn; de werking monitoren, opschorten en rapporteren bij opkomend risico; logs bijhouden (min. 6 maanden) |
| Typische actor in OT | OEM, machinebouwer, integrator, modelleverancier | Fabrieksoperator, nutsbedrijf, asset-eigenaar |
| De valkuil | — | Wijzig, hertrain of rebrand een hoog-risicosysteem substantieel en u kunt **de aanbieder worden** — met overname van de volledige aanbiedersverplichtingen |

**Aanbieders** dragen het gewicht, en in de praktijk is dat uw OEM, integrator of modelleverancier. ([Artikel 16](https://artificialintelligenceact.eu/article/16/)) **Gebruiksverantwoordelijken** dragen een lichtere maar concrete set plichten, en waar u AI inzet die werknemers raakt, kunt u hun ook informatie verschuldigd zijn. ([Artikel 26](https://artificialintelligenceact.eu/article/26/)) De grens tussen beide is degene die u in de gaten moet houden bij inkoop en bij elke firmware-upgrade: op het moment dat u het veiligheidsmodel van een leverancier hertraint op uw eigen data, heeft u die grens zeer waarschijnlijk overschreden.

### De wijzigingsvalkuil, uitgeschreven

Artikel 25 is waar een gebruiksverantwoordelijke stilletjes een aanbieder wordt. U erft de **volledige aanbiedersverplichtingen** voor een hoog-risicosysteem als u er **uw eigen naam of merk op zet**, als u een **substantiële wijziging** aanbrengt die het hoog risico houdt, of als u het **beoogde doel verandert** zodat een voorheen niet-hoog-risicosysteem hoog risico wordt. In een OT-context zijn alle drie doodgewone onderhoudsgebeurtenissen, vermomd als juridische drempels.

```compare
Blijft gebruiksverantwoordelijke (Art. 26-plichten)
- Gebruikt het systeem **volgens de instructies** van de aanbieder
- Past leveranciersupdates en patches toe binnen het beoogde doel
- Voedt het met representatieve invoergegevens en monitort de output
- Houdt logs bij, waarborgt bevoegd menselijk toezicht, rapporteert opkomend risico
---
Wordt aanbieder (Art. 25 → Art. 16-plichten)
- **Hertraint** het model op eigen data om de prestaties te wijzigen
- **Rebrandt** het systeem of levert het door onder eigen naam
- **Herbestemt** het — een kwaliteitsmodel omgebouwd tot veiligheidsbeslisser
- **Wijzigt** het substantieel voorbij het door de aanbieder verklaarde ontwerp
```

Dit doet ertoe vanwege kosten en aansprakelijkheid: de aanbieder bezit de conformiteitsbeoordeling, het technisch dossier, de conformiteitsverklaring, de monitoring na marktintroductie en het bewijs onder Artikel 15. De grens per ongeluk overschrijden — een goedbedoelde hertraining om hinderlijke trips te verminderen — kan die volledige last op u overdragen zonder dat iemand iets tekent. Controleer voordat u wijzigt; documenteer het besluit hoe dan ook.

## Een noot over AI voor algemene doeleinden

Los van de risicoklassen stelt de verordening regels vast voor **AI-modellen voor algemene doeleinden (GPAI)** — de grote foundation-modellen die voor veel taken kunnen worden aangepast. Hun verplichtingen (technische documentatie, een beleid voor auteursrechtnaleving, een openbare samenvatting van de trainingsdata, en samenwerking met het AI-Bureau) golden vanaf **2 augustus 2025**, en de Commissie — via het AI-Bureau — kan GPAI-aanbieders rechtstreeks controleren en beboeten onder Artikel 101.

Bovenop deze plichten zit een zwaardere klasse: modellen met **systeemrisico**. Onder **Artikel 51** wordt aangenomen dat een GPAI-model systeemrisico draagt wanneer de cumulatieve rekenkracht voor de training **10²⁵ floating-point-operaties (FLOPs)** overschrijdt — een drempel gericht op de grootste frontier-modellen. Die aanbieders nemen extra plichten op zich: modelevaluatie en adversariële toetsing (red-teaming), beoordeling en mitigatie van systeemrisico, het volgen en melden van ernstige incidenten, en een basisniveau van cyberbeveiliging voor het model en de fysieke infrastructuur ervan. Veel aanbieders voldoen hieraan via de **GPAI-gedragscode**, het co-regulerende instrument dat de Commissie faciliteerde om een vermoeden van naleving te geven.

Voor een industriële operator is dit meestal upstream — u consumeert GPAI via tools in plaats van het te trainen — maar de naadlijn doet er op twee plekken toe. Ten eerste, als u een **foundation-model fine-tunet en in een product inbedt** of onder eigen naam op de markt brengt, komen de vragen over aanbiederschap weer in beeld, en afhankelijk van de betrokken rekenkracht kunt u zelfs downstream GPAI-plichten erven. Ten tweede is een GPAI-aangedreven assistent die u op operationele data richt een **gegevensgovernance- en vertrouwelijkheidsbeslissing** voordat het een gemak is — precies het soort "shadow AI"-blootstelling dat pas ongeïnventariseerd opduikt wanneer iemand gaat zoeken.

> [!IMPORTANT]
> Let op **"shadow AI"** aan de OT-kant van het huis. Engineers die proceslogs in een publieke chatbot plakken om een storing te debuggen, een leverancierstool die stilletjes een gehost model aanroept, een assistent gefinetuned op uw onderhoudshistorie — elk is een AI-systeem dat op de inventaris hoort en verplichtingen kan dragen (geletterdheid, transparantie, vertrouwelijkheid, en soms meer). U kunt niet classificeren of beheersen wat niemand heeft opgeschreven.

## AI-geletterdheid is al wet — Artikel 4

Te midden van het debat over uitgestelde hoog-risicodata is één live verplichting makkelijk te missen: **Artikel 4** vereist dat aanbieders en gebruiksverantwoordelijken een **voldoende niveau van AI-geletterdheid** waarborgen bij hun personeel en bij eenieder die namens hen AI-systemen bedient, en het geldt sinds **2 februari 2025**. Het is niet gebonden aan de hoog-risicoklasse en is **niet** uitgesteld door de Omnibus.

"Voldoende" is proportioneel aan de context: het schaalt mee met de rol van de persoon, de systemen die zij aanraken, en wie erdoor wordt geraakt. Voor een industriële operator betekent dit dat de mensen die een AI-ondersteunde inspectiecel bedienen, een adaptieve controller afstemmen, of de output van een model interpreteren, op een voor hun functie passend niveau moeten begrijpen wat het systeem doet, waar het faalt, en wanneer het te wantrouwen. Dit is de human-factors-tegenhanger van de toezichtplicht van Artikel 14: toezicht werkt alleen als de toezichthoudende persoon de geletterdheid heeft om het uit te oefenen. Een kort, op de rol toegesneden programma met een registratie van wie waarop is getraind is zowel het compliance-artefact als datgene wat het risico op de vloer daadwerkelijk verlaagt.

## Grondrechtenkader en de FRIA

De AI Act is in de kern een grondrechteninstrument, en dat komt tot uiting in één plicht van de gebruiksverantwoordelijke die het vermelden waard is, ook al bijt deze zelden in pure OT: bepaalde gebruiksverantwoordelijken van hoog-risicosystemen — met name overheidsinstanties en sommige aanbieders van essentiële diensten — moeten vóór het eerste gebruik een **grondrechteneffectbeoordeling (FRIA)** onder Artikel 27 uitvoeren, met een beschrijving van het proces, de getroffen personen, de risico's en de maatregelen voor menselijk toezicht en governance. Voor een puur mechanische veiligheidscomponent is het grondrechtenoppervlak klein; voor AI die werknemers, toegang of het publiek raakt — een klantbeïnvloedend beslissysteem van een nutsbedrijf, personeelsmonitoring — is het reëel, en het stapelt bovenop een eventuele AVG-verplichting in plaats van deze te vervangen. De veilige houding is de FRIA-vraag tijdens de classificatie te stellen in plaats van deze tijdens een audit te ontdekken.

## Sancties

Artikel 99 stelt de plafonds vast, en het zijn de hoogste in het EU-digitale recht. Net als bij de AVG en NIS2 is de structuur bewust gekoppeld aan de omzet, zodat non-compliance zich vertaalt naar een financieel risico op bestuursniveau, niet naar een begrotingspost.

| Overtreding | Maximale boete | Artikel |
|---|---|---|
| Verboden praktijken | **35.000.000 euro of 7%** van de totale wereldwijde jaaromzet, afhankelijk van wat hoger is | Art. 5 → Art. 99 |
| Schending van overige verplichtingen (aanbieders, gebruiksverantwoordelijken, importeurs, distributeurs, aangemelde instanties, transparantie) | **15.000.000 euro of 3%** van de wereldwijde omzet | Art. 99 |
| Verstrekken van onjuiste, onvolledige of misleidende informatie aan autoriteiten / aangemelde instanties | **7.500.000 euro of 1%** van de wereldwijde omzet | Art. 99 |
| Inbreuken door aanbieders van GPAI-modellen | **15.000.000 euro of 3%** van de wereldwijde omzet | Art. 101 |

Boetes zijn proportioneel, en voor kmo's en start-ups is het bedrag begrensd op het laagste van het percentage of het absolute bedrag — een bewuste verzachting voor kleinere bedrijven. ([Artikel 99](https://artificialintelligenceact.eu/article/99/); [Artikel 101](https://ai-act-service-desk.ec.europa.eu/en/ai-act/article-101))

```cta
€35 miljoen of 7% van de omzet — maar is uw industriële AI eigenlijk hoog risico?
Meestal niet. De waarde zit in het vinden van de weinige systemen die dat wél zijn en ze goed beheersen. Wij inventariseren en classificeren uw AI tegen de verordening.
Classificeer mijn AI-systemen :: /nl/contact
```

## Conformiteitsbeoordeling, CE-markering en de EU-databank

Een hoog-risicosysteem bereikt de markt niet op de kracht van goede bedoelingen. Voordat het op de markt wordt gebracht of in gebruik wordt genomen, moet de aanbieder een **conformiteitsbeoordeling** uitvoeren — de formele controle dat aan Artikelen 8–15 is voldaan — en de route hangt af van hoe het systeem is geclassificeerd.

Voor de meeste **Bijlage III**-hoog-risicosystemen staat de verordening een conformiteitsbeoordeling toe op basis van **interne controle (Bijlage VI)**: de aanbieder verifieert zelf dat zijn kwaliteitsmanagementsysteem en technische documentatie aan de vereisten voldoen, zonder derde partij. Voor bepaalde systemen — met name sommige biometrische gebruikscasussen — moet de beoordeling in plaats daarvan een **aangemelde instantie (Bijlage VII)** betrekken, een geaccrediteerde onafhankelijke beoordelaar. Voor in **Bijlage I** ingebedde AI wordt de AI-conformiteitscontrole opgenomen in de **bestaande productconformiteitsbeoordeling** onder de relevante harmonisatiewetgeving (zodat de AI-veiligheidscomponent van een machine wordt beoordeeld via de eigen procedure van de Machineverordening, niet via een aparte, parallelle). ([Artikel 43, EU AI Act](https://artificialintelligenceact.eu/article/43/))

De uitkomst van een geslaagde beoordeling is een keten van tastbare artefacten:

| Stap | Wat het is | Wie het bewaart |
|---|---|---|
| **Technische documentatie (Bijlage IV)** | Het bewijsdossier dat conformiteit aantoont | Aanbieder, actueel gehouden |
| **EU-conformiteitsverklaring** | De ondertekende juridische verklaring van naleving door de aanbieder | Aanbieder |
| **CE-markering** | Het zichtbare merk dat het product in de EU mag circuleren | Op het product / begeleidende documenten |
| **Registratie in de EU-databank** | Zelfstandige Bijlage III-systemen vastgelegd vóór marktintroductie | Aanbieder (en gebruiksverantwoordelijken, voor sommige overheidsgebruiken) |
| **Monitoring na marktintroductie** | Doorlopende verzameling van prestatie- en incidentgegevens | Aanbieder |

De praktische implicatie voor een gebruiksverantwoordelijke is een korte inkoopchecklist met echt gewicht: **is er een conformiteitsverklaring, is het systeem CE-gemarkeerd, en kan de aanbieder de gebruiksaanwijzing met de nauwkeurigheidsmetrieken en beperkingen van Artikel 13 overleggen?** Is het antwoord nee, dan kijkt u ofwel niet naar een conform hoog-risicosysteem, ofwel bent u dichter bij het aanbieder-zijn dan u denkt.

## Geharmoniseerde normen en het vermoeden van conformiteit

Niemand wil Artikelen 8–15 voor elk systeem vanaf de grond opnieuw beargumenteren. De verordening gebruikt het klassieke mechanisme van het **Nieuwe Wetgevingskader**: waar een aanbieder een **geharmoniseerde norm** volgt waarvan de referentie in het Publicatieblad is gepubliceerd, geniet het systeem een **vermoeden van conformiteit** met de bijbehorende vereisten. Met andere woorden: voldoe aan de norm en de bewijslast valt grotendeels weg. De normen zelf worden op verzoek van de Commissie ontwikkeld door **CEN-CENELEC (Joint Technical Committee 21)** en bestrijken risicobeheer, datakwaliteit, robuustheid, cyberbeveiliging, transparantie en menselijk toezicht voor AI.

Voor OT is dit de pragmatische route, en ze sluit aan op de beveiligingstechnische normen die u mogelijk al gebruikt. De cyberbeveiligingseis van Artikel 15 is bij uitstek waar AI-specifieke normen en normen voor de beveiliging van besturingssystemen zoals [IEC 62443](/nl/iec-62443) samenkomen: de geharmoniseerde AI-normen geven u het vermoeden van conformiteit, terwijl de zones, conduits en beveiligingsniveaus van 62443 u de *methode* geven om de robuustheid en cyberbeveiliging aan te tonen die de norm verwacht. Uw bewijs één keer opbouwen, tegen beide, is veel goedkoper dan het twee keer opbouwen.

## De koppeling met de Machineverordening

De AI Act staat niet op zichzelf. De **Machineverordening (EU) 2023/1230** — die de oude Machinerichtlijn vervangt en van toepassing is vanaf **20 januari 2027** — moderniseert machineveiligheid voor een wereld van software, connectiviteit en AI, en maakt voor het eerst **cyberbeveiliging tot een essentiële gezondheids- en veiligheidseis**. ([EUR-Lex 2023/1230](https://eur-lex.europa.eu/eli/reg/2023/1230/oj/eng); [Nemko](https://www.nemko.com/blog/eu-machinery-regulation-2023/1230))

De herziene essentiële eisen van Bijlage III behandelen nu AI-gedrag, cyberbeveiliging, samenwerking tussen mens en robot, IoT-connectiviteit, de veiligheidsimpact van software-updates en functionele veiligheid. In gewone taal: veiligheidsgerelateerde besturingssystemen en software moeten immuun zijn voor zowel toevallige storingen *als* opzettelijke aanvallen, en het aansluiten van een apparaat op een machine mag geen gevaar veroorzaken. Cyberbeveiliging in machines is niet langer optioneel — het maakt deel uit van het veiligheidsdossier.

De twee wetten zijn doelbewust met elkaar verweven. Een veiligheidsgerelateerde AI-component in een machine is hoog risico onder de AI Act, en de machine zelf moet voldoen aan de veiligheids- en beveiligingseisen van de Machineverordening. De EU heeft expliciet stappen gezet om de overlap te verduidelijken, zodat een fabrikant niet twee tegenstrijdige conformiteitstrajecten voor één machine hoeft te doorlopen. ([IAPP](https://iapp.org/news/a/eu-agrees-to-amend-ai-act-clarifies-overlap-with-machinery-rules)) Voor een machinebouwer of een operator die nieuwe apparatuur in bedrijf stelt, loopt het compliant traject via **beide tegelijk** — precies waarom het classificatiewerk en de beveiligingstechniek in dezelfde kamer moeten plaatsvinden. Zie de pagina [Machineverordening](/nl/machine-act) voor de kant van machineveiligheid in dit verhaal.

## Een uitgewerkt voorbeeld: een AI-visietrip op een pers van 400 ton

Abstractie verbergt de beslissingen. Loop één concreet systeem door de hele keten en de wet houdt op een muur van artikelen te zijn.

Een stanslijn draait een **mechanische pers van 400 ton**. Om operators te beschermen vervangt de bouwer het vaste lichtgordijn door een **AI-visiesysteem** dat de gevarenzone bewaakt en **de pers opdracht geeft te stoppen** als het een hand, arm of lichaam binnen de beveiligde zone tijdens de slag detecteert. Het leert een hand van een schaduw te onderscheiden, een handschoen van een onderdeel, stoom van een indringing.

- **Is het hoog risico?** Ja — via **Route 1 (Bijlage I)**. Het visiesysteem is een **veiligheidscomponent van een machine** (Verordening (EU) 2023/1230), en machines vallen onder Bijlage I-harmonisatiewetgeving. De classificatie is automatisch; er is geen ontsnapping via Artikel 6, lid 3, omdat de output van het model *wezenlijk beïnvloedt* of een gevaarlijke beweging stopt. Zodra de beslissing de pers kan stoppen, verricht het veiligheidsrelevant werk.
- **Wie is de aanbieder?** De **machinebouwer** die het visiesysteem integreert en de pers onder eigen naam op de markt brengt. Hij bezit de technische documentatie, het risicobeheerdossier (Artikel 9), de gegevensgovernance voor de trainingsset (Artikel 10), de conformiteitsverklaring en de CE-markering.
- **Wat eist Artikel 15?** Dat het model **nauwkeurig** is (een verklaard, getest detectiepercentage onder echte verlichting, stof en snelheid), **robuust** (fail-safe — een verloren frame, een geblokkeerde lens of een out-of-distribution input moet de pers laten stoppen, niet doorlaten), en **cyberveilig** (een aanvaller mag geen vervalst frame kunnen invoeren, het model vergiftigen, of een **adversariële patch** maken — een sticker of patroon dat het model een hand als achtergrond laat classificeren op precies het verkeerde moment).
- **Waar bijt de Machineverordening?** Parallel. Het **veiligheidsgerelateerde besturingssysteem** moet voldoen aan de essentiële gezondheids- en veiligheidseisen — inclusief de nieuwe **cyberbeveiligings**eis — en de AI-conformiteitscontrole vouwt zich in de eigen conformiteitsbeoordeling van de machine in plaats van als apart traject te lopen.
- **Wat als de operator het hertraint?** Als de fabrieksoperator het **model hertraint op zijn eigen product** om valse trips te verminderen, kan hij het systeem **substantieel wijzigen** en **de aanbieder worden** — met overname van de volledige documentatie-, conformiteits- en Artikel 15-last waarvan hij dacht dat die bij de bouwer lag.
- **Waar leeft het beveiligingsprogramma?** De risico's van adversariële patches en datavergiftiging zijn **OT-dreigingen**, in kaart gebracht via [IEC 62443](/nl/iec-62443)-zones en -conduits en staand op hetzelfde risicoregister voor besturingssystemen als blootstelling via toegang op afstand en ransomware — niet in een aparte AI-silo.

Eén pers, één model, en vier regimes die eraan raken: de AI Act, de Machineverordening, [NIS2](/nl/nis2) bij de operator, en de [CRA](/nl/cra) op de digitale componenten erin. Daarom pleit OXOT ervoor ze te beantwoorden met **één samenhangend model van de fabriek**, niet vier losse projecten.

## Sectorspecifieke aandachtspunten

De classificatielogica is gemeenschappelijk, maar waar AI landt verschilt per sector:

- **Energie en net.** AI in onderstationsautomatisering, DER-orkestratie en belastingprognose kan een **Bijlage III**-veiligheidscomponent zijn in de elektriciteitsvoorziening. Beschikbaarheid domineert, en een gemanipuleerde prognose of beschermingsnabij model is een stabiliteitsrisico, niet enkel een datakwaliteitskwestie.
- **Water en afvalwater.** Doseeroptimalisatie en afwijkingsdetectie zitten dicht bij volksgezondheidsuitkomsten; een AI die een chemisch setpoint aanpast, beïnvloedt wezenlijk een veiligheidsrelevant proces, wat het naar hoog risico trekt.
- **Discrete productie.** De Bijlage I / machine-route is de gebruikelijke: op visie gebaseerde veiligheidstrips, AI-geleide cobots, adaptieve controllers op gevaarlijke bewegingen. De aanbieder/gebruiksverantwoordelijke-valkuil rond hertraining is hier het scherpst.
- **Farma en medische productie.** AI in hulpmiddelen en productie overlapt de verordeningen voor **medische hulpmiddelen / IVD** (eveneens Bijlage I), waardoor conformiteitsregimes zich op hetzelfde systeem stapelen.
- **Chemie en procesindustrie.** AI nabij **veiligheidsinstrumentatiesystemen** moet worden verzoend met functionele-veiligheidsregimes — een natuurlijke fit voor de risicogebaseerde zones van IEC 62443 in plaats van een bolt-on.

## Wat het betekent voor OT — en voor uw rol

De eerlijke hoofdboodschap verdient herhaling: **de meeste industriële AI is geen hoog risico.** Het werk zit in het vinden van de AI die dat wel is, deze correct classificeren, en deze beheersen zonder nuttige innovatie te verstikken. Verschillende mensen in de organisatie ervaren dat werk verschillend.

**Als u CISO bent of AI-governanceverantwoordelijke**, breidt de AI Act uw mandaat uit naar modellen die zijn ingebed in OT, en Artikel 15 maakt modelrobuustheid en cyberbeveiliging expliciet uw probleem. U heeft een inventaris van AI-systemen nodig, een verdedigbare classificatie voor elk, en bewijs dat de weinige hoog-risicosystemen worden beheerst — inclusief tegen datavergiftiging en adversariële manipulatie.

**Als u een operationeel of technisch manager bent**, worden de vragen concreet bij inkoop en bij elke upgrade: Is deze AI een veiligheidscomponent? Wie is de aanbieder? Is er een conformiteitsverklaring en een CE-markering? Maakt hertraining of wijziging ervan *ons* tot aanbieder?

**Als u in de raad van bestuur zit**, voegt de AI Act een tweede aan omzet gekoppeld sanctieregime toe bovenop NIS2, en de verantwoordelijkheid voor classificatie en governance rust uiteindelijk bij u. Het geruststellende deel is dat de reikwijdte smaller is dan de krantenkoppen suggereren; het ongemakkelijke deel is dat "we wisten niet dat we die AI hadden" geen verweer is.

## Een praktische aanpak — inventariseren, classificeren, beheersen

1. **Inventariseer uw AI.** U kunt niet classificeren wat u niet heeft opgelijst. Bouw een register van AI-systemen over IT en OT heen, inclusief ingebedde modellen in aandrijvingen, controllers en visiecellen, en door leveranciers geleverde modellen die u misschien niet als "AI" herkent.
2. **Classificeer elk systeem.** Beslis voor elk systeem: verboden, hoog risico (via Bijlage I of Bijlage III), beperkt risico, of minimaal risico — en **documenteer de redenering**, vooral waar u concludeert dat een systeem *geen* hoog risico is. De verordening verwacht dat u die beslissing kunt onderbouwen.
3. **Stel uw rol vast.** Bepaal voor elk hoog-risicosysteem of u aanbieder of gebruiksverantwoordelijke bent, en bevestig dat de aanbieder zijn deel heeft gedaan — conformiteitsbeoordeling, CE-markering, documentatie, conformiteitsverklaring.
4. **Beheers de weinige hoog-risicosystemen.** Zorg voor menselijk toezicht, logging, monitoring en — voor alles in een besturings- of veiligheidslus — robuustheids- en cyberbeveiligingscontroles onder Artikel 15. Test het model tegen adversariële input, niet alleen tegen nominale input.
5. **Sluit aan bij uw OT-beveiligingsprogramma.** Behandel AI-robuustheid als onderdeel van de beveiliging van besturingssystemen, niet als aparte silo. Datavergiftiging en modelmanipulatie zijn nu OT-dreigingen, en horen op hetzelfde risicoregister thuis als ransomware en blootstelling via toegang op afstand. Zie [Frameworks](/nl/frameworks) voor hoe de regimes op elkaar aansluiten.

## Hoe OXOT helpt

AI-classificatie en robuustheid onder Artikel 15 zijn in de kern vragen over waar AI zich bevindt in uw operationele risicobeeld — en dat is precies wat OXOT modelleert. Onze **[Cyber Digital Twin](/nl/cyber-digital-twin)** geeft u een gestructureerd, levend overzicht van uw OT-omgeving, inclusief waar AI-componenten zich bevinden ten opzichte van veiligheids- en besturingsfuncties, zodat u de weinige hoog-risicosystemen kunt vinden en de cyberbeveiliging van de modellen die er echt toe doen kunt beheersen. Onze OT-beveiligingsbeoordelingen en -programma's integreren AI-robuustheid in uw bredere beveiliging van besturingssystemen, en onze afstemming op **[IEC 62443](/nl/iec-62443)** geeft u een technische methode om aan te tonen dat aan de beveiligingseisen — inclusief die van Artikel 15 — wordt voldaan. Waar de AI Act de [CRA](/nl/cra), [NIS2](/nl/nis2) en de [Machineverordening](/nl/machine-act) ontmoet, helpen wij u alle vier te beantwoorden met één samenhangend beeld in plaats van vier losse projecten.

## Veelgestelde vragen

**Is ons predictief-onderhoudsmodel hoog risico?**
Vrijwel zeker niet, als het alleen onderhoud informeert en niet fungeert als veiligheidscomponent of een gevaarlijk proces aanstuurt. Maar documenteer die conclusie — de verordening verwacht dat u een niet-hoog-risicoclassificatie onderbouwt, en "dat namen we aan" is geen documentatie.

**Wij kopen machines met AI erin van een OEM. Zijn wij de aanbieder?**
Meestal is de OEM de aanbieder. Maar als u de AI substantieel wijzigt, deze hertraint op uw eigen data, of deze onder uw eigen naam op de markt brengt, kunt u de aanbieder worden en die verplichtingen overnemen. Controleer dit voordat u wijzigt — de valkuil klapt stilletjes dicht.

**Hoe verhoudt de AI Act zich tot NIS2, de CRA en de Machineverordening?**
Ze stapelen zich op. [NIS2](/nl/nis2) regelt hoe u uw systemen exploiteert; de [CRA](/nl/cra) regelt de beveiliging van producten met digitale elementen; de Machineverordening maakt cyberbeveiliging tot een machineveiligheidseis; en de AI Act regelt specifiek AI-systemen, met Artikel 15 als de beveiligingsbrug. Een veiligheidsgerelateerde industriële AI kan door alle vier tegelijk worden geraakt.

**De hoog-risicotermijnen zijn verschoven — heb ik meer tijd?**
Ja, en nee. De Digital Omnibus heeft zelfstandige Bijlage III-systemen uitgesteld naar 2 december 2027 en in producten ingebedde Bijlage I-AI naar 2 augustus 2028 — maar die data zijn voorlopig totdat het wijzigingsbesluit is gepubliceerd, en de verbodsbepalingen en AI-geletterdheidsplichten gelden al. Inventarisatie en classificatie kosten meer tijd dan het papierwerk dat daarop volgt, dus nu beginnen is de goedkope optie.

**Maakt het de verordening uit welke AI-techniek wij hebben gebruikt?**
Nee. Ze is technologieneutraal. Een regelgebaseerd systeem en een diep neuraal netwerk worden hetzelfde behandeld als ze dezelfde veiligheidsrelevante taak op dezelfde plek uitvoeren. Wat telt is de *functie en context*, niet het algoritme.

**Ons Bijlage III-systeem doet een "beperkte taak" — kunnen we hoog risico overslaan?**
Mogelijk, via de afwijking van Artikel 6, lid 3 — maar alleen als u het werkelijk in een van de vier voorwaarden kunt plaatsen (beperkte procedurele taak, verbetering van een voltooide menselijke activiteit, detectie van patronen zonder menselijk oordeel te vervangen, of een voorbereidende taak) *én* het geen persoon profileert of een veiligheids- of rechtenrelevante uitkomst wezenlijk beïnvloedt. U moet het systeem eerst registreren en de beoordeling vastleggen, en de voorwaarden worden eng uitgelegd. Voor een echte veiligheidscomponent is de uitgang zelden van toepassing.

**Hebben we een aangemelde instantie nodig om onze hoog-risico-AI te beoordelen?**
Meestal niet voor industriële systemen. De meeste Bijlage III-systemen gebruiken conformiteitsbeoordeling via interne controle (Bijlage VI); een aangemelde instantie (Bijlage VII) is vooral vereist voor bepaalde biometrische gebruikscasussen. Voor in machines ingebedde AI (Bijlage I) wordt de AI-controle opgenomen in de bestaande conformiteitsbeoordeling van de machine in plaats van er een aparte toe te voegen.

**Is een norm volgen genoeg om te voldoen?**
Het volgen van een geharmoniseerde norm waarvan de referentie in het Publicatieblad is gepubliceerd, geeft een **vermoeden van conformiteit** met de bijbehorende vereisten — wat de bewijslast sterk in uw voordeel verschuift, al kan een markttoezichtautoriteit nog steeds onderzoeken. De AI-normen worden geschreven door CEN-CENELEC JTC 21, en voor de cyberbeveiliging van Artikel 15 sluiten ze goed aan op IEC 62443.

**En personeel dat gewoon een AI-tool gebruikt — nu al een verplichting?**
Ja. De AI-geletterdheidsplicht van Artikel 4 is live en is niet uitgesteld. Iedereen die namens u AI bedient, heeft een begripsniveau nodig dat past bij de rol. Een kort, op de rol toegesneden trainingsprogramma met een registratie van voltooiing is het verwachte artefact.

## Bronnen

- Verordening (EU) 2024/1689 (AI Act), officiële tekst — [EUR-Lex](https://eur-lex.europa.eu/eli/reg/2024/1689/oj/eng)
- AI Act-beleid en -implementatie — [Europese Commissie, Shaping Europe's digital future](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai)
- Artikel 6 — classificatie van hoog-risicosystemen — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/article/6/)
- Artikel 15 — nauwkeurigheid, robuustheid en cyberbeveiliging — [AI Act Service Desk (EC)](https://ai-act-service-desk.ec.europa.eu/en/ai-act/article-15)
- Artikel 16 — verplichtingen aanbieder — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/article/16/)
- Artikel 26 — verplichtingen gebruiksverantwoordelijke — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/article/26/)
- Artikel 43 — conformiteitsbeoordeling (Bijlage VI interne controle / Bijlage VII aangemelde instantie) — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/article/43/)
- Artikel 6, lid 3 afwijking & classificatierichtsnoeren van de Commissie — [Data Protection Report](https://www.dataprotectionreport.com/2026/05/is-my-use-case-a-high-risk-ai-system-applying-the-commissions-guidelines-and-next-steps/)
- Digital Omnibus — definitieve vaststelling door de Raad, 29 juni 2026 — [Raad van de EU](https://www.consilium.europa.eu/en/press/press-releases/2026/06/29/artificial-intelligence-council-gives-final-green-light-to-simplify-and-streamline-rules/); [White & Case](https://www.whitecase.com/insight-alert/eu-agrees-digital-omnibus-deal-simplify-ai-rules)
- Artikel 99 — sancties — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/article/99/)
- Artikel 101 — boetes GPAI-modellen — [AI Act Service Desk (EC)](https://ai-act-service-desk.ec.europa.eu/en/ai-act/article-101)
- Bijlage I — Unie-harmonisatiewetgeving (incl. machines) — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/annex/1/)
- Bijlage III — hoog-risicogebruikscasussen (incl. kritieke infrastructuur) — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/annex/3/)
- Digital Omnibus — uitgestelde hoog-risicotermijnen (overeengekomen 7 mei 2026) — [Gibson Dunn](https://www.gibsondunn.com/eu-ai-act-omnibus-agreement-postponed-high-risk-deadlines-and-other-key-changes/); [Hogan Lovells](https://www.hoganlovells.com/en/publications/eu-legislators-agree-to-delay-for-highrisk-ai-rules)
- Conceptrichtsnoeren voor hoog-risicoclassificatie — [McCann FitzGerald](https://www.mccannfitzgerald.com/knowledge/construction-and-infrastructure/critical-infrastructure-spotlight-eu-ai-act-draft-guidelines-on-high-risk-ai-classification)
- EU-Machineverordening (EU) 2023/1230 — [EUR-Lex](https://eur-lex.europa.eu/eli/reg/2023/1230/oj/eng); overzicht cyberbeveiliging — [Nemko](https://www.nemko.com/blog/eu-machinery-regulation-2023/1230)
- Overlap AI Act / Machineverordening verduidelijkt — [IAPP](https://iapp.org/news/a/eu-agrees-to-amend-ai-act-clarifies-overlap-with-machinery-rules)

*Deze pagina bevat algemene informatie over EU-recht en vormt geen juridisch advies. Classificatie onder de AI Act is feitelijk bepaald; toets de status van uw systemen aan de verordening en, waar nodig, aan gekwalificeerd juridisch advies.*$MDBODY$, true, $MDBODY$EU AI Act voor Industriële & OT-AI | OXOT$MDBODY$, $MDBODY$De EU AI Act (Verordening (EU) 2024/1689) voor industrie en OT — risicoklassen met voorbeelden uit de praktijk op de werkvloer, de twee routes naar hoog risico, de koppeling met de Machineverordening, de plichten van aanbieder versus gebruiksverantwoordelijke, cyberbeveiliging onder Artikel 15, het herziene tijdpad voor 2026 en de sancties.$MDBODY$, $MDBODY$Hoe de EU AI Act van toepassing is zodra AI de fabrieksvloer betreedt — classificatie als hoog risico, de koppeling met machineveiligheid, de plichten van aanbieder en gebruiksverantwoordelijke, robuustheid onder Artikel 15, het herziene tijdpad voor 2026 en de sancties.$MDBODY$, NULL, $MDBODY$page$MDBODY$, now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET
  title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published,
  meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description,
  excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type,
  published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now()
WHERE length(pages.body) < length(EXCLUDED.body);

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ($MDBODY$nis2$MDBODY$, $MDBODY$en$MDBODY$, $MDBODY$NIS2 for Operational Technology$MDBODY$, $MDBODY$NIS2 is the European Union's second Network and Information Security Directive, and it is the most consequential cybersecurity law most industrial operators in Europe have ever had to answer to. It replaces the original 2016 NIS Directive, widens the net of who is covered, hard-codes reporting deadlines, and — for the first time — makes senior management personally accountable for getting cybersecurity right.

For an operator of a substation, a pumping station, a chemical plant or a factory floor, NIS2 is not an IT problem that stays inside the server room. It reaches directly into the Operational Technology (OT) that keeps production running and people safe. A tripped safety instrumented system, a halted bottling line, a manipulated setpoint on a chlorine dosing pump — these are the events the directive cares about, and they live in the world of PLCs, RTUs, drives and historians, not email servers. This page explains what the law actually requires, where it bites hardest in OT environments, and what a realistic response looks like.

## The short version

- NIS2 is **Directive (EU) 2022/2555**, adopted on 14 December 2022 and in force since 16 January 2023. Member States had to transpose it into national law by **17 October 2024**. ([EUR-Lex, CELEX 32022L2555](https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022L2555))
- It covers far more sectors and organisations than the old NIS Directive, split into **essential** and **important** entities across **18 sectors** (11 in Annex I, 7 in Annex II).
- **Article 21** sets a **minimum baseline of ten risk-management measures**, built on an **all-hazards approach** that includes physical and environmental threats — not just cyberattacks.
- **Article 23** imposes a strict incident-reporting rhythm: an **early warning within 24 hours**, a **notification within 72 hours**, and a **final report within one month**.
- **Article 20** requires management bodies to **approve and oversee** the measures, obliges them to **undergo training**, and lets them be **held liable** for failures.
- **Article 34** sets fines of **at least €10 million or 2% of global annual turnover** for essential entities, and **at least €7 million or 1.4%** for important entities — whichever is higher.

If you take one thing away: NIS2 is a governance and risk-management law, not a shopping list of products. It rewards organisations that can *show* they understand their risk and manage it deliberately — which is exactly where OT security so often falls down.

> [!IMPORTANT]
> NIS2 is a directive, not a regulation. It does not apply to your organisation directly — it applies through your Member State's national transposition law. Always check the national statute, because several countries went further than the directive's floor. In the Netherlands, that law is the **Cyberbeveiligingswet (Cbw)**.

## Why NIS2 exists

The 2016 NIS Directive was the EU's first attempt to raise the cybersecurity baseline for critical services. It worked unevenly. Member States interpreted "operators of essential services" differently, enforcement was patchy, and whole categories that clearly mattered — wastewater, food production, manufacturing, public administration — sat outside its scope. Two organisations delivering the same essential service in two countries could face wildly different obligations, or none at all.

Meanwhile the threat landscape moved on. Ransomware crews learned that stopping production is more profitable than stealing data, because a plant losing millions a day pays quickly. State-aligned actors demonstrated, repeatedly, that industrial control systems are viable targets — from the wiper attacks on Ukrainian power distribution to the intrusion sets that reconnoitre European utilities without ever pulling the trigger. Supply-chain compromises showed that trusted software updates and remote-maintenance channels are as dangerous as any front-door exploit.

NIS2 is the correction. It harmonises the rules, expands the scope dramatically, hard-codes reporting timelines, and puts accountability where decisions actually get made — with senior management. The directive's recitals are candid that the previous regime left gaps and that the exposure of essential and important entities had grown faster than the law governing them.

## Who is in scope

NIS2 divides covered organisations into two tiers. Both must meet the same core security obligations under Article 21 and the same reporting duties under Article 23; the difference lies in how strictly they are supervised and how they are penalised. ([nis-2-directive.com, Article 3](https://www.nis-2-directive.com/NIS_2_Directive_Article_3.html))

### The two tiers at a glance

| Tier | Sectors | Supervision | Fine ceiling |
| --- | --- | --- | --- |
| **Essential entities** | Annex I high-criticality sectors, at scale | Proactive, *ex ante* — audits and inspections without needing evidence of a problem | At least **€10m or 2%** of global annual turnover, whichever is higher |
| **Important entities** | Annex II other-critical sectors | Reactive, *ex post* — action on evidence or indication of non-compliance | At least **€7m or 1.4%** of global annual turnover, whichever is higher |

### Annex I — the 11 highly critical sectors

The essential tier is drawn largely from Annex I: **energy** (electricity, oil, gas, district heating and cooling, hydrogen), **transport** (air, rail, water, road), **banking**, **financial market infrastructures**, **health**, **drinking water**, **wastewater**, **digital infrastructure**, **ICT service management** (B2B), **public administration**, and **space**. ([Glocert, essential vs important](https://www.glocertinternational.com/resources/guides/nis2-applicability-essential-vs-important-entities/))

### Annex II — the 7 other critical sectors

Annex II adds the important-tier sectors: **postal and courier services**, **waste management**, **manufacture, production and distribution of chemicals**, **food production and distribution**, **manufacturing** (medical devices, computers and electronics, machinery and equipment, motor vehicles, other transport equipment), **digital providers** (online marketplaces, search engines, social platforms), and **research organisations**.

### The size rule — and its exceptions

As a general rule, NIS2 applies to organisations that are **medium-sized or larger** in an in-scope sector — broadly, **50 or more employees, or annual turnover / balance sheet total above €10 million**. An entity that also crosses **250 employees or €50 million turnover** is a large enterprise and, in a high-criticality sector, is typically an essential entity. ([Legiscope, essential vs important](https://www.legiscope.com/blog/nis2-essential-important-entities.html))

There are important exceptions. Certain providers are in scope **regardless of size** — including **DNS service providers, top-level-domain name registries, trust service providers, and providers of public electronic communications networks or services**. Member States can also designate specific smaller entities as covered where they are, for example, the sole provider of a critical service in a region, or where disruption would have significant impact.

> [!WARNING]
> The practical consequence for industry is stark. A mid-sized manufacturer, a regional water utility, a food producer or a chemicals distributor that never considered itself "critical national infrastructure" is now very likely in scope — and many did not notice when the transposition deadline passed. Not knowing you are in scope is not a defence.

### Where transposition actually stands

Member States were supposed to have national law in force by 17 October 2024. Most missed it. On **7 May 2025 the European Commission issued reasoned opinions to 19 Member States** for failing to notify full transposition, a formal step before referral to the Court of Justice. ([European Commission, NIS transposition](https://digital-strategy.ec.europa.eu/en/policies/nis-transposition)) As of 2026 the majority have adopted transposing legislation while several — including **France, Ireland, Luxembourg, the Netherlands and Spain** — completed the process later than the deadline. ([ECSO transposition tracker](https://ecs-org.eu/activities/nis2-directive-transposition-tracker/))

In the **Netherlands**, the **Cyberbeveiligingswet (Cbw)** implements NIS2. The **Dutch Parliament (Tweede Kamer) approved the draft on 15 April 2026**, with formal adoption targeted for later in 2026 following Senate review. ([Bird & Bird, Dutch Cybersecurity Act](https://www.twobirds.com/en/insights/2026/netherlands/dutch-parliament-approves-cybersecurity-act-implementing-nis2)) The delay does not change the substance operators must prepare for — and it does not pause the obligation to be ready.

## Essential vs important entities — the split that sets your regime

NIS2 sorts in-scope organisations into two tiers, and the tier decides how hard the law lands on you: the supervision model, the penalty ceiling, and how proactively a regulator can knock on your door. The split is driven by sector *and* size — as a rule, large enterprises in the highest-criticality sectors are **essential**, while medium-sized organisations and those in "other critical" sectors are **important**. Both tiers carry the same core security and reporting duties; what differs is the enforcement posture.

```compare
Essential entities
- Highest-criticality sectors: energy, transport, banking, financial-market infrastructure, health, drinking & waste water, digital infrastructure, ICT service management, public administration, space
- **Proactive (ex ante) supervision** — regulators may audit, inspect and demand evidence without waiting for an incident
- Administrative fines up to **€10 million or 2% of global annual turnover**, whichever is higher
---
Important entities
- Other critical sectors: postal & courier, waste management, chemicals, food, manufacturing (incl. medical devices, machinery, vehicles), digital providers, research
- **Reactive (ex post) supervision** — scrutiny typically follows evidence of non-compliance or an incident
- Administrative fines up to **€7 million or 1.4% of global annual turnover**, whichever is higher
```

> [!IMPORTANT]
> The classification is not a self-assessment you can quietly round down. NIS2 introduces a **registration duty** — in-scope entities must register with their national authority (in the Netherlands, coordinated via the NCSC/RDI landscape under the Cbw), and the **"size-cap" rule** means a company can be pulled in below the usual size thresholds if it is the sole provider of a critical service or its disruption would have significant societal impact. Getting the classification wrong in either direction is itself a governance failure.

## Governance and scope, at a glance

The diagram below traces the chain NIS2 constructs: from an accountable management body, down through the ten measures, into the supervision and enforcement that keep them honest.

```svg
<svg viewBox="0 0 700 380" xmlns="http://www.w3.org/2000/svg" font-family="Segoe UI, Helvetica, Arial, sans-serif">
  <rect x="0" y="0" width="700" height="380" fill="none"/>
  <!-- Management body -->
  <rect x="200" y="20" width="300" height="56" rx="8" fill="#3b82f6" fill-opacity="0.15" stroke="#3b82f6" stroke-width="1.5"/>
  <text x="350" y="44" text-anchor="middle" fill="#e5e7eb" font-size="15" font-weight="700">Management body (Art. 20)</text>
  <text x="350" y="63" text-anchor="middle" fill="#94a3b8" font-size="11">Approves &amp; oversees measures · trained · liable</text>
  <!-- arrow down -->
  <line x1="350" y1="76" x2="350" y2="104" stroke="#94a3b8" stroke-width="1.5"/>
  <polygon points="350,110 345,100 355,100" fill="#94a3b8"/>
  <!-- Measures -->
  <rect x="120" y="112" width="460" height="70" rx="8" fill="#94a3b8" fill-opacity="0.10" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="350" y="134" text-anchor="middle" fill="#e5e7eb" font-size="15" font-weight="700">Ten risk-management measures (Art. 21)</text>
  <text x="350" y="154" text-anchor="middle" fill="#94a3b8" font-size="11">All-hazards · proportionate · IT and OT in scope</text>
  <text x="350" y="171" text-anchor="middle" fill="#94a3b8" font-size="11">Risk analysis · incident handling · continuity · supply chain · MFA · more</text>
  <!-- two arrows down -->
  <line x1="230" y1="182" x2="230" y2="212" stroke="#94a3b8" stroke-width="1.5"/>
  <polygon points="230,218 225,208 235,208" fill="#94a3b8"/>
  <line x1="470" y1="182" x2="470" y2="212" stroke="#94a3b8" stroke-width="1.5"/>
  <polygon points="470,218 465,208 475,208" fill="#94a3b8"/>
  <!-- Reporting -->
  <rect x="60" y="220" width="340" height="64" rx="8" fill="#f97316" fill-opacity="0.13" stroke="#f97316" stroke-width="1.5"/>
  <text x="230" y="244" text-anchor="middle" fill="#e5e7eb" font-size="14" font-weight="700">Incident reporting (Art. 23)</text>
  <text x="230" y="264" text-anchor="middle" fill="#94a3b8" font-size="11">24h warning → 72h notification → 1-month report</text>
  <text x="230" y="279" text-anchor="middle" fill="#94a3b8" font-size="11">to national CSIRT / competent authority</text>
  <!-- Supervision -->
  <rect x="360" y="220" width="280" height="64" rx="8" fill="#3b82f6" fill-opacity="0.10" stroke="#3b82f6" stroke-width="1.5"/>
  <text x="500" y="244" text-anchor="middle" fill="#e5e7eb" font-size="14" font-weight="700">Supervision (Art. 32–33)</text>
  <text x="500" y="264" text-anchor="middle" fill="#94a3b8" font-size="11">Essential: ex ante · Important: ex post</text>
  <text x="500" y="279" text-anchor="middle" fill="#94a3b8" font-size="11">Audits · orders · monitoring officer</text>
  <!-- arrows to enforcement -->
  <line x1="230" y1="284" x2="330" y2="316" stroke="#94a3b8" stroke-width="1.5"/>
  <line x1="500" y1="284" x2="380" y2="316" stroke="#94a3b8" stroke-width="1.5"/>
  <!-- Enforcement -->
  <rect x="230" y="320" width="240" height="46" rx="8" fill="#f97316" fill-opacity="0.16" stroke="#f97316" stroke-width="1.5"/>
  <text x="350" y="343" text-anchor="middle" fill="#e5e7eb" font-size="14" font-weight="700">Enforcement &amp; fines (Art. 34)</text>
  <text x="350" y="359" text-anchor="middle" fill="#94a3b8" font-size="11">Up to €10m / 2% or €7m / 1.4%</text>
</svg>
```

## Article 21: the ten measures, decoded for OT

Article 21 is the heart of the directive. It requires covered entities to take "appropriate and proportionate technical, operational and organisational measures to manage the risks posed to the security of network and information systems." It uses an **all-hazards approach** — the measures must protect those systems and their physical environment from incidents, whether the cause is a hacker, a fire, a flood or a failed supplier. ([nis-2-directive.com, Article 21](https://www.nis-2-directive.com/NIS_2_Directive_Article_21.html))

The article lists ten measures as a minimum. Read through a pure-IT lens, each looks familiar. Read through an OT lens, each carries weight that is easy to underestimate. The table maps them; the sections that follow go deeper.

| # | Article 21(2) measure | What it means | OT implication |
| --- | --- | --- | --- |
| 1 | Risk analysis and information system security policies | A documented, current understanding of risk and the policies that govern it | Starts with an asset inventory most plants cannot produce on demand |
| 2 | Incident handling | Prevention, detection, analysis, containment, response, recovery | You often cannot reboot, patch or isolate without touching a live physical process |
| 3 | Business continuity, backup, disaster recovery, crisis management | Keep or restore operations after disruption | Tested recovery of PLC/RTU configs, engineering workstations and historians — not just servers |
| 4 | Supply chain security | Security of relationships with direct suppliers and service providers | Your OEMs, integrators and maintenance vendors hold remote access to your crown jewels |
| 5 | Security in acquisition, development and maintenance; vulnerability handling and disclosure | Build security into how you buy and maintain systems | Procurement clauses and patch windows for control systems, not bolt-on fixes |
| 6 | Policies to assess the effectiveness of measures | Prove the controls actually work | Testing and audit that respect operational constraints — no disruptive scans on live cells |
| 7 | Basic cyber hygiene and security training | Patching, config management, least privilege, awareness | Applied to engineers and operators, whose day jobs are not IT security |
| 8 | Cryptography and, where appropriate, encryption | Proportionate use of crypto | Usually protects remote access, data in transit and backups — rarely real-time control traffic |
| 9 | HR security, access control, asset management | Who can touch what, from where, with which rights | Shared accounts, contractor access and vendor logins are the classic weak points |
| 10 | MFA / continuous authentication; secured & emergency communications | Strong auth and hardened comms channels | MFA on remote and privileged OT access is now an expectation, not a nice-to-have |

### 1 — Risk analysis and security policies

Everything downstream rests on this. You need a current, documented view of your risk and the policies that govern how you manage it. In OT, that view is impossible without an accurate **asset inventory** — and this is precisely where most operators fall short. A plant that cannot list, on demand, which controllers it runs, how they connect, which are internet-reachable and which protect a safety function is doing risk analysis on guesswork. NIS2 turns that gap from an operational nuisance into a compliance exposure.

### 2 — Incident handling

Detection, analysis, containment, response and recovery — the full lifecycle. The IT playbook assumes you can isolate a host, kill a process or restore from image. On a process line, those moves may trip a safety function or scrap a batch. OT incident handling has to be written with the process engineer in the room, with pre-agreed decision rights for who can take equipment offline and under what safety conditions.

### 3 — Business continuity and crisis management

Backup, disaster recovery and the ability to keep or restore operations. For OT this means tested, restorable copies of **PLC and RTU logic, HMI and SCADA projects, engineering workstation images, drive parameters and historian data** — and a rehearsed plan for rebuilding a cell from bare metal. Backups you have never restored are a hypothesis, not a control.

### 4 — Supply chain security

NIS2 makes supply-chain risk explicit. Entities must consider the vulnerabilities of each direct supplier, the quality of their products and their secure-development practices, and factor in the EU-level **coordinated risk assessments of critical supply chains** under Article 22. ([nis2-info.eu, Article 21](https://www.nis2-info.eu/article-21-cybersecurity-risk-management-measures/)) In OT the supply chain *is* the attack surface: your integrators and OEMs frequently hold standing remote access into your most sensitive equipment. Vendor access governance is not a paperwork exercise here — it is one of the highest-leverage controls you own.

### 5 — Security in acquisition, development and maintenance

This reaches into procurement and the whole system lifecycle, including vulnerability handling and disclosure. Security requirements belong in the specification when you buy a new line or upgrade a control system — not in a remediation project three years later. It is also where NIS2 meets the [Cyber Resilience Act](/en/cra) and the [Machinery Regulation](/en/machine-act): the products you buy increasingly arrive with security obligations of their own, and your job is to demand and verify them.

### 6 — Assessing effectiveness

You must be able to show the measures work, through testing, audit and review. In OT the challenge is doing this without breaking anything — active scanning a live control network can be as disruptive as an attack. Passive monitoring, offline validation and staged testing become the tools of choice, and a [Cyber Digital Twin](/en/cyber-digital-twin) lets you reason about "does this control hold?" against a model rather than against production.

### 7 — Basic cyber hygiene and training

Patching, configuration management, least privilege, awareness. The catch: in OT the "users" are engineers, operators and maintenance staff, and patch cycles are governed by maintenance windows measured in months. Hygiene has to be designed around operational reality — compensating controls where patching is genuinely impossible, and training that speaks the language of the plant, not the SOC.

### 8 — Cryptography and encryption

Applied proportionately. In OT, encryption usually protects remote-access sessions, data in transit across untrusted links, and backups — not real-time control traffic, where latency and legacy protocols often make in-line encryption impractical. The word "proportionate" is doing real work here: NIS2 does not ask you to encrypt a 20-year-old fieldbus.

### 9 — HR security, access control and asset management

Who can touch what, from where, with which privileges. Shared operator accounts, generic vendor logins and contractors with standing access are endemic in OT and are exactly what this measure targets. Tighter access control and a maintained asset register are the two controls that most often move the needle on real risk.

### 10 — MFA and secured communications

Multi-factor or continuous authentication, plus secured voice, video and text and emergency communications where appropriate. Read plainly: **MFA on remote and privileged access to OT is now an expectation.** Given how much OT compromise begins with an unprotected remote-access path, this is one of the highest-value lines in the whole article.

> [!TIP]
> The word that recurs across Article 21 is **proportionate**. NIS2 does not demand identical controls of a nuclear operator and a snack-food distributor. It demands measures proportionate to the risk, the entity's exposure, the state of the art, and cost weighed against potential impact. That is a risk-based standard — and it means you must be able to *justify* your choices against your actual risk. A structured, evidence-based assessment is what turns "we decided not to patch that PLC" from a liability into a defensible, documented decision.

## Article 23: incident reporting in practice

Where the old regime was vague, NIS2 is specific. Article 23 requires covered entities to report **significant incidents** to their national CSIRT or competent authority on a defined timeline that starts the moment you **become aware**. ([nis-2-directive.com, Article 23](https://www.nis-2-directive.com/NIS_2_Directive_Article_23.html))

| Stage | Deadline | What it must contain |
| --- | --- | --- |
| **Early warning** | Within **24 hours** of becoming aware | Whether the incident is suspected to be unlawful/malicious and whether it could have cross-border impact |
| **Incident notification** | Within **72 hours** of becoming aware | Update to the early warning; initial assessment of severity and impact; indicators of compromise where available |
| **Intermediate report** | On request | Status update at the authority's request |
| **Final report** | Within **1 month** of the notification | Detailed description, root-cause analysis, mitigations applied, and any cross-border impact |
| **Progress report** | If still ongoing at the 1-month mark | Progress report now, final report within one month of resolving the incident |

An incident is **significant** if it has caused or is capable of causing **severe operational disruption of the service or financial loss**, or has affected or is capable of affecting **other persons through considerable material or non-material damage**. ([Legiscope, 24h/72h framework](https://www.legiscope.com/blog/nis2-incident-reporting.html)) For an OT operator, a disruption to a physical process — a tripped safety system, a halted production line, a contaminated water supply — clears that bar with room to spare.

```timeline
T + 24 hours :: **Early warning** — is it suspected malicious? Could it cross borders?
T + 72 hours :: **Incident notification** — severity, impact, indicators of compromise
On request :: **Intermediate report** — status update when the authority asks
T + 1 month :: **Final report** — root cause, mitigations, cross-border impact
While ongoing :: **Progress report** at one month, then a final report within a month of resolution
```

The reason this rhythm bites in OT is that the clock starts at *awareness*, not at *resolution* — and awareness in an OT environment often arrives through operations, not the SOC. A 24-hour early-warning obligation presumes a detection-and-escalation path that reaches a decision-maker inside a day, on nights and weekends, for events that may first show up as a process anomaly rather than a security alert. Building that path is as much an organisational design problem as a technical one.

There is a reciprocal obligation worth knowing: the CSIRT or competent authority must respond to the early warning **without undue delay and where possible within 24 hours**, including initial feedback and, on request, operational advice. The report is not shouting into a void.

```svg
<svg viewBox="0 0 700 240" xmlns="http://www.w3.org/2000/svg" font-family="Segoe UI, Helvetica, Arial, sans-serif">
  <rect x="0" y="0" width="700" height="240" fill="none"/>
  <!-- baseline -->
  <line x1="40" y1="120" x2="660" y2="120" stroke="#94a3b8" stroke-width="2"/>
  <polygon points="668,120 656,114 656,126" fill="#94a3b8"/>
  <!-- T0 -->
  <circle cx="70" cy="120" r="7" fill="#f97316"/>
  <text x="70" y="150" text-anchor="middle" fill="#e5e7eb" font-size="12" font-weight="700">Become aware</text>
  <text x="70" y="167" text-anchor="middle" fill="#94a3b8" font-size="10">clock starts</text>
  <!-- 24h -->
  <circle cx="230" cy="120" r="7" fill="#3b82f6"/>
  <line x1="230" y1="120" x2="230" y2="60" stroke="#3b82f6" stroke-width="1.2" stroke-dasharray="3 3"/>
  <rect x="150" y="30" width="160" height="34" rx="6" fill="#3b82f6" fill-opacity="0.15" stroke="#3b82f6" stroke-width="1.2"/>
  <text x="230" y="48" text-anchor="middle" fill="#e5e7eb" font-size="12" font-weight="700">24h — Early warning</text>
  <text x="230" y="60" text-anchor="middle" fill="#94a3b8" font-size="9.5">malicious? cross-border?</text>
  <!-- 72h -->
  <circle cx="400" cy="120" r="7" fill="#3b82f6"/>
  <line x1="400" y1="120" x2="400" y2="60" stroke="#3b82f6" stroke-width="1.2" stroke-dasharray="3 3"/>
  <rect x="320" y="30" width="160" height="34" rx="6" fill="#3b82f6" fill-opacity="0.15" stroke="#3b82f6" stroke-width="1.2"/>
  <text x="400" y="48" text-anchor="middle" fill="#e5e7eb" font-size="12" font-weight="700">72h — Notification</text>
  <text x="400" y="60" text-anchor="middle" fill="#94a3b8" font-size="9.5">severity, impact, IoCs</text>
  <!-- 1 month -->
  <circle cx="600" cy="120" r="7" fill="#f97316"/>
  <line x1="600" y1="120" x2="600" y2="176" stroke="#f97316" stroke-width="1.2" stroke-dasharray="3 3"/>
  <rect x="510" y="176" width="180" height="40" rx="6" fill="#f97316" fill-opacity="0.15" stroke="#f97316" stroke-width="1.2"/>
  <text x="600" y="194" text-anchor="middle" fill="#e5e7eb" font-size="12" font-weight="700">1 month — Final report</text>
  <text x="600" y="208" text-anchor="middle" fill="#94a3b8" font-size="9.5">root cause · mitigations</text>
  <!-- on request marker -->
  <text x="500" y="150" text-anchor="middle" fill="#94a3b8" font-size="10" font-style="italic">intermediate report on request</text>
</svg>
```

The 24-hour clock is unforgiving, and it starts when you *become aware* — not when you finish investigating. That places a premium on two things: **detection**, because an organisation that cannot see an incident cannot report it; and a **rehearsed reporting process**, because a team that has never practised the report will not produce a coherent one under pressure at three in the morning. Build the templates, name the decision-makers, and run the drill before you need it.

## Governance: management is on the hook

Article 20 is the cultural pivot of NIS2. Management bodies of covered entities must **approve** the risk-management measures, **oversee** their implementation, and can be **held liable** for infringements. Members of management must also **follow training** to gain sufficient knowledge to identify risks and assess management practices, and are expected to offer similar training to staff. ([ISMS.online, Article 34](https://www.isms.online/nis-2/articles/34-administrative-fines-for-non-compliance/))

In plain terms: cybersecurity is no longer something a board can delegate downward and forget. Directors are accountable for it. In serious, repeated cases and for essential entities, several Member States provide for **temporary bans from management functions** for the individuals responsible. This is deliberate. The EU concluded that security investment follows accountability — and that the surest way to sustain investment in unglamorous OT security is to make the people who control the budget answerable for the outcome.

### What a board actually has to do

Approval and oversight are not a signature on a slide. To discharge the Article 20 duty credibly, a management body needs:

- A **decision-ready view of operational risk** — not a stack of technical reports, but a picture clear enough to approve measures knowingly.
- Evidence that measures are **implemented and effective**, refreshed on a cadence, so oversight is continuous rather than annual.
- A **named accountable executive** and a reporting line that surfaces material OT risk to the board without translation loss.
- **Documented training** for board members, and a record of the risk decisions the board has ratified — because when a regulator or a court asks "did the board know?", the answer lives in the minutes.

## Supervision and enforcement

The two tiers diverge here. **Essential entities** face proactive, *ex ante* supervision: authorities can conduct audits, inspections, security scans and targeted requests for information without first needing evidence of a problem. **Important entities** face *ex post* supervision: authorities act when there is evidence or indication of non-compliance. ([nis-2-directive.com, Article 34](https://www.nis-2-directive.com/NIS_2_Directive_Article_34.html))

Authorities' powers escalate. They can issue **warnings**, give **binding instructions**, order an entity to **remedy deficiencies** or to **cease conduct**, require notification of affected parties, and — for essential entities in serious cases — appoint a **monitoring officer** or seek **temporary suspension of certifications or management functions**. Fines under Article 34 sit **on top of** these measures, not instead of them. Entities retain due-process rights: a hearing, the chance to present mitigating evidence, and a route of appeal.

## Penalties

Article 34 sets the ceilings for administrative fines. ([nis-2-directive.com, Article 34](https://www.nis-2-directive.com/NIS_2_Directive_Article_34.html))

| Entity type | Fine ceiling | Structure |
| --- | --- | --- |
| **Essential entities** | Maximum of at least **€10,000,000 or 2%** of total worldwide annual turnover | Whichever is **higher** |
| **Important entities** | Maximum of at least **€7,000,000 or 1.4%** of total worldwide annual turnover | Whichever is **higher** |

These are ceilings, not tariffs. Actual fines must be **effective, proportionate and dissuasive**, judged against the nature, gravity and duration of the breach, the degree of culpability, and whether the entity cooperated. But the turnover-linked structure — familiar from the GDPR — signals intent. Non-compliance is meant to be a board-level financial risk, not a rounding error.

Work the maths for a mid-sized group turning over €800 million: 2% is €16 million, comfortably above the €10 million floor, so the higher figure governs. For a €4 billion enterprise, 2% is €80 million. The percentage bites precisely where the fixed cap would otherwise be trivial — which is the point.

But the fines are only half of the enforcement story, and arguably not the half that changes behaviour. NIS2 makes **management bodies personally accountable** for approving and overseeing cybersecurity risk-management measures, and it gives authorities powers that reach past the balance sheet to the individuals in charge.

```keyfacts
Essential entities :: up to €10M or 2% of global turnover (higher applies)
Important entities :: up to €7M or 1.4% of global turnover (higher applies)
Management duty :: approve & oversee measures; personal accountability (Art. 20)
Training duty :: management must follow — and offer staff — cyber-risk training
Authority powers :: audits, binding instructions, and temporary suspension of a manager
Basis :: turnover-linked, GDPR-style — a board-level risk, not a line item
```

The sharpest instrument is **Article 32(5)**: for essential entities, supervisory authorities may **temporarily suspend a certification or authorisation**, and **temporarily prohibit any person discharging managerial responsibilities at CEO or legal-representative level from exercising those functions**, until the entity remedies the failure. A regulator that can bar a CEO from running the company concentrates minds in a way a fine rarely does — and it is exactly why NIS2 compliance is now a board agenda item, not a task delegated into the security team and forgotten. The Dutch Cbw carries these accountability provisions through into national law.

```cta
€10 million or 2% of turnover — and personal liability for your board.
NIS2 penalties land on the organisation and its leadership alike. We translate the ten measures into a defensible, board-ready OT security programme.
Check my NIS2 exposure :: /en/contact
```

## Where the law meets the plant

NIS2 never uses the words "PLC" or "SCADA," but its all-hazards, risk-based demands land squarely on OT. Three tensions are worth naming honestly.

### The IT/OT priority inversion

In IT, the security triad reads confidentiality, integrity, availability — protect the data first. In OT it inverts: **safety, then availability, then integrity, then confidentiality.** A control that is routine in IT — force a patch, drop a connection, reboot a server — can be unacceptable next to a running process, where the first duty is that nobody gets hurt and the second is that the plant keeps running.

```svg
<svg viewBox="0 0 700 170" xmlns="http://www.w3.org/2000/svg" font-family="Segoe UI, Helvetica, Arial, sans-serif">
  <rect x="0" y="0" width="700" height="170" fill="none"/>
  <text x="30" y="30" fill="#94a3b8" font-size="13" font-weight="700">IT priority</text>
  <rect x="150" y="14" width="120" height="30" rx="6" fill="#3b82f6" fill-opacity="0.15" stroke="#3b82f6"/>
  <text x="210" y="34" text-anchor="middle" fill="#e5e7eb" font-size="12">Confidentiality</text>
  <rect x="290" y="14" width="120" height="30" rx="6" fill="#3b82f6" fill-opacity="0.12" stroke="#3b82f6"/>
  <text x="350" y="34" text-anchor="middle" fill="#e5e7eb" font-size="12">Integrity</text>
  <rect x="430" y="14" width="120" height="30" rx="6" fill="#3b82f6" fill-opacity="0.10" stroke="#3b82f6"/>
  <text x="490" y="34" text-anchor="middle" fill="#e5e7eb" font-size="12">Availability</text>
  <text x="620" y="34" fill="#94a3b8" font-size="11">highest → lowest</text>
  <line x1="30" y1="70" x2="670" y2="70" stroke="#94a3b8" stroke-width="0.75" stroke-dasharray="4 4"/>
  <text x="30" y="110" fill="#f97316" font-size="13" font-weight="700">OT priority</text>
  <rect x="110" y="94" width="100" height="30" rx="6" fill="#f97316" fill-opacity="0.20" stroke="#f97316"/>
  <text x="160" y="114" text-anchor="middle" fill="#e5e7eb" font-size="12">Safety</text>
  <rect x="222" y="94" width="110" height="30" rx="6" fill="#f97316" fill-opacity="0.16" stroke="#f97316"/>
  <text x="277" y="114" text-anchor="middle" fill="#e5e7eb" font-size="12">Availability</text>
  <rect x="344" y="94" width="100" height="30" rx="6" fill="#f97316" fill-opacity="0.12" stroke="#f97316"/>
  <text x="394" y="114" text-anchor="middle" fill="#e5e7eb" font-size="12">Integrity</text>
  <rect x="456" y="94" width="130" height="30" rx="6" fill="#f97316" fill-opacity="0.08" stroke="#f97316"/>
  <text x="521" y="114" text-anchor="middle" fill="#e5e7eb" font-size="12">Confidentiality</text>
  <text x="620" y="114" fill="#94a3b8" font-size="11">highest → lowest</text>
  <text x="350" y="152" text-anchor="middle" fill="#94a3b8" font-size="11" font-style="italic">NIS2's proportionality principle accommodates the inversion — if you can articulate it</text>
</svg>
```

NIS2's proportionality principle accommodates this inversion, but only if you can *articulate* the operational constraints and the compensating controls you use instead. "We can't patch during a campaign, so we do X, Y and Z" is a defensible position. Silence is not.

### You cannot manage what you cannot see

The first Article 21 measure is risk analysis, and risk analysis presumes an asset inventory. In practice, the single most common gap OXOT finds is that operators lack a current, structured view of their OT estate — which devices exist, how they connect, which are exposed, and which protect a safety function. Under NIS2, that gap is no longer just operational debt; it is a compliance exposure, because you cannot demonstrate proportionate measures over an estate you cannot describe.

### IEC 62443 is the engineering answer

NIS2 tells you *what* outcomes to achieve; it does not prescribe *how*. The [IEC 62443](/en/iec-62443) series — the international standard for industrial automation and control system security — provides the how: **zones and conduits, security levels, and a lifecycle** for building and operating secure control systems. For the rail and infrastructure world, [TS 50701](/en/ts-50701) extends the same thinking. Aligning your NIS2 response to IEC 62443 gives you a defensible, internationally recognised method for showing that your measures are appropriate and proportionate. The two are complementary: **NIS2 is the legal obligation; IEC 62443 is the engineering answer.**

### How the ten measures map to IEC 62443

| Article 21 measure | Where IEC 62443 answers it |
| --- | --- |
| Risk analysis & policies | 62443-3-2 risk assessment; 62443-2-1 security programme |
| Incident handling | 62443-2-1 and 62443-3-3 detection/response requirements (FR 6) |
| Business continuity & recovery | 62443-2-1 continuity; 62443-3-3 resource availability (FR 7) |
| Supply chain security | 62443-2-4 service-provider requirements; 62443-4-1 secure development |
| Acquisition, dev & maintenance | 62443-4-1 secure product lifecycle; 62443-4-2 component requirements |
| Effectiveness assessment | 62443-2-1 audit and metrics; conduct security verification |
| Cyber hygiene & training | 62443-2-1 policies; 62443-2-4 competence |
| Cryptography | 62443-3-3 data confidentiality (FR 4) and integrity (FR 3) |
| Access control & asset mgmt | 62443-3-3 identification/authentication (FR 1) and use control (FR 2) |
| MFA & secured comms | 62443-3-3 FR 1/FR 2; zone-and-conduit restricted data flow (FR 5) |

For related and adjacent obligations — the [CRA](/en/cra), the [AI Act](/en/ai-act), the [Machinery Regulation](/en/machine-act) — see our overview of [frameworks](/en/frameworks) and how they stack.

## Sector-by-sector notes

The obligations are common, but the pressure points differ. A few sector-specific realities OXOT sees repeatedly:

- **Energy and utilities.** Substation automation, DER aggregation and remote SCADA make availability the paramount concern. Legacy protocols and long asset lifecycles collide with the patch-and-hygiene expectations of Article 21. Vendor remote access is pervasive and under-governed.
- **Drinking water and wastewater.** Often lean on staff, wide geography, thousands of remote sites. A significant incident here can mean a public-health event, so the Article 23 "considerable damage" test is easily met. Asset visibility across dispersed telemetry is the hard part.
- **Chemicals and process industries.** Safety-instrumented systems and functional-safety regimes dominate. Cybersecurity has to be reconciled with process safety, not bolted alongside it — a natural fit for IEC 62443's risk-based zones.
- **Manufacturing (Annex II).** Flat networks, converged IT/OT, and machinery arriving with its own [CRA](/en/cra) and [Machinery Regulation](/en/machine-act) obligations. The scoping surprise is real: many manufacturers only recently learned they are important entities.
- **Food production and distribution.** Cold-chain integrity, high-throughput lines and thin margins make downtime expensive and safety-relevant. Recovery testing of line controls is frequently the neglected control.

## A practical roadmap

There is no shortcut, but there is a sensible order. Run it as a programme with phases, not a one-off project.

| Phase | Focus | Key outputs |
| --- | --- | --- |
| **0. Confirm status** | Are you essential or important under your national law? | Scoping determination; registration where required |
| **1. See the estate** | Build the asset & risk picture | Structured OT inventory; connectivity map; exposure and safety-criticality flags |
| **2. Assess vs Art. 21** | Map current state to the ten measures | Gap analysis prioritised by operational risk, not raw CVSS |
| **3. Reporting muscle** | Stand up and rehearse Art. 23 | Templates, decision rights, a tested 24/72h/1-month drill |
| **4. Remediate in waves** | Close gaps, IEC 62443-aligned | Prioritised, proportionate, operationally realistic control roll-out |
| **5. Prove & sustain** | Demonstrate and maintain effectiveness | Test/audit cadence; living evidence base; board reporting |

> [!NOTE]
> Several Member States impose **registration duties** with their own deadlines, separate from the substantive obligations. Confirming status (Phase 0) is not busywork — miss a registration window and you may be non-compliant before you have touched a single technical control.

## What it means for your role

**If you are a CISO or security lead,** NIS2 extends your mandate across the IT/OT boundary and demands evidence, not assertion. You will be asked to show your risk picture, your measures and their effectiveness — for environments you may not fully control and whose owners speak a different language. Your leverage is a shared, structured view of OT risk that engineering trusts and the board can read.

**If you are a plant or operations manager,** security decisions now have to be reconciled with production and safety reality, and you are a stakeholder in — not a spectator to — the risk assessment. The upside: a genuinely risk-based approach protects you from disproportionate, disruptive controls being imposed top-down by people who have never stood on your floor.

**If you sit on the board or in executive management,** NIS2 makes cybersecurity a named governance duty with personal exposure. You need enough visibility to approve measures knowingly and to oversee them — which means insisting on a clear, decision-ready view of operational risk, documented training, and a record of what you ratified and when.

**If you are in compliance or legal,** NIS2 introduces hard deadlines and turnover-linked penalties. You need the reporting process rehearsed and the evidence base maintained, because the difference between a defensible position and a fine is often documentation you either kept or did not.

## How OXOT helps

OXOT was built for exactly this: turning fragmented OT security findings into clear, defensible decisions. Our **OT Security Assessments** establish the asset and risk picture NIS2 assumes you already have. Our [Cyber Digital Twin](/en/cyber-digital-twin) unifies documentation, network data, asset inventories and tool output into one structured model, so you can prioritise Article 21 gaps by real operational risk and show your reasoning to an auditor, a board or a regulator. Our **OT Security Programmes** deliver remediation in proportionate, [IEC 62443](/en/iec-62443)-aligned waves, and our **Capability Transfer** work makes sure the knowledge stays with your team after we leave.

We are OT-first, risk-based, and built on the premise of European digital sovereignty — your data and your model stay yours. NIS2 rewards organisations that can demonstrate they understand and manage their risk deliberately. That is the whole point of how we work.

## Frequently asked questions

**Does NIS2 apply directly, or through national law?**
Through national law. NIS2 is a directive, transposed by each Member State. Always check your national statute — several countries set stricter or broader requirements than the directive's baseline. In the Netherlands the relevant law is the Cyberbeveiligingswet.

**We missed the 17 October 2024 deadline — what now?**
That deadline was for *Member States* to legislate, not a grace period for entities. The obligations apply once your national law is in force. Prioritise confirming status, standing up the reporting process, and building the risk picture, then remediate in prioritised waves. Where your Member State's law is late, use the time to be ready rather than to wait.

**How do I know if I'm essential or important?**
Check your sector against Annex I (essential-leaning, high-criticality) and Annex II (important), then apply the size rule — generally 50+ employees or €10m+ turnover — and watch for the size-independent exceptions (DNS, TLD registries, trust services, public electronic comms). Then confirm against your national transposition, which is the binding text.

**Is a firewall between IT and OT enough?**
No. Segmentation matters, but Article 21 spans governance, supply chain, access control, incident handling, continuity, cryptography and more. A single control cannot satisfy a risk-management obligation, and a regulator assessing proportionality will look at the whole programme.

**What counts as a "significant" incident I have to report?**
One that has caused or could cause severe operational disruption or financial loss, or considerable material or non-material damage to others. In OT, most events that disrupt a physical process — safety trips, line stoppages, contamination — will qualify. When in doubt, report; the 24-hour early warning is deliberately low-friction.

**How does NIS2 relate to the CRA and IEC 62443?**
NIS2 obliges *operators* to manage the risk of the systems they run. The [Cyber Resilience Act](/en/cra) obliges *manufacturers* to build security into products with digital elements. [IEC 62443](/en/iec-62443) gives operators and vendors the engineering method to do both. They reinforce one another rather than compete.

**Can board members really be held personally liable?**
Yes. Article 20 requires management to approve and oversee the measures and allows them to be held liable for failures. Several Member States provide, for essential entities, for temporary bans on holding management functions in serious, repeated cases. Documented oversight and training are your protection.

## Sources

- Directive (EU) 2022/2555 (NIS2), full text — [EUR-Lex, CELEX 32022L2555](https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022L2555)
- Article 3, essential and important entities — [nis-2-directive.com](https://www.nis-2-directive.com/NIS_2_Directive_Article_3.html)
- Article 21, cybersecurity risk-management measures — [nis-2-directive.com](https://www.nis-2-directive.com/NIS_2_Directive_Article_21.html) · [nis2-info.eu](https://www.nis2-info.eu/article-21-cybersecurity-risk-management-measures/)
- Article 23, reporting obligations & 24/72h/1-month timeline — [nis-2-directive.com](https://www.nis-2-directive.com/NIS_2_Directive_Article_23.html) · [Legiscope](https://www.legiscope.com/blog/nis2-incident-reporting.html)
- Article 34, administrative fines — [nis-2-directive.com](https://www.nis-2-directive.com/NIS_2_Directive_Article_34.html) · [ISMS.online](https://www.isms.online/nis-2/articles/34-administrative-fines-for-non-compliance/)
- Essential vs important entities, scope and size rule — [Glocert](https://www.glocertinternational.com/resources/guides/nis2-applicability-essential-vs-important-entities/) · [Legiscope](https://www.legiscope.com/blog/nis2-essential-important-entities.html)
- Transposition status and Commission enforcement — [European Commission](https://digital-strategy.ec.europa.eu/en/policies/nis-transposition) · [ECSO tracker](https://ecs-org.eu/activities/nis2-directive-transposition-tracker/)
- Netherlands Cyberbeveiligingswet (Cbw) implementing NIS2 — [Bird & Bird](https://www.twobirds.com/en/insights/2026/netherlands/dutch-parliament-approves-cybersecurity-act-implementing-nis2)

*This page is general information about EU law, not legal advice. Confirm how NIS2 applies to your organisation against your national transposition law and, where needed, qualified legal counsel.*$MDBODY$, true, $MDBODY$NIS2 Directive for OT & Industry | OXOT$MDBODY$, $MDBODY$What NIS2 (Directive (EU) 2022/2555) means for industrial and OT operators — scope, the ten Article 21 measures, 24/72-hour reporting, management liability, penalties, IEC 62443 alignment, and a practical roadmap.$MDBODY$, $MDBODY$An OT-first field guide to NIS2 — who is in scope, the ten Article 21 measures decoded for plants, the 24/72-hour/one-month reporting drumbeat, board liability, penalties, and a phased plan you can actually run.$MDBODY$, NULL, $MDBODY$page$MDBODY$, now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET
  title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published,
  meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description,
  excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type,
  published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now()
WHERE length(pages.body) < length(EXCLUDED.body);

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ($MDBODY$nis2$MDBODY$, $MDBODY$nl$MDBODY$, $MDBODY$NIS2 voor Operationele Technologie$MDBODY$, $MDBODY$NIS2 is de tweede richtlijn van de Europese Unie inzake netwerk- en informatiebeveiliging, en het is de meest ingrijpende cybersecuritywetgeving waarmee de meeste industriële operators in Europa ooit te maken hebben gehad. De richtlijn vervangt de oorspronkelijke NIS-richtlijn uit 2016, verbreedt de kring van organisaties die eronder vallen aanzienlijk, legt meldtermijnen wettelijk vast en maakt — voor het eerst — de hoogste leiding persoonlijk verantwoordelijk voor een goede cybersecurity.

Voor de exploitant van een onderstation, een gemaal, een chemische fabriek of een productiehal is NIS2 geen IT-vraagstuk dat binnen de serverruimte blijft. De richtlijn raakt rechtstreeks aan de Operationele Technologie (OT) die de productie draaiende houdt en mensen veilig. Een geactiveerd veiligheidsinstrumentatiesysteem, een stilgelegde bottelarij, een gemanipuleerd setpoint op een chloordoseerpomp — dit zijn de gebeurtenissen waar de richtlijn om geeft, en die spelen zich af in de wereld van PLC's, RTU's, aandrijvingen en historians, niet e-mailservers. Deze pagina legt uit wat de wet daadwerkelijk vereist, waar deze het hardst doorwerkt in OT-omgevingen, en hoe een realistische reactie eruitziet.

## De korte versie

- NIS2 is **Richtlijn (EU) 2022/2555**, aangenomen op 14 december 2022 en van kracht sinds 16 januari 2023. Lidstaten moesten deze uiterlijk **17 oktober 2024** omzetten in nationale wetgeving. ([EUR-Lex, CELEX 32022L2555](https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022L2555))
- De richtlijn bestrijkt veel meer sectoren en organisaties dan de oude NIS-richtlijn, onderverdeeld in **essentiële** en **belangrijke** entiteiten in **18 sectoren** (11 in Bijlage I, 7 in Bijlage II).
- **Artikel 21** stelt een **minimale basis van tien risicobeheersmaatregelen** vast, gebaseerd op een **allgevarenbenadering** die ook fysieke en omgevingsdreigingen omvat — niet alleen cyberaanvallen.
- **Artikel 23** legt een strikt meldritme op voor incidenten: een **vroegtijdige waarschuwing binnen 24 uur**, een **melding binnen 72 uur**, en een **eindverslag binnen één maand**.
- **Artikel 20** verplicht bestuursorganen om de maatregelen **goed te keuren en toe te zien** op de uitvoering ervan, verplicht hen om **training te volgen**, en maakt het mogelijk dat zij **aansprakelijk worden gesteld** bij tekortkomingen.
- **Artikel 34** stelt boetes vast van **ten minste €10 miljoen of 2% van de wereldwijde jaaromzet** voor essentiële entiteiten, en **ten minste €7 miljoen of 1,4%** voor belangrijke entiteiten — welk bedrag ook hoger is.

Als u één ding meeneemt: NIS2 is een governance- en risicobeheerwet, geen boodschappenlijst van producten. De richtlijn beloont organisaties die kunnen *aantonen* dat zij hun risico begrijpen en het doelbewust beheren — en dat is precies waar OT-beveiliging zo vaak tekortschiet.

> [!IMPORTANT]
> NIS2 is een richtlijn, geen verordening. Zij is niet rechtstreeks van toepassing op uw organisatie — zij werkt door via de nationale omzettingswet van uw lidstaat. Controleer altijd de nationale wet, want verschillende landen zijn verder gegaan dan de ondergrens van de richtlijn. In Nederland is dat de **Cyberbeveiligingswet (Cbw)**.

## Waarom NIS2 bestaat

De NIS-richtlijn uit 2016 was de eerste poging van de EU om de cybersecuritybasis voor kritieke diensten te verhogen. Dat werkte ongelijkmatig. Lidstaten interpreteerden "aanbieders van essentiële diensten" verschillend, de handhaving was inconsistent, en hele categorieën die duidelijk van belang waren — afvalwater, voedselproductie, industriële productie, openbaar bestuur — vielen buiten de reikwijdte. Twee organisaties die dezelfde essentiële dienst leverden in twee landen konden voor totaal verschillende verplichtingen komen te staan, of voor helemaal geen.

Ondertussen veranderde het dreigingslandschap. Ransomwaregroepen ontdekten dat het stilleggen van productie winstgevender is dan het stelen van gegevens, omdat een fabriek die miljoenen per dag verliest snel betaalt. Statelijke actoren toonden herhaaldelijk aan dat industriële besturingssystemen levensvatbare doelwitten zijn — van de wiper-aanvallen op de Oekraïense elektriciteitsdistributie tot de verkenningsactiviteiten bij Europese nutsbedrijven zonder ooit daadwerkelijk toe te slaan. Compromittering van de toeleveringsketen liet zien dat vertrouwde software-updates en kanalen voor beheer op afstand net zo gevaarlijk zijn als elke frontale exploit.

NIS2 is de correctie. De richtlijn harmoniseert de regels, verbreedt de reikwijdte aanzienlijk, legt meldtermijnen wettelijk vast, en legt de verantwoordelijkheid daar waar besluiten daadwerkelijk worden genomen — bij de hoogste leiding. De overwegingen bij de richtlijn zijn er open over dat het vorige regime hiaten liet bestaan en dat de blootstelling van essentiële en belangrijke entiteiten sneller was gegroeid dan de wetgeving die daarop toezag.

## Wie valt onder de reikwijdte

NIS2 verdeelt de betrokken organisaties in twee categorieën. Beide moeten voldoen aan dezelfde kernbeveiligingsverplichtingen onder Artikel 21 en dezelfde meldplichten onder Artikel 23; het verschil zit in de striktheid van het toezicht en de wijze van sanctionering. ([nis-2-directive.com, Artikel 3](https://www.nis-2-directive.com/NIS_2_Directive_Article_3.html))

### De twee categorieën in één oogopslag

| Categorie | Sectoren | Toezicht | Bovengrens boete |
| --- | --- | --- | --- |
| **Essentiële entiteiten** | Hoogkritieke sectoren uit Bijlage I, op schaal | Proactief, *ex ante* — audits en inspecties zonder dat bewijs van een probleem nodig is | Ten minste **€10 miljoen of 2%** van de wereldwijde jaaromzet, welk bedrag ook hoger is |
| **Belangrijke entiteiten** | Overige kritieke sectoren uit Bijlage II | Reactief, *ex post* — actie op basis van bewijs of aanwijzing van niet-naleving | Ten minste **€7 miljoen of 1,4%** van de wereldwijde jaaromzet, welk bedrag ook hoger is |

### Bijlage I — de 11 zeer kritieke sectoren

De essentiële categorie komt grotendeels uit Bijlage I: **energie** (elektriciteit, olie, gas, stadsverwarming en -koeling, waterstof), **transport** (lucht, spoor, water, weg), **bankwezen**, **infrastructuren voor de financiële markt**, **gezondheidszorg**, **drinkwater**, **afvalwater**, **digitale infrastructuur**, **beheer van ICT-diensten** (business-to-business), **openbaar bestuur**, en **ruimtevaart**. ([Glocert, essentieel versus belangrijk](https://www.glocertinternational.com/resources/guides/nis2-applicability-essential-vs-important-entities/))

### Bijlage II — de 7 overige kritieke sectoren

Bijlage II voegt de sectoren voor de belangrijke categorie toe: **post- en koeriersdiensten**, **afvalbeheer**, **vervaardiging, productie en distributie van chemische stoffen**, **productie en distributie van levensmiddelen**, **industriële productie** (medische hulpmiddelen, computers en elektronica, machines en apparatuur, motorvoertuigen, overige transportmiddelen), **aanbieders van digitale diensten** (onlinemarktplaatsen, zoekmachines, sociale platforms), en **onderzoeksorganisaties**.

### De omvangsregel — en de uitzonderingen erop

Als algemene regel is NIS2 van toepassing op organisaties die **middelgroot of groter** zijn binnen een sector die onder de reikwijdte valt — in grote lijnen, **50 of meer werknemers, of een jaaromzet/balanstotaal boven €10 miljoen**. Een entiteit die bovendien **250 werknemers of €50 miljoen omzet** overschrijdt, is een grote onderneming en is in een hoogkritieke sector doorgaans een essentiële entiteit. ([Legiscope, essentieel versus belangrijk](https://www.legiscope.com/blog/nis2-essential-important-entities.html))

Er zijn belangrijke uitzonderingen. Bepaalde aanbieders vallen **ongeacht hun omvang** onder de reikwijdte — waaronder **aanbieders van DNS-diensten, registers voor topleveldomeinnamen, vertrouwensdiensten, en aanbieders van openbare elektronische-communicatienetwerken of -diensten**. Lidstaten kunnen ook specifieke kleinere entiteiten aanwijzen als zij bijvoorbeeld de enige aanbieder van een kritieke dienst in een regio zijn, of wanneer verstoring aanzienlijke gevolgen zou hebben.

> [!WARNING]
> Het praktische gevolg voor de industrie is scherp. Een middelgrote fabrikant, een regionaal waterbedrijf, een voedselproducent of een chemicaliëndistributeur die zichzelf nooit als "vitale infrastructuur" beschouwde, valt nu zeer waarschijnlijk onder de reikwijdte — en velen merkten dit niet toen de omzettingstermijn verstreek. Niet weten dat u onder de reikwijdte valt, is geen verweer.

### Waar de omzetting daadwerkelijk staat

Lidstaten moesten uiterlijk 17 oktober 2024 nationale wetgeving van kracht hebben. De meeste haalden dat niet. Op **7 mei 2025 heeft de Europese Commissie met redenen omklede adviezen uitgebracht aan 19 lidstaten** wegens het niet melden van volledige omzetting — een formele stap voorafgaand aan verwijzing naar het Hof van Justitie. ([Europese Commissie, NIS-omzetting](https://digital-strategy.ec.europa.eu/en/policies/nis-transposition)) Vanaf 2026 heeft de meerderheid omzettingswetgeving aangenomen, terwijl verschillende landen — waaronder **Frankrijk, Ierland, Luxemburg, Nederland en Spanje** — het proces later afrondden dan de termijn. ([ECSO-omzettingstracker](https://ecs-org.eu/activities/nis2-directive-transposition-tracker/))

In **Nederland** implementeert de **Cyberbeveiligingswet (Cbw)** NIS2. De **Tweede Kamer keurde het wetsvoorstel goed op 15 april 2026**, waarbij formele vaststelling later in 2026 wordt beoogd na behandeling in de Eerste Kamer. ([Bird & Bird, Nederlandse Cyberbeveiligingswet](https://www.twobirds.com/en/insights/2026/netherlands/dutch-parliament-approves-cybersecurity-act-implementing-nis2)) De vertraging verandert niets aan de inhoud waarop operators zich moeten voorbereiden — en zij schort de verplichting om gereed te zijn niet op.

## Essentiële versus belangrijke entiteiten — de splitsing die uw regime bepaalt

De tweedeling die u zojuist in de tabel zag, bepaalt méér dan alleen het boeteplafond: zij bepaalt hoe de wet u benadert. Beide categorieën dragen dezelfde kern van beveiligingsmaatregelen (Artikel 21) en dezelfde meldplichten (Artikel 23). Wat verschilt, is de **handhavingshouding** — en dat verschil is in de praktijk vaak ingrijpender dan het cijfer op de boete. Uw categorie volgt uit sector *én* omvang: grote ondernemingen in de meest kritieke sectoren zijn in de regel **essentieel**; middelgrote organisaties en die in "andere kritieke" sectoren zijn **belangrijk**.

```compare
Essentiële entiteiten
- Meest kritieke sectoren (Bijlage I): energie, transport, bankwezen, financiëlemarktinfrastructuur, gezondheidszorg, drink- & afvalwater, digitale infrastructuur, ICT-servicebeheer, openbaar bestuur, ruimtevaart
- **Proactief (ex ante) toezicht** — toezichthouders mogen auditen, inspecteren en bewijs opvragen zónder een incident of aanwijzing af te wachten
- Bestuurlijke boetes tot **€10 miljoen of 2% van de wereldwijde jaaromzet**, het hoogste bedrag geldt
---
Belangrijke entiteiten
- Andere kritieke sectoren (Bijlage II): post & koeriers, afvalbeheer, chemie, voeding, maakindustrie (medische hulpmiddelen, machines, voertuigen), digitale aanbieders, onderzoek
- **Reactief (ex post) toezicht** — controle volgt doorgaans pas op aanwijzingen van niet-naleving of een incident
- Bestuurlijke boetes tot **€7 miljoen of 1,4% van de wereldwijde jaaromzet**, het hoogste bedrag geldt
```

> [!IMPORTANT]
> De classificatie is geen zelfbeoordeling die u stilletjes naar beneden afrondt. NIS2 kent een **registratieplicht** — betrokken entiteiten moeten zich melden bij hun nationale autoriteit (in Nederland gecoördineerd binnen het NCSC/RDI-landschap onder de Cbw) — en de **"size-cap"-uitzondering** betekent dat een organisatie ónder de gebruikelijke omvangsdrempels tóch in scope kan vallen als zij de enige aanbieder van een kritieke dienst is of als verstoring een aanzienlijke maatschappelijke impact zou hebben. De categorie verkeerd inschatten — in welke richting dan ook — is zelf een governancefalen.

## Governance en reikwijdte, in één oogopslag

Onderstaand diagram volgt de keten die NIS2 opbouwt: van een verantwoordelijk bestuursorgaan, via de tien maatregelen, naar het toezicht en de handhaving die dit alles bewaken.

```svg
<svg viewBox="0 0 700 380" xmlns="http://www.w3.org/2000/svg" font-family="Segoe UI, Helvetica, Arial, sans-serif">
  <rect x="0" y="0" width="700" height="380" fill="none"/>
  <!-- Management body -->
  <rect x="200" y="20" width="300" height="56" rx="8" fill="#3b82f6" fill-opacity="0.15" stroke="#3b82f6" stroke-width="1.5"/>
  <text x="350" y="44" text-anchor="middle" fill="#e5e7eb" font-size="15" font-weight="700">Bestuursorgaan (Art. 20)</text>
  <text x="350" y="63" text-anchor="middle" fill="#94a3b8" font-size="11">Keurt goed &amp; ziet toe · getraind · aansprakelijk</text>
  <!-- arrow down -->
  <line x1="350" y1="76" x2="350" y2="104" stroke="#94a3b8" stroke-width="1.5"/>
  <polygon points="350,110 345,100 355,100" fill="#94a3b8"/>
  <!-- Measures -->
  <rect x="120" y="112" width="460" height="70" rx="8" fill="#94a3b8" fill-opacity="0.10" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="350" y="134" text-anchor="middle" fill="#e5e7eb" font-size="15" font-weight="700">Tien risicobeheersmaatregelen (Art. 21)</text>
  <text x="350" y="154" text-anchor="middle" fill="#94a3b8" font-size="11">Allgevaren · proportioneel · IT en OT binnen bereik</text>
  <text x="350" y="171" text-anchor="middle" fill="#94a3b8" font-size="11">Risicoanalyse · incidentbehandeling · continuïteit · keten · MFA · meer</text>
  <!-- two arrows down -->
  <line x1="230" y1="182" x2="230" y2="212" stroke="#94a3b8" stroke-width="1.5"/>
  <polygon points="230,218 225,208 235,208" fill="#94a3b8"/>
  <line x1="470" y1="182" x2="470" y2="212" stroke="#94a3b8" stroke-width="1.5"/>
  <polygon points="470,218 465,208 475,208" fill="#94a3b8"/>
  <!-- Reporting -->
  <rect x="60" y="220" width="340" height="64" rx="8" fill="#f97316" fill-opacity="0.13" stroke="#f97316" stroke-width="1.5"/>
  <text x="230" y="244" text-anchor="middle" fill="#e5e7eb" font-size="14" font-weight="700">Incidentmelding (Art. 23)</text>
  <text x="230" y="264" text-anchor="middle" fill="#94a3b8" font-size="11">24u waarschuwing → 72u melding → 1 mnd verslag</text>
  <text x="230" y="279" text-anchor="middle" fill="#94a3b8" font-size="11">aan nationaal CSIRT / bevoegde autoriteit</text>
  <!-- Supervision -->
  <rect x="360" y="220" width="280" height="64" rx="8" fill="#3b82f6" fill-opacity="0.10" stroke="#3b82f6" stroke-width="1.5"/>
  <text x="500" y="244" text-anchor="middle" fill="#e5e7eb" font-size="14" font-weight="700">Toezicht (Art. 32–33)</text>
  <text x="500" y="264" text-anchor="middle" fill="#94a3b8" font-size="11">Essentieel: ex ante · Belangrijk: ex post</text>
  <text x="500" y="279" text-anchor="middle" fill="#94a3b8" font-size="11">Audits · bevelen · toezichthouder</text>
  <!-- arrows to enforcement -->
  <line x1="230" y1="284" x2="330" y2="316" stroke="#94a3b8" stroke-width="1.5"/>
  <line x1="500" y1="284" x2="380" y2="316" stroke="#94a3b8" stroke-width="1.5"/>
  <!-- Enforcement -->
  <rect x="230" y="320" width="240" height="46" rx="8" fill="#f97316" fill-opacity="0.16" stroke="#f97316" stroke-width="1.5"/>
  <text x="350" y="343" text-anchor="middle" fill="#e5e7eb" font-size="14" font-weight="700">Handhaving &amp; boetes (Art. 34)</text>
  <text x="350" y="359" text-anchor="middle" fill="#94a3b8" font-size="11">Tot €10m / 2% of €7m / 1,4%</text>
</svg>
```

## Artikel 21: de tien maatregelen, vertaald naar OT

Artikel 21 vormt de kern van de richtlijn. Het vereist dat betrokken entiteiten "passende en evenredige technische, operationele en organisatorische maatregelen" nemen "om de risico's voor de beveiliging van netwerk- en informatiesystemen te beheersen." Het hanteert een **allgevarenbenadering** — de maatregelen moeten deze systemen en hun fysieke omgeving beschermen tegen incidenten, ongeacht of de oorzaak een hacker, een brand, een overstroming of een falende leverancier is. ([nis-2-directive.com, Artikel 21](https://www.nis-2-directive.com/NIS_2_Directive_Article_21.html))

Het artikel noemt tien maatregelen als minimum. Bekeken door een zuivere IT-bril lijkt elk maatregel bekend. Bekeken door een OT-bril draagt elk een gewicht dat gemakkelijk wordt onderschat. De tabel brengt ze in kaart; de secties daarna gaan dieper in.

| # | Maatregel Artikel 21(2) | Wat het betekent | Implicatie voor OT |
| --- | --- | --- | --- |
| 1 | Risicoanalyse en beveiligingsbeleid voor informatiesystemen | Een gedocumenteerd, actueel inzicht in risico's en het beleid dat dit stuurt | Begint met een asset-inventaris die de meeste fabrieken niet op verzoek kunnen produceren |
| 2 | Incidentbehandeling | Preventie, detectie, analyse, inperking, respons, herstel | U kunt vaak niet herstarten, patchen of isoleren zonder een live fysiek proces te raken |
| 3 | Bedrijfscontinuïteit, back-up, disaster recovery, crisisbeheer | Bedrijfsvoering behouden of herstellen na verstoring | Getest herstel van PLC/RTU-configuraties, engineeringwerkstations en historians — niet alleen servers |
| 4 | Beveiliging van de toeleveringsketen | Beveiliging van relaties met directe leveranciers en dienstverleners | Uw OEM's, integrators en onderhoudsleveranciers hebben toegang op afstand tot uw kroonjuwelen |
| 5 | Beveiliging bij verwerving, ontwikkeling en onderhoud; omgang met en openbaarmaking van kwetsbaarheden | Beveiliging inbouwen in hoe u systemen aanschaft en onderhoudt | Inkoopclausules en patchvensters voor besturingssystemen, geen achteraf toegevoegde oplossingen |
| 6 | Beleid om de effectiviteit van maatregelen te beoordelen | Aantonen dat de beheersmaatregelen daadwerkelijk werken | Testen en auditen met respect voor operationele beperkingen — geen verstorende scans op live cellen |
| 7 | Basale cyberhygiëne en beveiligingstraining | Patchen, configuratiebeheer, minimale rechten, bewustwording | Toegepast op engineers en operators, wier dagelijkse werk geen IT-beveiliging is |
| 8 | Cryptografie en, waar passend, versleuteling | Evenredig gebruik van cryptografie | Beschermt meestal toegang op afstand, gegevens in transit en back-ups — zelden realtime besturingsverkeer |
| 9 | HR-beveiliging, toegangsbeheer, assetbeheer | Wie wat mag aanraken, vanaf waar, met welke rechten | Gedeelde accounts, leverancierstoegang en contractanttoegang zijn de klassieke zwakke plekken |
| 10 | MFA / continue authenticatie; beveiligde & noodcommunicatie | Sterke authenticatie en gehardende communicatiekanalen | MFA op toegang op afstand en bevoorrechte OT-toegang is nu een verwachting, geen leuke extra |

### 1 — Risicoanalyse en beveiligingsbeleid

Alles wat volgt, rust hierop. U hebt een actueel, gedocumenteerd beeld nodig van uw risico en het beleid dat bepaalt hoe u dat beheert. In OT is dat beeld onmogelijk zonder een nauwkeurige **asset-inventaris** — en precies hier schieten de meeste operators tekort. Een fabriek die niet op verzoek kan opsommen welke controllers zij gebruikt, hoe deze verbonden zijn, welke bereikbaar zijn via internet en welke een veiligheidsfunctie beschermen, doet risicoanalyse op basis van giswerk. NIS2 verandert dat gat van een operationeel ongemak in een compliance-risico.

### 2 — Incidentbehandeling

Detectie, analyse, inperking, respons en herstel — de volledige levenscyclus. Het IT-draaiboek gaat ervan uit dat u een host kunt isoleren, een proces kunt beëindigen of kunt herstellen vanuit een image. Op een procesinstallatie kunnen die handelingen een veiligheidsfunctie activeren of een batch verloren laten gaan. OT-incidentbehandeling moet worden opgesteld met de procesengineer aan tafel, met vooraf overeengekomen beslissingsbevoegdheden over wie apparatuur offline mag halen en onder welke veiligheidscondities.

### 3 — Bedrijfscontinuïteit en crisisbeheer

Back-up, disaster recovery en het vermogen om de bedrijfsvoering te behouden of te herstellen. Voor OT betekent dit geteste, herstelbare kopieën van **PLC- en RTU-logica, HMI- en SCADA-projecten, images van engineeringwerkstations, aandrijfparameters en historiandata** — en een geoefend plan om een cel vanaf kale hardware weer op te bouwen. Back-ups die u nooit hebt hersteld, zijn een hypothese, geen beheersmaatregel.

### 4 — Beveiliging van de toeleveringsketen

NIS2 maakt het risico van de toeleveringsketen expliciet. Entiteiten moeten de kwetsbaarheden van elke directe leverancier, de kwaliteit van hun producten en hun praktijken voor veilige ontwikkeling in overweging nemen, en rekening houden met de **gecoördineerde risicobeoordelingen van kritieke toeleveringsketens** op EU-niveau onder Artikel 22. ([nis2-info.eu, Artikel 21](https://www.nis2-info.eu/article-21-cybersecurity-risk-management-measures/)) In OT *is* de toeleveringsketen het aanvalsoppervlak: uw integrators en OEM's hebben vaak permanente toegang op afstand tot uw meest gevoelige apparatuur. Governance van leverancierstoegang is hier geen papieren exercitie — het is een van de beheersmaatregelen met de hoogste hefboomwerking die u in eigen hand hebt.

### 5 — Beveiliging bij verwerving, ontwikkeling en onderhoud

Dit reikt tot in de inkoop en de gehele levenscyclus van systemen, inclusief de omgang met en openbaarmaking van kwetsbaarheden. Beveiligingseisen horen thuis in de specificatie wanneer u een nieuwe lijn koopt of een besturingssysteem upgradet — niet in een saneringsproject drie jaar later. Het is ook waar NIS2 de [Cyber Resilience Act](/nl/cra) en de [Machineverordening](/nl/machine-act) raakt: de producten die u koopt, komen steeds vaker met eigen beveiligingsverplichtingen, en het is uw taak deze te eisen en te verifiëren.

### 6 — Effectiviteit beoordelen

U moet kunnen aantonen dat de maatregelen werken, door middel van testen, audit en evaluatie. In OT is de uitdaging dit te doen zonder iets te breken — actief scannen van een live besturingsnetwerk kan net zo verstorend zijn als een aanval. Passieve monitoring, offline validatie en gefaseerd testen worden de gereedschappen bij uitstek, en een [Cyber Digital Twin](/nl/cyber-digital-twin) stelt u in staat om de vraag "houdt deze beheersmaatregel stand?" te beantwoorden tegen een model in plaats van tegen de productie.

### 7 — Basale cyberhygiëne en training

Patchen, configuratiebeheer, minimale rechten, bewustwording. De valkuil: in OT zijn de "gebruikers" engineers, operators en onderhoudspersoneel, en patchcycli worden bepaald door onderhoudsvensters die in maanden worden gemeten. Hygiëne moet worden ontworpen rondom de operationele realiteit — compensatiemaatregelen waar patchen daadwerkelijk onmogelijk is, en training die de taal van de fabriek spreekt, niet die van het SOC.

### 8 — Cryptografie en versleuteling

Evenredig toegepast. In OT beschermt versleuteling meestal sessies voor toegang op afstand, gegevens in transit over onvertrouwde verbindingen, en back-ups — niet realtime besturingsverkeer, waar latentie en verouderde protocollen inline-versleuteling vaak onpraktisch maken. Het woord "evenredig" doet hier echt werk: NIS2 vraagt u niet om een 20 jaar oude veldbus te versleutelen.

### 9 — HR-beveiliging, toegangsbeheer en assetbeheer

Wie wat mag aanraken, vanaf waar, met welke bevoegdheden. Gedeelde operatoraccounts, generieke leveranciersinloggegevens en contractanten met permanente toegang komen veelvuldig voor in OT en zijn precies waar deze maatregel op aangrijpt. Strakker toegangsbeheer en een bijgehouden assetregister zijn de twee beheersmaatregelen die het vaakst het werkelijke risico verminderen.

### 10 — MFA en beveiligde communicatie

Meervoudige of continue authenticatie, plus beveiligde spraak-, video- en tekstcommunicatie en noodcommunicatie waar passend. Ronduit gezegd: **MFA op toegang op afstand en bevoorrechte toegang tot OT is nu een verwachting.** Gezien hoe vaak OT-compromittering begint met een onbeveiligd toegangspad op afstand, is dit een van de meest waardevolle regels in het hele artikel.

> [!TIP]
> Het woord dat steeds terugkeert in Artikel 21 is **evenredig**. NIS2 vereist niet dezelfde maatregelen van een kerncentrale-exploitant als van een snackfood-distributeur. Het vereist maatregelen die evenredig zijn aan het risico, de blootstelling van de entiteit, de stand van de techniek, en de kosten afgewogen tegen de potentiële impact. Dat is een risicogebaseerde norm — en het betekent dat u uw keuzes moet kunnen *rechtvaardigen* tegen uw werkelijke risico. Een gestructureerde, op bewijs gebaseerde beoordeling is wat "we hebben besloten die PLC niet te patchen" verandert van een aansprakelijkheid in een verdedigbaar, gedocumenteerd besluit.

## Artikel 23: incidentmelding in de praktijk

Waar het oude regime vaag was, is NIS2 specifiek. Artikel 23 vereist dat betrokken entiteiten **significante incidenten** melden aan hun nationale CSIRT of bevoegde autoriteit binnen een vaste termijn die begint op het moment dat u **zich bewust wordt**. ([nis-2-directive.com, Artikel 23](https://www.nis-2-directive.com/NIS_2_Directive_Article_23.html))

| Fase | Termijn | Wat het moet bevatten |
| --- | --- | --- |
| **Vroegtijdige waarschuwing** | Binnen **24 uur** nadat u zich bewust werd | Of het incident vermoedelijk onrechtmatig/kwaadwillig is en of het grensoverschrijdende gevolgen kan hebben |
| **Incidentmelding** | Binnen **72 uur** nadat u zich bewust werd | Update van de vroegtijdige waarschuwing; eerste beoordeling van ernst en impact; indicatoren van compromittering indien beschikbaar |
| **Tussentijds verslag** | Op verzoek | Statusupdate op verzoek van de autoriteit |
| **Eindverslag** | Binnen **1 maand** na de melding | Gedetailleerde beschrijving, oorzaakanalyse, toegepaste mitigaties, en eventuele grensoverschrijdende impact |
| **Voortgangsverslag** | Indien het incident nog loopt na de termijn van 1 maand | Nu een voortgangsverslag, eindverslag binnen één maand na afhandeling van het incident |

Een incident is **significant** als het ernstige operationele verstoring van de dienst of financiële schade heeft veroorzaakt of kan veroorzaken, of andere personen heeft getroffen of kan treffen door aanzienlijke materiële of immateriële schade. ([Legiscope, 24u/72u-kader](https://www.legiscope.com/blog/nis2-incident-reporting.html)) Voor een OT-operator haalt een verstoring van een fysiek proces — een geactiveerd veiligheidssysteem, een stilgelegde productielijn, een verontreinigde watervoorziening — deze drempel met gemak.

Er is een wederkerige verplichting die het waard is te weten: het CSIRT of de bevoegde autoriteit moet reageren op de vroegtijdige waarschuwing **zonder onnodige vertraging en waar mogelijk binnen 24 uur**, inclusief eerste feedback en, op verzoek, operationeel advies. De melding is geen roepen in de leegte.

```timeline
T + 24 uur :: **Vroegtijdige waarschuwing** — meld of het incident vermoedelijk kwaadwillig is en of het grensoverschrijdende gevolgen kan hebben. Nog geen volledige analyse vereist.
T + 72 uur :: **Incidentmelding** — werk de waarschuwing bij met een eerste beoordeling van ernst en impact, plus indicatoren van compromittering (IoC's) voor zover beschikbaar.
Op verzoek :: **Tussentijds verslag** — een statusupdate wanneer de bevoegde autoriteit of het CSIRT daarom vraagt terwijl het incident nog loopt.
T + 1 maand :: **Eindverslag** — een gedetailleerde beschrijving, oorzaakanalyse, toegepaste mitigaties en de grensoverschrijdende impact.
Na afhandeling :: **Voortgangsverslag** — loopt het incident na één maand nog, dan volstaat een voortgangsverslag; het eindverslag volgt binnen één maand na afhandeling.
```

Het is essentieel om te begrijpen dat de klok start bij **bewustwording**, niet bij **oplossing**. U hoeft het incident op T+24u niet begrepen of ingeperkt te hebben — u moet het gemeld hebben. Dat verplaatst de last naar twee capaciteiten die OT-organisaties vaak missen: **detectie** die snel genoeg is om "bewustwording" binnen uren in plaats van weken te laten plaatsvinden, en een **geoefend meldproces** met vooraf ingevulde sjablonen en benoemde beslissers, zodat om drie uur 's nachts niemand hoeft uit te vogelen wie de autoriteit belt.

```svg
<svg viewBox="0 0 700 240" xmlns="http://www.w3.org/2000/svg" font-family="Segoe UI, Helvetica, Arial, sans-serif">
  <rect x="0" y="0" width="700" height="240" fill="none"/>
  <!-- baseline -->
  <line x1="40" y1="120" x2="660" y2="120" stroke="#94a3b8" stroke-width="2"/>
  <polygon points="668,120 656,114 656,126" fill="#94a3b8"/>
  <!-- T0 -->
  <circle cx="70" cy="120" r="7" fill="#f97316"/>
  <text x="70" y="150" text-anchor="middle" fill="#e5e7eb" font-size="12" font-weight="700">Bewust worden</text>
  <text x="70" y="167" text-anchor="middle" fill="#94a3b8" font-size="10">klok start</text>
  <!-- 24h -->
  <circle cx="230" cy="120" r="7" fill="#3b82f6"/>
  <line x1="230" y1="120" x2="230" y2="60" stroke="#3b82f6" stroke-width="1.2" stroke-dasharray="3 3"/>
  <rect x="150" y="30" width="160" height="34" rx="6" fill="#3b82f6" fill-opacity="0.15" stroke="#3b82f6" stroke-width="1.2"/>
  <text x="230" y="48" text-anchor="middle" fill="#e5e7eb" font-size="12" font-weight="700">24u — Vroeg. waarschuwing</text>
  <text x="230" y="60" text-anchor="middle" fill="#94a3b8" font-size="9.5">kwaadwillig? grensoverschr.?</text>
  <!-- 72h -->
  <circle cx="400" cy="120" r="7" fill="#3b82f6"/>
  <line x1="400" y1="120" x2="400" y2="60" stroke="#3b82f6" stroke-width="1.2" stroke-dasharray="3 3"/>
  <rect x="320" y="30" width="160" height="34" rx="6" fill="#3b82f6" fill-opacity="0.15" stroke="#3b82f6" stroke-width="1.2"/>
  <text x="400" y="48" text-anchor="middle" fill="#e5e7eb" font-size="12" font-weight="700">72u — Melding</text>
  <text x="400" y="60" text-anchor="middle" fill="#94a3b8" font-size="9.5">ernst, impact, IoC's</text>
  <!-- 1 month -->
  <circle cx="600" cy="120" r="7" fill="#f97316"/>
  <line x1="600" y1="120" x2="600" y2="176" stroke="#f97316" stroke-width="1.2" stroke-dasharray="3 3"/>
  <rect x="510" y="176" width="180" height="40" rx="6" fill="#f97316" fill-opacity="0.15" stroke="#f97316" stroke-width="1.2"/>
  <text x="600" y="194" text-anchor="middle" fill="#e5e7eb" font-size="12" font-weight="700">1 maand — Eindverslag</text>
  <text x="600" y="208" text-anchor="middle" fill="#94a3b8" font-size="9.5">oorzaak · mitigaties</text>
  <!-- on request marker -->
  <text x="500" y="150" text-anchor="middle" fill="#94a3b8" font-size="10" font-style="italic">tussentijds verslag op verzoek</text>
</svg>
```

De 24-uursklok is onverbiddelijk, en begint te lopen zodra u *zich bewust wordt* — niet zodra u klaar bent met onderzoeken. Dat legt de nadruk op twee zaken: **detectie**, omdat een organisatie die een incident niet kan zien het niet kan melden; en een **geoefend meldproces**, omdat een team dat de melding nog nooit heeft geoefend er onder druk om drie uur 's nachts geen samenhangende melding uit zal krijgen. Bouw de sjablonen, benoem de besluitvormers, en oefen de drill voordat u hem nodig hebt.

## Governance: het bestuur staat op het spel

Artikel 20 is de culturele draaischijf van NIS2. Bestuursorganen van betrokken entiteiten moeten de risicobeheersmaatregelen **goedkeuren**, toezien op de **uitvoering** ervan, en kunnen **aansprakelijk worden gesteld** voor overtredingen. Leden van de leiding moeten ook **training volgen** om voldoende kennis te verwerven om risico's te herkennen en beheerpraktijken te beoordelen, en worden geacht vergelijkbare training aan te bieden aan het personeel. ([ISMS.online, Artikel 34](https://www.isms.online/nis-2/articles/34-administrative-fines-for-non-compliance/))

In gewone taal: cybersecurity is niet langer iets dat een bestuur naar beneden kan delegeren en vergeten. Bestuurders zijn er verantwoordelijk voor. In ernstige, herhaalde gevallen en voor essentiële entiteiten voorzien verschillende lidstaten in **tijdelijke verboden op het uitoefenen van bestuursfuncties** voor de verantwoordelijke personen. Dit is bewust zo. De EU heeft geconcludeerd dat beveiligingsinvesteringen verantwoordelijkheid volgen — en dat de zekerste manier om investeringen in het minder glamoureuze OT-beveiligingsdomein op peil te houden, is door de mensen die het budget beheren, verantwoordelijk te maken voor het resultaat.

### Wat een bestuur daadwerkelijk moet doen

Goedkeuring en toezicht zijn geen handtekening onder een dia. Om de verplichting van Artikel 20 geloofwaardig na te komen, heeft een bestuursorgaan nodig:

- Een **beslissingsklaar beeld van operationeel risico** — geen stapel technische rapporten, maar een beeld dat helder genoeg is om maatregelen weloverwogen goed te keuren.
- Bewijs dat maatregelen **geïmplementeerd en effectief** zijn, met regelmaat vernieuwd, zodat het toezicht continu is in plaats van jaarlijks.
- Een **benoemde eindverantwoordelijke bestuurder** en een rapportagelijn die materieel OT-risico zonder vertaalverlies onder de aandacht van het bestuur brengt.
- **Gedocumenteerde training** voor bestuursleden, en een vastlegging van de risicobesluiten die het bestuur heeft bekrachtigd — want wanneer een toezichthouder of rechter vraagt "wist het bestuur ervan?", ligt het antwoord in de notulen.

## Toezicht en handhaving

De twee categorieën lopen hier uiteen. **Essentiële entiteiten** krijgen te maken met proactief, *ex ante* toezicht: autoriteiten kunnen audits, inspecties, beveiligingsscans en gerichte informatieverzoeken uitvoeren zonder dat daarvoor eerst bewijs van een probleem nodig is. **Belangrijke entiteiten** krijgen te maken met *ex post* toezicht: autoriteiten treden op wanneer er bewijs of een aanwijzing van niet-naleving is. ([nis-2-directive.com, Artikel 34](https://www.nis-2-directive.com/NIS_2_Directive_Article_34.html))

De bevoegdheden van autoriteiten nemen toe in zwaarte. Zij kunnen **waarschuwingen** geven, **bindende instructies** uitvaardigen, een entiteit bevelen **tekortkomingen te verhelpen** of **gedrag te staken**, melding aan getroffen partijen vereisen, en — voor essentiële entiteiten in ernstige gevallen — een **toezichthouder** aanstellen of **tijdelijke opschorting van certificeringen of bestuursfuncties** vorderen. Boetes onder Artikel 34 komen **bovenop** deze maatregelen, niet in plaats daarvan. Entiteiten behouden hun procedurele rechten: een hoorzitting, de mogelijkheid om verzachtend bewijs te overleggen, en een beroepsmogelijkheid.

## Sancties

Artikel 34 stelt de bovengrenzen voor bestuurlijke boetes vast. ([nis-2-directive.com, Artikel 34](https://www.nis-2-directive.com/NIS_2_Directive_Article_34.html))

| Type entiteit | Bovengrens boete | Structuur |
| --- | --- | --- |
| **Essentiële entiteiten** | Maximaal ten minste **€10.000.000 of 2%** van de totale wereldwijde jaaromzet | Welk bedrag ook **hoger** is |
| **Belangrijke entiteiten** | Maximaal ten minste **€7.000.000 of 1,4%** van de totale wereldwijde jaaromzet | Welk bedrag ook **hoger** is |

Dit zijn bovengrenzen, geen tarieven. Werkelijke boetes moeten **doeltreffend, evenredig en afschrikwekkend** zijn, beoordeeld tegen de aard, ernst en duur van de overtreding, de mate van verwijtbaarheid, en of de entiteit heeft meegewerkt. Maar de aan de omzet gekoppelde structuur — bekend van de AVG — geeft een duidelijk signaal af. Niet-naleving is bedoeld als een financieel risico op bestuursniveau, geen afrondingsverschil.

Reken het na voor een middelgrote groep met een omzet van €800 miljoen: 2% is €16 miljoen, ruim boven de vloer van €10 miljoen, dus geldt het hogere bedrag. Voor een onderneming met €4 miljard omzet is 2% gelijk aan €80 miljoen. Het percentage grijpt precies daar in waar de vaste bovengrens anders triviaal zou zijn — en dat is precies de bedoeling.

```keyfacts
Bovengrens essentieel :: €10 mln of 2% wereldwijde omzet (hoogste geldt)
Bovengrens belangrijk :: €7 mln of 1,4% wereldwijde omzet (hoogste geldt)
Toetssteen boete :: doeltreffend, evenredig én afschrikwekkend
Boven op boetes :: bindende instructies, staken van gedrag, toezichthouder
Uiterste maatregel :: tijdelijke schorsing van bestuurder/certificering (Art. 32(5))
Persoonlijk risico :: bestuurders aansprakelijk voor toezichttekort (Art. 20)
```

De boete is niet de zwaarste hefboom in het arsenaal. Voor **essentiële entiteiten** kan een toezichthouder onder **Artikel 32(5)**, wanneer andere handhavingsmaatregelen zijn uitgeput, om een rechterlijke of administratieve maatregel vragen die de **certificering of vergunning voor een deel of het geheel van de diensten opschort**, en — scherper nog — een **natuurlijke persoon met bestuurs- of vertegenwoordigingsbevoegdheid (een CEO of wettelijk vertegenwoordiger) tijdelijk verbieden bestuursfuncties uit te oefenen**. Dat is een sanctie tegen de persoon, niet alleen de rechtspersoon. In samenhang met de aansprakelijkheid van Artikel 20 is de boodschap ondubbelzinnig: aanhoudende, verwijtbare niet-naleving kan de baan van een bestuurder kosten, niet slechts een regel op de winst-en-verliesrekening. In Nederland wordt deze handhavingsarchitectuur belegd via de Cyberbeveiligingswet en de aangewezen sectorale toezichthouders.

```cta
€10 miljoen of 2% van de omzet — plus persoonlijke aansprakelijkheid voor uw bestuur.
NIS2-boetes raken de organisatie én haar leiding. Wij vertalen de tien maatregelen naar een verdedigbaar, bestuursklaar OT-beveiligingsprogramma.
Toets mijn NIS2-blootstelling :: /nl/contact
```

## Waar de wet de fabrieksvloer raakt

NIS2 gebruikt nergens de woorden "PLC" of "SCADA," maar de allgevaren-, risicogebaseerde eisen komen recht op OT neer. Drie spanningsvelden verdienen het om eerlijk te worden benoemd.

### De IT/OT-prioriteitsomkering

In IT luidt de beveiligingstriade vertrouwelijkheid, integriteit, beschikbaarheid — bescherm eerst de gegevens. In OT keert dit om: **veiligheid, dan beschikbaarheid, dan integriteit, dan vertrouwelijkheid.** Een handeling die in IT routine is — een patch afdwingen, een verbinding verbreken, een server herstarten — kan onaanvaardbaar zijn naast een lopend proces, waar de eerste plicht is dat niemand gewond raakt en de tweede dat de fabriek blijft draaien.

```svg
<svg viewBox="0 0 700 170" xmlns="http://www.w3.org/2000/svg" font-family="Segoe UI, Helvetica, Arial, sans-serif">
  <rect x="0" y="0" width="700" height="170" fill="none"/>
  <text x="30" y="30" fill="#94a3b8" font-size="13" font-weight="700">IT-prioriteit</text>
  <rect x="150" y="14" width="120" height="30" rx="6" fill="#3b82f6" fill-opacity="0.15" stroke="#3b82f6"/>
  <text x="210" y="34" text-anchor="middle" fill="#e5e7eb" font-size="12">Vertrouwelijkheid</text>
  <rect x="290" y="14" width="120" height="30" rx="6" fill="#3b82f6" fill-opacity="0.12" stroke="#3b82f6"/>
  <text x="350" y="34" text-anchor="middle" fill="#e5e7eb" font-size="12">Integriteit</text>
  <rect x="430" y="14" width="120" height="30" rx="6" fill="#3b82f6" fill-opacity="0.10" stroke="#3b82f6"/>
  <text x="490" y="34" text-anchor="middle" fill="#e5e7eb" font-size="12">Beschikbaarheid</text>
  <text x="620" y="34" fill="#94a3b8" font-size="11">hoogste → laagste</text>
  <line x1="30" y1="70" x2="670" y2="70" stroke="#94a3b8" stroke-width="0.75" stroke-dasharray="4 4"/>
  <text x="30" y="110" fill="#f97316" font-size="13" font-weight="700">OT-prioriteit</text>
  <rect x="110" y="94" width="100" height="30" rx="6" fill="#f97316" fill-opacity="0.20" stroke="#f97316"/>
  <text x="160" y="114" text-anchor="middle" fill="#e5e7eb" font-size="12">Veiligheid</text>
  <rect x="222" y="94" width="110" height="30" rx="6" fill="#f97316" fill-opacity="0.16" stroke="#f97316"/>
  <text x="277" y="114" text-anchor="middle" fill="#e5e7eb" font-size="12">Beschikbaarheid</text>
  <rect x="344" y="94" width="100" height="30" rx="6" fill="#f97316" fill-opacity="0.12" stroke="#f97316"/>
  <text x="394" y="114" text-anchor="middle" fill="#e5e7eb" font-size="12">Integriteit</text>
  <rect x="456" y="94" width="130" height="30" rx="6" fill="#f97316" fill-opacity="0.08" stroke="#f97316"/>
  <text x="521" y="114" text-anchor="middle" fill="#e5e7eb" font-size="12">Vertrouwelijkheid</text>
  <text x="620" y="114" fill="#94a3b8" font-size="11">hoogste → laagste</text>
  <text x="350" y="152" text-anchor="middle" fill="#94a3b8" font-size="11" font-style="italic">NIS2's evenredigheidsbeginsel biedt ruimte voor deze omkering — mits u ze kunt onderbouwen</text>
</svg>
```

Het evenredigheidsbeginsel van NIS2 biedt ruimte voor deze omkering, maar alleen als u de operationele beperkingen en de compensatiemaatregelen die u in plaats daarvan gebruikt, kunt *onderbouwen*. "We kunnen niet patchen tijdens een campagne, dus doen we X, Y en Z" is een verdedigbaar standpunt. Stilte is dat niet.

### U kunt niet beheren wat u niet ziet

De eerste maatregel van Artikel 21 is risicoanalyse, en risicoanalyse veronderstelt een asset-inventaris. In de praktijk is het meest voorkomende hiaat dat OXOT aantreft dat operators geen actueel, gestructureerd beeld hebben van hun OT-omgeving — welke apparaten er zijn, hoe deze verbonden zijn, welke blootgesteld zijn, en welke een veiligheidsfunctie beschermen. Onder NIS2 is dat hiaat niet langer alleen operationele achterstand; het is een compliance-risico, omdat u geen evenredige maatregelen kunt aantonen over een omgeving die u niet kunt beschrijven.

### IEC 62443 is het technische antwoord

NIS2 vertelt u *welke* uitkomsten u moet bereiken; het schrijft niet voor *hoe*. De reeks [IEC 62443](/nl/iec-62443) — de internationale norm voor de beveiliging van industriële automatiserings- en besturingssystemen — biedt het hoe: **zones en conduits, beveiligingsniveaus, en een levenscyclus** voor het bouwen en beheren van veilige besturingssystemen. Voor de spoor- en infrastructuurwereld breidt [TS 50701](/nl/ts-50701) dezelfde denkwijze uit. Het afstemmen van uw NIS2-aanpak op IEC 62443 geeft u een verdedigbare, internationaal erkende methode om aan te tonen dat uw maatregelen passend en evenredig zijn. De twee vullen elkaar aan: **NIS2 is de wettelijke verplichting; IEC 62443 is het technische antwoord.**

### Hoe de tien maatregelen zich verhouden tot IEC 62443

| Maatregel Artikel 21 | Waar IEC 62443 een antwoord biedt |
| --- | --- |
| Risicoanalyse & beleid | 62443-3-2 risicobeoordeling; 62443-2-1 beveiligingsprogramma |
| Incidentbehandeling | 62443-2-1 en 62443-3-3 detectie-/responsvereisten (FR 6) |
| Bedrijfscontinuïteit & herstel | 62443-2-1 continuïteit; 62443-3-3 beschikbaarheid van middelen (FR 7) |
| Beveiliging toeleveringsketen | 62443-2-4 vereisten voor dienstverleners; 62443-4-1 veilige ontwikkeling |
| Verwerving, ontwikkeling & onderhoud | 62443-4-1 veilige productlevenscyclus; 62443-4-2 componentvereisten |
| Effectiviteitsbeoordeling | 62443-2-1 audit en metrieken; beveiligingsverificatie uitvoeren |
| Cyberhygiëne & training | 62443-2-1 beleid; 62443-2-4 competentie |
| Cryptografie | 62443-3-3 vertrouwelijkheid van gegevens (FR 4) en integriteit (FR 3) |
| Toegangsbeheer & assetbeheer | 62443-3-3 identificatie/authenticatie (FR 1) en gebruikscontrole (FR 2) |
| MFA & beveiligde communicatie | 62443-3-3 FR 1/FR 2; zone-en-conduit beperkte datastromen (FR 5) |

Voor gerelateerde en aanpalende verplichtingen — de [CRA](/nl/cra), de [AI-verordening](/nl/ai-act), de [Machineverordening](/nl/machine-act) — zie ons overzicht van [kaders](/nl/frameworks) en hoe deze op elkaar aansluiten.

## Sectorspecifieke aandachtspunten

De verplichtingen zijn gemeenschappelijk, maar de drukpunten verschillen. Enkele sectorspecifieke realiteiten die OXOT herhaaldelijk tegenkomt:

- **Energie en nutsbedrijven.** Onderstationsautomatisering, DER-aggregatie en SCADA op afstand maken beschikbaarheid de allesoverheersende zorg. Verouderde protocollen en lange levensduur van assets botsen met de patch- en hygiëneverwachtingen van Artikel 21. Leverancierstoegang op afstand is alomtegenwoordig en onvoldoende beheerst.
- **Drinkwater en afvalwater.** Vaak weinig personeel, wijde geografische spreiding, duizenden locaties op afstand. Een significant incident kan hier een gebeurtenis voor de volksgezondheid betekenen, dus de "aanzienlijke schade"-toets van Artikel 23 wordt gemakkelijk gehaald. Zichtbaarheid van assets over verspreide telemetrie is het lastigste onderdeel.
- **Chemie en procesindustrie.** Veiligheidsinstrumentatiesystemen en functionele-veiligheidsregimes domineren. Cybersecurity moet worden verzoend met procesveiligheid, niet ernaast worden geplakt — een natuurlijke fit voor de risicogebaseerde zones van IEC 62443.
- **Industriële productie (Bijlage II).** Platte netwerken, samengevoegde IT/OT, en machines die met hun eigen [CRA](/nl/cra)- en [Machineverordening](/nl/machine-act)-verplichtingen binnenkomen. De verrassing over de reikwijdte is reëel: veel fabrikanten ontdekten pas recent dat zij belangrijke entiteiten zijn.
- **Productie en distributie van levensmiddelen.** Integriteit van de koudeketen, hoogvolumelijnen en dunne marges maken uitvaltijd duur en veiligheidsrelevant. Herstel-testen van lijnbesturingen is vaak de verwaarloosde beheersmaatregel.

## Een praktisch stappenplan

Er is geen snelle route, maar er is een verstandige volgorde. Voer dit uit als een programma met fasen, niet als een eenmalig project.

| Fase | Focus | Belangrijkste opleveringen |
| --- | --- | --- |
| **0. Status bevestigen** | Bent u essentieel of belangrijk onder uw nationale wetgeving? | Reikwijdtebepaling; registratie waar vereist |
| **1. De omgeving in kaart brengen** | Het asset- en risicobeeld opbouwen | Gestructureerde OT-inventaris; connectiviteitskaart; markeringen voor blootstelling en veiligheidskritikaliteit |
| **2. Beoordelen t.o.v. Art. 21** | Huidige situatie afzetten tegen de tien maatregelen | Gapanalyse geprioriteerd naar operationeel risico, niet naar ruwe CVSS |
| **3. Meldvermogen opbouwen** | Art. 23 inrichten en oefenen | Sjablonen, beslissingsbevoegdheden, een geteste 24u/72u/1-maand-drill |
| **4. Saneren in golven** | Gaten dichten, afgestemd op IEC 62443 | Geprioriteerde, evenredige, operationeel realistische uitrol van beheersmaatregelen |
| **5. Aantonen & borgen** | Effectiviteit aantonen en onderhouden | Test-/auditritme; levend bewijsdossier; rapportage aan het bestuur |

> [!NOTE]
> Verschillende lidstaten leggen **registratieverplichtingen** op met hun eigen termijnen, los van de inhoudelijke verplichtingen. Het bevestigen van de status (Fase 0) is geen bureaucratische formaliteit — mis een registratievenster en u kunt non-compliant zijn nog voordat u ook maar één technische beheersmaatregel hebt aangeraakt.

## Wat het betekent voor uw rol

**Als u CISO of beveiligingsverantwoordelijke bent,** verlengt NIS2 uw mandaat over de IT/OT-grens heen en vraagt bewijs, geen bewering. U zult worden gevraagd uw risicobeeld, uw maatregelen en de effectiviteit ervan te tonen — voor omgevingen die u mogelijk niet volledig beheerst en waarvan de eigenaren een andere taal spreken. Uw hefboom is een gedeeld, gestructureerd beeld van OT-risico dat engineering vertrouwt en het bestuur kan lezen.

**Als u een fabrieks- of operationsmanager bent,** moeten beveiligingsbeslissingen nu worden verzoend met de productie- en veiligheidsrealiteit, en bent u een belanghebbende bij — niet een toeschouwer van — de risicobeoordeling. Het voordeel: een echt risicogebaseerde aanpak beschermt u tegen onevenredige, verstorende maatregelen die van bovenaf worden opgelegd door mensen die nooit op uw fabrieksvloer hebben gestaan.

**Als u in het bestuur of de directie zit,** maakt NIS2 cybersecurity tot een benoemde governanceplicht met persoonlijke blootstelling. U hebt voldoende zicht nodig om maatregelen weloverwogen goed te keuren en erop toe te zien — wat betekent dat u moet aandringen op een helder, beslissingsklaar beeld van operationeel risico, gedocumenteerde training, en een vastlegging van wat u hebt bekrachtigd en wanneer.

**Als u werkzaam bent in compliance of juridische zaken,** introduceert NIS2 harde termijnen en aan de omzet gekoppelde sancties. U hebt het meldproces geoefend nodig en het bewijsdossier onderhouden, want het verschil tussen een verdedigbare positie en een boete is vaak documentatie die u wel of niet hebt bijgehouden.

## Hoe OXOT helpt

OXOT is precies hiervoor gebouwd: gefragmenteerde OT-beveiligingsbevindingen omzetten in heldere, verdedigbare besluiten. Onze **OT-beveiligingsassessments** leggen het asset- en risicobeeld vast dat NIS2 veronderstelt dat u al hebt. Onze [Cyber Digital Twin](/nl/cyber-digital-twin) verenigt documentatie, netwerkgegevens, asset-inventarissen en tooloutput in één gestructureerd model, zodat u Artikel 21-hiaten kunt prioriteren op basis van werkelijk operationeel risico en uw redenering kunt tonen aan een auditor, een bestuur of een toezichthouder. Onze **OT-beveiligingsprogramma's** leveren sanering in evenredige, [IEC 62443](/nl/iec-62443)-afgestemde golven, en onze **kennisoverdracht** zorgt ervoor dat de kennis bij uw team blijft nadat wij zijn vertrokken.

Wij zijn OT-eerst, risicogebaseerd, en gebouwd op het uitgangspunt van Europese digitale soevereiniteit — uw data en uw model blijven van u. NIS2 beloont organisaties die kunnen aantonen dat zij hun risico doelbewust begrijpen en beheren. Dat is precies waar onze werkwijze om draait.

## Veelgestelde vragen

**Is NIS2 rechtstreeks van toepassing, of via nationale wetgeving?**
Via nationale wetgeving. NIS2 is een richtlijn, omgezet door elke lidstaat. Controleer altijd uw nationale wet — verschillende landen stellen strengere of bredere eisen dan de basis van de richtlijn. In Nederland is de relevante wet de Cyberbeveiligingswet.

**We hebben de termijn van 17 oktober 2024 gemist — wat nu?**
Die termijn gold voor *lidstaten* om wetgeving vast te stellen, niet als respijtperiode voor entiteiten. De verplichtingen gelden zodra uw nationale wet van kracht is. Geef prioriteit aan het bevestigen van uw status, het inrichten van het meldproces, en het opbouwen van het risicobeeld, en saneer vervolgens in geprioriteerde golven. Waar de wet van uw lidstaat vertraging heeft, gebruik de tijd om gereed te zijn in plaats van te wachten.

**Hoe weet ik of ik essentieel of belangrijk ben?**
Controleer uw sector tegen Bijlage I (essentieel-georiënteerd, hoogkritiek) en Bijlage II (belangrijk), pas dan de omvangsregel toe — over het algemeen 50+ werknemers of €10 miljoen+ omzet — en let op de omvangsonafhankelijke uitzonderingen (DNS, TLD-registers, vertrouwensdiensten, openbare elektronische communicatie). Bevestig dit vervolgens tegen uw nationale omzetting, die de bindende tekst is.

**Is een firewall tussen IT en OT voldoende?**
Nee. Segmentatie is belangrijk, maar Artikel 21 omvat governance, toeleveringsketen, toegangsbeheer, incidentbehandeling, continuïteit, cryptografie en meer. Eén enkele beheersmaatregel kan niet voldoen aan een risicobeheerverplichting, en een toezichthouder die de evenredigheid beoordeelt, kijkt naar het gehele programma.

**Wat telt als een "significant" incident dat ik moet melden?**
Een incident dat ernstige operationele verstoring of financiële schade heeft veroorzaakt of kan veroorzaken, of aanzienlijke materiële of immateriële schade aan anderen. In OT zullen de meeste gebeurtenissen die een fysiek proces verstoren — veiligheidstrips, stilgelegde lijnen, verontreiniging — hieraan voldoen. Meld bij twijfel; de 24-uurs vroegtijdige waarschuwing is bewust laagdrempelig gehouden.

**Hoe verhoudt NIS2 zich tot de CRA en IEC 62443?**
NIS2 verplicht *operators* om het risico van de systemen die zij gebruiken te beheren. De [Cyber Resilience Act](/nl/cra) verplicht *fabrikanten* om beveiliging in te bouwen in producten met digitale elementen. [IEC 62443](/nl/iec-62443) geeft operators en leveranciers de technische methode om beide te doen. Zij versterken elkaar in plaats van te concurreren.

**Kunnen bestuursleden echt persoonlijk aansprakelijk worden gesteld?**
Ja. Artikel 20 vereist dat de leiding de maatregelen goedkeurt en erop toeziet, en maakt het mogelijk dat zij aansprakelijk wordt gesteld voor tekortkomingen. Verschillende lidstaten voorzien, voor essentiële entiteiten, in tijdelijke verboden op het uitoefenen van bestuursfuncties in ernstige, herhaalde gevallen. Gedocumenteerd toezicht en training zijn uw bescherming.

## Bronnen

- Richtlijn (EU) 2022/2555 (NIS2), volledige tekst — [EUR-Lex, CELEX 32022L2555](https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022L2555)
- Artikel 3, essentiële en belangrijke entiteiten — [nis-2-directive.com](https://www.nis-2-directive.com/NIS_2_Directive_Article_3.html)
- Artikel 21, cybersecurity-risicobeheersmaatregelen — [nis-2-directive.com](https://www.nis-2-directive.com/NIS_2_Directive_Article_21.html) · [nis2-info.eu](https://www.nis2-info.eu/article-21-cybersecurity-risk-management-measures/)
- Artikel 23, meldverplichtingen & 24u/72u/1-maand-tijdlijn — [nis-2-directive.com](https://www.nis-2-directive.com/NIS_2_Directive_Article_23.html) · [Legiscope](https://www.legiscope.com/blog/nis2-incident-reporting.html)
- Artikel 34, bestuurlijke boetes — [nis-2-directive.com](https://www.nis-2-directive.com/NIS_2_Directive_Article_34.html) · [ISMS.online](https://www.isms.online/nis-2/articles/34-administrative-fines-for-non-compliance/)
- Essentiële versus belangrijke entiteiten, reikwijdte en omvangsregel — [Glocert](https://www.glocertinternational.com/resources/guides/nis2-applicability-essential-vs-important-entities/) · [Legiscope](https://www.legiscope.com/blog/nis2-essential-important-entities.html)
- Omzettingsstatus en handhaving door de Commissie — [Europese Commissie](https://digital-strategy.ec.europa.eu/en/policies/nis-transposition) · [ECSO-tracker](https://ecs-org.eu/activities/nis2-directive-transposition-tracker/)
- Nederlandse Cyberbeveiligingswet (Cbw) ter implementatie van NIS2 — [Bird & Bird](https://www.twobirds.com/en/insights/2026/netherlands/dutch-parliament-approves-cybersecurity-act-implementing-nis2)

*Deze pagina bevat algemene informatie over EU-wetgeving en vormt geen juridisch advies. Bevestig hoe NIS2 op uw organisatie van toepassing is aan de hand van uw nationale omzettingswet en, waar nodig, gekwalificeerd juridisch advies.*$MDBODY$, true, $MDBODY$NIS2-richtlijn voor OT & Industrie | OXOT$MDBODY$, $MDBODY$Wat NIS2 (Richtlijn (EU) 2022/2555) betekent voor industriële en OT-operators — reikwijdte, de tien maatregelen van Artikel 21, 24/72-uurs melding, bestuurdersaansprakelijkheid, sancties, aansluiting op IEC 62443, en een praktisch stappenplan.$MDBODY$, $MDBODY$Een OT-gerichte praktijkgids voor NIS2 — wie onder de reikwijdte valt, de tien maatregelen van Artikel 21 vertaald naar de fabrieksvloer, het 24/72-uurs/één-maand meldritme, bestuurdersaansprakelijkheid, sancties, en een gefaseerd plan dat u daadwerkelijk kunt uitvoeren.$MDBODY$, NULL, $MDBODY$page$MDBODY$, now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET
  title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published,
  meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description,
  excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type,
  published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now()
WHERE length(pages.body) < length(EXCLUDED.body);

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ($MDBODY$machine-act$MDBODY$, $MDBODY$en$MDBODY$, $MDBODY$The EU Machinery Regulation$MDBODY$, $MDBODY$For most of industrial history, machine safety and cybersecurity lived in separate worlds. Safety engineers reasoned about guards, interlocks, light curtains and emergency stops. Security, if anyone owned it at all, was an IT concern that stopped at the office firewall. The **EU Machinery Regulation** ends that separation. It rebuilds Europe's machine-safety regime for an era in which machines are networked, software-defined and increasingly steered by AI — and it does something the old law never did: it makes **protection against corruption a condition of a machine being safe**.

That single move rewires the compliance question for everyone who builds, integrates, imports or reworks machinery for the European market. The CE marking that declares a machine safe now depends, in part, on getting cybersecurity right. Miss it, and the machine is not merely insecure — under the Regulation, it is not compliant.

> [!IMPORTANT]
> Regulation (EU) 2023/1230 entered into force on 19 July 2023 and **applies from 20 January 2027**, repealing Machinery Directive 2006/42/EC. From that date, machinery placed on the EU market must meet the new essential health and safety requirements — including the cybersecurity-related ones. ([EUR-Lex](https://eur-lex.europa.eu/eli/reg/2023/1230/oj/eng))

```keyfacts
Instrument :: Regulation (EU) 2023/1230 — directly applicable, no transposition
Replaces :: Machinery Directive 2006/42/EC
In force since :: 19 July 2023
Applies from :: 20 January 2027 (hard deadline)
Cyber clauses :: Annex III §1.1.9 (protection against corruption) + §1.2.1 (control-system reliability)
New high-risk category :: ML-based self-evolving safety components (Annex I Part A)
Substantial modification :: defined in law — Article 3(16)
AI Act link :: AI safety component in machinery → automatically high-risk
Key emerging standard :: prEN 50742 — protection against corruption
```

## The short version

- The **Machinery Regulation (EU) 2023/1230** replaces the long-standing **Machinery Directive 2006/42/EC**. ([EUR-Lex](https://eur-lex.europa.eu/eli/reg/2023/1230/oj/eng))
- It applies from **20 January 2027** — a hard deadline, not a soft target. ([EU-OSHA](https://osha.europa.eu/en/legislation/directive/regulation-20231230eu-machinery))
- As a **Regulation** rather than a Directive, it applies **directly and identically** across all 27 Member States, ending the national divergence that Directive transposition allowed.
- It introduces **cybersecurity-related essential health and safety requirements** in **Annex III** — machinery must resist **accidental or intentional corruption** that could create a hazard, and must keep **tamper evidence**. ([Nemko](https://www.nemko.com/blog/eu-machinery-regulation-2023/1230))
- It addresses **software, connectivity and AI**, including machinery with **self-evolving behaviour** and **AI-based safety components**.
- It links to the **[AI Act](/en/ai-act)**: an AI system used as a safety component of machinery that itself needs third-party conformity assessment is **automatically high-risk**. ([EU AI Act Annex I](https://artificialintelligenceact.eu/annex/1/))

## Why the old Directive failed the connected era

The Machinery Directive is a product of 2006 — a world before the industrial IoT was routine, before a press or a palletiser routinely spoke to a network, before machine-learning models sat inside a safety loop. On its own terms it was a good law. It disciplined mechanical, electrical, thermal and ergonomic hazards, and it gave Europe a common safety grammar for two decades.

What it never contemplated is a machine that is mechanically flawless yet dangerous because someone corrupted its logic. A guard is worthless if a forged network command retracts it. An emergency-stop function is worthless if its firmware can be silently overwritten. A perfectly rated safety relay is worthless if the safety PLC driving it accepts unauthenticated instructions from a remote-maintenance portal. The Directive had nothing to say about any of that, because in 2006 those attack surfaces barely existed on the plant floor.

The Regulation is the correction. It keeps the proven architecture of EU product-safety law — essential health and safety requirements, risk assessment, conformity assessment, CE marking, a Declaration of Conformity — and extends that architecture to the **digital** ways a modern machine becomes unsafe. Two structural choices signal the intent.

**It is a Regulation, not a Directive.** A Directive is a target each Member State transposes into national law, which is why "the Machinery Directive" quietly meant 27 slightly different laws. A Regulation is the law, in every country, on the same day. One European rulebook, no transposition lag, far less room for a machine that is legal in one market and not another.

**It puts security inside the safety case, not beside it.** The Regulation does not create a separate "cyber annex" you can bolt on late. It threads corruption-resistance, safe connectivity and tamper evidence through the same essential requirements that govern guarding and control reliability. Security is now something your safety engineers own, evidenced in the same technical file.

### Directive 2006/42/EC vs Regulation (EU) 2023/1230

| Dimension | Machinery **Directive** 2006/42/EC | Machinery **Regulation** (EU) 2023/1230 |
|---|---|---|
| Legal instrument | Directive — transposed into 27 national laws | Regulation — directly applicable, uniform EU-wide |
| Applies from | 29 December 2009 | **20 January 2027** ([EU-OSHA](https://osha.europa.eu/en/legislation/directive/regulation-20231230eu-machinery)) |
| Cybersecurity | Effectively silent | Explicit EHSRs on **protection against corruption** and safe connections (Annex III) |
| Software & AI | Not addressed as such | Software safety components and **AI / self-evolving** behaviour in scope |
| High-risk list | Annex IV; self-certification broadly available | **Annex I** (Parts A/B); Part A makes **notified-body** assessment mandatory |
| Instructions | Paper manual generally required | **Digital instructions** permitted (with safety-info carve-outs) |
| Substantial modification | Handled through national/guidance practice | **Defined in law** (Art. 3(16)); modifier becomes the manufacturer |

## What the Regulation covers

The Regulation applies to **machinery** and a family of **related products**: safety components, interchangeable equipment, lifting accessories, chains, ropes and webbing, removable mechanical transmission devices, and **partly completed machinery** — an assembly that cannot yet perform an application on its own and is meant to be built into other machinery. ([EU-OSHA](https://osha.europa.eu/en/legislation/directive/regulation-20231230eu-machinery))

Two points matter most for the digital era:

**Safety components are products in their own right.** A safety component is a part whose failure endangers people, and the Regulation is explicit that this now includes **software** performing a safety function and, named specifically, **AI-based** safety components. If your product's job is to keep a machine safe, it carries the requirements — whether it is a light curtain, a safety controller, or a trained model that decides when a collaborative robot must stop.

**Self-evolving behaviour is anticipated, not ignored.** The Regulation contemplates machinery whose behaviour can adapt or learn after it leaves the factory, and it refuses to let that evolution wander outside the safe operating envelope validated at conformity assessment. Learning is allowed; drifting into a hazardous state is not.

Alongside the technology, the Regulation modernises the paperwork. It permits **digital instructions and documentation** rather than a mandatory printed manual in every case (with sensible carve-outs so that essential safety information remains accessible), and it writes the rules on **substantial modification** into the law itself — more on that below.

## Cybersecurity becomes part of the safety case

Here is the heart of the change for anyone in OT. The Regulation's essential health and safety requirements, set out in **Annex III**, now carry cybersecurity-relevant clauses. The clearest is **Annex III §1.1.9, "Protection against corruption."** In plain terms: a machine must be designed so that its safety is **not compromised by corruption — whether accidental or intentional** — of the hardware and software components that affect safety. ([Nemko](https://www.nemko.com/blog/eu-machinery-regulation-2023/1230))

Read that carefully, because the wording is precise and the precision is the point.

- The concern is **safety**, not confidentiality. The Regulation does not ask you to protect trade secrets; it asks you to ensure that corruption cannot turn the machine into a hazard.
- It covers **accidental and intentional** corruption alike — a malformed update, a mis-flashed controller, a bit-flip on a bus, and a deliberate attacker are all in scope.
- It reaches the components **that affect safety**. A machine's business-logic HMI is not the target; the safety function and the systems that can influence it are.

From that clause, and the control-reliability requirements in **Annex III §1.2.1**, a concrete set of engineering expectations follows.

### The cybersecurity-related essential requirements, in engineering terms

| Requirement (as expressed in Annex III) | What it means on the machine |
|---|---|
| Safety not compromised by **accidental or intentional corruption** of safety-affecting hardware/software (§1.1.9) | Safety-related control logic and firmware must resist tampering; corrupting them must not be able to defeat a safety function |
| **Evidence of intervention** in safety software | The control system must **log** legitimate and illegitimate interventions so tampering is detectable and traceable — tamper evidence, retained over the machine's life ([Nemko](https://www.nemko.com/blog/eu-machinery-regulation-2023/1230)) |
| Safe **connection** to external devices (§1.2.1) | Wireless, networked and remote-access features must not create a hazardous situation; a bad or hostile connection must not reach a safety function |
| **Robust safety functions** under external influence | Safety functions must remain reliable when subjected to reasonably foreseeable external influence delivered through connections, not only under clean-lab conditions |
| **Lifecycle** maintenance of protection | Protective measures, updates and patches must be sustainable across the machine's operational life, not frozen at the moment of shipment |

This is a genuine reframing, not a relabelling. Cybersecurity for machinery is no longer a parallel workstream that runs alongside safety and reports to a different manager. It is **inside** the safety argument. If a machine can be made dangerous by corrupting its software, then — in the Regulation's logic — it is not safe, and it does not conform. The security failure and the safety failure are the same failure.

### What "protection against corruption" actually demands

The Regulation states the *outcome* — safety must survive corruption — and leaves the *how* to engineering and standards. In practice, satisfying Annex III §1.1.9 and §1.2.1 on a real machine converges on a recognisable set of controls, the same measures a control-system security engineer would reach for:

- **Know your software.** Identify the safety-affecting software and data — increasingly captured as a **software bill of materials (SBOM)** — because you cannot protect components you have not enumerated. This is also the seam with the [CRA](/en/cra), which makes the SBOM an explicit obligation.
- **Authenticate what runs.** **Signed firmware** and a **secure/verified boot** chain so a modified safety image is rejected rather than executed. The Regulation's example is blunt: if someone installs modified safety firmware, the machine must be able to detect it.
- **Authenticate who connects.** Safety-relevant instructions must come only from authenticated, authorised sources. An unauthenticated command from a remote-maintenance portal must never be able to reach a safety function.
- **Constrain the connection.** Networked, wireless and remote-access features must be designed so a bad or hostile connection cannot create a hazardous situation — segmentation, least privilege, and a safe-state fallback if the link misbehaves.
- **Make tampering visible.** Log both **legitimate and illegitimate** interventions in safety software, with retention across the machine's operational life, so corruption is detectable and traceable after the fact.
- **Sustain protection over the lifecycle.** Updates and patches for the safety-affecting software must remain deliverable for as long as the machine is in service — protection frozen at ship date is not protection.

```compare
The safety case survives corruption when…
- Safety-affecting software is **inventoried** (SBOM) and its integrity is verifiable
- Firmware is **signed** and boot is **verified** — modified images are rejected
- Remote and networked access is **authenticated, authorised and segmented**
- Interventions are **logged and retained** — tampering leaves evidence
- Patches and updates stay **deliverable across the machine's life**
---
The machine is non-conforming when…
- A **forged network command** can retract a guard or defeat an interlock
- Safety **firmware can be silently overwritten** and executed
- A **remote-maintenance portal** reaches a safety function unauthenticated
- Tampering with safety software **leaves no trace**
- Security **cannot be maintained** after the machine ships
```

None of this is novel to a security engineer — which is exactly the point. The Regulation does not invent a new discipline; it imports an existing one, [IEC 62443](/en/iec-62443), into the machine-safety file and makes it a condition of the CE mark.

```svg
<svg viewBox="0 0 700 340" xmlns="http://www.w3.org/2000/svg" font-family="system-ui,Segoe UI,Roboto,sans-serif">
  <rect x="0" y="0" width="700" height="340" fill="none"/>
  <text x="350" y="28" fill="#e5e7eb" font-size="17" font-weight="700" text-anchor="middle">Cybersecurity as part of the machine safety case</text>

  <!-- Outer safety case boundary -->
  <rect x="30" y="50" width="640" height="260" rx="12" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="46" y="72" fill="#3b82f6" font-size="13" font-weight="700">Machine safety case → CE marking &amp; Declaration of Conformity</text>

  <!-- Traditional safety block -->
  <rect x="55" y="92" width="285" height="88" rx="8" fill="none" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="197" y="114" fill="#e5e7eb" font-size="13" font-weight="700" text-anchor="middle">Functional / mechanical safety</text>
  <text x="197" y="136" fill="#94a3b8" font-size="11.5" text-anchor="middle">Guards · interlocks · E-stop</text>
  <text x="197" y="153" fill="#94a3b8" font-size="11.5" text-anchor="middle">Control reliability · risk assessment</text>
  <text x="197" y="170" fill="#94a3b8" font-size="11.5" text-anchor="middle">EN ISO 12100 / 13849</text>

  <!-- Cyber block -->
  <rect x="360" y="92" width="285" height="88" rx="8" fill="none" stroke="#f97316" stroke-width="1.5"/>
  <text x="502" y="114" fill="#f97316" font-size="13" font-weight="700" text-anchor="middle">Protection against corruption</text>
  <text x="502" y="136" fill="#94a3b8" font-size="11.5" text-anchor="middle">Anti-tamper · safe connections</text>
  <text x="502" y="153" fill="#94a3b8" font-size="11.5" text-anchor="middle">Tamper-evidence logging</text>
  <text x="502" y="170" fill="#94a3b8" font-size="11.5" text-anchor="middle">Annex III §1.1.9 / §1.2.1</text>

  <!-- Merge arrow -->
  <line x1="197" y1="180" x2="197" y2="210" stroke="#94a3b8" stroke-width="1.5"/>
  <line x1="502" y1="180" x2="502" y2="210" stroke="#94a3b8" stroke-width="1.5"/>
  <line x1="197" y1="210" x2="502" y2="210" stroke="#94a3b8" stroke-width="1.5"/>
  <line x1="350" y1="210" x2="350" y2="238" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#a)"/>
  <defs>
    <marker id="a" markerWidth="9" markerHeight="9" refX="5" refY="3" orient="auto">
      <path d="M0,0 L6,3 L0,6 Z" fill="#94a3b8"/>
    </marker>
  </defs>

  <rect x="205" y="240" width="290" height="52" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="350" y="262" fill="#e5e7eb" font-size="13" font-weight="700" text-anchor="middle">One integrated safety argument</text>
  <text x="350" y="281" fill="#94a3b8" font-size="11.5" text-anchor="middle">Corruptible safety = not safe = not compliant</text>
</svg>
```

> [!NOTE]
> Emerging standards are lining up behind the clauses. **EN 50742** (under development) addresses corruption protection in machinery and safety components; **IEC 62443** supplies the recognised engineering method for the control systems inside a machine; **ISO/CD 24882** targets cybersecurity for agricultural machinery. Expect harmonised standards to become the practical route to presuming conformity. ([Nemko](https://www.nemko.com/blog/eu-machinery-regulation-2023/1230))

## Software, connectivity and AI — and the AI Act interlock

The Regulation is deliberately forward-leaning on software and AI. It recognises machinery whose behaviour can **evolve** — systems that adapt or learn in service — and requires that such evolution cannot carry the machine beyond the safe envelope proven at assessment. Where AI performs a safety function, the machine must reckon with what AI actually brings: behaviour that is hard to test exhaustively, decisions that are hard to explain, and a standing need for meaningful human oversight of automated action.

This is exactly where the Machinery Regulation and the **[AI Act](/en/ai-act)** are engineered to interlock. The Machinery Regulation appears in **Annex I of the AI Act** as Union harmonisation legislation. Under **AI Act Article 6(1)**, an AI system that is a **safety component** of a product covered by that Annex I legislation — and where the product must undergo third-party conformity assessment — is **automatically classified as high-risk**. ([EU AI Act Annex I](https://artificialintelligenceact.eu/annex/1/))

The consequence is concrete. Deploy an AI model as a safety component in machinery that falls into the notified-body route, and you are simultaneously the manufacturer of a high-risk AI system. Two regimes, one product, at the same time:

- The **Machinery Regulation** governs the machine's safety-and-security (risk assessment, Annex III essential requirements, conformity assessment, technical file, CE marking).
- The **AI Act** layers on the high-risk obligations for the model itself: risk management, data governance, logging, transparency, human oversight, accuracy and robustness, and a quality management system.

> [!WARNING]
> An AI safety component is not "a bit of extra paperwork." Under Article 6(1), it can move your product from a self-declared route into **third-party conformity assessment with a notified body**, and it triggers the AI Act's high-risk lifecycle at the same time. Discovering that overlap during assessment, months before a launch, is one of the most expensive ways to learn it. Map it at design time. See [AI Act](/en/ai-act).

## Conformity assessment and high-risk machinery

Like the Directive before it, the Regulation classifies machinery by risk and offers proportionate routes to CE marking. Most machinery can still reach the market by the manufacturer's **self-assessment** (internal production control). The higher-risk categories are listed in **Annex I**, split into two parts, and this is where the notified body enters.

- **Annex I, Part A** — the categories the Regulation treats as the highest risk. For these, **third-party conformity assessment by a notified body is mandatory**; the manufacturer cannot self-declare. Part A now includes **safety components with fully or partially self-evolving behaviour using machine-learning approaches ensuring safety functions** — a category that did not, and could not, exist under the 2006 Directive. ([Baker McKenzie](https://www.bakermckenzie.com/en/insight/publications/resources/product-risk-radar-articles/machinery-regulation))
- **Annex I, Part B** — high-risk categories broadly comparable to the old Annex IV, where a manufacturer may use a self-assessment route **only** if it has applied the relevant harmonised standards in full; otherwise a notified body is required.

### Risk category → conformity route

| Machinery category | Risk tier | Conformity route |
|---|---|---|
| Ordinary machinery (not in Annex I) | Standard | Manufacturer **self-assessment** (internal production control) |
| **Annex I, Part B** high-risk | High | Self-assessment **only if** harmonised standards applied in full; otherwise **notified body** |
| **Annex I, Part A** (incl. **ML-based self-evolving safety components**) | Highest | **Notified body mandatory** — no self-declaration ([Baker McKenzie](https://www.bakermckenzie.com/en/insight/publications/resources/product-risk-radar-articles/machinery-regulation)) |

The practical takeaway: adding connectivity or AI to a machine is not a neutral feature decision. It can change the machine's risk classification, the conformity route, whether a notified body is in the loop, and therefore the cost and lead time to market. That call belongs at the start of a project, with your safety and security engineers in the room together.

## Substantial modification: when the plant floor becomes the manufacturer

One provision deserves its own spotlight, because it catches integrators and operators who think the Regulation is only a builder's problem. The Regulation **defines substantial modification in law**, at **Article 3(16)**: a modification of a machine, by physical or digital means, made after it was placed on the market or put into service, that the original manufacturer did not foresee or plan, and that affects safety by creating a new hazard or increasing an existing risk such that new protective measures are needed. ([EU-OSHA](https://osha.europa.eu/en/legislation/directive/regulation-20231230eu-machinery))

The sting is in the effect. A person who carries out a substantial modification is **considered the manufacturer** of the modified machinery and takes on the manufacturer's obligations under Article 10 — a fresh risk assessment, conformity assessment, technical file, Declaration of Conformity and CE marking for the modified machine. And because the definition explicitly names **digital** means, a change to control software, a new network connection, or a retrofitted AI function can be the substantial modification that transfers manufacturer liability onto you.

> [!TIP]
> Before you rework a safety-related control system — re-flash a safety PLC, add remote access, drop in a learning model — assess whether the change is a substantial modification under Article 3(16). If it is, you have just inherited a manufacturer's obligations. Knowing that line **before** you touch the machine is far cheaper than discovering it after an incident. A [Cyber Digital Twin](/en/cyber-digital-twin) makes those change boundaries visible.

## The multi-framework stack around a smart machine

The Machinery Regulation does not operate alone. A single connected, AI-enabled production line can pull five European regimes into scope at once, each governing a different facet of the same asset. Treating them as five disconnected audits is how programmes go over budget; treating them as one engineering problem is how they get built once.

```svg
<svg viewBox="0 0 700 400" xmlns="http://www.w3.org/2000/svg" font-family="system-ui,Segoe UI,Roboto,sans-serif">
  <rect x="0" y="0" width="700" height="400" fill="none"/>
  <text x="350" y="28" fill="#e5e7eb" font-size="17" font-weight="700" text-anchor="middle">One connected/AI machine → five regimes at once</text>

  <!-- Center node -->
  <rect x="270" y="170" width="160" height="60" rx="10" fill="none" stroke="#f97316" stroke-width="2.5"/>
  <text x="350" y="196" fill="#e5e7eb" font-size="13.5" font-weight="700" text-anchor="middle">Connected / AI</text>
  <text x="350" y="214" fill="#e5e7eb" font-size="13.5" font-weight="700" text-anchor="middle">machine</text>

  <!-- Spokes -->
  <!-- Machinery Reg (top) -->
  <line x1="350" y1="170" x2="350" y2="118" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#b)"/>
  <rect x="245" y="66" width="210" height="52" rx="8" fill="none" stroke="#3b82f6" stroke-width="1.8"/>
  <text x="350" y="88" fill="#3b82f6" font-size="12.5" font-weight="700" text-anchor="middle">Machinery Regulation 2023/1230</text>
  <text x="350" y="106" fill="#94a3b8" font-size="11" text-anchor="middle">safety incl. protection against corruption</text>

  <!-- AI Act (top-left) -->
  <line x1="290" y1="180" x2="150" y2="120" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#b)"/>
  <rect x="30" y="86" width="180" height="52" rx="8" fill="none" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="120" y="108" fill="#e5e7eb" font-size="12.5" font-weight="700" text-anchor="middle">AI Act</text>
  <text x="120" y="126" fill="#94a3b8" font-size="11" text-anchor="middle">AI safety component → high-risk</text>

  <!-- CRA (top-right) -->
  <line x1="410" y1="180" x2="550" y2="120" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#b)"/>
  <rect x="490" y="86" width="180" height="52" rx="8" fill="none" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="580" y="108" fill="#e5e7eb" font-size="12.5" font-weight="700" text-anchor="middle">CRA</text>
  <text x="580" y="126" fill="#94a3b8" font-size="11" text-anchor="middle">product w/ digital elements</text>

  <!-- IEC 62443 (bottom-left) -->
  <line x1="290" y1="220" x2="150" y2="290" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#b)"/>
  <rect x="30" y="292" width="180" height="52" rx="8" fill="none" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="120" y="314" fill="#e5e7eb" font-size="12.5" font-weight="700" text-anchor="middle">IEC 62443 (4-1 / 4-2)</text>
  <text x="120" y="332" fill="#94a3b8" font-size="11" text-anchor="middle">the engineering method</text>

  <!-- NIS2 (bottom-right) -->
  <line x1="410" y1="220" x2="550" y2="290" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#b)"/>
  <rect x="490" y="292" width="180" height="52" rx="8" fill="none" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="580" y="314" fill="#e5e7eb" font-size="12.5" font-weight="700" text-anchor="middle">NIS2</text>
  <text x="580" y="332" fill="#94a3b8" font-size="11" text-anchor="middle">operator of the running line</text>

  <text x="350" y="376" fill="#94a3b8" font-size="11.5" text-anchor="middle">Build it once as one engineering problem — not five audits</text>

  <defs>
    <marker id="b" markerWidth="9" markerHeight="9" refX="5" refY="3" orient="auto">
      <path d="M0,0 L6,3 L0,6 Z" fill="#94a3b8"/>
    </marker>
  </defs>
</svg>
```

### How the frameworks divide the same asset

| Regime | What it governs on the machine | Who it lands on |
|---|---|---|
| **[Machinery Regulation](#)** 2023/1230 | Machine safety, incl. protection against corruption (Annex III) | Manufacturer / substantial modifier |
| **[AI Act](/en/ai-act)** | AI safety component → high-risk lifecycle obligations | Provider of the AI system |
| **[CRA](/en/cra)** | The digital components as products with digital elements — security-by-design, vulnerability handling | Manufacturer of the digital product |
| **[IEC 62443](/en/iec-62443)** | The engineering method: secure development (4-1), component security (4-2) | Builder / integrator of the control system |
| **[NIS2](/en/nis2)** | Running the machinery as part of an essential/important service | The operator |

A builder who treats these as one coherent engineering problem — a single secure-development lifecycle, one risk model, one technical file that satisfies several regimes — spends far less than one running four parallel compliance projects, and ends with a more defensible product. Our [Frameworks](/en/frameworks) view maps where each obligation sits.

### The CRA and the Machinery Regulation — one machine, two mandates

The pairing that most often confuses builders is the [Cyber Resilience Act](/en/cra) and the Machinery Regulation, because both talk about cybersecurity on the same box — yet they ask different questions. The Machinery Regulation asks *"can corruption make this machine unsafe?"* — a **safety** question, answered in the machine's safety case. The CRA asks *"is this product with digital elements secure by design, and will vulnerabilities be handled over its life?"* — a **product-security** question, answered through the CRA's own essential requirements, SBOM and vulnerability-disclosure duties.

The good news is that they are designed to reinforce, not collide. EU guidance is explicit that **compliance with the CRA's cybersecurity requirements can facilitate compliance** with the Machinery Regulation's corruption-protection clauses — the same secure-development evidence, SBOM and update mechanism feed both files. ([ORC WG CRA FAQ](https://cra.orcwg.org/faq/official/faq_2-4-1/)) A builder who runs one secure-development lifecycle produces the artefacts both regimes want; a builder who treats them as two projects pays twice for the same evidence.

### Harmonised standards and the presumption of conformity

As with every New-Legislative-Framework law, the practical route to demonstrating conformity is a **harmonised standard**: apply one whose reference is published in the Official Journal and you gain a **presumption of conformity** with the requirement it covers. For the new cybersecurity clauses the headline instrument is **prEN 50742**, under development specifically to address *protection against corruption* in machinery and safety components — the standard written to operationalise Annex III §1.1.9. ([IBF, prEN 50742](https://www.ibf-solutions.com/en/seminars-and-news/news/new-standard-pren-50742-protection-against-corruption)) Alongside it, the established safety standards (**EN ISO 12100** for risk assessment, **EN ISO 13849** for safety-related control systems) continue to carry the mechanical and functional-safety requirements, and **[IEC 62443](/en/iec-62443)** supplies the recognised engineering method for the control systems inside the machine. Building your evidence against this stack once is what turns a wall of legal clauses into an auditable design.

```cta
One connected machine, five regimes — and you may already be the manufacturer.
Machinery, AI Act, CRA, IEC 62443 and NIS2 can all land on the same line. We build it once, as one engineering problem, not five parallel audits.
Map my machine's obligations :: /en/contact
```

## A worked example: a networked robot welding cell

A builder ships a **robot welding cell**: a six-axis robot, a safety PLC, a light curtain and interlocked doors, an HMI, and a **remote-support VPN** the builder uses for diagnostics and program updates. Under the 2006 Directive this was a well-understood safety product. Under the Regulation, the same cell asks new questions.

- **Where is the corruption risk?** The safety PLC logic, the robot's safety configuration, and the remote-support path. If a forged command over the VPN can relax a speed-and-separation limit, or if the safety PLC accepts an unsigned logic download, the cell can be made unsafe by corruption — squarely within Annex III §1.1.9.
- **What does conformity now require?** The risk assessment must treat corruption as a hazard; the remote path must be authenticated, authorised and segmented; safety firmware must be signed and its integrity verifiable; and interventions must be logged with lifetime retention. The technical file has to *evidence* all of this, not merely assert it.
- **Does a notified body enter?** If the cell's category, or an added ML-based self-evolving safety component, lands it in **Annex I Part A**, self-declaration is off the table and a notified body is mandatory — a lead-time decision that belongs at design time, not at launch.
- **Who owns it after commissioning?** If the operator later adds a new network connection or re-flashes the safety PLC in a way the builder never foresaw, that can be a **substantial modification** under Article 3(16) — and the operator becomes the manufacturer of the modified cell.

One cell, and the safety engineer, the security engineer and the procurement lead are suddenly working the same file. That convergence is the whole point of the Regulation — and the reason a single, shared model of the machine beats four disconnected reviews.

## What it means for your role

**If you build or integrate machinery**, this is a direct obligation with a January 2027 wall. Your safety engineering now has to include cybersecurity, and your technical file has to evidence it. Where connectivity or an AI safety component changes the risk tier, a notified body may enter the loop — and the AI Act may apply on top. The cheap version of this project starts now; the expensive version starts in late 2026.

**If you substantially modify machines** — the daily reality of the plant floor — Article 3(16) can make you the manufacturer of the modified machine, digital changes included. Locate that line before you re-flash a safety controller or add remote access.

**If you operate machinery**, the Regulation raises the security floor of the equipment you buy over time — but only if your procurement asks for it. Start specifying machinery designed to resist corruption, with tamper evidence and a lifecycle patch commitment, in your next tender rather than your next Regulation.

**If you sit on the board**, the exposure is CE-marking and product-liability exposure now wearing a cybersecurity face. A machine made dangerous by a software flaw is a non-conforming product, with the market-access and liability consequences that follow. This belongs on the risk register alongside [NIS2](/en/nis2), not in a separate "IT" column.

## The road to 20 January 2027

The dates are simple; the temptation to treat the gap as idle time is the trap.

```timeline
19 July 2023 :: **Regulation enters into force.** The text is fixed; the transition window opens. Nothing is required yet, but the clock is running.
2023–2026 :: **Transition and preparation.** Machinery may still be placed on the market under Directive 2006/42/EC; builders adapt designs, files and processes. Harmonised standards (incl. prEN 50742) mature.
20 January 2027 :: **The Regulation applies.** Machinery placed on the EU market must meet the new essential requirements — including the cybersecurity-related ones. The Directive is repealed.
After 20 Jan 2027 :: **Lifecycle obligations run.** Protection against corruption, tamper evidence and update delivery must be sustained across each machine's operational life.
```

> [!WARNING]
> The interval to 2027 is *transition time, not idle time.* Folding cybersecurity into the safety case, re-checking conformity routes, engaging a notified body where connectivity or AI changes the risk tier, and designing tamper-evident logging in from the start are all long-lead tasks. A builder who starts in late 2026 will be doing the expensive version of this project.

## A builder's readiness roadmap to January 2027

1. **Inventory your safety-affecting software and connectivity.** For each product line, list the components that affect safety, every external connection, and any AI in a safety function. You cannot secure what you have not mapped. A [Cyber Digital Twin](/en/cyber-digital-twin) is a fast way to build that map.
2. **Fold cybersecurity into the risk assessment.** Corruption of safety-affecting software is now a hazard to be assessed under Annex III, in the same document as mechanical hazards — not a separate report.
3. **Re-check your conformity route.** Does connectivity or an AI safety component push a product into Annex I Part A or Part B? If so, engage a notified body's lead time early.
4. **Adopt the engineering method.** Align the control-system work to **[IEC 62443](/en/iec-62443)** — 4-1 for secure development, 4-2 for component security — so the Annex III clauses have a concrete, auditable implementation.
5. **Build tamper evidence in.** Design the logging of legitimate and illegitimate interventions into the control system, with retention across the machine's life. Retrofitting it later is painful.
6. **Test the AI Act interlock.** For any AI safety component, run the Article 6(1) classification and stand up the high-risk obligations in parallel with the machine's assessment.
7. **Update the technical file and instructions.** Evidence the cybersecurity measures in the file; use the new **digital instructions** allowance where it helps, keeping essential safety information accessible.
8. **Rehearse substantial modification.** Give your integration and service teams a clear Article 3(16) test so they know when a change makes them the manufacturer.

## Frequently asked questions

**When does the Machinery Regulation apply?**
From **20 January 2027**, replacing Machinery Directive 2006/42/EC. It entered into force in July 2023; the interval to 2027 is transition time to adapt products and processes — not idle time, given the new cybersecurity and AI dimensions. ([EU-OSHA](https://osha.europa.eu/en/legislation/directive/regulation-20231230eu-machinery))

**Is cybersecurity really part of machine safety now?**
Yes. Annex III §1.1.9 requires that safety is not compromised by accidental or intentional corruption of safety-affecting hardware and software, and that intervention in safety software leaves evidence. A machine that can be made dangerous by tampering with its software does not meet the Regulation. ([Nemko](https://www.nemko.com/blog/eu-machinery-regulation-2023/1230))

**We add AI to our machines. What extra applies?**
If the AI is a safety component and the machine needs third-party conformity assessment, it is **automatically high-risk** under the [AI Act](/en/ai-act) (Article 6(1) via Annex I). Both regimes then apply to the same product, so plan for them together. ([EU AI Act Annex I](https://artificialintelligenceact.eu/annex/1/))

**Does modifying an existing machine trigger the Regulation?**
It can. A **substantial modification** under Article 3(16) — physical or digital — makes you the manufacturer of the modified machine, with the obligations that follow. Assess before you rework safety-related control systems. ([EU-OSHA](https://osha.europa.eu/en/legislation/directive/regulation-20231230eu-machinery))

**When is a notified body mandatory?**
For **Annex I Part A** categories — the highest-risk machinery, now including machine-learning-based self-evolving safety components — a notified body is required and self-declaration is not available. Part B categories may self-assess only where harmonised standards are applied in full. ([Baker McKenzie](https://www.bakermckenzie.com/en/insight/publications/resources/product-risk-radar-articles/machinery-regulation))

**How is this different from the Cyber Resilience Act?**
They answer different questions about the same machine. The Machinery Regulation asks whether corruption can make the machine *unsafe* (a safety question, in the safety case); the [CRA](/en/cra) asks whether the product with digital elements is *secure by design* with vulnerability handling over its life (a product-security question). They are designed to reinforce each other — CRA compliance can facilitate Machinery-Regulation compliance — so one secure-development lifecycle feeds both files. ([ORC WG CRA FAQ](https://cra.orcwg.org/faq/official/faq_2-4-1/))

**What standard covers the new cybersecurity clauses?**
**prEN 50742** is being developed specifically for *protection against corruption* in machinery and safety components, to operationalise Annex III §1.1.9; applying a published harmonised standard gives a presumption of conformity. EN ISO 12100 and EN ISO 13849 continue to carry risk assessment and safety-related control-system requirements, with IEC 62443 as the engineering method for the control systems. ([IBF, prEN 50742](https://www.ibf-solutions.com/en/seminars-and-news/news/new-standard-pren-50742-protection-against-corruption))

**Do we need an SBOM for our machine?**
It is fast becoming the practical baseline. You must identify and protect the safety-affecting software, which is exactly what a software bill of materials records — and the [CRA](/en/cra) makes the SBOM an explicit obligation for products with digital elements. Building it once serves both regimes.

## How OXOT helps

The Regulation's cybersecurity requirements are, at their core, control-system security requirements for the systems inside a machine — OXOT's home ground. We help machine builders and integrators translate the Annex III essential requirements into an engineering programme aligned to **[IEC 62443](/en/iec-62443)**, so the clauses become an auditable design rather than an aspiration. We help operators fold machinery-security expectations into procurement and into their broader OT security and **[NIS2](/en/nis2)** programmes. And where AI safety components are in play, our **[Cyber Digital Twin](/en/cyber-digital-twin)** locates them in your risk picture so the Machinery Regulation and [AI Act](/en/ai-act) obligations — and the [CRA](/en/cra) overlap — are handled together, once, rather than in four separate scrambles. See how it fits the wider [Frameworks](/en/frameworks) picture.

## Sources

- Regulation (EU) 2023/1230 (Machinery Regulation), official text — [EUR-Lex](https://eur-lex.europa.eu/eli/reg/2023/1230/oj/eng)
- Regulation 2023/1230/EU — machinery, legislation overview — [EU-OSHA](https://osha.europa.eu/en/legislation/directive/regulation-20231230eu-machinery)
- EU Machinery Regulation 2023/1230: cybersecurity obligations for manufacturers — [Nemko](https://www.nemko.com/blog/eu-machinery-regulation-2023/1230)
- Machinery Regulation — high-risk categories and conformity assessment analysis — [Baker McKenzie](https://www.bakermckenzie.com/en/insight/publications/resources/product-risk-radar-articles/machinery-regulation)
- AI Act Annex I — Union harmonisation legislation (incl. machinery) — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/annex/1/)
- prEN 50742 — protection against corruption in machinery and safety components — [IBF Solutions](https://www.ibf-solutions.com/en/seminars-and-news/news/new-standard-pren-50742-protection-against-corruption)
- CRA ↔ Machinery Regulation interplay — [ORC WG CRA FAQ](https://cra.orcwg.org/faq/official/faq_2-4-1/)
- Machinery Regulation compliance, AI & cybersecurity overview — [Intertek](https://www.intertek.com/industrial-equipment/machinery-regulation/)

*This page is general information about EU law, not legal advice. Confirm how the Machinery Regulation applies to your products and role against the Regulation itself and, where needed, qualified counsel.*$MDBODY$, true, $MDBODY$EU Machinery Regulation (EU) 2023/1230 & OT Security | OXOT$MDBODY$, $MDBODY$Regulation (EU) 2023/1230 explained for machine builders and operators — how it replaces the Machinery Directive, makes cybersecurity part of the machine safety case (Annex III), handles AI and self-evolving safety components, the 20 January 2027 deadline, notified-body conformity assessment, and the interlock with the AI Act, CRA, IEC 62443 and NIS2.$MDBODY$, $MDBODY$Machine safety for the connected, software and AI era — where protection against corruption becomes a condition of a machine being safe.$MDBODY$, NULL, $MDBODY$page$MDBODY$, now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET
  title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published,
  meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description,
  excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type,
  published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now()
WHERE length(pages.body) < length(EXCLUDED.body);

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ($MDBODY$machine-act$MDBODY$, $MDBODY$nl$MDBODY$, $MDBODY$De EU-Machineverordening$MDBODY$, $MDBODY$Het grootste deel van de industriële geschiedenis leefden machineveiligheid en cyberbeveiliging in gescheiden werelden. Veiligheidsingenieurs redeneerden over afschermingen, vergrendelingen, lichtschermen en noodstops. Beveiliging, voor zover iemand daar eigenaar van was, was een IT-aangelegenheid die stopte bij de firewall van het kantoor. De **EU-Machineverordening** maakt een einde aan die scheiding. Zij herbouwt het Europese machineveiligheidsregime voor een tijdperk waarin machines genetwerkt, softwaregedreven en in toenemende mate door AI aangestuurd zijn — en doet iets wat de oude wet nooit deed: zij maakt **bescherming tegen corruptie een voorwaarde voor de veiligheid van een machine**.

Die ene ingreep herschrijft de compliance-vraag voor iedereen die machines bouwt, integreert, importeert of aanpast voor de Europese markt. De CE-markering die verklaart dat een machine veilig is, hangt nu mede af van een correcte invulling van cyberbeveiliging. Wie dat mist, heeft niet alleen een onveilige machine — onder de Verordening is die machine niet-conform.

> [!IMPORTANT]
> Verordening (EU) 2023/1230 is op 19 juli 2023 in werking getreden en **is van toepassing vanaf 20 januari 2027**, waarbij Machinerichtlijn 2006/42/EG wordt ingetrokken. Vanaf die datum moeten machines die op de EU-markt worden gebracht voldoen aan de nieuwe essentiële gezondheids- en veiligheidseisen — inclusief de eisen met betrekking tot cyberbeveiliging. ([EUR-Lex](https://eur-lex.europa.eu/eli/reg/2023/1230/oj/eng))

```keyfacts
Instrument :: Verordening (EU) 2023/1230 — rechtstreeks toepasselijk, geen omzetting
Vervangt :: Machinerichtlijn 2006/42/EG
In werking sinds :: 19 juli 2023
Van toepassing vanaf :: 20 januari 2027 (harde deadline)
Cyberclausules :: Bijlage III §1.1.9 (bescherming tegen corruptie) + §1.2.1 (betrouwbaarheid besturing)
Nieuwe hoogrisicocategorie :: op ML gebaseerde zelflerende veiligheidscomponenten (Bijlage I deel A)
Ingrijpende wijziging :: wettelijk gedefinieerd — artikel 3, lid 16
Koppeling AI-verordening :: AI-veiligheidscomponent in machine → automatisch hoogrisico
Belangrijke opkomende norm :: prEN 50742 — bescherming tegen corruptie
```

## De korte versie

- De **Machineverordening (EU) 2023/1230** vervangt de langlopende **Machinerichtlijn 2006/42/EG**. ([EUR-Lex](https://eur-lex.europa.eu/eli/reg/2023/1230/oj/eng))
- Zij is van toepassing vanaf **20 januari 2027** — een harde deadline, geen zachte doelstelling. ([EU-OSHA](https://osha.europa.eu/en/legislation/directive/regulation-20231230eu-machinery))
- Als **verordening** in plaats van een richtlijn is zij **rechtstreeks en identiek** van toepassing in alle 27 lidstaten, wat een einde maakt aan de nationale verschillen die omzetting van een richtlijn toeliet.
- Zij introduceert **essentiële gezondheids- en veiligheidseisen met betrekking tot cyberbeveiliging** in **bijlage III** — machines moeten bestand zijn tegen **toevallige of opzettelijke corruptie** die een gevaar kan opleveren, en moeten **bewijs van manipulatie** bewaren. ([Nemko](https://www.nemko.com/blog/eu-machinery-regulation-2023/1230))
- Zij behandelt **software, connectiviteit en AI**, met inbegrip van machines met **zelflerend gedrag** en **op AI gebaseerde veiligheidscomponenten**.
- Zij koppelt aan de **[AI-verordening](/nl/ai-act)**: een AI-systeem dat als veiligheidscomponent van een machine wordt gebruikt en dat zelf een conformiteitsbeoordeling door een derde partij nodig heeft, is **automatisch hoogrisico**. ([Bijlage I EU AI-verordening](https://artificialintelligenceact.eu/annex/1/))

## Waarom de oude richtlijn tekortschoot in het connectiviteitstijdperk

De Machinerichtlijn is een product van 2006 — een wereld van vóór het industriële IoT gemeengoed werd, van vóór een pers of palletiseerder routinematig met een netwerk communiceerde, van vóór machine-learningmodellen in een veiligheidslus plaatsnamen. Op zichzelf was het een goede wet. Zij bracht orde in mechanische, elektrische, thermische en ergonomische gevaren, en gaf Europa twee decennia lang een gemeenschappelijke veiligheidsgrammatica.

Waar zij nooit in voorzag, is een machine die mechanisch foutloos is maar gevaarlijk wordt doordat iemand de besturingslogica corrumpeert. Een afscherming is waardeloos als een vervalst netwerkcommando haar intrekt. Een noodstopfunctie is waardeloos als de firmware ervan stilzwijgend kan worden overschreven. Een perfect gedimensioneerd veiligheidsrelais is waardeloos als de veiligheids-PLC die het aanstuurt ongeauthenticeerde instructies accepteert vanuit een portaal voor onderhoud op afstand. De Richtlijn had daar niets over te zeggen, omdat die aanvalsoppervlakken in 2006 nauwelijks bestonden op de fabrieksvloer.

De Verordening is de correctie. Zij behoudt de beproefde architectuur van de EU-productveiligheidswetgeving — essentiële gezondheids- en veiligheidseisen, risicobeoordeling, conformiteitsbeoordeling, CE-markering, een conformiteitsverklaring — en breidt die architectuur uit naar de **digitale** manieren waarop een moderne machine onveilig wordt. Twee structurele keuzes maken de intentie duidelijk.

**Het is een verordening, geen richtlijn.** Een richtlijn is een doel dat elke lidstaat omzet in nationale wetgeving, waardoor "de Machinerichtlijn" in feite 27 licht verschillende wetten betekende. Een verordening is de wet, in elk land, op dezelfde dag. Eén Europees regelboek, geen vertraging door omzetting, veel minder ruimte voor een machine die in de ene markt legaal is en in de andere niet.

**Zij plaatst beveiliging binnen het veiligheidsdossier, niet ernaast.** De Verordening creëert geen apart "cyberbijlage" die u er later bij kunt plakken. Zij weeft corruptiebestendigheid, veilige connectiviteit en bewijs van manipulatie door dezelfde essentiële eisen die gelden voor afscherming en betrouwbaarheid van de besturing. Beveiliging is nu iets waar uw veiligheidsingenieurs eigenaar van zijn, aangetoond in hetzelfde technisch dossier.

### Richtlijn 2006/42/EG versus Verordening (EU) 2023/1230

| Dimensie | Machine**richtlijn** 2006/42/EG | Machine**verordening** (EU) 2023/1230 |
|---|---|---|
| Rechtsinstrument | Richtlijn — omgezet in 27 nationale wetten | Verordening — rechtstreeks toepasselijk, uniform EU-breed |
| Van toepassing vanaf | 29 december 2009 | **20 januari 2027** ([EU-OSHA](https://osha.europa.eu/en/legislation/directive/regulation-20231230eu-machinery)) |
| Cyberbeveiliging | Feitelijk geen bepalingen | Expliciete essentiële eisen inzake **bescherming tegen corruptie** en veilige verbindingen (bijlage III) |
| Software & AI | Niet als zodanig behandeld | Softwareveiligheidscomponenten en **AI/zelflerend** gedrag binnen de reikwijdte |
| Hoogrisicolijst | Bijlage IV; zelfcertificering breed beschikbaar | **Bijlage I** (delen A/B); deel A maakt beoordeling door een **aangemelde instantie** verplicht |
| Instructies | Papieren handleiding doorgaans verplicht | **Digitale instructies** toegestaan (met uitzonderingen voor veiligheidsinformatie) |
| Ingrijpende wijziging | Behandeld via nationale praktijk/richtsnoeren | **Wettelijk gedefinieerd** (art. 3, lid 16); de wijzigende partij wordt de fabrikant |

## Wat de Verordening bestrijkt

De Verordening is van toepassing op **machines** en een familie van **gerelateerde producten**: veiligheidscomponenten, verwisselbare uitrustingsstukken, hijs- en hefgereedschappen, kettingen, kabels en banden, verwijderbare mechanische overbrengingssystemen, en **niet-voltooide machines** — een samenstel dat nog geen toepassing op zichzelf kan uitvoeren en bestemd is om in andere machines te worden ingebouwd. ([EU-OSHA](https://osha.europa.eu/en/legislation/directive/regulation-20231230eu-machinery))

Twee punten zijn het belangrijkst voor het digitale tijdperk:

**Veiligheidscomponenten zijn producten op zichzelf.** Een veiligheidscomponent is een onderdeel waarvan het falen mensen in gevaar brengt, en de Verordening is expliciet dat dit nu **software** omvat die een veiligheidsfunctie vervult, en, specifiek genoemd, **op AI gebaseerde** veiligheidscomponenten. Als het uw product de taak is om een machine veilig te houden, draagt het de eisen — of het nu een lichtscherm, een veiligheidsregelaar, of een getraind model is dat beslist wanneer een collaboratieve robot moet stoppen.

**Zelflerend gedrag wordt voorzien, niet genegeerd.** De Verordening houdt rekening met machines waarvan het gedrag zich kan aanpassen of leren nadat zij de fabriek hebben verlaten, en staat niet toe dat die ontwikkeling buiten de veilige gebruiksgrenzen treedt die bij de conformiteitsbeoordeling zijn gevalideerd. Leren is toegestaan; afdrijven naar een gevaarlijke toestand niet.

Naast de technologie moderniseert de Verordening ook de papierwinkel. Zij staat **digitale instructies en documentatie** toe in plaats van een verplichte gedrukte handleiding in elk geval (met verstandige uitzonderingen zodat essentiële veiligheidsinformatie toegankelijk blijft), en zij legt de regels over **ingrijpende wijziging** vast in de wet zelf — meer daarover hieronder.

## Cyberbeveiliging wordt onderdeel van het veiligheidsdossier

Hier zit de kern van de verandering voor iedereen in OT. De essentiële gezondheids- en veiligheidseisen van de Verordening, vastgelegd in **bijlage III**, bevatten nu clausules die relevant zijn voor cyberbeveiliging. De duidelijkste is **bijlage III, §1.1.9, "Bescherming tegen corruptie."** In gewone woorden: een machine moet zo zijn ontworpen dat de veiligheid ervan **niet in gevaar komt door corruptie — hetzij toevallig, hetzij opzettelijk** — van de hardware- en softwarecomponenten die de veiligheid beïnvloeden. ([Nemko](https://www.nemko.com/blog/eu-machinery-regulation-2023/1230))

Lees dat zorgvuldig, want de formulering is precies en die precisie is de kern van de zaak.

- De zorg betreft **veiligheid**, niet vertrouwelijkheid. De Verordening vraagt u niet om bedrijfsgeheimen te beschermen; zij vraagt u ervoor te zorgen dat corruptie de machine niet in een gevaar kan veranderen.
- Zij bestrijkt zowel **toevallige als opzettelijke** corruptie — een misvormde update, een verkeerd geflashte controller, een bitflip op een bus, en een doelbewuste aanvaller vallen allemaal binnen de reikwijdte.
- Zij richt zich op de componenten **die de veiligheid beïnvloeden**. De bedrijfslogica-HMI van een machine is niet het doelwit; de veiligheidsfunctie en de systemen die haar kunnen beïnvloeden, wel.

Uit die clausule, en de eisen inzake betrouwbaarheid van de besturing in **bijlage III, §1.2.1**, volgt een concrete reeks technische verwachtingen.

### De essentiële eisen met betrekking tot cyberbeveiliging, in technische termen

| Eis (zoals verwoord in bijlage III) | Wat het op de machine betekent |
|---|---|
| Veiligheid niet in gevaar door **toevallige of opzettelijke corruptie** van veiligheidsbeïnvloedende hardware/software (§1.1.9) | Veiligheidsgerelateerde besturingslogica en firmware moeten bestand zijn tegen manipulatie; corruptie ervan mag geen veiligheidsfunctie kunnen omzeilen |
| **Bewijs van interventie** in veiligheidssoftware | Het besturingssysteem moet legitieme en illegitieme interventies **loggen**, zodat manipulatie detecteerbaar en traceerbaar is — bewijs van manipulatie, bewaard gedurende de levensduur van de machine ([Nemko](https://www.nemko.com/blog/eu-machinery-regulation-2023/1230)) |
| Veilige **verbinding** met externe apparaten (§1.2.1) | Draadloze, genetwerkte en toegang-op-afstand-functies mogen geen gevaarlijke situatie creëren; een slechte of vijandige verbinding mag geen veiligheidsfunctie kunnen bereiken |
| **Robuuste veiligheidsfuncties** onder externe invloed | Veiligheidsfuncties moeten betrouwbaar blijven bij redelijkerwijs te voorziene externe invloed via verbindingen, niet alleen onder laboratoriumomstandigheden |
| **Levenscyclusonderhoud** van bescherming | Beschermende maatregelen, updates en patches moeten houdbaar zijn gedurende de operationele levensduur van de machine, niet bevroren op het moment van levering |

Dit is een echte herkadering, geen relabeling. Cyberbeveiliging voor machines is niet langer een parallel werkspoor dat naast veiligheid loopt en aan een andere manager rapporteert. Zij zit **binnen** het veiligheidsargument. Als een machine gevaarlijk kan worden gemaakt door corruptie van de software, dan is zij — in de logica van de Verordening — niet veilig, en voldoet zij niet. De beveiligingsfout en de veiligheidsfout zijn dezelfde fout.

### Wat "bescherming tegen corruptie" daadwerkelijk vereist

De Verordening formuleert de *uitkomst* — de veiligheid moet corruptie overleven — en laat het *hoe* over aan techniek en normen. In de praktijk convergeert het voldoen aan bijlage III §1.1.9 en §1.2.1 op een echte machine naar een herkenbare set maatregelen, dezelfde die een beveiligingsingenieur voor besturingssystemen zou kiezen:

- **Ken uw software.** Identificeer de veiligheidsbeïnvloedende software en data — steeds vaker vastgelegd als een **software bill of materials (SBOM)** — want u kunt geen componenten beschermen die u niet heeft opgesomd. Dit is ook de naadlijn met de [CRA](/nl/cra), die de SBOM tot een expliciete verplichting maakt.
- **Authenticeer wat draait.** **Ondertekende firmware** en een **secure/verified boot**-keten, zodat een gewijzigde veiligheidsimage wordt geweigerd in plaats van uitgevoerd. Het voorbeeld van de Verordening is bot: als iemand gewijzigde veiligheidsfirmware installeert, moet de machine dat kunnen detecteren.
- **Authenticeer wie verbindt.** Veiligheidsrelevante instructies mogen alleen komen van geauthenticeerde, geautoriseerde bronnen. Een ongeauthenticeerd commando vanuit een portaal voor onderhoud op afstand mag nooit een veiligheidsfunctie kunnen bereiken.
- **Beperk de verbinding.** Genetwerkte, draadloze en toegang-op-afstand-functies moeten zo zijn ontworpen dat een slechte of vijandige verbinding geen gevaarlijke situatie kan creëren — segmentatie, minimale rechten, en een veilige terugvalstand als de verbinding zich misdraagt.
- **Maak manipulatie zichtbaar.** Log zowel **legitieme als illegitieme** interventies in veiligheidssoftware, met bewaring gedurende de operationele levensduur van de machine, zodat corruptie achteraf detecteerbaar en traceerbaar is.
- **Houd bescherming in stand over de levenscyclus.** Updates en patches voor de veiligheidsbeïnvloedende software moeten leverbaar blijven zolang de machine in bedrijf is — bescherming bevroren op de leverdatum is geen bescherming.

```compare
Het veiligheidsdossier overleeft corruptie wanneer…
- Veiligheidsbeïnvloedende software is **geïnventariseerd** (SBOM) en de integriteit is verifieerbaar
- Firmware is **ondertekend** en boot is **geverifieerd** — gewijzigde images worden geweigerd
- Toegang op afstand en via netwerk is **geauthenticeerd, geautoriseerd en gesegmenteerd**
- Interventies worden **gelogd en bewaard** — manipulatie laat bewijs achter
- Patches en updates blijven **leverbaar gedurende de levensduur** van de machine
---
De machine is niet-conform wanneer…
- Een **vervalst netwerkcommando** een afscherming kan intrekken of een vergrendeling omzeilen
- Veiligheids**firmware stilzwijgend kan worden overschreven** en uitgevoerd
- Een **portaal voor onderhoud op afstand** een veiligheidsfunctie ongeauthenticeerd bereikt
- Manipulatie van veiligheidssoftware **geen spoor achterlaat**
- Beveiliging **niet kan worden onderhouden** nadat de machine is geleverd
```

Niets hiervan is nieuw voor een beveiligingsingenieur — en dat is precies het punt. De Verordening vindt geen nieuwe discipline uit; zij importeert een bestaande, [IEC 62443](/nl/iec-62443), in het machineveiligheidsdossier en maakt haar tot een voorwaarde voor de CE-markering.

```svg
<svg viewBox="0 0 700 340" xmlns="http://www.w3.org/2000/svg" font-family="system-ui,Segoe UI,Roboto,sans-serif">
  <rect x="0" y="0" width="700" height="340" fill="none"/>
  <text x="350" y="28" fill="#e5e7eb" font-size="17" font-weight="700" text-anchor="middle">Cyberbeveiliging als onderdeel van het machineveiligheidsdossier</text>

  <!-- Outer safety case boundary -->
  <rect x="30" y="50" width="640" height="260" rx="12" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="46" y="72" fill="#3b82f6" font-size="13" font-weight="700">Veiligheidsdossier machine → CE-markering &amp; conformiteitsverklaring</text>

  <!-- Traditional safety block -->
  <rect x="55" y="92" width="285" height="88" rx="8" fill="none" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="197" y="114" fill="#e5e7eb" font-size="13" font-weight="700" text-anchor="middle">Functionele / mechanische veiligheid</text>
  <text x="197" y="136" fill="#94a3b8" font-size="11.5" text-anchor="middle">Afschermingen · vergrendelingen · noodstop</text>
  <text x="197" y="153" fill="#94a3b8" font-size="11.5" text-anchor="middle">Betrouwbaarheid besturing · risicobeoordeling</text>
  <text x="197" y="170" fill="#94a3b8" font-size="11.5" text-anchor="middle">EN ISO 12100 / 13849</text>

  <!-- Cyber block -->
  <rect x="360" y="92" width="285" height="88" rx="8" fill="none" stroke="#f97316" stroke-width="1.5"/>
  <text x="502" y="114" fill="#f97316" font-size="13" font-weight="700" text-anchor="middle">Bescherming tegen corruptie</text>
  <text x="502" y="136" fill="#94a3b8" font-size="11.5" text-anchor="middle">Antimanipulatie · veilige verbindingen</text>
  <text x="502" y="153" fill="#94a3b8" font-size="11.5" text-anchor="middle">Logging van manipulatiebewijs</text>
  <text x="502" y="170" fill="#94a3b8" font-size="11.5" text-anchor="middle">Bijlage III §1.1.9 / §1.2.1</text>

  <!-- Merge arrow -->
  <line x1="197" y1="180" x2="197" y2="210" stroke="#94a3b8" stroke-width="1.5"/>
  <line x1="502" y1="180" x2="502" y2="210" stroke="#94a3b8" stroke-width="1.5"/>
  <line x1="197" y1="210" x2="502" y2="210" stroke="#94a3b8" stroke-width="1.5"/>
  <line x1="350" y1="210" x2="350" y2="238" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#a)"/>
  <defs>
    <marker id="a" markerWidth="9" markerHeight="9" refX="5" refY="3" orient="auto">
      <path d="M0,0 L6,3 L0,6 Z" fill="#94a3b8"/>
    </marker>
  </defs>

  <rect x="205" y="240" width="290" height="52" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="350" y="262" fill="#e5e7eb" font-size="13" font-weight="700" text-anchor="middle">Eén geïntegreerd veiligheidsargument</text>
  <text x="350" y="281" fill="#94a3b8" font-size="11.5" text-anchor="middle">Corrumpeerbare veiligheid = onveilig = niet-conform</text>
</svg>
```

> [!NOTE]
> Nieuwe normen sluiten aan bij de clausules. **EN 50742** (in ontwikkeling) behandelt bescherming tegen corruptie in machines en veiligheidscomponenten; **IEC 62443** levert de erkende technische methode voor de besturingssystemen binnen een machine; **ISO/CD 24882** richt zich op cyberbeveiliging voor landbouwmachines. Verwacht dat geharmoniseerde normen de praktische route worden om conformiteit te vermoeden. ([Nemko](https://www.nemko.com/blog/eu-machinery-regulation-2023/1230))

## Software, connectiviteit en AI — en de koppeling met de AI-verordening

De Verordening is doelbewust vooruitstrevend op het gebied van software en AI. Zij erkent machines waarvan het gedrag kan **evolueren** — systemen die zich aanpassen of leren tijdens gebruik — en eist dat die ontwikkeling de machine niet buiten de veilige gebruiksgrenzen kan brengen die bij de beoordeling zijn bewezen. Waar AI een veiligheidsfunctie vervult, moet de machine rekening houden met wat AI daadwerkelijk met zich meebrengt: gedrag dat lastig uitputtend te testen is, beslissingen die lastig te verklaren zijn, en een blijvende behoefte aan zinvol menselijk toezicht op geautomatiseerde actie.

Dit is precies waar de Machineverordening en de **[AI-verordening](/nl/ai-act)** op elkaar zijn afgestemd. De Machineverordening staat vermeld in **bijlage I van de AI-verordening** als harmonisatiewetgeving van de Unie. Op grond van **artikel 6, lid 1, van de AI-verordening** wordt een AI-systeem dat een **veiligheidscomponent** is van een product dat onder die bijlage I-wetgeving valt — en waarbij het product een conformiteitsbeoordeling door een derde partij moet ondergaan — **automatisch als hoogrisico geclassificeerd**. ([Bijlage I EU AI-verordening](https://artificialintelligenceact.eu/annex/1/))

Het gevolg is concreet. Zet u een AI-model in als veiligheidscomponent in machines die onder de route van de aangemelde instantie vallen, dan bent u tegelijkertijd de fabrikant van een hoogrisico-AI-systeem. Twee regimes, één product, tegelijkertijd:

- De **Machineverordening** regelt de veiligheid-en-beveiliging van de machine (risicobeoordeling, essentiële eisen van bijlage III, conformiteitsbeoordeling, technisch dossier, CE-markering).
- De **AI-verordening** voegt daar de hoogrisicoverplichtingen voor het model zelf aan toe: risicobeheer, datagovernance, logging, transparantie, menselijk toezicht, nauwkeurigheid en robuustheid, en een kwaliteitsmanagementsysteem.

> [!WARNING]
> Een AI-veiligheidscomponent is niet "een beetje extra papierwerk." Op grond van artikel 6, lid 1, kan zij uw product verplaatsen van een zelfverklaringsroute naar **conformiteitsbeoordeling door een derde partij bij een aangemelde instantie**, en zij activeert tegelijkertijd de hoogrisicolevenscyclus van de AI-verordening. Die overlap ontdekken tijdens de beoordeling, enkele maanden voor een lancering, is een van de duurste manieren om dit te leren. Breng het in kaart tijdens het ontwerp. Zie [AI-verordening](/nl/ai-act).

## Conformiteitsbeoordeling en hoogrisicomachines

Net als de Richtlijn vóór haar classificeert de Verordening machines naar risico en biedt zij evenredige routes naar CE-markering. De meeste machines kunnen nog steeds via **zelfbeoordeling** door de fabrikant (interne productiecontrole) op de markt komen. De hogerisicocategorieën staan vermeld in **bijlage I**, opgesplitst in twee delen, en hier komt de aangemelde instantie in beeld.

- **Bijlage I, deel A** — de categorieën die de Verordening als het hoogste risico behandelt. Voor deze categorieën is **conformiteitsbeoordeling door een aangemelde instantie verplicht**; de fabrikant kan niet zelf verklaren. Deel A omvat nu **veiligheidscomponenten met volledig of gedeeltelijk zelflerend gedrag met gebruik van machine-learningbenaderingen die veiligheidsfuncties waarborgen** — een categorie die onder de Richtlijn van 2006 niet bestond en niet kon bestaan. ([Baker McKenzie](https://www.bakermckenzie.com/en/insight/publications/resources/product-risk-radar-articles/machinery-regulation))
- **Bijlage I, deel B** — hoogrisicocategorieën die grotendeels vergelijkbaar zijn met de oude bijlage IV, waarbij een fabrikant alleen een zelfbeoordelingsroute mag gebruiken **indien** de relevante geharmoniseerde normen volledig zijn toegepast; anders is een aangemelde instantie vereist.

### Risicocategorie → conformiteitsroute

| Machinecategorie | Risiconiveau | Conformiteitsroute |
|---|---|---|
| Gewone machines (niet in bijlage I) | Standaard | **Zelfbeoordeling** door de fabrikant (interne productiecontrole) |
| Hoogrisico **bijlage I, deel B** | Hoog | Zelfbeoordeling **alleen indien** geharmoniseerde normen volledig zijn toegepast; anders **aangemelde instantie** |
| **Bijlage I, deel A** (incl. **op ML gebaseerde zelflerende veiligheidscomponenten**) | Hoogst | **Aangemelde instantie verplicht** — geen zelfverklaring ([Baker McKenzie](https://www.bakermckenzie.com/en/insight/publications/resources/product-risk-radar-articles/machinery-regulation)) |

De praktische conclusie: het toevoegen van connectiviteit of AI aan een machine is geen neutrale productkeuze. Het kan de risicoclassificatie van de machine veranderen, de conformiteitsroute, of een aangemelde instantie betrokken is, en daarmee de kosten en doorlooptijd naar de markt. Die beslissing hoort aan het begin van een project thuis, met uw veiligheids- en beveiligingsingenieurs samen aan tafel.

## Ingrijpende wijziging: wanneer de fabrieksvloer de fabrikant wordt

Eén bepaling verdient een eigen podium, omdat zij integrators en exploitanten raakt die denken dat de Verordening alleen een probleem van de bouwer is. De Verordening **definieert ingrijpende wijziging in de wet**, in **artikel 3, lid 16**: een wijziging van een machine, met fysieke of digitale middelen, aangebracht nadat zij op de markt is gebracht of in bedrijf is gesteld, die de oorspronkelijke fabrikant niet heeft voorzien of gepland, en die de veiligheid beïnvloedt door een nieuw gevaar te creëren of een bestaand risico zodanig te verhogen dat nieuwe beschermende maatregelen nodig zijn. ([EU-OSHA](https://osha.europa.eu/en/legislation/directive/regulation-20231230eu-machinery))

De angel zit in het gevolg. Wie een ingrijpende wijziging uitvoert, wordt **beschouwd als de fabrikant** van de gewijzigde machine en neemt de verplichtingen van de fabrikant op grond van artikel 10 over — een nieuwe risicobeoordeling, conformiteitsbeoordeling, technisch dossier, conformiteitsverklaring en CE-markering voor de gewijzigde machine. En omdat de definitie expliciet **digitale** middelen noemt, kan een wijziging van besturingssoftware, een nieuwe netwerkverbinding, of een achteraf toegevoegde AI-functie de ingrijpende wijziging zijn die de aansprakelijkheid van de fabrikant op u overdraagt.

> [!TIP]
> Voordat u een veiligheidsgerelateerd besturingssysteem aanpast — een veiligheids-PLC opnieuw flasht, toegang op afstand toevoegt, een lerend model inbouwt — beoordeel of de wijziging een ingrijpende wijziging is onder artikel 3, lid 16. Zo ja, dan heeft u zojuist de verplichtingen van een fabrikant geërfd. Die grens kennen **voordat** u de machine aanraakt, is veel goedkoper dan haar ontdekken na een incident. Een [Cyber Digital Twin](/nl/cyber-digital-twin) maakt die wijzigingsgrenzen zichtbaar.

## De stapel van meerdere kaders rond een slimme machine

De Machineverordening opereert niet alleen. Eén enkele connected, AI-ondersteunde productielijn kan vijf Europese regimes tegelijk binnen de reikwijdte trekken, elk gericht op een ander facet van hetzelfde asset. Ze behandelen als vijf losstaande audits is de manier waarop programma's uit de hand lopen qua budget; ze behandelen als één technisch probleem is de manier waarop ze in één keer worden gebouwd.

```svg
<svg viewBox="0 0 700 400" xmlns="http://www.w3.org/2000/svg" font-family="system-ui,Segoe UI,Roboto,sans-serif">
  <rect x="0" y="0" width="700" height="400" fill="none"/>
  <text x="350" y="28" fill="#e5e7eb" font-size="17" font-weight="700" text-anchor="middle">Eén connected/AI-machine → vijf regimes tegelijk</text>

  <!-- Center node -->
  <rect x="270" y="170" width="160" height="60" rx="10" fill="none" stroke="#f97316" stroke-width="2.5"/>
  <text x="350" y="196" fill="#e5e7eb" font-size="13.5" font-weight="700" text-anchor="middle">Connected / AI-</text>
  <text x="350" y="214" fill="#e5e7eb" font-size="13.5" font-weight="700" text-anchor="middle">machine</text>

  <!-- Spokes -->
  <!-- Machinery Reg (top) -->
  <line x1="350" y1="170" x2="350" y2="118" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#b)"/>
  <rect x="245" y="66" width="210" height="52" rx="8" fill="none" stroke="#3b82f6" stroke-width="1.8"/>
  <text x="350" y="88" fill="#3b82f6" font-size="12.5" font-weight="700" text-anchor="middle">Machineverordening 2023/1230</text>
  <text x="350" y="106" fill="#94a3b8" font-size="11" text-anchor="middle">veiligheid incl. bescherming tegen corruptie</text>

  <!-- AI Act (top-left) -->
  <line x1="290" y1="180" x2="150" y2="120" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#b)"/>
  <rect x="30" y="86" width="180" height="52" rx="8" fill="none" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="120" y="108" fill="#e5e7eb" font-size="12.5" font-weight="700" text-anchor="middle">AI-verordening</text>
  <text x="120" y="126" fill="#94a3b8" font-size="11" text-anchor="middle">AI-veiligheidscomponent → hoogrisico</text>

  <!-- CRA (top-right) -->
  <line x1="410" y1="180" x2="550" y2="120" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#b)"/>
  <rect x="490" y="86" width="180" height="52" rx="8" fill="none" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="580" y="108" fill="#e5e7eb" font-size="12.5" font-weight="700" text-anchor="middle">CRA</text>
  <text x="580" y="126" fill="#94a3b8" font-size="11" text-anchor="middle">product met digitale elementen</text>

  <!-- IEC 62443 (bottom-left) -->
  <line x1="290" y1="220" x2="150" y2="290" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#b)"/>
  <rect x="30" y="292" width="180" height="52" rx="8" fill="none" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="120" y="314" fill="#e5e7eb" font-size="12.5" font-weight="700" text-anchor="middle">IEC 62443 (4-1 / 4-2)</text>
  <text x="120" y="332" fill="#94a3b8" font-size="11" text-anchor="middle">de technische methode</text>

  <!-- NIS2 (bottom-right) -->
  <line x1="410" y1="220" x2="550" y2="290" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#b)"/>
  <rect x="490" y="292" width="180" height="52" rx="8" fill="none" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="580" y="314" fill="#e5e7eb" font-size="12.5" font-weight="700" text-anchor="middle">NIS2</text>
  <text x="580" y="332" fill="#94a3b8" font-size="11" text-anchor="middle">exploitant van de draaiende lijn</text>

  <text x="350" y="376" fill="#94a3b8" font-size="11.5" text-anchor="middle">Bouw het één keer als één technisch probleem — niet als vijf audits</text>

  <defs>
    <marker id="b" markerWidth="9" markerHeight="9" refX="5" refY="3" orient="auto">
      <path d="M0,0 L6,3 L0,6 Z" fill="#94a3b8"/>
    </marker>
  </defs>
</svg>
```

### Hoe de kaders hetzelfde asset verdelen

| Regime | Wat het op de machine regelt | Op wie het neerkomt |
|---|---|---|
| **[Machineverordening](#)** 2023/1230 | Machineveiligheid, incl. bescherming tegen corruptie (bijlage III) | Fabrikant / wijzigende partij bij ingrijpende wijziging |
| **[AI-verordening](/nl/ai-act)** | AI-veiligheidscomponent → hoogrisicolevenscyclusverplichtingen | Aanbieder van het AI-systeem |
| **[CRA](/nl/cra)** | De digitale componenten als producten met digitale elementen — security-by-design, omgang met kwetsbaarheden | Fabrikant van het digitale product |
| **[IEC 62443](/nl/iec-62443)** | De technische methode: veilige ontwikkeling (4-1), componentbeveiliging (4-2) | Bouwer / integrator van het besturingssysteem |
| **[NIS2](/nl/nis2)** | Het exploiteren van de machine als onderdeel van een essentiële/belangrijke dienst | De exploitant |

Een bouwer die dit behandelt als één samenhangend technisch probleem — één veilige ontwikkelingslevenscyclus, één risicomodel, één technisch dossier dat aan meerdere regimes voldoet — besteedt veel minder dan wie vier parallelle compliance-projecten uitvoert, en eindigt met een beter verdedigbaar product. Ons overzicht [Kaders](/nl/frameworks) brengt in kaart waar elke verplichting past.

### De CRA en de Machineverordening — één machine, twee mandaten

Het koppel dat bouwers het vaakst verwart is de [Cyber Resilience Act](/nl/cra) en de Machineverordening, omdat beide over cyberbeveiliging op dezelfde kast spreken — maar ze stellen verschillende vragen. De Machineverordening vraagt *"kan corruptie deze machine onveilig maken?"* — een **veiligheids**vraag, beantwoord in het veiligheidsdossier van de machine. De CRA vraagt *"is dit product met digitale elementen secure-by-design, en worden kwetsbaarheden over de levensduur beheerd?"* — een **productbeveiligings**vraag, beantwoord via de eigen essentiële eisen, SBOM- en kwetsbaarheidsmeldplichten van de CRA.

Het goede nieuws is dat ze zijn ontworpen om elkaar te versterken, niet te botsen. EU-richtsnoeren zijn expliciet dat **naleving van de cyberbeveiligingseisen van de CRA de naleving kan vergemakkelijken** van de corruptiebeschermingsclausules van de Machineverordening — dezelfde bewijzen van veilige ontwikkeling, SBOM en updatemechanisme voeden beide dossiers. ([ORC WG CRA-FAQ](https://cra.orcwg.org/faq/official/faq_2-4-1/)) Een bouwer die één veilige ontwikkelingslevenscyclus draait, produceert de artefacten die beide regimes willen; wie ze als twee projecten behandelt, betaalt twee keer voor hetzelfde bewijs.

### Geharmoniseerde normen en het vermoeden van conformiteit

Zoals bij elke wet binnen het Nieuwe Wetgevingskader is de praktische route om conformiteit aan te tonen een **geharmoniseerde norm**: pas er een toe waarvan de referentie in het Publicatieblad is gepubliceerd en u verkrijgt een **vermoeden van conformiteit** met de eis die zij dekt. Voor de nieuwe cyberbeveiligingsclausules is het belangrijkste instrument **prEN 50742**, in ontwikkeling om specifiek *bescherming tegen corruptie* in machines en veiligheidscomponenten te behandelen — de norm geschreven om bijlage III §1.1.9 te operationaliseren. ([IBF, prEN 50742](https://www.ibf-solutions.com/en/seminars-and-news/news/new-standard-pren-50742-protection-against-corruption)) Daarnaast blijven de gevestigde veiligheidsnormen (**EN ISO 12100** voor risicobeoordeling, **EN ISO 13849** voor veiligheidsgerelateerde besturingssystemen) de mechanische en functionele-veiligheidseisen dragen, en levert **[IEC 62443](/nl/iec-62443)** de erkende technische methode voor de besturingssystemen binnen de machine. Uw bewijs één keer opbouwen tegen deze stapel is wat een muur van juridische clausules verandert in een controleerbaar ontwerp.

```cta
Eén connected machine, vijf regimes — en u bent mogelijk al de fabrikant.
Machineverordening, AI-verordening, CRA, IEC 62443 en NIS2 kunnen allemaal op dezelfde lijn neerkomen. Wij bouwen het één keer, als één technisch probleem, niet vijf parallelle audits.
Breng de verplichtingen van mijn machine in kaart :: /nl/contact
```

## Een uitgewerkt voorbeeld: een genetwerkte robotlascel

Een bouwer levert een **robotlascel**: een zesassige robot, een veiligheids-PLC, een lichtscherm en vergrendelde deuren, een HMI, en een **VPN voor ondersteuning op afstand** die de bouwer gebruikt voor diagnostiek en programma-updates. Onder de Richtlijn van 2006 was dit een goed begrepen veiligheidsproduct. Onder de Verordening stelt dezelfde cel nieuwe vragen.

- **Waar zit het corruptierisico?** De logica van de veiligheids-PLC, de veiligheidsconfiguratie van de robot, en het pad voor ondersteuning op afstand. Als een vervalst commando via de VPN een snelheids-en-scheidingslimiet kan versoepelen, of als de veiligheids-PLC een ongetekende logica-download accepteert, kan de cel onveilig worden gemaakt door corruptie — recht binnen bijlage III §1.1.9.
- **Wat vereist conformiteit nu?** De risicobeoordeling moet corruptie als een gevaar behandelen; het pad op afstand moet geauthenticeerd, geautoriseerd en gesegmenteerd zijn; veiligheidsfirmware moet ondertekend en de integriteit verifieerbaar zijn; en interventies moeten worden gelogd met levenslange bewaring. Het technisch dossier moet dit alles *aantonen*, niet slechts beweren.
- **Komt er een aangemelde instantie bij?** Als de categorie van de cel, of een toegevoegde op ML gebaseerde zelflerende veiligheidscomponent, haar in **bijlage I deel A** plaatst, is zelfverklaring van tafel en is een aangemelde instantie verplicht — een doorlooptijdbeslissing die bij het ontwerp thuishoort, niet bij de lancering.
- **Wie is er eigenaar na inbedrijfstelling?** Als de exploitant later een nieuwe netwerkverbinding toevoegt of de veiligheids-PLC opnieuw flasht op een manier die de bouwer nooit voorzag, kan dat een **ingrijpende wijziging** zijn onder artikel 3, lid 16 — en wordt de exploitant de fabrikant van de gewijzigde cel.

Eén cel, en de veiligheidsingenieur, de beveiligingsingenieur en de inkoopverantwoordelijke werken opeens aan hetzelfde dossier. Die convergentie is de hele bedoeling van de Verordening — en de reden waarom één gedeeld model van de machine vier losstaande beoordelingen verslaat.

## Wat het betekent voor uw rol

**Als u machines bouwt of integreert**, is dit een directe verplichting met een muur op januari 2027. Uw veiligheidsengineering moet nu cyberbeveiliging omvatten, en uw technisch dossier moet dit aantonen. Waar connectiviteit of een AI-veiligheidscomponent het risiconiveau verandert, kan een aangemelde instantie in beeld komen — en de AI-verordening kan daar bovenop van toepassing zijn. De goedkope versie van dit project begint nu; de dure versie begint eind 2026.

**Als u machines ingrijpend wijzigt** — de dagelijkse realiteit van de fabrieksvloer — kan artikel 3, lid 16, u de fabrikant maken van de gewijzigde machine, digitale wijzigingen inbegrepen. Bepaal die grens voordat u een veiligheidsregelaar opnieuw flasht of toegang op afstand toevoegt.

**Als u machines exploiteert**, verhoogt de Verordening de beveiligingsondergrens van de apparatuur die u in de loop van de tijd koopt — maar alleen als uw inkoop daarom vraagt. Begin met het specificeren van machines die ontworpen zijn om corruptie te weerstaan, met bewijs van manipulatie en een toezegging tot patches gedurende de levenscyclus, in uw volgende aanbesteding in plaats van uw volgende verordening.

**Als u in de raad van bestuur zit**, is de blootstelling CE-markerings- en productaansprakelijkheidsrisico dat nu een cyberbeveiligingsgezicht draagt. Een machine die gevaarlijk is gemaakt door een softwarefout is een niet-conform product, met de gevolgen voor markttoegang en aansprakelijkheid die daaruit voortvloeien. Dit hoort op het risicoregister naast [NIS2](/nl/nis2), niet in een aparte kolom "IT".

## De weg naar 20 januari 2027

De data zijn eenvoudig; de verleiding om het gat als stilzittijd te behandelen is de valkuil.

```timeline
19 juli 2023 :: **Verordening treedt in werking.** De tekst ligt vast; het overgangsvenster opent. Er is nog niets vereist, maar de klok loopt.
2023–2026 :: **Overgang en voorbereiding.** Machines mogen nog op de markt worden gebracht onder Richtlijn 2006/42/EG; bouwers passen ontwerpen, dossiers en processen aan. Geharmoniseerde normen (incl. prEN 50742) rijpen.
20 januari 2027 :: **De Verordening is van toepassing.** Machines die op de EU-markt worden gebracht moeten voldoen aan de nieuwe essentiële eisen — inclusief die inzake cyberbeveiliging. De Richtlijn wordt ingetrokken.
Na 20 jan 2027 :: **Levenscyclusverplichtingen lopen.** Bescherming tegen corruptie, bewijs van manipulatie en updatelevering moeten in stand blijven gedurende de operationele levensduur van elke machine.
```

> [!WARNING]
> De periode tot 2027 is *overgangstijd, geen stilzittijd.* Cyberbeveiliging in het veiligheidsdossier vouwen, conformiteitsroutes opnieuw controleren, een aangemelde instantie inschakelen waar connectiviteit of AI het risiconiveau verandert, en manipulatiebestendige logging vanaf het begin ontwerpen zijn allemaal taken met een lange doorlooptijd. Een bouwer die eind 2026 begint, doet de dure versie van dit project.

## Een gereedheidsroutekaart voor bouwers richting januari 2027

1. **Inventariseer uw veiligheidsbeïnvloedende software en connectiviteit.** Maak voor elke productlijn een lijst van de componenten die de veiligheid beïnvloeden, elke externe verbinding, en alle AI in een veiligheidsfunctie. U kunt niet beveiligen wat u niet in kaart heeft gebracht. Een [Cyber Digital Twin](/nl/cyber-digital-twin) is een snelle manier om die kaart te bouwen.
2. **Integreer cyberbeveiliging in de risicobeoordeling.** Corruptie van veiligheidsbeïnvloedende software is nu een te beoordelen gevaar onder bijlage III, in hetzelfde document als mechanische gevaren — geen apart rapport.
3. **Controleer opnieuw uw conformiteitsroute.** Duwt connectiviteit of een AI-veiligheidscomponent een product naar bijlage I, deel A of deel B? Zo ja, betrek dan tijdig de doorlooptijd van een aangemelde instantie.
4. **Neem de technische methode over.** Stem het werk aan het besturingssysteem af op **[IEC 62443](/nl/iec-62443)** — 4-1 voor veilige ontwikkeling, 4-2 voor componentbeveiliging — zodat de clausules van bijlage III een concrete, controleerbare uitvoering krijgen.
5. **Bouw bewijs van manipulatie in.** Ontwerp de logging van legitieme en illegitieme interventies in het besturingssysteem, met bewaring gedurende de levensduur van de machine. Dit achteraf toevoegen is pijnlijk.
6. **Test de koppeling met de AI-verordening.** Voer voor elke AI-veiligheidscomponent de classificatie van artikel 6, lid 1, uit en zet de hoogrisicoverplichtingen parallel aan de beoordeling van de machine op.
7. **Werk het technisch dossier en de instructies bij.** Toon de cyberbeveiligingsmaatregelen aan in het dossier; gebruik de nieuwe toelating voor **digitale instructies** waar dat helpt, met behoud van toegankelijkheid van essentiële veiligheidsinformatie.
8. **Oefen ingrijpende wijziging.** Geef uw integratie- en serviceteams een duidelijke toets op grond van artikel 3, lid 16, zodat zij weten wanneer een wijziging hen tot fabrikant maakt.

## Veelgestelde vragen

**Vanaf wanneer is de Machineverordening van toepassing?**
Vanaf **20 januari 2027**, ter vervanging van Machinerichtlijn 2006/42/EG. Zij is in juli 2023 in werking getreden; de periode tot 2027 is overgangstijd om producten en processen aan te passen — geen stilzittijd, gezien de nieuwe cyberbeveiligings- en AI-dimensies. ([EU-OSHA](https://osha.europa.eu/en/legislation/directive/regulation-20231230eu-machinery))

**Is cyberbeveiliging nu echt onderdeel van machineveiligheid?**
Ja. Bijlage III, §1.1.9, vereist dat de veiligheid niet in gevaar komt door toevallige of opzettelijke corruptie van veiligheidsbeïnvloedende hardware en software, en dat interventie in veiligheidssoftware bewijs achterlaat. Een machine die gevaarlijk kan worden gemaakt door manipulatie van de software, voldoet niet aan de Verordening. ([Nemko](https://www.nemko.com/blog/eu-machinery-regulation-2023/1230))

**Wij voegen AI toe aan onze machines. Wat is er extra van toepassing?**
Als de AI een veiligheidscomponent is en de machine een conformiteitsbeoordeling door een derde partij nodig heeft, is zij **automatisch hoogrisico** onder de [AI-verordening](/nl/ai-act) (artikel 6, lid 1, via bijlage I). Beide regimes zijn dan van toepassing op hetzelfde product, dus plan ze samen. ([Bijlage I EU AI-verordening](https://artificialintelligenceact.eu/annex/1/))

**Leidt het wijzigen van een bestaande machine tot toepasselijkheid van de Verordening?**
Dat kan. Een **ingrijpende wijziging** onder artikel 3, lid 16 — fysiek of digitaal — maakt u de fabrikant van de gewijzigde machine, met de verplichtingen die daaruit voortvloeien. Beoordeel dit voordat u veiligheidsgerelateerde besturingssystemen aanpast. ([EU-OSHA](https://osha.europa.eu/en/legislation/directive/regulation-20231230eu-machinery))

**Wanneer is een aangemelde instantie verplicht?**
Voor categorieën van **bijlage I, deel A** — de hoogrisicomachines, nu met inbegrip van op machine-learning gebaseerde zelflerende veiligheidscomponenten — is een aangemelde instantie vereist en is zelfverklaring niet beschikbaar. Categorieën van deel B mogen alleen zelf beoordelen waar geharmoniseerde normen volledig zijn toegepast. ([Baker McKenzie](https://www.bakermckenzie.com/en/insight/publications/resources/product-risk-radar-articles/machinery-regulation))

**Hoe verschilt dit van de Cyber Resilience Act?**
Zij beantwoorden verschillende vragen over dezelfde machine. De Machineverordening vraagt of corruptie de machine *onveilig* kan maken (een veiligheidsvraag, in het veiligheidsdossier); de [CRA](/nl/cra) vraagt of het product met digitale elementen *secure-by-design* is met kwetsbaarheidsbeheer over de levensduur (een productbeveiligingsvraag). Ze zijn ontworpen om elkaar te versterken — CRA-naleving kan naleving van de Machineverordening vergemakkelijken — zodat één veilige ontwikkelingslevenscyclus beide dossiers voedt. ([ORC WG CRA-FAQ](https://cra.orcwg.org/faq/official/faq_2-4-1/))

**Welke norm dekt de nieuwe cyberbeveiligingsclausules?**
**prEN 50742** wordt specifiek ontwikkeld voor *bescherming tegen corruptie* in machines en veiligheidscomponenten, om bijlage III §1.1.9 te operationaliseren; het toepassen van een gepubliceerde geharmoniseerde norm geeft een vermoeden van conformiteit. EN ISO 12100 en EN ISO 13849 blijven de risicobeoordeling en de eisen aan veiligheidsgerelateerde besturingssystemen dragen, met IEC 62443 als de technische methode voor de besturingssystemen. ([IBF, prEN 50742](https://www.ibf-solutions.com/en/seminars-and-news/news/new-standard-pren-50742-protection-against-corruption))

**Hebben we een SBOM nodig voor onze machine?**
Het wordt snel de praktische basislijn. U moet de veiligheidsbeïnvloedende software identificeren en beschermen, en dat is precies wat een software bill of materials vastlegt — en de [CRA](/nl/cra) maakt de SBOM tot een expliciete verplichting voor producten met digitale elementen. Eén keer opbouwen bedient beide regimes.

## Hoe OXOT helpt

De cyberbeveiligingseisen van de Verordening zijn in de kern beveiligingseisen voor de besturingssystemen binnen een machine — het thuisterrein van OXOT. Wij helpen machinebouwers en integrators de essentiële eisen van bijlage III te vertalen naar een technisch programma dat is afgestemd op **[IEC 62443](/nl/iec-62443)**, zodat de clausules een controleerbaar ontwerp worden in plaats van een ambitie. Wij helpen exploitanten machinebeveiligingsverwachtingen te integreren in inkoop en in hun bredere OT-beveiligings- en **[NIS2](/nl/nis2)**-programma's. En waar AI-veiligheidscomponenten in het spel zijn, plaatst onze **[Cyber Digital Twin](/nl/cyber-digital-twin)** ze in uw risicobeeld, zodat de verplichtingen van de Machineverordening en de [AI-verordening](/nl/ai-act) — en de overlap met de [CRA](/nl/cra) — samen worden aangepakt, in één keer, in plaats van in vier afzonderlijke haastklussen. Bekijk hoe dit past in het bredere beeld van [Kaders](/nl/frameworks).

## Sources

- Regulation (EU) 2023/1230 (Machinery Regulation), official text — [EUR-Lex](https://eur-lex.europa.eu/eli/reg/2023/1230/oj/eng)
- Regulation 2023/1230/EU — machinery, legislation overview — [EU-OSHA](https://osha.europa.eu/en/legislation/directive/regulation-20231230eu-machinery)
- EU Machinery Regulation 2023/1230: cybersecurity obligations for manufacturers — [Nemko](https://www.nemko.com/blog/eu-machinery-regulation-2023/1230)
- Machinery Regulation — high-risk categories and conformity assessment analysis — [Baker McKenzie](https://www.bakermckenzie.com/en/insight/publications/resources/product-risk-radar-articles/machinery-regulation)
- AI Act Annex I — Union harmonisation legislation (incl. machinery) — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/annex/1/)
- prEN 50742 — bescherming tegen corruptie in machines en veiligheidscomponenten — [IBF Solutions](https://www.ibf-solutions.com/en/seminars-and-news/news/new-standard-pren-50742-protection-against-corruption)
- Samenspel CRA ↔ Machineverordening — [ORC WG CRA-FAQ](https://cra.orcwg.org/faq/official/faq_2-4-1/)
- Machineverordening — naleving, AI & cyberbeveiliging (overzicht) — [Intertek](https://www.intertek.com/industrial-equipment/machinery-regulation/)

*Deze pagina bevat algemene informatie over EU-wetgeving en vormt geen juridisch advies. Bevestig hoe de Machineverordening van toepassing is op uw producten en rol aan de hand van de Verordening zelf en, waar nodig, gekwalificeerd juridisch advies.*$MDBODY$, true, $MDBODY$EU-Machineverordening (EU) 2023/1230 & OT-beveiliging | OXOT$MDBODY$, $MDBODY$Verordening (EU) 2023/1230 uitgelegd voor machinebouwers en -exploitanten — hoe zij de Machinerichtlijn vervangt, cyberbeveiliging onderdeel maakt van het veiligheidsdossier van de machine (bijlage III), omgaat met AI en zelflerende veiligheidscomponenten, de deadline van 20 januari 2027, conformiteitsbeoordeling door aangemelde instanties, en de koppeling met de AI-verordening, de CRA, IEC 62443 en NIS2.$MDBODY$, $MDBODY$Machineveiligheid voor het tijdperk van connectiviteit, software en AI — waarin bescherming tegen corruptie een voorwaarde wordt voor de veiligheid van een machine.$MDBODY$, NULL, $MDBODY$page$MDBODY$, now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET
  title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published,
  meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description,
  excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type,
  published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now()
WHERE length(pages.body) < length(EXCLUDED.body);

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ($MDBODY$iec-62443$MDBODY$, $MDBODY$en$MDBODY$, $MDBODY$IEC 62443 for Industrial Security$MDBODY$, $MDBODY$If the European regulations tell you *what* cybersecurity outcomes to achieve, **IEC 62443 tells you how to actually build and operate secure industrial systems.** It is the international series of standards for the security of Industrial Automation and Control Systems (IACS), developed jointly by the IEC and ISA, and it has become the common language of OT security — the reference that operators, integrators and product vendors can all point to.

For an industrial organisation trying to make sense of NIS2, the CRA and their own risk, IEC 62443 is the engineering backbone. It is not a law and it is not mandatory in itself, but it is the most widely recognised, defensible method for demonstrating that your security measures are appropriate, proportionate and complete. Two ideas make it durable rather than merely fashionable: it treats security as a *shared responsibility* across the whole supply chain, and it insists that a control is only as good as the process that sustains it.

## The short version

- IEC 62443 is a **series of standards** for the cybersecurity of industrial automation and control systems, structured across **four groups**: General, Policies & Procedures, System, and Component.
- Its central design concept is **zones and conduits** — grouping assets by shared security requirements and controlling the communication paths between them.
- It defines **Security Levels (SL 1–4)**, from protection against casual or accidental misuse (SL 1) up to protection against sophisticated, well-resourced attackers such as nation-states (SL 4), and it separates the *target*, *capability* and *achieved* level (SL-T / SL-C / SL-A).
- It rests on **seven foundational requirements** that every control-system security measure maps back to.
- It assigns clear responsibilities to three roles: the **asset owner** (the operator), the **system integrator**, and the **product supplier**.
- It goes deep on two things this page treats at length — **component security** (`62443-4-1` secure development, `62443-4-2` component requirements) and the **security programme** (`62443-2-1` for asset owners, `62443-2-4` for service providers).
- It aligns tightly with **[NIS2](/en/nis2)** and the **[CRA](/en/cra)**, giving you an engineering method to satisfy both.

> [!NOTE]
> Throughout this page we use the joint designation **ISA/IEC 62443**. ISA (the International Society of Automation) develops the standards through its ISA99 committee; the IEC publishes them internationally. They are the same documents.

## Who IEC 62443 is for

The genius of the series is that it addresses the whole ecosystem, and it is explicit about who is responsible for what. Security in an industrial plant is never one party's job — it is a chain, and IEC 62443 names every link.

| Role | Who it is | What they own | Primary parts of 62443 |
| --- | --- | --- | --- |
| **Asset owner** | The operator — utility, plant, or infrastructure owner | The risk, the operational requirements, and the running security programme | `2-1`, `3-2`, `3-3` |
| **System integrator** | Designs, assembles and commissions the automation solution | Turning components into a secured, working system to a target security level | `2-4`, `3-2`, `3-3` |
| **Product supplier** | Develops the individual products — controllers, gateways, software, devices | Secure development and demonstrable component capability | `4-1`, `4-2` |
| **Maintenance / service provider** | Configures, patches and supports the solution over its life | Sustaining security during operations and maintenance | `2-4` |

Security only works when each part plays its role, and the series is deliberately structured so that everyone knows their obligations and can hold the others to account. An asset owner can require an integrator to build to a target security level; an integrator can require components that meet a component security level; a product supplier can demonstrate secure development. The paperwork of one party becomes the assurance of the next.

## The structure: four groups of documents

The series is organised into four groups, each addressing a different layer. The two-digit numbering (`x-y`) reads as *group–part*.

| Group | Theme | Key parts | What it covers |
| --- | --- | --- | --- |
| **1 — General** | Concepts & terminology | `1-1` | Concepts, terminology and the models the rest of the series builds on |
| **2 — Policies & Procedures** | The programme | `2-1`, `2-4` | Establishing/operating a security programme (asset owner) and requirements for service providers |
| **3 — System** | System engineering | `3-2`, `3-3` | Risk assessment, zones & conduits, and system-level security requirements and levels |
| **4 — Component** | Product | `4-1`, `4-2` | Secure product development lifecycle and technical requirements for individual components |

A few parts carry most of the practical weight:

- **`62443-1-1`** — terminology, concepts and models. The vocabulary everything else uses.
- **`62443-2-1`** — security programme requirements for **IACS asset owners** (the operator's Cybersecurity Management System). ([ISA](https://www.isa.org/products/ansi-isa-62443-2-1-2024-security-industrial-automa))
- **`62443-2-4`** — security programme requirements for **IACS service providers** — integrators and maintenance contractors. ([IEC](https://webstore.iec.ch/en/publication/67631))
- **`62443-3-2`** — **security risk assessment for system design**: how you define zones, conduits and target security levels.
- **`62443-3-3`** — **system security requirements and security levels**: the detailed technical requirements a system must meet. ([Cisco](https://www.cisco.com/c/en/us/products/collateral/security/isaiec-62443-3-3-wp.html))
- **`62443-4-1`** — **secure product development lifecycle**: what a supplier must *do* to develop secure products. ([Dragos](https://www.dragos.com/blog/isa-iec-62443-concepts))
- **`62443-4-2`** — **technical security requirements for components**: what a product must *be able to do*.

The parts interlock. The 62443-4-2 component requirements are derived directly from the 62443-3-3 system requirements, so a system assembled from compliant components has a genuine head start on system-level compliance — a design property we return to in the component-security section below.

## Zones and conduits — the core idea

The defining concept of IEC 62443 is **segmentation by security requirement.** A **zone** is a grouping of assets — systems and components — that share common security requirements based on their function, logical relationship and physical location. A **conduit** is a logical or physical grouping of the communication channels that connect zones and that share common security requirements.

The power of the model is that it forces you to reason about *where risk crosses boundaries*. Instead of trying to secure every device identically, you divide the environment into zones and then control and monitor the conduits between them. Security effort concentrates where it matters most — at the boundaries — and the highest-consequence functions can be placed in the most protected zones. This is the practical answer to the OT segmentation problem, and it is the method behind good IT/OT separation. ([Zone & conduit design guide](https://www.cagripolat.com/iec62443/en/iec-62443-zone-conduit-design-ot-practical-guide))

A reference architecture makes it concrete. Reading from the plant floor upward, the most safety-critical functions sit deepest, and every crossing between zones passes through a controlled conduit.

```svg
<svg viewBox="0 0 700 420" xmlns="http://www.w3.org/2000/svg" font-family="sans-serif">
  <rect width="700" height="420" fill="none"/>
  <text x="350" y="26" fill="#e5e7eb" font-size="17" font-weight="bold" text-anchor="middle">Zones &amp; Conduits — reference architecture</text>

  <!-- Enterprise / IT -->
  <rect x="120" y="44" width="460" height="46" rx="6" fill="none" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="350" y="72" fill="#e5e7eb" font-size="13" text-anchor="middle">Enterprise / IT zone  (ERP, business network)</text>

  <!-- conduit -->
  <line x1="350" y1="90" x2="350" y2="110" stroke="#f97316" stroke-width="3"/>
  <text x="470" y="105" fill="#f97316" font-size="11" text-anchor="start">conduit (firewall)</text>

  <!-- DMZ -->
  <rect x="120" y="110" width="460" height="46" rx="6" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="350" y="138" fill="#e5e7eb" font-size="13" text-anchor="middle">OT/IT DMZ  (jump host, patch &amp; AV proxy, historian replica)</text>

  <line x1="350" y1="156" x2="350" y2="176" stroke="#f97316" stroke-width="3"/>
  <text x="470" y="171" fill="#f97316" font-size="11" text-anchor="start">conduit (broker only)</text>

  <!-- Supervisory -->
  <rect x="120" y="176" width="460" height="46" rx="6" fill="none" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="350" y="204" fill="#e5e7eb" font-size="13" text-anchor="middle">Supervisory zone  (SCADA servers, engineering workstations)</text>

  <line x1="350" y1="222" x2="350" y2="242" stroke="#f97316" stroke-width="3"/>

  <!-- Control -->
  <rect x="120" y="242" width="460" height="46" rx="6" fill="none" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="350" y="270" fill="#e5e7eb" font-size="13" text-anchor="middle">Control zone  (PLCs, RTUs, HMIs)</text>

  <line x1="350" y1="288" x2="350" y2="308" stroke="#f97316" stroke-width="3"/>
  <text x="470" y="303" fill="#f97316" font-size="11" text-anchor="start">conduit (one-way / strict)</text>

  <!-- Safety -->
  <rect x="120" y="308" width="460" height="52" rx="6" fill="none" stroke="#3b82f6" stroke-width="2.5"/>
  <text x="350" y="332" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Safety zone  (SIS — highest SL-T)</text>
  <text x="350" y="350" fill="#94a3b8" font-size="11" text-anchor="middle">deepest / most protected</text>

  <!-- side arrow -->
  <text x="60" y="200" fill="#94a3b8" font-size="11" text-anchor="middle" transform="rotate(-90 60 200)">rising consequence · rising target SL</text>
</svg>
```

> [!TIP]
> Draw zones by *consequence of compromise*, not by network topology or vendor boundaries. Two devices on the same VLAN can belong to different zones if the impact of compromising them differs. The zone diagram is a risk artefact first and a network diagram second.

## Security Levels

IEC 62443 does not pretend that every system needs nation-state-grade defences. It defines four **Security Levels** that express *how strong* the protection of a zone or conduit needs to be, calibrated to the threat you are defending against.

| Level | Defends against | Attacker profile |
| --- | --- | --- |
| **SL 1** | Casual or coincidental violation | No specific intent — accidents, mistakes, curious insiders |
| **SL 2** | Intentional violation using **simple means** | Low resources, generic skills, low motivation |
| **SL 3** | Intentional violation using **sophisticated means** | Moderate resources, IACS-specific skills, moderate motivation |
| **SL 4** | Intentional violation using sophisticated means with **extended resources** | High resources, IACS-specific skills, high motivation — the nation-state tier |

Security levels come in three flavours that keep the conversation honest — and confusing them is one of the most common mistakes in practice.

| Variant | Name | Question it answers | Who sets it |
| --- | --- | --- | --- |
| **SL-T** | Target | What level does this zone *need*, given the risk? | Asset owner (via `3-2` risk assessment) |
| **SL-C** | Capability | What level *can* this component or system deliver when correctly configured? | Product supplier / integrator |
| **SL-A** | Achieved | What level is *actually* in place once deployed and operated? | Measured in the field |

The gap between **SL-T** and **SL-A** is your remediation backlog, expressed in a way an engineer and an auditor can both understand. A component with **SL-C 3** installed in a zone whose **SL-T** is 3 but configured carelessly may only achieve **SL-A 1** — capability is a ceiling, not a guarantee.

## The seven foundational requirements

Every requirement in the series maps back to one of **seven foundational requirements (FRs)** — a compact mental model for what "secure" means in a control system. Each FR is then decomposed into system requirements (in `3-3`) and component requirements (in `4-2`), each of which is enhanced as the security level rises.

| FR | Name | What it means | Everyday example |
| --- | --- | --- | --- |
| **FR 1** | Identification & Authentication Control (IAC) | Know who and what is acting | Unique accounts, no shared logins, MFA for remote access |
| **FR 2** | Use Control (UC) | Enforce the privileges each identity may exercise | Role-based access; least privilege on engineering functions |
| **FR 3** | System Integrity (SI) | Protect systems and data against unauthorised change | Signed firmware, malware protection, secure boot |
| **FR 4** | Data Confidentiality (DC) | Protect information from unauthorised disclosure | Encryption of sensitive configuration and process data |
| **FR 5** | Restricted Data Flow (RDF) | Segment and control information flow | Zones and conduits; deny-by-default at boundaries |
| **FR 6** | Timely Response to Events (TRE) | Detect, log and respond to security events | Central logging, monitoring, alerting on anomalies |
| **FR 7** | Resource Availability (RA) | Protect against denial of service; keep essential functions running | DoS protection, redundancy, resource limits |

The ordering is instructive: availability sits at the end not because it is least important, but because in OT it is often the *outcome* the other requirements exist to protect. FR 5 is worth a second look — it is the zones-and-conduits principle expressed as a requirement, which is why segmentation is not optional decoration but a foundational control.

## How Security Levels stack — the cumulative CR/RE model

The seven foundational requirements are not abstract goals; each one decomposes into concrete, testable **Component Requirements (CRs)** in `62443-4-2` and **System Requirements (SRs)** in `62443-3-3`. What turns those requirements into a *level* is the way they stack. Each CR/SR has a base specification at SL 1, and rising through the levels adds **Requirement Enhancements (REs)** on top — so the model is strictly **cumulative: SL 3 ⊇ SL 2 ⊇ SL 1.** Achieving SL 3 does not mean meeting a different set of controls; it means meeting the SL 2 set *plus* the additional enhancements that defeat a more capable attacker.

That structure has a consequence people routinely get wrong. **`62443-4-2` only defines SL-C — the capability of a component.** It explicitly places SL-T (the target a zone needs) and SL-A (what a zone actually achieves in the field) outside its scope; those live in `62443-3-2` (risk-derived target) and `62443-3-3` plus operational assessment (achieved). A zone's risk is only genuinely managed when **SL-A ≥ SL-T** — and SL-A can legitimately exceed a component's SL-C when compensating controls (firewalls, IDPS, restrictive conduits) carry the difference.

| FR | Governs | What SL-2 typically requires | What SL-3 adds (the REs) |
| --- | --- | --- | --- |
| FR 1 (IAC) | Who/what is acting | Unique accounts, RBAC, PKI | MFA, per-user access control, hardware authenticators |
| FR 3 (SI) | Integrity of code & data | TLS, code-signing, error handling | Hardware root of trust, secure boot |
| FR 4 (DC) | Confidentiality | AES-128+ in transit, secure deletion | Encryption at rest, hardware key management |
| FR 5 (RDF) | Segmentation | Logical segmentation, firewall ACLs | Physical segmentation, deep-packet inspection of OT protocols |
| FR 6 (TRE) | Detection & response | Accessible audit logs, real-time detection | SIEM export, anomaly detection, tamper-evident logs |
| FR 7 (RA) | Availability | Basic DoS protection, resource limits | Application-layer DoS resistance, graceful degradation |

## A worked example — a four-zone OT product

Security Levels earn their keep when a real system has *different* risk in different places. Take a representative OT product decomposed into four zones after a `62443-3-2` risk assessment:

| Zone | Target (SL-T) | Threat profile it must resist |
| --- | --- | --- |
| Zone 1 — control core | ≥ 3 | Sophisticated, IACS-specific attackers |
| Zone 2 — supervisory | ≥ 3 | Sophisticated, IACS-specific attackers |
| Zone 3 — auxiliary/HMI | ≥ 2 | Low-skill, generic tooling |
| Zone 4 — safety/critical | ≥ 4 | State-level, extended resources |

The point is not that everything must reach SL 4. It is that the risk assessment *justifies* pouring SL-4-grade effort into Zone 4 while accepting SL-2 for Zone 3 — because Zone 3's threat profile does not warrant defences against a nation-state. This is proportionality made concrete: you engineer to the risk each zone actually carries, and you can defend every decision with the `3-2` assessment that produced the SL-T values. It is also exactly the reasoning the [Cyber Resilience Act](/en/cra) demands under its "where applicable" test.

## Mapping IEC 62443 to the CRA — control by control

This is where the standard stops being "good practice" and becomes a compliance instrument. Most in-scope OT manufacturers already hold `62443` certifications, and the CENELEC work on **EN IEC 62443-4-2/A11:2026** maps its component requirements directly onto the [CRA](/en/cra)'s Annex I, Part I essential requirements. The correspondence is close enough to use as an engineering bridge today:

| CRA Annex I requirement | Primary 62443 FR | What SL-2 provides | What SL-3 adds |
| --- | --- | --- | --- |
| Protection from unauthorised access | FR 1 (IAC), FR 2 (UC) | Unique accounts, RBAC, PKI | MFA, per-user ACLs, hardware authenticators |
| Confidentiality of data | FR 4 (DC) | AES-128+ in transit, secure deletion | At-rest encryption, hardware key management |
| Integrity of data and programs | FR 3 (SI) | TLS, code-signing | Hardware root of trust, secure boot |
| Minimisation of data / attack surface | FR 5 (RDF), FR 3 (SI) | Zone boundary filtering, least functionality | Physical segmentation, deny-by-default |
| Availability of essential functions | FR 7 (RA) | Basic DoS protection | App-layer DoS resistance, graceful degradation |
| Security event logging | FR 6 (TRE) | Accessible audit logs, real-time detection | SIEM export, anomaly detection, tamper-evident logs |

The practical upshot: a component certified to **SL-C 2** satisfies FR 1–7 at SL-2 depth, and — where the risk assessment shows that depth is appropriate for the zone — that becomes a defensible CRA baseline, with the SL-3 enhancements documented as "not applicable" under CRA Article 13(4). A `62443-4-2` certificate is powerful evidence in a CRA technical file, even though it is not, on its own, a CRA conformity certificate.

## Compensating controls and the SL-A vs SL-C trap

The most consequential mistake in translating `62443` to a product-level obligation is assuming component capability equals delivered security. It does not — and under the CRA the gap becomes a legal exposure.

| Situation | Consequence for a CRA technical file |
| --- | --- |
| Component SL-C 2, zone SL-T 2 | ✅ SL-2 specifications are the correct baseline |
| Component SL-C 2, zone SL-T 3, compensating controls raise SL-A to 3 | ⚠️ Must document *how* the compensating controls achieve SL-A 3 |
| Component SL-C 2, zone SL-T 3, no compensating controls documented | ❌ Product-level assessment fails — non-conformity |

The lesson generalises well beyond compliance: a zone is only as secure as its *achieved* level, and achieved level is a property of the whole architecture — components, configuration, conduits and monitoring together — not of any single certificate. This is why OXOT assesses the integrated posture, not just the component data sheets.

```cta
Is your installed security level (SL-A) actually meeting your target (SL-T)?
The SL-A vs SL-C gap is exactly where audits fail and incidents start. We turn it into a prioritized, evidence-backed remediation backlog you can defend.
Assess my SL gap :: /en/contact
```

## Maturity levels and the Security Protection Rating

Having a control is not the same as operating it well. Alongside security levels, the series uses **maturity levels** for *processes*, drawn from familiar capability-maturity thinking. ([Overcyte](https://www.overcyte.com/frameworks/isa-iec-62443))

| Maturity level | Name | Meaning |
| --- | --- | --- |
| **ML 1** | Initial | The process is performed, but ad hoc and reliant on individuals |
| **ML 2** | Managed | The process is documented and repeatable |
| **ML 3** | Defined (Practiced) | The process is established and consistently applied across the organisation |
| **ML 4** | Improving | The process is measured and continuously improved |

The **Security Protection Rating (SPR)** combines the security level achieved with the maturity of the processes that sustain it. A high security level held together by heroics and undocumented tribal knowledge is fragile; maturity is what makes protection durable. This is the same reason `62443-4-1` grades a supplier's *development processes* by maturity, and why `62443-2-1:2024` introduced a maturity model for the asset owner's programme — the series consistently asks not only "is the control present?" but "will it still be present, correctly, next year?"

---

## Component security — the deep dive

Component security is where IEC 62443 does something no regulation does: it defines, in engineering terms, both **how a secure product is built** (`62443-4-1`) and **what a secure product must be able to do** (`62443-4-2`). For asset owners this is the leverage point in procurement; for suppliers it is increasingly the price of market access under the CRA. We treat it in depth because it is where the standard turns "buy secure equipment" into a checkable specification.

### 62443-4-1 — the secure product development lifecycle

`62443-4-1` sets out the **secure development lifecycle (SDL)** a product supplier must follow. It does not describe a single audit at the end; it describes the *processes* that run from concept to end-of-life, and it grades those processes by maturity. The standard organises them into **eight practices** with 47 top-level requirements (and hundreds of sub-requirements). ([jtsec practices summary](https://jtsec.es/files/IEC%2062443-4-1%20Practices%20&%20Requirementes.pdf))

| # | Practice | Code | What it requires |
| --- | --- | --- | --- |
| 1 | **Security Management** | SM | Governance, roles, accountability and resources for secure development across the organisation |
| 2 | **Specification of Security Requirements** | SR | Security requirements derived from a documented threat model and traced through development |
| 3 | **Secure by Design** | SD | Defence-in-depth, least privilege and secure design principles built into the architecture |
| 4 | **Secure Implementation** | SI | Secure coding standards and review to prevent vulnerabilities being introduced |
| 5 | **Security Verification & Validation Testing** | SVV | Security testing — functional, vulnerability, penetration and robustness testing — before release |
| 6 | **Management of Security-Related Issues** | DM | Receiving, triaging, tracking and resolving reported defects and vulnerabilities |
| 7 | **Security Update Management** | SUM | Qualifying, documenting and delivering security patches in a timely way, including third-party components |
| 8 | **Security Guidelines** | SG | Documentation that tells the integrator and operator how to deploy, harden and decommission the product securely |

Read as a lifecycle, these practices answer the questions an asset owner should be asking a vendor:

- **Threat modelling (SR).** Are security requirements derived from an actual threat model — and is that model kept current as the design evolves, rather than done once and filed? ([cytal](https://cytal.co.uk/blog/iec-62443-4-1-explained-secure-development-lifecycle-requirements/))
- **Secure design and implementation (SD, SI).** Is defence-in-depth designed in, and are secure coding standards enforced and reviewed?
- **Verification and validation (SVV).** Is the product security-tested — including robustness and penetration testing — before it ships, with evidence?
- **Defect and vulnerability management (DM).** Is there a real process to receive vulnerability reports, triage them, and coordinate disclosure — not just a mailbox nobody reads?
- **Patch management (SUM).** Are security updates qualified, documented and delivered promptly, including for embedded third-party libraries?
- **Product end-of-life (SG).** Does the guidance say when support ends and how to decommission securely — so an operator is not left running an abandoned product on a critical process?

> [!IMPORTANT]
> `62443-4-1` is about **process maturity**, not a single test. A supplier's SDL can be independently assessed — for example under the ISASecure **SDLA (Secure Development Lifecycle Assurance)** programme — and rated ML 1–4. Ask vendors for the assessment, not just the marketing claim. ([ISASecure CSA](https://isasecure.org/certification/iec-62443-csa-certification))

### 62443-4-2 — technical requirements by component type

Where `4-1` is about the *maker*, `62443-4-2` is about the *product*. It specifies **Component Requirements (CRs)** that a device or application must be able to satisfy, organised under the same seven foundational requirements and scaled across SL 1–4. Requirements are split by component type, because a PLC and a SCADA server cannot reasonably meet identical technical controls. ([Keyfactor](https://www.keyfactor.com/blog/iec-62443-4-2-technical-security-requirements-for-iacs-components/))

| Code | Component type | Definition | Typical examples |
| --- | --- | --- | --- |
| **EDR** | Embedded Device Requirement | Special-purpose device running embedded software, usually with a limited OS | PLCs, RTUs, IEDs, IIoT sensors |
| **HDR** | Host Device Requirement | General-purpose device running a full OS | Engineering workstations, HMIs, servers |
| **NDR** | Network Device Requirement | Device that transports, routes or controls network traffic | Firewalls, switches, routers, gateways |
| **SAR** | Software Application Requirement | Software running on a host, providing IACS functions | SCADA, MES, historian, engineering software |

Every component type is measured against the seven FRs, and each requirement gains **requirement enhancements (REs)** as the security level rises — so, for example, authentication that is acceptable at SL 1 must become stronger and harder to bypass to satisfy SL 3. ([INCIBE](https://www.incibe.es/en/incibe-cert/blog/iec-62443-4-2-need-secure-components))

The critical design property is **derivation**: the component requirements in `4-2` are drawn directly from the system requirements in `3-3`. That is what lets the roles collaborate cleanly — the asset owner sets a target SL for a zone, the integrator builds the zone to `3-3`, and the components inside it carry `4-2` capability that rolls up to support the system claim.

```svg
<svg viewBox="0 0 700 340" xmlns="http://www.w3.org/2000/svg" font-family="sans-serif">
  <rect width="700" height="340" fill="none"/>
  <text x="350" y="28" fill="#e5e7eb" font-size="16" font-weight="bold" text-anchor="middle">How component requirements derive — and roles collaborate</text>

  <!-- FR box -->
  <rect x="270" y="48" width="160" height="44" rx="6" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="350" y="70" fill="#e5e7eb" font-size="12" text-anchor="middle">7 Foundational</text>
  <text x="350" y="85" fill="#e5e7eb" font-size="12" text-anchor="middle">Requirements</text>

  <line x1="350" y1="92" x2="350" y2="118" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#a)"/>

  <!-- 3-3 -->
  <rect x="230" y="118" width="240" height="46" rx="6" fill="none" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="350" y="140" fill="#e5e7eb" font-size="12" text-anchor="middle">62443-3-3 · System Requirements (SR)</text>
  <text x="350" y="156" fill="#94a3b8" font-size="11" text-anchor="middle">set per zone at target SL — built by the integrator</text>

  <line x1="350" y1="164" x2="350" y2="190" stroke="#f97316" stroke-width="2" marker-end="url(#b)"/>
  <text x="480" y="182" fill="#f97316" font-size="11" text-anchor="start">derives</text>

  <!-- 4-2 -->
  <rect x="230" y="190" width="240" height="46" rx="6" fill="none" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="350" y="212" fill="#e5e7eb" font-size="12" text-anchor="middle">62443-4-2 · Component Requirements (CR)</text>
  <text x="350" y="228" fill="#94a3b8" font-size="11" text-anchor="middle">EDR · HDR · NDR · SAR — met by the supplier</text>

  <line x1="350" y1="236" x2="350" y2="262" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#a)"/>

  <!-- 4-1 -->
  <rect x="230" y="262" width="240" height="46" rx="6" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="350" y="284" fill="#e5e7eb" font-size="12" text-anchor="middle">62443-4-1 · Secure Development Lifecycle</text>
  <text x="350" y="300" fill="#94a3b8" font-size="11" text-anchor="middle">the process that makes CR capability credible</text>

  <!-- role labels -->
  <text x="120" y="141" fill="#3b82f6" font-size="11" text-anchor="middle">Integrator</text>
  <text x="120" y="213" fill="#f97316" font-size="11" text-anchor="middle">Supplier</text>
  <text x="120" y="285" fill="#f97316" font-size="11" text-anchor="middle">Supplier</text>
  <text x="600" y="71" fill="#3b82f6" font-size="11" text-anchor="middle">Asset owner</text>
  <text x="600" y="85" fill="#94a3b8" font-size="10" text-anchor="middle">sets SL-T</text>

  <defs>
    <marker id="a" markerWidth="8" markerHeight="8" refX="4" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 Z" fill="#94a3b8"/></marker>
    <marker id="b" markerWidth="8" markerHeight="8" refX="4" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 Z" fill="#f97316"/></marker>
  </defs>
</svg>
```

### What asset owners should demand of suppliers

Component security only pays off if it is written into procurement. Practical asks:

- A stated **SL-C** per foundational requirement for each product, and the configuration needed to achieve it.
- Evidence of a `62443-4-1` **SDL assessment** (ideally third-party, with a maturity level) — not a self-declared claim.
- A **Software Bill of Materials (SBOM)** and a documented **vulnerability handling and disclosure** process (DM).
- A **security update** commitment (SUM): cadence, qualification, and how third-party library fixes reach you.
- **Hardening and end-of-life guidance** (SG), including the support period and secure decommissioning.

> [!NOTE]
> ISASecure certifies both sides of component security: **CSA (Component Security Assurance)** for products against `4-2`, and **SDLA** for development processes against `4-1`. Some sector bodies argue **SL 2** should be the practical minimum for new components rather than SL 1. ([ISASecure — the case for SL 2](https://www.isasecure.org/hubfs/The-Case-for-ISA-IEC-62443-Security-Level-2-as-a-Minimum-FINAL.pdf))

### Why component security underpins the CRA

The EU **[Cyber Resilience Act](/en/cra)** requires manufacturers of products with digital elements to build in security by design and by default, and to handle vulnerabilities across a defined support period (Annex I, Parts I and II). ENISA and industry both note that a product built to `4-2` and developed to `4-1` already meets much of what Annex I demands. ([exida on 62443 & the CRA](https://www.exida.com/blog/how-iec-62443-can-help-achieve-compliance-with-the-eu-cyber-resilience-act-cra))

| CRA Annex I theme | Where 62443 answers it |
| --- | --- |
| Security by design & by default (Part I) | `4-1` SD/SI · `4-2` CRs at target SL |
| Secure configuration & least privilege | `4-2` FR 1 (IAC) & FR 2 (UC) |
| Protection of data integrity & confidentiality | `4-2` FR 3 (SI) & FR 4 (DC) |
| Attack surface reduction & DoS resilience | `4-2` FR 5 (RDF) & FR 7 (RA) |
| Vulnerability handling & coordinated disclosure (Part II) | `4-1` DM (issue management) |
| Security updates across the support period | `4-1` SUM (update management) |
| Provision of an SBOM | `4-1` SM / SUM component inventory |

The alignment is close but not automatic: the CRA is law with its own conformity assessment, and 62443 is the engineering evidence that makes conformity defensible rather than a paper exercise.

---

## The security programme — the deep dive

Technology alone does not make an operator secure; a *programme* does. Group 2 of the series covers the organisational engine that keeps everything else running — governance, risk management, policy, competence and operations — split between the asset owner (`62443-2-1`) and the service providers who work on their behalf (`62443-2-4`). This is the layer NIS2 cares about most, which is why we treat it at length.

### 62443-2-1 — the asset owner's security programme

`62443-2-1` specifies the requirements for an asset owner to **establish and operate an IACS security programme** — historically framed as a Cybersecurity Management System (CSMS), the OT counterpart to an ISMS. The **2024 edition** restructured the requirements into **Security Programme Elements (SPEs)**, removed duplication with ISO/IEC 27001-style information-security management, and added a **maturity model** for evaluating each requirement. ([Industrial Cyber on 2-1:2024](https://industrialcyber.co/isa-iec-62443/iec-publishes-iec-62443-2-12024-setting-security-standards-for-industrial-automation-and-control-systems/))

The programme runs as a continuous cycle rather than a one-off project:

```svg
<svg viewBox="0 0 700 360" xmlns="http://www.w3.org/2000/svg" font-family="sans-serif">
  <rect width="700" height="360" fill="none"/>
  <text x="350" y="28" fill="#e5e7eb" font-size="16" font-weight="bold" text-anchor="middle">The IACS security-programme lifecycle (62443-2-1)</text>

  <!-- centre -->
  <circle cx="350" cy="190" r="52" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="350" y="186" fill="#e5e7eb" font-size="12" text-anchor="middle">Govern &amp;</text>
  <text x="350" y="202" fill="#e5e7eb" font-size="12" text-anchor="middle">improve</text>

  <!-- nodes -->
  <g fill="none" stroke="#94a3b8" stroke-width="1.5">
    <rect x="270" y="60" width="160" height="42" rx="6"/>
    <rect x="500" y="150" width="170" height="42" rx="6"/>
    <rect x="430" y="290" width="180" height="42" rx="6"/>
    <rect x="90" y="290" width="180" height="42" rx="6"/>
    <rect x="30" y="150" width="170" height="42" rx="6"/>
  </g>
  <text x="350" y="86" fill="#e5e7eb" font-size="12" text-anchor="middle">1 · Risk assessment</text>
  <text x="585" y="176" fill="#e5e7eb" font-size="12" text-anchor="middle">2 · Policy &amp; org</text>
  <text x="520" y="316" fill="#e5e7eb" font-size="12" text-anchor="middle">3 · Controls &amp; competence</text>
  <text x="180" y="316" fill="#e5e7eb" font-size="12" text-anchor="middle">4 · Operate &amp; respond</text>
  <text x="115" y="176" fill="#e5e7eb" font-size="12" text-anchor="middle">5 · Monitor &amp; audit</text>

  <!-- arrows around -->
  <g stroke="#f97316" stroke-width="2" fill="none" marker-end="url(#c)">
    <path d="M430 84 Q520 100 560 150"/>
    <path d="M585 192 Q560 250 520 290"/>
    <path d="M430 315 Q350 340 270 315"/>
    <path d="M180 290 Q120 250 115 192"/>
    <path d="M120 150 Q180 100 270 84"/>
  </g>
  <defs>
    <marker id="c" markerWidth="9" markerHeight="9" refX="4.5" refY="4.5" orient="auto"><path d="M0,0 L9,4.5 L0,9 Z" fill="#f97316"/></marker>
  </defs>
</svg>
```

What a mature asset-owner programme contains:

- **Governance and accountability.** Named ownership, a policy framework, and management commitment. The asset owner remains *accountable* even where suppliers do the work. ([ISA product page](https://www.isa.org/products/ansi-isa-62443-2-1-2024-security-industrial-automa))
- **Risk management.** A recurring, documented IACS risk assessment (feeding the `3-2` zone/conduit and SL-T work) that keeps the programme calibrated to real consequence.
- **Policies and procedures.** Access control, change management, network security, and secure configuration — written down, not carried in people's heads.
- **Competence and awareness.** Roles, training and cyber-hygiene for the people who operate the plant.
- **Operations.** Monitoring, incident response, backup and recovery, and patch/vulnerability handling as running processes.
- **Maturity and continuous improvement.** Each element assessed against the maturity model and improved over time — the durability point again.

> [!IMPORTANT]
> `62443-2-1:2024` deliberately allows **implementation flexibility** for legacy plant, recognising that many operational systems run hardware and software that can no longer be patched. The programme's job is to manage that reality with compensating controls, not to pretend it away. ([Industrial Cyber](https://industrialcyber.co/isa-iec-62443/iec-publishes-iec-62443-2-12024-setting-security-standards-for-industrial-automation-and-control-systems/))

### 62443-2-4 — requirements for service providers

An operator rarely builds and maintains its own IACS alone. `62443-2-4` specifies the **security programme requirements for IACS service providers** — the integrators and maintenance contractors who deliver and support the automation solution. It defines the security *capabilities* (increasingly framed as documented *processes*) a service provider must offer across integration and maintenance activities. ([IEC](https://webstore.iec.ch/en/publication/67631))

In practice, `2-4` is what an asset owner points to when writing security into a contract: it covers secure engineering practices, hardening during Factory and Site Acceptance Testing (FAT/SAT), account and remote-access handling, patch and backup processes, and how the provider sustains its security guidelines through the maintenance phase. It is the bridge between the operator's programme (`2-1`) and the components it buys (`4-1`/`4-2`) — the assurance that the people touching your system work to a defined standard.

### How the programme satisfies NIS2 Article 21

NIS2 requires "appropriate and proportionate" technical and organisational risk-management measures, and **Article 21(2)** enumerates ten of them. The security programme in Group 2 (with support from Group 3) maps onto these almost item-for-item — which is why building the programme to 62443 lets you evidence NIS2 without inventing a parallel structure. ([NIS2 Article 21 — the 10 measures](https://www.glocertinternational.com/resources/guides/nis2-article-21-risk-management-measures-explained/))

| NIS2 Article 21(2) measure | Where 62443 delivers it |
| --- | --- |
| (a) Risk analysis & information security policies | `2-1` risk management & policy · `3-2` risk assessment |
| (b) Incident handling | `2-1` operations · FR 6 (TRE) |
| (c) Business continuity, backup & crisis management | `2-1` operations (backup/recovery) |
| (d) Supply chain security | `2-4` service providers · `4-1`/`4-2` for products |
| (e) Security in acquisition, development & maintenance (incl. vuln handling) | `4-1` (DM, SUM) · `2-4` maintenance |
| (f) Assessing effectiveness of measures | `2-1` maturity model, monitoring & audit |
| (g) Cyber hygiene & training | `2-1` competence & awareness |
| (h) Cryptography & encryption | FR 3 (SI) & FR 4 (DC) in `3-3`/`4-2` |
| (i) HR security, access control & asset management | FR 1 (IAC) & FR 2 (UC) · `2-1` asset management |
| (j) MFA, secured communications | FR 1 REs at higher SLs |

## IEC 62443 and the other regulations

The European regulations set outcomes; IEC 62443 provides the recognised method to reach and evidence them. Beyond NIS2 and the CRA covered above:

- **The [AI Act](/en/ai-act)** requires accuracy, robustness and cybersecurity for high-risk AI systems (Article 15). Where such systems live inside an IACS, the 62443 zone model and system requirements are the vehicle for protecting them.
- **The [Machinery Regulation](/en/machine-act)** brings cybersecurity relevant to safety into the CE-marking of machinery; 62443's component and system requirements give machine builders a route to demonstrate it.
- **[TS 50701](/en/ts-50701)** applies the 62443 concepts and risk-assessment method to the railway sector, adapting them to rail's safety lifecycle.

Aligning your regulatory response to IEC 62443 means you build once and satisfy many — and you speak a language regulators, auditors, integrators and vendors already recognise. Our **[Frameworks](/en/frameworks)** overview shows how these pieces fit together.

## What it means for your role

**If you are an asset owner / operator**, IEC 62443 turns "make it secure" into a specification. Set a target security level per zone (`3-2`), run a real security programme (`2-1`), and hold integrators (`2-4`) and suppliers (`4-1`/`4-2`) to those numbers in contracts.

**If you are an engineer or integrator**, the series is your design method: risk-assess (`3-2`), define zones and conduits, set target security levels, and build systems (`3-3`) from components (`4-2`) that meet them — while meeting `2-4` in how you deliver.

**If you are a product supplier**, `4-1` and `4-2` are your route to market: a demonstrable secure development lifecycle and components with a stated, ideally certified, security capability — which is fast becoming the entry ticket under the CRA.

## How OXOT uses IEC 62443

IEC 62443 is the backbone of how OXOT works. Our **OT Security Assessments** are structured around its risk-assessment method (`62443-3-2`), producing zone and conduit models and target security levels grounded in your real operational risk. Our **[Cyber Digital Twin](/en/cyber-digital-twin)** holds that structure as a living model — zones, conduits, assets and the gap between target and achieved security levels — so you can prioritise investment and show your reasoning. Our **OT Security Programmes** build the `2-1` engine; our **Architecture & Segmentation** work delivers the design in practice; and our **Capability Transfer** ensures your team can operate and sustain it. IEC 62443 is not a document we cite; it is the method we build with.

## Frequently asked questions

**Is IEC 62443 mandatory?**
Not in itself — it is a voluntary international standard. But it is the recognised method for demonstrating compliance with mandatory regimes like NIS2 and the CRA, and many contracts and sector regulators now expect it.

**Do we need SL 4 everywhere?**
No — that would be disproportionate and expensive. You set a *target* security level per zone based on the consequence of compromise. Most zones need SL 1–2; only the highest-consequence functions warrant SL 3 or 4.

**What is the difference between a security level and a maturity level?**
A **security level (SL 1–4)** grades the strength of protection of a system or component. A **maturity level (ML 1–4)** grades how well the *process* behind it is established and improved. A strong control run by an immature process is fragile — the Security Protection Rating combines both.

**Is 62443-4-2 certification the same as being CRA-compliant?**
No, but it is most of the work. A product built to `4-2` and developed under `4-1` meets much of CRA Annex I, yet the CRA has its own legal conformity assessment. Treat 62443 as the engineering evidence, not the legal sign-off. See our **[CRA](/en/cra)** page.

**How does IEC 62443 relate to TS 50701?**
**[TS 50701](/en/ts-50701)** is IEC 62443 specialised for rail — same concepts and risk method, adapted to the railway safety lifecycle.

**Where do we start?**
With a risk-based assessment: inventory your assets, define zones and conduits, set target security levels, and measure the gap. That assessment is the foundation everything else builds on — and it is exactly what OXOT delivers first.

## Sources

- ANSI/ISA-62443-2-1-2024, Security Program Requirements for IACS Asset Owners — [ISA](https://www.isa.org/products/ansi-isa-62443-2-1-2024-security-industrial-automa)
- IEC 62443-2-1:2024 publication note — [Industrial Cyber](https://industrialcyber.co/isa-iec-62443/iec-publishes-iec-62443-2-12024-setting-security-standards-for-industrial-automation-and-control-systems/)
- IEC 62443-2-4:2023, Security Program Requirements for IACS Service Providers — [IEC](https://webstore.iec.ch/en/publication/67631)
- ISA/IEC 62443-3-3 overview — [Cisco](https://www.cisco.com/c/en/us/products/collateral/security/isaiec-62443-3-3-wp.html)
- IEC 62443-4-1 practices & requirements — [jtsec](https://jtsec.es/files/IEC%2062443-4-1%20Practices%20&%20Requirementes.pdf)
- IEC 62443-4-1 explained — [CyTAL](https://cytal.co.uk/blog/iec-62443-4-1-explained-secure-development-lifecycle-requirements/)
- IEC 62443-4-2 technical security requirements for components — [Keyfactor](https://www.keyfactor.com/blog/iec-62443-4-2-technical-security-requirements-for-iacs-components/)
- IEC 62443-4-2, the need to secure components — [INCIBE-CERT](https://www.incibe.es/en/incibe-cert/blog/iec-62443-4-2-need-secure-components)
- ISASecure CSA / SDLA certification — [ISASecure](https://isasecure.org/certification/iec-62443-csa-certification)
- The case for SL 2 as a minimum — [ISASecure](https://www.isasecure.org/hubfs/The-Case-for-ISA-IEC-62443-Security-Level-2-as-a-Minimum-FINAL.pdf)
- IEC 62443 concepts for OT security teams — [Dragos](https://www.dragos.com/blog/isa-iec-62443-concepts)
- ISA/IEC 62443 series overview — [ISA](https://www.isa.org/standards-and-publications/isa-standards/isa-iec-62443-series-of-standards)
- Maturity levels & framework overview — [Overcyte](https://www.overcyte.com/frameworks/isa-iec-62443)
- How IEC 62443 helps with the CRA — [exida](https://www.exida.com/blog/how-iec-62443-can-help-achieve-compliance-with-the-eu-cyber-resilience-act-cra)
- NIS2 Article 21 — the 10 risk-management measures — [Gloce International](https://www.glocertinternational.com/resources/guides/nis2-article-21-risk-management-measures-explained/)
- IEC 62443 zone & conduit design — [Çağrı Polat](https://www.cagripolat.com/iec62443/en/iec-62443-zone-conduit-design-ot-practical-guide)
- IEC 62443 overview — [Fortinet](https://www.fortinet.com/resources/cyberglossary/iec-62443)
- IEC 62443 — IEC SyC Smart Energy — [IEC](https://syc-se.iec.ch/deliveries/cybersecurity-guidelines/security-standards-and-best-practices/iec-62443/)

*This page is general educational information about the IEC 62443 series. Refer to the official IEC/ISA standards for authoritative requirements.*$MDBODY$, true, $MDBODY$IEC 62443 Explained — Zones, Security Levels, Component Security & the Security Programme | OXOT$MDBODY$, $MDBODY$A practical, in-depth guide to the ISA/IEC 62443 series — the four document groups, zones and conduits, security levels SL 1–4 (SL-T/C/A), the seven foundational requirements, maturity and the Security Protection Rating, the asset-owner/integrator/supplier roles, plus deep sections on component security (62443-4-1 secure development & 62443-4-2 component requirements) and the IACS security programme (62443-2-1 & 2-4) — and how it underpins NIS2 and the CRA.$MDBODY$, $MDBODY$The international standard for securing industrial automation and control systems — concepts, structure, component security, the security programme, and how to use it in practice.$MDBODY$, NULL, $MDBODY$page$MDBODY$, now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET
  title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published,
  meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description,
  excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type,
  published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now()
WHERE length(pages.body) < length(EXCLUDED.body);

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ($MDBODY$iec-62443$MDBODY$, $MDBODY$nl$MDBODY$, $MDBODY$IEC 62443 voor industriële beveiliging$MDBODY$, $MDBODY$Als de Europese regelgeving u vertelt *welke* cybersecurity-uitkomsten u moet bereiken, dan vertelt **IEC 62443 u hoe u daadwerkelijk veilige industriële systemen bouwt en exploiteert.** Het is de internationale reeks standaarden voor de beveiliging van Industrial Automation and Control Systems (IACS), gezamenlijk ontwikkeld door de IEC en ISA, en het is uitgegroeid tot de gemeenschappelijke taal van OT-security — het referentiekader waar operators, integrators en productleveranciers allemaal naar kunnen verwijzen.

Voor een industriële organisatie die grip probeert te krijgen op NIS2, de CRA en haar eigen risico, is IEC 62443 de technische ruggengraat. Het is geen wet en op zichzelf niet verplicht, maar het is de meest erkende, verdedigbare methode om aan te tonen dat uw beveiligingsmaatregelen passend, proportioneel en volledig zijn. Twee ideeën maken het duurzaam in plaats van slechts modieus: het behandelt beveiliging als een *gedeelde verantwoordelijkheid* over de hele toeleveringsketen, en het staat erop dat een maatregel niet beter is dan het proces dat haar in stand houdt.

## De korte versie

- IEC 62443 is een **reeks standaarden** voor de cybersecurity van industriële automatiserings- en controlesystemen, gestructureerd in **vier groepen**: Algemeen, Beleid & Procedures, Systeem, en Component.
- Het centrale ontwerpconcept is **zones en conduits** — het groeperen van assets op basis van gedeelde beveiligingseisen en het beheersen van de communicatiepaden ertussen.
- Het definieert **security levels (SL 1–4)**, van bescherming tegen incidenteel of onbedoeld misbruik (SL 1) tot bescherming tegen geavanceerde, goed uitgeruste aanvallers zoals natiestaten (SL 4), en het maakt onderscheid tussen het *target*-, *capability*- en *achieved*-niveau (SL-T / SL-C / SL-A).
- Het steunt op **zeven fundamentele eisen (foundational requirements)** waar elke beveiligingsmaatregel voor controlesystemen op terugvalt.
- Het kent duidelijke verantwoordelijkheden toe aan drie rollen: de **asset owner** (de operator), de **system integrator**, en de **product supplier**.
- Het gaat diep in op twee onderwerpen die deze pagina uitgebreid behandelt — **componentbeveiliging** (`62443-4-1` secure development, `62443-4-2` componenteisen) en het **security-programma** (`62443-2-1` voor asset owners, `62443-2-4` voor dienstverleners).
- Het sluit nauw aan bij **[NIS2](/nl/nis2)** en de **[CRA](/nl/cra)**, en geeft u een technische methode om aan beide te voldoen.

> [!NOTE]
> Op deze pagina gebruiken we de gezamenlijke aanduiding **ISA/IEC 62443**. ISA (de International Society of Automation) ontwikkelt de standaarden via het ISA99-comité; de IEC publiceert ze internationaal. Het zijn dezelfde documenten.

## Voor wie IEC 62443 is bedoeld

Het geniale aan de reeks is dat zij het hele ecosysteem adresseert en expliciet is over wie waarvoor verantwoordelijk is. Beveiliging in een industriële installatie is nooit het werk van één partij — het is een keten, en IEC 62443 benoemt elke schakel.

| Rol | Wie het is | Wat zij bezitten | Belangrijkste onderdelen van 62443 |
| --- | --- | --- | --- |
| **Asset owner** | De operator — nutsbedrijf, fabriek of eigenaar van infrastructuur | Het risico, de operationele eisen, en het lopende security-programma | `2-1`, `3-2`, `3-3` |
| **System integrator** | Ontwerpt, bouwt en neemt de automatiseringsoplossing in bedrijf | Componenten omzetten in een beveiligd, werkend systeem op een target security level | `2-4`, `3-2`, `3-3` |
| **Product supplier** | Ontwikkelt de afzonderlijke producten — controllers, gateways, software, apparaten | Secure development en aantoonbare componentcapaciteit | `4-1`, `4-2` |
| **Onderhouds-/dienstverlener** | Configureert, patcht en ondersteunt de oplossing gedurende haar levensduur | Beveiliging in stand houden tijdens bedrijf en onderhoud | `2-4` |

Beveiliging werkt alleen wanneer elk onderdeel zijn rol vervult, en de reeks is bewust zo gestructureerd dat iedereen zijn verplichtingen kent en de anderen daarop kan aanspreken. Een asset owner kan van een integrator eisen dat deze bouwt naar een target security level; een integrator kan componenten eisen die voldoen aan een component security level; een product supplier kan secure development aantonen. Het papierwerk van de ene partij wordt de zekerheid van de volgende.

## De structuur: vier groepen documenten

De reeks is georganiseerd in vier groepen, elk gericht op een andere laag. De tweecijferige nummering (`x-y`) leest als *groep–onderdeel*.

| Groep | Thema | Kernonderdelen | Wat het behandelt |
| --- | --- | --- | --- |
| **1 — Algemeen** | Concepten & terminologie | `1-1` | Concepten, terminologie en de modellen waarop de rest van de reeks voortbouwt |
| **2 — Beleid & Procedures** | Het programma | `2-1`, `2-4` | Opzetten/exploiteren van een security-programma (asset owner) en eisen voor dienstverleners |
| **3 — Systeem** | Systeemtechniek | `3-2`, `3-3` | Risicobeoordeling, zones & conduits, en systeemniveau-beveiligingseisen en -niveaus |
| **4 — Component** | Product | `4-1`, `4-2` | Secure product development lifecycle en technische eisen voor afzonderlijke componenten |

Een paar onderdelen dragen het meeste praktische gewicht:

- **`62443-1-1`** — terminologie, concepten en modellen. Het vocabulaire dat al het andere gebruikt.
- **`62443-2-1`** — eisen aan het security-programma voor **IACS asset owners** (het Cybersecurity Management System van de operator). ([ISA](https://www.isa.org/products/ansi-isa-62443-2-1-2024-security-industrial-automa))
- **`62443-2-4`** — eisen aan het security-programma voor **IACS-dienstverleners** — integrators en onderhoudscontractanten. ([IEC](https://webstore.iec.ch/en/publication/67631))
- **`62443-3-2`** — **risicobeoordeling voor systeemontwerp**: hoe u zones, conduits en target security levels definieert.
- **`62443-3-3`** — **systeembeveiligingseisen en security levels**: de gedetailleerde technische eisen waaraan een systeem moet voldoen. ([Cisco](https://www.cisco.com/c/en/us/products/collateral/security/isaiec-62443-3-3-wp.html))
- **`62443-4-1`** — **secure product development lifecycle**: wat een leverancier moet *doen* om veilige producten te ontwikkelen. ([Dragos](https://www.dragos.com/blog/isa-iec-62443-concepts))
- **`62443-4-2`** — **technische beveiligingseisen voor componenten**: wat een product moet *kunnen*.

De onderdelen grijpen op elkaar in. De componenteisen van 62443-4-2 zijn rechtstreeks afgeleid van de systeemeisen van 62443-3-3, waardoor een systeem dat is opgebouwd uit conforme componenten een echte voorsprong heeft op compliance op systeemniveau — een ontwerpeigenschap waar we in de sectie over componentbeveiliging op terugkomen.

## Zones en conduits — het kernidee

Het bepalende concept van IEC 62443 is **segmentatie naar beveiligingseis.** Een **zone** is een groepering van assets — systemen en componenten — die gemeenschappelijke beveiligingseisen delen op basis van hun functie, logische relatie en fysieke locatie. Een **conduit** is een logische of fysieke groepering van de communicatiekanalen die zones verbinden en die gemeenschappelijke beveiligingseisen delen.

De kracht van het model is dat het u dwingt na te denken over *waar risico grenzen overschrijdt*. In plaats van te proberen elk apparaat identiek te beveiligen, verdeelt u de omgeving in zones en beheerst en monitort u vervolgens de conduits ertussen. Beveiligingsinspanning concentreert zich waar het er het meest toe doet — op de grenzen — en de functies met de hoogste gevolgen kunnen in de best beschermde zones worden geplaatst. Dit is het praktische antwoord op het OT-segmentatievraagstuk, en het is de methode achter goede IT/OT-scheiding. ([Zone & conduit ontwerpgids](https://www.cagripolat.com/iec62443/en/iec-62443-zone-conduit-design-ot-practical-guide))

Een referentiearchitectuur maakt dit concreet. Van de fabrieksvloer naar boven gelezen, liggen de meest veiligheidskritische functies het diepst, en elke overgang tussen zones loopt via een beheerste conduit.

```svg
<svg viewBox="0 0 700 420" xmlns="http://www.w3.org/2000/svg" font-family="sans-serif">
  <rect width="700" height="420" fill="none"/>
  <text x="350" y="26" fill="#e5e7eb" font-size="17" font-weight="bold" text-anchor="middle">Zones &amp; conduits — referentiearchitectuur</text>

  <!-- Enterprise / IT -->
  <rect x="120" y="44" width="460" height="46" rx="6" fill="none" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="350" y="72" fill="#e5e7eb" font-size="13" text-anchor="middle">Enterprise/IT-zone  (ERP, bedrijfsnetwerk)</text>

  <!-- conduit -->
  <line x1="350" y1="90" x2="350" y2="110" stroke="#f97316" stroke-width="3"/>
  <text x="470" y="105" fill="#f97316" font-size="11" text-anchor="start">conduit (firewall)</text>

  <!-- DMZ -->
  <rect x="120" y="110" width="460" height="46" rx="6" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="350" y="138" fill="#e5e7eb" font-size="13" text-anchor="middle">OT/IT-DMZ  (jump host, patch- &amp; AV-proxy, historian-replica)</text>

  <line x1="350" y1="156" x2="350" y2="176" stroke="#f97316" stroke-width="3"/>
  <text x="470" y="171" fill="#f97316" font-size="11" text-anchor="start">conduit (alleen broker)</text>

  <!-- Supervisory -->
  <rect x="120" y="176" width="460" height="46" rx="6" fill="none" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="350" y="204" fill="#e5e7eb" font-size="13" text-anchor="middle">Supervisiezone  (SCADA-servers, engineering-werkstations)</text>

  <line x1="350" y1="222" x2="350" y2="242" stroke="#f97316" stroke-width="3"/>

  <!-- Control -->
  <rect x="120" y="242" width="460" height="46" rx="6" fill="none" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="350" y="270" fill="#e5e7eb" font-size="13" text-anchor="middle">Controlezone  (PLC's, RTU's, HMI's)</text>

  <line x1="350" y1="288" x2="350" y2="308" stroke="#f97316" stroke-width="3"/>
  <text x="470" y="303" fill="#f97316" font-size="11" text-anchor="start">conduit (eenrichting/strikt)</text>

  <!-- Safety -->
  <rect x="120" y="308" width="460" height="52" rx="6" fill="none" stroke="#3b82f6" stroke-width="2.5"/>
  <text x="350" y="332" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Veiligheidszone  (SIS — hoogste SL-T)</text>
  <text x="350" y="350" fill="#94a3b8" font-size="11" text-anchor="middle">diepst / best beschermd</text>

  <!-- side arrow -->
  <text x="60" y="200" fill="#94a3b8" font-size="11" text-anchor="middle" transform="rotate(-90 60 200)">toenemende gevolgen · toenemend target SL</text>
</svg>
```

> [!TIP]
> Teken zones op basis van *gevolgen bij compromittering*, niet op basis van netwerktopologie of leveranciersgrenzen. Twee apparaten op hetzelfde VLAN kunnen tot verschillende zones behoren als de impact van hun compromittering verschilt. Het zonediagram is in de eerste plaats een risicodocument en pas in de tweede plaats een netwerkdiagram.

## Security levels

IEC 62443 doet niet alsof elk systeem bescherming op natiestaatniveau nodig heeft. Het definieert vier **security levels** die uitdrukken *hoe sterk* de bescherming van een zone of conduit moet zijn, afgestemd op de dreiging waartegen u zich verdedigt.

| Niveau | Beschermt tegen | Aanvallersprofiel |
| --- | --- | --- |
| **SL 1** | Incidentele of toevallige schending | Geen specifieke intentie — ongelukken, vergissingen, nieuwsgierige insiders |
| **SL 2** | Opzettelijke schending met **eenvoudige middelen** | Weinig middelen, generieke vaardigheden, lage motivatie |
| **SL 3** | Opzettelijke schending met **geavanceerde middelen** | Gematigde middelen, IACS-specifieke vaardigheden, gematigde motivatie |
| **SL 4** | Opzettelijke schending met geavanceerde middelen en **uitgebreide middelen** | Ruime middelen, IACS-specifieke vaardigheden, hoge motivatie — het natiestaatniveau |

Security levels komen in drie varianten die het gesprek eerlijk houden — en ze door elkaar halen is een van de meest voorkomende fouten in de praktijk.

| Variant | Naam | Vraag die het beantwoordt | Wie het bepaalt |
| --- | --- | --- | --- |
| **SL-T** | Target | Welk niveau heeft deze zone *nodig*, gegeven het risico? | Asset owner (via `3-2`-risicobeoordeling) |
| **SL-C** | Capability | Welk niveau *kan* dit component of systeem leveren wanneer correct geconfigureerd? | Productleverancier/integrator |
| **SL-A** | Achieved | Welk niveau is *daadwerkelijk* aanwezig zodra het is geïmplementeerd en in bedrijf is? | Gemeten in het veld |

Het verschil tussen **SL-T** en **SL-A** is uw herstelbacklog, uitgedrukt op een manier die zowel een engineer als een auditor begrijpt. Een component met **SL-C 3**, geïnstalleerd in een zone met een **SL-T** van 3 maar onzorgvuldig geconfigureerd, behaalt mogelijk slechts **SL-A 1** — capability is een plafond, geen garantie.

## De zeven fundamentele eisen

Elke eis in de reeks valt terug op een van de **zeven fundamentele eisen (foundational requirements, FR's)** — een compact denkmodel voor wat "veilig" betekent in een controlesysteem. Elke FR wordt vervolgens uitgewerkt in systeemeisen (in `3-3`) en componenteisen (in `4-2`), die elk worden versterkt naarmate het security level stijgt.

| FR | Naam | Wat het betekent | Alledaags voorbeeld |
| --- | --- | --- | --- |
| **FR 1** | Identification & Authentication Control (IAC) | Weten wie en wat handelt | Unieke accounts, geen gedeelde logins, MFA voor toegang op afstand |
| **FR 2** | Use Control (UC) | De rechten die elke identiteit mag uitoefenen afdwingen | Rolgebaseerde toegang; least privilege op engineering-functies |
| **FR 3** | System Integrity (SI) | Systemen en data beschermen tegen ongeoorloofde wijziging | Ondertekende firmware, malwarebescherming, secure boot |
| **FR 4** | Data Confidentiality (DC) | Informatie beschermen tegen ongeoorloofde openbaarmaking | Versleuteling van gevoelige configuratie- en procesdata |
| **FR 5** | Restricted Data Flow (RDF) | Informatiestroom segmenteren en beheersen | Zones en conduits; deny-by-default op grenzen |
| **FR 6** | Timely Response to Events (TRE) | Beveiligingsgebeurtenissen detecteren, loggen en erop reageren | Centrale logging, monitoring, alertering bij afwijkingen |
| **FR 7** | Resource Availability (RA) | Beschermen tegen denial of service; essentiële functies operationeel houden | DoS-bescherming, redundantie, resourcelimieten |

De volgorde is veelzeggend: beschikbaarheid staat aan het eind, niet omdat het het minst belangrijk is, maar omdat het in OT vaak het *resultaat* is dat de andere eisen dienen te beschermen. FR 5 verdient een tweede blik — het is het zones-en-conduits-principe uitgedrukt als eis, en dat is waarom segmentatie geen optionele versiering is maar een fundamentele beheersmaatregel.

## Hoe Security Levels stapelen — het cumulatieve CR/RE-model

De zeven fundamentele eisen zijn geen abstracte doelen; elk valt uiteen in concrete, toetsbare **componenteisen (CR's)** in `62443-4-2` en **systeemeisen (SR's)** in `62443-3-3`. Wat die eisen tot een *niveau* maakt, is hoe ze stapelen. Elke CR/SR heeft een basisspecificatie op SL 1, en het opklimmen voegt **Requirement Enhancements (RE's)** toe — het model is dus strikt **cumulatief: SL 3 ⊇ SL 2 ⊇ SL 1.** SL 3 halen betekent niet een andere set maatregelen, maar de SL 2-set *plus* de aanvullende versterkingen die een capabelere aanvaller weren.

Die structuur heeft een gevolg dat men stelselmatig verkeerd inschat. **`62443-4-2` definieert alleen SL-C — de capaciteit van een component.** SL-T (het doel dat een zone nodig heeft) en SL-A (wat een zone in het veld werkelijk bereikt) vallen expliciet buiten de scope; die horen bij `62443-3-2` (risico-afgeleid doel) en `62443-3-3` plus operationele beoordeling (bereikt). Het risico van een zone is pas echt beheerst wanneer **SL-A ≥ SL-T** — en SL-A mag de SL-C van een component legitiem overstijgen wanneer compenserende maatregelen (firewalls, IDPS, restrictieve conduits) het verschil dragen.

| FR | Beheerst | Wat SL-2 doorgaans vereist | Wat SL-3 toevoegt (de RE's) |
| --- | --- | --- | --- |
| FR 1 (IAC) | Wie/wat handelt | Unieke accounts, RBAC, PKI | MFA, toegang per gebruiker, hardware-authenticators |
| FR 3 (SI) | Integriteit van code & data | TLS, code-signing, foutafhandeling | Hardware root of trust, secure boot |
| FR 4 (DC) | Vertrouwelijkheid | AES-128+ in transit, veilig wissen | Versleuteling at rest, hardware key management |
| FR 5 (RDF) | Segmentatie | Logische segmentatie, firewall-ACL's | Fysieke segmentatie, deep-packet inspection van OT-protocollen |
| FR 6 (TRE) | Detectie & respons | Toegankelijke auditlogs, real-time detectie | SIEM-export, anomaliedetectie, manipulatiebestendige logs |
| FR 7 (RA) | Beschikbaarheid | Basale DoS-bescherming, resourcelimieten | DoS-weerstand op applicatieniveau, gecontroleerde degradatie |

## Een uitgewerkt voorbeeld — een OT-product met vier zones

Security Levels bewijzen hun waarde wanneer een echt systeem *verschillend* risico op verschillende plaatsen draagt. Neem een representatief OT-product, na een `62443-3-2`-risicobeoordeling opgedeeld in vier zones:

| Zone | Doel (SL-T) | Dreigingsprofiel dat het moet weerstaan |
| --- | --- | --- |
| Zone 1 — besturingskern | ≥ 3 | Geavanceerde, IACS-specifieke aanvallers |
| Zone 2 — supervisie | ≥ 3 | Geavanceerde, IACS-specifieke aanvallers |
| Zone 3 — hulp/HMI | ≥ 2 | Laaggeschoolde aanvallers, generieke tools |
| Zone 4 — safety/kritiek | ≥ 4 | Statelijke actoren, uitgebreide middelen |

Het punt is niet dat alles SL 4 moet halen. Het is dat de risicobeoordeling *rechtvaardigt* om SL-4-inspanning in Zone 4 te steken en SL-2 voor Zone 3 te aanvaarden — omdat het dreigingsprofiel van Zone 3 geen verdediging tegen een statelijke actor vereist. Dit is proportionaliteit concreet gemaakt: u engineert naar het risico dat elke zone werkelijk draagt, en u kunt elke keuze verdedigen met de `3-2`-beoordeling die de SL-T-waarden opleverde. Het is ook precies de redenering die de [Cyber Resilience Act](/nl/cra) eist onder zijn "waar van toepassing"-toets.

## IEC 62443 afbeelden op de CRA — per maatregel

Hier houdt de norm op "goede praktijk" te zijn en wordt hij een compliance-instrument. De meeste betrokken OT-fabrikanten bezitten al `62443`-certificeringen, en het CENELEC-werk aan **EN IEC 62443-4-2/A11:2026** beeldt de componenteisen rechtstreeks af op de essentiële eisen van Bijlage I, deel I van de [CRA](/nl/cra). De overeenkomst is nauw genoeg om vandaag als engineering-brug te gebruiken:

| CRA Bijlage I-eis | Primaire 62443-FR | Wat SL-2 biedt | Wat SL-3 toevoegt |
| --- | --- | --- | --- |
| Bescherming tegen ongeautoriseerde toegang | FR 1 (IAC), FR 2 (UC) | Unieke accounts, RBAC, PKI | MFA, ACL's per gebruiker, hardware-authenticators |
| Vertrouwelijkheid van gegevens | FR 4 (DC) | AES-128+ in transit, veilig wissen | Versleuteling at rest, hardware key management |
| Integriteit van gegevens en programma's | FR 3 (SI) | TLS, code-signing | Hardware root of trust, secure boot |
| Minimalisering van gegevens / aanvalsoppervlak | FR 5 (RDF), FR 3 (SI) | Filtering op zonegrenzen, minimale functionaliteit | Fysieke segmentatie, deny-by-default |
| Beschikbaarheid van essentiële functies | FR 7 (RA) | Basale DoS-bescherming | DoS-weerstand op applicatieniveau, gecontroleerde degradatie |
| Logging van beveiligingsgebeurtenissen | FR 6 (TRE) | Toegankelijke auditlogs, real-time detectie | SIEM-export, anomaliedetectie, manipulatiebestendige logs |

De praktische uitkomst: een component gecertificeerd op **SL-C 2** voldoet aan FR 1–7 op SL-2-diepte, en — waar de risicobeoordeling aantoont dat die diepte passend is voor de zone — wordt dat een verdedigbare CRA-basislijn, met de SL-3-versterkingen gedocumenteerd als "niet van toepassing" onder CRA-artikel 13(4). Een `62443-4-2`-certificaat is krachtig bewijs in een CRA-technisch dossier, ook al is het op zichzelf geen CRA-conformiteitscertificaat.

## Compenserende maatregelen en de SL-A-versus-SL-C-valkuil

De meest ingrijpende fout bij het vertalen van `62443` naar een productverplichting is aannemen dat componentcapaciteit gelijkstaat aan geleverde beveiliging. Dat is niet zo — en onder de CRA wordt die kloof een juridische blootstelling.

| Situatie | Gevolg voor een CRA-technisch dossier |
| --- | --- |
| Component SL-C 2, zone SL-T 2 | ✅ SL-2-specificaties zijn de juiste basislijn |
| Component SL-C 2, zone SL-T 3, compenserende maatregelen tillen SL-A naar 3 | ⚠️ Moet documenteren *hoe* de compenserende maatregelen SL-A 3 bereiken |
| Component SL-C 2, zone SL-T 3, geen compenserende maatregelen gedocumenteerd | ❌ Beoordeling op productniveau faalt — non-conformiteit |

De les reikt verder dan compliance: een zone is slechts zo veilig als zijn *bereikte* niveau, en het bereikte niveau is een eigenschap van de hele architectuur — componenten, configuratie, conduits en monitoring samen — niet van één certificaat. Daarom beoordeelt OXOT de geïntegreerde houding, niet alleen de datasheets van componenten.

```cta
Voldoet uw geïnstalleerde beveiligingsniveau (SL-A) werkelijk aan uw doel (SL-T)?
De kloof tussen SL-A en SL-C is precies waar audits mislukken en incidenten beginnen. Wij vertalen die naar een geprioriteerde, onderbouwde saneringsbacklog die u kunt verdedigen.
Beoordeel mijn SL-kloof :: /nl/contact
```

## Volwassenheidsniveaus en de Security Protection Rating

Een beheersmaatregel hebben is niet hetzelfde als hem goed uitvoeren. Naast security levels gebruikt de reeks **volwassenheidsniveaus (maturity levels)** voor *processen*, ontleend aan bekende capability-maturity-denkwijzen. ([Overcyte](https://www.overcyte.com/frameworks/isa-iec-62443))

| Volwassenheidsniveau | Naam | Betekenis |
| --- | --- | --- |
| **ML 1** | Initial | Het proces wordt uitgevoerd, maar ad hoc en afhankelijk van individuen |
| **ML 2** | Managed | Het proces is gedocumenteerd en herhaalbaar |
| **ML 3** | Defined (Practiced) | Het proces is vastgesteld en wordt consistent toegepast binnen de organisatie |
| **ML 4** | Improving | Het proces wordt gemeten en continu verbeterd |

De **Security Protection Rating (SPR)** combineert het behaalde security level met de volwassenheid van de processen die het in stand houden. Een hoog security level dat bijeen wordt gehouden door improvisatie en ongedocumenteerde stamkennis is kwetsbaar; volwassenheid is wat bescherming duurzaam maakt. Dit is dezelfde reden waarom `62443-4-1` de *ontwikkelprocessen* van een leverancier beoordeelt op volwassenheid, en waarom `62443-2-1:2024` een volwassenheidsmodel introduceerde voor het programma van de asset owner — de reeks vraagt consequent niet alleen "is de maatregel aanwezig?" maar ook "zal hij volgend jaar nog steeds, correct, aanwezig zijn?"

---

## Componentbeveiliging — de diepgaande verkenning

Componentbeveiliging is waar IEC 62443 iets doet wat geen regelgeving doet: het definieert, in technische termen, zowel **hoe een veilig product wordt gebouwd** (`62443-4-1`) als **wat een veilig product moet kunnen** (`62443-4-2`). Voor asset owners is dit het hefboompunt in inkoop; voor leveranciers wordt het steeds meer de toegangsprijs tot de markt onder de CRA. We behandelen het uitgebreid omdat het is waar de standaard "koop veilige apparatuur" omzet in een toetsbare specificatie.

### 62443-4-1 — de secure product development lifecycle

`62443-4-1` beschrijft de **secure development lifecycle (SDL)** die een productleverancier moet volgen. Het beschrijft geen eenmalige audit aan het einde; het beschrijft de *processen* die lopen van concept tot einde levensduur, en het beoordeelt die processen op volwassenheid. De standaard organiseert ze in **acht practices** met 47 eisen op het hoogste niveau (en honderden subeisen). ([jtsec practices-overzicht](https://jtsec.es/files/IEC%2062443-4-1%20Practices%20&%20Requirementes.pdf))

| # | Practice | Code | Wat het vereist |
| --- | --- | --- | --- |
| 1 | **Security Management** | SM | Governance, rollen, verantwoording en middelen voor secure development binnen de organisatie |
| 2 | **Specification of Security Requirements** | SR | Beveiligingseisen afgeleid van een gedocumenteerd dreigingsmodel en getraceerd doorheen de ontwikkeling |
| 3 | **Secure by Design** | SD | Defence-in-depth, least privilege en secure-designprincipes ingebouwd in de architectuur |
| 4 | **Secure Implementation** | SI | Secure-coderingsstandaarden en review om het introduceren van kwetsbaarheden te voorkomen |
| 5 | **Security Verification & Validation Testing** | SVV | Beveiligingstests — functioneel, kwetsbaarheid, penetratie en robuustheid — vóór release |
| 6 | **Management of Security-Related Issues** | DM | Ontvangen, triageren, bijhouden en oplossen van gemelde gebreken en kwetsbaarheden |
| 7 | **Security Update Management** | SUM | Kwalificeren, documenteren en tijdig leveren van beveiligingspatches, inclusief voor componenten van derden |
| 8 | **Security Guidelines** | SG | Documentatie die de integrator en operator vertelt hoe het product veilig te implementeren, te hardenen en buiten gebruik te stellen |

Gelezen als een lifecycle beantwoorden deze practices de vragen die een asset owner aan een leverancier zou moeten stellen:

- **Dreigingsmodellering (SR).** Zijn de beveiligingseisen afgeleid van een echt dreigingsmodel — en wordt dat model actueel gehouden naarmate het ontwerp evolueert, in plaats van eenmalig opgesteld en gearchiveerd? ([cytal](https://cytal.co.uk/blog/iec-62443-4-1-explained-secure-development-lifecycle-requirements/))
- **Secure design en implementatie (SD, SI).** Is defence-in-depth ingebouwd, en worden secure-coderingsstandaarden gehandhaafd en beoordeeld?
- **Verificatie en validatie (SVV).** Wordt het product op beveiliging getest — inclusief robuustheids- en penetratietests — vóór het wordt uitgeleverd, met bewijs?
- **Beheer van gebreken en kwetsbaarheden (DM).** Is er een echt proces om kwetsbaarheidsmeldingen te ontvangen, te triageren en gecoördineerde openbaarmaking te regelen — niet slechts een postbus die niemand leest?
- **Patchbeheer (SUM).** Worden beveiligingsupdates tijdig gekwalificeerd, gedocumenteerd en geleverd, ook voor ingebedde bibliotheken van derden?
- **Einde levensduur van het product (SG).** Geeft de handleiding aan wanneer ondersteuning eindigt en hoe veilig buiten gebruik te stellen — zodat een operator niet blijft zitten met een verlaten product op een kritiek proces?

> [!IMPORTANT]
> `62443-4-1` gaat over **procesvolwassenheid**, niet over een eenmalige test. De SDL van een leverancier kan onafhankelijk worden beoordeeld — bijvoorbeeld onder het ISASecure-programma **SDLA (Secure Development Lifecycle Assurance)** — en beoordeeld op ML 1–4. Vraag leveranciers om de beoordeling, niet alleen de marketingclaim. ([ISASecure CSA](https://isasecure.org/certification/iec-62443-csa-certification))

### 62443-4-2 — technische eisen per componenttype

Waar `4-1` over de *maker* gaat, gaat `62443-4-2` over het *product*. Het specificeert **Component Requirements (CR's)** waaraan een apparaat of applicatie moet kunnen voldoen, georganiseerd onder dezelfde zeven fundamentele eisen en geschaald over SL 1–4. Eisen zijn opgesplitst naar componenttype, omdat een PLC en een SCADA-server redelijkerwijs niet aan identieke technische maatregelen kunnen voldoen. ([Keyfactor](https://www.keyfactor.com/blog/iec-62443-4-2-technical-security-requirements-for-iacs-components/))

| Code | Componenttype | Definitie | Typische voorbeelden |
| --- | --- | --- | --- |
| **EDR** | Embedded Device Requirement | Speciaal apparaat met embedded software, meestal met een beperkt besturingssysteem | PLC's, RTU's, IED's, IIoT-sensoren |
| **HDR** | Host Device Requirement | Algemeen apparaat met een volledig besturingssysteem | Engineering-werkstations, HMI's, servers |
| **NDR** | Network Device Requirement | Apparaat dat netwerkverkeer transporteert, routeert of beheerst | Firewalls, switches, routers, gateways |
| **SAR** | Software Application Requirement | Software die op een host draait en IACS-functies levert | SCADA, MES, historian, engineeringsoftware |

Elk componenttype wordt getoetst aan de zeven FR's, en elke eis krijgt **requirement enhancements (RE's)** naarmate het security level stijgt — dus authenticatie die acceptabel is op SL 1 moet bijvoorbeeld sterker en moeilijker te omzeilen worden om aan SL 3 te voldoen. ([INCIBE](https://www.incibe.es/en/incibe-cert/blog/iec-62443-4-2-need-secure-components))

De kritieke ontwerpeigenschap is **afleiding**: de componenteisen in `4-2` zijn rechtstreeks ontleend aan de systeemeisen in `3-3`. Dat is wat de rollen in staat stelt netjes samen te werken — de asset owner bepaalt een target SL voor een zone, de integrator bouwt de zone volgens `3-3`, en de componenten daarin dragen `4-2`-capaciteit die bijdraagt aan de systeemclaim.

```svg
<svg viewBox="0 0 700 340" xmlns="http://www.w3.org/2000/svg" font-family="sans-serif">
  <rect width="700" height="340" fill="none"/>
  <text x="350" y="28" fill="#e5e7eb" font-size="16" font-weight="bold" text-anchor="middle">Hoe componenteisen worden afgeleid — en rollen samenwerken</text>

  <!-- FR box -->
  <rect x="270" y="48" width="160" height="44" rx="6" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="350" y="70" fill="#e5e7eb" font-size="12" text-anchor="middle">7 fundamentele</text>
  <text x="350" y="85" fill="#e5e7eb" font-size="12" text-anchor="middle">eisen</text>

  <line x1="350" y1="92" x2="350" y2="118" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#a)"/>

  <!-- 3-3 -->
  <rect x="230" y="118" width="240" height="46" rx="6" fill="none" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="350" y="140" fill="#e5e7eb" font-size="12" text-anchor="middle">62443-3-3 · systeemeisen (SR)</text>
  <text x="350" y="156" fill="#94a3b8" font-size="11" text-anchor="middle">per zone bepaald op target SL — gebouwd door de integrator</text>

  <line x1="350" y1="164" x2="350" y2="190" stroke="#f97316" stroke-width="2" marker-end="url(#b)"/>
  <text x="480" y="182" fill="#f97316" font-size="11" text-anchor="start">leidt af</text>

  <!-- 4-2 -->
  <rect x="230" y="190" width="240" height="46" rx="6" fill="none" stroke="#94a3b8" stroke-width="1.5"/>
  <text x="350" y="212" fill="#e5e7eb" font-size="12" text-anchor="middle">62443-4-2 · componenteisen (CR)</text>
  <text x="350" y="228" fill="#94a3b8" font-size="11" text-anchor="middle">EDR · HDR · NDR · SAR — geleverd door de leverancier</text>

  <line x1="350" y1="236" x2="350" y2="262" stroke="#94a3b8" stroke-width="1.5" marker-end="url(#a)"/>

  <!-- 4-1 -->
  <rect x="230" y="262" width="240" height="46" rx="6" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="350" y="284" fill="#e5e7eb" font-size="12" text-anchor="middle">62443-4-1 · secure development lifecycle</text>
  <text x="350" y="300" fill="#94a3b8" font-size="11" text-anchor="middle">het proces dat CR-capaciteit geloofwaardig maakt</text>

  <!-- role labels -->
  <text x="120" y="141" fill="#3b82f6" font-size="11" text-anchor="middle">Integrator</text>
  <text x="120" y="213" fill="#f97316" font-size="11" text-anchor="middle">Leverancier</text>
  <text x="120" y="285" fill="#f97316" font-size="11" text-anchor="middle">Leverancier</text>
  <text x="600" y="71" fill="#3b82f6" font-size="11" text-anchor="middle">Asset owner</text>
  <text x="600" y="85" fill="#94a3b8" font-size="10" text-anchor="middle">bepaalt SL-T</text>

  <defs>
    <marker id="a" markerWidth="8" markerHeight="8" refX="4" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 Z" fill="#94a3b8"/></marker>
    <marker id="b" markerWidth="8" markerHeight="8" refX="4" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 Z" fill="#f97316"/></marker>
  </defs>
</svg>
```

### Wat asset owners van leveranciers moeten eisen

Componentbeveiliging loont alleen als het in inkoop wordt vastgelegd. Praktische verzoeken:

- Een vastgesteld **SL-C** per fundamentele eis voor elk product, en de configuratie die nodig is om het te behalen.
- Bewijs van een `62443-4-1`-**SDL-beoordeling** (bij voorkeur door een derde partij, met een volwassenheidsniveau) — geen zelfverklaarde claim.
- Een **Software Bill of Materials (SBOM)** en een gedocumenteerd proces voor **kwetsbaarheidsafhandeling en -openbaarmaking** (DM).
- Een **toezegging voor beveiligingsupdates** (SUM): cadans, kwalificatie, en hoe fixes voor bibliotheken van derden u bereiken.
- **Hardening- en einde-levensduur-richtlijnen** (SG), inclusief de ondersteuningsperiode en veilige buitengebruikstelling.

> [!NOTE]
> ISASecure certificeert beide kanten van componentbeveiliging: **CSA (Component Security Assurance)** voor producten tegen `4-2`, en **SDLA** voor ontwikkelprocessen tegen `4-1`. Sommige sectororganisaties stellen dat **SL 2** het praktische minimum zou moeten zijn voor nieuwe componenten in plaats van SL 1. ([ISASecure — het pleidooi voor SL 2](https://www.isasecure.org/hubfs/The-Case-for-ISA-IEC-62443-Security-Level-2-as-a-Minimum-FINAL.pdf))

### Waarom componentbeveiliging de CRA ondersteunt

De EU-**[Cyber Resilience Act](/nl/cra)** vereist dat fabrikanten van producten met digitale elementen beveiliging by design en by default inbouwen, en kwetsbaarheden afhandelen gedurende een vastgestelde ondersteuningsperiode (bijlage I, delen I en II). ENISA en de sector zelf merken op dat een product dat is gebouwd volgens `4-2` en ontwikkeld volgens `4-1` al veel van wat bijlage I vereist, invult. ([exida over 62443 & de CRA](https://www.exida.com/blog/how-iec-62443-can-help-achieve-compliance-with-the-eu-cyber-resilience-act-cra))

| Thema uit CRA-bijlage I | Waar 62443 het beantwoordt |
| --- | --- |
| Security by design & by default (deel I) | `4-1` SD/SI · `4-2` CR's op target SL |
| Veilige configuratie & least privilege | `4-2` FR 1 (IAC) & FR 2 (UC) |
| Bescherming van data-integriteit & vertrouwelijkheid | `4-2` FR 3 (SI) & FR 4 (DC) |
| Reductie van het aanvalsoppervlak & DoS-weerbaarheid | `4-2` FR 5 (RDF) & FR 7 (RA) |
| Kwetsbaarheidsafhandeling & gecoördineerde openbaarmaking (deel II) | `4-1` DM (issuebeheer) |
| Beveiligingsupdates gedurende de ondersteuningsperiode | `4-1` SUM (updatebeheer) |
| Verstrekken van een SBOM | `4-1` SM/SUM-componentinventarisatie |

De afstemming is nauw maar niet automatisch: de CRA is wetgeving met een eigen conformiteitsbeoordeling, en 62443 is het technische bewijs dat conformiteit verdedigbaar maakt in plaats van een papieren exercitie.

---

## Het security-programma — de diepgaande verkenning

Technologie alleen maakt een operator niet veilig; een *programma* doet dat. Groep 2 van de reeks behandelt de organisatorische motor die al het andere laat draaien — governance, risicobeheer, beleid, competentie en bedrijfsvoering — verdeeld over de asset owner (`62443-2-1`) en de dienstverleners die namens hen werken (`62443-2-4`). Dit is de laag waar NIS2 het meest om geeft, en daarom behandelen we deze uitgebreid.

### 62443-2-1 — het security-programma van de asset owner

`62443-2-1` specificeert de eisen voor een asset owner om een **IACS-security-programma op te zetten en te exploiteren** — historisch omschreven als een Cybersecurity Management System (CSMS), de OT-tegenhanger van een ISMS. De **editie van 2024** herstructureerde de eisen in **Security Programme Elements (SPE's)**, verwijderde overlap met ISO/IEC 27001-achtig informatiebeveiligingsbeheer, en voegde een **volwassenheidsmodel** toe voor het beoordelen van elke eis. ([Industrial Cyber over 2-1:2024](https://industrialcyber.co/isa-iec-62443/iec-publishes-iec-62443-2-12024-setting-security-standards-for-industrial-automation-and-control-systems/))

Het programma draait als een continue cyclus in plaats van een eenmalig project:

```svg
<svg viewBox="0 0 700 360" xmlns="http://www.w3.org/2000/svg" font-family="sans-serif">
  <rect width="700" height="360" fill="none"/>
  <text x="350" y="28" fill="#e5e7eb" font-size="16" font-weight="bold" text-anchor="middle">De levenscyclus van het IACS-security-programma (62443-2-1)</text>

  <!-- centre -->
  <circle cx="350" cy="190" r="52" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="350" y="186" fill="#e5e7eb" font-size="12" text-anchor="middle">Sturen &amp;</text>
  <text x="350" y="202" fill="#e5e7eb" font-size="12" text-anchor="middle">verbeteren</text>

  <!-- nodes -->
  <g fill="none" stroke="#94a3b8" stroke-width="1.5">
    <rect x="270" y="60" width="160" height="42" rx="6"/>
    <rect x="500" y="150" width="170" height="42" rx="6"/>
    <rect x="430" y="290" width="180" height="42" rx="6"/>
    <rect x="90" y="290" width="180" height="42" rx="6"/>
    <rect x="30" y="150" width="170" height="42" rx="6"/>
  </g>
  <text x="350" y="86" fill="#e5e7eb" font-size="12" text-anchor="middle">1 · Risicobeoordeling</text>
  <text x="585" y="176" fill="#e5e7eb" font-size="12" text-anchor="middle">2 · Beleid &amp; organisatie</text>
  <text x="520" y="316" fill="#e5e7eb" font-size="12" text-anchor="middle">3 · Maatregelen &amp; competentie</text>
  <text x="180" y="316" fill="#e5e7eb" font-size="12" text-anchor="middle">4 · Uitvoeren &amp; reageren</text>
  <text x="115" y="176" fill="#e5e7eb" font-size="12" text-anchor="middle">5 · Monitoren &amp; auditen</text>

  <!-- arrows around -->
  <g stroke="#f97316" stroke-width="2" fill="none" marker-end="url(#c)">
    <path d="M430 84 Q520 100 560 150"/>
    <path d="M585 192 Q560 250 520 290"/>
    <path d="M430 315 Q350 340 270 315"/>
    <path d="M180 290 Q120 250 115 192"/>
    <path d="M120 150 Q180 100 270 84"/>
  </g>
  <defs>
    <marker id="c" markerWidth="9" markerHeight="9" refX="4.5" refY="4.5" orient="auto"><path d="M0,0 L9,4.5 L0,9 Z" fill="#f97316"/></marker>
  </defs>
</svg>
```

Wat een volwassen asset-owner-programma bevat:

- **Governance en verantwoording.** Benoemd eigenaarschap, een beleidskader, en betrokkenheid van het management. De asset owner blijft *verantwoordelijk*, ook waar leveranciers het werk uitvoeren. ([ISA-productpagina](https://www.isa.org/products/ansi-isa-62443-2-1-2024-security-industrial-automa))
- **Risicobeheer.** Een terugkerende, gedocumenteerde IACS-risicobeoordeling (die het `3-2`-zone-/conduitwerk en SL-T-werk voedt) die het programma afgestemd houdt op werkelijke gevolgen.
- **Beleid en procedures.** Toegangsbeheer, wijzigingsbeheer, netwerkbeveiliging en veilige configuratie — vastgelegd op papier, niet alleen in hoofden van mensen.
- **Competentie en bewustzijn.** Rollen, training en cyberhygiëne voor de mensen die de installatie bedienen.
- **Bedrijfsvoering.** Monitoring, incidentrespons, back-up en herstel, en patch-/kwetsbaarheidsafhandeling als lopende processen.
- **Volwassenheid en continue verbetering.** Elk element beoordeeld tegen het volwassenheidsmodel en na verloop van tijd verbeterd — nogmaals het punt van duurzaamheid.

> [!IMPORTANT]
> `62443-2-1:2024` staat bewust **implementatieflexibiliteit** toe voor verouderde installaties, met erkenning dat veel operationele systemen draaien op hardware en software die niet meer gepatcht kan worden. De taak van het programma is om die realiteit te beheersen met compenserende maatregelen, niet om ze te negeren. ([Industrial Cyber](https://industrialcyber.co/isa-iec-62443/iec-publishes-iec-62443-2-12024-setting-security-standards-for-industrial-automation-and-control-systems/))

### 62443-2-4 — eisen voor dienstverleners

Een operator bouwt en onderhoudt zelden alleen haar eigen IACS. `62443-2-4` specificeert de **eisen aan het security-programma voor IACS-dienstverleners** — de integrators en onderhoudscontractanten die de automatiseringsoplossing leveren en ondersteunen. Het definieert de beveiligings*capaciteiten* (steeds vaker omschreven als gedocumenteerde *processen*) die een dienstverlener moet bieden bij integratie- en onderhoudsactiviteiten. ([IEC](https://webstore.iec.ch/en/publication/67631))

In de praktijk is `2-4` waar een asset owner naar verwijst bij het vastleggen van beveiliging in een contract: het behandelt veilige engineeringpraktijken, hardening tijdens Factory en Site Acceptance Testing (FAT/SAT), afhandeling van accounts en toegang op afstand, patch- en back-upprocessen, en hoe de dienstverlener zijn beveiligingsrichtlijnen handhaaft tijdens de onderhoudsfase. Het is de brug tussen het programma van de operator (`2-1`) en de componenten die deze koopt (`4-1`/`4-2`) — de zekerheid dat de mensen die uw systeem aanraken werken volgens een vastgestelde standaard.

### Hoe het programma voldoet aan NIS2 artikel 21

NIS2 vereist "passende en proportionele" technische en organisatorische risicobeheersmaatregelen, en **artikel 21, lid 2**, somt daar tien van op. Het security-programma in groep 2 (met ondersteuning van groep 3) sluit hier bijna één-op-één op aan — en dat is waarom het opbouwen van het programma volgens 62443 u in staat stelt NIS2 te onderbouwen zonder een parallelle structuur te hoeven bedenken. ([NIS2 artikel 21 — de 10 maatregelen](https://www.glocertinternational.com/resources/guides/nis2-article-21-risk-management-measures-explained/))

| NIS2-maatregel artikel 21, lid 2 | Waar 62443 het levert |
| --- | --- |
| (a) Risicoanalyse & informatiebeveiligingsbeleid | `2-1` risicobeheer & beleid · `3-2` risicobeoordeling |
| (b) Incidentafhandeling | `2-1` bedrijfsvoering · FR 6 (TRE) |
| (c) Bedrijfscontinuïteit, back-up & crisisbeheer | `2-1` bedrijfsvoering (back-up/herstel) |
| (d) Beveiliging van de toeleveringsketen | `2-4` dienstverleners · `4-1`/`4-2` voor producten |
| (e) Beveiliging bij verwerving, ontwikkeling & onderhoud (incl. kwetsbaarheidsafhandeling) | `4-1` (DM, SUM) · `2-4` onderhoud |
| (f) Beoordelen van de doeltreffendheid van maatregelen | `2-1` volwassenheidsmodel, monitoring & audit |
| (g) Cyberhygiëne & training | `2-1` competentie & bewustzijn |
| (h) Cryptografie & versleuteling | FR 3 (SI) & FR 4 (DC) in `3-3`/`4-2` |
| (i) Personeelsbeveiliging, toegangsbeheer & assetbeheer | FR 1 (IAC) & FR 2 (UC) · `2-1` assetbeheer |
| (j) MFA, beveiligde communicatie | FR 1-RE's op hogere SL's |

## IEC 62443 en de andere regelgeving

De Europese regelgeving stelt de uitkomsten vast; IEC 62443 levert de erkende methode om ze te bereiken en te onderbouwen. Naast NIS2 en de CRA, hierboven al behandeld:

- **De [AI Act](/nl/ai-act)** vereist nauwkeurigheid, robuustheid en cybersecurity voor hoogrisico-AI-systemen (artikel 15). Waar zulke systemen zich binnen een IACS bevinden, zijn het zonemodel en de systeemeisen van 62443 het middel om ze te beschermen.
- **De [Machineverordening](/nl/machine-act)** brengt cybersecurity die relevant is voor veiligheid onder in de CE-markering van machines; de component- en systeemeisen van 62443 geven machinebouwers een route om dit aan te tonen.
- **[TS 50701](/nl/ts-50701)** past de concepten en de risicobeoordelingsmethode van 62443 toe op de spoorsector, aangepast aan de veiligheidslevenscyclus van het spoor.

Uw regelgevingsaanpak afstemmen op IEC 62443 betekent dat u eenmaal bouwt en aan velen voldoet — en dat u een taal spreekt die toezichthouders, auditors, integrators en leveranciers al herkennen. Ons **[Frameworks](/nl/frameworks)**-overzicht laat zien hoe deze onderdelen samenkomen.

## Wat het betekent voor uw rol

**Als u asset owner/operator bent**, verandert IEC 62443 "maak het veilig" in een specificatie. Bepaal een target security level per zone (`3-2`), voer een echt security-programma uit (`2-1`), en houd integrators (`2-4`) en leveranciers (`4-1`/`4-2`) aan die cijfers in contracten.

**Als u engineer of integrator bent**, is de reeks uw ontwerpmethode: voer een risicobeoordeling uit (`3-2`), definieer zones en conduits, bepaal target security levels, en bouw systemen (`3-3`) uit componenten (`4-2`) die daaraan voldoen — terwijl u voldoet aan `2-4` in hoe u oplevert.

**Als u productleverancier bent**, zijn `4-1` en `4-2` uw route naar de markt: een aantoonbare secure development lifecycle en componenten met een vastgestelde, bij voorkeur gecertificeerde, beveiligingscapaciteit — wat snel het toegangsbewijs wordt onder de CRA.

## Hoe OXOT IEC 62443 gebruikt

IEC 62443 is de ruggengraat van hoe OXOT werkt. Onze **OT-beveiligingsassessments** zijn gestructureerd rond de risicobeoordelingsmethode (`62443-3-2`), en leveren zone- en conduitmodellen en target security levels op, gegrond in uw werkelijke operationele risico. Onze **[Cyber Digital Twin](/nl/cyber-digital-twin)** bewaart die structuur als een levend model — zones, conduits, assets en de kloof tussen target en behaald security level — zodat u investeringen kunt prioriteren en uw redenering kunt tonen. Onze **OT-beveiligingsprogramma's** bouwen de `2-1`-motor; ons werk op het gebied van **architectuur & segmentatie** levert het ontwerp in de praktijk; en **capaciteitsoverdracht** zorgt ervoor dat uw team het kan bedienen en in stand houden. IEC 62443 is geen document dat wij citeren; het is de methode waarmee wij bouwen.

## Veelgestelde vragen

**Is IEC 62443 verplicht?**
Niet op zichzelf — het is een vrijwillige internationale standaard. Maar het is de erkende methode om compliance aan te tonen met verplichte regimes zoals NIS2 en de CRA, en veel contracten en sectortoezichthouders verwachten het inmiddels.

**Hebben we overal SL 4 nodig?**
Nee — dat zou disproportioneel en kostbaar zijn. U bepaalt een *target* security level per zone op basis van de gevolgen van compromittering. De meeste zones hebben SL 1–2 nodig; alleen de functies met de hoogste gevolgen rechtvaardigen SL 3 of 4.

**Wat is het verschil tussen een security level en een maturity level?**
Een **security level (SL 1–4)** beoordeelt de sterkte van de bescherming van een systeem of component. Een **maturity level (ML 1–4)** beoordeelt hoe goed het *proces* erachter is vastgesteld en verbeterd. Een sterke beheersmaatregel uitgevoerd door een onvolwassen proces is kwetsbaar — de Security Protection Rating combineert beide.

**Is 62443-4-2-certificering hetzelfde als CRA-conform zijn?**
Nee, maar het is het grootste deel van het werk. Een product dat is gebouwd volgens `4-2` en ontwikkeld onder `4-1` voldoet aan veel van CRA-bijlage I, maar de CRA heeft haar eigen wettelijke conformiteitsbeoordeling. Behandel 62443 als het technische bewijs, niet als de juridische goedkeuring. Zie onze **[CRA](/nl/cra)**-pagina.

**Hoe verhoudt IEC 62443 zich tot TS 50701?**
**[TS 50701](/nl/ts-50701)** is IEC 62443 gespecialiseerd voor het spoor — dezelfde concepten en risicomethode, aangepast aan de veiligheidslevenscyclus van het spoor.

**Waar beginnen we?**
Met een risicogebaseerde beoordeling: inventariseer uw assets, definieer zones en conduits, bepaal target security levels, en meet de kloof. Die beoordeling is het fundament waarop al het andere voortbouwt — en het is precies wat OXOT als eerste levert.

## Sources

- ANSI/ISA-62443-2-1-2024, Security Program Requirements for IACS Asset Owners — [ISA](https://www.isa.org/products/ansi-isa-62443-2-1-2024-security-industrial-automa)
- IEC 62443-2-1:2024 publication note — [Industrial Cyber](https://industrialcyber.co/isa-iec-62443/iec-publishes-iec-62443-2-12024-setting-security-standards-for-industrial-automation-and-control-systems/)
- IEC 62443-2-4:2023, Security Program Requirements for IACS Service Providers — [IEC](https://webstore.iec.ch/en/publication/67631)
- ISA/IEC 62443-3-3 overview — [Cisco](https://www.cisco.com/c/en/us/products/collateral/security/isaiec-62443-3-3-wp.html)
- IEC 62443-4-1 practices & requirements — [jtsec](https://jtsec.es/files/IEC%2062443-4-1%20Practices%20&%20Requirementes.pdf)
- IEC 62443-4-1 explained — [CyTAL](https://cytal.co.uk/blog/iec-62443-4-1-explained-secure-development-lifecycle-requirements/)
- IEC 62443-4-2 technical security requirements for components — [Keyfactor](https://www.keyfactor.com/blog/iec-62443-4-2-technical-security-requirements-for-iacs-components/)
- IEC 62443-4-2, the need to secure components — [INCIBE-CERT](https://www.incibe.es/en/incibe-cert/blog/iec-62443-4-2-need-secure-components)
- ISASecure CSA / SDLA certification — [ISASecure](https://isasecure.org/certification/iec-62443-csa-certification)
- The case for SL 2 as a minimum — [ISASecure](https://www.isasecure.org/hubfs/The-Case-for-ISA-IEC-62443-Security-Level-2-as-a-Minimum-FINAL.pdf)
- IEC 62443 concepts for OT security teams — [Dragos](https://www.dragos.com/blog/isa-iec-62443-concepts)
- ISA/IEC 62443 series overview — [ISA](https://www.isa.org/standards-and-publications/isa-standards/isa-iec-62443-series-of-standards)
- Maturity levels & framework overview — [Overcyte](https://www.overcyte.com/frameworks/isa-iec-62443)
- How IEC 62443 helps with the CRA — [exida](https://www.exida.com/blog/how-iec-62443-can-help-achieve-compliance-with-the-eu-cyber-resilience-act-cra)
- NIS2 Article 21 — the 10 risk-management measures — [Gloce International](https://www.glocertinternational.com/resources/guides/nis2-article-21-risk-management-measures-explained/)
- IEC 62443 zone & conduit design — [Çağrı Polat](https://www.cagripolat.com/iec62443/en/iec-62443-zone-conduit-design-ot-practical-guide)
- IEC 62443 overview — [Fortinet](https://www.fortinet.com/resources/cyberglossary/iec-62443)
- IEC 62443 — IEC SyC Smart Energy — [IEC](https://syc-se.iec.ch/deliveries/cybersecurity-guidelines/security-standards-and-best-practices/iec-62443/)

*Deze pagina bevat algemene educatieve informatie over de IEC 62443-reeks. Raadpleeg de officiële IEC/ISA-standaarden voor gezaghebbende eisen.*$MDBODY$, true, $MDBODY$IEC 62443 uitgelegd — zones, security levels, componentbeveiliging & het security-programma | OXOT$MDBODY$, $MDBODY$Een praktische, diepgaande gids over de ISA/IEC 62443-reeks — de vier documentgroepen, zones en conduits, security levels SL 1–4 (SL-T/C/A), de zeven fundamentele eisen, volwassenheid en de Security Protection Rating, de rollen van asset owner/integrator/leverancier, plus uitgebreide secties over componentbeveiliging (62443-4-1 secure development & 62443-4-2 componenteisen) en het IACS-beveiligingsprogramma (62443-2-1 & 2-4) — en hoe dit NIS2 en de CRA ondersteunt.$MDBODY$, $MDBODY$De internationale standaard voor het beveiligen van industriële automatiserings- en controlesystemen — concepten, structuur, componentbeveiliging, het security-programma, en hoe u het in de praktijk toepast.$MDBODY$, NULL, $MDBODY$page$MDBODY$, now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET
  title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published,
  meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description,
  excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type,
  published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now()
WHERE length(pages.body) < length(EXCLUDED.body);

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ($MDBODY$ts-50701$MDBODY$, $MDBODY$en$MDBODY$, $MDBODY$TS 50701 — Railway Cybersecurity$MDBODY$, $MDBODY$A modern train is a data centre on wheels running through a network that stretches across an entire country. Signalling interlockings, on-board control units, traffic-management systems, passenger information, trackside sensors, remote maintenance links — all of it now digital, much of it connected, and every piece expected to keep working safely for thirty years or more. Rail is one of the hardest places on earth to do cybersecurity: safety-critical, geographically sprawling, assembled from a long chain of suppliers, and governed by a safety culture that predates the internet.

For a long time, rail had no cybersecurity standard of its own. Engineers borrowed generic industrial guidance, stretched it over railway architecture, and hoped the fit was close enough. **CLC/TS 50701 ended that improvisation.** Published in July 2021, it is the first cybersecurity specification written specifically for railway applications, and it has become the reference point for securing signalling, control-command, rolling stock and rail infrastructure across Europe and beyond.

## The short version

- **CLC/TS 50701** is a CENELEC Technical Specification for **cybersecurity in railway applications**. Its first edition was published in **July 2021** — the world's first comprehensive cybersecurity specification built for rail. A **second edition (CLC/TS 50701:2023)** followed in August 2023. ([CLC/TS 50701:2023 guide, iTeh](https://standards.iteh.ai/catalog/standards/clc/db257ea9-8ba0-4f4c-a791-df34a6030541/clc-ts-50701-2023))
- It is **not standalone**. It **applies the [IEC 62443](/en/iec-62443) series** to the railway context, adapting its security models, concepts and risk-assessment process — leaning especially on **IEC 62443-3-2** and **62443-3-3**. ([ENISA / CENELEC](https://www.enisa.europa.eu/sites/default/files/all_files/05-standards-02-cenelec-christian-schlehuber.pdf))
- It integrates with the railway **RAMS lifecycle** defined in **EN 50126-1**, so cybersecurity is engineered alongside reliability, availability, maintainability and safety — not bolted on afterwards.
- It was authored by **CENELEC TC 9X/WG 26**, a working group of dozens of European rail and security experts, and now feeds directly into the coming **international standard IEC 63452**. ([Alstom](https://www.alstom.com/press-releases-news/2024/3/towards-first-railway-cybersecurity-international-standard-why-standards-are-important-secure-railways))

> [!NOTE]
> A note on naming. You will see this document written as **CLC/TS 50701**, **TS 50701**, or with a year suffix (**:2021**, **:2023**). "CLC" marks it as a CENELEC deliverable; "TS" marks it as a Technical Specification rather than a full European Norm. The 2021 first edition and the 2023 second edition are the same document maturing, not two competing standards.

```keyfacts
Type :: CENELEC Technical Specification (CLC/TS) — not a full EN
First edition :: July 2021 — world's first rail-specific cybersecurity spec
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

The higher the target security level of a zone, the more of each FR's requirement enhancements apply — which is exactly how a signalling interlocking (SL-3/SL-4) ends up with far stricter controls than a passenger-information display (SL-1/SL-2), even though both are assessed against the same seven headings.

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

TS 50701 gives this interface a formal home. It requires that cybersecurity work take into account relevant safety-related aspects, and it draws on established safety machinery — notably the **Common Safety Method for Risk Assessment (CSM-RA)**, the EU regulation that governs how significant changes to the railway system are risk-assessed — alongside security sources such as IEC 62443-3-3. ([Shieldworkz](https://shieldworkz.com/blogs/a-deep-dive-into-ts-50701-based-risk-and-security-assessment)) The specification's later editions go further, recommending **joint design reviews** so that safety and security engineers assess changes together rather than in sequence.

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
> The classic rail trap is treating a security patch like a routine IT update. In a safety-critical system, a change that alters timing or behaviour can invalidate the safety case. TS 50701's insistence on a managed safety–security interface exists precisely so that a well-intentioned security action does not quietly become a safety hazard.

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

The railway adaptation shows up in *which* assets fall into *which* zones, and in how consequences are weighted by safety criticality. A signalling interlocking sits in a different world from a passenger Wi-Fi access point, and TS 50701's zoning reflects that. The illustrative pattern below is typical of how criticality drives target SLs.

| Zone (illustrative) | Example assets | Safety criticality | Typical target SL |
| --- | --- | --- | --- |
| Signalling & interlocking | Interlockings, object controllers, ETCS on-board/trackside | Safety-critical | SL-3 / SL-4 |
| Control-command & traffic management | TMS, dispatching, ATS | High operational | SL-2 / SL-3 |
| Rolling stock control | Train control units, on-board networks (TCN) | Safety-related | SL-2 / SL-3 |
| Operational support | SCADA for power, HVAC, tunnel systems | Operational | SL-2 |
| Passenger & non-vital | CCTV, passenger information, on-board Wi-Fi | Low / non-vital | SL-1 / SL-2 |

The output is what any good OT security assessment should produce: a structured, defensible model of where risk concentrates, what protection each zone needs, and where the current design falls short — expressed in the language of both the security standard and the railway lifecycle.

### A worked example: the trackside-to-on-board conduit

Consider one concrete pathway: the **radio conduit** carrying movement authorities between a trackside **ETCS/RBC** (radio block centre) and a train's on-board unit. It is the artery of modern signalling, and it crosses an open medium.

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
July 2021 :: **CLC/TS 50701 first edition** — the world's first cybersecurity specification written specifically for railway applications.
August 2023 :: **CLC/TS 50701:2023 second edition** — the specification matures: refined risk process, MITRE ATT&CK for ICS referenced as a threat library, clearer safety–security interface guidance.
2024 onward :: **IEC 63452 in development** — CENELEC's rail cybersecurity work feeds the first international standard, globalising the TS 50701 approach.
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

OXOT's method is built on [IEC 62443](/en/iec-62443) — the exact foundation TS 50701 extends — so our approach maps directly onto rail. Our **OT security assessments** apply the same zones-and-conduits and target-security-level logic that TS 50701 shares with IEC 62443, framed in railway terms and mindful of the safety lifecycle. Our **[Cyber Digital Twin](/en/cyber-digital-twin)** holds the resulting model — assets, zones, conduits, safety–security interfaces and security-level gaps — as a living structure that serves both the security programme and the safety case at once.

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

*This page is general educational information. Refer to the official CENELEC CLC/TS 50701 (and the forthcoming EN / IEC 63452) documents for authoritative requirements.*$MDBODY$, true, $MDBODY$CLC/TS 50701 Railway Cybersecurity Explained | OXOT$MDBODY$, $MDBODY$CLC/TS 50701 explained in depth — the first cybersecurity specification for rail, how it applies IEC 62443 to railway systems, its integration with the EN 50126 RAMS lifecycle, the safety–security interface, zones and conduits, NIS2 and CRA relevance, and the road to IEC 63452.$MDBODY$, $MDBODY$The cybersecurity specification for rail — IEC 62443 adapted to railway applications and welded into the safety lifecycle.$MDBODY$, NULL, $MDBODY$page$MDBODY$, now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET
  title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published,
  meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description,
  excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type,
  published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now()
WHERE length(pages.body) < length(EXCLUDED.body);

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ($MDBODY$ts-50701$MDBODY$, $MDBODY$nl$MDBODY$, $MDBODY$TS 50701 — Cybersecurity voor spoorwegen$MDBODY$, $MDBODY$Een moderne trein is een datacenter op wielen dat door een netwerk rijdt dat zich uitstrekt over een heel land. Seingevingsinterlockings, boordbesturingseenheden, verkeersmanagementsystemen, reizigersinformatie, langs het spoor geplaatste sensoren, remote-onderhoudsverbindingen — het is allemaal inmiddels digitaal, veel ervan verbonden, en elk onderdeel moet dertig jaar of langer veilig blijven functioneren. Het spoor is een van de moeilijkste plekken ter wereld om cybersecurity toe te passen: veiligheidskritisch, geografisch wijdverspreid, opgebouwd uit een lange keten van leveranciers, en geregeerd door een veiligheidscultuur die ouder is dan het internet.

Lange tijd had het spoor geen eigen cybersecuritynorm. Ingenieurs leenden generieke industriële richtlijnen, rekten die uit over de spoorwegarchitectuur en hoopten dat de pasvorm goed genoeg was. **CLC/TS 50701 maakte een einde aan die improvisatie.** Gepubliceerd in juli 2021, is dit de eerste cybersecurityspecificatie die specifiek is geschreven voor spoorwegtoepassingen, en het is uitgegroeid tot het referentiepunt voor het beveiligen van seingeving, control-command, rollend materieel en spoorweginfrastructuur in heel Europa en daarbuiten.

## De korte versie

- **CLC/TS 50701** is een CENELEC Technical Specification voor **cybersecurity in spoorwegtoepassingen**. De eerste editie werd gepubliceerd in **juli 2021** — 's werelds eerste uitgebreide cybersecurityspecificatie die speciaal voor het spoor is gebouwd. Een **tweede editie (CLC/TS 50701:2023)** volgde in augustus 2023. ([CLC/TS 50701:2023-gids, iTeh](https://standards.iteh.ai/catalog/standards/clc/db257ea9-8ba0-4f4c-a791-df34a6030541/clc-ts-50701-2023))
- Het is **geen op zichzelf staand document**. Het **past de [IEC 62443](/nl/iec-62443)-reeks toe** op de spoorwegcontext, waarbij de beveiligingsmodellen, concepten en het risicobeoordelingsproces worden aangepast — met name steunend op **IEC 62443-3-2** en **62443-3-3**. ([ENISA / CENELEC](https://www.enisa.europa.eu/sites/default/files/all_files/05-standards-02-cenelec-christian-schlehuber.pdf))
- Het integreert met de **RAMS-levenscyclus** voor spoorwegen zoals gedefinieerd in **EN 50126-1**, zodat cybersecurity samen met betrouwbaarheid, beschikbaarheid, onderhoudbaarheid en veiligheid wordt ontworpen — en niet achteraf wordt toegevoegd.
- Het is opgesteld door **CENELEC TC 9X/WG 26**, een werkgroep van tientallen Europese spoorweg- en beveiligingsexperts, en voedt nu rechtstreeks de komende **internationale norm IEC 63452**. ([Alstom](https://www.alstom.com/press-releases-news/2024/3/towards-first-railway-cybersecurity-international-standard-why-standards-are-important-secure-railways))

> [!NOTE]
> Een opmerking over de naamgeving. U ziet dit document geschreven als **CLC/TS 50701**, **TS 50701**, of met een jaartalsuffix (**:2021**, **:2023**). "CLC" markeert het als een CENELEC-uitgave; "TS" markeert het als een Technical Specification in plaats van een volwaardige Europese Norm. De eerste editie uit 2021 en de tweede editie uit 2023 zijn hetzelfde document dat rijper wordt, niet twee concurrerende normen.

```keyfacts
Type :: CENELEC Technical Specification (CLC/TS) — geen volwaardige EN
Eerste editie :: juli 2021 — 's werelds eerste spoorspecifieke cybersecurityspec
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

De eisencatalogus die TS 50701 erft van IEC 62443-3-3 is geordend onder **zeven fundamentele eisen (FR's)**. Ze klinken abstract totdat u elke eis vertaalt naar een spoorwegasset — waarna ze een inspectiechecklist voor een seingevingsareaal worden.

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
| Specificatie van eisen | RAMS-eisen afleiden | Cybersecurity-eisen afleiden uit target SL's en het dreigingsmodel |
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
> De klassieke valkuil in het spoor is het behandelen van een beveiligingspatch als een routinematige IT-update. In een veiligheidskritisch systeem kan een wijziging die timing of gedrag verandert, de safety case ongeldig maken. TS 50701's aandringen op een beheerste veiligheid–security-interface bestaat precies om te voorkomen dat een goedbedoelde beveiligingsactie stilletjes een veiligheidsrisico wordt.

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

De aanpassing aan het spoor komt tot uiting in *welke* assets in *welke* zones vallen, en in hoe gevolgen worden gewogen naar veiligheidskritikaliteit. Een seingevingsinterlocking bevindt zich in een andere wereld dan een wifi-toegangspunt voor reizigers, en de zone-indeling van TS 50701 weerspiegelt dat. Het onderstaande illustratieve patroon is typerend voor hoe kritikaliteit de target SL's bepaalt.

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
- **Welke FR's bijten.** FR 3 (integriteit) en FR 1 (authenticatie) beschermen de authenticiteit van de rijmachtiging; FR 7 (beschikbaarheid) adresseert jamming en denial-of-service; FR 5 (beperkte gegevensstroom) waarborgt dat niets anders op de conduit kan injecteren.
- **De veiligheid–security-interface.** Een beveiligingsmaatregel die latentie toevoegt aan het machtigingsbericht kan zelf een gevaar creëren — een trein die remt omdat een geldige machtiging te laat aankwam, is een veiligheidsgebeurtenis veroorzaakt door een beveiligingsmaatregel. Dit is precies de interface die TS 50701 u dwingt gezamenlijk te beoordelen, niet na elkaar.

Eén conduit, en het zonemodel, de zeven FR's, de target-SL-logica en de veiligheid–security-interface komen allemaal tegelijk in het spel. Zo werkt de specificatie zoals bedoeld: hetzelfde asset, bekeken door de securitylens en de safetylens tegelijk.

### Bestaande installaties en compenserende maatregelen

Het spoor gebruikt assets dertig, veertig, soms vijftig jaar. Een groot deel van de geïnstalleerde basis dateert van vóór enig idee van geauthenticeerde commando's of ondertekende firmware, en kan niet simpelweg naar een SL-3-houding worden gepatcht. TS 50701 doet niet alsof dat wel kan. Omdat de risicologica kan worden toegepast op systemen die **buiten** het moderne EN 50126-1-proces zijn gebouwd, houdt het rekening met de brownfield-realiteit: waar een oude interlocking een maatregel niet rechtstreeks kan halen, grijpt de beoordeling naar **compenserende maatregelen** — strakkere zone-indeling rond het oude asset, een geharde en gemonitorde conduit, strikte toegangscontrole op het onderhoudspad, en verbeterde detectie zodat een poging op het zwakke component in elk geval wordt gezien. Het target security level benoemt nog steeds het doel; de compenserende maatregelen zijn de verdedigbare, gedocumenteerde route ernaartoe wanneer het asset zelf niet kan veranderen. Dit is dezelfde pragmatische zet die OXOT toepast op verouderende OT-arealen, en het is waarom een nauwkeurig model van *wat er werkelijk bestaat* meer telt dan een geïdealiseerd ontwerp.

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
juli 2021 :: **CLC/TS 50701 eerste editie** — 's werelds eerste cybersecurityspecificatie die specifiek voor spoorwegtoepassingen is geschreven.
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
5. **Specificeer, verifieer, documenteer.** Leid eisen af uit de target SL's, verifieer ze (inclusief controles op componentniveau tegen IEC 62443-4-2), en leg het restrisico vast tegen uw NIS2- en veiligheidsverplichtingen.

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

*Deze pagina bevat algemene educatieve informatie. Raadpleeg de officiële CENELEC CLC/TS 50701-documenten (en de aankomende EN-/IEC 63452-documenten) voor gezaghebbende eisen.*$MDBODY$, true, $MDBODY$CLC/TS 50701 Cybersecurity voor spoorwegen uitgelegd | OXOT$MDBODY$, $MDBODY$CLC/TS 50701 uitgebreid uitgelegd — de eerste cybersecurityspecificatie voor het spoor, hoe deze IEC 62443 toepast op spoorwegsystemen, de integratie met de EN 50126 RAMS-levenscyclus, de veiligheid–security-interface, zones en conduits, de relevantie van NIS2 en CRA, en de weg naar IEC 63452.$MDBODY$, $MDBODY$De cybersecurityspecificatie voor het spoor — IEC 62443 aangepast aan spoorwegtoepassingen en verankerd in de veiligheidslevenscyclus.$MDBODY$, NULL, $MDBODY$page$MDBODY$, now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET
  title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published,
  meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description,
  excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type,
  published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now()
WHERE length(pages.body) < length(EXCLUDED.body);
