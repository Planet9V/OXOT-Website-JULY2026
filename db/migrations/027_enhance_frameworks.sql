-- 027_enhance_frameworks.sql
-- Additively enrich the framework CMS pages (frameworks index, Machinery
-- Regulation, NIS2) in EN and NL by APPENDING structured reference sections to
-- the existing page body. Never erases or replaces existing content.
--
-- Idempotent: each UPDATE appends only when the body does not already contain a
-- unique marker (a distinctive heading that lives inside the appended content),
-- so re-running the migration never double-appends. All appended body text is
-- dollar-quoted ($$ ... $$). Six UPDATE statements total.

-- 1) frameworks — EN -----------------------------------------------------------
UPDATE pages
   SET body = body || $$

---
## How the EU OT frameworks fit together

Read individually, the five instruments below look like five separate compliance projects. Read together, they are one risk-based engineering problem seen from five angles — the same secure-by-design, vulnerability-management, access-control and logging controls, cited differently in each law. The table pairs each framework with the number of distinct requirements OXOT tracks for it in the conformity platform.

### The five frameworks at a glance

| Framework | Instrument | Requirements tracked | In one line |
| --- | --- | --- | --- |
| [Cyber Resilience Act](/en/cra) | Regulation (EU) 2024/2847 | 19 | Horizontal security-by-design for any product with digital elements. |
| [NIS2](/en/nis2) | Directive (EU) 2022/2555 | 12 | Risk management, governance and incident reporting for operators of essential and important services. |
| [AI Act](/en/ai-act) | Regulation (EU) 2024/1689 | 12 | Risk-based obligations for AI systems; industrial safety functions are typically high-risk. |
| [Machinery Regulation](/en/machine-act) | Regulation (EU) 2023/1230 | 8 | Cybersecurity folded into machine safety for safety-related control systems. |
| [IEC 62443](/en/iec-62443) | International standard | 27 | The engineering method the regulations lean on for technical substance. |

### Who answers to what

- **Operators** of essential and important services answer first to **[NIS2](/en/nis2)** — maintaining risk-management measures, reporting incidents, and holding their supply chain (including the OT products they buy) to an adequate standard.
- **Manufacturers and integrators** of products with digital elements answer to the **[Cyber Resilience Act](/en/cra)**, the **[Machinery Regulation](/en/machine-act)** and, where AI performs a safety function, the **[AI Act](/en/ai-act)** — CE-marking their products, maintaining a software bill of materials, handling vulnerabilities across the supported life, and producing a conformity dossier a notified body can audit.
- Most industrial organisations are **both at once**: they operate a plant and build or substantially modify the machinery inside it.

### Why treat them as one programme

Every one of these regimes was drafted by a different part of the Commission, yet they share a large common core. A single network-segmentation design, penetration test or patching process can satisfy an obligation in CRA Annex I, NIS2 Article 21, IEC 62443-3-3 and the Machinery Regulation's essential requirements at the same time. Map the shared obligations once and you write the evidence once — not four times over.

### How OXOT helps

- **Unified control library** — every obligation across the five frameworks modelled as one deduplicated requirement set, so your team works against a single list. Explore it on the [conformity platform](/en/conformity-platform).
- **Cyber Digital Twin** — a living model of your OT estate that maps assets, zones and conduits to the controls that apply to each, so the compliance picture updates as the environment changes.
- **Audit-ready evidence** — engineering artefacts linked to controls, generating the structured technical files and declarations of conformity a notified body can actually follow.

See exactly where the frameworks overlap in the [requirement matrix](/en/conformity-platform/matrix), or start from the [conformity platform](/en/conformity-platform) overview.$$,
       updated_at = now()
 WHERE slug = 'frameworks' AND locale = 'en'
   AND body NOT LIKE '%How the EU OT frameworks fit together%';

-- 2) frameworks — NL -----------------------------------------------------------
UPDATE pages
   SET body = body || $$

---
## Hoe de EU-OT-kaders op elkaar aansluiten

