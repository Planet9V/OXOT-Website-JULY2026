---
title: "CRA — Volledige technische referentie"
meta_title: "Cyber Resilience Act — Volledige technische referentie (Verord. (EU) 2024/2847) | OXOT"
meta_description: "Een volledige technische referentie voor de EU Cyber Resilience Act (Verordening (EU) 2024/2847): reikwijdte en uitzonderingen, de drieledige productclassificatie, alle essentiële eisen van bijlage I, conformiteitsbeoordelingsmodules, alle acht bijlagen, sancties en de nalevingstijdlijn."
excerpt: "Diepgaande technische referentie voor Verordening (EU) 2024/2847 — structuur van de verordening (8 hoofdstukken, 71 artikelen, 8 bijlagen), productclassificatie, essentiële eisen van bijlage I, conformiteitsbeoordeling, CE-markering, sancties en het nalevingsstappenplan."
content_type: article
published: true
---

[Kaders](/nl/frameworks) › [Cyber Resilience Act](/nl/cra) › Volledige technische referentie

> **Diepgaande referentie.** Voor het overzicht in gewone taal begint u bij de [Cyber Resilience Act veldgids](/nl/cra). Voor het CE-markerings-/conformiteitsbeoordelingsproces, zie [CRA CE-markeringstrajecten](/nl/cra-ce-marking-pathways). Deze pagina brengt de volledige verordening in kaart — elk hoofdstuk, elke productklasse en elke bijlage.

***
## Managementsamenvatting
De Cyber Resilience Act (CRA), formeel Verordening (EU) 2024/2847, is de eerste horizontale cybersecurityverordening van de EU die verplichte, bindende eisen oplegt aan vrijwel alle hardware- en softwareproducten die op de EU-markt worden verkocht. Anders dan sectorspecifieke regels (NIS2, MDR, GPSR) werkt de CRA als een **productwet** — die de architectuur van de CE-markering uitbreidt naar cybersecurity — en geldt zij van de siliciumtoeleveringsketen tot en met de eindgebruiker. De verordening is op **10 december 2024** in werking getreden en is vanaf **11 december 2027** volledig van toepassing, met verplichtingen die gefaseerd eerder ingaan.

Voor OT- en kritieke-infrastructuuromgevingen is de CRA direct relevant: producten binnen de reikwijdte zijn onder meer OT-apparatuur, IoT-gateways, SCADA-componenten, slimme-metergateways, netwerkinfrastructuur en elk "product met digitale elementen" (PDE) in de toeleveringsketen van kritieke infrastructuur.

***
## Deel I: Inleiding en wetgevingscontext
### Wat de CRA is en waarom zij is ontstaan
De CRA pakt een marktfalen aan: fabrikanten hadden van oudsher weinig commerciële prikkel om in cybersecurity te investeren, en kopers hadden geen betrouwbare manier om de beveiliging van verbonden producten te beoordelen. De verordening legt basisbeveiligingsverplichtingen op bij de fabricage, niet pas na de uitrol. De kernontwerpprincipes zijn:

