-- 009_media.sql — binary media (images, PDFs) stored in Postgres per project spec.
-- Files live in the DB itself (bytea); served via /api/media/[id]. Idempotent.

CREATE TABLE IF NOT EXISTS media (
  id          BIGSERIAL PRIMARY KEY,
  filename    TEXT        NOT NULL,
  mime        TEXT        NOT NULL,
  bytes       BYTEA       NOT NULL,
  size        INTEGER     NOT NULL,
  width       INTEGER,
  height      INTEGER,
  alt         TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS media_created_idx ON media (created_at DESC);
