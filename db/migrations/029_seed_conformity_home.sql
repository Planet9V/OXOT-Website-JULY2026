-- 029_seed_conformity_home.sql
-- Seed the admin-editable conformity home page content into site_blocks under the
-- NEW key 'conformity_home', for both locales (en, nl). Source of truth is the two
-- JSON files data/conformity_home_{en,nl}.json (copy inlined verbatim below).
--
-- ON CONFLICT (key, locale) DO NOTHING: this seeds the INITIAL content once and then
-- LEAVES ADMIN EDITS ALONE. After the first seed the admin owns this content; re-running
-- the migration will not overwrite anything a human edited. Idempotent + re-runnable.
--
-- site_blocks is created by migration 007_site_blocks.sql (PRIMARY KEY (key, locale)).

INSERT INTO site_blocks (key, locale, data) VALUES
  ('conformity_home', 'en', $json$
{
  "hero": {
    "eyebrow": "Compliance, engineered",
    "title": "Four regulations. One evidence system.",
    "subtitle": "OXOT unifies the Cyber Resilience Act, the AI Act, the Machinery Regulation and IEC 62443 into a single, living source of conformity evidence — so your teams prove compliance instead of chasing it.",
    "primaryCta": {
      "label": "Explore the platform",
      "href": "/conformity-platform"
    },
    "secondaryCta": {
      "label": "See our approach",
      "href": "/industrial-operations"
    },
    "bullets": [
      "Overlap mapped once, reused everywhere",
      "Audit-ready evidence, always current",
      "Engineers stay in their tools"
    ]
  },
  "logoWall": {
    "title": "Built for the regulations reshaping industrial products",
    "logos": [
      "Cyber Resilience Act",
      "EU AI Act",
      "Machinery Regulation 2023/1230",
      "IEC 62443",
      "NIS2 Directive",
      "Radio Equipment Directive"
    ]
  },
  "stats": [
    {
      "value": "4-in-1",
      "label": "regulations",
      "sublabel": "mapped to one control set"
    },
    {
      "value": "70%",
      "label": "less duplicate work",
      "sublabel": "across overlapping requirements"
    },
    {
      "value": "Weeks",
      "label": "not quarters",
      "sublabel": "to an audit-ready dossier"
    },
    {
      "value": "100%",
      "label": "traceable",
      "sublabel": "every claim linked to evidence"
    }
  ],
  "featureGrid": {
    "eyebrow": "The platform",
    "title": "Everything a conformity dossier needs, in one place",
    "subtitle": "Stop maintaining four parallel spreadsheets. OXOT models the shared reality underneath every regulation and keeps it current as your product evolves.",
    "features": [
      {
        "title": "Unified control library",
        "description": "One requirement model spanning CRA, AI Act, Machinery and IEC 62443 — mapped, deduplicated and versioned.",
        "icon": "Library"
      },
      {
        "title": "Living evidence",
        "description": "Link tickets, tests, SBOMs and design docs to controls. Evidence updates as your product does.",
        "icon": "FileCheck"
      },
      {
        "title": "Gap detection",
        "description": "See exactly which obligations are covered, partial or open — per product, per regulation, in real time.",
        "icon": "ScanSearch"
      },
      {
        "title": "Audit-ready export",
        "description": "Generate a structured technical file and declaration of conformity your notified body can actually follow.",
        "icon": "FileOutput"
      },
      {
        "title": "Risk & threat modeling",
        "description": "Structured risk assessments aligned to IEC 62443 and the AI Act, reusable across product lines.",
        "icon": "ShieldAlert"
      },
      {
        "title": "Expert in the loop",
        "description": "OXOT consultants review your dossier and coach your team — the platform never leaves you alone with the hard calls.",
        "icon": "Users"
      }
    ]
  },
  "problem": {
    "eyebrow": "The problem",
    "title": "The regulations overlap. Your tooling doesn't.",
    "body": "CRA wants secure-by-design evidence. IEC 62443 wants the same, in its own language. The Machinery Regulation adds safety. The AI Act adds risk management. Most teams answer each one separately — and pay for the same work four times.",
    "bullets": [
      "Duplicate requirements re-documented per framework",
      "Evidence that goes stale the moment code ships",
      "No single view of what is actually covered"
    ],
    "cta": {
      "label": "See how we fix it",
      "href": "/industrial-operations"
    }
  },
  "shift": {
    "eyebrow": "The shift",
    "title": "Prove conformity as a by-product of building",
    "body": "OXOT maps every obligation to a shared control once, then wires those controls to the evidence your teams already produce. Compliance stops being a project and becomes a property of how you work.",
    "bullets": [
      "One control satisfies many regulations",
      "Engineers contribute evidence without leaving their tools",
      "Leadership sees conformity status at a glance"
    ],
    "cta": {
      "label": "Explore the platform",
      "href": "/conformity-platform"
    }
  },
  "comparison": {
    "eyebrow": "Why OXOT",
    "title": "One system versus four silos",
    "subtitle": "What changes when overlapping regulations share a single evidence backbone.",
    "columns": [
      "Four separate efforts",
      "OXOT unified system"
    ],
    "rows": [
      {
        "label": "Requirement mapping",
        "left": "Repeated per regulation",
        "right": true
      },
      {
        "label": "Evidence freshness",
        "left": "Manual, drifts quickly",
        "right": true
      },
      {
        "label": "Cross-regulation reuse",
        "left": "",
        "right": true
      },
      {
        "label": "Audit preparation",
        "left": "Quarter-long scramble",
        "right": true
      },
      {
        "label": "Expert guidance",
        "left": "Ad-hoc consultants",
        "right": true
      },
      {
        "label": "Real-time coverage view",
        "left": "",
        "right": true
      }
    ]
  },
  "steps": {
    "eyebrow": "How it works",
    "title": "From scattered documents to a living dossier",
    "steps": [
      {
        "number": "01",
        "title": "Scope",
        "description": "We map your products to the regulations that apply and the controls they share."
      },
      {
        "number": "02",
        "title": "Connect",
        "description": "Evidence sources — tests, SBOMs, risk assessments — are wired into the control model."
      },
      {
        "number": "03",
        "title": "Close gaps",
        "description": "OXOT surfaces what's open; our experts help you close it efficiently."
      },
      {
        "number": "04",
        "title": "Sustain",
        "description": "The dossier stays current automatically, ready for audit at any moment."
      }
    ]
  },
  "quote": {
    "quote": "We used to treat every regulation as a separate fire drill. With OXOT the evidence writes itself once and answers all of them.",
    "author": "Head of Product Security",
    "role": "Industrial automation vendor"
  },
  "faq": {
    "eyebrow": "Questions",
    "title": "What teams ask before starting",
    "items": [
      {
        "question": "Which regulations does OXOT cover?",
        "answer": "The Cyber Resilience Act, the EU AI Act, the Machinery Regulation (2023/1230) and IEC 62443, with adjacent frameworks like NIS2 mapped in."
      },
      {
        "question": "Is this software or consulting?",
        "answer": "Both. The platform maintains your evidence; OXOT experts review dossiers and guide your team through the hard decisions."
      },
      {
        "question": "Do our engineers have to learn a new tool?",
        "answer": "Minimally. Evidence is pulled from the systems they already use, so contribution happens in the flow of their work."
      },
      {
        "question": "How quickly can we be audit-ready?",
        "answer": "Most teams reach an audit-ready dossier in weeks rather than quarters, because overlapping work is only done once."
      }
    ]
  },
  "cta": {
    "title": "See your conformity status in one view",
    "subtitle": "Book a walkthrough and we'll map your products to the regulations that matter.",
    "primaryCta": {
      "label": "Talk to OXOT",
      "href": "/contact"
    },
    "secondaryCta": {
      "label": "Explore the platform",
      "href": "/conformity-platform"
    }
  }
}
$json$::jsonb),
  ('conformity_home', 'nl', $json$
{
  "hero": {
    "eyebrow": "Conformiteit, doordacht",
    "title": "Vier regelgevingen. Eén bewijssysteem.",
    "subtitle": "OXOT verenigt de Cyber Resilience Act, de AI Act, de Machineverordening en IEC 62443 in één levende bron van conformiteitsbewijs — zodat uw teams conformiteit aantonen in plaats van najagen.",
    "primaryCta": {
      "label": "Ontdek het platform",
      "href": "/conformity-platform"
    },
    "secondaryCta": {
      "label": "Bekijk onze aanpak",
      "href": "/industrial-operations"
    },
    "bullets": [
      "Overlap eenmaal in kaart, overal hergebruikt",
      "Auditklaar bewijs, altijd actueel",
      "Ingenieurs blijven in hun tools"
    ]
  },
  "logoWall": {
    "title": "Gebouwd voor de regelgeving die industriële producten hervormt",
    "logos": [
      "Cyber Resilience Act",
      "EU AI Act",
      "Machinery Regulation 2023/1230",
      "IEC 62443",
      "NIS2 Directive",
      "Radio Equipment Directive"
    ]
  },
  "stats": [
    {
      "value": "4-in-1",
      "label": "regelgevingen",
      "sublabel": "op één set controles"
    },
    {
      "value": "70%",
      "label": "minder dubbel werk",
      "sublabel": "over overlappende eisen"
    },
    {
      "value": "Weken",
      "label": "geen kwartalen",
      "sublabel": "tot een auditklaar dossier"
    },
    {
      "value": "100%",
      "label": "traceerbaar",
      "sublabel": "elke claim gekoppeld aan bewijs"
    }
  ],
  "featureGrid": {
    "eyebrow": "Het platform",
    "title": "Alles wat een conformiteitsdossier nodig heeft, op één plek",
    "subtitle": "Stop met het bijhouden van vier parallelle spreadsheets. OXOT modelleert de gedeelde werkelijkheid onder elke regelgeving en houdt die actueel terwijl uw product evolueert.",
    "features": [
      {
        "title": "Uniforme controlebibliotheek",
        "description": "Eén eisenmodel over CRA, AI Act, Machinerichtlijn en IEC 62443 — gekoppeld, ontdubbeld en geversioneerd.",
        "icon": "Library"
      },
      {
        "title": "Levend bewijs",
        "description": "Koppel tickets, tests, SBOM's en ontwerpdocumenten aan controles. Bewijs werkt mee met uw product.",
        "icon": "FileCheck"
      },
      {
        "title": "Gatdetectie",
        "description": "Zie precies welke verplichtingen gedekt, gedeeltelijk of open zijn — per product, per regelgeving, realtime.",
        "icon": "ScanSearch"
      },
      {
        "title": "Auditklare export",
        "description": "Genereer een gestructureerd technisch dossier en conformiteitsverklaring die uw aangemelde instantie kan volgen.",
        "icon": "FileOutput"
      },
      {
        "title": "Risico- en dreigingsmodellering",
        "description": "Gestructureerde risicoanalyses conform IEC 62443 en de AI Act, herbruikbaar over productlijnen.",
        "icon": "ShieldAlert"
      },
      {
        "title": "Expert in de lus",
        "description": "OXOT-consultants beoordelen uw dossier en coachen uw team — het platform laat u nooit alleen met de moeilijke keuzes.",
        "icon": "Users"
      }
    ]
  },
  "problem": {
    "eyebrow": "Het probleem",
    "title": "De regelgeving overlapt. Uw tooling niet.",
    "body": "CRA wil secure-by-design bewijs. IEC 62443 wil hetzelfde, in eigen taal. De Machineverordening voegt veiligheid toe. De AI Act voegt risicobeheer toe. De meeste teams beantwoorden elk apart — en betalen vier keer voor hetzelfde werk.",
    "bullets": [
      "Dubbele eisen per raamwerk opnieuw gedocumenteerd",
      "Bewijs dat veroudert zodra code live gaat",
      "Geen enkel overzicht van wat werkelijk gedekt is"
    ],
    "cta": {
      "label": "Zie hoe wij dit oplossen",
      "href": "/industrial-operations"
    }
  },
  "shift": {
    "eyebrow": "De omslag",
    "title": "Toon conformiteit als bijproduct van het bouwen",
    "body": "OXOT koppelt elke verplichting eenmalig aan een gedeelde controle en verbindt die controles met het bewijs dat uw teams al produceren. Conformiteit is geen project meer, maar een eigenschap van hoe u werkt.",
    "bullets": [
      "Eén controle voldoet aan meerdere regelgevingen",
      "Ingenieurs leveren bewijs zonder hun tools te verlaten",
      "Leiding ziet de conformiteitsstatus in één oogopslag"
    ],
    "cta": {
      "label": "Ontdek het platform",
      "href": "/conformity-platform"
    }
  },
  "comparison": {
    "eyebrow": "Waarom OXOT",
    "title": "Eén systeem versus vier silo's",
    "subtitle": "Wat verandert wanneer overlappende regelgeving één bewijsruggengraat deelt.",
    "columns": [
      "Vier losse trajecten",
      "OXOT uniform systeem"
    ],
    "rows": [
      {
        "label": "Eisen in kaart brengen",
        "left": "Per regelgeving herhaald",
        "right": true
      },
      {
        "label": "Actualiteit van bewijs",
        "left": "Handmatig, verschuift snel",
        "right": true
      },
      {
        "label": "Hergebruik over regelgevingen",
        "left": "",
        "right": true
      },
      {
        "label": "Auditvoorbereiding",
        "left": "Kwartaal lang haasten",
        "right": true
      },
      {
        "label": "Expertbegeleiding",
        "left": "Ad-hoc consultants",
        "right": true
      },
      {
        "label": "Realtime dekkingsoverzicht",
        "left": "",
        "right": true
      }
    ]
  },
  "steps": {
    "eyebrow": "Hoe het werkt",
    "title": "Van verspreide documenten naar een levend dossier",
    "steps": [
      {
        "number": "01",
        "title": "Afbakenen",
        "description": "We koppelen uw producten aan de van toepassing zijnde regelgeving en de gedeelde controles."
      },
      {
        "number": "02",
        "title": "Verbinden",
        "description": "Bewijsbronnen — tests, SBOM's, risicoanalyses — worden aan het controlemodel gekoppeld."
      },
      {
        "number": "03",
        "title": "Gaten dichten",
        "description": "OXOT toont wat open staat; onze experts helpen het efficiënt te sluiten."
      },
      {
        "number": "04",
        "title": "Onderhouden",
        "description": "Het dossier blijft automatisch actueel, klaar voor audit op elk moment."
      }
    ]
  },
  "quote": {
    "quote": "Vroeger was elke regelgeving een aparte brandoefening. Met OXOT schrijft het bewijs zich eenmaal en beantwoordt het ze allemaal.",
    "author": "Hoofd Productbeveiliging",
    "role": "Leverancier industriële automatisering"
  },
  "faq": {
    "eyebrow": "Vragen",
    "title": "Wat teams vragen voordat ze starten",
    "items": [
      {
        "question": "Welke regelgeving dekt OXOT?",
        "answer": "De Cyber Resilience Act, de EU AI Act, de Machineverordening (2023/1230) en IEC 62443, met aangrenzende raamwerken zoals NIS2 mee in kaart."
      },
      {
        "question": "Is dit software of advies?",
        "answer": "Beide. Het platform onderhoudt uw bewijs; OXOT-experts beoordelen dossiers en begeleiden uw team bij de moeilijke keuzes."
      },
      {
        "question": "Moeten onze ingenieurs een nieuwe tool leren?",
        "answer": "Minimaal. Bewijs komt uit de systemen die zij al gebruiken, dus bijdragen gebeurt in de flow van hun werk."
      },
      {
        "question": "Hoe snel zijn we auditklaar?",
        "answer": "De meeste teams bereiken een auditklaar dossier in weken in plaats van kwartalen, omdat overlappend werk maar één keer wordt gedaan."
      }
    ]
  },
  "cta": {
    "title": "Zie uw conformiteitsstatus in één overzicht",
    "subtitle": "Boek een rondleiding en we koppelen uw producten aan de relevante regelgeving.",
    "primaryCta": {
      "label": "Praat met OXOT",
      "href": "/contact"
    },
    "secondaryCta": {
      "label": "Ontdek het platform",
      "href": "/conformity-platform"
    }
  }
}
$json$::jsonb)
ON CONFLICT (key, locale) DO NOTHING;
