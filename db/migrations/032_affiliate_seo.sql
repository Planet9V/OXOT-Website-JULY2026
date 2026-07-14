-- 032_affiliate_seo.sql
-- Affiliate links + keywords, and per-page SEO fields. Ported from the source
-- Drizzle schemas (Celestial-Agent-Nexus: lib/db/src/schema/affiliateLinks.ts,
-- affiliateKeywords.ts, linkClicks.ts) and the source SEO admin (adminSeo.ts).
--
-- Reconciliation notes:
--  * link_clicks already exists (031_analytics.sql) as a GENERIC click table
--    (href/kind/path/...). We do NOT create a second clicks table — we add a
--    nullable affiliate_link_id column so affiliate clicks are attributed to a
--    link while non-affiliate clicks keep affiliate_link_id NULL.
--  * pages already carries meta_title / meta_description / og_image (002 + 004).
--    We do NOT create a parallel SEO table — the SEO admin manages those existing
--    columns and we only ADD the SEO fields the source admin edits that pages
--    lacks (og_title, og_description, canonical_url, meta_keywords, noindex).
-- Idempotent: CREATE TABLE / COLUMN / INDEX IF NOT EXISTS, guarded constraints.

-- Partner / affiliate link. Public copy links through the click-tracking redirect
-- (/api/go/:id) rather than target_url directly, so every click is recorded.
-- `sponsored` drives the rel attribute (sponsored vs nofollow). Columns match the
-- source affiliateLinks.ts schema exactly. Click totals are derived from
-- link_clicks (no denormalized counter), matching the source.
CREATE TABLE IF NOT EXISTS affiliate_links (
  id          serial PRIMARY KEY,
  name        text NOT NULL,
  target_url  text NOT NULL,
  description text,
  sponsored   boolean NOT NULL DEFAULT true,
  active      boolean NOT NULL DEFAULT true,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

-- A keyword mapped to an affiliate link, per locale. Matches affiliateKeywords.ts.
CREATE TABLE IF NOT EXISTS affiliate_keywords (
  id                serial PRIMARY KEY,
  affiliate_link_id integer NOT NULL REFERENCES affiliate_links (id) ON DELETE CASCADE,
  keyword           text NOT NULL,
  locale            text NOT NULL DEFAULT 'en',
  active            boolean NOT NULL DEFAULT true,
  created_at        timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS affiliate_keywords_link_idx ON affiliate_keywords (affiliate_link_id);

-- Reconcile with the existing generic link_clicks table: attribute affiliate
-- clicks without recreating the table. Nullable so non-affiliate clicks are fine.
ALTER TABLE link_clicks ADD COLUMN IF NOT EXISTS affiliate_link_id integer;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'link_clicks_affiliate_link_id_fkey'
  ) THEN
    ALTER TABLE link_clicks
      ADD CONSTRAINT link_clicks_affiliate_link_id_fkey
      FOREIGN KEY (affiliate_link_id) REFERENCES affiliate_links (id) ON DELETE CASCADE;
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS link_clicks_affiliate_link_idx ON link_clicks (affiliate_link_id);

-- Per-page SEO fields the source SEO admin edits that pages does not already have.
-- meta_title / meta_description / og_image already exist (002_admin_cms + 004_seo_fields).
ALTER TABLE pages ADD COLUMN IF NOT EXISTS og_title      text;
ALTER TABLE pages ADD COLUMN IF NOT EXISTS og_description text;
ALTER TABLE pages ADD COLUMN IF NOT EXISTS canonical_url text;
ALTER TABLE pages ADD COLUMN IF NOT EXISTS meta_keywords text;
ALTER TABLE pages ADD COLUMN IF NOT EXISTS noindex       boolean NOT NULL DEFAULT false;
