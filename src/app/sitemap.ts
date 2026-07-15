import type { MetadataRoute } from "next";
import { locales } from "@/i18n/config";
import { listPublishedRefs } from "@/lib/content";
import { SITE_URL } from "@/lib/seo";

export const dynamic = "force-dynamic";

// Static routes that exist for every locale (not CMS-driven).
const STATIC_PATHS = [
  "",
  "/blog",
  "/contact",
  "/conformity-platform",
  "/industrial-operations",
  "/conformity-platform/regulations",
  "/conformity-platform/requirements",
  "/conformity-platform/themes",
  "/conformity-platform/sources",
  "/conformity-platform/matrix"
];

function languageAlternates(path: string): Record<string, string> {
  const langs: Record<string, string> = {};
  for (const l of locales) langs[l] = `${SITE_URL}/${l}${path}`;
  langs["x-default"] = `${SITE_URL}/en${path}`;
  return langs;
}

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const entries: MetadataRoute.Sitemap = [];

  for (const path of STATIC_PATHS) {
    for (const l of locales) {
      entries.push({
        url: `${SITE_URL}/${l}${path}`,
        changeFrequency: path === "" ? "weekly" : "monthly",
        priority: path === "" ? 1 : 0.6,
        alternates: { languages: languageAlternates(path) }
      });
    }
  }

  // CMS pages. Best-effort: if the DB is unreachable at build/request time,
  // still return the static routes rather than failing the whole sitemap.
  try {
    const refs = await listPublishedRefs();
    for (const ref of refs) {
      const path = `/${ref.slug}`;
      entries.push({
        url: `${SITE_URL}/${ref.locale}${path}`,
        lastModified: ref.updatedAt ?? undefined,
        changeFrequency: ref.contentType === "article" ? "monthly" : "weekly",
        priority: 0.7,
        alternates: { languages: languageAlternates(path) }
      });
    }
  } catch {
    // DB not available — return static routes only.
  }

  return entries;
}