- **Veilig door ontwerp en veilig standaard** — producten moeten worden ontworpen, ontwikkeld en geproduceerd met ingebouwde cybersecurity
- **Beveiliging over de levenscyclus** — verplichtingen gelden voor de duur van de ondersteuningsperiode van een product, niet alleen op het verkooppunt
- **Transparantie in de toeleveringsketen** — verplichte SBOM-eisen koppelen productbeveiliging aan verantwoording op componentniveau
- **Geharmoniseerde toegang tot de eengemaakte markt** — één CE-markeringsregime vervangt een lappendeken van nationale regels
### Wetgevingsgeschiedenis
| Mijlpaal | Datum |
|-----------|------|
| Voorstel van de Commissie gepubliceerd | september 2022 |
| Goedkeuring Europees Parlement | maart 2024 |
| Aanneming door de Raad | oktober 2024 |
| Gepubliceerd in het EU-Publicatieblad | 20 november 2024 |
| Inwerkingtreding | 10 december 2024 |
| Hoofdstuk IV (aanmelding CAB's) van toepassing | 11 juni 2026 |
| Rapportageverplichtingen (art. 14) van toepassing | 11 september 2026 |
| Volledige toepasselijkheid | 11 december 2027 |
| Bestaande typeonderzoekcertificaten geldig tot | 11 juni 2028 |

De Commissie heeft al twee aanvullende handelingen vastgesteld: Gedelegeerde Verordening (EU) 2025/1535 (uitsluiting van motorvoertuigproducten) en Uitvoeringsverordening (EU) 2025/2392 (technische beschrijvingen van belangrijke/kritieke productcategorieën).

***
## Deel II: Reikwijdte
### Wat valt eronder
De CRA is van toepassing op elk **product met digitale elementen (PDE)** — gedefinieerd als "een software- of hardwareproduct en de bijbehorende oplossingen voor gegevensverwerking op afstand, met inbegrip van software- of hardwarecomponenten die afzonderlijk in de handel worden gebracht" — waarbij het beoogde doel of het redelijkerwijs te voorziene gebruik een **directe of indirecte logische of fysieke gegevensverbinding** met een apparaat of netwerk omvat.

In de praktijk vallen hieronder:
- Verbonden hardware: smartphones, laptops, slimme-huisapparatuur, industriële controllers, routers, firewalls, gateways, microprocessors, slimme meters
- Softwareproducten: besturingssystemen, applicaties, firmware, mobiele apps, games
- Gegevensverwerking op afstand die nauw met de functie van het product is verweven
- Componenten die afzonderlijk in de handel worden gebracht (bijv. een afzonderlijk verkochte microcontroller)

De bepalende test is **connectiviteit bij het beoogde normale gebruik** — niet de theoretische mogelijkheid. Een debugpoort die alleen in de fabriek wordt gebruikt, activeert de CRA niet; een voor de eindgebruiker toegankelijke USB-C-interface wel.
### Wat is uitgesloten
| Uitgesloten categorie | Reden / rechtsgrondslag |
|-------------------|----------------------|
| Niet-commerciële vrije en openbronsoftware (FOSS) | Niet "op de markt aangeboden" volgens overweging 18 |
| Producten uitsluitend voor nationale veiligheid / militair gebruik | Sectoruitzondering |
| Producten die al onder specifieke EU-sectorregelgeving vallen (medische hulpmiddelen, luchtvaart, auto-industrie) | Lex specialis |
| Producten die bij normaal gebruik niet met apparaten of netwerken zijn verbonden | Buiten de PDE-definitie |
| Producten die niet in de handel worden gebracht (intern gebruik, prototypes op beurzen) | Buiten de commerciële levering |

Openbron-**beheerders** (rechtspersonen die FOSS voor commerciële activiteiten in stand houden) hebben op grond van artikel 24 een lichter pakket verplichtingen, maar zijn niet volledig vrijgesteld.
### Verhouding tot andere EU-regelgeving
De CRA vervangt uitdrukkelijk **niet** de NIS2 (die exploitanten reguleert, geen producten), de AVG (bescherming van persoonsgegevens), de AI-verordening (eisen aan AI-systemen), de MDR/IVDR (medische hulpmiddelen) of de radioapparatuurrichtlijn (RED). Waar overlap bestaat, heeft de meer specifieke sectorregel voorrang voor die specifieke verplichtingen; de CRA-cybersecurityeisen vullen de resterende leemten op.

***
## Deel III: Structuur van de verordening — 8 hoofdstukken, 71 artikelen, 8 bijlagen
### Hoofdstukkenoverzicht
| Hoofdstuk | Artikelen | Onderwerp |
|---------|----------|---------|
| **I – Algemene bepalingen** | 1–12 | Reikwijdte, definities, productclassificatie, verhouding tot andere wetgeving |
| **II – Verplichtingen van marktdeelnemers** | 13–26 | Verplichtingen van fabrikant, importeur, distributeur, FOSS-beheerder |
| **III – Conformiteit** | 27–34 | Normen, CE-markering, conformiteitsverklaring, technische documentatie, conformiteitsbeoordeling |
| **IV – Aanmelding van CAB's** | 35–51 | Aanwijzing van aangemelde instanties, eisen, operationele regels |
| **V – Markttoezicht & handhaving** | 52–60 | Bevoegdheden markttoezichtautoriteiten, nationale/Unieprocedures, gezamenlijke acties, ADCO |
| **VI – Gedelegeerde bevoegdheden** | 61–62 | Bevoegdheid van de Commissie tot gedelegeerde/uitvoeringshandelingen |
| **VII – Vertrouwelijkheid & sancties** | 63–65 | Bescherming van informatie, geldboetes, representatieve vorderingen |
| **VIII – Overgangs- en slotbepalingen** | 66–71 | Wijzigingen, overgangsregels, evaluatie, inwerkingtreding |
### Belangrijkste artikelen in één oogopslag
| Artikel | Onderwerp | Belang |
|---------|---------|-----------|
| Art. 2 | Reikwijdte | Bepaalt welke producten en situaties eronder vallen |
| Art. 3 | Definities | "PDE", "fabrikant", "substantiële wijziging", "ondersteuningsperiode" |
| Art. 6 | Eisen voor PDE's | Toegangspoort tot de essentiële eisen van bijlage I |
| Art. 7 | Belangrijke producten | Definieert klasse I en klasse II; verwijst naar bijlage III |
| Art. 8 | Kritieke producten | Commissie kan EU-cybersecuritycertificering verplichten; verwijst naar bijlage IV |
| Art. 13 | Verplichtingen van de fabrikant | Kernartikel — risicobeoordeling, levenscyclus, SBOM, ondersteuningsperiode, CE-markering |
| Art. 14 | Rapportageverplichtingen | Termijnen van 24 u/72 u/14 dagen/30 dagen; van toepassing vanaf 11 sep. 2026 |
| Art. 32 | Conformiteitsbeoordeling | Trajecten module A / B+C / H; welke producten beoordeling door derden vereisen |
| Art. 64 | Sancties | Gedifferentieerde boetes: € 15 mln/2,5 %, € 10 mln/2 %, € 5 mln/1 % |
| Art. 69 | Overgangsbepalingen | Producten die vóór dec. 2027 reeds op de markt zijn, vallen er alleen onder bij substantiële wijziging |

***
## Deel IV: Productclassificatie
### Drieledig classificatiemodel
De CRA creëert drie productrisicoklassen:

```
┌─────────────────────────────────────────────────────┐
│  KRITIEKE producten (bijlage IV)                    │
│  Hoogste risico; Commissie kan EUCC-cert. verplichten│
├─────────────────────────────────────────────────────┤
│  BELANGRIJKE producten (bijlage III)                │
│  Klasse II – Beoordeling door derden vereist        │
│  Klasse I  – Zelfbeoordeling alleen met geharm. norm │
├─────────────────────────────────────────────────────┤
│  STANDAARDproducten (alle overige)                  │
│  ~90% van de producten; module A zelfbeoordeling    │
└─────────────────────────────────────────────────────┘
```

De classificatie is gebaseerd op de **kernfunctionaliteit** van het product, niet op de vormfactor of bijkomende kenmerken.

***
### Standaardproducten
**Definitie:** Alle PDE's die niet in bijlage III (belangrijk) of bijlage IV (kritiek) zijn opgenomen.

**Omvang:** Naar schatting valt ~90% van alle PDE's in deze klasse.

**Eisen:** Alle essentiële eisen van bijlage I gelden voor standaardproducten identiek aan hogere klassen. De classificatie verandert alleen het **traject van de conformiteitsbeoordeling**, niet de inhoud van wat moet worden bereikt.

**Conformiteitsbeoordeling:** Module A (zelfbeoordeling, zonder betrokkenheid van een aangemelde instantie).

**Voorbeelden:** Consumenten-IoT-apparatuur, de meeste commerciële software, ingebedde sensoren, smart-tv's, wearables voor consumenten die niet aan de criteria van bijlage III voldoen.

***
### Belangrijke producten – klasse I (bijlage III, deel I)
**Definitie:** Producten waarvan de exploitatie "significante nadelige gevolgen" kan hebben door hun functie of hun kritieke rol in de toeleveringsketen.

**Opties voor conformiteitsbeoordeling:**
- Module A (zelfbeoordeling) **indien** geharmoniseerde normen of gemeenschappelijke specificaties worden toegepast
- Module B+C of module H (derde partij) indien geen geharmoniseerde normen worden gebruikt
- FOSS-producten van belangrijke klasse I mogen een zelfbeoordeling uitvoeren indien de technische documentatie openbaar wordt gemaakt

**Voorbeelden van producten uit bijlage III, deel I:**

| Categorie | Voorbeelden |
|----------|---------|
| Identiteits- en toegangsbeheer | IAM-software/-hardware, biometrische lezers, authenticatielezers |
| Browsers | Zelfstandige en ingebedde browsers |
| Wachtwoordbeheerders | Alle wachtwoordbeheersoftware/-hardware |
| Anti-malware | Producten die kwaadaardige software zoeken, verwijderen of in quarantaine plaatsen |
| VPN | Producten met virtueel-privénetwerkfunctie |
| Netwerkbeheer | Netwerkbeheersystemen |
| SIEM | Systemen voor beveiligingsinformatie- en gebeurtenissenbeheer |
| Bootmanagers | Componenten voor veilig opstarten |
| PKI | Public key infrastructure, software voor uitgifte van digitale certificaten |
| Netwerkinterfaces | Fysieke en virtuele netwerkinterfaces |
| Besturingssystemen | Universele OS'en (niet reeds gedekt door hogere klassen) |
| Routers/modems/switches | Op internet gerichte routers, modems voor internetverbinding, switches |
| Beveiligingsmicroprocessors | Microprocessors met beveiligingsgerelateerde functies |
| Beveiligingsmicrocontrollers | Microcontrollers met beveiligingsgerelateerde functies |
| ASIC's / FPGA's | Met beveiligingsgerelateerde functies |
| Slimme-huisassistenten | Universele virtuele assistenten |
| Slimme-huisbeveiliging | Slimme deursloten, beveiligingscamera's, babyfoons, alarmsystemen |
| Verbonden speelgoed | IoT-speelgoed met sociale interactie of locatievolgfuncties |
| Wearables voor gezondheid | Niet onder de MDR vallende persoonlijke gezondheidsmonitoring of wearables voor kinderen |

***
### Belangrijke producten – klasse II (bijlage III, deel II)
**Definitie:** Producten met een "hoger kritiekniveau" — falen kan "veel grotere systemische effecten" hebben en kan vele andere producten verstoren, aansturen of beschadigen.

**Conformiteitsbeoordeling:** Altijd door een derde partij (module B+C of module H) of EUCC-certificering. Geen zelfbeoordelingstraject, behalve voor FOSS-producten die hun technische documentatie openbaar maken.

**Voorbeelden van producten uit bijlage III, deel II:**

| Categorie | Voorbeelden |
|----------|---------|
| Hypervisors | Hypervisors en container-runtimesystemen die gevirtualiseerde OS-uitvoering ondersteunen |
| Industriële firewalls / IDS / IPS | Firewalls, inbraakdetectie-/-preventiesystemen voor **industrieel gebruik** |
| Manipulatiebestendige microprocessors | Geharde processors van het TPM-type |
| Manipulatiebestendige microcontrollers | Secure-element-microcontrollers met manipulatiebestendigheid |

> **OT/ICS-relevantie (OXOT):** Industriële firewalls en inbraakdetectie-/-preventiesystemen die in OT-omgevingen worden gebruikt, zijn uitdrukkelijk klasse II. Elke OXOT-klant die IDS/IPS voor OT-doeleinden uitrolt (bijv. Claroty-, Dragos-, Nozomi-sensoren als product) moet als klasse II worden beoordeeld.

***
### Kritieke producten (bijlage IV)
**Definitie:** De smalste klasse met de zwaarste gevolgen. De Commissie kan bij gedelegeerde handeling **verplichte Europese cybersecuritycertificering** op zekerheidsniveau "substantieel" of hoger onder het EUCC-regime opleggen (artikel 8).

**Productlijst bijlage IV:**

| # | Categorie |
|---|---------|
| 1 | Hardwareapparaten met beveiligingsboxen (HSM's) |
| 2 | Slimme-metergateways binnen slimme-meetsystemen (conform Richtlijn (EU) 2019/944); andere apparaten voor geavanceerde beveiligingsdoeleinden, waaronder veilige cryptografische verwerking |
| 3 | Smartcards of soortgelijke apparaten, waaronder secure elements |

**Conformiteitsbeoordeling:** Beoordeling door een aangemelde instantie, of verplichte EUCC-certificering waar dit door een gedelegeerde handeling van de Commissie is voorgeschreven.

> **Opmerking:** Per mei 2025 beschikte geen enkel CDU-product over een IEC 62443-4-2-registercertificering op beveiligingsniveau — een parallelle leemte die evenzeer geldt voor de gereedheid voor CRA-certificering van kritieke producten.

***
## Deel V: Essentiële eisen (bijlage I)
Alle drie de productklassen moeten aan **dezelfde inhoudelijke eisen** van bijlage I voldoen. De classificatie beïnvloedt alleen hoe conformiteit wordt beoordeeld en gedocumenteerd.

Bijlage I is opgesplitst in twee delen:

***
### Bijlage I – deel I: Beveiligingseigenschappen van producten (13 eisen)
Fabrikanten moeten waarborgen dat producten zo worden **ontworpen, ontwikkeld en geproduceerd** dat zij bij het in de handel brengen aan deze eigenschappen voldoen:

| Eis | Eis | Technische toelichting |
|------|-------------|-----------------|
| **1** | **Geen bekende, misbruikbare kwetsbaarheden bij release** | Producten moeten vrij van misbruikbare kwetsbaarheden worden geleverd; de risicobeoordeling moet dit bevestigen |
| **2(a)** | **Veilige standaardconfiguratie** | Standaardinstellingen moeten veilig zijn; een optie om naar de oorspronkelijke staat terug te zetten moet beschikbaar zijn |
| **2(b)** | **Bescherming tegen onbevoegde toegang** | Authenticatie, identiteits- en toegangsbeheer (IAM), toegangscontrolemechanismen passend bij de omgeving |
| **2(c)** | **Vertrouwelijkheid van gegevens** | Bescherming van opgeslagen, verzonden en verwerkte gegevens (persoonlijk en overig) via state-of-the-art cryptografie in rust en tijdens verzending |
| **2(d)** | **Integriteitsbescherming** | Bescherm de integriteit van opgeslagen/verzonden gegevens, commando's, programma's, configuratie; meld corrupties |
| **2(e)** | **Gegevensminimalisatie** | Verwerk alleen gegevens die toereikend, ter zake dienend en beperkt zijn tot wat nodig is voor het beoogde gebruik |
| **2(f)** | **Beschikbaarheid en veerkracht** | Bescherm de beschikbaarheid van essentiële functies; veerkracht tegen en beperking van DoS-aanvallen |
| **2(g)** | **Beperk negatieve netwerkimpact** | Ontwerp om de eigen negatieve impact van het product op de beschikbaarheid van diensten op andere apparaten of netwerken te minimaliseren |
| **2(h)** | **Geminimaliseerd aanvalsoppervlak** | Beperk aanvalsoppervlakken, waaronder externe interfaces; door ontwerp en productie |
| **2(i)** | **Beperking van incidentimpact** | Exploitmitigatiemechanismen en -technieken om de impact van incidenten te verminderen |
| **2(j)** | **Beveiligingslogging en -monitoring** | Registreer en/of monitor relevante interne activiteit om incidenten te detecteren en te onderzoeken |
| **2(k)** | **Veilige updates** | Het updatemechanisme mag geen extra kwetsbaarheden introduceren; updates moeten geauthenticeerd zijn en de integriteit beschermen |
| **2(l)** | **Veilige fabrieksreset / herstel** | Het product moet terugkeer naar een bekende, goede staat mogelijk maken |

> **Toepasselijkheidsopmerking (art. 13(3)):** De risicobeoordeling bepaalt welke van de eisen 2(a)–2(l) op een bepaald product van toepassing zijn. Niet alle 13 gelden voor elk product — de risicobeoordeling stuurt de bepaling en moet worden gedocumenteerd.

***
### Bijlage I – deel II: Eisen voor kwetsbaarhedenbeheer (8 eisen)
Fabrikanten moeten aan deze eisen voldoen, zowel **bij het in de handel brengen** als **gedurende de gehele ondersteuningsperiode**:

| Eis | Code (BSI TR-03183) | Eis | Detail |
|------|---------------------|-------------|--------|
| **1** | REQ_VH1 | **Kwetsbaarheden identificeren en documenteren (SBOM)** | Houd een SBOM bij in een gangbaar, machineleesbaar formaat; dekt minimaal de afhankelijkheden op het hoogste niveau; documenteer alle bekende kwetsbaarheden per component |
| **2** | REQ_VH2 | **Kwetsbaarheden aanpakken en verhelpen** | Verhelp misbruikbare kwetsbaarheden zonder onnodige vertraging; waar technisch haalbaar moeten beveiligingsupdates gescheiden zijn van functionele updates |
| **3** | REQ_VH3 | **Regelmatige tests** | Doeltreffende en regelmatige beveiligingstests en -reviews; minimaal elke 3 maanden of bij elke grote wijziging, afhankelijk van wat vaker is |
| **4** | REQ_VH4 | **Verholpen kwetsbaarheden publiceren** | Verhelp­te kwetsbaarheden openbaar maken, met inbegrip van beschrijving, identificatie van getroffen product, impact, ernst en herstelrichtlijnen; publicatie mag worden uitgesteld tot een patch beschikbaar is |
| **5** | REQ_VH5 | **Beleid voor gecoördineerde kwetsbaarhedenmelding (CVD)** | Implementeer en handhaaf een CVD-beleid; reageer op meldingen binnen 5 werkdagen (eenvoudige bevestiging) en 10 werkdagen (gedetailleerde terugkoppeling) |
| **6** | REQ_VH5 | **Contactadres / security.txt** | Voorzie in een contactadres voor kwetsbaarheidsmeldingen; publiceer `security.txt` conform RFC 9116 op `/.well-known/security.txt` |
| **7** | REQ_VH6 | **Veilige distributie van updates** | Mechanismen om updates veilig te distribueren (versleuteld, integriteitsbeschermd); waar van toepassing automatische beveiligingsupdates |
| **8** | REQ_VH7 | **Updates zonder vertraging en kosteloos verspreiden** | Beveiligingsupdates moeten kosteloos zijn (standaard voor consumenten); zonder vertraging verspreid; vergezeld van adviesberichten die gebruikers informeren over de kwetsbaarheid en de vereiste actie |

**Minimale ondersteuningsperiode:** Ten minste 5 jaar, of de verwachte levensduur van het product indien korter. Beveiligingsupdates moeten nog **10 jaar** na release beschikbaar blijven. Het technisch dossier en de EU-conformiteitsverklaring moeten **10 jaar** worden bewaard.

**Meldingstermijnen voor kwetsbaarheden (art. 14, van toepassing vanaf 11 september 2026):**

| Melding | Termijn | Ontvanger |
|-------------|----------|-----------|
| Vroegtijdige waarschuwing | **24 uur** na kennisname | ENISA + nationaal CSIRT |
| Hoofdmelding | **72 uur** | ENISA + nationaal CSIRT |
| Eindrapport (actief misbruikte kwetsbaarheid) | **14 dagen** na beschikbaarheid van corrigerende/mitigerende maatregel | ENISA + nationaal CSIRT |
| Eindrapport (ernstig incident) | **30 dagen** na de indiening op 72 u | ENISA + nationaal CSIRT |

De rapportage geldt voor **alle PDE's op de EU-markt**, inclusief bestaande producten die vóór 11 december 2027 in de handel zijn gebracht.

***
## Deel VI: Technische specificaties en conformiteitsbeoordeling
### Modules voor conformiteitsbeoordeling (bijlage VIII)
| Module | Traject art. 32 | Wie voert uit | Wanneer gebruikt |
|--------|----------------|--------------|-----------|
| **Module A** – Interne controle | Art. 32(1)(a) | Fabrikant (zelfbeoordeling) | Standaardproducten; belangrijke producten klasse I waar geharmoniseerde normen zijn toegepast |
| **Module B** – EU-typeonderzoek | Art. 32(1)(b), deel I + II bijlage VIII | Aangemelde instantie onderzoekt het ontwerp | Klasse I zonder geharm. norm; klasse II; kritiek |
| **Module C** – Conformiteit met type (interne productiecontrole) | Art. 32(1)(b), deel II bijlage VIII | Fabrikant, op basis van het module B-certificaat | Volgt altijd op module B |
| **Module H** – Volledige kwaliteitsborging | Art. 32(1)(c), deel IV bijlage VIII | Aangemelde instantie beoordeelt het volledige KMS | Klasse II; kritiek; fabrikanten met meerdere/frequente producttypen |
| **EUCC / Europese cybersecuritycertificering** | Art. 32(1)(d) + art. 27(9) | Door ENISA erkend certificeringsregime | Waar de Commissie de toepasselijkheid van een regime heeft aangegeven; kritieke producten |

**Voordeel van module H:** Dekt een volledige productcatalogus onder één beoordeling van het kwaliteitsmanagementsysteem. Bijzonder nuttig voor fabrikanten met frequente updates of meerdere producttypen, omdat typeonderzoek per product overbodig wordt.
### Normen en technische specificaties
De CRA steunt op **geharmoniseerde Europese normen** die door CEN/CENELEC/ETSI worden ontwikkeld en concrete implementatierichtlijnen voor de eisen van bijlage I bieden. Het gebruik van geharmoniseerde normen levert een **wettelijk vermoeden van conformiteit** op (artikel 27).

Belangrijke normalisatie-instellingen en -inspanningen:

| Instelling | Rol |
|------|------|
| CEN/CENELEC JTC 13 | Algemene horizontale cybersecuritynormen (EN 18045, enz.) |
| ETSI | Telecomspecifieke normen; ETSI EN 303 645 (IoT) |
| BSI (Duitsland) | Technische richtlijnen TR-03183 (delen 1–3): implementatierichtlijnen voor fabrikanten |
| ENISA | CRA-platform voor centrale melding; EUCC-regime |

> **Status (juni 2026):** De geharmoniseerde normen onder de CRA worden nog door CEN/CENELEC/ETSI afgerond. De technische richtlijnen BSI TR-03183 vormen momenteel de meest concrete implementatiereferentie.
### Eisen aan de CE-markering (art. 28–30)
Voordat een fabrikant een PDE op de EU-markt brengt, moet deze:
1. De toepasselijke conformiteitsbeoordelingsprocedure doorlopen
2. De **EU-conformiteitsverklaring** opstellen en ondertekenen
3. De **CE-markering** zichtbaar op het product aanbrengen
4. Gebruikersinformatie conform bijlage II verstrekken (inclusief de einddatum van de ondersteuningsperiode, maand en jaar)

***
## Deel VII: Bijlagen — volledige beschrijvingen en checklists
### Bijlage I – Essentiële cybersecurityeisen
**Beschrijving:** De technische kern van de CRA. Opgesplitst in deel I (beveiligingseigenschappen van producten, 13 eisen) en deel II (kwetsbaarhedenbeheer, 8 eisen). Alle PDE's binnen de reikwijdte moeten aan beide delen voldoen — de risicobeoordeling bepaalt de toepasselijkheid en de implementatiebenadering voor de eisen 2(a)–2(l) van deel I.

**Checklist:**
- [ ] Cybersecurityrisicobeoordeling voltooid en gedocumenteerd (art. 13(2))
- [ ] Risicobeoordeling dekt beoogd doel, voorzienbaar gebruik, operationele omgeving, activa, verwachte levensduur
- [ ] Product uitgebracht zonder bekende misbruikbare kwetsbaarheden (eis 1)
- [ ] Veilige standaardconfiguratie geïmplementeerd (eis 2a)
- [ ] Toegangscontrole-/authenticatiemechanismen aanwezig (eis 2b)
- [ ] Gegevens in rust en tijdens verzending versleuteld met actuele cryptografie (eis 2c)
- [ ] Integriteitsbescherming van gegevens en commando's geïmplementeerd (eis 2d)
- [ ] Beginsel van gegevensminimalisatie toegepast (eis 2e)
- [ ] DoS-veerkrachtmechanismen voor essentiële functies (eis 2f)
- [ ] Product ontworpen om negatieve netwerkimpact te minimaliseren (eis 2g)
- [ ] Aanvalsoppervlak geminimaliseerd, externe interfaces beperkt (eis 2h)
- [ ] Exploitmitigatietechnieken geïmplementeerd (eis 2i)
- [ ] Beveiligingslogging en -monitoring aanwezig (eis 2j)
- [ ] Veilig updatemechanisme geïmplementeerd (eis 2k)
- [ ] Veilige fabrieksreset / herstelstaat beschikbaar (eis 2l)
- [ ] SBOM aangemaakt in machineleesbaar formaat (VH-eis 1)
- [ ] Proces voor kwetsbaarheidsherstel gedocumenteerd (VH-eis 2)
- [ ] Schema voor regelmatige beveiligingstests vastgesteld (VH-eis 3)
- [ ] CVD-beleid en security.txt gepubliceerd (VH-eis 5/6)
- [ ] Mechanisme voor veilige updatedistributie geïmplementeerd (VH-eis 7)
- [ ] Proces voor kosteloze updatedistributie aanwezig (VH-eis 8)
- [ ] Ondersteuningsperiode van minimaal 5 jaar verklaard

***
### Bijlage II – Informatie en instructies voor gebruikers
**Beschrijving:** Bepaalt de verplichte informatie die producten op de EU-markt moet vergezellen, in een voor gebruikers begrijpelijke taal. Dit is de nalevingslaag richting de gebruiker.

**Vereiste informatie omvat:**
- Producttype, batch- of serienummer voor identificatie
- Naam van de fabrikant, geregistreerd handelsmerk, post-/e-mailadres, website
- Voorwaarden voor beoogd gebruik, misbruikscenario's, bekende risico's
- De EU-conformiteitsverklaring (of waar deze te vinden is)
- Einddatum van de beveiligingsondersteuningsperiode (maand en jaar), getoond op het verkooppunt
- Hoe kwetsbaarheden te melden (contactadres)
- Instructies voor veilige installatie, gebruik en buitengebruikstelling
- Beschrijving van cybersecurityeigenschappen die voor gebruikers relevant zijn

**Checklist:**
- [ ] Productidentificatie-element (type, batch, serie)
- [ ] Contactgegevens fabrikant (post + digitaal)
- [ ] Voorwaarden voor beoogd gebruik gedocumenteerd
- [ ] Einddatum beveiligingsondersteuning prominent weergegeven
- [ ] Contactadres voor kwetsbaarheidsmeldingen opgenomen
- [ ] Gebruikersinstructies dekken veilige installatie, gebruik, buitengebruikstelling
- [ ] EU-conformiteitsverklaring bijgevoegd of via URL vermeld
- [ ] Taal passend voor de doelmarkt(en)

***
### Bijlage III – Belangrijke producten met digitale elementen
**Beschrijving:** De definitieve lijst van productcategorieën die als "belangrijk" zijn geclassificeerd, opgesplitst in deel I (klasse I — matig risico bij beoordeling door derden) en deel II (klasse II — hoger systemisch risico). Producten worden geclassificeerd op basis van kernfunctionaliteit.

De technische beschrijvingen van deze categorieën zijn op 28 november 2025 vastgesteld via Uitvoeringsverordening (EU) 2025/2392 van de Commissie.

**Checklist (voor fabrikanten van producten met functionaliteit die overeenkomt met bijlage III):**
- [ ] Kernfunctionaliteit getoetst aan alle categorieën van bijlage III, deel I en deel II
- [ ] Classificatie als klasse I of klasse II bepaald en gedocumenteerd
- [ ] Traject conformiteitsbeoordeling gekozen (module A alleen bij klasse I met geharmoniseerde normen; module B+C of H bij klasse II of klasse I zonder normen)
- [ ] FOSS-uitzondering beoordeeld indien van toepassing (vereist openbare technische documentatie)
- [ ] Aangemelde instantie geïdentificeerd en ingeschakeld (indien vereist)
- [ ] Uitgebreide technische documentatie voorbereid voor beoordeling door derden

***
### Bijlage IV – Kritieke producten met digitale elementen
**Beschrijving:** Drie specifieke productcategorieën die aan de strengste verplichtingen zijn onderworpen, met de mogelijkheid van verplichte EUCC-certificering bij gedelegeerde handeling van de Commissie:

1. **Hardwareapparaten met beveiligingsboxen** (HSM's)
2. **Slimme-metergateways** binnen slimme-meetsystemen (Richtlijn (EU) 2019/944) en andere apparaten voor geavanceerde beveiligingsdoeleinden, waaronder veilige cryptografische verwerking
3. **Smartcards of soortgelijke apparaten, waaronder secure elements**

**Checklist:**
- [ ] Product getoetst aan alle drie de categorieën van bijlage IV
- [ ] Kritieke classificatie gedocumenteerd
- [ ] Beoordeling door aangemelde instantie gestart
- [ ] Toepasselijkheid EUCC-certificering gecontroleerd (gedelegeerde handelingen van de Commissie)
- [ ] Versterkt plan voor monitoring na het in de handel brengen opgesteld
- [ ] Coördinatie met ENISA over registratie op het meldingsplatform

***
### Bijlage V – EU-conformiteitsverklaring (volledig model)
**Beschrijving:** Biedt de verplichte sjabloonstructuur voor de volledige EU-conformiteitsverklaring die fabrikanten vóór de CE-markering moeten opstellen en ondertekenen.

**Vereiste elementen van de conformiteitsverklaring:**
- Productidentificatie (naam, model, batch-/serienummer)
- Naam en volledig adres van de fabrikant
- Verklaring dat de conformiteitsverklaring onder de uitsluitende verantwoordelijkheid van de fabrikant wordt afgegeven
- Voorwerp van de verklaring, voldoende geïdentificeerd om tot het product herleidbaar te zijn
- Verwijzing naar de CRA (Verordening (EU) 2024/2847) en bijlage I
- Verwijzing naar eventuele toegepaste geharmoniseerde normen
- Verwijzing naar eventuele toegepaste gemeenschappelijke specificaties
- Verwijzing naar eventuele gebruikte Europese cybersecuritycertificering
- Identificatie van de aangemelde instantie (bij beoordeling door derden), beoordelingsmodule en certificaatnummer
- Ondertekende verklaring door of namens de fabrikant, met datum en plaats

**Checklist:**
- [ ] Alle vereiste velden ingevuld
- [ ] Toegepaste normen/specificaties met versie/datum vermeld
- [ ] Nummer aangemelde instantie en certificaatnummer opgenomen (indien van toepassing)
- [ ] Conformiteitsverklaring ondertekend door bevoegde persoon
- [ ] Conformiteitsverklaring 10 jaar bewaard
- [ ] Conformiteitsverklaring op verzoek beschikbaar voor markttoezichtautoriteiten
- [ ] Vereenvoudigde verklaring (bijlage VI) gebruikt voor klasse I-producten indien toegestaan

***
### Bijlage VI – Vereenvoudigde EU-conformiteitsverklaring
**Beschrijving:** Verkort format van de conformiteitsverklaring dat is toegestaan voor producten waarvoor de regelgeving een vereenvoudigde verklaring toelaat (voornamelijk bij ruimtebeperkte producten). De vereenvoudigde verklaring moet vermelden waar de volledige verklaring te vinden is.

**Vereiste elementen van de vereenvoudigde verklaring:**
- Productnaam en -type
- Naam en adres van de fabrikant
- Verklaring van conformiteit met Verordening (EU) 2024/2847
- Website-URL waar de volledige conformiteitsverklaring toegankelijk is

**Checklist:**
- [ ] Controleer of een vereenvoudigde verklaring is toegestaan voor de productcategorie
- [ ] URL naar de volledige verklaring actief en toegankelijk
- [ ] Vereenvoudigde verklaring opgenomen in de productverpakking of -documentatie

***
### Bijlage VII – Technische documentatie
**Beschrijving:** Specificeert de minimuminhoud van de technische documentatie (technisch dossier) die vóór het in de handel brengen moet worden opgesteld en beschikbaar gehouden voor markttoezichtautoriteiten.

De technische documentatie moet **vóór** het in de handel brengen worden samengesteld en tot **10 jaar daarna** worden bewaard.

**Inhoudseisen van bijlage VII:**

| Deel | Inhoud |
|------|---------|
| **Productbeschrijving en beoogd gebruik** | Type, model, versie, beoogd gebruik, operationele omgeving, connectiviteit, afhankelijkheden |
| **Ontwerp- en fabricage-informatie** | Architectuur (hardware en software), moduleopbouw, firmware, netwerkarchitectuur, gegevensstroomdiagrammen, componenten van derden |
| **Cybersecurityrisicobeoordeling** | Conform artikel 13(2)–(3); identificatie van dreigingen, risicobepaling, bepaling toepasselijkheid bijlage I |
| **Implementatie van essentiële eisen** | Toewijzing van elke toepasselijke eis van bijlage I aan geïmplementeerde technische maatregelen |
| **SBOM** | Machineleesbare SBOM die afhankelijkheden op het hoogste niveau dekt; componentnamen, versies, leveranciers, bekende CVE's, licenties |
| **Update- en patchbeheer** | Update-architectuur, ondertekening/validatie, terugrolpreventie, levenscyclusbeleid |
| **Processen voor kwetsbaarhedenbeheer** | CVD-beleid, intake- en triageproces, herstelworkflows, openbaarmakingstermijnen |
| **Bewijs van beveiligingstests** | Samenvattingen van pentests, SAST/DAST-resultaten, fuzzing-resultaten, testrapporten van derden |
| **Bewijs van conformiteitsbeoordeling** | Zelfverklaring module A of certificaat module B / KMS-certificaat module H |
| **EU-conformiteitsverklaring** | Kopie van de ingevulde conformiteitsverklaring van bijlage V |
| **Plan voor monitoring na in de handel brengen** (component na markttoetreding, bijlage VII) | Monitoringstrategie, dreigingsinformatiebronnen, incidentresponsdocumentatie, kwetsbaarheidsregister |

**Checklist:**
- [ ] Productbeschrijving en beoogd gebruik — compleet
- [ ] Architectuurdiagrammen (hardware, software, netwerk, gegevensstroom) — compleet
- [ ] Cybersecurityrisicobeoordeling gedocumenteerd en ondertekend
- [ ] Toewijzingsmatrix eisen bijlage I — compleet
- [ ] SBOM gegenereerd in machineleesbaar formaat (SPDX, CycloneDX of SWID)
- [ ] Alle SBOM-afhankelijkheden — naam, versie, leverancier, CVE-status, licentie
- [ ] Documentatie veilige ontwikkelingslevenscyclus (SDL) opgenomen
- [ ] Bewijs van beveiligingstests (pentest, SAST, DAST, fuzzing) gearchiveerd
- [ ] Architectuur updatemechanisme gedocumenteerd
- [ ] Proces voor kwetsbaarhedenbeheer gedocumenteerd
- [ ] CVD-beleid en security.txt-bestand gedocumenteerd
- [ ] EU-conformiteitsverklaring (bijlage V) opgenomen
- [ ] Plan voor monitoring na in de handel brengen opgenomen
- [ ] Technisch dossier 10 jaar bewaard vanaf het in de handel brengen
- [ ] Aangewezen contactpersoon voor gegevensverzoeken van markttoezichtautoriteiten

***
### Bijlage VIII – Conformiteitsbeoordelingsprocedures
**Beschrijving:** Specificeert de vier beoordelingsmodules op grond van artikel 32 en definieert de verplichtingen van de fabrikant en de aangemelde instantie voor elke module:

**Deel I – Module A (interne controle / zelfbeoordeling):**
- De fabrikant voert alle conformiteitsbeoordelingsactiviteiten uit
- Geen betrokkenheid van een aangemelde instantie
- De fabrikant stelt de technische documentatie samen en ondertekent de EU-conformiteitsverklaring
- Beschikbaar voor: standaardproducten; belangrijke producten klasse I waar geharmoniseerde normen of gemeenschappelijke specificaties zijn toegepast

**Deel II – Module B (EU-typeonderzoek):**
- De fabrikant dient technische documentatie en een representatief monster in bij een aangemelde instantie
- De aangemelde instantie onderzoekt het productontwerp en geeft een certificaat van EU-typeonderzoek af
- Certificaat 5 jaar geldig, verlengbaar
- Moet worden gevolgd door module C

**Deel III – Module C (conformiteit met EU-type op basis van interne productiecontrole):**
- Volgt op module B
- De fabrikant verklaart dat de productie overeenstemt met het goedgekeurde type
- Geen verdere betrokkenheid van een aangemelde instantie in de productiefase

**Deel IV – Module H (volledige kwaliteitsborging):**
- De fabrikant implementeert een volledig kwaliteitsmanagementsysteem van ontwerp tot en met productie
- De aangemelde instantie beoordeelt het volledige KMS (kan gebaseerd zijn op de ISO 9000-reeks, maar ISO 9000-certificering alleen is onvoldoende)
- De aangemelde instantie voert periodieke audits uit
- De fabrikant verklaart conformiteit op basis van het KMS
- Best voor fabrikanten met meerdere producttypen of frequente updates
- Eén aangemelde instantie dekt het volledige KMS

**Checklist:**
- [ ] Productclassificatie bevestigd (standaard / klasse I / klasse II / kritiek)
- [ ] Beschikbaarheid geharmoniseerde normen gecontroleerd (bepaalt geschiktheid module A voor klasse I)
- [ ] Traject conformiteitsbeoordeling gedocumenteerd en onderbouwd
- [ ] Aangemelde instantie geïdentificeerd en gecontracteerd (indien vereist)
- [ ] Module A: technische documentatie compleet; zelfverklaring ondertekend
- [ ] Module B: aanvraag ingediend bij aangemelde instantie; EU-typecertificaat ontvangen
- [ ] Module C: productieconformiteitsverklaring ondertekend met verwijzing naar module B-certificaat
- [ ] Module H: KMS gedocumenteerd en ingediend; goedkeuring aangemelde instantie ontvangen; periodiek auditschema vastgesteld
- [ ] ID-nummer aangemelde instantie vastgelegd in EU-conformiteitsverklaring

***
## Deel VIII: Handhaving, sancties en markttoezicht
### Sanctieniveaus (artikel 64)
| Overtreding | Maximale boete | % van wereldwijde jaaromzet |
|-----------|-------------|----------------------------|
| Niet-naleving van essentiële cybersecurityeisen (bijlage I) of verplichtingen van de fabrikant uit art. 13/14 | **€ 15.000.000** | **2,5 %** (het hoogste van beide) |
| Niet-naleving van overige verplichtingen (importeurs, distributeurs, conformiteit, CE-markering, technische documentatie) | **€ 10.000.000** | **2,0 %** (het hoogste van beide) |
| Verstrekken van onjuiste, onvolledige of misleidende informatie aan aangemelde instanties of markttoezichtautoriteiten | **€ 5.000.000** | **1,0 %** (het hoogste van beide) |

**Vrijstelling voor kmo's:** Micro- en kleine ondernemingen kunnen niet worden beboet voor het niet halen van de meldingstermijn van 24 uur voor de vroegtijdige waarschuwing. Beheerders van openbronsoftware zijn niet onderworpen aan sancties voor enige CRA-inbreuk.

**Niet-financiële handhaving:** Markttoezichtautoriteiten kunnen terugtrekking van het product of corrigerende maatregelen eisen; producten die niet-conform worden bevonden, kunnen van de EU-markt worden geweerd.
### Structuur van het markttoezicht
- Elke lidstaat wijst op grond van artikel 52 een of meer **markttoezichtautoriteiten (MTA's)** aan
- Grensoverschrijdende coördinatie via de **groep voor administratieve samenwerking (ADCO)** — artikel 52
- **Gezamenlijke acties** en gecoördineerde controlemaatregelen mogelijk op grond van artikel 60
- MTA's kunnen technische documentatie inzien, producten testen en bevelen tot corrigerende maatregelen, terugtrekking of terugroeping uitvaardigen

***
## Deel IX: Tijdlijnoverzicht en nalevingsstappenplan
| Datum | Verplichting |
|------|-----------|
| **10 dec. 2024** | CRA in werking getreden |
| **11 jun. 2026** | Lidstaten moeten conformiteitsbeoordelingsinstanties aanmelden (hfst. IV van toepassing) |
| **11 sep. 2026** | Rapportageverplichtingen (art. 14) van toepassing — termijnen 24 u/72 u/14 d/30 d actief voor alle PDE's op de EU-markt, inclusief bestaande |
| **11 dec. 2027** | Volledige toepasselijkheid CRA — CE-markering, conformiteitsverklaring, conformiteitsbeoordeling en alle verplichtingen verplicht voor nieuwe producten |
| **11 jun. 2028** | Bestaande certificaten van EU-typeonderzoek en goedkeuringsbesluiten verlopen |

**Regel voor substantiële wijziging:** Producten die **vóór 11 december 2027** in de handel zijn gebracht, zijn vrijgesteld, tenzij zij na die datum een "substantiële wijziging" ondergaan (gedefinieerd in artikel 3(30), overwegingen 38–41).

**Onmiddellijke actiepunten (vóór december 2027):**
1. Classificeer alle producten aan de hand van bijlage III/IV
2. Voer een cybersecurityrisicobeoordeling uit conform art. 13(2)
3. Zet SBOM-tooling en CVD-beleidsinfrastructuur op
4. Registreer op het ENISA-platform voor centrale melding (voor naleving van art. 14 vóór sep. 2026)
5. Identificeer een aangemelde instantie voor klasse II- of kritieke producten
6. Start met het samenstellen van de technische documentatie
7. Breng de eisen van bijlage I in kaart tegen bestaande beveiligingsmaatregelen en identificeer leemten

---

## Bronnen

1. [Exclusions and Transitional Scope under the EU Cyber Resilience Act](https://www.linkedin.com/pulse/exclusions-transitional-scope-under-eu-cyber-resilience-ian-gauci-frwce)
2. [The Cyber Resilience Act: an overview - Cyberstand](https://cyberstand.eu/cyber-resilience-act-overview)
3. [The Cyber Resilience Act - Summary of the legislative text](https://digital-strategy.ec.europa.eu/en/policies/cra-summary)
4. [Cyber Resilience Act: Overview for affected companies](https://www.taylorwessing.com/en/insights-and-events/insights/2025/11/cyber-resilience-act-overview)
5. [Cyber Resilience Act - BSI](https://www.bsi.bund.de/EN/Themen/Unternehmen-und-Organisationen/Informationen-und-Empfehlungen/Cyber_Resilience_Act/cyber_resilience_act_node.html)
6. [Which products fall under scope of the EU CRA - Nohau](https://nohau.eu/blogs/knowledge-center/beyond-the-checklist-which-products-fall-under-scope-of-the-eu-cyber-resilience-act-cra)
7. [Cyber Resilience Act text, Article 13](https://www.european-cyber-resilience-act.com/Cyber_Resilience_Act_Article_13.html)
8. [CRA guide for manufacturers](https://www.cyberresilienceact.eu/cra-guide-for-manufacturers/)
9. [Mandatory SBOMs: What CRA is — and why it matters | RL Blog](https://www.reversinglabs.com/blog/mandatory-sbom-cra)
10. [CRA SBOM Requirements: Complete Guide - Regulus](https://goregulus.com/cra-requirements/cra-sbom-requirements/)
11. [Does the EU CRA Apply to Your Product?](https://testofthings.com/blog/does-cra-apply-to-your-product-product-functions-boundaries-and-components)
12. [The 3 product categories covered by the CRA](https://theembeddedkit.io/blog/product-categories-cyber-resilience-act/)
13. [How to Classify IoT Products under the CRA - Tributech](https://www.tributech.io/blog/classify-iot-products-cyber-resilience-act)
14. [Which Conformity Assessment Procedure Applies?](https://www.linkedin.com/pulse/step-6-which-conformity-assessment-procedure-applies-michael-jesse-szpkf)
15. [Understanding the EU CRA Requirements - Finite State](https://finitestate.io/blog/conformity-assessments-eu-cra-requirements)
16. [CRA - Annex IV - StreamLex](https://streamlex.eu/annexes/cra-en-annex-iv/)
17. [Cyber Resilience Act text, Annex 1](https://www.european-cyber-resilience-act.com/Cyber_Resilience_Act_Annex_1.html)
18. [EU CRA: Essential Requirements Related to Vulnerability Handling](https://www.smallstepsystems.com/eu-cra-essential-requirements-related-to-vulnerability-handling/)
19. [Penalties for CRA Non-Compliance Explained](https://complyd.io/en/blog/compliance-info-penalties-for-cra-non-compliance-explained/)
20. [What is module H? How does it work? - CRA FAQ](https://cra.orcwg.org/faq/official/faq_6-3/)
21. [Cyber Resilience Act Technical Documentation Guide (Annex II & VII)](https://goregulus.com/cra-documentation/technical-documentation/)
22. [Cyber Resilience Act text, Article 53](https://www.european-cyber-resilience-act.com/Cyber_Resilience_Act_Article_53_15.9.2022.html)

---

_Zie ook: [Cyber Resilience Act overzicht](/nl/cra) · [CRA CE-markeringstrajecten](/nl/cra-ce-marking-pathways) · [CRA Volledige technische referentie](/nl/cra-technical-reference) · [IEC 62443](/nl/iec-62443) · [NIS2](/nl/nis2)_