Afzonderlijk gelezen lijken de vijf onderstaande instrumenten vijf losse complianceprojecten. Samen gelezen vormen zij één risicogebaseerd technisch vraagstuk, bekeken vanuit vijf invalshoeken — dezelfde maatregelen voor secure-by-design, kwetsbaarheidsbeheer, toegangsbeheer en logging, die in elke wet anders worden aangehaald. De tabel koppelt elk kader aan het aantal afzonderlijke eisen dat OXOT er in het conformiteitsplatform voor bijhoudt.

### De vijf kaders in één oogopslag

| Kader | Instrument | Bijgehouden eisen | In één zin |
| --- | --- | --- | --- |
| [Cyber Resilience Act](/nl/cra) | Verordening (EU) 2024/2847 | 19 | Horizontale security-by-design voor elk product met digitale elementen. |
| [NIS2](/nl/nis2) | Richtlijn (EU) 2022/2555 | 12 | Risicobeheer, governance en incidentmelding voor operators van essentiële en belangrijke diensten. |
| [AI-verordening](/nl/ai-act) | Verordening (EU) 2024/1689 | 12 | Risicogebaseerde verplichtingen voor AI-systemen; industriële veiligheidsfuncties zijn doorgaans hoogrisico. |
| [Machineverordening](/nl/machine-act) | Verordening (EU) 2023/1230 | 8 | Cyberbeveiliging verweven met machineveiligheid voor veiligheidsgerelateerde besturingssystemen. |
| [IEC 62443](/nl/iec-62443) | Internationale norm | 27 | De technische methode waarop de regelgeving voor haar inhoudelijke invulling steunt. |

### Wie valt onder wat

- **Operators** van essentiële en belangrijke diensten vallen in de eerste plaats onder **[NIS2](/nl/nis2)** — zij onderhouden risicobeheersmaatregelen, melden incidenten, en houden hun toeleveringsketen (inclusief de OT-producten die zij inkopen) aan een passende norm.
- **Fabrikanten en integrators** van producten met digitale elementen vallen onder de **[Cyber Resilience Act](/nl/cra)**, de **[Machineverordening](/nl/machine-act)** en, waar AI een veiligheidsfunctie vervult, de **[AI-verordening](/nl/ai-act)** — zij voorzien hun producten van een CE-markering, onderhouden een software bill of materials, beheren kwetsbaarheden gedurende de ondersteunde levensduur, en stellen een conformiteitsdossier op dat een aangemelde instantie kan controleren.
- De meeste industriële organisaties zijn **beide tegelijk**: zij exploiteren een installatie én bouwen of wijzigen ingrijpend de machines daarin.

### Waarom ze als één programma behandelen

Elk van deze regimes is opgesteld door een ander onderdeel van de Commissie, en toch delen zij een grote gemeenschappelijke kern. Eén ontwerp voor netwerksegmentatie, één penetratietest of één patchproces kan tegelijkertijd voldoen aan een verplichting in bijlage I van de CRA, Artikel 21 van NIS2, IEC 62443-3-3 en de essentiële eisen van de Machineverordening. Breng de gedeelde verplichtingen één keer in kaart en u legt het bewijs één keer vast — niet vier keer.

### Hoe OXOT helpt

- **Uniforme controlebibliotheek** — elke verplichting uit de vijf kaders gemodelleerd als één ontdubbelde set eisen, zodat uw team tegen één lijst werkt. Verken deze op het [conformiteitsplatform](/nl/conformity-platform).
- **Cyber Digital Twin** — een levend model van uw OT-omgeving dat assets, zones en conduits koppelt aan de beheersmaatregelen die op elk van toepassing zijn, zodat het compliancebeeld meebeweegt met de omgeving.
- **Auditklaar bewijs** — technische artefacten gekoppeld aan beheersmaatregelen, die de gestructureerde technische dossiers en conformiteitsverklaringen genereren die een aangemelde instantie daadwerkelijk kan volgen.

