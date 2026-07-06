-- 007_site_blocks.sql — structured, CMS-editable content blocks (e.g. the
-- homepage hero + services) stored as JSONB per key + locale. Idempotent.

CREATE TABLE IF NOT EXISTS site_blocks (
  key        TEXT        NOT NULL,
  locale     TEXT        NOT NULL,
  data       JSONB       NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (key, locale)
);
