import { pool } from "./db";

// DB-backed hero carousel slides (migration 033_carousel.sql), reconciled with
// the app's existing static hero deck. The server <Hero> reads active slides via
// getCarouselSlides(); if the table is empty OR the DB is down it falls back to
// staticHeroSlides() so the home front door never breaks.

export interface HeroSlide {
  src: string;
  caption: string | null;
  link: string | null;
}

const HERO_STATIC_COUNT = 6;

// The pre-rendered hero deck shipped in public/hero/<locale>/slide-N.png. Used
// as the guaranteed fallback (and seeded into the DB by migration 033 for EN).
export function staticHeroSlides(locale: string): HeroSlide[] {
  const l = locale === "nl" ? "nl" : "en";
  return Array.from({ length: HERO_STATIC_COUNT }, (_, k) => ({
    src: `/hero/${l}/slide-${k + 1}.png`,
    caption: null,
    link: null,
  }));
}

// Active slides for the hero, ordered by sort_order, with the caption resolved
// for the active locale. Returns [] on any DB error so callers fall back to the
// static set. Never throws.
export async function getCarouselSlides(locale: string): Promise<HeroSlide[]> {
  const l = locale === "nl" ? "nl" : "en";
  try {
    const { rows } = await pool.query(
      `SELECT image_path, caption_en, caption_nl, link_url
         FROM carousel_slides
        WHERE active = true
        ORDER BY sort_order ASC, id ASC`
    );
    return rows.map((r) => ({
      src: r.image_path as string,
      caption: ((l === "nl" ? r.caption_nl : r.caption_en) as string | null) ?? null,
      link: (r.link_url as string | null) ?? null,
    }));
  } catch {
    return [];
  }
}
