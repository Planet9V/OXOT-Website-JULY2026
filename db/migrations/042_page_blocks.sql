-- 042_page_blocks.sql
-- Phase 0 of the Block/Section Page Builder CMS (docs/BLOCK-CMS-PLAN.md).
-- PURE SCHEMA, additive and idempotent. No content is created or moved here —
-- the CDT/Conformity backfill is a later, separately-gated migration (043) that
-- runs only after the parity harness signs off. Nothing in this file changes any
-- rendered page.
--
-- Three changes, all approved in the plan's §H decisions:
--   A) new `page_blocks` table — one row per (slug, locale, ordered block).
--   B) `page_versions.blocks` JSONB column — lets the existing zero-loss snapshot
--      machinery (src/lib/page-versions.ts snapshotCurrent) also capture a page's
--      ordered block set, keeping ONE unified history table.
--   C) extend `pages_content_type_chk` to allow content_type='blocks' (a page
--      whose body is composed of page_blocks rather than markdown).

BEGIN;

-- ============================================================================
-- A) page_blocks — ordered, typed, per-locale content blocks for a page.
-- ============================================================================
-- `type` is a registry key (src/lib/blocks/types.ts), e.g. 'cdt.hero'. `config`
-- holds exactly the section's existing typed sub-object (CdtHero, ConformityHomeStat[],
-- ...), so a backfill is 1:1 and provably lossless. EN and NL are sibling rows
-- sharing slug+position+type, differing only in `config` — mirroring the per-locale
-- shape of `pages` and `page_versions`.
CREATE TABLE IF NOT EXISTS page_blocks (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  slug        TEXT NOT NULL,
  locale      TEXT NOT NULL CHECK (locale IN ('nl','en')),
  position    INT  NOT NULL DEFAULT 0,
  type        TEXT NOT NULL,
  config      JSONB NOT NULL DEFAULT '{}'::jsonb,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS page_blocks_slug_locale_pos_idx
  ON page_blocks (slug, locale, position);

-- ============================================================================
-- B) page_versions.blocks — capture the ordered block set in each snapshot.
-- ============================================================================
-- Nullable: markdown pages leave it NULL; block pages store a JSON array of
-- { position, type, config } at snapshot time. snapshotCurrent() is extended in
-- a later phase to populate it; adding the column now is safe and additive.
ALTER TABLE page_versions ADD COLUMN IF NOT EXISTS blocks JSONB;

-- ============================================================================
-- C) allow content_type = 'blocks' on pages.
-- ============================================================================
-- Postgres cannot modify a CHECK in place, so drop + re-add. Idempotent: the
-- re-added constraint is the superset, so re-running is a no-op in effect.
-- Tagged dollar-quote ($mig042$) per scripts/check-sql.mjs — never bare $$.
DO $mig042$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'pages_content_type_chk') THEN
    ALTER TABLE pages DROP CONSTRAINT pages_content_type_chk;
  END IF;
  ALTER TABLE pages
    ADD CONSTRAINT pages_content_type_chk
    CHECK (content_type IN ('page','article','blocks'));
END $mig042$;

COMMIT;
