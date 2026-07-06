-- 003_seed_content.sql — OXOT site content (pages + main menu), nl + en.
-- Idempotent: menu items are reset each run; pages upsert on (slug, locale).

-- ── main menu ─────────────────────────────────────────────────────────────
INSERT INTO menus (key) VALUES ('main') ON CONFLICT (key) DO NOTHING;

DELETE FROM menu_items WHERE menu_id = (SELECT id FROM menus WHERE key = 'main');

INSERT INTO menu_items (menu_id, locale, label, href, position)
SELECT (SELECT id FROM menus WHERE key = 'main'), v.locale, v.label, v.href, v.position
FROM (VALUES
  ('en', 'Home',               '/en',                   0),
  ('en', 'Services',           '/en/services',          1),
  ('en', 'Cyber Digital Twin', '/en/cyber-digital-twin',2),
  ('en', 'Frameworks',         '/en/frameworks',        3),
  ('en', 'About',              '/en/about',             4),
  ('en', 'Contact',            '/en/contact',           5),
  ('nl', 'Home',               '/nl',                   0),
  ('nl', 'Diensten',           '/nl/services',          1),
  ('nl', 'Cyber Digital Twin', '/nl/cyber-digital-twin',2),
  ('nl', 'Kaders',             '/nl/frameworks',        3),
  ('nl', 'Over ons',           '/nl/about',             4),
  ('nl', 'Contact',            '/nl/contact',           5)
) AS v(locale, label, href, position);

-- ── pages ─────────────────────────────────────────────────────────────────
INSERT INTO pages (slug, locale, title, body, published) VALUES

('services', 'en', 'OXOT Services', $body$OXOT delivers OT cybersecurity services that turn technical complexity into clear, risk-based decisions. Every engagement starts by understanding your environment, your operational constraints and what matters most to safety, continuity and production.

OT Security Assessments
Understand your current OT security posture, key risks and practical next steps.

Cyber Digital Twin
Create a living model of your OT environment to support risk-based decisions at scale.

OT Security Programmes
Design and execute structured OT security improvement programmes across sites, business units or regions.

Architecture & Segmentation
Define secure OT network architectures, zones, conduits and practical segmentation patterns.

Secure Remote Access
Reduce risk from vendor access, remote maintenance and external connectivity.

OT Security Baseline
Define minimum security controls that are realistic, repeatable and aligned with operational needs.

Capability Transfer
Help internal teams build the knowledge, structure and ownership needed to maintain OT security over time.$body$, true),

('services', 'nl', 'OXOT-diensten', $body$OXOT levert OT-cybersecuritydiensten die technische complexiteit omzetten in heldere, risicogebaseerde beslissingen. Elke opdracht begint met het begrijpen van uw omgeving, uw operationele randvoorwaarden en wat het zwaarst weegt voor veiligheid, continuïteit en productie.

OT-securityassessments
Begrijp uw huidige OT-securityhouding, belangrijkste risico's en praktische vervolgstappen.

Cyber Digital Twin
Creëer een levend model van uw OT-omgeving om risicogebaseerde beslissingen op schaal te ondersteunen.

OT-securityprogramma's
Ontwerp en voer gestructureerde OT-securityverbeterprogramma's uit over locaties, bedrijfsonderdelen of regio's.

Architectuur & segmentatie
Definieer veilige OT-netwerkarchitecturen, zones, conduits en praktische segmentatiepatronen.

Veilige externe toegang
Verminder risico van leverancierstoegang, onderhoud op afstand en externe connectiviteit.

OT-securitybaseline
Definieer minimale beveiligingsmaatregelen die realistisch, herhaalbaar en afgestemd op operationele behoeften zijn.

Kennisoverdracht
Help interne teams de kennis, structuur en eigenaarschap op te bouwen om OT-security duurzaam te onderhouden.$body$, true),

('cyber-digital-twin', 'en', 'Cyber Digital Twin', $body$Cyber Digital Twin for OT environments

The OXOT Cyber Digital Twin is a living data model of your OT environment. It brings together information from documentation, network diagrams, asset inventories, configurations, security tools and operational input. Instead of looking at each source separately, the Cyber Digital Twin creates one structured view of assets, risks and controls.

This helps industrial organizations prioritize security improvements based on real operational risk, not just technical severity.

It can support:
- site risk assessments
- asset and architecture understanding
- attack path analysis
- control gap analysis
- OT security baseline development
- investment prioritization
- continuous improvement

The Cyber Digital Twin does not replace existing OT security tools. It uses their output, adds context and helps leadership make better decisions.$body$, true),

