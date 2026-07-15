-- Zero-loss CMS: append-only version history for `pages`, so every overwrite
-- (edit, publish, restore) is preceded by a snapshot. No content is ever
-- deleted; page_versions only ever grows.

CREATE TABLE IF NOT EXISTS page_versions (
  id               BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  slug             TEXT NOT NULL,
  locale           TEXT NOT NULL CHECK (locale IN ('nl','en')),
  version_number   INT NOT NULL,
  state            TEXT NOT NULL DEFAULT 'archived' CHECK (state IN ('draft','published','archived')),
  title            TEXT NOT NULL,
  body             TEXT NOT NULL DEFAULT '',
  meta_title       TEXT,
  meta_description TEXT,
  excerpt          TEXT,
  og_image         TEXT,
  content_type     TEXT NOT NULL DEFAULT 'page',
  note             TEXT,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (slug, locale, version_number)
);

CREATE INDEX IF NOT EXISTS page_versions_slug_locale_idx
  ON page_versions (slug, locale, version_number DESC);

-- Seed v1 for every existing page that has no versions yet (idempotent via
-- WHERE NOT EXISTS). This guarantees no pre-existing content is ever at risk
-- before its first edit under the new versioning system.
INSERT INTO page_versions
  (slug, locale, version_number, state, title, body,
   meta_title, meta_description, excerpt, og_image, content_type, note)
SELECT p.slug, p.locale, 1,
       CASE WHEN p.published THEN 'published' ELSE 'draft' END,
       p.title, p.body,
       p.meta_title, p.meta_description, p.excerpt, p.og_image, p.content_type,
       'Initial snapshot'
  FROM pages p
 WHERE NOT EXISTS (
   SELECT 1 FROM page_versions v WHERE v.slug = p.slug AND v.locale = p.locale
 );
