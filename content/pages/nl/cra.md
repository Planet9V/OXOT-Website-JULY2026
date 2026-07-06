---
title: De Cyber Resilience Act (CRA)
meta_title: Cyber Resilience Act (CRA) voor OT & producten met digitale elementen | OXOT
meta_description: De EU Cyber Resilience Act (Verordening (EU) 2024/2847) uitgelegd voor OT — reikwijdte, productklassen, eisen voor beveiliging en kwetsbaarheidsbeheer uit Bijlage I, SBOM, melding binnen 24 uur, ondersteuningsperiodes van circa 5 jaar, het tijdpad 2024→2027, sancties en de koppeling met IEC 62443.
excerpt: Security-by-design wordt een wettelijke voorwaarde voor markttoegang. Een praktische gids over de reikwijdte van de CRA, productklassen, Bijlage I, SBOM, melding binnen 24 uur, ondersteuningsperiodes en wat dit betekent voor OT-fabrikanten en -afnemers.
content_type: page
published: true
---

De Cyber Resilience Act is het antwoord van de Europese Unie op een simpel maar ongemakkelijk feit: digitale producten worden al decennialang op de markt gebracht met beveiliging als iets optioneels, en de rekening kwam terecht bij de gebruikers. De CRA verandert die afspraak. Voor het eerst wordt **beveiliging een wettelijke voorwaarde om een product met digitale elementen op de EU-markt te brengen** — van consumentenapparatuur tot de industriële regelaars, gateways en software waarmee operationele omgevingen draaien.

Als [NIS2](/nl/nis2) de wet is voor de *operators* die systemen draaien, dan is de CRA de wet voor de *makers* van de producten waaruit die systemen zijn opgebouwd. Industriële organisaties krijgen er doorgaans van beide kanten mee te maken: als afnemer die eindelijk beveiliging als recht kan eisen, en — als u producten bouwt, integreert of ingrijpend wijzigt — als fabrikant die nu verplichtingen draagt die worden ondersteund door boetes gekoppeld aan de omzet.

## De korte versie

