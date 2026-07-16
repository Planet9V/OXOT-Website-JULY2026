-- Consolidate the top-level "Approach" / "Onze aanpak" nav (added by 023,
-- pointing at /industrial-operations) into the new coded Cyber Digital Twin
-- (CDT) page at /[locale]/cyber-digital-twin (site_blocks key 'cdt_home',
-- src/lib/cdt.ts). Zero content loss: the legacy markdown `pages` row for
-- slug='cyber-digital-twin' is snapshotted to page_versions before the new
-- coded route shadows it in routing (the [slug] catch-all still serves it if
-- the coded route is ever removed; the pages row itself is never touched).
-- The 'home' site_blocks content and the /industrial-operations route are
-- left completely untouched by this migration — only the top-level nav link
-- to it is removed (023's seed becomes a no-op once this has run).
--
-- REVERSAL: to undo, (1) re-run db/migrations/023_seed_approach_nav.sql to
-- restore the "Approach"/"Onze aanpak" top-level nav items pointing at
-- /en/industrial-operations and /nl/industrial-operations; (2) the
-- page_versions snapshot rows inserted by Section B below are additive only
-- — they can be left in place or deleted with:
--   DELETE FROM page_versions WHERE slug = 'cyber-digital-twin'
--     AND note = 'Snapshot before CDT coded-route launch';
-- (3) remove the redirect block added to next.config.mjs for
-- /:locale(en|nl)/industrial-operations.

-- ============================================================================
-- SECTION A — nav: remove the "Approach" top-level link (both locales).
-- Idempotent: no-op once already gone. Does not touch the industrial-
-- operations route or its page content — only this nav entry.
-- ============================================================================
DELETE FROM menu_items
 WHERE menu_id = (SELECT id FROM menus WHERE key = 'main')
   AND parent_id IS NULL
   AND href IN ('/en/industrial-operations', '/nl/industrial-operations');

-- ============================================================================
-- SECTION B — zero-loss snapshot of the existing cyber-digital-twin markdown
-- page into page_versions before the coded route shadows it. Guarded against
-- duplication on re-run via WHERE NOT EXISTS on the note.
-- ============================================================================
INSERT INTO page_versions
  (slug, locale, version_number, state, title, body,
   meta_title, meta_description, excerpt, og_image, content_type, note)
SELECT
  p.slug, p.locale,
  COALESCE((SELECT MAX(v.version_number) FROM page_versions v
             WHERE v.slug = p.slug AND v.locale = p.locale), 0) + 1,
  CASE WHEN p.published THEN 'published' ELSE 'draft' END,
  p.title, p.body,
  p.meta_title, p.meta_description, p.excerpt, p.og_image, p.content_type,
  'Snapshot before CDT coded-route launch'
FROM pages p
WHERE p.slug = 'cyber-digital-twin'
  AND NOT EXISTS (
    SELECT 1 FROM page_versions v
     WHERE v.slug = p.slug AND v.locale = p.locale
       AND v.note = 'Snapshot before CDT coded-route launch'
  );
