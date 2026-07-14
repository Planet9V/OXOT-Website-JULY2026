-- 024_conformity_nl.sql
-- Fill the Dutch (_nl) translation columns for the OXOT Conformity Platform data.
-- Tables are created by migration 021 (conformity_platform.sql); this migration only
-- UPDATEs the *_nl columns so the /nl pages render Dutch instead of falling back to English.
--
-- Scope: 5 regulations, 15 themes, 78 requirements, 18 timeline labels.
-- Every value uses PostgreSQL dollar-quoting ($$...$$) so Dutch apostrophes (e.g. thema's,
-- commando's) never break the statement. All UPDATEs are idempotent (plain UPDATE ... WHERE)
-- and re-runnable. The English key / ref_code / label in each WHERE clause is copied verbatim
-- from data/conformity_source.json so nothing silently fails to match.
--
-- Technical clause references, article/standard numbers and acronyms (SBOM, CVD, TLS, MFA,
-- IACS, DoS, EAL, HSM, CE, ENISA, CSIRT, GPAI) are kept intact inside the Dutch text.

BEGIN;

-- =====================================================================
-- 1. Regulations (5)
-- =====================================================================

UPDATE conformity_regulations SET
  name_nl=$$Cyberweerbaarheidsverordening$$,
  short_name_nl=$$CRA$$,
  full_title_nl=$$Verordening (EU) 2024/2847 inzake horizontale cyberbeveiligingsvereisten voor producten met digitale elementen$$,
  summary_nl=$$Stelt verplichte cyberbeveiligingsvereisten vast voor het ontwerp, de ontwikkeling, de productie en het kwetsbaarhedenbeheer van elk product met digitale elementen dat op de EU-markt wordt aangeboden. Introduceert essentiële productvereisten (bijlage I deel I), vereisten voor kwetsbaarhedenbeheer (bijlage I deel II), CE-markering en risicogebaseerde conformiteitsroutes die gekoppeld zijn aan productklassen.$$
WHERE key='cra';

UPDATE conformity_regulations SET
  name_nl=$$EU-verordening kunstmatige intelligentie$$,
  short_name_nl=$$AI Act$$,
  full_title_nl=$$Verordening (EU) 2024/1689 tot vaststelling van geharmoniseerde regels betreffende kunstmatige intelligentie$$,
  summary_nl=$$Risicogebaseerd kader voor AI-systemen. Systemen met een hoog risico moeten voldoen aan vereisten op het gebied van risicobeheer, datagovernance, technische documentatie, logging, transparantie, menselijk toezicht en nauwkeurigheid/robuustheid/cyberbeveiliging, ondersteund door een kwaliteitsbeheersysteem, conformiteitsbeoordeling, registratie en monitoring na het in de handel brengen.$$
WHERE key='ai_act';

UPDATE conformity_regulations SET
  name_nl=$$Machineverordening$$,
  short_name_nl=$$Machinery$$,
  full_title_nl=$$Verordening (EU) 2023/1230 betreffende machines, tot intrekking van Richtlijn 2006/42/EG$$,
  summary_nl=$$Essentiële gezondheids- en veiligheidseisen voor machines, nu met expliciete cyberbeveiligingsbepalingen voor veiligheidsgerelateerde besturingssystemen (bescherming tegen corruptie, betrouwbaarheid van besturingssystemen). Vereist een technisch dossier, een risicobeoordeling, een EU-conformiteitsverklaring en — voor categorieën met een hoog risico — conformiteitsbeoordeling door een derde partij.$$
WHERE key='machinery';

UPDATE conformity_regulations SET
  name_nl=$$IEC 62443-serie$$,
  short_name_nl=$$IEC 62443$$,
  full_title_nl=$$IEC 62443 — Beveiliging van industriële automatiserings- en besturingssystemen (IACS)$$,
  summary_nl=$$De referentienormenreeks voor OT/ICS-cyberbeveiliging. 62443-4-1 definieert een beveiligde levenscyclus voor productontwikkeling (acht praktijken); 62443-4-2 definieert technische componentvereisten verdeeld over zeven fundamentele vereisten. Doelbeveiligingsniveaus (SL 1-4) schalen de maatregelen af op de dreiging. Wordt breed gebruikt als bewijs voor de cyberbeveiligingsverplichtingen uit de CRA en de Machineverordening.$$
WHERE key='iec_62443';

UPDATE conformity_regulations SET
  name_nl=$$NIS2-richtlijn$$,
  short_name_nl=$$NIS2$$,
  full_title_nl=$$Richtlijn (EU) 2022/2555 betreffende maatregelen voor een hoog gezamenlijk niveau van cyberbeveiliging in de hele Unie$$,
  summary_nl=$$EU-brede cyberbeveiligingsrichtlijn die verplichtingen inzake risicobeheer, governance en incidentmelding oplegt aan essentiële en belangrijke entiteiten in kritieke sectoren (energie, vervoer, water, gezondheidszorg, digitale infrastructuur, productie en meer). In tegenstelling tot de productgerichte CRA reguleert NIS2 de exploitant: verantwoordingsplicht van het bestuur, een vastgestelde reeks technische en organisatorische maatregelen (art. 21) en strikte termijnen voor incidentmelding (art. 23).$$
WHERE key='nis2';

-- =====================================================================
-- 2. Themes (15)
-- =====================================================================

UPDATE conformity_themes SET
  name_nl=$$Veilig door ontwerp en standaard$$,
  description_nl=$$Vanaf het begin passende, risicoproportionele beveiliging in een product inbouwen, inclusief een veilige standaardconfiguratie en een geminimaliseerd aanvalsoppervlak.$$
WHERE key='secure_by_design';

UPDATE conformity_themes SET
  name_nl=$$Risicobeheer$$,
  description_nl=$$Het opzetten en onderhouden van een proces om beveiligings- en veiligheidsrisico's gedurende de gehele levenscyclus van het product te identificeren, te beoordelen en te behandelen.$$
WHERE key='risk_management';

UPDATE conformity_themes SET
  name_nl=$$Kwetsbaarhedenbeheer$$,
  description_nl=$$Het identificeren, testen op, verhelpen en openbaar maken van kwetsbaarheden, inclusief gecoördineerde openbaarmaking.$$
WHERE key='vulnerability_handling';

UPDATE conformity_themes SET
  name_nl=$$Beheer van beveiligingsupdates$$,
  description_nl=$$Het leveren en veilig distribueren van beveiligingsupdates en patches gedurende de ondersteunde levensduur van het product.$$
WHERE key='secure_update';

UPDATE conformity_themes SET
  name_nl=$$SBOM en toeleveringsketen$$,
  description_nl=$$Het identificeren en beheren van componenten en afhankelijkheden van derden, inclusief een softwarestuklijst (SBOM).$$
WHERE key='sbom_supply_chain';

UPDATE conformity_themes SET
  name_nl=$$Toegangscontrole$$,
  description_nl=$$Identificatie-, authenticatie- en autorisatiemaatregelen die ongeoorloofde toegang tot het product en zijn functies voorkomen.$$
WHERE key='access_control';

UPDATE conformity_themes SET
  name_nl=$$Gegevensbescherming en -integriteit$$,
  description_nl=$$Het beschermen van de vertrouwelijkheid en integriteit van opgeslagen, verzonden en verwerkte gegevens, commando's en configuratie.$$
WHERE key='data_protection';

UPDATE conformity_themes SET
  name_nl=$$Logging en monitoring$$,
  description_nl=$$Het vastleggen van beveiligingsrelevante activiteit en het mogelijk maken van detectie van en reactie op beveiligingsgebeurtenissen.$$
WHERE key='logging_monitoring';

UPDATE conformity_themes SET
  name_nl=$$Incidentmelding$$,
  description_nl=$$Het binnen de voorgeschreven termijnen melden van actief misbruikte kwetsbaarheden en ernstige incidenten aan autoriteiten en gebruikers.$$
WHERE key='incident_reporting';

UPDATE conformity_themes SET
  name_nl=$$Technische documentatie$$,
  description_nl=$$Het samenstellen en bijhouden van de technische documentatie / het technisch dossier waarmee conformiteit wordt aangetoond.$$
WHERE key='technical_documentation';

UPDATE conformity_themes SET
  name_nl=$$Conformiteitsverklaring$$,
  description_nl=$$Het opstellen van de EU-conformiteitsverklaring en het aanbrengen van de passende markering.$$
WHERE key='conformity_declaration';

UPDATE conformity_themes SET
  name_nl=$$Menselijk toezicht en transparantie$$,
  description_nl=$$Ervoor zorgen dat systemen transparant zijn voor mensen en effectief door hen kunnen worden overzien en beheerst.$$
WHERE key='human_oversight';

UPDATE conformity_themes SET
  name_nl=$$Datagovernance$$,
  description_nl=$$Het beheersen van de kwaliteit, relevantie en representativiteit van gegevens die worden gebruikt om systemen te trainen, te valideren en te laten werken.$$
WHERE key='data_governance';

UPDATE conformity_themes SET
  name_nl=$$Veerkracht en beschikbaarheid$$,
  description_nl=$$Het handhaven van de beschikbaarheid van essentiële functies en het weerstaan van denial-of-service-aanvallen, manipulatie en andere verstoringen.$$
WHERE key='resilience';

UPDATE conformity_themes SET
  name_nl=$$Monitoring na het in de handel brengen$$,
  description_nl=$$Het actief monitoren van producten in het veld en het gedurende de ondersteuningsperiode terugkoppelen van bevindingen naar het risicobeheer.$$
WHERE key='post_market';

-- =====================================================================
-- 3. Requirements (78)  — match on regulation_key + ref_code
-- =====================================================================

-- --- IEC 62443 (27) ---
UPDATE conformity_requirements SET
  title_nl=$$Beveiligingsbeheer$$,
  description_nl=$$Zet een beveiligingsbeheerproces op dat de ontwikkellevenscyclus stuurt, inclusief rollen, verantwoordelijkheden en een vastgestelde reikwijdte van het proces.$$
WHERE regulation_key='iec_62443' AND ref_code='4-1 SM';

UPDATE conformity_requirements SET
  title_nl=$$Beheer van componenten van derden$$,
  description_nl=$$Identificeer, beoordeel en beheer de beveiligingsrisico's van componenten van derden en opensourcecomponenten die in het product worden gebruikt, en houd een register van componenten bij.$$
WHERE regulation_key='iec_62443' AND ref_code='4-1 SM-9';

UPDATE conformity_requirements SET
  title_nl=$$Specificatie van beveiligingsvereisten$$,
  description_nl=$$Documenteer en onderhoud de beveiligingsvereisten voor het product, afgeleid van de beoogde omgeving en het dreigingsmodel.$$
WHERE regulation_key='iec_62443' AND ref_code='4-1 SR';

UPDATE conformity_requirements SET
  title_nl=$$Veilig door ontwerp$$,
  description_nl=$$Pas gedurende het gehele productontwerp principes van veilig ontwerp toe, waaronder defence in depth en threat modelling.$$
WHERE regulation_key='iec_62443' AND ref_code='4-1 SD';

UPDATE conformity_requirements SET
  title_nl=$$Beveiligingsverificatie en -validatie$$,
  description_nl=$$Voer vóór de release beveiligingsverificatie- en validatietests uit, waaronder tests op dreigingsmitigatie, kwetsbaarheden en penetratietests.$$
WHERE regulation_key='iec_62443' AND ref_code='4-1 SVV';

UPDATE conformity_requirements SET
  title_nl=$$Beheer van beveiligingsgerelateerde problemen$$,
  description_nl=$$Zet een proces op om beveiligingsgerelateerde problemen (defecten en kwetsbaarheden) in het product te ontvangen, te volgen, te beoordelen en te verhelpen.$$
WHERE regulation_key='iec_62443' AND ref_code='4-1 DM';

UPDATE conformity_requirements SET
  title_nl=$$Beheer van beveiligingsupdates$$,
  description_nl=$$Zet een proces op om beveiligingsupdates te ontwikkelen, te testen, te kwalificeren en tijdig en veilig aan productgebruikers te leveren.$$
WHERE regulation_key='iec_62443' AND ref_code='4-1 SUM';

UPDATE conformity_requirements SET
  title_nl=$$Beveiligingsrichtlijnen$$,
  description_nl=$$Verstrek documentatie (beveiligingsrichtlijnen) die de veilige integratie, configuratie, bediening, het onderhoud en de buitengebruikstelling van het product mogelijk maakt.$$
WHERE regulation_key='iec_62443' AND ref_code='4-1 SG';

UPDATE conformity_requirements SET
  title_nl=$$Identificatie- en authenticatiecontrole$$,
  description_nl=$$Identificeer en authenticeer alle gebruikers (mensen, softwareprocessen en apparaten) voordat toegang tot de component wordt verleend.$$
WHERE regulation_key='iec_62443' AND ref_code='4-2 FR1';

UPDATE conformity_requirements SET
  title_nl=$$Gebruikscontrole$$,
  description_nl=$$Handhaaf toegewezen rechten om het gebruik van de component te beperken tot geautoriseerde handelingen (autorisatie).$$
WHERE regulation_key='iec_62443' AND ref_code='4-2 FR2';

UPDATE conformity_requirements SET
  title_nl=$$Systeemintegriteit$$,
  description_nl=$$Bescherm de integriteit van de component tegen ongeoorloofde manipulatie, waaronder van firmware, software en informatie.$$
WHERE regulation_key='iec_62443' AND ref_code='4-2 FR3';

UPDATE conformity_requirements SET
  title_nl=$$Vertrouwelijkheid van gegevens$$,
  description_nl=$$Bescherm de vertrouwelijkheid van informatie in rust en tijdens verzending, onder meer door cryptografische bescherming.$$
WHERE regulation_key='iec_62443' AND ref_code='4-2 FR4';

UPDATE conformity_requirements SET
  title_nl=$$Tijdige respons op gebeurtenissen$$,
  description_nl=$$Voorzie in auditlogging en de mogelijkheid om te reageren op beveiligingsinbreuken door de bevoegde autoriteit te informeren en bewijs te rapporteren.$$
WHERE regulation_key='iec_62443' AND ref_code='4-2 FR6';

UPDATE conformity_requirements SET
  title_nl=$$Beschikbaarheid van middelen$$,
  description_nl=$$Waarborg de beschikbaarheid van de component tegen de degradatie of het uitvallen van essentiële diensten, ook onder denial-of-service-omstandigheden (DoS).$$
WHERE regulation_key='iec_62443' AND ref_code='4-2 FR7';

UPDATE conformity_requirements SET
  title_nl=$$Identificatie en authenticatie van menselijke gebruikers$$,
  description_nl=$$Het besturingssysteem moet alle menselijke gebruikers identificeren en authenticeren en authenticatie op alle interfaces afdwingen voordat toegang tot het systeem wordt verleend.$$
WHERE regulation_key='iec_62443' AND ref_code='3-3 SR 1.1';

UPDATE conformity_requirements SET
  title_nl=$$Identificatie van softwareprocessen en apparaten$$,
  description_nl=$$Het besturingssysteem moet alle softwareprocessen en apparaten identificeren en authenticeren voordat zij toegang tot het systeem krijgen.$$
WHERE regulation_key='iec_62443' AND ref_code='3-3 SR 1.2';

UPDATE conformity_requirements SET
  title_nl=$$Handhaving van autorisatie$$,
  description_nl=$$Het besturingssysteem moet de aan alle gebruikers en processen toegewezen autorisaties handhaven en de toegang beperken tot het minimum dat voor de toegewezen rol noodzakelijk is (least privilege).$$
WHERE regulation_key='iec_62443' AND ref_code='3-3 SR 2.1';

UPDATE conformity_requirements SET
  title_nl=$$Sessievergrendeling en -beëindiging$$,
  description_nl=$$Het besturingssysteem moet een sessie vergrendelen of beëindigen na een configureerbare periode van inactiviteit of op verzoek, waardoor verdere toegang wordt voorkomen totdat opnieuw wordt geauthenticeerd.$$
WHERE regulation_key='iec_62443' AND ref_code='3-3 SR 2.5';

UPDATE conformity_requirements SET
  title_nl=$$Communicatie-integriteit$$,
  description_nl=$$Het besturingssysteem moet de integriteit van verzonden informatie beschermen en ongeoorloofde wijzigingen in de communicatie tijdens de verzending detecteren.$$
WHERE regulation_key='iec_62443' AND ref_code='3-3 SR 3.1';

UPDATE conformity_requirements SET
  title_nl=$$Bescherming tegen kwaadaardige code$$,
  description_nl=$$Het besturingssysteem moet bescherming tegen en detectie van kwaadaardige code bieden op toegangs- en uitgangspunten en op de betrokken apparaten.$$
WHERE regulation_key='iec_62443' AND ref_code='3-3 SR 3.2';

UPDATE conformity_requirements SET
  title_nl=$$Vertrouwelijkheid van informatie$$,
  description_nl=$$Het besturingssysteem moet de vertrouwelijkheid beschermen van informatie in rust en tijdens verzending waarvoor expliciete leesautorisatie vereist is, waar passend met behulp van cryptografische mechanismen.$$
WHERE regulation_key='iec_62443' AND ref_code='3-3 SR 4.1';

UPDATE conformity_requirements SET
  title_nl=$$Netwerksegmentatie$$,
  description_nl=$$Het besturingssysteem moet besturingsnetwerken logisch scheiden van niet-besturingsnetwerken en het systeem opdelen in zones en conduits overeenkomstig de risicobeoordeling.$$
WHERE regulation_key='iec_62443' AND ref_code='3-3 SR 5.1';

UPDATE conformity_requirements SET
  title_nl=$$Bescherming van zonegrenzen$$,
  description_nl=$$Het besturingssysteem moet de communicatie op de zonegrenzen monitoren en beheersen om de gedefinieerde conduits af te dwingen, waarbij netwerkverkeer standaard wordt geweigerd en slechts bij uitzondering wordt toegestaan.$$
WHERE regulation_key='iec_62443' AND ref_code='3-3 SR 5.2';

UPDATE conformity_requirements SET
  title_nl=$$Toegankelijkheid van auditlogs$$,
  description_nl=$$Het besturingssysteem moet de mogelijkheid bieden om auditlogs alleen-lezen toegankelijk te maken voor geautoriseerd personeel en geautoriseerde tools.$$
WHERE regulation_key='iec_62443' AND ref_code='3-3 SR 6.1';

UPDATE conformity_requirements SET
  title_nl=$$Continue monitoring$$,
  description_nl=$$Het besturingssysteem moet de mogelijkheid bieden om beveiligingsrelevante gebeurtenissen continu te monitoren met behulp van algemeen aanvaarde tools en mechanismen.$$
WHERE regulation_key='iec_62443' AND ref_code='3-3 SR 6.2';

UPDATE conformity_requirements SET
  title_nl=$$Bescherming tegen denial-of-service$$,
  description_nl=$$Het besturingssysteem moet essentiële functies handhaven wanneer het in een gedegradeerde modus werkt als gevolg van een denial-of-service-gebeurtenis (DoS).$$
WHERE regulation_key='iec_62443' AND ref_code='3-3 SR 7.1';

UPDATE conformity_requirements SET
  title_nl=$$Beheer en herstel van middelen$$,
  description_nl=$$Het besturingssysteem moet het gebruik van middelen door beveiligingsfuncties beperken om uitputting van middelen te voorkomen, en back-up en herstel naar een bekende veilige staat na een verstoring ondersteunen.$$
WHERE regulation_key='iec_62443' AND ref_code='3-3 SR 7.2';

-- --- CRA (19) ---
UPDATE conformity_requirements SET
  title_nl=$$Passend niveau van cyberbeveiliging op basis van risico$$,
  description_nl=$$Producten met digitale elementen moeten zo worden ontworpen, ontwikkeld en geproduceerd dat een passend niveau van cyberbeveiliging op basis van de risico's wordt gewaarborgd.$$
WHERE regulation_key='cra' AND ref_code='Annex I(1)';

UPDATE conformity_requirements SET
  title_nl=$$Geen bekende misbruikbare kwetsbaarheden bij release$$,
  description_nl=$$Producten moeten op de markt worden aangeboden zonder bekende misbruikbare kwetsbaarheden.$$
WHERE regulation_key='cra' AND ref_code='Annex I(2)(a)';

UPDATE conformity_requirements SET
  title_nl=$$Standaard veilige configuratie$$,
  description_nl=$$Producten moeten worden aangeboden met een standaard veilige configuratie, met inbegrip van de mogelijkheid om het product terug te zetten naar de oorspronkelijke staat.$$
WHERE regulation_key='cra' AND ref_code='Annex I(2)(b)';

UPDATE conformity_requirements SET
  title_nl=$$Beveiligingsupdates$$,
  description_nl=$$Zorg ervoor dat kwetsbaarheden kunnen worden verholpen via beveiligingsupdates, met inbegrip van, waar van toepassing, automatische updates en kennisgeving aan de gebruiker.$$
WHERE regulation_key='cra' AND ref_code='Annex I(2)(c)';

UPDATE conformity_requirements SET
  title_nl=$$Bescherming tegen ongeoorloofde toegang$$,
  description_nl=$$Bescherm tegen ongeoorloofde toegang met passende controlemechanismen, waaronder authenticatie- en identiteits- en toegangsbeheersystemen.$$
WHERE regulation_key='cra' AND ref_code='Annex I(2)(d)';

UPDATE conformity_requirements SET
  title_nl=$$Vertrouwelijkheid van gegevens$$,
  description_nl=$$Bescherm de vertrouwelijkheid van opgeslagen, verzonden of verwerkte gegevens door relevante gegevens in rust of tijdens verzending te versleutelen met state-of-the-art mechanismen.$$
WHERE regulation_key='cra' AND ref_code='Annex I(2)(e)';

UPDATE conformity_requirements SET
  title_nl=$$Integriteit van gegevens en configuratie$$,
  description_nl=$$Bescherm de integriteit van opgeslagen, verzonden of verwerkte gegevens, commando's, programma's en configuratie tegen ongeoorloofde manipulatie.$$
WHERE regulation_key='cra' AND ref_code='Annex I(2)(f)';

UPDATE conformity_requirements SET
  title_nl=$$Beschikbaarheid van essentiële functies$$,
  description_nl=$$Bescherm de beschikbaarheid van essentiële en basisfuncties, met inbegrip van veerkracht tegen en beperking van denial-of-service-aanvallen.$$
WHERE regulation_key='cra' AND ref_code='Annex I(2)(h)';

UPDATE conformity_requirements SET
  title_nl=$$Beveiligingsrelevante logging$$,
  description_nl=$$Verstrek beveiligingsgerelateerde informatie door relevante interne activiteit vast te leggen en te monitoren, waaronder toegang tot of wijziging van gegevens, diensten of functies.$$
WHERE regulation_key='cra' AND ref_code='Annex I(2)(l)';

UPDATE conformity_requirements SET
  title_nl=$$Componenten identificeren en documenteren (SBOM)$$,
  description_nl=$$Identificeer en documenteer kwetsbaarheden en componenten, onder meer door een softwarestuklijst (SBOM) op te stellen in een gangbaar machineleesbaar formaat.$$
WHERE regulation_key='cra' AND ref_code='Annex I Part II(1)';

UPDATE conformity_requirements SET
  title_nl=$$Kwetsbaarheden onverwijld verhelpen$$,
  description_nl=$$Verhelp kwetsbaarheden in verhouding tot de risico's onverwijld, onder meer door het verstrekken van beveiligingsupdates.$$
WHERE regulation_key='cra' AND ref_code='Annex I Part II(2)';

UPDATE conformity_requirements SET
  title_nl=$$Regelmatige beveiligingstests$$,
  description_nl=$$Voer doeltreffende en regelmatige tests en beoordelingen uit van de beveiliging van het product met digitale elementen.$$
WHERE regulation_key='cra' AND ref_code='Annex I Part II(3)';

UPDATE conformity_requirements SET
  title_nl=$$Gecoördineerde openbaarmaking van kwetsbaarheden$$,
  description_nl=$$Stel een beleid voor gecoördineerde openbaarmaking van kwetsbaarheden (CVD) op en handhaaf dit.$$
WHERE regulation_key='cra' AND ref_code='Annex I Part II(5)';

UPDATE conformity_requirements SET
  title_nl=$$Veilige distributie van updates$$,
  description_nl=$$Zorg ervoor dat er mechanismen zijn om updates veilig te distribueren, zodat patches of updates tijdig kunnen worden verspreid.$$
WHERE regulation_key='cra' AND ref_code='Annex I Part II(7)';

UPDATE conformity_requirements SET
  title_nl=$$Cyberbeveiligingsrisicobeoordeling$$,
  description_nl=$$Voer een beoordeling uit van de cyberbeveiligingsrisico's die aan het product verbonden zijn en houd rekening met de uitkomst tijdens de planning, het ontwerp, de ontwikkeling, de productie, de levering en het onderhoud.$$
WHERE regulation_key='cra' AND ref_code='Art 13';

UPDATE conformity_requirements SET
  title_nl=$$Ondersteuningsperiode en updates gedurende de levensduur$$,
  description_nl=$$Zorg ervoor dat kwetsbaarheden doeltreffend worden afgehandeld gedurende een vastgestelde ondersteuningsperiode die de verwachte levensduur van het product weerspiegelt.$$
WHERE regulation_key='cra' AND ref_code='Art 13(8)';

UPDATE conformity_requirements SET
  title_nl=$$Misbruikte kwetsbaarheden en ernstige incidenten melden$$,
  description_nl=$$Meld een actief misbruikte kwetsbaarheid of een ernstig incident: een vroegtijdige waarschuwing binnen 24 uur en een melding binnen 72 uur aan het CSIRT en ENISA.$$
WHERE regulation_key='cra' AND ref_code='Art 14';

UPDATE conformity_requirements SET
  title_nl=$$Technische documentatie$$,
  description_nl=$$Stel technische documentatie op met alle relevante gegevens en details van de middelen die zijn gebruikt om de conformiteit te waarborgen, en bewaar deze ten minste tien jaar.$$
WHERE regulation_key='cra' AND ref_code='Annex VII';

UPDATE conformity_requirements SET
  title_nl=$$EU-conformiteitsverklaring$$,
  description_nl=$$Stel een EU-conformiteitsverklaring op waarin wordt verklaard dat aan de essentiële eisen is voldaan, en breng de CE-markering aan.$$
WHERE regulation_key='cra' AND ref_code='Annex V';

-- --- AI Act (12) ---
UPDATE conformity_requirements SET
  title_nl=$$Risicobeheersysteem$$,
  description_nl=$$Zet een risicobeheersysteem op, implementeer, documenteer en onderhoud het gedurende de gehele levenscyclus van het AI-systeem met een hoog risico.$$
WHERE regulation_key='ai_act' AND ref_code='Art 9';

UPDATE conformity_requirements SET
  title_nl=$$Data en datagovernance$$,
  description_nl=$$Trainings-, validatie- en testdatasets moeten onderworpen zijn aan datagovernance- en beheerpraktijken die passen bij het beoogde doel.$$
WHERE regulation_key='ai_act' AND ref_code='Art 10';

UPDATE conformity_requirements SET
  title_nl=$$Technische documentatie (bijlage IV)$$,
  description_nl=$$Stel technische documentatie op voordat het systeem in de handel wordt gebracht en houd deze actueel, waarmee de conformiteit wordt aangetoond zoals bepaald in bijlage IV.$$
WHERE regulation_key='ai_act' AND ref_code='Art 11';

UPDATE conformity_requirements SET
  title_nl=$$Registratie en logging$$,
  description_nl=$$AI-systemen met een hoog risico moeten technisch de automatische registratie van gebeurtenissen (logs) gedurende de levensduur van het systeem mogelijk maken.$$
WHERE regulation_key='ai_act' AND ref_code='Art 12';

UPDATE conformity_requirements SET
  title_nl=$$Transparantie en informatie voor gebruiksverantwoordelijken$$,
  description_nl=$$Ontwerp en ontwikkel systemen zodanig dat de werking voldoende transparant is om gebruiksverantwoordelijken in staat te stellen de output te interpreteren en op passende wijze te gebruiken; verstrek een gebruiksaanwijzing.$$
WHERE regulation_key='ai_act' AND ref_code='Art 13';

UPDATE conformity_requirements SET
  title_nl=$$Menselijk toezicht$$,
  description_nl=$$Ontwerp en ontwikkel AI-systemen met een hoog risico zodanig dat er tijdens de periode van gebruik effectief menselijk toezicht door natuurlijke personen op kan worden uitgeoefend.$$
WHERE regulation_key='ai_act' AND ref_code='Art 14';

UPDATE conformity_requirements SET
  title_nl=$$Nauwkeurigheid, robuustheid en cyberbeveiliging$$,
  description_nl=$$Ontwerp en ontwikkel systemen zodanig dat passende niveaus van nauwkeurigheid, robuustheid en cyberbeveiliging worden bereikt en dat zij gedurende hun gehele levenscyclus consistent presteren.$$
WHERE regulation_key='ai_act' AND ref_code='Art 15';

UPDATE conformity_requirements SET
  title_nl=$$Veerkracht tegen manipulatie$$,
  description_nl=$$AI-systemen met een hoog risico moeten bestand zijn tegen pogingen om hun gebruik, outputs of prestaties te wijzigen door misbruik te maken van kwetsbaarheden, waaronder datavergiftiging (data poisoning) en vijandige voorbeelden (adversarial examples).$$
WHERE regulation_key='ai_act' AND ref_code='Art 15(5)';

UPDATE conformity_requirements SET
  title_nl=$$Kwaliteitsbeheersysteem$$,
  description_nl=$$Aanbieders moeten een kwaliteitsbeheersysteem opzetten dat de naleving van de verordening waarborgt en dat op systematische en ordelijke wijze is gedocumenteerd.$$
WHERE regulation_key='ai_act' AND ref_code='Art 17';

UPDATE conformity_requirements SET
  title_nl=$$EU-conformiteitsverklaring$$,
  description_nl=$$Stel voor elk AI-systeem met een hoog risico een schriftelijke EU-conformiteitsverklaring op en bewaar deze gedurende tien jaar na het in de handel brengen.$$
WHERE regulation_key='ai_act' AND ref_code='Art 47';

UPDATE conformity_requirements SET
  title_nl=$$Monitoring na het in de handel brengen$$,
  description_nl=$$Zet een systeem voor monitoring na het in de handel brengen op en documenteer dit; het verzamelt en beoordeelt actief de ervaring die is opgedaan met het gebruik van AI-systemen met een hoog risico.$$
WHERE regulation_key='ai_act' AND ref_code='Art 72';

UPDATE conformity_requirements SET
  title_nl=$$Melding van ernstige incidenten$$,
  description_nl=$$Meld elk ernstig incident aan de markttoezichtautoriteiten van de betrokken lidstaten, binnen de in de verordening vastgestelde termijnen.$$
WHERE regulation_key='ai_act' AND ref_code='Art 73';

-- --- Machinery (8) ---
UPDATE conformity_requirements SET
  title_nl=$$Bescherming tegen corruptie$$,
  description_nl=$$Machines moeten zo worden ontworpen en gebouwd dat de aansluiting van een ander apparaat niet tot een gevaarlijke situatie leidt en dat hardware/software die veiligheidssignalen doorgeeft, tegen corruptie is beschermd.$$
WHERE regulation_key='machinery' AND ref_code='Annex III 1.1.9';

UPDATE conformity_requirements SET
  title_nl=$$Veiligheid en betrouwbaarheid van besturingssystemen$$,
  description_nl=$$Besturingssystemen moeten zo worden ontworpen en gebouwd dat gevaarlijke situaties worden voorkomen en dat zij bestand zijn tegen de beoogde bedrijfsbelasting en externe invloeden, waaronder kwaadwillige pogingen van derden om een gevaarlijke situatie te creëren.$$
WHERE regulation_key='machinery' AND ref_code='Annex III 1.2.1';

UPDATE conformity_requirements SET
  title_nl=$$Bescherming van veiligheidsgerelateerde besturingssoftware$$,
  description_nl=$$Veiligheidsgerelateerde besturingssoftware en de toegang daartoe moeten worden beschermd tegen onbedoelde of opzettelijke corruptie en ongeoorloofde wijziging.$$
WHERE regulation_key='machinery' AND ref_code='Annex III 1.2.1(a)';

UPDATE conformity_requirements SET
  title_nl=$$Registratie van interventiegegevens$$,
  description_nl=$$Bewijs van interventie en van een fout die de veiligheidsfuncties beïnvloedt, moet worden geregistreerd ter ondersteuning van foutdetectie en traceerbaarheid.$$
WHERE regulation_key='machinery' AND ref_code='Annex III 1.2.1(b)';

UPDATE conformity_requirements SET
  title_nl=$$Software-updates met behoud van veiligheid$$,
  description_nl=$$Wijzigingen aan veiligheidsgerelateerde software, met inbegrip van updates, mogen de veiligheid van de machine niet in gevaar brengen.$$
WHERE regulation_key='machinery' AND ref_code='Annex III 1.2.1(c)';

UPDATE conformity_requirements SET
  title_nl=$$Risicobeoordeling$$,
  description_nl=$$De fabrikant voert een risicobeoordeling uit om te bepalen welke gezondheids- en veiligheidseisen van toepassing zijn, en ontwerpt en bouwt de machine met inachtneming van de resultaten daarvan.$$
WHERE regulation_key='machinery' AND ref_code='Annex III (general)';

UPDATE conformity_requirements SET
  title_nl=$$Technisch dossier$$,
  description_nl=$$Stel een technisch dossier samen waaruit blijkt dat de machine voldoet aan de toepasselijke essentiële gezondheids- en veiligheidseisen.$$
WHERE regulation_key='machinery' AND ref_code='Annex IV';

UPDATE conformity_requirements SET
  title_nl=$$EU-conformiteitsverklaring$$,
  description_nl=$$Stel de EU-conformiteitsverklaring op en breng de CE-markering aan voordat de machine in de handel wordt gebracht.$$
WHERE regulation_key='machinery' AND ref_code='Annex II';

-- --- NIS2 (12) ---
UPDATE conformity_requirements SET
  title_nl=$$Governance en verantwoordingsplicht van het bestuur$$,
  description_nl=$$De bestuursorganen van essentiële en belangrijke entiteiten keuren de maatregelen voor cyberbeveiligingsrisicobeheer goed, houden toezicht op de uitvoering ervan en volgen opleidingen; zij kunnen aansprakelijk worden gesteld voor inbreuken.$$
WHERE regulation_key='nis2' AND ref_code='Art 20';

UPDATE conformity_requirements SET
  title_nl=$$Risicoanalyse en beleid voor de beveiliging van informatiesystemen$$,
  description_nl=$$Entiteiten moeten beleid inzake risicoanalyse en de beveiliging van informatiesystemen vaststellen als basis voor een allesomvattende, risicogebaseerde benadering van de bescherming van netwerk- en informatiesystemen.$$
WHERE regulation_key='nis2' AND ref_code='Art 21(2)(a)';

UPDATE conformity_requirements SET
  title_nl=$$Incidentafhandeling$$,
  description_nl=$$Entiteiten moeten maatregelen voor incidentafhandeling implementeren die preventie, detectie, analyse, indamming, respons en herstel omvatten.$$
WHERE regulation_key='nis2' AND ref_code='Art 21(2)(b)';

UPDATE conformity_requirements SET
  title_nl=$$Bedrijfscontinuïteit en crisisbeheer$$,
  description_nl=$$Entiteiten moeten de bedrijfscontinuïteit waarborgen door middel van back-upbeheer, noodherstel en crisisbeheerregelingen.$$
WHERE regulation_key='nis2' AND ref_code='Art 21(2)(c)';

UPDATE conformity_requirements SET
  title_nl=$$Beveiliging van de toeleveringsketen$$,
  description_nl=$$Entiteiten moeten de beveiliging in hun toeleveringsketen aanpakken, met inbegrip van de beveiligingsgerelateerde aspecten van de relaties tussen elke entiteit en haar directe leveranciers of dienstverleners.$$
WHERE regulation_key='nis2' AND ref_code='Art 21(2)(d)';

UPDATE conformity_requirements SET
  title_nl=$$Beveiliging bij aanschaf, ontwikkeling en onderhoud$$,
  description_nl=$$Entiteiten moeten de beveiliging waarborgen bij de aanschaf, ontwikkeling en het onderhoud van netwerk- en informatiesystemen, met inbegrip van kwetsbaarhedenbeheer en openbaarmaking.$$
WHERE regulation_key='nis2' AND ref_code='Art 21(2)(e)';

UPDATE conformity_requirements SET
  title_nl=$$Beoordeling van de doeltreffendheid van maatregelen$$,
  description_nl=$$Entiteiten moeten beleid en procedures vaststellen om de doeltreffendheid van de door hen getroffen maatregelen voor cyberbeveiligingsrisicobeheer te beoordelen.$$
WHERE regulation_key='nis2' AND ref_code='Art 21(2)(f)';

UPDATE conformity_requirements SET
  title_nl=$$Basiscyberhygiëne en opleiding$$,
  description_nl=$$Entiteiten moeten basispraktijken voor cyberhygiëne toepassen en cyberbeveiligingstraining aan het personeel bieden.$$
WHERE regulation_key='nis2' AND ref_code='Art 21(2)(g)';

UPDATE conformity_requirements SET
  title_nl=$$Cryptografie en versleuteling$$,
  description_nl=$$Entiteiten moeten beleid en procedures vaststellen voor het gebruik van cryptografie en, waar passend, versleuteling.$$
WHERE regulation_key='nis2' AND ref_code='Art 21(2)(h)';

UPDATE conformity_requirements SET
  title_nl=$$Toegangscontrole en assetbeheer$$,
  description_nl=$$Entiteiten moeten personeelsbeveiliging, toegangscontrolebeleid en assetbeheer implementeren die passen bij het risico.$$
WHERE regulation_key='nis2' AND ref_code='Art 21(2)(i)';

UPDATE conformity_requirements SET
  title_nl=$$Multifactorauthenticatie en beveiligde communicatie$$,
  description_nl=$$Entiteiten moeten waar passend gebruikmaken van multifactorauthenticatie (MFA) of continue authenticatie, beveiligde spraak-, video- en tekstcommunicatie en beveiligde noodcommunicatiesystemen.$$
WHERE regulation_key='nis2' AND ref_code='Art 21(2)(j)';

UPDATE conformity_requirements SET
  title_nl=$$Verplichtingen tot incidentmelding$$,
  description_nl=$$Entiteiten moeten significante incidenten melden bij het CSIRT of de bevoegde autoriteit: een vroegtijdige waarschuwing binnen 24 uur, een incidentmelding binnen 72 uur en een eindverslag binnen één maand.$$
WHERE regulation_key='nis2' AND ref_code='Art 23';

-- =====================================================================
-- 4. Timeline (18)  — match on regulation_key + event_date + label
-- =====================================================================

UPDATE conformity_timeline SET label_nl=$$IEC 62443-3-3 gepubliceerd (systeembeveiligingsvereisten)$$
WHERE regulation_key='iec_62443' AND event_date='2013-08-01' AND label=$$IEC 62443-3-3 published (system security requirements)$$;

UPDATE conformity_timeline SET label_nl=$$IEC 62443-4-1 gepubliceerd (beveiligde ontwikkellevenscyclus)$$
WHERE regulation_key='iec_62443' AND event_date='2018-01-01' AND label=$$IEC 62443-4-1 published (secure development lifecycle)$$;

UPDATE conformity_timeline SET label_nl=$$IEC 62443-4-2 gepubliceerd (componentvereisten)$$
WHERE regulation_key='iec_62443' AND event_date='2019-02-01' AND label=$$IEC 62443-4-2 published (component requirements)$$;

UPDATE conformity_timeline SET label_nl=$$NIS2-richtlijn treedt in werking$$
WHERE regulation_key='nis2' AND event_date='2023-01-16' AND label=$$NIS2 Directive enters into force$$;

UPDATE conformity_timeline SET label_nl=$$Machineverordening treedt in werking$$
WHERE regulation_key='machinery' AND event_date='2023-07-19' AND label=$$Machinery Regulation enters into force$$;

UPDATE conformity_timeline SET label_nl=$$AI Act treedt in werking$$
WHERE regulation_key='ai_act' AND event_date='2024-08-01' AND label=$$AI Act enters into force$$;

UPDATE conformity_timeline SET label_nl=$$Uiterste datum voor omzetting door de lidstaten$$
WHERE regulation_key='nis2' AND event_date='2024-10-17' AND label=$$Member State transposition deadline$$;

UPDATE conformity_timeline SET label_nl=$$Nationale maatregelen worden van toepassing$$
WHERE regulation_key='nis2' AND event_date='2024-10-18' AND label=$$National measures apply$$;

UPDATE conformity_timeline SET label_nl=$$CRA treedt in werking$$
WHERE regulation_key='cra' AND event_date='2024-12-10' AND label=$$CRA enters into force$$;

UPDATE conformity_timeline SET label_nl=$$Verboden praktijken (art. 5) worden van toepassing$$
WHERE regulation_key='ai_act' AND event_date='2025-02-02' AND label=$$Prohibited practices (Art 5) apply$$;

UPDATE conformity_timeline SET label_nl=$$Lidstaten stellen registers van entiteiten op$$
WHERE regulation_key='nis2' AND event_date='2025-04-17' AND label=$$Member States establish registers of entities$$;

UPDATE conformity_timeline SET label_nl=$$Regels voor GPAI en governance worden van toepassing$$
WHERE regulation_key='ai_act' AND event_date='2025-08-02' AND label=$$GPAI and governance rules apply$$;

UPDATE conformity_timeline SET label_nl=$$Regels voor aangemelde instanties worden van toepassing$$
WHERE regulation_key='cra' AND event_date='2026-06-11' AND label=$$Notified-body rules apply$$;

UPDATE conformity_timeline SET label_nl=$$Verplichtingen voor hoog risico (bijlage III) worden van toepassing$$
WHERE regulation_key='ai_act' AND event_date='2026-08-02' AND label=$$High-risk (Annex III) obligations apply$$;

UPDATE conformity_timeline SET label_nl=$$Meldingsverplichtingen (art. 14) worden van toepassing$$
WHERE regulation_key='cra' AND event_date='2026-09-11' AND label=$$Reporting obligations (Art 14) apply$$;

UPDATE conformity_timeline SET label_nl=$$Volledige toepassing — intrekking van Richtlijn 2006/42/EG$$
WHERE regulation_key='machinery' AND event_date='2027-01-20' AND label=$$Full application — repeals Directive 2006/42/EC$$;

UPDATE conformity_timeline SET label_nl=$$Verplichtingen voor hoog risico (bijlage I) worden van toepassing$$
WHERE regulation_key='ai_act' AND event_date='2027-08-02' AND label=$$High-risk (Annex I) obligations apply$$;

UPDATE conformity_timeline SET label_nl=$$Volledige toepassing — CE-markering vereist$$
WHERE regulation_key='cra' AND event_date='2027-12-11' AND label=$$Full application — CE marking required$$;

COMMIT;