('cyber-digital-twin', 'nl', 'Cyber Digital Twin', $body$Cyber Digital Twin voor OT-omgevingen

De OXOT Cyber Digital Twin is een levend datamodel van uw OT-omgeving. Het brengt informatie samen uit documentatie, netwerkdiagrammen, asset-inventarissen, configuraties, securitytools en operationele input. In plaats van elke bron afzonderlijk te bekijken, creëert de Cyber Digital Twin één gestructureerd beeld van assets, risico's en maatregelen.

Dit helpt industriële organisaties om beveiligingsverbeteringen te prioriteren op basis van werkelijk operationeel risico, niet alleen technische ernst.

Het kan ondersteunen bij:
- risicobeoordelingen per locatie
- inzicht in assets en architectuur
- analyse van aanvalspaden
- analyse van hiaten in maatregelen
- ontwikkeling van een OT-securitybaseline
- prioritering van investeringen
- continue verbetering

De Cyber Digital Twin vervangt bestaande OT-securitytools niet. Het gebruikt hun output, voegt context toe en helpt de leiding betere beslissingen te nemen.$body$, true),

('about', 'en', 'About OXOT', $body$What we do
OT Security Programmes, Cyber Digital Twin, OT Risk Assessment, Architecture & Segmentation, Secure Remote Access, and OT Security Baseline.

Why OXOT
OXOT is a Dutch cybersecurity company specialized in securing industrial environments where Operational Technology is critical to business continuity.

Founded by former Fox-IT OT security leads, OXOT combines deep OT security expertise, hands-on experience in critical infrastructure and advanced data-driven capabilities. The team brings experience from complex environments such as energy, water, logistics and manufacturing.

We understand that OT security is not about creating more reports. It is about helping organizations make better decisions, reduce operational risk and improve resilience without disrupting production.

What makes OXOT different:
- OT-first thinking, not IT security copied into the plant
- practical experience in critical industrial environments
- clear communication for both technical and executive stakeholders
- risk-based prioritization instead of generic control checklists
- scalable approach using Cyber Digital Twin capabilities
- focus on capability transfer, so knowledge stays inside the organization
- focus on EU sovereignty$body$, true),

('about', 'nl', 'Over OXOT', $body$Wat we doen
OT-securityprogramma's, Cyber Digital Twin, OT-risicobeoordeling, Architectuur & segmentatie, Veilige externe toegang en OT-securitybaseline.

Waarom OXOT
OXOT is een Nederlands cybersecuritybedrijf gespecialiseerd in het beveiligen van industriële omgevingen waar Operational Technology cruciaal is voor de bedrijfscontinuïteit.

Opgericht door voormalige OT-securityleads van Fox-IT, combineert OXOT diepgaande OT-securityexpertise, praktijkervaring in kritieke infrastructuur en geavanceerde datagedreven capaciteiten. Het team brengt ervaring mee uit complexe omgevingen zoals energie, water, logistiek en productie.

Wij begrijpen dat OT-security niet gaat over het maken van meer rapporten. Het gaat over het helpen van organisaties om betere beslissingen te nemen, operationeel risico te verminderen en veerkracht te verbeteren zonder de productie te verstoren.

Wat OXOT anders maakt:
- OT-first denken, geen IT-security gekopieerd naar de fabriek
- praktijkervaring in kritieke industriële omgevingen
- heldere communicatie voor zowel technische als bestuurlijke stakeholders
- risicogebaseerde prioritering in plaats van generieke checklists
- schaalbare aanpak met Cyber Digital Twin-capaciteiten
- focus op kennisoverdracht, zodat kennis binnen de organisatie blijft
- focus op EU-soevereiniteit$body$, true),

('frameworks', 'en', 'Frameworks', $body$OXOT helps industrial organizations navigate the regulations and standards that shape OT cybersecurity, translating requirements into practical, risk-based action.

Frameworks we work with:
- AI Act
- CRA — Cyber Resilience Act
- NIS2
- Machinery Regulation
- IEC 62443

Detailed guidance for each framework is coming soon. Talk to us to discuss how these apply to your environment.$body$, true),

('frameworks', 'nl', 'Kaders', $body$OXOT helpt industriële organisaties hun weg te vinden in de regelgeving en normen die OT-cybersecurity bepalen, en vertaalt eisen naar praktische, risicogebaseerde actie.

Kaders waarmee we werken:
- AI Act
- CRA — Cyber Resilience Act
- NIS2
- Machineverordening
- IEC 62443

Gedetailleerde toelichting per kader volgt binnenkort. Neem contact met ons op om te bespreken hoe deze op uw omgeving van toepassing zijn.$body$, true),