Zie precies waar de kaders elkaar overlappen in de [eisenmatrix](/nl/conformity-platform/matrix), of begin bij het overzicht van het [conformiteitsplatform](/nl/conformity-platform).$$,
       updated_at = now()
 WHERE slug = 'frameworks' AND locale = 'nl'
   AND body NOT LIKE '%Hoe de EU-OT-kaders op elkaar aansluiten%';

-- 3) machine-act (Machinery Regulation) — EN -----------------------------------
UPDATE pages
   SET body = body || $$

---
## Machinery at a glance: dates, classes and conformity routes

The sections above make the case in prose. This is the structured reference companion — the same Regulation reduced to the dates, entity classes, conformity modules and requirement register OXOT tracks in the [conformity platform](/en/conformity-platform).

### Key dates

- **19 July 2023** — Regulation (EU) 2023/1230 enters into force; the transition window opens.
- **20 January 2027** — full application. The Regulation applies to machinery placed on the EU market and Directive 2006/42/EC is repealed.

### Product classes and entity types

| Class | Risk tier | How conformity is reached |
| --- | --- | --- |
| Standard machinery (not listed in Annex I) | Standard | Manufacturer's internal checks — self-assessment. |
| Annex I Part A (high-risk) | High | Third-party involvement is mandatory, even where harmonised standards are applied. |
| Annex I Part B | Elevated | Self-assessment only if harmonised standards are applied in full; otherwise third-party assessment. |

### Conformity routes (assessment modules)

| Module | Route | Notified body |
| --- | --- | --- |
| **Module A** — Internal checks | Conformity based on internal checks on the manufacture of machinery. | Not required |
| **Module B + C** — EU-type examination | EU-type examination followed by conformity to type. | Required |
| **Module H** — Full quality assurance | Conformity based on a full quality-assurance system. | Required |
| **Module G** — Unit verification | Conformity based on verification of each individual unit. | Required |

### Cybersecurity requirements at a glance

The eight machinery requirements OXOT tracks, drawn from Annexes II–IV. Open the full detail on the [requirements register](/en/conformity-platform/requirements?reg=machinery).

| Ref | Requirement | Theme | What it demands |
| --- | --- | --- | --- |
| Annex III 1.1.9 | Protection against corruption | Secure by Design & Default | Connecting another device must not create a hazard; hardware and software carrying safety signals are protected against corruption. |
| Annex III 1.2.1 | Safety and reliability of control systems | Resilience & Availability | Control systems withstand operating stresses and external influence, including malicious attempts to create a hazard. |
| Annex III 1.2.1(a) | Protection of safety-related control software | Access Control | Safety-related software and access to it are protected against unintended or intentional corruption and unauthorised modification. |
| Annex III 1.2.1(b) | Recording of intervention data | Logging & Monitoring | Evidence of intervention and of safety-affecting faults is recorded to support detection and traceability. |
| Annex III 1.2.1(c) | Software updates preserving safety | Secure Update Management | Modifications to safety-related software, including updates, must not compromise the machine's safety. |
| Annex III (general) | Risk assessment | Risk Management | The manufacturer performs a risk assessment and designs the machinery around its results. |
| Annex IV | Technical file | Technical Documentation | Compile the technical file demonstrating conformity with the applicable essential health and safety requirements. |
| Annex II | EU Declaration of Conformity | Conformity Declaration | Draw up the EU declaration of conformity and affix the CE marking before placing the machinery on the market. |

Adding connectivity or AI can move a machine up a class and pull a notified body into the loop — the same secure-development evidence also feeds the [CRA CE-marking pathways](/en/cra-ce-marking-pathways). See how the obligations overlap on the [conformity platform](/en/conformity-platform).$$,
       updated_at = now()
 WHERE slug = 'machine-act' AND locale = 'en'
   AND body NOT LIKE '%Machinery at a glance: dates, classes and conformity routes%';

-- 4) machine-act (Machinery Regulation) — NL -----------------------------------
UPDATE pages
   SET body = body || $$

---
## De Machineverordening in één oogopslag: data, klassen en conformiteitsroutes

