-- Consolidate the top-level "Conformity Platform" / "Conformiteitsplatform" nav
-- into the existing "Frameworks" / "Kaders" hub. Zero content loss: the four
-- still-useful conformity sub-pages (matrix, requirements, themes, sources) are
-- re-parented under Frameworks before the old parent is removed; their page
-- content is untouched. Only the CP "Overview" and "Regulations" nav *links*
-- are dropped (their `pages` rows, if any, are not touched by this migration).
-- The Frameworks overview pages (slug='frameworks', en/nl) are enriched with a
-- "Coverage tools" section that links to the four re-parented views, snapshotted
-- to page_versions first per the zero-loss CMS invariant.
--
-- REVERSAL: to undo, (1) re-run db/migrations/022_seed_conformity_nav.sql to
-- restore the "Conformity Platform"/"Conformiteitsplatform" top-level parent and
-- its six children; (2) move the four keeper rows (matrix, requirements, themes,
-- sources; both locales) back under that restored parent with their original
-- positions (4, 2, 3, 5 respectively — see 022's VALUES lists) and original
-- labels; (3) remove the "## Coverage tools" / "## Dekkingsinstrumenten" section
-- appended to the `frameworks` pages' `body` (or restore from the page_versions
-- snapshot row noted with 'Auto-snapshot before 038 coverage-tools enrichment');
-- (4) remove the redirect block added to next.config.mjs for
-- /:locale(en|nl)/conformity-platform.

-- ============================================================================
-- SECTION A — nav: re-parent keepers under Frameworks, then drop the CP parent
-- ============================================================================
DO $$
DECLARE
  m_id BIGINT;
  fw_en BIGINT;
  fw_nl BIGINT;
BEGIN
  SELECT id INTO m_id FROM menus WHERE key = 'main';
  IF m_id IS NULL THEN RETURN; END IF;

  SELECT id INTO fw_en FROM menu_items
    WHERE menu_id = m_id AND locale = 'en' AND href LIKE '%/frameworks' AND parent_id IS NULL
    ORDER BY position LIMIT 1;
  SELECT id INTO fw_nl FROM menu_items
    WHERE menu_id = m_id AND locale = 'nl' AND href LIKE '%/frameworks' AND parent_id IS NULL
    ORDER BY position LIMIT 1;

  -- Re-parent BEFORE deleting the CP parent (parent_id is ON DELETE CASCADE;
  -- doing this first prevents these four rows from being cascade-deleted).
  IF fw_en IS NOT NULL THEN
    UPDATE menu_items SET parent_id = fw_en, position = 7,  label = 'Coverage Matrix'
      WHERE menu_id = m_id AND locale = 'en' AND href = '/en/conformity-platform/matrix';
    UPDATE menu_items SET parent_id = fw_en, position = 8,  label = 'Requirements'
      WHERE menu_id = m_id AND locale = 'en' AND href = '/en/conformity-platform/requirements';
    UPDATE menu_items SET parent_id = fw_en, position = 9,  label = 'Themes'
      WHERE menu_id = m_id AND locale = 'en' AND href = '/en/conformity-platform/themes';
    UPDATE menu_items SET parent_id = fw_en, position = 10, label = 'Resources'
      WHERE menu_id = m_id AND locale = 'en' AND href = '/en/conformity-platform/sources';
  END IF;

  IF fw_nl IS NOT NULL THEN
    UPDATE menu_items SET parent_id = fw_nl, position = 7,  label = 'Dekkingsmatrix'
      WHERE menu_id = m_id AND locale = 'nl' AND href = '/nl/conformity-platform/matrix';
    UPDATE menu_items SET parent_id = fw_nl, position = 8,  label = 'Vereisten'
      WHERE menu_id = m_id AND locale = 'nl' AND href = '/nl/conformity-platform/requirements';
    UPDATE menu_items SET parent_id = fw_nl, position = 9,  label = 'Thema''s'
      WHERE menu_id = m_id AND locale = 'nl' AND href = '/nl/conformity-platform/themes';
    UPDATE menu_items SET parent_id = fw_nl, position = 10, label = 'Bronnen'
      WHERE menu_id = m_id AND locale = 'nl' AND href = '/nl/conformity-platform/sources';
  END IF;

  -- Drop the old CP top-level parents. CASCADE removes only whatever children
  -- remain under them (the "Overview" + "Regulations" links) — the four keepers
  -- above have already been re-parented out from under this CASCADE.
  -- Idempotent: no-op once the CP parents are already gone.
  DELETE FROM menu_items
   WHERE menu_id = m_id AND parent_id IS NULL
     AND href IN ('/en/conformity-platform', '/nl/conformity-platform');