- De CRA is **Verordening (EU) 2024/2847**. Zij **is op 10 december 2024 in werking getreden**. ([EUR-Lex, officiële tekst](https://eur-lex.europa.eu/eli/reg/2024/2847/oj/eng))
- Zij is van toepassing op **producten met digitale elementen** (PDE's) — hardware en software waarvan het beoogde of redelijkerwijs te voorziene gebruik een directe of indirecte gegevensverbinding met een apparaat of netwerk omvat.
- **Fabrikanten** dragen de kernverplichtingen: beveiliging door ontwerp en standaard, kwetsbaarheidsbeheer, een SBOM, en een vastgestelde **ondersteuningsperiode** van in de regel ten minste vijf jaar.
- De verplichtingen voor **kwetsbaarheids- en incidentmelding** gelden vanaf **11 september 2026**; de **hoofdverplichtingen** gelden vanaf **11 december 2027**. ([Europese Commissie](https://digital-strategy.ec.europa.eu/en/policies/cyber-resilience-act))
- Producten moeten voldoen aan de **essentiële eisen in Bijlage I** en de **CE-markering** dragen.
- **Actief uitgebuite kwetsbaarheden** en **ernstige incidenten** brengen een **vroegtijdige waarschuwing binnen 24 uur** teweeg aan ENISA en het nationale CSIRT, via één meldingsplatform.
- Sancties lopen op tot **€15 miljoen of 2,5% van de wereldwijde jaaromzet**, wat hoger is.

> [!IMPORTANT]
> De meldingsklok start eerder dan de hoofdverplichtingen. De detectie- en meldingsmachinerie moet operationeel zijn vóór **11 september 2026** — meer dan een jaar voordat u een CE-markering op het product zelf nodig heeft.

## Waarom de CRA bestaat

Twee structurele problemen lagen ten grondslag aan de wet. Ten eerste een **laag niveau van cyberbeveiliging** in veel digitale producten — zwakke standaardconfiguraties, ongepatchte kwetsbaarheden, geen duidelijke route om een fout te melden. Ten tweede een **ontoereikend begrip van en toegang tot informatie** bij gebruikers, die op het moment van aankoop geen onderscheid konden maken tussen een veilig en een onveilig product, en vaak geen beveiligingsupdates konden krijgen, zelfs als zij dat wilden. ([CRA-samenvatting, Europese Commissie](https://digital-strategy.ec.europa.eu/en/policies/cra-summary))

De oplossing legt de verantwoordelijkheid stroomopwaarts, bij de partij die het best in staat is om te handelen: de fabrikant. Zij hergebruikt de beproefde machinerie van het EU-productrecht — essentiële eisen, conformiteitsbeoordeling, CE-markering, markttoezicht — en richt die op cyberbeveiliging. "Secure by design" en "secure by default" zijn geen slogans meer, maar de prijs van markttoegang.

## Het tijdpad van de CRA

De verordening wordt in drie jaar gefaseerd ingevoerd. Onderstaande data zijn de data om op te plannen; in de tussenliggende periode moet het technische werk gebeuren.

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
  <text x="300" y="150" fill="#e5e7eb" font-size="12" text-anchor="middle">Meldings-</text>
  <text x="300" y="166" fill="#e5e7eb" font-size="12" text-anchor="middle">verplichtingen gelden</text>
  <text x="300" y="182" fill="#e5e7eb" font-size="12" text-anchor="middle">(art. 14)</text>
  <!-- milestone 3 -->
  <circle cx="510" cy="120" r="8" fill="#94a3b8"/>
  <line x1="510" y1="120" x2="510" y2="70" stroke="#94a3b8" stroke-width="1"/>
  <text x="510" y="58" fill="#e5e7eb" font-size="12" font-weight="bold" text-anchor="middle">Medio–eind 2026</text>
  <text x="510" y="150" fill="#e5e7eb" font-size="12" text-anchor="middle">Geharmoniseerde</text>
  <text x="510" y="166" fill="#e5e7eb" font-size="12" text-anchor="middle">normen verwacht</text>
  <!-- milestone 4 -->
  <circle cx="640" cy="120" r="9" fill="#3b82f6" stroke="#e5e7eb" stroke-width="2"/>
  <line x1="640" y1="120" x2="640" y2="70" stroke="#94a3b8" stroke-width="1"/>
  <text x="640" y="58" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">11 dec 2027</text>
  <text x="640" y="150" fill="#e5e7eb" font-size="12" text-anchor="middle">Hoofd-</text>
  <text x="640" y="166" fill="#e5e7eb" font-size="12" text-anchor="middle">verplichtingen</text>
  <text x="640" y="182" fill="#e5e7eb" font-size="12" text-anchor="middle">gelden</text>
  <text x="350" y="215" fill="#94a3b8" font-size="11" text-anchor="middle">Gefaseerde invoering over drie jaar — de doorlooptijd voor toetsing door derden is nu al kort</text>
</svg>
```

| Datum | Wat geldt |
|---|---|
| **10 december 2024** | De CRA treedt in werking. De klok start; verplichtingen worden vanaf hier gefaseerd ingevoerd. |
| **Medio–eind 2026** | Geharmoniseerde normen en detaillering van productclassificatie worden verwacht, wat fabrikanten de technische basis voor conformiteit geeft. |
| **11 september 2026** | De **verplichtingen voor kwetsbaarheids- en incidentmelding (artikel 14)** gelden. Het gemeenschappelijke ENISA-meldingsplatform moet dan operationeel zijn. ([EC — melding](https://digital-strategy.ec.europa.eu/en/policies/cra-reporting)) |
| **11 december 2027** | De **hoofdverplichtingen** — essentiële eisen, conformiteitsbeoordeling, CE-markering — gelden volledig. |

Het opzetten van processen voor veilige ontwikkeling en kwetsbaarheidsbeheer, het produceren van SBOM's en het regelen van toetsing door derden voor belangrijke en kritieke producten zijn meerjarige programma's, geen projecten voor het laatste kwartaal.

## Wat telt als een "product met digitale elementen"

De reikwijdte is bewust breed. Een **product met digitale elementen** is elk software- of hardwareproduct, en de bijbehorende oplossingen voor gegevensverwerking op afstand, waarvan het beoogde of redelijkerwijs te voorziene gebruik een **directe of indirecte logische of fysieke gegevensverbinding** met een apparaat of netwerk omvat.

In een industriële omgeving valt daar veel onder:

- **PLC's, RTU's en industriële regelaars** — de logica die het proces aanstuurt.
- **Protocolgateways en netwerkapparatuur** — de vertalers en routers tussen OT en IT.
- **HMI's en software voor engineeringwerkstations** — de mens-machine- en configuratielagen.
- **Industriële IoT-sensoren en edge-apparaten** — de groeiende populatie verbonden eindpunten.
- **Firmware en applicatiesoftware** die op al het bovenstaande draait, inclusief losse software die op zichzelf wordt verkocht.

Sommige categorieën zijn uitgesloten omdat zij al elders gereguleerd zijn — bepaalde medische hulpmiddelen, motorvoertuigen en luchtvaartproducten vallen onder hun eigen sectorale regimes in plaats van onder de CRA. Als uw product zich op een grensvlak bevindt (bijvoorbeeld machines met een digitaal besturingssysteem), leest u de CRA mogelijk naast de [Machineverordening](/nl/machine-act).

## Wie draagt de verplichtingen

De CRA volgt de waardeketen, en het gewicht is niet gelijk verdeeld.

| Rol | Kernverplichting onder de CRA |
|---|---|
| **Fabrikant** | Substantiële verplichtingen: veilig ontwerp, naleving van Bijlage I, SBOM, kwetsbaarheidsbeheer, ondersteuningsperiode, melding, conformiteitsbeoordeling, CE-markering. |
| **Importeur** | Mag geen niet-conforme producten op de markt brengen; moet verifiëren dat de fabrikant aan zijn verplichtingen heeft voldaan; treedt op bij non-conformiteit. |
| **Distributeur** | Handelt met de nodige zorgvuldigheid; mag geen producten op de markt aanbieden waarvan hij weet of zou moeten weten dat zij niet conform zijn. |

> [!WARNING]
> **U kunt "fabrikant" worden zonder uzelf ooit zo te noemen.** Als u een product onder uw eigen naam of merk op de markt brengt, of als u een product dat al op de markt is **ingrijpend wijzigt**, neemt u de verplichtingen van de fabrikant daarvoor over. Systeemintegratoren en operators die apparatuur ombouwen naar een eigen merk, firmware opnieuw flashen, of een apparaat aanzienlijk wijzigen, moeten precies weten waar die grens ligt — per product, vóór 2027.

Die trigger van "ingrijpende wijziging" is degene die OT-teams verrast. Een machinebouwer die een regelaar van een derde partij integreert en de lijn onder eigen naam levert, of een operator die een apparaat opnieuw imaget en het materieel gewijzigd terug in bedrijf stelt, kan de volledige verplichtingenstapel van de fabrikant erven. Breng nu al de rol per product in kaart, terwijl er nog tijd is om het proces te ontwerpen in plaats van erop te reageren.

## Productklassen en conformiteitsbeoordeling

Niet alle producten worden gelijk behandeld. De CRA rangschikt PDE's naar kriticiteit, en de klasse bepaalt hoe streng de conformiteit moet worden aangetoond. De classificatie volgt de kernfunctie van het product: past het bij een categorie in **Bijlage III**, dan is het *belangrijk* (klasse I of II); past het bij **Bijlage IV**, dan is het *kritiek*; past het bij geen van beide, dan is het *standaard*. ([EC — conformiteitsbeoordeling](https://digital-strategy.ec.europa.eu/en/policies/cra-conformity-assessment))

| Klasse | Voorbeelden (Bijlage III / IV) | Conformiteitsroute |
|---|---|---|
| **Standaard** | De grote meerderheid van producten, niet genoemd in een van beide bijlagen. | **Zelfbeoordeling** (interne controle) tegen de essentiële eisen. |
| **Belangrijk — klasse I** | Besturingssystemen, netwerkrouters, netwerkinterfaces, microcontrollers/microprocessors, bootmanagers, wachtwoordbeheerders, antivirussoftware. | Zelfbeoordeling **alleen als** geharmoniseerde normen / gemeenschappelijke specificaties worden toegepast; anders beoordeling door **derden** via een aangemelde instantie. |
| **Belangrijk — klasse II** | Firewalls, VPN's, virtualisatie-runtimes die OS-uitvoering ondersteunen. | Conformiteitsbeoordeling door **derden** via een **aangemelde instantie**. |
| **Kritiek** | Categorieën met de hoogste gevoeligheid en systeemrisico — bijv. hardwareapparaten met secure elements, slimme meters. | Kan **Europese cyberbeveiligingscertificering** onder het kader van de Cybersecurity Act vereisen. |

Veel industriële apparaten — netwerkapparatuur, beveiligingscomponenten, regelaars met veiligheids- of beveiligingsfuncties — vallen in de belangrijke of hogere categorieën. Dat betekent beoordeling door derden in plaats van een zelfverklaring, wat zowel de doorlooptijd als de kosten bepaalt. Classificeer de portfolio vroegtijdig; de beoordelingsroute, niet de code, is meestal de bepalende factor voor het tijdschema.

## Bijlage I, deel I — de beveiligingseigenschappen van het product

Bijlage I is waar de CRA concreet wordt, en zij bestaat uit twee delen. **Deel I** regelt hoe het product zelf zich moet gedragen. Producten moeten zodanig worden ontworpen, ontwikkeld en geproduceerd dat een passend cyberbeveiligingsniveau op basis van de risico's wordt gewaarborgd. ([CRA-bijlagen](https://www.cyberresilienceact.eu/annexes.html))

| Beveiligingseigenschap | Wat het in de praktijk vereist |
|---|---|
| **Geen bekende, uitbuitbare kwetsbaarheden** | Lever producten zonder bekende, uitbuitbare fouten — kwetsbaarheidsbeheer vóór, niet na, de release. |
| **Standaard veilig (secure by default)** | Geleverd met een veilige configuratie uit de doos; het veilige pad is het standaardpad. |
| **Toegangscontrole & authenticatie** | Bescherming tegen ongeautoriseerde toegang met passende authenticatie- en identiteitscontroles. |
| **Vertrouwelijkheid & integriteit** | Bescherming van gegevens en opdrachten in rust, tijdens transport en tijdens verwerking — encryptie en integriteitscontroles. |
| **Dataminimalisatie** | Verwerk alleen gegevens die adequaat, relevant en beperkt zijn tot wat het product nodig heeft. |
| **Beschikbaarheid & veerkracht** | Bescherm essentiële functies; weersta en herstel van denial-of-service. |
| **Geminimaliseerd aanvalsoppervlak** | Beperk blootgestelde interfaces, diensten en externe afhankelijkheden. |
| **Beperking van uitbuiting** | Pas passende hardening- en mitigatietechnieken toe. |
| **Beveiligingslogging & -monitoring** | Registreer en monitor relevante activiteit; geef operators inzicht in wat er is gebeurd. |
| **Veilige updates** | Voorzie in beveiligingsupdates, waar mogelijk automatisch, met een duidelijke opt-out. |

Voor OT lezen verschillende van deze punten als een to-dolijst die de sector al tien jaar in whitepapers schrijft — nu met wettelijke kracht erachter.

## Bijlage I, deel II — kwetsbaarheidsbeheer en de SBOM

**Deel II** regelt het proces dat een fabrikant gedurende de hele ondersteuningsperiode moet uitvoeren. Dit is de operationele discipline achter de beveiligingseigenschappen van het product.

| Verplichting kwetsbaarheidsbeheer | Wat het betekent |
|---|---|
| **Componenten identificeren & documenteren** | Weet wat er in het product zit, inclusief een **software bill of materials (SBOM)** die de belangrijkste afhankelijkheden dekt. |
| **Onverwijld verhelpen** | Pak kwetsbaarheden onverwijld aan en verhelp ze, onder meer via **gratis beveiligingsupdates** gedurende de ondersteuningsperiode. |
| **Regelmatig testen** | Pas effectieve, regelmatige beveiligingstests en -reviews toe. |
| **Gecoördineerde openbaarmaking** | Voer een beleid voor gecoördineerde openbaarmaking van kwetsbaarheden. |
| **Openbare bekendmaking van oplossingen** | Deel, zodra een oplossing beschikbaar is, informatie over verholpen kwetsbaarheden met een beschrijving. |
| **Meldingscontact** | Bied één centraal aanspreekpunt voor het melden van kwetsbaarheden. |
| **Veilige distributie** | Verspreid updates op veilige wijze en, waar relevant, snel en kosteloos. |

> [!NOTE]
> **Waarom de SBOM belangrijker is dan hij lijkt.** Industriële producten zijn opgebouwd uit lagen van componenten van derden en open source. De SBOM-verplichting dwingt fabrikanten om daadwerkelijk te weten wat er in hun producten zit en de kwetsbaarheden van die componenten te volgen. Voor operators is een SBOM van een leverancier een directe input voor uw eigen risicobeeld — en een redelijke eis om al ruim vóór 2027 in de inkoop te stellen.

## De levenscyclus van verplichtingen voor de fabrikant

Van begin tot eind beschrijft de CRA een levenscyclus, geen eenmalige poort. Veilig ontwerp voedt een SBOM; de SBOM en naleving van Bijlage I ondersteunen de conformiteit en de CE-markering; eenmaal op de markt lopen kwetsbaarheidsbeheer en updates gedurende de hele ondersteuningsperiode, met melding daar bovenop.

```svg
<svg viewBox="0 0 700 300" xmlns="http://www.w3.org/2000/svg" font-family="system-ui, sans-serif">
  <!-- top row blocks -->
  <rect x="20" y="40" width="150" height="60" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="95" y="66" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Veilig ontwerp</text>
  <text x="95" y="84" fill="#94a3b8" font-size="11" text-anchor="middle">Bijlage I, deel I</text>

  <rect x="200" y="40" width="150" height="60" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="275" y="66" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">SBOM &amp;</text>
  <text x="275" y="84" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">componenten</text>

  <rect x="380" y="40" width="150" height="60" rx="8" fill="none" stroke="#3b82f6" stroke-width="2"/>
  <text x="455" y="66" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Conformiteit</text>
  <text x="455" y="84" fill="#94a3b8" font-size="11" text-anchor="middle">beoordeling + CE</text>

  <rect x="540" y="40" width="140" height="60" rx="8" fill="#3b82f6" fill-opacity="0.12" stroke="#3b82f6" stroke-width="2"/>
  <text x="610" y="76" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Op de markt</text>

  <!-- arrows top row -->
  <line x1="170" y1="70" x2="200" y2="70" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr)"/>
  <line x1="350" y1="70" x2="380" y2="70" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr)"/>
  <line x1="530" y1="70" x2="540" y2="70" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr)"/>

  <!-- down into lifecycle band -->
  <line x1="610" y1="100" x2="610" y2="160" stroke="#94a3b8" stroke-width="2" marker-end="url(#arr)"/>

  <!-- lifecycle band -->
  <rect x="60" y="170" width="440" height="70" rx="8" fill="none" stroke="#f97316" stroke-width="2"/>
  <text x="280" y="198" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Kwetsbaarheidsbeheer &amp; beveiligingsupdates</text>
  <text x="280" y="220" fill="#94a3b8" font-size="11" text-anchor="middle">Ondersteuningsperiode — in de regel ≥ 5 jaar (Bijlage I, deel II)</text>

  <rect x="530" y="170" width="150" height="70" rx="8" fill="#f97316" fill-opacity="0.12" stroke="#f97316" stroke-width="2"/>
  <text x="605" y="198" fill="#e5e7eb" font-size="13" font-weight="bold" text-anchor="middle">Melding</text>
  <text x="605" y="218" fill="#94a3b8" font-size="11" text-anchor="middle">24u / 72u / eind</text>

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

## De ondersteuningsperiode — een nieuwe vorm voor leveranciersrelaties

Een van de meest praktisch ingrijpende eisen van de CRA is de **ondersteuningsperiode**: fabrikanten moeten beveiligingsupdates leveren gedurende een periode die passend is voor het product, en **in de regel ten minste vijf jaar** (korter alleen als het product naar verwachting korter in gebruik zal zijn). Technische documentatie en de EU-conformiteitsverklaring moeten ten minste tien jaar worden bewaard, of de ondersteuningsperiode indien deze langer is.

Voor industriële apparatuur die routinematig een decennium of langer meegaat, verandert dit de commerciële relatie fundamenteel. Beveiligingsondersteuning is niet langer een geste van goede wil die vervalt zodra een productlijn wordt uitgefaseerd, maar wordt een wettelijke verwachting over een vastgestelde levensduur. Voor afnemers is de ondersteuningsperiode een onderhandelingsanker: u kunt een leverancier houden aan een gestelde termijn, en u kunt vragen wat er gebeurt bij het einde van de ondersteuning voordat u tekent.

## Melding — de klok van 24 uur

De CRA introduceert een scherp, gefaseerd meldingsregime onder **artikel 14**. **Actief uitgebuite kwetsbaarheden** en **ernstige incidenten** die de productbeveiliging aantasten, moeten via één meldingsplatform worden gemeld aan het nationale **CSIRT** van de fabrikant en, gelijktijdig, aan **ENISA**. ([EC — melding](https://digital-strategy.ec.europa.eu/en/policies/cra-reporting))

| Fase | Termijn | Inhoud |
|---|---|---|
| **Vroegtijdige waarschuwing** | Binnen **24 uur** nadat men zich ervan bewust is geworden | Eerste melding dat er een actief uitgebuite kwetsbaarheid of ernstig incident bestaat. |
| **Kennisgeving** | Binnen **72 uur** | Uitgebreidere details, inclusief genomen corrigerende of mitigerende maatregelen. |
| **Eindverslag** | **14 dagen** (kwetsbaarheid, nadat een oplossing beschikbaar is) / **1 maand** (ernstig incident) | Beschrijving, ernst, impact en herstelmaatregelen. ([CRA-meldingstermijnen](https://www.cyberresilienceact.eu/reporting.html)) |

Twee operationele gevolgen. Ten eerste treedt deze verplichting in werking op **11 september 2026**, vóór de hoofdwet — dus moet de pijplijn voor detectie, triage en openbaarmaking al bestaan voordat het werk aan de productconformiteit zelfs maar is afgerond. Ten tweede is de melding een eenmalige indiening: één rapport via het platform bereikt het CSIRT en ENISA, die het vervolgens doorgeven aan andere getroffen CSIRT's. Micro- en kleine ondernemingen krijgen enige verlichting van sancties bij het missen van de termijn van 24 uur voor kwetsbaarheden, maar de verplichting zelf blijft gelden.

> [!TIP]
> Behandel CRA-melding en uw [NIS2](/nl/nis2)-incidentmelding als één detectie- en responscapaciteit, niet als twee. De onderliggende vaardigheid — een ernstige gebeurtenis signaleren, bepalen dat deze meldingsplichtig is, en binnen een dag een eerste melding versturen — is dezelfde. Bouw dit één keer.

## Sancties

Niet-naleving van de **essentiële eisen of de kernverplichtingen van de fabrikant** kan boetes opleveren tot **€15 miljoen of 2,5% van de totale wereldwijde jaaromzet**, wat hoger is. Voor andere inbreuken en voor het verstrekken van onjuiste, onvolledige of misleidende informatie gelden lagere maxima.

| Inbreuk | Maximum (het hoogste van) |
|---|---|
| Essentiële eisen (Bijlage I) & kernverplichtingen van de fabrikant | **€15 miljoen of 2,5%** van de wereldwijde jaaromzet |
| Overige CRA-verplichtingen | **€10 miljoen of 2%** van de wereldwijde jaaromzet |
| Onjuiste, onvolledige of misleidende informatie aan autoriteiten / aangemelde instanties | **€5 miljoen of 1%** van de wereldwijde jaaromzet |

Net als bij NIS2 en de [AI-verordening](/nl/ai-act) is de koppeling aan de omzet bewust: productbeveiliging is nu een commercieel risico op bestuursniveau, geen post die uitsluitend binnen engineering leeft en sterft. ([Pillsbury — CRA-vereisten](https://www.pillsburylaw.com/en/news-and-insights/eu-cyber-resilience-act-requirements-products-software.html))

## De CRA en OT — twee kanten van dezelfde medaille

De CRA en NIS2 zijn complementaire helften van één strategie. **[NIS2](/nl/nis2)** verplicht operators om het risico van de systemen die zij draaien te beheren; de CRA verplicht fabrikanten om die systemen om te beginnen beveiligbaar te maken. De supply-chainverplichting van een operator onder NIS2 (artikel 21) wordt veel makkelijker na te komen wanneer de producten in de keten CRA-conform zijn — met SBOM's, beveiligingsupdates en een ondersteuningstoezegging in plaats van een schouderophaal.

### De CRA koppelen aan IEC 62443

**[IEC 62443](/nl/iec-62443)** is de natuurlijke technische brug voor OT-leveranciers. De proces- en componentnormen sluiten nauw aan bij Bijlage I, zodat een fabrikant die al volgens 62443 bouwt, veel van het voorbereidende werk voor de CRA al heeft gedaan. De koppeling is niet één-op-één, maar wel dicht genoeg om te hergebruiken.

| CRA-verplichting | Dichtstbijzijnde IEC 62443-anker |
|---|---|
| Veilige ontwikkellevenscyclus (Bijlage I, deel II, proces) | **IEC 62443-4-1** — eisen voor een veilige productontwikkellevenscyclus |
| Beveiligingseigenschappen van product/component (Bijlage I, deel I) | **IEC 62443-4-2** — technische beveiligingseisen voor componenten |
| Beveiligingscapaciteiten op systeemniveau | **IEC 62443-3-3** — systeembeveiligingseisen en beveiligingsniveaus |
| Kwetsbaarheidsbeheer, openbaarmaking, patchbeheer | **IEC 62443-4-1**-praktijken (defect-/patchbeheer, richtlijnen voor beveiligingsupdates) |
| SBOM / componenteninventaris | Componentbeheer binnen 62443-4-1, uitgebreid met de expliciete SBOM-verplichting van de CRA |

Het op elkaar afstemmen van beide voorkomt dubbel werk en geeft een verdedigbare, internationaal erkende basis voor conformiteit. Waar de CRA juridisch bindend maar normneutraal is, levert 62443 de concrete technische inhoud — een combinatie die ook goed past binnen het bredere landschap van [frameworks](/nl/frameworks).

Specifiek voor OT is de CRA het mechanisme dat, na verloop van tijd, de beveiligingsvloer moet verhogen van de regelaars, gateways en software waaruit industriële systemen bestaan — waardoor de kloof wordt gedicht die operators jarenlang hebben overbrugd met segmentatie en monitoring.

## Het traject naar gereedheid voor de fabrikant

CRA-conformiteit bereiken is een reeks stappen, geen schakelaar. Onderstaande vijf fasen volgen hoe de meeste OT-productteams zullen bewegen van "bewust van de deadline" naar "CE-markering verdedigbaar."

```carousel
Fase 1 — Bepaal de reikwijdte en classificeer
Inventariseer elk product met digitale elementen dat u op de EU-markt brengt. Bepaal voor elk product de klasse: standaard, belangrijk klasse I/II, of kritiek. De klasse bepaalt uw conformiteitsroute en daarmee uw tijdschema. Dit is ook het moment waarop u de producten vindt waarvoor u stilzwijgend "fabrikant" bent geworden door rebranding of ingrijpende wijziging.
---
Fase 2 — Voer een gap-analyse uit tegen Bijlage I
Meet elk product tegen Bijlage I, deel I (beveiligingseigenschappen) en deel II (kwetsbaarheidsbeheer). Teams die al zijn afgestemd op IEC 62443-4-1/4-2 zullen merken dat veel hiervan overeenkomt. Het resultaat is een geprioriteerde lijst met tekortkomingen, geen slaag/zak-oordeel — de meeste producten hebben werk nodig op een handvol specifieke punten, geen volledige herbouw.
---
Fase 3 — Bouw de machine voor kwetsbaarheidsbeheer
Zet de SBOM-pijplijn op, evenals het beleid voor gecoördineerde openbaarmaking, het meldingscontact, het testritme en het mechanisme voor veilige updates. Dit is het onderdeel dat vóór 11 september 2026 operationeel moet zijn voor melding, dus het loopt voor op het schema — vóór het werk aan de productconformiteit zelf.
---
Fase 4 — Conformiteitsbeoordeling en CE
Doorloop de toepasselijke procedure: zelfbeoordeling voor standaard en (met geharmoniseerde normen) klasse I, of een aangemelde instantie voor klasse II en kritiek. Stel technische documentatie samen, geef de EU-conformiteitsverklaring af en breng de CE-markering aan. De capaciteit van aangemelde instanties is beperkt — boek vroeg.
---
Fase 5 — Werk gedurende de ondersteuningsperiode
Houd updates, monitoring en openbaarmaking in stand gedurende de ondersteuningsperiode — in de regel ten minste vijf jaar. Bewaar technische documentatie tien jaar. Koppel bevindingen uit het veld terug naar het ontwerp. Conformiteit is een toestand die u onderhoudt, geen certificaat dat u archiveert en vergeet.
```

## Wat het betekent voor uw rol

**Als u industriële producten fabriceert, integreert of herbrandt**, is de CRA een directe nalevingsverplichting met een harde deadline in 2027 en een meldingsmoment in 2026. Classificeer de portfolio, bouw processen voor veilige ontwikkeling en kwetsbaarheidsbeheer, produceer SBOM's, verbind u aan een ondersteuningsperiode, en regel — voor belangrijke en kritieke producten — de conformiteitsbeoordeling zolang er plekken bij aangemelde instanties beschikbaar zijn.

**Als u operator of afnemer bent**, is de CRA hefboomkracht. Vanaf 2027 moeten de producten die u koopt voldoen aan de essentiële eisen; al eerder kunt u CRA-conforme verwachtingen — een SBOM, gratis beveiligingsupdates, een gestelde ondersteuningstermijn, een contactpunt voor openbaarmaking — opnemen in inkoop- en aanbestedingscriteria. De wet geeft afnemers een vocabulaire die zij nooit eerder hadden.

**Als u in het bestuur van een fabrikant zit**, voegt de CRA nog een aan omzet gekoppeld sanctieregime toe en maakt productbeveiliging tot een governancekwestie met een vastgesteld tijdpad. De vraag aan het management is niet "zijn we compliant?" maar "welke producten volgen welke conformiteitsroute, en wat is het kritieke pad naar 2027?"

## Hoe OXOT helpt

OXOT werkt aan beide kanten van de CRA. Voor **operators** integreren wij CRA-conforme eisen in inkoop en in de supply-chaindimensie van uw NIS2- en OT-beveiligingsprogramma's, en onze **[Cyber Digital Twin](/nl/cyber-digital-twin)** geeft u een gestructureerde plek om leveranciers-SBOM's en componentenrisico's vast te leggen, zodat een nieuwe CVE in een gedeelde bibliotheek een opzoekactie is, geen brandoefening. Voor **fabrikanten en integratoren** vertalen wij Bijlage I naar een technisch programma dat is afgestemd op [IEC 62443](/nl/iec-62443)-4-1/4-2 — waardoor de regelgeving een concreet, onderbouwd pad naar conformiteit wordt in plaats van een compliance-race.

*OXOT's CRA Readiness-materialen — inclusief ons op de bijlagen afgestemde gereedheidsoverzicht en onze voorbereidingsdienst — worden hier gelinkt als een uitgebreidere bron.*

## Veelgestelde vragen

**Is de CRA ook van toepassing op software, en niet alleen op hardware?**
Ja. Losse software is een product met digitale elementen. Firmware en applicatiesoftware vallen beide binnen de reikwijdte, onder voorbehoud van de sectorale uitzonderingen (bepaalde medische, automotive en luchtvaartproducten die elders worden gereguleerd).

**Wij integreren regelaars van derden in onze machines. Zijn wij fabrikant onder de CRA?**
Mogelijk. Als u het geïntegreerde product onder uw eigen naam op de markt brengt, of componenten ingrijpend wijzigt, kunt u de verplichtingen van de fabrikant overnemen. Breng uw rol per product in kaart vóór 2027 — en houd de grens van "ingrijpende wijziging" nauwlettend in de gaten.

**Is een SBOM echt verplicht?**
Bijlage I, deel II vereist dat fabrikanten componenten identificeren en documenteren, inclusief het opstellen van een software bill of materials, als onderdeel van kwetsbaarheidsbeheer. Behandel dit als een kernresultaat, geen optionele extra.

**Wanneer precies moeten wij beginnen met melden?**
De meldingsverplichtingen van artikel 14 gelden vanaf **11 september 2026** — eerder dan de hoofdverplichtingen. Een actief uitgebuite kwetsbaarheid of ernstig incident brengt een vroegtijdige waarschuwing binnen 24 uur teweeg, een kennisgeving binnen 72 uur, en een eindverslag (14 dagen voor een kwetsbaarheid zodra deze is verholpen, één maand voor een ernstig incident).

**Hoe lang moeten wij een product ondersteunen?**
In de regel ten minste vijf jaar, of de verwachte gebruiksduur van het product indien korter. Bewaar technische documentatie en de conformiteitsverklaring ten minste tien jaar, of de ondersteuningsperiode indien deze langer is.

**Hoe verhoudt de CRA zich tot de AI-verordening, NIS2 en de Machineverordening?**
De **[AI-verordening](/nl/ai-act)** reguleert AI-systemen, de CRA reguleert producten met digitale elementen, **[NIS2](/nl/nis2)** reguleert operators, en de **[Machineverordening](/nl/machine-act)** reguleert machineveiligheid inclusief digitale besturing. Een verbonden industriële machine met een AI-veiligheidscomponent kan met alle vier te maken krijgen — precies waarom één samenhangend OT-beveiligingsprogramma beter is dan vier losstaande complianceinspanningen.

## Bronnen

- Verordening (EU) 2024/2847 (Cyber Resilience Act), officiële tekst — [EUR-Lex](https://eur-lex.europa.eu/eli/reg/2024/2847/oj/eng)
- Overzicht van het Cyber Resilience Act-beleid — [Europese Commissie](https://digital-strategy.ec.europa.eu/en/policies/cyber-resilience-act)
- Samenvatting van de CRA-wetstekst — [Europese Commissie](https://digital-strategy.ec.europa.eu/en/policies/cra-summary)
- CRA-conformiteitsbeoordeling — [Europese Commissie](https://digital-strategy.ec.europa.eu/en/policies/cra-conformity-assessment)
- CRA-meldingsverplichtingen — [Europese Commissie](https://digital-strategy.ec.europa.eu/en/policies/cra-reporting)
- Reikwijdte, klassen en deadlines van de CRA — [cyberresilienceact.eu](https://www.cyberresilienceact.eu/explained.html)
- CRA-bijlagen I–VIII, essentiële eisen en productlijsten — [cyberresilienceact.eu](https://www.cyberresilienceact.eu/annexes.html)
- CRA-meldingstermijnen (artikel 14) — [cyberresilienceact.eu](https://www.cyberresilienceact.eu/reporting.html)
- CRA-vereisten voor verbonden producten en software — [Pillsbury Law](https://www.pillsburylaw.com/en/news-and-insights/eu-cyber-resilience-act-requirements-products-software.html)

*Deze pagina bevat algemene informatie over EU-wetgeving en vormt geen juridisch advies. Bevestig hoe de CRA van toepassing is op uw producten en rol aan de hand van de verordening en, waar nodig, gekwalificeerd juridisch advies.*
