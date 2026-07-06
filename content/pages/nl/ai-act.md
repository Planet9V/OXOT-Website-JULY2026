---
title: De EU AI Act en industriële AI
meta_title: EU AI Act voor Industriële & OT-AI | OXOT
meta_description: De EU AI Act (Verordening (EU) 2024/1689) voor industrie en OT — risicoklassen met voorbeelden uit de praktijk op de werkvloer, de twee routes naar hoog risico, de koppeling met de Machineverordening, de plichten van aanbieder versus gebruiksverantwoordelijke, cyberbeveiliging onder Artikel 15, het herziene tijdpad voor 2026 en de sancties.
excerpt: Hoe de EU AI Act van toepassing is zodra AI de fabrieksvloer betreedt — classificatie als hoog risico, de koppeling met machineveiligheid, de plichten van aanbieder en gebruiksverantwoordelijke, robuustheid onder Artikel 15, het herziene tijdpad voor 2026 en de sancties.
content_type: page
published: true
---

Kunstmatige intelligentie is de fabrieksvloer binnengekomen zonder lanceerdatum. Ze sloop naar binnen via een visiesysteem dat een leverancier in een inspectiecel bundelde, een module voor predictief onderhoud in een aandrijving, een "adaptieve" lus in een firmware-release van een controller. Niemand heeft er beleid voor vastgesteld. Niemand heeft er een grens omheen getrokken. En nu stemt AI processen af, keurt ze producten, voorspelt ze storingen, balanceert ze energie en — in toenemende mate — bevindt ze zich dicht bij de veiligheids- en besturingsfuncties die bepalen of een lijn draait of stilvalt.

De EU AI Act is de eerste allesomvattende wet ter wereld die deze verschuiving reguleert. Voor de meeste mensen roept "AI-regelgeving" beelden op van chatbots en deepfakes. Voor een industriële operator zijn de bepalingen die er echt toe doen juist de stille bepalingen: de regels voor **AI die is ingebed in machines, veiligheidscomponenten en gereguleerde producten**. Daar reikt de wet tot in de operationele technologie, en daar houdt AI-governance op een juridische abstractie te zijn en wordt het een technisch vraagstuk.

Deze pagina legt uit wat de AI Act vereist, wanneer een industrieel AI-systeem de grens naar "hoog risico" overschrijdt, hoe de wet doelbewust is verweven met de Machineverordening en het bredere productveiligheidsregime, wat aanbieders en gebruiksverantwoordelijken elk verschuldigd zijn, en hoe een proportionele aanpak eruitziet in een OT-omgeving waar een gemanipuleerd model een gemanipuleerd proces is.

## De korte versie

