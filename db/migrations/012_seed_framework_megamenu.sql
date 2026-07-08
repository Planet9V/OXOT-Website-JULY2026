-- Nest the EU framework pages under the Frameworks/Kaders top item to demonstrate
-- the mega-menu. Idempotent: a child is inserted only if its href+parent doesn't
-- already exist. Includes an "overview" child so the hub page stays reachable
-- (a parent with children opens the dropdown rather than navigating).
DO $$
DECLARE
  m_id BIGINT;
  parent_en BIGINT;
  parent_nl BIGINT;
BEGIN
  SELECT id INTO m_id FROM menus WHERE key = 'main';
  IF m_id IS NULL THEN RETURN; END IF;

  SELECT id INTO parent_en FROM menu_items WHERE menu_id = m_id AND locale = 'en' AND href LIKE '%/frameworks' AND parent_id IS NULL ORDER BY position LIMIT 1;
  SELECT id INTO parent_nl FROM menu_items WHERE menu_id = m_id AND locale = 'nl' AND href LIKE '%/frameworks' AND parent_id IS NULL ORDER BY position LIMIT 1;

  IF parent_en IS NOT NULL THEN
    INSERT INTO menu_items (menu_id, locale, label, href, position, parent_id, description)
    SELECT m_id, 'en', v.label, v.href, v.pos, parent_en, v.descr
    FROM (VALUES
      ('Frameworks overview',    '/en/frameworks',   0, 'How the EU OT-security frameworks fit together — pick your role.'),
      ('NIS2',                   '/en/nis2',         1, 'Cyber risk management & incident reporting for essential/important entities.'),
      ('Cyber Resilience Act',   '/en/cra',          2, 'Security as a condition of market access for digital products.'),
      ('AI Act',                 '/en/ai-act',       3, 'Risk-tiered obligations for AI in safety and industrial contexts.'),
      ('Machinery Regulation',   '/en/machine-act',  4, 'Cybersecurity built into the machine safety case.'),
      ('IEC 62443',              '/en/iec-62443',    5, 'The engineering backbone for OT/ICS security.'),
      ('TS 50701',               '/en/ts-50701',     6, 'IEC 62443 adapted to railway systems.')
    ) AS v(label, href, pos, descr)
    WHERE NOT EXISTS (SELECT 1 FROM menu_items x WHERE x.menu_id = m_id AND x.locale = 'en' AND x.href = v.href AND x.parent_id = parent_en);
  END IF;

  IF parent_nl IS NOT NULL THEN
    INSERT INTO menu_items (menu_id, locale, label, href, position, parent_id, description)
    SELECT m_id, 'nl', v.label, v.href, v.pos, parent_nl, v.descr
    FROM (VALUES
      ('Kaders — overzicht',     '/nl/frameworks',   0, 'Hoe de EU OT-beveiligingskaders samenhangen — kies uw rol.'),
      ('NIS2',                   '/nl/nis2',         1, 'Cyberrisicobeheer en incidentmelding voor essentiële/belangrijke entiteiten.'),
      ('Cyber Resilience Act',   '/nl/cra',          2, 'Beveiliging als voorwaarde voor markttoegang van digitale producten.'),
      ('AI-verordening',         '/nl/ai-act',       3, 'Risicogebaseerde verplichtingen voor AI in veiligheids- en industriële context.'),
      ('Machineverordening',     '/nl/machine-act',  4, 'Cyberbeveiliging in de machineveiligheidsbeoordeling.'),
      ('IEC 62443',              '/nl/iec-62443',    5, 'De technische ruggengraat voor OT/ICS-beveiliging.'),
      ('TS 50701',               '/nl/ts-50701',     6, 'IEC 62443 toegepast op spoorwegsystemen.')
    ) AS v(label, href, pos, descr)
    WHERE NOT EXISTS (SELECT 1 FROM menu_items x WHERE x.menu_id = m_id AND x.locale = 'nl' AND x.href = v.href AND x.parent_id = parent_nl);
  END IF;
END $$;