('ai-act', 'en', 'AI Act', $body$The EU AI Act sets requirements for the safe and trustworthy use of AI systems, including where AI is applied in industrial and safety-related contexts.

Content coming soon. Contact OXOT to discuss how the AI Act applies to your OT environment.$body$, true),

('ai-act', 'nl', 'AI Act', $body$De EU AI Act stelt eisen aan het veilige en betrouwbare gebruik van AI-systemen, ook waar AI wordt toegepast in industriële en veiligheidsgerelateerde contexten.

Inhoud volgt binnenkort. Neem contact op met OXOT om te bespreken hoe de AI Act op uw OT-omgeving van toepassing is.$body$, true),

('cra', 'en', 'CRA — Cyber Resilience Act', $body$The Cyber Resilience Act (CRA) sets cybersecurity requirements for products with digital elements placed on the EU market, across their lifecycle.

Content coming soon. Contact OXOT to discuss how the CRA applies to your products and OT environment.$body$, true),

('cra', 'nl', 'CRA — Cyber Resilience Act', $body$De Cyber Resilience Act (CRA) stelt cybersecurity-eisen aan producten met digitale elementen die op de EU-markt worden gebracht, gedurende hun hele levenscyclus.

Inhoud volgt binnenkort. Neem contact op met OXOT om te bespreken hoe de CRA op uw producten en OT-omgeving van toepassing is.$body$, true),

('nis2', 'en', 'NIS2', $body$The NIS2 Directive raises cybersecurity and risk-management requirements for essential and important entities across the EU, including many industrial operators.

Content coming soon. Contact OXOT to discuss how NIS2 applies to your organization.$body$, true),

('nis2', 'nl', 'NIS2', $body$De NIS2-richtlijn verhoogt de eisen aan cybersecurity en risicobeheer voor essentiële en belangrijke entiteiten in de EU, waaronder veel industriële operators.

Inhoud volgt binnenkort. Neem contact op met OXOT om te bespreken hoe NIS2 op uw organisatie van toepassing is.$body$, true),

('machine-act', 'en', 'Machinery Regulation', $body$The EU Machinery Regulation introduces safety and cybersecurity-related requirements for machinery placed on the EU market.

Content coming soon. Contact OXOT to discuss how the Machinery Regulation applies to your equipment and OT environment.$body$, true),

('machine-act', 'nl', 'Machineverordening', $body$De EU-Machineverordening introduceert veiligheids- en cybersecuritygerelateerde eisen voor machines die op de EU-markt worden gebracht.

Inhoud volgt binnenkort. Neem contact op met OXOT om te bespreken hoe de Machineverordening op uw machines en OT-omgeving van toepassing is.$body$, true),

('iec-62443', 'en', 'IEC 62443', $body$IEC 62443 is the leading international standard series for the security of industrial automation and control systems (IACS), covering people, processes and technology.

Content coming soon. Contact OXOT to discuss how IEC 62443 applies to your OT environment.$body$, true),

('iec-62443', 'nl', 'IEC 62443', $body$IEC 62443 is de toonaangevende internationale normreeks voor de beveiliging van industriële automatiserings- en besturingssystemen (IACS), met aandacht voor mensen, processen en technologie.

Inhoud volgt binnenkort. Neem contact op met OXOT om te bespreken hoe IEC 62443 op uw OT-omgeving van toepassing is.$body$, true),

('contact', 'en', 'Contact', $body$Talk to an OT security expert.

Whether you are starting your OT security journey or scaling an existing programme, we are happy to help you understand your risk and the practical next steps.

A contact form and full contact details are coming soon. In the meantime, reach out to arrange a conversation.

OXOT — Dutch OT cybersecurity, focused on EU sovereignty.$body$, true),

('contact', 'nl', 'Contact', $body$Praat met een OT-securityexpert.

Of u nu begint met OT-security of een bestaand programma opschaalt, wij helpen u graag om uw risico en de praktische vervolgstappen te begrijpen.

Een contactformulier en volledige contactgegevens volgen binnenkort. Neem in de tussentijd contact met ons op om een gesprek in te plannen.

OXOT — Nederlandse OT-cybersecurity, met focus op EU-soevereiniteit.$body$, true)

-- DO NOTHING (was DO UPDATE): these are first-run PLACEHOLDER bodies. Re-running
-- migrate must never overwrite the full content that scripts/seed-pages.mjs
-- (npm run seed:pages) imports from content/pages/**. Clobbering here was the
-- cause of framework pages reverting to "Content coming soon" stubs.
ON CONFLICT (slug, locale) DO NOTHING;
