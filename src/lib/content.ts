import { pool } from "./db";
import type { Locale } from "@/i18n/config";

export interface Page {
  slug: string;
  locale: string;
  title: string;
  body: string;
  metaTitle: string | null;
  metaDescription: string | null;
  excerpt: string | null;
  ogImage: string | null;
  contentType: string;
  publishedAt: Date | null;
}
export interface MenuItem { label: string; href: string; }
export interface ArticleSummary { slug: string; title: string; excerpt: string | null }

export async function getPublishedPage(
  slug: string,
  locale: Locale
): Promise<Page | null> {
  const { rows } = await pool.query(
    `SELECT slug, locale, title, body,
            meta_title       AS "metaTitle",
            meta_description AS "metaDescription",
            excerpt,
            og_image         AS "ogImage",
            content_type     AS "contentType",
            published_at     AS "publishedAt"
       FROM pages
      WHERE slug=$1 AND locale=$2 AND published=true LIMIT 1`,
    [slug, locale]
  );
  return rows[0] ?? null;
}

export async function getMenu(key: string, locale: Locale): Promise<MenuItem[]> {
  // Flat top-level list (used by the footer). Excludes child items.
  const { rows } = await pool.query(
    `SELECT mi.label, mi.href FROM menu_items mi
       JOIN menus m ON m.id = mi.menu_id
      WHERE m.key=$1 AND mi.locale=$2 AND mi.parent_id IS NULL
      ORDER BY mi.position`,
    [key, locale]
  );
  return rows;
}

export interface MenuNode {
  id: number;
  label: string;
  href: string;
  description: string | null;
  children: MenuNode[];
}

/** Nested menu tree (top-level items + their children) for the mega-menu nav. */
export async function getMenuTree(key: string, locale: Locale): Promise<MenuNode[]> {
  const { rows } = await pool.query(
    `SELECT mi.id, mi.parent_id AS "parentId", mi.label, mi.href, mi.description, mi.position
       FROM menu_items mi JOIN menus m ON m.id = mi.menu_id
      WHERE m.key=$1 AND mi.locale=$2
      ORDER BY mi.position`,
    [key, locale]
  );
  const byId = new Map<number, MenuNode>();
  const roots: MenuNode[] = [];
  for (const r of rows) byId.set(Number(r.id), { id: Number(r.id), label: r.label, href: r.href, description: r.description ?? null, children: [] });
  for (const r of rows) {
    const node = byId.get(Number(r.id))!;
    if (r.parentId != null && byId.has(Number(r.parentId))) byId.get(Number(r.parentId))!.children.push(node);
    else roots.push(node);
  }
  return roots;
}

// All published slugs per locale, with type + last-modified — used by the sitemap.
export interface PublishedRef { slug: string; locale: string; contentType: string; updatedAt: Date | null }
export async function listPublishedRefs(): Promise<PublishedRef[]> {
  const { rows } = await pool.query(
    `SELECT slug, locale,
            content_type AS "contentType",
            COALESCE(published_at, updated_at) AS "updatedAt"
       FROM pages
      WHERE published=true
      ORDER BY slug, locale`
  );
  return rows;
}

// Published articles (content_type='article'), newest first — used by the blog index.
export async function listArticles(locale: Locale): Promise<ArticleSummary[]> {
  const { rows } = await pool.query(
    `SELECT slug, title, excerpt FROM pages
      WHERE locale=$1 AND published=true AND content_type='article'
      ORDER BY COALESCE(published_at, updated_at) DESC`,
    [locale]
  );
  return rows;
}
