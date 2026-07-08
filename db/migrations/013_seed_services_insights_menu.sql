-- Populate the Services and Insights dropdowns from the real offerings/articles.
-- Idempotent, keyed by (locale, parent, label) so several links that share an href
-- (e.g. offerings -> /services) still each insert once.
DO $$
DECLARE
  m_id BIGINT; sv_en BIGINT; sv_nl BIGINT; in_en BIGINT; in_nl BIGINT;
BEGIN
  SELECT id INTO m_id FROM menus WHERE key = 'main';
  IF m_id IS NULL THEN RETURN; END IF;

  SELECT id INTO sv_en FROM menu_items WHERE menu_id=m_id AND locale='en' AND href LIKE '%/services' AND parent_id IS NULL ORDER BY position LIMIT 1;
  SELECT id INTO sv_nl FROM menu_items WHERE menu_id=m_id AND locale='nl' AND href LIKE '%/services' AND parent_id IS NULL ORDER BY position LIMIT 1;
  SELECT id INTO in_en FROM menu_items WHERE menu_id=m_id AND locale='en' AND href LIKE '%/blog' AND parent_id IS NULL ORDER BY position LIMIT 1;
  SELECT id INTO in_nl FROM menu_items WHERE menu_id=m_id AND locale='nl' AND href LIKE '%/blog' AND parent_id IS NULL ORDER BY position LIMIT 1;

  IF sv_en IS NOT NULL THEN
    INSERT INTO menu_items (menu_id, locale, label, href, position, parent_id, description)
    SELECT m_id, 'en', v.label, v.href, v.pos, sv_en, v.descr FROM (VALUES
      ('Services overview',        '/en/services',           0, 'What we do, how we work, and how it maps to the EU frameworks.'),
      ('OT Security Assessments',  '/en/services',           1, 'Understand your current OT security posture, key risks and next steps.'),
      ('Cyber Digital Twin',       '/en/cyber-digital-twin', 2, 'A living model of your OT environment for risk-based decisions at scale.'),
      ('OT Security Programmes',   '/en/services',           3, 'Structured OT security improvement programmes across sites and regions.'),
      ('Architecture & Segmentation','/en/services',         4, 'Secure OT network architectures, zones, conduits and segmentation patterns.'),
      ('Secure Remote Access',     '/en/services',           5, 'Reduce risk from vendor access, remote maintenance and external connectivity.'),
      ('OT Security Baseline',     '/en/services',           6, 'Minimum controls that are realistic, repeatable and operations-aligned.'),
      ('Capability Transfer',      '/en/services',           7, 'Build internal knowledge, structure and ownership to sustain OT security.')
    ) AS v(label, href, pos, descr)
    WHERE NOT EXISTS (SELECT 1 FROM menu_items x WHERE x.menu_id=m_id AND x.locale='en' AND x.parent_id=sv_en AND x.label=v.label);
  END IF;

  IF sv_nl IS NOT NULL THEN
    INSERT INTO menu_items (menu_id, locale, label, href, position, parent_id, description)
    SELECT m_id, 'nl', v.label, v.href, v.pos, sv_nl, v.descr FROM (VALUES
      ('Diensten — overzicht',      '/nl/services',           0, 'Wat we doen, hoe we werken en hoe het aansluit op de EU-kaders.'),
      ('OT-securityassessments',    '/nl/services',           1, 'Begrijp uw huidige OT-securityhouding, risico’s en vervolgstappen.'),
      ('Cyber Digital Twin',        '/nl/cyber-digital-twin', 2, 'Een levend model van uw OT-omgeving voor risicogebaseerde besluiten.'),
      ('OT-securityprogramma’s',    '/nl/services',           3, 'Gestructureerde OT-securityverbeterprogramma’s over locaties en regio’s.'),
      ('Architectuur & segmentatie','/nl/services',           4, 'Veilige OT-netwerkarchitecturen, zones, conduits en segmentatiepatronen.'),
      ('Veilige externe toegang',   '/nl/services',           5, 'Verminder risico van leverancierstoegang en onderhoud op afstand.'),
      ('OT-securitybaseline',       '/nl/services',           6, 'Minimale, realistische en herhaalbare beveiligingsmaatregelen.'),
      ('Kennisoverdracht',          '/nl/services',           7, 'Bouw interne kennis, structuur en eigenaarschap voor blijvende OT-security.')
    ) AS v(label, href, pos, descr)
    WHERE NOT EXISTS (SELECT 1 FROM menu_items x WHERE x.menu_id=m_id AND x.locale='nl' AND x.parent_id=sv_nl AND x.label=v.label);
  END IF;

  IF in_en IS NOT NULL THEN
    INSERT INTO menu_items (menu_id, locale, label, href, position, parent_id, description)
    SELECT m_id, 'en', v.label, v.href, v.pos, in_en, v.descr FROM (VALUES
      ('All insights',        '/en/blog',                      0, 'Analysis and practical guides on securing industrial environments.'),
      ('Fooled by Randomness','/en/cdt-fooled-by-randomness',  1, 'Why “we’ve never had an incident” is not evidence of safety.')
    ) AS v(label, href, pos, descr)
    WHERE NOT EXISTS (SELECT 1 FROM menu_items x WHERE x.menu_id=m_id AND x.locale='en' AND x.parent_id=in_en AND x.label=v.label);
  END IF;

  IF in_nl IS NOT NULL THEN
    INSERT INTO menu_items (menu_id, locale, label, href, position, parent_id, description)
    SELECT m_id, 'nl', v.label, v.href, v.pos, in_nl, v.descr FROM (VALUES
      ('Alle kennisbank',     '/nl/blog',                      0, 'Analyses en praktische gidsen over het beveiligen van industriële omgevingen.'),
      ('Fooled by Randomness','/nl/cdt-fooled-by-randomness',  1, 'Waarom “we hebben nog nooit een incident gehad” geen bewijs is.')
    ) AS v(label, href, pos, descr)
    WHERE NOT EXISTS (SELECT 1 FROM menu_items x WHERE x.menu_id=m_id AND x.locale='nl' AND x.parent_id=in_nl AND x.label=v.label);
  END IF;
END $$;