- De AI Act is **Verordening (EU) 2024/1689**. Ze is op **1 augustus 2024** in werking getreden en wordt in fasen van kracht. ([EUR-Lex, officiële tekst](https://eur-lex.europa.eu/eli/reg/2024/1689/oj/eng))
- Ze is **risicogebaseerd**: een korte lijst van **verboden** praktijken, een veeleisende **hoog-risico**-klasse, lichtere **transparantie**verplichtingen voor systemen met beperkt risico, en geen nieuwe verplichtingen voor AI met minimaal risico.
- Industriële AI wordt meestal hoog risico via **Bijlage I** — waar de AI een veiligheidscomponent is van, of zelf, een product dat onder EU-harmonisatiewetgeving valt, zoals de **Machineverordening**. Een tweede route loopt via gebruik in **Bijlage III**-kritieke infrastructuur.
- **Aanbieders** (providers — die AI ontwikkelen of op de markt brengen) dragen de zware verplichtingen; **gebruiksverantwoordelijken** (deployers — die AI gebruiken) dragen een lichtere maar reële set plichten. Wijzig een systeem voldoende en een gebruiksverantwoordelijke *wordt* een aanbieder.
- Hoog-risicosystemen moeten voldoen aan de Artikelen 8–15: risicobeheer, datagovernance, logging, transparantie, menselijk toezicht en — de regel die OT-teams twee keer moeten lezen — **nauwkeurigheid, robuustheid en cyberbeveiliging** onder **Artikel 15**.
- Sancties lopen op tot **35 miljoen euro of 7% van de wereldwijde omzet** voor verboden praktijken, en **15 miljoen euro of 3%** voor schending van hoog-risicoverplichtingen. ([Artikel 99](https://artificialintelligenceact.eu/article/99/))
- De hoog-risicotermijnen zijn **uitgesteld** door de **Digital Omnibus**, overeengekomen op **7 mei 2026** — zelfstandige Bijlage III-systemen gelden nu vanaf **2 december 2027**, en in producten ingebedde Bijlage I-AI vanaf **2 augustus 2028**. ([Gibson Dunn](https://www.gibsondunn.com/eu-ai-act-omnibus-agreement-postponed-high-risk-deadlines-and-other-key-changes/))

> [!NOTE]
> De eerlijke hoofdboodschap voor de industrie: **de meeste industriële AI is geen hoog risico.** Procesoptimalisatie, kwaliteitsanalyse en onderhoudsvoorspelling die nooit een veiligheids- of besturingsfunctie raken, vallen in de minimale klasse. Het echte werk is het vinden van de handvol systemen die dat *wel* doen, ze correct classificeren, en ze beheersen zonder de nuttige negentig procent te verstikken.

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

Toen verschoof het tijdpad. Op **7 mei 2026** bereikten onderhandelaars van de Raad, het Parlement en de Commissie een voorlopig politiek akkoord over de **Digital Omnibus inzake AI** — een vereenvoudigingspakket dat onder meer **de hoog-risicotermijnen uitstelde**. Volgens de overeengekomen tekst gelden zelfstandige **Bijlage III**-hoog-risicosystemen vanaf **2 december 2027** (een verschuiving ten opzichte van de oorspronkelijke 2 augustus 2026), en in producten ingebedde **Bijlage I**-AI vanaf **2 augustus 2028**. ([Hogan Lovells](https://www.hoganlovells.com/en/publications/eu-legislators-agree-to-delay-for-highrisk-ai-rules); [ComplianceHub](https://compliancehub.wiki/eu-digital-omnibus-ai-act-deadline-deferral-annex-iii-2027/))

| Datum | Wat van toepassing is | Status |
|---|---|---|
| 1 aug 2024 | Verordening treedt in werking | Van kracht |
| 2 feb 2025 | Verbodsbepalingen Art. 5; plicht AI-geletterdheid | Van kracht |
| 2 aug 2025 | Governanceregels; verplichtingen GPAI-modellen | Van kracht |
| 2 dec 2026 | Nieuw verbod (door AI gegenereerd intiem beeldmateriaal / CSAM) | Voorlopig (Omnibus) |
| **2 dec 2027** | **Hoog-risicoverplichtingen voor zelfstandige Bijlage III-systemen** | **Voorlopig (Omnibus) — was 2 aug 2026** |
| **2 aug 2028** | **Hoog-risicoverplichtingen voor in Bijlage I ingebedde AI (incl. machines)** | **Voorlopig (Omnibus)** |

> [!WARNING]
> Behandel deze hoog-risicodata als **voorlopig**. De Digital Omnibus is op 7 mei 2026 politiek overeengekomen, maar krijgt pas rechtskracht zodra de wijzigingsverordening formeel is vastgesteld en gepubliceerd in het Publicatieblad. Plan op basis van de specifieke route van uw systeem, niet op basis van een krantenkop — en houd het Publicatieblad in de gaten, niet het persbericht. ([Gibson Dunn](https://www.gibsondunn.com/eu-ai-act-omnibus-agreement-postponed-high-risk-deadlines-and-other-key-changes/))

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

## Aanbieders versus gebruiksverantwoordelijken

De verordening splitst plichten naar rol, en het correct vaststellen van uw rol bepaalt uw verplichtingen. Het onderscheid is niet academisch — dezelfde organisatie kan gebruiksverantwoordelijke zijn voor het ene systeem en, zonder dat te bedoelen, de aanbieder van een ander.

| | **Aanbieder** (provider — Art. 16) | **Gebruiksverantwoordelijke** (deployer — Art. 26) |
|---|---|---|
| Wie | Ontwikkelt de AI of laat deze ontwikkelen, en brengt deze op de markt / in gebruik onder eigen naam | Gebruikt een hoog-risico AI-systeem onder eigen gezag — de meeste industriële operators |
| Kernplichten | Kwaliteitsmanagementsysteem; volledige technische documentatie; conformiteitsbeoordeling; EU-conformiteitsverklaring; CE-markering; registratie in de EU-databank; monitoring na het in de handel brengen | Gebruik volgens instructies; menselijk toezicht door bevoegde personen waarborgen; zorgen dat invoergegevens relevant/representatief zijn; de werking monitoren, opschorten en rapporteren bij opkomend risico; logs bijhouden (min. 6 maanden) |
| Typische actor in OT | OEM, machinebouwer, integrator, modelleverancier | Fabrieksoperator, nutsbedrijf, asset-eigenaar |
| De valkuil | — | Wijzig, hertrain of rebrand een hoog-risicosysteem substantieel en u kunt **de aanbieder worden** — met overname van de volledige aanbiedersverplichtingen |

**Aanbieders** dragen het gewicht, en in de praktijk is dat uw OEM, integrator of modelleverancier. ([Artikel 16](https://artificialintelligenceact.eu/article/16/)) **Gebruiksverantwoordelijken** dragen een lichtere maar concrete set plichten, en waar u AI inzet die werknemers raakt, kunt u hun ook informatie verschuldigd zijn. ([Artikel 26](https://artificialintelligenceact.eu/article/26/)) De grens tussen beide is degene die u in de gaten moet houden bij inkoop en bij elke firmware-upgrade: op het moment dat u het veiligheidsmodel van een leverancier hertraint op uw eigen data, heeft u die grens zeer waarschijnlijk overschreden.

## Een noot over AI voor algemene doeleinden

Los van de risicoklassen stelt de verordening regels vast voor **AI-modellen voor algemene doeleinden (GPAI)** — de grote foundation-modellen die voor veel taken kunnen worden aangepast. Hun verplichtingen (documentatie, auteursrechtbeleid, samenvattingen van trainingsdata, en aanvullende plichten voor modellen met "systeemrisico") golden vanaf **2 augustus 2025**, en de Commissie kan GPAI-aanbieders rechtstreeks beboeten. Voor een industriële operator is dit meestal upstream — u consumeert GPAI via tools in plaats van het te trainen — maar als u een foundation-model fine-tunet en in een product inbedt, komen de vragen over aanbiederschap weer in beeld.

## Sancties

Artikel 99 stelt de plafonds vast, en het zijn de hoogste in het EU-digitale recht. Net als bij de AVG en NIS2 is de structuur bewust gekoppeld aan de omzet, zodat non-compliance zich vertaalt naar een financieel risico op bestuursniveau, niet naar een begrotingspost.

| Overtreding | Maximale boete | Artikel |
|---|---|---|
| Verboden praktijken | **35.000.000 euro of 7%** van de totale wereldwijde jaaromzet, afhankelijk van wat hoger is | Art. 5 → Art. 99 |
| Schending van overige verplichtingen (aanbieders, gebruiksverantwoordelijken, importeurs, distributeurs, aangemelde instanties, transparantie) | **15.000.000 euro of 3%** van de wereldwijde omzet | Art. 99 |
| Verstrekken van onjuiste, onvolledige of misleidende informatie aan autoriteiten / aangemelde instanties | **7.500.000 euro of 1%** van de wereldwijde omzet | Art. 99 |
| Inbreuken door aanbieders van GPAI-modellen | **15.000.000 euro of 3%** van de wereldwijde omzet | Art. 101 |

Boetes zijn proportioneel, en voor kmo's en start-ups is het bedrag begrensd op het laagste van het percentage of het absolute bedrag — een bewuste verzachting voor kleinere bedrijven. ([Artikel 99](https://artificialintelligenceact.eu/article/99/); [Artikel 101](https://ai-act-service-desk.ec.europa.eu/en/ai-act/article-101))

## De koppeling met de Machineverordening

De AI Act staat niet op zichzelf. De **Machineverordening (EU) 2023/1230** — die de oude Machinerichtlijn vervangt en van toepassing is vanaf **20 januari 2027** — moderniseert machineveiligheid voor een wereld van software, connectiviteit en AI, en maakt voor het eerst **cyberbeveiliging tot een essentiële gezondheids- en veiligheidseis**. ([EUR-Lex 2023/1230](https://eur-lex.europa.eu/eli/reg/2023/1230/oj/eng); [Nemko](https://www.nemko.com/blog/eu-machinery-regulation-2023/1230))

De herziene essentiële eisen van Bijlage III behandelen nu AI-gedrag, cyberbeveiliging, samenwerking tussen mens en robot, IoT-connectiviteit, de veiligheidsimpact van software-updates en functionele veiligheid. In gewone taal: veiligheidsgerelateerde besturingssystemen en software moeten immuun zijn voor zowel toevallige storingen *als* opzettelijke aanvallen, en het aansluiten van een apparaat op een machine mag geen gevaar veroorzaken. Cyberbeveiliging in machines is niet langer optioneel — het maakt deel uit van het veiligheidsdossier.

De twee wetten zijn doelbewust met elkaar verweven. Een veiligheidsgerelateerde AI-component in een machine is hoog risico onder de AI Act, en de machine zelf moet voldoen aan de veiligheids- en beveiligingseisen van de Machineverordening. De EU heeft expliciet stappen gezet om de overlap te verduidelijken, zodat een fabrikant niet twee tegenstrijdige conformiteitstrajecten voor één machine hoeft te doorlopen. ([IAPP](https://iapp.org/news/a/eu-agrees-to-amend-ai-act-clarifies-overlap-with-machinery-rules)) Voor een machinebouwer of een operator die nieuwe apparatuur in bedrijf stelt, loopt het compliant traject via **beide tegelijk** — precies waarom het classificatiewerk en de beveiligingstechniek in dezelfde kamer moeten plaatsvinden. Zie de pagina [Machineverordening](/nl/machine-act) voor de kant van machineveiligheid in dit verhaal.

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

## Bronnen

- Verordening (EU) 2024/1689 (AI Act), officiële tekst — [EUR-Lex](https://eur-lex.europa.eu/eli/reg/2024/1689/oj/eng)
- AI Act-beleid en -implementatie — [Europese Commissie, Shaping Europe's digital future](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai)
- Artikel 6 — classificatie van hoog-risicosystemen — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/article/6/)
- Artikel 15 — nauwkeurigheid, robuustheid en cyberbeveiliging — [AI Act Service Desk (EC)](https://ai-act-service-desk.ec.europa.eu/en/ai-act/article-15)
- Artikel 16 — verplichtingen aanbieder — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/article/16/)
- Artikel 26 — verplichtingen gebruiksverantwoordelijke — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/article/26/)
- Artikel 99 — sancties — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/article/99/)
- Artikel 101 — boetes GPAI-modellen — [AI Act Service Desk (EC)](https://ai-act-service-desk.ec.europa.eu/en/ai-act/article-101)
- Bijlage I — Unie-harmonisatiewetgeving (incl. machines) — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/annex/1/)
- Bijlage III — hoog-risicogebruikscasussen (incl. kritieke infrastructuur) — [artificialintelligenceact.eu](https://artificialintelligenceact.eu/annex/3/)
- Digital Omnibus — uitgestelde hoog-risicotermijnen (overeengekomen 7 mei 2026) — [Gibson Dunn](https://www.gibsondunn.com/eu-ai-act-omnibus-agreement-postponed-high-risk-deadlines-and-other-key-changes/); [Hogan Lovells](https://www.hoganlovells.com/en/publications/eu-legislators-agree-to-delay-for-highrisk-ai-rules)
- Conceptrichtsnoeren voor hoog-risicoclassificatie — [McCann FitzGerald](https://www.mccannfitzgerald.com/knowledge/construction-and-infrastructure/critical-infrastructure-spotlight-eu-ai-act-draft-guidelines-on-high-risk-ai-classification)
- EU-Machineverordening (EU) 2023/1230 — [EUR-Lex](https://eur-lex.europa.eu/eli/reg/2023/1230/oj/eng); overzicht cyberbeveiliging — [Nemko](https://www.nemko.com/blog/eu-machinery-regulation-2023/1230)
- Overlap AI Act / Machineverordening verduidelijkt — [IAPP](https://iapp.org/news/a/eu-agrees-to-amend-ai-act-clarifies-overlap-with-machinery-rules)

*Deze pagina bevat algemene informatie over EU-recht en vormt geen juridisch advies. Classificatie onder de AI Act is feitelijk bepaald; toets de status van uw systemen aan de verordening en, waar nodig, aan gekwalificeerd juridisch advies.*
