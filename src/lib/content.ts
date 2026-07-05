import { pool } from "./db";
import type { Locale } from "@/i18n/config";

export interface Page { slug: string; locale: string; title: string; body: string; }
export interface MenuItem { label: string; href: string; }

export async function getPublishedPage(
  slug: string,
  locale: Locale
): Promise<Page | null> {
  const { rows } = await pool.query(
    `SELECT slug, locale, title, body FROM pages
     WHERE slug=$1 AND locale=$2 AND published=true LIMIT 1`,
    [slug, locale]
  );
  return rows[0] ?? null;
}

export async function getMenu(key: string, locale: Locale): Promise<MenuItem[]> {
  const { rows } = await pool.query(
    `SELECT mi.label, mi.href FROM menu_items mi
       JOIN menus m ON m.id = mi.menu_id
      WHERE m.key=$1 AND mi.locale=$2
      ORDER BY mi.position`,
    [key, locale]
  );
  return rows;
}