END $$;

-- ============================================================================
-- SECTION B — content: enrich the Frameworks hub pages with a "Coverage tools"
-- section (zero-loss: snapshot to page_versions before the overwrite).
-- ============================================================================
DO $$
DECLARE
  cur RECORD;
  next_version INT;
BEGIN
  -- EN
  SELECT * INTO cur FROM pages WHERE slug = 'frameworks' AND locale = 'en';
  IF FOUND AND cur.body NOT LIKE '%## Coverage tools%' THEN
    SELECT COALESCE(MAX(version_number), 0) + 1 INTO next_version
      FROM page_versions WHERE slug = 'frameworks' AND locale = 'en';

    INSERT INTO page_versions
      (slug, locale, version_number, state, title, body,
       meta_title, meta_description, excerpt, og_image, content_type, note)
    VALUES (
      cur.slug, cur.locale, next_version,
      CASE WHEN cur.published THEN 'published' ELSE 'draft' END,
      cur.title, cur.body,
      cur.meta_title, cur.meta_description, cur.excerpt, cur.og_image, cur.content_type,
      'Auto-snapshot before 038 coverage-tools enrichment'
    );

    UPDATE pages
       SET body = body || E'\n\n## Coverage tools\n\nExplore how these frameworks map to concrete obligations:\n\n- [Coverage Matrix](/en/conformity-platform/matrix) — the theme × regulation grid.\n- [Requirements](/en/conformity-platform/requirements) — search every obligation across frameworks.\n- [Themes](/en/conformity-platform/themes) — the cross-cutting control themes.\n- [Resources](/en/conformity-platform/sources) — the source corpus behind the mappings.\n',
           updated_at = now()
     WHERE slug = 'frameworks' AND locale = 'en';
  END IF;

  -- NL
  SELECT * INTO cur FROM pages WHERE slug = 'frameworks' AND locale = 'nl';
  IF FOUND AND cur.body NOT LIKE '%## Dekkingsinstrumenten%' THEN
    SELECT COALESCE(MAX(version_number), 0) + 1 INTO next_version
      FROM page_versions WHERE slug = 'frameworks' AND locale = 'nl';

    INSERT INTO page_versions
      (slug, locale, version_number, state, title, body,
       meta_title, meta_description, excerpt, og_image, content_type, note)
    VALUES (
      cur.slug, cur.locale, next_version,
      CASE WHEN cur.published THEN 'published' ELSE 'draft' END,
      cur.title, cur.body,
      cur.meta_title, cur.meta_description, cur.excerpt, cur.og_image, cur.content_type,
      'Auto-snapshot before 038 coverage-tools enrichment'
    );

    UPDATE pages
       SET body = body || E'\n\n## Dekkingsinstrumenten\n\nOntdek hoe deze kaders zich vertalen naar concrete verplichtingen:\n\n- [Dekkingsmatrix](/nl/conformity-platform/matrix) — de thema × regelgeving-matrix.\n- [Vereisten](/nl/conformity-platform/requirements) — doorzoek elke verplichting over alle kaders heen.\n- [Thema''s](/nl/conformity-platform/themes) — de overkoepelende beheersmaatregelthema''s.\n- [Bronnen](/nl/conformity-platform/sources) — het broncorpus achter de mappings.\n',
           updated_at = now()
     WHERE slug = 'frameworks' AND locale = 'nl';
  END IF;
END $$;
