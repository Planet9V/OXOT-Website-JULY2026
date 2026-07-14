-- 020_seed_cra_ce_marking_nl.sql
-- Dutch (NL) translation of the CRA CE-marking pathways page. Seeded via db:migrate
-- (the Railway pre-deploy seed:* steps do not run). Idempotent upsert.

INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('cra-ce-marking-pathways', 'nl', 'CRA — CE-markeringstrajecten & conformiteitsbeoordeling', '[Kaders](/nl/frameworks) › [Cyberweerbaarheidsverordening](/nl/cra) › CE-markeringstrajecten

> **Naslagwerk voor de praktijk.** Deze pagina behandelt hoe u conformiteit daadwerkelijk aantoont en CE-markeert onder de CRA. Voor het overzicht in gewone taal, zie de [veldgids Cyberweerbaarheidsverordening](/nl/cra); voor de volledige artikelsgewijze afbeelding, zie het [CRA volledige technische naslagwerk](/nl/cra-technical-reference).

> **Beoogd gebruik:** Dit naslagwerk is bedoeld voor productteams, compliance-verantwoordelijken en beveiligingsarchitecten die CE-markeringstrajecten onder de CRA plannen. Het behandelt elk conformiteitstraject, de procesarchitectuur, de vereisten voor de conformiteitsverklaring, de mechaniek van betrokkenheid van aangemelde instanties en praktische bouwstenen die organisaties als programmablauwdruk kunnen aanpassen.

***

## Deel I — Architectuur van het CRA-conformiteitssysteem

### 1.1 Wettelijke grondslag

De verplichting tot conformiteitsbeoordeling vloeit voort uit **Artikel 32** van Verordening (EU) 2024/2847:

> *"De fabrikant toont de conformiteit met de essentiële cyberbeveiligingsvereisten aan door middel van een van de volgende procedures: (a) interne controle (op basis van module A) overeenkomstig Bijlage VIII; (b) EU-typeonderzoek (op basis van module B) overeenkomstig Bijlage VIII, gevolgd door conformiteit met het type op basis van interne productiecontrole (op basis van module C) overeenkomstig Bijlage VIII; (c) conformiteit op basis van volledige kwaliteitsborging (op basis van module H) overeenkomstig Bijlage VIII; of (d) indien beschikbaar en van toepassing, een Europees cyberbeveiligingscertificeringsschema krachtens Artikel 27, lid 9."*

De modules zijn afkomstig uit het **Nieuwe Wetgevingskader (NLF)** van de EU — Besluit 768/2008/EG — en zijn goed ingeburgerd in andere CE-markeringsregelgeving (Radioapparatuurrichtlijn, Verordening medische hulpmiddelen, Machineverordening). De CRA past ze aan het cyberbeveiligingsdomein aan.

### 1.2 CE-markering als toegangspoort tot de markt

Vanaf **11 december 2027** mag geen enkel product met digitale elementen wettelijk op de EU-markt worden aangeboden zonder een geldige CE-markering die CRA-conformiteit aantoont. De CE-markering wordt **uitsluitend** aangebracht nadat:
1. De conformiteitsbeoordelingsprocedure is voltooid
2. De EU-conformiteitsverklaring is opgesteld en ondertekend
3. Alle technische documentatie is samengesteld

De CE-markering heeft geen vervaldatum, maar moet worden verwijderd of bijgewerkt als het product een substantiële wijziging ondergaat die de conformiteit beïnvloedt.

### 1.3 De classificatiepoort bepaalt de module

De keuze van de module is **niet vrij** — deze wordt bepaald door de risicoclassificatie van het product krachtens Artikelen 6–8:

| Productclassificatie | Beschikbare modules | Zelfbeoordeling toegestaan? |
|---|---|---|
| **Standaard** | Alleen Module A | Ja — altijd |
| **Belangrijk Klasse I** (Bijlage III, Klasse I) | Module A indien volledige geharmoniseerde norm toegepast; anders Module B+C of H | Ja, INDIEN de geharmoniseerde norm alle vereisten dekt |
| **Belangrijk Klasse II** (Bijlage III, Klasse II) | Alleen Module B+C of Module H | Nee — nooit |
| **Kritiek** (Bijlage IV) | Europees cyberbeveiligingscertificeringsschema; indien geen, Module B+C of H | Nee — nooit |

De meest bepalende compliancebeslissing is daarom de classificatie, niet de technische implementatie. Een onjuiste classificatie laat in het programma kan de volledige conformiteitsbeoordeling ongeldig maken.

***

## Deel II — Module A: interne controle (zelfbeoordeling)

### 2.1 Wettelijke grondslag en toepasselijkheid

Module A is vastgelegd in **Deel I van Bijlage VIII** van de CRA. Het is het "standaard"-traject: geen aangemelde instantie, geen externe audit, een verklaring onder de uitsluitende verantwoordelijkheid van de fabrikant. Het is van toepassing op:
- Alle Standaard-producten, ongeacht hoe de fabrikant technisch aantoont conform te zijn (zelfs als er geen geharmoniseerde norm wordt gebruikt)
- Belangrijk Klasse I-producten waarbij de fabrikant een geharmoniseerde norm of relevant Europees cyberbeveiligingscertificeringsschema dat alle toepasselijke vereisten van Bijlage I dekt **volledig heeft toegepast**

> *"Module A, vastgelegd in Deel I van Bijlage VIII CRA, is de meest eenvoudige conformiteitsbeoordelingsprocedure. Het is een zelfbeoordeling, geheel uitgevoerd onder de uitsluitende verantwoordelijkheid van de fabrikant. Er is geen aangemelde instantie bij betrokken."*

### 2.2 Kritieke beperking: timing geharmoniseerde norm voor Klasse I

Sinds juni 2026 zijn **er geen geharmoniseerde CRA-normen aangehaald in het Publicatieblad van de EU**. Dit betekent dat op dit moment alle fabrikanten van Belangrijk Klasse I standaard het derde-partijtraject (Module B+C of H) gebruiken — het Module A-zelfbeoordelingstraject voor Klasse I is tijdelijk geblokkeerd totdat vermelding in het PBEU plaatsvindt, naar verwachting rond Q2 2027. Fabrikanten van Klasse I-producten die mikken op CE-markering per december 2027 moeten een tweefasenaanpak plannen:
- **Fase 1 (nu–Q2 2027):** Voer Module B+C of H uit met een aangemelde instantie, of ontwikkel al het bewijs vooraf tegen de verwachte geharmoniseerde norm
- **Fase 2 (na vermelding in het PBEU):** Waar de geharmoniseerde norm het product volledig dekt, stap over naar Module A-zelfbeoordeling voor toekomstige productversies

### 2.3 Processtappen Module A — stap voor stap

#### Stap 1 — Verificatie van productbereik en classificatie

Voordat u Module A initieert, bevestig dat het product daadwerkelijk in de categorie Standaard valt of dat de volledige geharmoniseerde norm alle toepasselijke vereisten van Bijlage I voor Klasse I dekt. Houd een gedocumenteerd **Classificatiebeslissingsverslag** (CBV) bij met verwijzingen naar de specifieke uitsluitingsanalyse van Bijlage III, de definitie van de productgrenzen en een verklaring van het beoogde gebruik.

*Bouwsteen: CBV-sjabloon*
```
CLASSIFICATIEBESLISSINGSVERSLAG
Product: [Naam, Model, Versie(s)]
Auteur: [Naam, Functie]          Datum: [JJJJ-MM-DD]
---------------------------------------------------------
Sectie A: CRA-toepassingsgebiedbeoordeling
  A1. Is dit een PDE volgens Artikel 3(1)?    [J/N + onderbouwing]
  A2. Is een uitsluiting uit Artikel 2 van toepassing? [J/N + onderbouwing]
  A3. Externe gegevensverwerking aanwezig?    [J/N + beschrijving]

Sectie B: Classificatieanalyse
  B1. Staat product in Bijlage III Klasse I?  [J/N + specifiek item]
  B2. Staat product in Bijlage III Klasse II? [J/N + specifiek item]
  B3. Staat product in Bijlage IV?            [J/N + specifiek item]
  B4. Classificatieresultaat:                 [Standaard / Belangr.I / Belangr.II / Kritiek]

Sectie C: Moduleselectie
  C1. Indien Standaard: Module A bevestigd    [bevestig]
  C2. Indien Belangrijk Klasse I: Geharm. norm? [Normref + PBEU-datum / Niet beschikbaar]
  C3. Geselecteerde module:                   [A / B+C / H / EUCC]

Goedgekeurd door: [Ondertekenaar]  Functie: [Positie met wettelijke bevoegdheid]
```

#### Stap 2 — Cyberbeveiligingsrisicobeoordeling (Artikel 13(2)–(3))

De risicobeoordeling is het funderende document voor Module A. Deze moet:
- Het dreigingsprofiel en de beoogde operationele omgeving identificeren
- Elke vereiste van Bijlage I, Deel I, punt (2)(a)–(m) afbeelden op een bepaling van toepasselijkheid
- Documenteren hoe toepasselijke vereisten worden geïmplementeerd
- Niet-toepasselijke vereisten documenteren met *"een duidelijke onderbouwing"* (Artikel 13(4))
- Zowel beveiligingseigenschappen (Deel I) als kwetsbaarhedenbeheer (Deel II) dekken

*Bouwsteen: structuur risicobeoordeling voor Module A*
```
CRA-CYBERBEVEILIGINGSRISICOBEOORDELING
Product: [Naam, Model, Versie]        Classificatie: [Standaard/Klasse I]
Versie risicobeoordeling: [x.y]       Datum: [JJJJ-MM-DD]
-----------------------------------------------------------------------
1. PRODUCTPROFIEL
   1.1 Beoogd doel en gebruiksscenario''s
   1.2 Connectiviteitsinterfaces (bedraad, draadloos, protocollen)
   1.3 Operationele omgeving (thuis/onderneming/industrieel/kritiek)
   1.4 Gebruikerstypen (consument/professional/beheerder)
   1.5 Verwachte levensduur en onderbouwing ondersteuningsperiode

2. DREIGINGSLANDSCHAP
   2.1 Profiel dreigingsactor (opportunistisch / gericht / IACS-specifiek)
   2.2 Aanvalsvectoren (netwerk / lokaal / fysiek / toeleveringsketen)
   2.3 Te beschermen activa (gegevens, functionaliteit, gebruikers)
   2.4 Geraadpleegde relevante dreigingsinformatiebronnen

3. AFBEELDING VEREISTEN BIJLAGE I DEEL I
   Voor elke deelvereiste (a) tot en met (m):
   | Ver | Toepasselijk? | Onderbouwing | Implementatie |
   |-----|---------------|--------------|---------------|
   |(a) Geen bekende kwetsb. | JA | Verbonden product | SBOM-gate release + pre-release scan |
   |(b) Veilig standaard | JA | Consumentgericht | Geen standaardwachtwoorden; fabrieksreset |
   |(c) Beveiligingsupdates | JA | Genetwerkt | Auto-update standaard met opt-out |
   |(d) Toegangscontrole | JA | Multi-user API | MFA voor beheer; RBAC |
   |(e) Vertrouwelijkheid | JA | PII in transit | TLS 1.3; AES-256 in rust |
   |(f) Integriteit gegevens | JA | Config beschermd | HMAC op config; ondertekende firmware |
   |(g) Gegevensminimalisatie | JA | Telemetrie verzameld | Beperkt verzamelbeleid |
   |(h) Beschikbaarheid | JA | Netwerkverbonden | Rate limiting; DoS-bescherming |
   |(i) Aanvalsoppervlak | JA | Internetgericht | Onnodige poorten/diensten gesloten |
   |(j) Impact incident | JA | Genetwerkt | Netwerksegmentatie; inperking |
   |(k) Logging | JA | Ondernemingsgebruik | Auditlog met opt-out |
   |(l) Gegevensverwijdering | JA | Gebruikersdata opgeslagen | Veilig wissen bij fabrieksreset |
   |(m) Blootstelling beperken | JA | Alle producten | SDL toegepast; minimale footprint |

4. AFBEELDING VEREISTEN BIJLAGE I DEEL II
   [Zelfde tabelformaat voor elk van de 8 kwetsbaarhedenbeheer-vereisten]

5. RISICOCONCLUSIE
   5.1 Algeheel risicoprofiel
   5.2 Restrisico''s en mitigaties
   5.3 Bepaling ondersteuningsperiode en onderbouwing
```

#### Stap 3 — Implementeer beveiligingsmaatregelen en valideer

Implementeer alle toepasselijke vereisten van Bijlage I. Bij Module A is de fabrikant verantwoordelijk voor het kiezen van de validatiemethoden — testrapporten, statische/dynamische analyse, samenvattingen van penetratietests of ontwerpanalyse — en het bewaren van bewijs. Er is geen externe verificatievereiste voor Module A.

Aanbevolen bewijsset voor Standaard-producten:
- Pre-release kwetsbaarheidsscanrapport (tooling: Grype, Trivy, Semgrep of gelijkwaardig)
- SBOM voor elke releaseversie (CycloneDX- of SPDX-formaat)
- Samenvatting penetratietest of ontwerpgebaseerde beveiligingsanalyse (evenredig met het productrisico)
- Documentatie beoordeling veilige configuratie
- Testcases die aantonen: authenticatievergrendeling, integriteit updatemechanisme, fabrieksresetfunctie, handhaving toegangscontrole

#### Stap 4 — Stel technische documentatie samen (Artikel 31, Bijlage VII)

Stel het volledige technisch dossier samen. Dit is dezelfde bewijsverzameling die ongeacht de module vereist is, en het document dat een beoordelaar of markttoezichtautoriteit zal onderzoeken. Zie Deel V van dit rapport voor de volledige elementenlijst van Bijlage VII.

#### Stap 5 — Stel EU-conformiteitsverklaring op en onderteken (Artikel 28, Bijlage V)

Geef de conformiteitsverklaring uit volgens de structuur van Bijlage V (zie Deel VI). De verklaring mag niet worden ondertekend voordat de conformiteitsbeoordeling is voltooid en het bewijs is samengesteld. De verklaring moet worden herzien en bijgewerkt als het product substantieel wordt gewijzigd.

#### Stap 6 — Breng CE-markering aan en beheer productieconformiteit

Breng de CE-markering zichtbaar, leesbaar en onuitwisbaar aan op het product, de verpakking of — voor software — de begeleidende documentatie of downloadpagina. Bij Module A moet de fabrikant interne controles hebben om te waarborgen dat productie-eenheden (latere releases) blijven voldoen aan de beoordeelde versie. Wanneer een nieuwe softwareversie wordt uitgebracht, is een beoordeling vereist of deze een substantiële wijziging vormt.

### 2.4 Tijdsbenchmark Module A

Een goed voorbereide organisatie met bestaande SBOM-tooling en een secure development lifecycle (SDL) moet rekening houden met:

| Activiteit | Duur |
|---|---|
| Classificatiebeslissing en risicobeoordeling | 4–8 weken |
| Beveiligingsimplementatie en interne tests | 8–16 weken (productafhankelijk) |
| Samenstellen technische documentatie | 4–6 weken |
| Voorbereiding conformiteitsverklaring, juridische toetsing en ondertekening | 1–2 weken |
| **Totaal (nieuw product, Module A)** | **17–32 weken** |

Voor bestaande producten met een volwassen beveiligingshouding is het samenstellen van de technische documentatie doorgaans het kritieke-pad-item.

***

## Deel III — Module B+C: EU-typeonderzoek met aangemelde instantie

### 3.1 Wettelijke grondslag en toepasselijkheid

Module B+C is vastgelegd in **Delen II en III van Bijlage VIII**. Het combineert:
- **Module B** — EU-typeonderzoek door een aangemelde instantie van het product*type* (ontwerp en architectuur)
- **Module C** — doorlopende conformiteit met het type op basis van de interne productiecontrole van de fabrikant

Module B+C is vereist voor:
- Belangrijk Klasse I-producten waarvoor geen toepasselijke geharmoniseerde norm volledig is toegepast
- **Alle** Belangrijk Klasse II-producten
- Kritieke producten waarvoor geen verplicht EUCC-certificeringsschema is aangewezen

> *"Bij deze procedure blijft de fabrikant verantwoordelijk voor het implementeren van cyberbeveiligingsmaatregelen, het testen van het product en het opstellen van de technische documentatie. De aangemelde instantie speelt echter een centrale rol door het technisch ontwerp van het product te beoordelen op basis van documentatie en monsters, en door de noodzakelijke tests uit te voeren of te laten uitvoeren."*

### 3.2 Wat een aangemelde instantie is en hoe zij wordt aangewezen

Een aangemelde instantie (AI) is een **conformiteitsbeoordelingsinstantie (CAB) die door een EU-lidstaat is aangewezen** om derde-partijbeoordelingen onder de CRA uit te voeren. Aanwijzing vereist:
1. De CAB dient bij de nationale autoriteit (aanmeldende autoriteit) een aanvraag tot aanwijzing in
2. De nationale autoriteit verifieert dat de CAB voldoet aan de vereisten van Artikel 43 CRA: technische competentie, onafhankelijkheid, onpartijdigheid, adequate verzekering en domeinkennis
3. Accreditatie door een nationale accreditatie-instantie (NAB) volgens EN ISO/IEC 17065 (productcertificatie) of EN ISO/IEC 17021 (certificering managementsystemen)
4. Formele aanmelding bij de Europese Commissie via NANDO (Notification And Database Online)
5. Opname in de NANDO-database, waarna de AI haar identificatienummer kan ontvangen (een 4-cijferig NANDO-nummer dat naast de CE-markering wordt afgedrukt)

**Beschikbaarheid CRA-aangemelde instanties — status juni 2026:**

> *"Op 11 juni 2026 werden de CRA-regels inzake aangemelde instanties van toepassing, maar er is er nog geen aangewezen."*

De aanwijzings- en accreditatieprocedure voor een aangemelde instantie duurt doorgaans **12 tot 18 maanden**. Dit betekent dat de pool van CRA-aangewezen aangemelde instanties tot ver in 2027 uiterst klein zal blijven. Verschillende organisaties die als aangemelde instantie optreden onder de Radioapparatuurrichtlijn (RED), de Verordening medische hulpmiddelen (MDR) en de Machineverordening hebben CRA-gereedheidsprogramma''s aangekondigd, waaronder TÜV Rheinland, TÜV SÜD, BSI Group, SGS, Bureau Veritas en Applus+ Laboratories.

Het praktische gevolg: **de vraag naar CRA-diensten van aangemelde instanties zal de capaciteit in 2026–2027 ver overtreffen**. Fabrikanten die Module B+C of H nodig hebben, moeten onmiddellijk in de wachtrij aansluiten.

### 3.3 Module B: EU-typeonderzoek — stapsgewijs proces

De aangemelde instantie voert het EU-typeonderzoek (Module B) uit tegen de technische documentatie en een representatief productmonster. Het onderzoek dekt zowel het technisch ontwerp als de processen voor kwetsbaarhedenbeheer.

#### Fase 1 — Voorbereiding en selectie van de aangemelde instantie

Voordat u een aanvraag indient:
- Identificeer kandidaat-instanties via de NANDO-database (zoek op CRA-scope zodra aanwijzingen verschijnen)
- Verifieer dat de AI technische competentie heeft in het productdomein (softwareproducten, IoT, industriële besturingssystemen, embedded systems — verschillende instanties kunnen verschillende scopes hebben)
- Vraag een scopinggesprek aan om instantie-specifieke indieningsvereisten en tijdlijnen te begrijpen
- Verkrijg een voorlopige kosten- en tijdlijnraming — kosten variëren sterk per instantie, productcomplexiteit en beoordelingsscope

*Bouwsteen: scorekaart evaluatie aangemelde instantie*
```
EVALUATIEMATRIX AANGEMELDE INSTANTIE
Evaluatiedatum: [JJJJ-MM-DD]     Product: [Naam, Klasse]
---------------------------------------------------------
Kandidaat-AI: [Naam]
  NANDO-nummer: [####]           NANDO-scope: [CRA / RED / MDR]
  Domeinexpertise:
    - Software/firmware:         [Hoog / Middel / Laag / Onbekend]
    - ICS/OT-producten:          [Hoog / Middel / Laag / Onbekend]
    - Consumenten-IoT:           [Hoog / Middel / Laag / Onbekend]
    - Industrieel Klasse II:     [Hoog / Middel / Laag / Onbekend]
  Capaciteitsbeoordeling:
    - Huidige achterstand (maanden): [raming uit scopinggesprek]
    - Vroegste intakedatum:      [JJJJ-MM]
    - Geschatte beoordelingsduur: [maanden]
    - Toezichtsverbintenis:      [jaarlijks / tweejaarlijks / anders]
  Kostenraming:
    - Module B-onderzoek:        [€-bereik]
    - Jaarlijks toezicht:        [€-bereik]
  Communicatiekwaliteit:         [Score 1–5]
  Geografische dekking:          [EU / Wereldwijd]
  Talen:                         [lijst]
  Referentieklanten beschikbaar? [J/N]
  ---------------------------------------------------------
  AANBEVELING: [Geselecteerd / Reserve / Afgewezen]
  Onderbouwing: [aantekeningen]
```

#### Fase 2 — Indiening van de aanvraag

Dien een formele aanvraag in bij de gekozen AI. Standaard indieningsinhoud:

- Ingevuld aanvraagformulier van de AI (instantie-specifiek formaat)
- Pakket technische documentatie volgens Bijlage VII (zie Deel V) — aangeleverd als gestructureerde PDF of via een documentportaal
- Een of meer representatieve productmonsters voor fysiek onderzoek (hardwareproducten) of toegangsgegevens (software/cloud)
- Concept EU-conformiteitsverklaring (versie vóór ondertekening)
- Bevestiging van de door de fabrikant genomen beslissingen over toepasselijkheid van Bijlage I
- Lijst van toegepaste geharmoniseerde normen, gemeenschappelijke specificaties of technische specificaties

De AI geeft doorgaans binnen 2–4 weken na indiening een **ontvangstbevestiging** af, waarin wordt bevestigd dat de aanvraag volledig is en het onderzoek is ingepland.

#### Fase 3 — Toetsing technische documentatie (Module B, fase 1)

De AI voert een bureautoetsing van de technische documentatie uit:

- Verifieert de volledigheid van de inhoud van Bijlage VII
- Toetst de risicobeoordeling en de beslissingen over toepasselijkheid van Bijlage I
- Beoordeelt de cyberbeveiligingsarchitectuur tegen de vereisten van Bijlage I Deel I
- Toetst de SBOM en de documentatie van het proces voor kwetsbaarhedenbeheer
- Toetst het CVD-beleid, het centrale contactpunt en de documentatie over rapportagecapaciteit onder Artikel 14
- Toetst testplannen en bestaand testbewijs
- Geeft een **toetsingsrapport technische documentatie** af waarin eventuele hiaten (non-conformiteiten of opmerkingen) worden geïdentificeerd

De fabrikant moet alle geïdentificeerde non-conformiteiten oplossen voordat de AI verdergaat. Hiaten die tijdens de toetsing worden geïdentificeerd en herstel vereisen, verlengen de totale tijdlijn — vaak met 4–8 weken per herstelcyclus.

#### Fase 4 — Producttests en onderzoek

Voor hardwareproducten onderzoekt de AI het ingediende monster (of monsters). Voor software beoordeelt de AI in een testomgeving of via gedocumenteerde analyse. Het onderzoek kan omvatten:

- Functionele beveiligingstests van geïmplementeerde maatregelen (authenticatie, toegangscontrole, cryptografische implementaties)
- Toetsing van de integriteit van het updatemechanisme (ondertekening, rollbackbescherming)
- Validatie van de veilige standaardconfiguratie
- Beoordeling van de nauwkeurigheid van de SBOM tegen de daadwerkelijke productbinary
- Verificatie dat er geen bekende exploiteerbare kwetsbaarheden in de ingediende versie bestaan (live CVE-controle tegen de SBOM)
- Doorloop van het proces voor kwetsbaarhedenbeheer (procedurele beoordeling)

#### Fase 5 — Afgifte EU-typeonderzoekscertificaat

Als het onderzoek succesvol is:

> *"Als de aangemelde instantie concludeert dat het product voldoet aan de CRA, geeft zij een EU-typeonderzoekscertificaat af, geldig voor een bepaalde periode."*

Het EU-typeonderzoekscertificaat bevat:
- Naam en identificatienummer van de AI
- Naam en adres van de fabrikant
- Productidentificatie (type, model, onderzochte versies)
- Onderzoeksresultaat en voorwaarden/beperkingen
- Geldigheidsduur (doorgaans 5 jaar, onder voorbehoud van toezicht)
- Verwijzingen naar de bij het onderzoek toegepaste normen of technische specificaties
- Ondertekend door de verantwoordelijke onderzoeker van de AI

Het certificaat dekt het specifieke product*type* — het onderzochte ontwerp. Alle productie-eenheden (Module C) moeten conform dit type zijn.

#### Fase 6 — Module C: conformiteit met het type (verantwoordelijkheid fabrikant)

Module C is de verplichting van de fabrikant om doorlopende productieconformiteit met het goedgekeurde type te waarborgen. Onder de CRA vereist Module C:

- Interne productiecontroles die voorkomen dat vervaardigde eenheden (of softwarereleases) afwijken van het onderzochte type
- Wanneer een nieuwe versie op een beveiligingsrelevante wijze afwijkt van het onderzochte type, moet de fabrikant de AI op de hoogte stellen om te bepalen of een nieuw onderzoek vereist is
- Elke wijziging die de beveiligingseigenschappen van Bijlage I of het beoogde doel beïnvloedt en die een substantiële wijziging vormt, vereist een nieuw Module B-onderzoek en een nieuw certificaat

*Bouwsteen: procedure productieconformiteit Module C*
```
MODULE C: PROCEDURE PRODUCTIECONFORMITEIT

Doel: Waarborgen dat elke release conform is aan het onder Module B onderzochte type.
Van toepassing op: Alle releases van [Productnaam] na afgifte certificaat.
Eigenaar: [Product Security Lead / QMS-eigenaar]

WIJZIGINGSCLASSIFICATIEPOORT (per release):
Beoordeel voor elke voorgestelde wijziging tegen het onderzochte type:

  1. Beïnvloedt de wijziging een beveiligingseigenschap van Bijlage I? [J/N]
  2. Wijzigt de wijziging een in de SBOM vermeld component?          [J/N]
  3. Verandert de wijziging het beoogde doel van het product?        [J/N]
  4. Wijzigt de wijziging een beveiligingsrelevant architectuurelement? [J/N]

  Indien ALLE antwoorden = N: Kleine wijziging, Module C-controles gelden, geen melding aan AI nodig.
  Indien EEN antwoord = J: Beoordeel de ernst:
    - Alleen beveiligingsverbetering (geen nieuw risico): Documenteer, werk technisch dossier bij, meld informeel aan AI.
    - Nieuw beveiligingsrisico of gewijzigd beoogd doel: Behandel als substantiële wijziging.
      Actie: Schort CE-markering op voor betrokken versies; start nieuw Module B-onderzoek.

RELEASEPOORTCONTROLELIJST:
  □ Wijzigingsclassificatiepoort voltooid en gedocumenteerd
  □ SBOM bijgewerkt naar de componentenset van de release
  □ CVE-scan tegen bijgewerkte SBOM — nul bekende exploiteerbare kwetsbaarheden
  □ Testrapport bevestigt conformiteit met onderzocht type
  □ Technische documentatie bijgewerkt (versie verhoogd)
  □ Conformiteitsverklaring bijgewerkt indien productversiescope wijzigt
  □ Melding aan AI voltooid (indien vereist door classificatiepoort)
```

### 3.4 Tijdsbenchmark Module B+C

| Fase | Geschatte duur |
|---|---|
| Selectie en scoping aangemelde instantie | 4–8 weken |
| Voorbereiding en indiening aanvraag | 6–12 weken |
| Intake-acceptatie AI | 2–4 weken |
| Toetsing technische documentatie | 4–8 weken |
| Herstelcyclus (indien non-conformiteiten geïdentificeerd) | 4–8 weken per cyclus |
| Productonderzoek en tests | 4–8 weken |
| Afgifte certificaat | 2–4 weken |
| Voorbereiding, toetsing en ondertekening conformiteitsverklaring | 1–2 weken |
| **Totaal (goed voorbereide organisatie)** | **4–8 maanden** |
| **Totaal (hiaten die herstel vereisen)** | **8–14 maanden** |

Deze ramingen zijn gebaseerd op analoge ervaring onder andere EU-NLF-kaders (RED, MDR) en weerspiegelen het verwachte CRA-proces. Gezien de capaciteitsbeperkingen van aangemelde instanties in 2026–2027, tel 2–4 maanden wachtrijtijd op voor de meeste fabrikanten die eind 2026 of begin 2027 aan het proces beginnen.

**Kritieke implicatie:** Voor Belangrijk Klasse II-producten die mikken op 11 december 2027 moet het Module B+C-proces uiterlijk rond **februari–maart 2027** absoluut worden gestart — idealiter in Q4 2026.

***

## Deel IV — Module H: volledige kwaliteitsborging

### 4.1 Wettelijke grondslag en concept

Module H is vastgelegd in **Deel IV van Bijlage VIII** en vormt het meest flexibele derde-partijtraject voor organisaties met een breed productportfolio:

> *"Module H, vastgelegd in Deel IV van Bijlage VIII, is een conformiteitsbeoordelingsprocedure waarbij de fabrikant een volledig kwaliteitscontrolesysteem implementeert dat waarborgt dat de aan dit systeem onderworpen producten voldoen aan de essentiële vereisten van de CRA, zowel in de ontwerp- als in de productiefase."*

Anders dan Module B+C, dat zich richt op een specifiek product*type*, beoordeelt Module H het **kwaliteitsmanagementsysteem (QMS)** van de fabrikant over een gedefinieerd productportfolio. Individuele producten ondergaan niet elk een afzonderlijk onderzoek — in plaats daarvan verifieert de AI dat het QMS in staat is consistent CRA-conforme producten voort te brengen.

### 4.2 Module H vs. Module B+C: strategische vergelijking

| Dimensie | Module B+C | Module H |
|---|---|---|
| Beoordelingsfocus | Ontwerp van individueel producttype | QMS van de fabrikant over het productportfolio |
| Betrokkenheid AI | Onderzoek per product + certificaat | QMS-audit + doorlopende toezichtsbezoeken |
| Schaalbaarheid | Laag — elk nieuw producttype vereist nieuw onderzoek | Hoog — nieuwe producten toegevoegd aan bestaande QMS-scope via uitbreiding |
| Initiële investering | Lager (enkel product) | Hoger (QMS-ontwerp, documentatie, auditvoorbereiding) |
| Doorlopende kosten | Per product + toezicht | Jaarlijks/tweejaarlijks toezicht, beoordelingen productuitbreiding |
| Beste voor | Smal productportfolio; weinig nieuwe producten per jaar | Breed portfolio; frequente introductie van nieuwe producten |
| Relevantie ISO 9000 | Geen | ISO 9000/9001 biedt nuttig kader, maar kwalificeert NIET automatisch — AI-beoordeling blijft vereist |
| Flexibiliteit voor productupdates | Vereist melding aan AI voor typewijzigingen | Updates beoordeeld via QMS-wijzigingsbeheer; AI-toetsing van wijzigingen |
| Documentatie-overhead | Technisch dossier per product | QMS-documentatie + conformiteitsregisters per product binnen QMS |

> *"Module H is opgebouwd rond een volledig kwaliteitscontrolesysteem dat ontwerp, ontwikkeling, testen, productie en kwetsbaarhedenbeheer omvat. In plaats van zich te richten op individuele producten, biedt het een veelzijdiger en flexibeler kader in vergelijking met module B+C."*

### 4.3 Structuur en inhoud QMS onder Module H

Het QMS onder Module H moet de volledige productlevenscyclus dekken. CRA Bijlage VIII Deel IV vereist dat het QMS het volgende documenteert en beheerst:

**Ontwerp- en ontwikkelingscontroles:**
- Procedures voor het uitvoeren van cyberbeveiligingsrisicobeoordelingen (Artikel 13(2)–(3))
- Toegepaste secure development lifecycle (SDL)-methodologieën
- Methoden voor het bepalen van de toepasselijkheid van vereisten uit Bijlage I
- Processen voor beveiligingsarchitectuurtoetsing
- Criteria voor het selecteren van cryptografische algoritmen en sleutellengtes (beoordeling stand der techniek)
- Methoden voor het genereren en onderhouden van SBOM''s per release

**Test- en verificatiecontroles:**
- Beveiligingstestprogramma: penetratietesten, fuzzing, statische analyse, dynamische analyse
- Testdekkingsvereisten per productrisicoklasse
- Standaarden voor bewaring van testbewijs
- Pre-release CVE-scannen tegen de SBOM — poortcriteria voor release

**Controles kwetsbaarhedenbeheer:**
- Processen voor onderhoud en publicatie van CVD-beleid
- Interne procedures voor intake, triage en prioritering van kwetsbaarheden
- Pijplijn voor ontwikkeling, testen en release van patches voor beveiligingsupdates
- Procedures voor rapportage aan het ENISA Single Reporting Platform (SRP) (cascade 24u/72u/14d)
- Stroomopwaartse rapportage van kwetsbaarheden in componenten van derden (Artikel 13(6))

**Productie- en releasecontroles:**
- Wijzigingsclassificatiepoort (beoordeling substantiële wijziging)
- Aan Module C gelijkwaardige controles op productieconformiteit
- Controles op SBOM-update per release
- Controles op CE-markering en update conformiteitsverklaring die door productwijzigingen worden geactiveerd

**Monitoring na het in de handel brengen:**
- Monitoring van CVE-feeds tegen de product-SBOM
- Monitoring van en respons op beveiligingsincidenten
- Procedures voor gebruikersmeldingen
- Beheer van de levenscyclus einde-ondersteuning

*Bouwsteen: documentstructuur QMS onder Module H*
```
DOCUMENTSTRUCTUUR QMS MODULE H

Niveau 1 — Kwaliteitshandboek (QM-001)
  Scope van de gedekte producten
  Wettelijke grondslag en regelgevingscontext (CRA Art. 32, Bijlage VIII Deel IV)
  QMS-architectuur en interactie van processen
  Directieverantwoordelijkheid en middelen

Niveau 2 — Procedures (PRO-xxx)
  PRO-001: Productclassificatie en toepassingsgebiedbeoordeling
  PRO-002: Cyberbeveiligingsrisicobeoordeling
  PRO-003: Secure development lifecycle (SDL)
  PRO-004: SBOM-generatie en -beheer
  PRO-005: Beveiligingstesten en beheer van testbewijs
  PRO-006: Intake en triage van kwetsbaarheden
  PRO-007: Beheer CVD-beleid
  PRO-008: Ontwikkeling en release van beveiligingsupdates
  PRO-009: Rapportage aan ENISA/CSIRT (Artikel 14)
  PRO-010: Wijzigingsclassificatie en beoordeling substantiële wijziging
  PRO-011: Samenstelling en onderhoud technische documentatie
  PRO-012: Beheer conformiteitsverklaring
  PRO-013: Controles CE-markering
  PRO-014: Monitoring en toezicht na het in de handel brengen
  PRO-015: Beheer levenscyclus einde-ondersteuning
  PRO-016: Interne audit en directiebeoordeling
  PRO-017: Relatiebeheer AI en coördinatie van toezicht

Niveau 3 — Werkinstructies (WI-xxx)
  [Tool-specifieke procedures, bv. SBOM-generatie in CycloneDX,
   Trivy-scanprocedure, verpakking indiening AI]

Niveau 4 — Registers (REC-xxx)
  Risicobeoordelingsregisters, testrapporten, kwetsbaarhedenlogs,
  SBOM-versies, versies conformiteitsverklaring, AI-correspondentie, auditregisters
```

### 4.4 Beoordelingsproces aangemelde instantie onder Module H

De AI voert een initiële QMS-beoordeling uit, gevolgd door periodiek toezicht:

**Initiële beoordeling:**
1. Dien het pakket QMS-documentatie in bij de AI
2. AI voert documentatietoetsing uit (bureau-audit) — doorgaans 4–6 weken
3. AI voert een on-site audit van de QMS-implementatie uit — toetst de QMS-implementatie tegen de vereisten van CRA Bijlage VIII Deel IV, onderzoekt representatieve producten, interviewt proceseigenaren
4. AI geeft beoordelingsrapport af met eventuele non-conformiteiten
5. Fabrikant pakt non-conformiteiten aan (doorgaans 4–12 weken)
6. AI geeft **certificaat goedkeuring kwaliteitssysteem Module H** af
7. Eerste producten in de handel gebracht onder Module H; fabrikant brengt CE-markering aan met NANDO-nummer van de AI

**Doorlopend toezicht:**
- Periodieke toezichtsaudits door de AI — doorgaans jaarlijks of tweejaarlijks
- Onaangekondigde inspecties zijn toegestaan
- Fabrikant moet de AI op de hoogte stellen van geplande wijzigingen aan het QMS of uitbreidingen van de productscope
- Nieuwe producten die aan de QMS-scope worden toegevoegd, vereisen een uitbreidingsbeoordeling (geen volledige initiële beoordeling)

### 4.5 Tijdsbenchmark Module H

| Fase | Geschatte duur |
|---|---|
| QMS-ontwerp en -documentatie | 3–6 maanden |
| Interne QMS-audit en proefdraai | 4–8 weken |
| AI-aanvraag en intake | 2–4 weken |
| Documentatietoetsing AI | 4–6 weken |
| On-site audit AI | 1–2 weken |
| Herstel non-conformiteiten | 4–12 weken |
| Afgifte certificaat | 2–4 weken |
| **Totaal (nieuw QMS, Module H)** | **8–14 maanden** |
| **Een nieuw product toevoegen aan bestaand QMS** | **4–8 weken** |

De initiële investering in Module H is daarom hoger dan Module B+C voor een enkel product, maar de kosten per product voor latere producten binnen de scope zijn aanzienlijk lager.

***

## Deel V — Het Europese cyberbeveiligingscertificeringstraject (EUCC)

### 5.1 Artikel 27 — vermoeden van conformiteit via certificering

**Artikel 27(9)** bepaalt dat producten die zijn gecertificeerd onder een Europees cyberbeveiligingscertificeringsschema op assurantieniveau **"substantieel" of hoger** een vermoeden van conformiteit genieten met de CRA-vereisten die door het schema worden gedekt:

> *"Producten met digitale elementen die zijn gecertificeerd onder een Europees cyberbeveiligingscertificeringsschema krachtens Artikel 52 van Verordening (EU) 2019/881 worden geacht in overeenstemming te zijn met de essentiële cyberbeveiligingsvereisten van deze verordening, voor zover die vereisten worden gedekt door het cyberbeveiligingscertificaat of delen daarvan."*

### 5.2 EUCC — EU-cyberbeveiligingscertificeringsschema op basis van Common Criteria

De **EUCC (EU-cyberbeveiligingscertificeringsschema op basis van Common Criteria)** is het belangrijkste operationele certificeringsschema onder de EU-cyberbeveiligingsverordening (Verordening (EU) 2019/881). Het is gebaseerd op de internationale norm **ISO/IEC 15408 (Common Criteria)**:

- **EUCC Substantieel:** Afgebeeld op Common Criteria-assurantieniveaus **EAL 1–EAL 4+** — dekt de meeste commerciële producten
- **EUCC Hoog:** Afgebeeld op Common Criteria-assurantieniveaus **EAL 5–EAL 7** — vereist voor producten met hoge assurantie zoals HSM''s, smartcards en kritieke beveiligingsmodules

Een geldig EUCC-certificaat op assurantieniveau Substantieel of Hoog levert een vermoeden van conformiteit met de door het schema gedekte CRA-vereisten — wat betekent dat de fabrikant naar het EUCC-certificaat kan verwijzen in de conformiteitsverklaring in plaats van conformiteit aan te tonen via Module B+C of H.

### 5.3 EUCC vs. NLF-module — vergelijking

| Dimensie | EUCC-certificering | Module B+C | Module H |
|---|---|---|---|
| Gebaseerd op | ISO/IEC 15408 (Common Criteria) + EU-schemaregels | CRA Bijlage VIII + vereisten Bijlage I | CRA Bijlage VIII + vereisten Bijlage I |
| Uitgevoerd door | ITSEF (IT Security Evaluation Facility) + nationale certificeringsinstantie (NCCA) | CRA-aangemelde instantie | CRA-aangemelde instantie |
| Uitvoerdocument | EUCC-certificaat | EU-typeonderzoekscertificaat | Certificaat goedkeuring kwaliteitssysteem |
| Geldigheid | Doorgaans 5 jaar, onder voorbehoud van onderhoud | Bepaalde periode, onder voorbehoud van toezicht | Onder voorbehoud van jaarlijks/tweejaarlijks toezicht |
| Scope | ICT-producten (breed) | Producten met digitale elementen onder CRA | Producten met digitale elementen onder CRA |
| Wederzijdse erkenning | EU-breed + enkele internationaal onder SOG-IS-kader | EU-breed | EU-breed |
| Bestaande investering | JA — organisaties met bestaande CC/EUCC-certificering kunnen die benutten | Nee — CRA-specifiek proces | Nee — CRA-specifiek proces |
| Verplicht voor Kritiek? | Waar de Commissie dit via uitvoeringsverordening voorschrijft | Waar geen verplicht schema | Waar geen verplicht schema |
| Tijdlijn | 6–18 maanden (afhankelijk productcomplexiteit) | 4–14 maanden | 8–14 maanden |

### 5.4 Overzicht EUCC-proces

1. Fabrikant selecteert een gelicentieerde **ITSEF** (IT Security Evaluation Facility) die door de relevante nationale NCCA is geaccrediteerd
2. Fabrikant en ITSEF definiëren het **Target of Evaluation (TOE)** — productgrenzen, beveiligingsdoelstellingen, assurantieniveau van de evaluatie
3. Fabrikant ontwikkelt het **Security Target (ST)**-document — claims, dreigingen, beveiligingsdoelstellingen en functionele beveiligingsvereisten
4. ITSEF voert de evaluatie uit tegen ISO/IEC 15408 en ISO/IEC 18045 (evaluatiemethodologie)
5. ITSEF dient de evaluatieresultaten in bij de **certificeringsinstantie (CB/NCCA)**
6. CB geeft het EUCC-certificaat af
7. Fabrikant verwijst naar het EUCC-certificaat in de conformiteitsverklaring; het certificaat levert een vermoeden van conformiteit voor de gedekte vereisten

***

## Deel VI — Technische documentatie: volledig naslagwerk Bijlage VII

### 6.1 Wettelijke grondslag

De technische documentatie is vereist krachtens **Artikel 31** en gestructureerd door **Bijlage VII** van de CRA. Het is de bewijsverzameling die zowel de conformiteitsbeoordeling (of het nu Module A, B+C, H of EUCC is) als de conformiteitsverklaring ondersteunt. Deze moet gedurende de gehele productlevenscyclus worden onderhouden en bijgewerkt.

### 6.2 Bijlage VII — volledige elementenlijst met bewijsrichtlijnen

**Element 1 — Algemene productbeschrijving (Bijlage VII §1)**

Wettelijke vereiste:
> *"een algemene beschrijving van het product met digitale elementen, met inbegrip van: het beoogde doel; versies van software die de conformiteit met de essentiële cyberbeveiligingsvereisten beïnvloeden; wanneer het product met digitale elementen een hardwareproduct is, foto''s of illustraties die externe kenmerken, markering en interne opbouw tonen; gebruikersinformatie en instructies zoals uiteengezet in Bijlage II"*

Bewijsitems:
- Productdatasheet of specificatiedocument
- Versiematrix (hardwareversies × softwareversies gedekt door dit technisch dossier)
- Hardwarefoto''s die connectoren, markeringen, printplaatopbouw tonen (voor hardwareproducten)
- Volledig pakket gebruikersinformatie uit Bijlage II (zie Deel VII)

**Element 2 — Beschrijving ontwerp, ontwikkeling, productie en kwetsbaarhedenbeheer (Bijlage VII §2)**

Wettelijke vereiste:
> *"een beschrijving van het ontwerp, de ontwikkeling en de productie van het product met digitale elementen en van de processen voor kwetsbaarhedenbeheer, met inbegrip van: noodzakelijke informatie over het ontwerp en de ontwikkeling van het product met digitale elementen, met inbegrip van, waar van toepassing, tekeningen en schema''s en een beschrijving van de systeemarchitectuur die uitlegt hoe softwarecomponenten op elkaar voortbouwen of elkaar voeden en integreren in de algehele verwerking; noodzakelijke informatie en specificaties van de door de fabrikant ingestelde processen voor kwetsbaarhedenbeheer, met inbegrip van de software bill of materials, het beleid voor gecoördineerde kwetsbaarhedenopenbaarmaking, bewijs van het bieden van een contactadres voor het melden van kwetsbaarheden en een beschrijving van de gekozen technische oplossingen voor de veilige distributie van updates; noodzakelijke informatie en specificaties van de productie- en monitoringprocessen van het product met digitale elementen en de validatie van die processen"*

Bewijsitems:
- Systeemarchitectuurdiagram (componentendecompositie, vertrouwensgrenzen, gegevensstroom)
- Afhankelijkheidsdiagram softwarecomponenten
- Documentatie SDL-proces (methodologie dreigingsmodellering, secure coding-standaarden)
- SBOM in CycloneDX- of SPDX-formaat (minimaal alle top-level-afhankelijkheden dekkend)
- CVD-beleidsdocument (openbaar toegankelijke URL)
- Centraal contactpunt (beveiligings-e-mail, `security.txt`-URL)
- Beschrijving updatemechanisme (ondertekeningsinfrastructuur, beveiliging distributiekanaal, rollbackbescherming)
- Documentatie productie-/CI-CD-proces (build-integriteit, reproduceerbaarheid)
- Beschrijving proces monitoring na het in de handel brengen

**Element 3 — Cyberbeveiligingsrisicobeoordeling (Bijlage VII §3)**

Wettelijke vereiste:
> *"een beoordeling van de cyberbeveiligingsrisico''s waartegen het product met digitale elementen wordt ontworpen, ontwikkeld, geproduceerd, geleverd en onderhouden krachtens Artikel 13, met inbegrip van hoe de essentiële cyberbeveiligingsvereisten uit Deel I van Bijlage I van toepassing zijn"*

Bewijsitems:
- Volledig risicobeoordelingsdocument (zie bouwsteen in Deel II, Stap 2)
- Bepaling toepasselijkheid Bijlage I Deel I (alle 13 vereisten behandeld; niet-toepasselijke gedocumenteerd met onderbouwing volgens Artikel 13(4))
- Bepaling toepasselijkheid Bijlage I Deel II (alle 8 kwetsbaarhedenbeheer-vereisten)
- Dreigingsmodel (STRIDE, PASTA, LINDDUN of gelijkwaardig)

**Element 4 — Bepaling ondersteuningsperiode (Bijlage VII §4)**

Wettelijke vereiste:
> *"relevante informatie die in aanmerking is genomen om de ondersteuningsperiode krachtens Artikel 13(8) van het product met digitale elementen te bepalen"*

Bewijsitems:
- Onderbouwingsdocument ondersteuningsperiode
- Analyse verwachte nuttige levensduur (marktonderzoek, gebruikersenquêtes, normen productdomein)
- Verklaring einddatum ondersteuningsperiode (minimaal: 5 jaar vanaf het in de handel brengen, tenzij korter onderbouwd)
- Ondersteuningsperiode gecommuniceerd op het punt van aankoop (bewijs van label of webpagina)

**Element 5 — Normen en technische specificaties (Bijlage VII §5)**

Wettelijke vereiste:
> *"een lijst van de geheel of gedeeltelijk toegepaste geharmoniseerde normen waarvan de referenties zijn bekendgemaakt in het Publicatieblad van de Europese Unie, gemeenschappelijke specificaties... en, wanneer die geharmoniseerde normen, gemeenschappelijke specificaties of Europese cyberbeveiligingscertificeringsschema''s niet zijn toegepast, beschrijvingen van de oplossingen die zijn aangenomen om te voldoen aan de essentiële cyberbeveiligingsvereisten uit Delen I en II van Bijlage I, met inbegrip van een lijst van andere toegepaste relevante technische specificaties. Bij gedeeltelijk toegepaste geharmoniseerde normen, gemeenschappelijke specificaties of Europese cyberbeveiligingscertificeringsschema''s specificeert de technische documentatie de delen die zijn toegepast"*

Bewijsitems:
- Normentabel: voor elke aangehaalde geharmoniseerde norm het normnummer, de titel, de PBEU-publicatiedatum en welke vereisten van Bijlage I deze dekt
- Waar geen geharmoniseerde norm bestaat: afbeeldingstabel vereisten-naar-oplossingen (elke vereiste van Bijlage I afgebeeld op de specifieke geïmplementeerde technische maatregel, met bewijsverwijzing)
- Andere relevante technische specificaties (bv. IEC 62443-4-2:2019 als niet-geharmoniseerde technische referentie, NIST SP 800-82, ISO/IEC 27001)
- Gedeeltelijk toegepaste normen: tabel van welke clausules zijn toegepast en welke uitgesloten, met onderbouwing

**Element 6 — Testrapporten (Bijlage VII §6)**

Wettelijke vereiste:
> *"rapporten van de uitgevoerde tests om de conformiteit van het product met digitale elementen en van de processen voor kwetsbaarhedenbeheer met de toepasselijke essentiële cyberbeveiligingsvereisten uit Delen I en II van Bijlage I te verifiëren"*

Bewijsitems:
- Penetratietestrapport (samengevat; moet alle relevante beveiligingseigenschappen van Bijlage I op de juiste diepte voor de productrisicoklasse dekken)
- Rapport statische applicatiebeveiligingstest (SAST)
- Rapport dynamische applicatiebeveiligingstest (DAST) (waar van toepassing)
- Rapport kwetsbaarheidsscan afhankelijkheden (Trivy, Grype of gelijkwaardig — gescand tegen huidige SBOM)
- Rapport beoordeling veilige configuratie
- Testbewijs integriteit updatemechanisme (ondertekeningsverificatie, rollbacktest)
- Testresultaten authenticatie en toegangscontrole
- Test-/proefdraaibewijs proces kwetsbaarhedenbeheer

**Element 7 — EU-conformiteitsverklaring (Bijlage VII §7)**

Wettelijke vereiste: *"een kopie van de EU-conformiteitsverklaring"*

Bewijsitems: Ondertekende kopie van de volledige conformiteitsverklaring volgens Bijlage V (zie Deel VII hieronder).

**Element 8 — SBOM (Bijlage VII §8)**

Wettelijke vereiste:
> *"waar van toepassing, de software bill of materials, na een met redenen omkleed verzoek van een markttoezichtautoriteit, mits dit noodzakelijk is om die autoriteit in staat te stellen de conformiteit met de essentiële cyberbeveiligingsvereisten uit Bijlage I te controleren"*

Opmerking: Element 8 wordt standaard niet proactief openbaar bekendgemaakt — het wordt op met redenen omkleed verzoek aan markttoezichtautoriteiten verstrekt. De SBOM moet echter bestaan en actueel zijn als onderdeel van het technisch dossier. In de praktijk zal de AI voor Module B+C en H de SBOM opvragen als onderdeel van het onderzoek.

### 6.3 Versiebeheer en bewaring technisch dossier

- Voorzie het technisch dossier van een versie met een duidelijk wijzigingslogboek
- Bewaar **10 jaar** vanaf de datum van het eerste in de handel brengen in de EU **of** de einddatum van de ondersteuningsperiode, welke van beide het langst is
- Het technisch dossier moet binnen een redelijke termijn na een met redenen omkleed verzoek beschikbaar zijn voor markttoezichtautoriteiten — plan voor terugvinding binnen 24–48 uur
- Wanneer producten worden bijgewerkt, werk het technisch dossier bij vóór CE-markering van de nieuwe versie

*Bouwsteen: structuur technisch dossier*
```
STRUCTUUR TECHNISCH DOSSIER — CRA VERORDENING (EU) 2024/2847

Product: [Naam]          Model: [Model]       Versie: [HW/SW]
Dossierref: TF-[Code]-[Jaar]-[Rev]   Datum: [JJJJ-MM-DD]
Opgesteld door: [Naam, Functie]   Getoetst door: [Naam, Functie]

DEEL 1 — PRODUCTOVERZICHT (Bijlage VII §1)
  1.1 Productbeschrijving en beoogd doel
  1.2 Versiematrix (HW × SW-versies in scope)
  1.3 Hardwarefoto''s en opbouwdiagrammen
  1.4 Gebruikersinformatie Bijlage II (kopie)

DEEL 2 — ONTWERP EN ONTWIKKELING (Bijlage VII §2)
  2.1 Systeemarchitectuurdiagram
  2.2 Architectuur softwarecomponenten en afhankelijkheidsdiagram
  2.3 Gegevensstroomdiagrammen (DFD''s)
  2.4 Documentatie SDL-proces
  2.5 SBOM — [product-vX.Y.Z.cdx.json / spdx.xml]
  2.6 CVD-beleid (huidige versie + URL)
  2.7 Bewijs centraal contactpunt
  2.8 Beschrijving beveiliging updatemechanisme
  2.9 Documentatie CI/CD en build-integriteit

DEEL 3 — CYBERBEVEILIGINGSRISICOBEOORDELING (Bijlage VII §3)
  3.1 Dreigingsmodel (STRIDE / PASTA / anders)
  3.2 Risicobeoordelingsrapport [RA-versie-datum.pdf]
  3.3 Toepasselijkheidsmatrix Bijlage I Deel I
  3.4 Toepasselijkheidsmatrix Bijlage I Deel II
  3.5 Onderbouwingen niet-toepasselijkheid (Artikel 13(4))

DEEL 4 — DOCUMENTATIE ONDERSTEUNINGSPERIODE (Bijlage VII §4)
  4.1 Onderbouwing ondersteuningsperiode
  4.2 Analyse verwachte nuttige levensduur
  4.3 Verklaring einddatum ondersteuningsperiode
  4.4 Bewijs communicatie op punt van aankoop

DEEL 5 — NORMEN EN SPECIFICATIES (Bijlage VII §5)
  5.1 Tabel toegepaste geharmoniseerde normen
  5.2 Afbeelding vereisten-naar-oplossingen (waar geen hEN)
  5.3 Andere technische specificaties waarnaar verwezen
  5.4 Verklaringen gedeeltelijke toepassing

DEEL 6 — TESTRAPPORTEN (Bijlage VII §6)
  6.1 Penetratietestrapport [pentest-vX.Y.pdf]
  6.2 Samenvatting SAST/DAST-resultaten
  6.3 Rapport kwetsbaarheidsscan afhankelijkheden [scan-JJJJ-MM-DD.pdf]
  6.4 Beoordeling veilige configuratie
  6.5 Testbewijs integriteit updatemechanisme
  6.6 Testresultaten authenticatie / toegangscontrole
  6.7 Proefdraaibewijs kwetsbaarhedenbeheerproces

DEEL 7 — CONFORMITEITSVERKLARING (Bijlage VII §7)
  7.1 Ondertekende EU-conformiteitsverklaring [DoC-[code]-[datum].pdf]

DEEL 8 — SBOM (Bijlage VII §8)
  8.1 SBOM-bestand [product-vX.Y.Z.cdx.json]
  [TOEGANG: Alleen op verzoek beschikbaar voor markttoezichtautoriteiten]

BIJLAGEN
  A: EU-typeonderzoekscertificaat AI (Module B+C) of goedkeuringscertificaat AI (Module H)
  B: EUCC-certificaat (indien van toepassing)
  C: Kwetsbaarhedenlog (live register, beperkte toegang)
  D: Incidentenlog (live register, beperkte toegang)
  E: Wijzigingslogboek documenten
```

***

## Deel VII — EU-conformiteitsverklaring (Bijlage V): volledige vereisten

### 7.1 Wettelijke grondslag

De EU-conformiteitsverklaring (DoC) is vereist krachtens **Artikel 28** en gestructureerd door **Bijlage V**. Het is de formele juridische verklaring van de fabrikant over de conformiteit van het product. Het is het sluitstukdocument van de conformiteitsbeoordeling — het kan niet worden ondertekend voordat de beoordeling is voltooid.

### 7.2 Verplichte elementen — Bijlage V

De volgende acht elementen zijn verplicht in elke CRA-conformiteitsverklaring:

| # | Element | Wettelijke grondslag | Detail |
|---|---|---|---|
| 1 | **Productnaam en type** | Bijlage V §1 | Productnaam, model-/typeaanduiding en voldoende aanvullende informatie om het product uniek te identificeren — kan de scope van batch-/serienummers, HW- en SW-versie-identifiers en waar passend een foto voor traceerbaarheid omvatten |
| 2 | **Identificatie fabrikant** | Bijlage V §2 | Volledige wettelijke naam en geregistreerd postadres van de fabrikant; voor niet-EU-fabrikanten ook naam en adres van de gemachtigde vertegenwoordiger in de EU |
| 3 | **Verklaring uitsluitende verantwoordelijkheid** | Bijlage V §3 | Letterlijk: *"Deze conformiteitsverklaring wordt afgegeven onder de uitsluitende verantwoordelijkheid van de fabrikant."* — Deze exacte formulering is wettelijk vereist |
| 4 | **Voorwerp van de verklaring** | Bijlage V §4 | Identificatie van het product die traceerbaarheid mogelijk maakt; waar nuttig, een korte beschrijving van het beoogde doel van het product |
| 5 | **Conformiteitsverklaring** | Bijlage V §5 | *"Het hierboven beschreven voorwerp van de verklaring is in overeenstemming met de relevante harmonisatiewetgeving van de Unie: Verordening (EU) 2024/2847 van het Europees Parlement en de Raad van 23 oktober 2024 inzake horizontale cyberbeveiligingsvereisten voor producten met digitale elementen."* Neem eventuele andere toepasselijke EU-wetgeving op (RED, MDR, Machineverordening enz.) als een gecombineerde verklaring wordt afgegeven |
| 6 | **Toegepaste normen en specificaties** | Bijlage V §6 | Lijst van geharmoniseerde normen (met PBEU-publicatiedatum), gemeenschappelijke specificaties of toegepaste Europese cyberbeveiligingscertificeringsschema''s; indien geen geharmoniseerde norm toegepast, vermeld: *"Geen geharmoniseerde normen toegepast. Conformiteit aangetoond via [beschrijving aanpak]"* |
| 7 | **Verwijzing aangemelde instantie** | Bijlage V §7 | Alleen vereist wanneer een aangemelde instantie betrokken was: naam AI, NANDO-nummer, beschrijving van de uitgevoerde conformiteitsbeoordelingsprocedure, referentienummer EU-typeonderzoekscertificaat (Module B+C) of referentie certificaat goedkeuring kwaliteitssysteem (Module H) |
| 8 | **Ondertekeningsblok** | Bijlage V §8 | Plaats en datum van afgifte; naam en functie van de gemachtigde ondertekenaar; handgeschreven of gekwalificeerde elektronische handtekening |

### 7.3 Aanbevolen aanvullende informatie

De volgende zijn niet verplicht in Bijlage V, maar worden sterk aanbevolen door compliancepraktijkmensen en toezichthouders:

| Optioneel veld | Onderbouwing |
|---|---|
| Verklaringsnummer (bv. `DoC-SSP3000-2027-001`) | Versiebeheer en kruisverwijzing in het technisch dossier |
| Einddatum ondersteuningsperiode (maand/jaar) | CRA Artikel 13(8) vereist communicatie op het punt van aankoop; opname in de verklaring ondersteunt het aantonen van conformiteit |
| Contact voor melding kwetsbaarheden / CVD-beleid-URL | Ondersteunt verplichtingen uit Artikel 13(17) |
| Link naar volledige technische documentatie | Vergemakkelijkt toegang voor markttoezichtautoriteiten |
| Datum eerste in de handel brengen in EU | Start de 10-jarige bewaartermijn |

### 7.4 Volledig conformiteitsverklaringssjabloon

```
─────────────────────────────────────────────────────────────────
                EU-CONFORMITEITSVERKLARING
        Verordening (EU) 2024/2847 (Cyberweerbaarheidsverordening)
─────────────────────────────────────────────────────────────────
VERKLARINGSNUMMER: DoC-[Productcode]-[JJJJ]-[Volgnr]

1. PRODUCTIDENTIFICATIE
   Productnaam:       [Volledige productnaam]
   Model / type:      [Modelaanduiding]
   Hardwareversie:    [HW-vX.Y] (indien van toepassing)
   Softwareversie:    [SW-vX.Y.Z] (indien firmware/software)
   Batch / serie:     [Batchbereik of serienummerformaat]
   Beschrijving:      [Eén zin: producttype, connectiviteit,
                       beoogde gebruiksomgeving]

2. FABRIKANT
   Wettelijke naam: [Geregistreerde bedrijfsnaam]
   Adres:           [Straat, Plaats, Postcode, Land]
   Website:         [https://www.bedrijf.com]
   E-mail:          [legal@bedrijf.com]

   [Indien niet-EU-fabrikant, voeg toe:]
   Gemachtigde vertegenwoordiger in de EU:
   Wettelijke naam: [Naam bedrijf EU-vertegenwoordiger]
   Adres:           [EU-adres]

3. UITSLUITENDE VERANTWOORDELIJKHEID
   Deze conformiteitsverklaring wordt afgegeven onder de
   uitsluitende verantwoordelijkheid van de fabrikant.

4. VOORWERP VAN DE VERKLARING
   Het in Sectie 1 hierboven geïdentificeerde product is het
   voorwerp van deze verklaring.

5. CONFORMITEITSVERKLARING
   Het hierboven beschreven voorwerp van de verklaring is in
   overeenstemming met de relevante harmonisatiewetgeving van de Unie:

   ■ Verordening (EU) 2024/2847 van het Europees Parlement en
     de Raad van 23 oktober 2024 inzake horizontale
     cyberbeveiligingsvereisten voor producten met digitale
     elementen (Cyberweerbaarheidsverordening).

   [Voeg andere toepasselijke verordeningen toe indien van toepassing, bv.:]
   □ Richtlijn 2014/53/EU (Radioapparatuurrichtlijn — RED)
   □ Verordening (EU) 2017/745 (Verordening medische hulpmiddelen — MDR)
   □ Richtlijn 2006/42/EG (Machinerichtlijn)

6. TOEGEPASTE GEHARMONISEERDE NORMEN EN TECHNISCHE SPECIFICATIES
   [Indien geharmoniseerde CRA-norm beschikbaar en toegepast:]
   ■ [EN XXXXX:JJJJ] — [Normtitel] — Bekendgemaakt in PBEU
     [datum], dekt vereisten Bijlage I Deel I/II [(lijst)]

   [Indien geen geharmoniseerde CRA-norm beschikbaar (huidige situatie):]
   Geen geharmoniseerde CRA-normen bekendgemaakt in het
   Publicatieblad van de Europese Unie zijn toegepast. Conformiteit
   met Verordening (EU) 2024/2847 Bijlage I is aangetoond via de
   volgende technische specificaties en maatregelen:

   Andere toegepaste technische specificaties:
   ■ IEC 62443-4-2:2019 — Technische beveiligingsvereisten voor
     IACS-componenten (toegepast als technische referentie, niet
     als geharmoniseerde norm)
   ■ ISO/IEC 27001:2022 — Informatiebeveiligingsbeheer
   ■ [Andere normen indien van toepassing]

   Zie technische documentatie ref. [TF-code-datum] voor de
   volledige afbeelding vereisten-naar-oplossingen van Bijlage I.

7. CONFORMITEITSBEOORDELINGSPROCEDURE EN AANGEMELDE INSTANTIE
   [Module A — Geen aangemelde instantie:]
   Conformiteitsbeoordelingsprocedure: interne controle
   (Module A, Bijlage VIII Deel I van Verordening (EU) 2024/2847).
   Er was geen aangemelde instantie bij deze beoordeling betrokken.

   [Module B+C — Aangemelde instantie betrokken:]
   Conformiteitsbeoordelingsprocedure: EU-typeonderzoek
   (Module B) gevolgd door conformiteit met het type op basis van
   interne productiecontrole (Module C), Bijlage VIII Delen II en III
   van Verordening (EU) 2024/2847.
   Aangemelde instantie: [Wettelijke naam AI]
   NANDO-nummer: [####]
   Nr. EU-typeonderzoekscertificaat: [Certificaatref]
   Datum certificaat: [JJJJ-MM-DD]
   Geldigheid certificaat: [JJJJ-MM-DD]

   [Module H — Volledige kwaliteitsborging:]
   Conformiteitsbeoordelingsprocedure: conformiteit op basis van
   volledige kwaliteitsborging (Module H), Bijlage VIII Deel IV van
   Verordening (EU) 2024/2847.
   Aangemelde instantie: [Wettelijke naam AI]
   NANDO-nummer: [####]
   Nr. certificaat goedkeuring kwaliteitssysteem: [Certificaatref]

   [EUCC-certificering:]
   Europese cyberbeveiligingscertificering:
   Schema: EU-cyberbeveiligingscertificeringsschema op basis van
   Common Criteria (EUCC), krachtens Verordening (EU) 2019/881.
   Assurantieniveau: [Substantieel / Hoog]
   Nr. certificaat: [Certificaatref]
   Afgevende instantie: [Naam NCCA]
   Geldigheid certificaat: [JJJJ-MM-DD]

8. AANVULLENDE INFORMATIE (AANBEVOLEN)
   Verklaringsnummer:    DoC-[code]-[JJJJ]-[volgnr]
   Beveiligingsondersteuning tot: [Maand JJJJ] (minimaal 5 jaar vanaf
                          eerste in de handel brengen in EU)
   Eerste in de handel brengen in EU: [JJJJ-MM-DD]
   Melding kwetsbaarheden: security@bedrijf.com
   CVD-beleid:           https://bedrijf.com/security
   Technische documentatie: Beschikbaar voor bevoegde autoriteiten
                          op met redenen omkleed verzoek op bovenstaand adres.

─────────────────────────────────────────────────────────────────
   Ondertekend voor en namens [Wettelijke bedrijfsnaam]:

   Plaats: [Plaats, Land]
   Datum:  [DD Maand JJJJ]

   Naam:       [Volledige naam]
   Functie:    [Titel, bv. Hoofd Productcompliance /
                Chief Technology Officer / Directeur Engineering]
   Handtekening: ___________________________________
                [Handgeschreven of gekwalificeerde elektronische handtekening]
─────────────────────────────────────────────────────────────────
```

### 7.5 Beheerverplichtingen conformiteitsverklaring

- De verklaring moet worden **vertaald** in de officiële taal (of talen) van elke EU-lidstaat waar het product wordt verkocht
- Een **vereenvoudigde verklaring** (Bijlage VI) mag met het product worden meegeleverd en bevat alleen het internetadres waar de volledige verklaring toegankelijk is; de volledige verklaring moet gedurende de bewaartermijn daadwerkelijk op die URL toegankelijk zijn
- De verklaring moet worden **bijgewerkt** wanneer:
  - Een substantiële wijziging plaatsvindt
  - Productversies aan de scope worden toegevoegd
  - Een nieuwe conformiteitsbeoordelingsprocedure is voltooid
  - Nieuwe geharmoniseerde normen worden toegepast
- De verklaring moet **10 jaar** worden bewaard vanaf de datum van het in de handel brengen, of gedurende de ondersteuningsperiode, welke van beide het langst is
- De ondertekende verklaring moet het product vergezellen (of toegankelijk zijn via de URL van de vereenvoudigde verklaring)

***

## Deel VIII — De capaciteitscrisis van aangemelde instanties: praktische richtlijnen

### 8.1 De omvang van het probleem

Het stelsel van aangemelde instanties onder de CRA kampt met een structureel capaciteitsprobleem waarmee fabrikanten in hun planning rekening moeten houden:

- **Aanwijzingsvertraging:** Accreditatie en aanwijzing van een nieuwe AI duurt doorgaans 12–18 maanden vanaf de aanvraag
- **Geen aangewezen instanties per juni 2026:** De regels voor aangemelde instanties van de CRA werden op 11 juni 2026 van toepassing, maar op diezelfde datum was er geen enkele CRA-aangemelde instantie formeel aangewezen
- **Vraagconcentratie:** Belangrijk Klasse I (zonder geharmoniseerde norm) + Belangrijk Klasse II + Kritieke producten vereisen allemaal betrokkenheid van een AI — wat neerkomt op duizenden producttypen in de hele EU
- **Tijdlijnconcentratie:** De volledige CRA-toepassing is 11 december 2027 — alle fabrikanten die AI-beoordeling nodig hebben, moeten deze binnen ongeveer 18 maanden na het verschijnen van de eerste aanwijzingen voltooien

> *"Accreditatie en aanwijzing van nieuwe instanties duurt doorgaans 12 tot 18 maanden, wat betekent dat de pool van CRA-aangemelde instanties tot ver in 2027 klein zal blijven."*

### 8.2 Praktische mitigatiestrategieën

**Strategie 1 — Betrek kandidaat-instanties vroeg**

Verschillende bestaande conformiteitsbeoordelingsinstanties die actief zijn onder RED, MDR en andere CE-markeringskaders hebben CRA-gereedheidsprogramma''s aangekondigd. Neem nu contact met hen op voor:
- Scopinggesprekken (kosteloos) om hun waarschijnlijke CRA-scope en -capaciteit te beoordelen
- Voorlopige indieningen om hiaten in de technische documentatie te identificeren vóór formele betrokkenheid
- Wachtrijregistratie (informeel, niet bindend, maar legt de relatie vast)

Organisaties waarvan bekend is dat zij CRA-capaciteit als aangemelde instantie voorbereiden zijn onder meer: Applus+ Laboratories, TÜV Rheinland, TÜV SÜD, BSI Group (VK, actief ook in de EU), SGS, Bureau Veritas en NMi (Nederland).

**Strategie 2 — Voltooi alle technische documentatie vóór betrokkenheid**

De honoraria en tijdlijnen van AI''s worden gedreven door de hoeveelheid herstelwerk voor tekortkomingen. Een fabrikant die een volledig, hoogwaardig technisch dossier indient, voltooit de beoordeling sneller en tegen lagere kosten dan een die het AI-proces gebruikt om hiaten te ontdekken.

**Strategie 3 — Overweeg EUCC als CC-certificering al gepland is**

Voor organisaties met producten die al een Common Criteria-evaluatie ondergaan of daarvoor gepland staan, is het EUCC-traject de meest efficiënte route naar een CRA-vermoeden van conformiteit — hetzelfde evaluatieproces dat het CC/EUCC-certificaat oplevert, adresseert tegelijk de CRA-conformiteit.

**Strategie 4 — Overweeg Module H als het productportfolio breed is**

Voor fabrikanten met vijf of meer Belangrijk Klasse II-producten is Module H vrijwel zeker economischer dan herhaalde Module B+C-beoordelingen. De eenmalige QMS-investering verdient zich snel terug wanneer nieuwe producten via uitbreidingsbeoordelingen aan de goedgekeurde QMS-scope kunnen worden toegevoegd in plaats van een volledig heronderzoek.

**Strategie 5 — Wacht niet op geharmoniseerde normen voor Klasse I**

Voor Belangrijk Klasse I-producten is de verleiding om te wachten tot geharmoniseerde normen zijn bekendgemaakt (verwacht Q2 2027) om Module A-zelfbeoordeling te gebruiken. Dit is een strategie met hoog risico: als normen vertraging oplopen, of als de norm niet volledig de specifieke vereisten van het product dekt, staat de fabrikant voor de achterstand bij aangemelde instanties in de laatste maanden vóór december 2027.

### 8.3 Gereedheidscontrolelijst betrokkenheid aangemelde instantie

```
GEREEDHEIDSCONTROLELIJST BETROKKENHEID AANGEMELDE INSTANTIE
Product: [Naam, Versie]          Classificatie: [Belangrijk Klasse I/II / Kritiek]
Doeldatum CE: [JJJJ-MM-DD]       Module: [B+C / H / EUCC]
---------------------------------------------------------------------------
VOORBEREIDING (Voltooien vóór eerste AI-contact)
  □ Productclassificatie bevestigd en gedocumenteerd (CBV voltooid)
  □ Toepasselijkheidsmatrix Bijlage I opgesteld (identificeert welke vereisten gelden)
  □ Cyberbeveiligingsrisicobeoordeling minimaal in conceptfase
  □ Systeemarchitectuurdiagram beschikbaar
  □ SBOM gegenereerd voor huidige versie
  □ CVD-beleid opgesteld en gepubliceerd (of URL voorbereid)
  □ Pre-release kwetsbaarheidsscan uitgevoerd
  □ SDL-proces gedocumenteerd
  □ Ondersteuningsperiode bepaald en onderbouwing gedocumenteerd
  □ Structuur technisch dossier aangemaakt (ook als nog niet al het bewijs compleet is)

START BETROKKENHEID (Bij eerste AI-contact)
  □ NANDO geverifieerd als CRA-dekkend (of bevestigd als in voorbereiding op aanwijzing)
  □ Scopinggesprek voltooid; domeincompetentie AI beoordeeld
  □ Voorlopige bewijstoetsing overeengekomen (bureautoetsing vóór formele aanvraag)
  □ Tijdlijn besproken; geschatte certificaatdatum bevestigd t.o.v. doeldatum CE
  □ Kostenraming verkregen

INDIENING AANVRAAG
  □ Volledige technische documentatie Bijlage VII verpakt en gecontroleerd
  □ Representatief productmonster of testtoegang geregeld
  □ AI-aanvraagformulier ingevuld
  □ Concept-conformiteitsverklaring opgesteld (niet ondertekend)
  □ Aanvraag ingediend; intakebevestiging ontvangen

BEOORDELINGSFASE
  □ Toetsingsrapport technische documentatie ontvangen
  □ Non-conformiteiten gelogd en hersteleigenaar toegewezen
  □ Alle non-conformiteiten opgelost; bewijs van oplossing ingediend
  □ Productonderzoek voltooid
  □ Afgifte certificaat bevestigd

NA CERTIFICAAT
  □ EU-typeonderzoekscertificaat ontvangen en opgeslagen in technisch dossier
  □ Conformiteitsverklaring ondertekend door gemachtigde ondertekenaar
  □ CE-markering aangebracht op product/verpakking/documentatie
  □ Toezichtsschema bevestigd met AI
  □ Technische documentatie bijgewerkt met certificaatverwijzing
```

***

## Deel IX — Regels voor CE-markering en veelgemaakte fouten

### 9.1 Toepassingsvereisten CE-markering

**Artikel 30** regelt de CE-markering. De CE-markering moet:
- **Zichtbaar:** Duidelijk zichtbaar op het product, de verpakking of de begeleidende documentatie
- **Leesbaar:** Evenredig met de grootte van het product; minimumhoogte 5 mm waar de productgrootte dat toelaat
- **Onuitwisbaar:** Niet gemakkelijk te verwijderen of los te maken; voor fysieke producten permanent aangebracht (gegraveerd, gedrukt of gelabeld met knoeibestendigheid)
- **Vergezeld van het AI-nummer:** Waar Module B+C of H is gebruikt, moet de CE-markering worden gevolgd door het NANDO-nummer van de AI (4 cijfers)

**Voor uitsluitend softwareproducten:**
- De CE-markering mag worden opgenomen in de begeleidende digitale documentatie, op de downloadpagina van het product of in de conformiteitsverklaring
- Deze hoeft niet in de gebruikersinterface van de software te verschijnen, hoewel dit gangbare praktijk is

**Timing:** De CE-markering mag pas worden aangebracht **nadat** de conformiteitsbeoordeling is voltooid, de conformiteitsverklaring is opgesteld en ondertekend, en alle technische documentatie is samengesteld. Voortijdig aanbrengen van de CE-markering is een overtreding van Artikel 30 en leidt tot boetes van Niveau 2.

### 9.2 Veelgemaakte fouten om te vermijden

| Fout | Gevolg | Preventie |
|---|---|---|
| Classificeren als Standaard zonder controle van Bijlage III/IV | Ongeldige Module A-beoordeling; CE-markering ongeldig | Voer gestructureerde classificatieanalyse uit tegen Uitvoeringsverordening 2025/2392 |
| Conformiteitsverklaring ondertekenen vóór voltooiing conformiteitsbeoordeling | Juridische overtreding onder Artikel 28; verklaring juridisch ongeldig | Ondertekening verklaring is altijd de laatste stap, nadat al het bewijs bestaat |
| Conformiteitsverklaring gebruiken als vervanging voor technische documentatie | Markttoezichtautoriteit vindt geen bewijsdossier | Onderhoud een apart volledig technisch dossier; de verklaring is een samenvatting, niet het bewijs |
| Verklaring niet bijwerken na software-update die een substantiële wijziging vormt | CE-markering wordt ongeldig voor de bijgewerkte versie | Implementeer een Module C-wijzigingsclassificatiepoort voor elke release |
| Verzuim de verklaring te vertalen in de talen van de lidstaten | Non-conformiteit met markttoegangsvereisten | Identificeer alle EU-markten bij marktintroductie; plan vertalingen vooraf |
| Een verouderde SBOM gebruiken (van een andere versie) | Onnauwkeurig conformiteitsbewijs; falen kwetsbaarheidsmonitoring | Integreer SBOM-generatie in elke CI/CD-build |
| Ontbrekend AI-identificatienummer op CE-markering (Module B+C/H) | CE-markering voldoet niet aan de vereisten van Artikel 30 | Neem het NANDO-nummer direct na het CE-symbool op |
| Een URL voor een vereenvoudigde verklaring gebruiken die een dode link wordt | Overtreding — URL vereenvoudigde verklaring moet 10 jaar toegankelijk blijven | Gebruik een permanente, stabiele URL; neem op in beleid voor langetermijn-URL-beheer |
| Verzuim de technische documentatie 10 jaar te bewaren | Overtreding van Artikel 13(13); boete Niveau 2 | Implementeer levenscyclusbeheer van documenten met een bewaarbeleid van 10 jaar |

***

## Deel X — Master CE-markeringsprogramma Gantt: aanbevolen tijdlijn

De volgende programmatijdlijn geldt voor een nieuw product dat mikt op CE-markering per 11 december 2027 en Module B+C vereist (Belangrijk Klasse II):

| Maand | Activiteit | Eigenaar | Uitvoer |
|---|---|---|---|
| M1 | Productclassificatie en toepassingsgebiedbeoordeling | Compliance Lead | Classificatiebeslissingsverslag |
| M1–M2 | Start cyberbeveiligingsrisicobeoordeling; dreigingsmodellering | Security Architect | Concept-risicobeoordeling |
| M2–M3 | Afbeelding vereisten Bijlage I; identificeer hiaten | Product Security | Hiatenanalyse vereisten |
| M3–M6 | Implementatie beveiligingsmaatregelen (herstel hiaten) | Engineering | Geïmplementeerde maatregelen |
| M3–M4 | Integratie SBOM-tooling in CI/CD | DevOps / Engineering | SBOM per build |
| M4–M5 | CVD-beleid gepubliceerd; centraal contactpunt live | Legal / Security | CVD-beleid-URL |
| M4–M5 | Beslissing ondersteuningsperiode; communicatie punt van aankoop voorbereid | Product / Legal | Documentatie ondersteuningsperiode |
| M5–M6 | Interne beveiligingstests (pentest, SAST/DAST, kwetsbaarheidsscan) | Security Testing | Testrapporten |
| M5–M6 | Technische documentatie Deel 1–5 samengesteld | Compliance Lead | Concept technisch dossier |
| M6 | Aangemelde instantie geïdentificeerd; scopinggesprek; wachtrijregistratie | Compliance Lead | Shortlist AI |
| M7 | Voorlopige bewijstoetsing met AI | AI + Fabrikant | Hiaten geïdentificeerd |
| M7–M8 | Herstel opmerkingen AI vóór indiening | Engineering | Herstelbewijs |
| M8 | Formele indiening aanvraag bij AI | Compliance Lead | Aanvraag ingediend |
| M8–M9 | Toetsing technische documentatie AI | AI | Toetsingsrapport |
| M9 | Herstel bevindingen documentatie AI (indien aanwezig) | Engineering/Compliance | Bijgewerkt technisch dossier |
| M9–M10 | Productonderzoek en tests AI | AI | Onderzoeksrapport |
| M10 | EU-typeonderzoekscertificaat afgegeven | AI | Certificaat |
| M10–M11 | Conformiteitsverklaring opgesteld, juridisch getoetst, ondertekend | Legal + Compliance + CTO/CEO | Ondertekende verklaring |
| M11 | CE-markering aangebracht op product/documentatie | Product/Design | CE-gemarkeerd product |
| M11–M12 | Buffer voor onverwachte vertragingen | — | — |
| **M12** | **Product op EU-markt aangeboden; volledig CRA-conform** | Management | **CE-gemarkeerd product op de markt** |

Deze tijdlijn gaat uit van een **goed voorbereide organisatie** zonder grote technische hiaten. Organisaties die aanzienlijke implementatiehiaten in Bijlage I ontdekken in de maanden M3–M5 moeten 2–4 maanden voor herstel toevoegen. De vroegste haalbare start voor een deadline van december 2027 is daarom ongeveer januari–februari 2027.

---

## Referenties

1. [Step 6: Which Conformity Assessment Procedure Applies? - LinkedIn](https://www.linkedin.com/pulse/step-6-which-conformity-assessment-procedure-applies-michael-jesse-szpkf)
2. [Decoding the Cyber Resilience Act – Part 2: A lifecycle approach to compliance - Freshfields](https://www.freshfields.com/en/our-thinking/blogs/technology-quotient/decoding-the-cyber-resilience-act-part-2-a-lifecycle-approach-to-compliance-102mkdk)
3. [Cyber Resilience Act | Shaping Europe''s digital future](https://digital-strategy.ec.europa.eu/en/policies/cyber-resilience-act)
4. [CRA Compliance Matrix: Every Obligation, with Article References](https://www.cyberresilienceact.eu/compliance-matrix.html)
5. [CRA EU Declaration of Conformity: Template and Elements](https://craevidence.com/cra-compliance/declaration-of-conformity)
6. [Cyber Resilience Act - Conformity assessment](https://digital-strategy.ec.europa.eu/en/policies/cra-conformity-assessment)
7. [CRA Conformity Assessment: Self-Assessment vs Third-Party - Complaro](https://complaro.com/blog/cra-conformity-assessment-guide)
8. [Cyber-Resilience Act (CRA) - Secure-by-Design Handbook](https://www.securebydesignhandbook.com/docs/standards/eu/cra-overview)
9. [Understanding the EU Cyber Resilience Act Requirements - Finite State](https://finitestate.io/blog/conformity-assessments-eu-cra-requirements)
10. [Notified Bodies Under the CRA: When You Need One - Seentrix](https://seentrix.com/blog/cra-notified-bodies)
11. [On 11 June 2026, the CRA''s Rules on Notified Bodies Started to Apply](https://www.cyberresilienceact.eu/news/cra-notified-bodies-rules-apply-11-june-2026.html)
12. [CRA Harmonised Standards Guide — Type A, B and C](https://eu-cyber-laws.com/cra/standards-guide/)
13. [Cyber Resilience Act text, Article 13](https://www.european-cyber-resilience-act.com/Cyber_Resilience_Act_Article_13.html)
14. [CE Marking to Show CRA compliance - Qt](https://www.qt.io/cyber-resilience-act/ce-marking)
15. [Notified bodies - Internal Market, Industry, Entrepreneurship and SMEs](https://single-market-economy.ec.europa.eu/single-market/goods/building-blocks/notified-bodies_en)
16. [The CRA Deadline Is Fixed. Assessment Capacity Isn''t - NMi](https://nmi.nl/cra-assessment-capacity-lab-scarcity/)
17. [EU Cyber Resilience Act (CRA) Compliance - Applus+ Laboratories](https://www.appluslaboratories.com/global/en/resource-center/eu-cyber-resilience-act/cra-compliance-services)
18. [CRA Conformity Assessment: Self-Assessment or Notified Body](https://craevidence.com/cra-compliance/conformity-assessment)
19. [Cyber Resilience Act—Notified Body Services - Applus+ Laboratories](https://www.appluslaboratories.com/global/en/what-we-do/service-sheet/cyber-resilience-act-notified-body)
20. [EU Cyber Resilience Act: What Product Teams Should Do Now](https://www.linkedin.com/pulse/eu-cyber-resilience-act-what-product-teams-should-do-now-leitner-ll66f)
21. [What is module H? How does it work? - CRA FAQ](https://cra.orcwg.org/faq/official/faq_6-3/)
22. [Cyber Resilience Act: The Complete Survival Guide for Manufacturers - CCLab](https://www.cclab.com/news/cyber-resilience-act-the-complete-survival-guide-for-manufacturers)
23. [Cyber Resilience Act implementation via EUCC - ENISA](https://certification.enisa.europa.eu/publications/cyber-resilience-act-implementation-eucc-and-its-applicable-technical-elements_en)
24. [EU Cybersecurity Certification Scheme on Common Criteria (EUCC) - Brightsight](https://www.brightsight.com/eucc)
25. [EUCC, differences with CCRA/SOGIS Common Criteria scheme (PDF)](https://www.appluslaboratories.com/en/dam/jcr:d65e3db0-9f1f-4fd0-a0f5-1266877db673/EUCC_vs_CCRA_SOGIS.pdf)
26. [Mapping EUCC to Common Criteria - QIMA](https://blog.qima.com/due-cybersecurity/mapping-eucc-to-common-criteria-a-technical-overview-of-assurance-levels-and-evaluation-requirements)
27. [Common Criteria (EUCC) | Dutch NCCA](https://www.dutchncca.nl/eu-cybersecurity-certification/common-criteria)
28. [Annex VII Cyber Resilience Act – Content of the Technical Documentation - Enobyte](https://enobyte.com/en/legal/cra/annex-vii/)
29. [CRA Standards Unlocked - CEN-CENELEC (PDF)](https://www.cencenelec.eu/media/CEN-CENELEC/Events/Webinars/2026/2026-03-18_cra_unlocked_cybersecurity_requirements_deep-dive_tc224wg17_cra.pdf)
30. [CRA Annex V: EU Declaration of Conformity Template - CVD Portal](https://cvdportal.com/cra/annex-v)
31. [CRA Declaration of Conformity (DoC) Guide - Regulus](https://goregulus.com/cra-documentation/cra-declaration-of-conformity/)
32. [Op 11 juni 2026 werden de CRA-regels inzake aangemelde instanties van toepassing](https://www.cyberresilienceact.eu/nl/news/cra-notified-bodies-rules-apply-11-june-2026.html)
33. [No Market Approval Without Cybersecurity: Implementing the CRA - Onekey](https://www.onekey.com/resource/no-market-approval-without-cybersecurity-how-companies-can-successfully-implement-the-cra)
34. [CE Marking for Software Under the CRA: Step-by-Step - Complaro](https://complaro.com/blog/cra-ce-marking-software)
35. [When Is Software "Placed on the Market" Under the EU Cyber Resilience Act](https://www.cybercertlabs.com/case_studies/software-placed-on-market-eu-cyber-resilience-act/)
36. [Understanding The EU CRA''s SBOM & Technical Documentation Requirements - Finite State](https://finitestate.io/blog/eu-cra-sbom-technical-documentation-guide)

---

_Verwant: [Cyberweerbaarheidsverordening overzicht](/nl/cra) · [CRA CE-markeringstrajecten](/nl/cra-ce-marking-pathways) · [CRA volledig technisch naslagwerk](/nl/cra-technical-reference) · [IEC 62443](/nl/iec-62443) · [NIS2](/nl/nis2)_
', true, 'CRA CE-markeringstrajecten: conformiteitsbeoordeling naslagwerk | OXOT', 'Hoe u een product met digitale elementen CE-markeert onder de Cyberweerbaarheidsverordening: Module A zelfbeoordeling, Module B+C EU-typeonderzoek, Module H volledige kwaliteitsborging, de EUCC-route, betrokkenheid van aangemelde instanties, het technisch dossier van Bijlage VII en de EU-conformiteitsverklaring van Bijlage V — met sjablonen en tijdlijnen.', 'Een diepgaand naslagwerk voor de praktijk over CRA-conformiteitsbeoordeling: Modules A / B+C / H, de EUCC-certificeringsroute, betrokkenheid van aangemelde instanties, het technisch dossier van Bijlage VII en de EU-conformiteitsverklaring van Bijlage V, met sjablonen en aanbevolen tijdlijnen.', NULL, 'article', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();