De secties hierboven voeren het betoog in lopende tekst. Dit is de gestructureerde naslagcompanion — dezelfde Verordening teruggebracht tot de data, entiteitsklassen, conformiteitsmodules en het eisenregister die OXOT bijhoudt in het [conformiteitsplatform](/nl/conformity-platform).

### Belangrijke data

- **19 juli 2023** — Verordening (EU) 2023/1230 treedt in werking; het overgangsvenster opent.
- **20 januari 2027** — volledige toepassing. De Verordening geldt voor machines die op de EU-markt worden gebracht en Richtlijn 2006/42/EG wordt ingetrokken.

### Productklassen en entiteitstypen

| Klasse | Risiconiveau | Hoe conformiteit wordt bereikt |
| --- | --- | --- |
| Standaardmachines (niet in bijlage I) | Standaard | Interne controles door de fabrikant — zelfbeoordeling. |
| Bijlage I deel A (hoog risico) | Hoog | Betrokkenheid van een derde partij is verplicht, ook wanneer geharmoniseerde normen worden toegepast. |
| Bijlage I deel B | Verhoogd | Zelfbeoordeling alleen als geharmoniseerde normen volledig zijn toegepast; anders beoordeling door een derde partij. |

### Conformiteitsroutes (beoordelingsmodules)

| Module | Route | Aangemelde instantie |
| --- | --- | --- |
| **Module A** — Interne controles | Conformiteit op basis van interne controles op de fabricage van de machine. | Niet vereist |
| **Module B + C** — EU-typeonderzoek | EU-typeonderzoek gevolgd door conformiteit met het type. | Vereist |
| **Module H** — Volledige kwaliteitsborging | Conformiteit op basis van een volledig kwaliteitsborgingssysteem. | Vereist |
| **Module G** — Eenheidskeuring | Conformiteit op basis van keuring van elke afzonderlijke eenheid. | Vereist |

### Cyberbeveiligingseisen in één oogopslag

De acht machine-eisen die OXOT bijhoudt, ontleend aan de bijlagen II–IV. Open de volledige details in het [eisenregister](/nl/conformity-platform/requirements?reg=machinery).

| Ref | Eis | Thema | Wat het vereist |
| --- | --- | --- | --- |
| Bijlage III 1.1.9 | Bescherming tegen corruptie | Secure by Design & Default | Het aansluiten van een ander apparaat mag geen gevaar opleveren; hardware en software die veiligheidssignalen dragen, zijn beschermd tegen corruptie. |
| Bijlage III 1.2.1 | Veiligheid en betrouwbaarheid van besturingssystemen | Weerbaarheid & Beschikbaarheid | Besturingssystemen weerstaan bedrijfsbelasting en externe invloed, inclusief kwaadwillige pogingen om een gevaar te creëren. |
| Bijlage III 1.2.1(a) | Bescherming van veiligheidsgerelateerde besturingssoftware | Toegangsbeheer | Veiligheidsgerelateerde software en de toegang ertoe zijn beschermd tegen onbedoelde of opzettelijke corruptie en ongeautoriseerde wijziging. |
| Bijlage III 1.2.1(b) | Registratie van interventiegegevens | Logging & Monitoring | Bewijs van interventie en van veiligheidsbeïnvloedende storingen wordt vastgelegd ter ondersteuning van detectie en traceerbaarheid. |
| Bijlage III 1.2.1(c) | Software-updates met behoud van veiligheid | Veilig updatebeheer | Wijzigingen aan veiligheidsgerelateerde software, inclusief updates, mogen de veiligheid van de machine niet in gevaar brengen. |
| Bijlage III (algemeen) | Risicobeoordeling | Risicobeheer | De fabrikant voert een risicobeoordeling uit en ontwerpt de machine op basis van de uitkomsten daarvan. |
| Bijlage IV | Technisch dossier | Technische documentatie | Stel het technisch dossier samen dat conformiteit met de toepasselijke essentiële gezondheids- en veiligheidseisen aantoont. |
| Bijlage II | EU-conformiteitsverklaring | Conformiteitsverklaring | Stel de EU-conformiteitsverklaring op en breng de CE-markering aan voordat de machine op de markt wordt gebracht. |

