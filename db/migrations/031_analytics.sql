-- 031_analytics.sql
-- First-party visitor analytics: page views + link clicks. Ported from the source
-- Drizzle schemas (lib/db/src/schema/pageViews.ts, linkClicks.ts). No cookies or PII;
-- session_id is a random, client-generated id kept in localStorage for coarse
-- unique-visitor counts. Idempotent: CREATE TABLE / INDEX IF NOT EXISTS.

-- One first-party page-view event, recorded by a lightweight beacon fired once
-- per public route view.
CREATE TABLE IF NOT EXISTS page_views (
  id serial primary key,
  path text not null,
  locale text not null default 'en',
  session_id text,
  referrer text,
  device text,
  created_at timestamptz not null default now()
);

CREATE INDEX IF NOT EXISTS page_views_created_idx ON page_views (created_at);
CREATE INDEX IF NOT EXISTS page_views_path_idx ON page_views (path);

-- One recorded click on a tracked link. `kind` classifies the destination
-- (internal | outbound | affiliate); `href` is the resolved target URL. Adapts
-- the source affiliate-only link_clicks table to this app's generic outbound/
-- internal click tracking (no affiliate-links table in this stack).
CREATE TABLE IF NOT EXISTS link_clicks (
  id serial primary key,
  href text not null,
  kind text not null default 'outbound',
  path text,
  locale text,
  session_id text,
  referrer text,
  created_at timestamptz not null default now()
);

CREATE INDEX IF NOT EXISTS link_clicks_created_idx ON link_clicks (created_at);
CREATE INDEX IF NOT EXISTS link_clicks_href_idx ON link_clicks (href);
