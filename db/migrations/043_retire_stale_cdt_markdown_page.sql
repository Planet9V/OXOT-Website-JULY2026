-- 043_retire_stale_cdt_markdown_page.sql
-- Gate-4 Stage 5. Retire the STALE markdown `pages` row slug='cyber-digital-twin'.
--
-- Background: migration 003 seeded a markdown CDT page (published=true). The coded
-- route src/app/[locale]/cyber-digital-twin/page.tsx (now block-rendered) shadows
-- it, so it never renders — but it still surfaces in the admin Pages list and the
-- sitemap (both filter published=true). Migration 040 snapshotted it but, by design,
-- never deleted the row. This retires it: SNAPSHOT-FIRST, then set published=false.
-- NOTHING is deleted — the row and an archival page_versions snapshot both remain,
-- so re-publishing (rollback) is a one-line UPDATE.
--
-- Idempotent: the snapshot is guarded by its unique note; the UPDATE only touches
-- still-published rows. Pure SQL, no DO block, no dollar quotes (check-sql safe).

BEGIN;

-- 1) Snapshot the current markdown row(s) into page_versions (per-locale version
--    numbering), only if not already captured with this note.
INSERT INTO page_versions
  (slug, locale, version_number, state, title, body,
   meta_title, meta_description, excerpt, og_image, content_type, note)
SELECT p.slug, p.locale,
       COALESCE((SELECT MAX(v.version_number) FROM page_versions v
                  WHERE v.slug = p.slug AND v.locale = p.locale), 0) + 1,
       'archived', p.title, p.body,
       p.meta_title, p.meta_description, p.excerpt, p.og_image, p.content_type,
       'Snapshot before retiring stale CDT markdown row (Gate-4)'
  FROM pages p
 WHERE p.slug = 'cyber-digital-twin'
   AND p.published = true
   AND NOT EXISTS (
     SELECT 1 FROM page_versions v
      WHERE v.slug = p.slug AND v.locale = p.locale
        AND v.note = 'Snapshot before retiring stale CDT markdown row (Gate-4)'
   );

-- 2) Unpublish (removes it from the Pages list + sitemap). No content deleted.
UPDATE pages
   SET published = false, updated_at = now()
 WHERE slug = 'cyber-digital-twin' AND published = true;

COMMIT;