Het toevoegen van connectiviteit of AI kan een machine een klasse omhoog tillen en een aangemelde instantie in beeld brengen — hetzelfde bewijs van veilige ontwikkeling voedt ook de [CRA-CE-markeringsroutes](/nl/cra-ce-marking-pathways). Zie hoe de verplichtingen elkaar overlappen op het [conformiteitsplatform](/nl/conformity-platform).$$,
       updated_at = now()
 WHERE slug = 'machine-act' AND locale = 'nl'
   AND body NOT LIKE '%De Machineverordening in één oogopslag: data, klassen en conformiteitsroutes%';

-- 5) nis2 — EN -----------------------------------------------------------------
UPDATE pages
   SET body = body || $$

---
## NIS2 requirement register: scope, measures, reporting and dates

The narrative above explains why NIS2 lands on the plant floor. This companion is the structured version OXOT tracks in the [conformity platform](/en/conformity-platform): who is covered, the twelve requirements by reference, the reporting clock and the statutory dates.

### Who NIS2 covers

- **Essential entities** — large organisations in the highest-criticality Annex I sectors: energy, transport, banking, financial-market infrastructure, health, drinking and waste water, digital infrastructure, ICT service management, public administration and space. Supervised proactively (ex ante).
- **Important entities** — organisations in the Annex II sectors: postal and courier services, waste management, chemicals, food, manufacturing (including medical devices, machinery and vehicles), digital providers and research. Supervised reactively (ex post).
- Both tiers carry the same Article 21 and Article 23 duties; the tier sets the supervision model and the penalty ceiling.

### The Article 21 measures, by reference

The twelve NIS2 requirements OXOT tracks. Open the full detail on the [requirements register](/en/conformity-platform/requirements?reg=nis2).

| Ref | Measure | Theme |
| --- | --- | --- |
| Art 20 | Governance and management accountability | Risk Management |
| Art 21(2)(a) | Risk analysis and information system security policies | Risk Management |
| Art 21(2)(b) | Incident handling | Incident Reporting |
| Art 21(2)(c) | Business continuity and crisis management | Resilience & Availability |
| Art 21(2)(d) | Supply chain security | SBOM & Supply Chain |
| Art 21(2)(e) | Security in acquisition, development and maintenance | Vulnerability Handling |
| Art 21(2)(f) | Assessing effectiveness of measures | Risk Management |
| Art 21(2)(g) | Basic cyber hygiene and training | Risk Management |
| Art 21(2)(h) | Cryptography and encryption | Data Protection & Integrity |
| Art 21(2)(i) | Access control and asset management | Access Control |
| Art 21(2)(j) | Multi-factor authentication and secured communications | Access Control |
| Art 23 | Incident reporting obligations | Incident Reporting |

### Incident reporting timeline (Article 23)

- **Early warning — within 24 hours** of becoming aware: is the incident suspected to be malicious, and could it cross borders?
- **Incident notification — within 72 hours**: an initial assessment of severity and impact, with indicators of compromise where available.
- **Final report — within one month** of the notification: a full description, root-cause analysis, mitigations applied and any cross-border impact.

### Key dates

- **16 January 2023** — the NIS2 Directive enters into force.
- **17 October 2024** — Member State transposition deadline.
- **18 October 2024** — national measures apply.
- **17 April 2025** — Member States establish their registers of entities.

See how NIS2 overlaps with the CRA, AI Act, Machinery Regulation and IEC 62443 in the [requirement matrix](/en/conformity-platform/matrix).$$,
       updated_at = now()
 WHERE slug = 'nis2' AND locale = 'en'
   AND body NOT LIKE '%NIS2 requirement register: scope, measures, reporting and dates%';

-- 6) nis2 — NL -----------------------------------------------------------------
UPDATE pages
   SET body = body || $$

---
## NIS2-eisenregister: reikwijdte, maatregelen, melding en data

