-- 033_carousel.sql — DB-backed, admin-managed homepage hero carousel.
-- Ported from the source Drizzle schema (Celestial-Agent-Nexus:
-- lib/db/src/schema/carouselSlides.ts) and admin route (adminMedia.ts, the
-- /admin/carousel + /site/carousel handlers). Adapted to raw SQL migrations.
--
-- Reconciliation notes:
--  * This app's hero (src/components/conformity-home/hero-carousel.tsx) currently
--    renders 6 STATIC PNGs from public/hero/<locale>/slide-N.png. We seed those
--    EN slides here so Railway shows the current hero immediately after deploy;
--    the component still falls back to the static set when the table is empty or
--    the DB is down, so the front door can never break.
--  * media_asset_id: the source references a media_assets table. This app's media
--    library is the `media` table (009_media.sql) keyed by BIGSERIAL. We keep
--    media_asset_id as a plain NULLABLE integer with NO foreign key — carousel
--    slides here reference public image paths/URLs directly (image_path), so no
--    FK is needed and a type mismatch (int vs bigint) is avoided.
-- Idempotent: CREATE TABLE IF NOT EXISTS + guarded seed (WHERE NOT EXISTS).

CREATE TABLE IF NOT EXISTS carousel_slides (
  id             serial PRIMARY KEY,
  sort_order     integer NOT NULL DEFAULT 0,
  kind           text    NOT NULL DEFAULT 'image', -- 'image' | 'pdf'
  image_path     text    NOT NULL,
  media_asset_id integer,                          -- nullable, no FK (see notes)
  group_id       text,
  page_index     integer,
  caption_en     text,
  caption_nl     text,
  link_url       text,
  active         boolean NOT NULL DEFAULT true,
  created_at     timestamptz NOT NULL DEFAULT now(),
  updated_at     timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS carousel_slides_sort_idx ON carousel_slides (sort_order);
CREATE INDEX IF NOT EXISTS carousel_slides_active_idx ON carousel_slides (active);

-- Seed the existing EN hero deck as the initial carousel (one row per PNG).
-- Guarded per-row by image_path so re-running the migration never duplicates.
INSERT INTO carousel_slides (sort_order, kind, image_path, active)
SELECT s.sort_order, 'image', s.image_path, true
FROM (VALUES
  (0, '/hero/en/slide-1.png'),
  (1, '/hero/en/slide-2.png'),
  (2, '/hero/en/slide-3.png'),
  (3, '/hero/en/slide-4.png'),
  (4, '/hero/en/slide-5.png'),
  (5, '/hero/en/slide-6.png')
) AS s (sort_order, image_path)
WHERE NOT EXISTS (
  SELECT 1 FROM carousel_slides c WHERE c.image_path = s.image_path
);
