-- 004_seo_fields.sql — SEO/meta fields + article content type on pages. Idempotent.

ALTER TABLE pages ADD COLUMN IF NOT EXISTS meta_title       TEXT;
ALTER TABLE pages ADD COLUMN IF NOT EXISTS meta_description TEXT;
ALTER TABLE pages ADD COLUMN IF NOT EXISTS excerpt          TEXT;
ALTER TABLE pages ADD COLUMN IF NOT EXISTS og_image         TEXT;
ALTER TABLE pages ADD COLUMN IF NOT EXISTS content_type     TEXT NOT NULL DEFAULT 'page';
ALTER TABLE pages ADD COLUMN IF NOT EXISTS published_at     TIMESTAMPTZ;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'pages_content_type_chk') THEN
    ALTER TABLE pages ADD CONSTRAINT pages_content_type_chk CHECK (content_type IN ('page','article'));
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS pages_content_type_idx ON pages (content_type, locale, published);

-- Seed SEO meta for the existing pages (idempotent; safe to re-run).
UPDATE pages p SET meta_title = v.mt, meta_description = v.md, excerpt = v.ex
FROM (VALUES
  ('services','en',
    $x$OT Cybersecurity Services | OXOT$x$,
    $x$OT security assessments, Cyber Digital Twin, programmes, segmentation, secure remote access and baselines — risk-based OT cybersecurity from OXOT.$x$,
    $x$Risk-based OT cybersecurity services for industrial organizations.$x$),
  ('services','nl',
    $x$OT-cybersecuritydiensten | OXOT$x$,
    $x$OT-securityassessments, Cyber Digital Twin, programma's, segmentatie, veilige externe toegang en baselines — risicogebaseerde OT-cybersecurity van OXOT.$x$,
    $x$Risicogebaseerde OT-cybersecuritydiensten voor industriële organisaties.$x$),
  ('cyber-digital-twin','en',
    $x$Cyber Digital Twin for OT | OXOT$x$,
    $x$A living data model of your OT environment that unifies assets, risks and controls to prioritize security by real operational risk — the OXOT Cyber Digital Twin.$x$,
    $x$A living model of your OT environment for risk-based decisions at scale.$x$),
  ('cyber-digital-twin','nl',
    $x$Cyber Digital Twin voor OT | OXOT$x$,
    $x$Een levend datamodel van uw OT-omgeving dat assets, risico's en maatregelen verenigt om te prioriteren op werkelijk operationeel risico — de OXOT Cyber Digital Twin.$x$,
    $x$Een levend model van uw OT-omgeving voor risicogebaseerde beslissingen op schaal.$x$),
  ('about','en',
    $x$About OXOT — Dutch OT Cybersecurity$x$,
    $x$OXOT is a Dutch OT cybersecurity company founded by former Fox-IT OT security leads, focused on risk-based security and EU sovereignty.$x$,
    $x$Dutch OT cybersecurity experts, founded by former Fox-IT OT security leads.$x$),
  ('about','nl',
    $x$Over OXOT — Nederlandse OT-cybersecurity$x$,
    $x$OXOT is een Nederlands OT-cybersecuritybedrijf, opgericht door voormalige OT-securityleads van Fox-IT, met focus op risicogebaseerde beveiliging en EU-soevereiniteit.$x$,
    $x$Nederlandse OT-securityexperts, opgericht door voormalige Fox-IT OT-leads.$x$),
  ('frameworks','en',
    $x$OT Security Frameworks & Regulations | OXOT$x$,
    $x$AI Act, CRA, NIS2, the Machinery Regulation and IEC 62443 — OXOT translates OT cybersecurity regulations into practical, risk-based action.$x$,
    $x$Navigate AI Act, CRA, NIS2, Machinery Regulation and IEC 62443 for OT.$x$),
  ('frameworks','nl',
    $x$OT-securitykaders & regelgeving | OXOT$x$,
    $x$AI Act, CRA, NIS2, de Machineverordening en IEC 62443 — OXOT vertaalt OT-cybersecurityregelgeving naar praktische, risicogebaseerde actie.$x$,
    $x$Navigeer AI Act, CRA, NIS2, Machineverordening en IEC 62443 voor OT.$x$),
  ('ai-act','en',
    $x$AI Act & OT Security | OXOT$x$,
    $x$How the EU AI Act applies to AI in industrial and safety-related OT contexts. OXOT helps you turn requirements into practical action.$x$,
    $x$The EU AI Act in industrial and OT contexts.$x$),
  ('ai-act','nl',
    $x$AI Act & OT-security | OXOT$x$,
    $x$Hoe de EU AI Act van toepassing is op AI in industriële en veiligheidsgerelateerde OT-contexten. OXOT vertaalt eisen naar praktische actie.$x$,
    $x$De EU AI Act in industriële en OT-contexten.$x$),
  ('cra','en',
    $x$Cyber Resilience Act (CRA) & OT | OXOT$x$,
    $x$The CRA sets cybersecurity requirements for products with digital elements. OXOT helps industrial organizations meet them across the lifecycle.$x$,
    $x$CRA cybersecurity requirements for products with digital elements.$x$),
  ('cra','nl',
    $x$Cyber Resilience Act (CRA) & OT | OXOT$x$,
    $x$De CRA stelt cybersecurity-eisen aan producten met digitale elementen. OXOT helpt industriële organisaties hieraan te voldoen gedurende de levenscyclus.$x$,
    $x$CRA-cybersecurity-eisen voor producten met digitale elementen.$x$),
  ('nis2','en',
    $x$NIS2 Directive for OT & Industry | OXOT$x$,
    $x$NIS2 raises cybersecurity and risk-management requirements for essential and important entities. OXOT helps industrial operators comply.$x$,
    $x$NIS2 cybersecurity requirements for essential and important entities.$x$),
  ('nis2','nl',
    $x$NIS2-richtlijn voor OT & industrie | OXOT$x$,
    $x$NIS2 verhoogt de eisen aan cybersecurity en risicobeheer voor essentiële en belangrijke entiteiten. OXOT helpt industriële operators te voldoen.$x$,
    $x$NIS2-cybersecurity-eisen voor essentiële en belangrijke entiteiten.$x$),
  ('machine-act','en',
    $x$EU Machinery Regulation & OT Security | OXOT$x$,
    $x$The EU Machinery Regulation introduces safety and cybersecurity requirements for machinery. OXOT helps you address them in OT environments.$x$,
    $x$Cybersecurity requirements in the EU Machinery Regulation.$x$),
  ('machine-act','nl',
    $x$EU-Machineverordening & OT-security | OXOT$x$,
    $x$De EU-Machineverordening introduceert veiligheids- en cybersecurity-eisen voor machines. OXOT helpt u hieraan te voldoen in OT-omgevingen.$x$,
    $x$Cybersecurity-eisen in de EU-Machineverordening.$x$),
  ('iec-62443','en',
    $x$IEC 62443 for Industrial Security | OXOT$x$,
    $x$IEC 62443 is the leading standard for IACS security. OXOT applies it to assessments, baselines and segmentation in real OT environments.$x$,
    $x$The leading standard series for industrial control system security.$x$),
  ('iec-62443','nl',
    $x$IEC 62443 voor industriële beveiliging | OXOT$x$,
    $x$IEC 62443 is de toonaangevende norm voor IACS-beveiliging. OXOT past het toe op assessments, baselines en segmentatie in echte OT-omgevingen.$x$,
    $x$De toonaangevende normreeks voor de beveiliging van besturingssystemen.$x$),
  ('contact','en',
    $x$Contact OXOT — Talk to an OT Security Expert$x$,
    $x$Talk to an OXOT OT security expert about your risk and practical next steps. Dutch OT cybersecurity, focused on EU sovereignty.$x$,
    $x$Talk to an OT security expert at OXOT.$x$),
  ('contact','nl',
    $x$Contact OXOT — Praat met een OT-securityexpert$x$,
    $x$Praat met een OT-securityexpert van OXOT over uw risico en praktische vervolgstappen. Nederlandse OT-cybersecurity, met focus op EU-soevereiniteit.$x$,
    $x$Praat met een OT-securityexpert bij OXOT.$x$)
) AS v(slug, locale, mt, md, ex)
WHERE p.slug = v.slug AND p.locale = v.locale;