Het betoog hierboven legt uit waarom NIS2 tot op de fabrieksvloer doorwerkt. Deze companion is de gestructureerde versie die OXOT bijhoudt in het [conformiteitsplatform](/nl/conformity-platform): wie eronder valt, de twaalf eisen per referentie, de meldklok en de wettelijke data.

### Wie valt onder NIS2

- **Essentiële entiteiten** — grote organisaties in de meest kritieke sectoren van bijlage I: energie, transport, bankwezen, financiëlemarktinfrastructuur, gezondheidszorg, drink- en afvalwater, digitale infrastructuur, beheer van ICT-diensten, openbaar bestuur en ruimtevaart. Proactief toezicht (ex ante).
- **Belangrijke entiteiten** — organisaties in de sectoren van bijlage II: post- en koeriersdiensten, afvalbeheer, chemie, levensmiddelen, maakindustrie (waaronder medische hulpmiddelen, machines en voertuigen), digitale aanbieders en onderzoek. Reactief toezicht (ex post).
- Beide categorieën dragen dezelfde verplichtingen uit Artikel 21 en Artikel 23; de categorie bepaalt het toezichtsmodel en de bovengrens van de boete.

### De maatregelen van Artikel 21, per referentie

De twaalf NIS2-eisen die OXOT bijhoudt. Open de volledige details in het [eisenregister](/nl/conformity-platform/requirements?reg=nis2).

| Ref | Maatregel | Thema |
| --- | --- | --- |
| Art. 20 | Governance en bestuurdersaansprakelijkheid | Risicobeheer |
| Art. 21(2)(a) | Risicoanalyse en beveiligingsbeleid voor informatiesystemen | Risicobeheer |
| Art. 21(2)(b) | Incidentbehandeling | Incidentmelding |
| Art. 21(2)(c) | Bedrijfscontinuïteit en crisisbeheer | Weerbaarheid & Beschikbaarheid |
| Art. 21(2)(d) | Beveiliging van de toeleveringsketen | SBOM & Toeleveringsketen |
| Art. 21(2)(e) | Beveiliging bij verwerving, ontwikkeling en onderhoud | Omgang met kwetsbaarheden |
| Art. 21(2)(f) | Beoordeling van de effectiviteit van maatregelen | Risicobeheer |
| Art. 21(2)(g) | Basale cyberhygiëne en training | Risicobeheer |
| Art. 21(2)(h) | Cryptografie en versleuteling | Gegevensbescherming & Integriteit |
| Art. 21(2)(i) | Toegangsbeheer en assetbeheer | Toegangsbeheer |
| Art. 21(2)(j) | Meervoudige authenticatie en beveiligde communicatie | Toegangsbeheer |
| Art. 23 | Meldplichten bij incidenten | Incidentmelding |

### Meldtermijnen bij incidenten (Artikel 23)

- **Vroegtijdige waarschuwing — binnen 24 uur** nadat u zich bewust wordt: is het incident vermoedelijk kwaadwillig, en kan het grensoverschrijdende gevolgen hebben?
- **Incidentmelding — binnen 72 uur**: een eerste beoordeling van ernst en impact, met indicatoren van compromittering voor zover beschikbaar.
- **Eindverslag — binnen één maand** na de melding: een volledige beschrijving, oorzaakanalyse, toegepaste mitigaties en eventuele grensoverschrijdende impact.

### Belangrijke data

- **16 januari 2023** — de NIS2-richtlijn treedt in werking.
- **17 oktober 2024** — omzettingstermijn voor de lidstaten.
- **18 oktober 2024** — de nationale maatregelen zijn van toepassing.
- **17 april 2025** — de lidstaten stellen hun registers van entiteiten vast.

Zie hoe NIS2 overlapt met de CRA, de AI-verordening, de Machineverordening en IEC 62443 in de [eisenmatrix](/nl/conformity-platform/matrix).$$,
       updated_at = now()
 WHERE slug = 'nis2' AND locale = 'nl'
   AND body NOT LIKE '%NIS2-eisenregister: reikwijdte, maatregelen, melding en data%';
