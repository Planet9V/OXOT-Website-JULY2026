-- Add a top-level "Conformity Platform" mega-menu item (with its six sub-views
-- as children) to the main nav, in both locales. Idempotent: the parent is
-- created only if absent, and each child only if its href+parent isn't present.
-- A parent WITH children opens the dropdown; the "Overview" child keeps the hub
-- page reachable.
DO $$
DECLARE
  m_id BIGINT;
  parent_en BIGINT;
  parent_nl BIGINT;
  next_pos INT;
BEGIN
  SELECT id INTO m_id FROM menus WHERE key = 'main';
  IF m_id IS NULL THEN RETURN; END IF;

  -- Position the new top-level item right after the highest existing top-level position.
  SELECT COALESCE(MAX(position), 0) + 1 INTO next_pos
    FROM menu_items WHERE menu_id = m_id AND parent_id IS NULL AND locale = 'en';

  -- EN top-level parent
  SELECT id INTO parent_en FROM menu_items
    WHERE menu_id = m_id AND locale = 'en' AND href = '/en/conformity-platform' AND parent_id IS NULL
    ORDER BY position LIMIT 1;
  IF parent_en IS NULL THEN
    INSERT INTO menu_items (menu_id, locale, label, href, position, parent_id, description)
    VALUES (m_id, 'en', 'Conformity Platform', '/en/conformity-platform', next_pos, NULL,
            'Every obligation, mapped once across CRA, AI Act, Machinery and IEC 62443.')
    RETURNING id INTO parent_en;
  END IF;

  -- NL top-level parent
  SELECT id INTO parent_nl FROM menu_items
    WHERE menu_id = m_id AND locale = 'nl' AND href = '/nl/conformity-platform' AND parent_id IS NULL
    ORDER BY position LIMIT 1;
  IF parent_nl IS NULL THEN
    INSERT INTO menu_items (menu_id, locale, label, href, position, parent_id, description)
    VALUES (m_id, 'nl', 'Conformiteitsplatform', '/nl/conformity-platform', next_pos, NULL,
            'Elke verplichting, één keer in kaart gebracht over CRA, AI-verordening, Machineverordening en IEC 62443.')
    RETURNING id INTO parent_nl;
  END IF;

  -- EN children
  IF parent_en IS NOT NULL THEN
    INSERT INTO menu_items (menu_id, locale, label, href, position, parent_id, description)
    SELECT m_id, 'en', v.label, v.href, v.pos, parent_en, v.descr
    FROM (VALUES
      ('Overview',     '/en/conformity-platform',              0, 'Dashboard: regulations, requirements, themes and the implementation timeline.'),
      ('Regulations',  '/en/conformity-platform/regulations',  1, 'The five frameworks in scope, with official texts and requirement counts.'),
      ('Requirements', '/en/conformity-platform/requirements', 2, 'Search and filter every obligation across all frameworks.'),
      ('Themes',       '/en/conformity-platform/themes',       3, 'Fifteen cross-cutting control themes that recur across regulations.'),
      ('Matrix',       '/en/conformity-platform/matrix',       4, 'The theme x regulation grid — one control, many clauses.'),
      ('Sources',      '/en/conformity-platform/sources',      5, 'The source corpus behind the mappings.')
    ) AS v(label, href, pos, descr)
    WHERE NOT EXISTS (SELECT 1 FROM menu_items x WHERE x.menu_id = m_id AND x.locale = 'en' AND x.href = v.href AND x.parent_id = parent_en);
  END IF;

  -- NL children
  IF parent_nl IS NOT NULL THEN
    INSERT INTO menu_items (menu_id, locale, label, href, position, parent_id, description)
    SELECT m_id, 'nl', v.label, v.href, v.pos, parent_nl, v.descr
    FROM (VALUES
      ('Overzicht',    '/nl/conformity-platform',              0, 'Dashboard: regelgeving, vereisten, thema''s en de implementatietijdlijn.'),
      ('Regelgeving',  '/nl/conformity-platform/regulations',  1, 'De vijf kaders binnen scope, met officiële teksten en aantallen vereisten.'),
      ('Vereisten',    '/nl/conformity-platform/requirements', 2, 'Zoek en filter elke verplichting over alle kaders heen.'),
      ('Thema''s',     '/nl/conformity-platform/themes',       3, 'Vijftien overkoepelende beheersmaatregelthema''s die terugkeren in de regelgeving.'),
      ('Matrix',       '/nl/conformity-platform/matrix',       4, 'De thema x regelgeving-matrix — één maatregel, vele clausules.'),
      ('Bronnen',      '/nl/conformity-platform/sources',      5, 'Het broncorpus achter de afbeeldingen.')
    ) AS v(label, href, pos, descr)
    WHERE NOT EXISTS (SELECT 1 FROM menu_items x WHERE x.menu_id = m_id AND x.locale = 'nl' AND x.href = v.href AND x.parent_id = parent_nl);
  END IF;
END $$;
