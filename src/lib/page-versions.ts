import { pool } from "@/lib/db";
import type { PoolClient } from "pg";

// Transactional helpers for the zero-loss CMS version history (page_versions).
// Append-only: nothing here ever deletes or overwrites an existing version row.

export interface PageVersionSummary {
  id: number;
  versionNumber: number;
  state: string;
  note: string | null;
  createdAt: Date;
  title: string;
}

export interface PageVersionFull extends PageVersionSummary {
  slug: string;
  locale: string;
  body: string;
  metaTitle: string | null;
  metaDescription: string | null;
  excerpt: string | null;
  ogImage: string | null;
  contentType: string;
}

/**
 * Snapshot the CURRENT `pages` row (slug, locale) into page_versions at the
 * next version_number, tagged with `state` + `note`. No-op if the page row
 * doesn't exist. Runs on the given client if inside a transaction, otherwise
 * uses the shared pool.
 */
export async function snapshotCurrent(
  slug: string,
  locale: string,
  state: "draft" | "published" | "archived",
  note: string,
  client: PoolClient | typeof pool = pool
): Promise<void> {
  const { rows } = await client.query(
    `SELECT title, body, meta_title, meta_description, excerpt, og_image, content_type
       FROM pages WHERE slug=$1 AND locale=$2 LIMIT 1`,
    [slug, locale]
  );
  const page = rows[0];
  if (!page) return; // nothing to snapshot yet

  await client.query(
    `INSERT INTO page_versions
       (slug, locale, version_number, state, title, body,
        meta_title, meta_description, excerpt, og_image, content_type, note)
     VALUES (
       $1, $2,
       COALESCE((SELECT MAX(version_number) FROM page_versions WHERE slug=$1 AND locale=$2), 0) + 1,
       $3, $4, $5, $6, $7, $8, $9, $10, $11
     )`,
    [
      slug, locale, state,
      page.title, page.body,
      page.meta_title, page.meta_description, page.excerpt, page.og_image, page.content_type,
      note,
    ]
  );
}

export async function listVersions(slug: string, locale: string): Promise<PageVersionSummary[]> {
  const { rows } = await pool.query(
    `SELECT id, version_number AS "versionNumber", state, note,
            created_at AS "createdAt", title
       FROM page_versions
      WHERE slug=$1 AND locale=$2
      ORDER BY version_number DESC`,
    [slug, locale]
  );
  return rows;
}

export async function getVersion(id: number): Promise<PageVersionFull | null> {
  const { rows } = await pool.query(
    `SELECT id, slug, locale, version_number AS "versionNumber", state, note,
            created_at AS "createdAt", title, body,
            meta_title AS "metaTitle", meta_description AS "metaDescription",
            excerpt, og_image AS "ogImage", content_type AS "contentType"
       FROM page_versions WHERE id=$1 LIMIT 1`,
    [id]
  );
  return rows[0] ?? null;
}

/**
 * Restore a page to a prior version, zero-loss: in ONE transaction, first
 * snapshot the current `pages` row (so the pre-restore state is never lost),
 * then copy the target version's content into the `pages` row. The page's
 * current published state is left as-is (restore only changes content).
 * Never deletes anything.
 */
export async function restoreVersion(
  slug: string,
  locale: string,
  versionId: number
): Promise<{ ok: true } | { ok: false; error: string }> {
  const client = await pool.connect();
  try {
    await client.query("BEGIN");

    const { rows: versionRows } = await client.query(
      `SELECT slug, locale, title, body, meta_title, meta_description, excerpt, og_image, content_type
         FROM page_versions WHERE id=$1 LIMIT 1`,
      [versionId]
    );
    const version = versionRows[0];
    if (!version || version.slug !== slug || version.locale !== locale) {
      await client.query("ROLLBACK");
      return { ok: false, error: "version not found for this page" };
    }

    const { rows: currentRows } = await client.query(
      `SELECT published FROM pages WHERE slug=$1 AND locale=$2 LIMIT 1`,
      [slug, locale]
    );
    if (!currentRows.length) {
      await client.query("ROLLBACK");
      return { ok: false, error: "page not found" };
    }
    const published: boolean = currentRows[0].published;

    // Snapshot current content BEFORE overwriting, so the pre-restore state
    // is never lost.
    await snapshotCurrent(
      slug, locale,
      published ? "published" : "draft",
      "Auto-snapshot before restore",
      client
    );

    await client.query(
      `UPDATE pages
          SET title=$3, body=$4, meta_title=$5, meta_description=$6,
              excerpt=$7, og_image=$8, content_type=$9, updated_at=now()
        WHERE slug=$1 AND locale=$2`,
      [
        slug, locale,
        version.title, version.body,
        version.meta_title, version.meta_description, version.excerpt, version.og_image, version.content_type,
      ]
    );

    await client.query("COMMIT");
    return { ok: true };
  } catch (err) {
    await client.query("ROLLBACK").catch(() => {});
    throw err;
  } finally {
    client.release();
  }
}
