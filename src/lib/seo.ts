import type { Metadata } from "next";
import { locales, type Locale } from "@/i18n/config";

/**
 * Central SEO helpers — the single place that knows the site's canonical origin,
 * builds bilingual hreflang alternates, and emits JSON-LD. Keeps every route's
 * metadata consistent (Karpathy rule 2: one source, not scattered strings).
 */

// Canonical origin. Override per environment with SITE_URL / NEXT_PUBLIC_SITE_URL.
export const SITE_URL = (
  process.env.SITE_URL ??
  process.env.NEXT_PUBLIC_SITE_URL ??
  "https://oxot.nl"
).replace(/\/$/, "");

export const SITE_NAME = "OXOT";
export const DEFAULT_OG_IMAGE = "/og/oxot-default.png";

/** hreflang + canonical alternates for a path that exists in both locales.
 *  `path` is the part AFTER the locale, e.g. "" for home or "/nis2" for a page. */
export function alternates(locale: Locale, path: string): Metadata["alternates"] {
  const clean = path && !path.startsWith("/") ? `/${path}` : path;
  const languages: Record<string, string> = {};
  for (const l of locales) languages[l] = `${SITE_URL}/${l}${clean}`;
  languages["x-default"] = `${SITE_URL}/en${clean}`;
  return { canonical: `${SITE_URL}/${locale}${clean}`, languages };
}

/** Absolute URL for an OG image path (crawlers want absolute URLs). */
export function ogImageUrl(image?: string | null): string {
  const img = image || DEFAULT_OG_IMAGE;
  return img.startsWith("http") ? img : `${SITE_URL}${img}`;
}

export function organizationJsonLd(opts?: { sameAs?: string[] }) {
  return {
    "@context": "https://schema.org",
    "@type": "Organization",
    name: SITE_NAME,
    url: SITE_URL,
    logo: `${SITE_URL}${DEFAULT_OG_IMAGE}`,
    description:
      "OXOT — operational-technology (OT) cybersecurity consultancy. IEC 62443, NIS2, the EU Cyber Resilience Act and the AI Act, applied to industrial and critical-infrastructure environments.",
    ...(opts?.sameAs && opts.sameAs.length > 0 ? { sameAs: opts.sameAs } : {})
  };
}

export function websiteJsonLd() {
  return {
    "@context": "https://schema.org",
    "@type": "WebSite",
    name: SITE_NAME,
    url: SITE_URL
  };
}

export function articleJsonLd(opts: {
  title: string;
  description?: string | null;
  url: string;
  image?: string | null;
  datePublished?: string | null;
}) {
  return {
    "@context": "https://schema.org",
    "@type": "Article",
    headline: opts.title,
    description: opts.description ?? undefined,
    image: ogImageUrl(opts.image),
    url: opts.url,
    datePublished: opts.datePublished ?? undefined,
    author: { "@type": "Organization", name: SITE_NAME },
    publisher: {
      "@type": "Organization",
      name: SITE_NAME,
      logo: { "@type": "ImageObject", url: `${SITE_URL}${DEFAULT_OG_IMAGE}` }
    }
  };
}

/** Small helper component-free serializer for a <script type="application/ld+json">. */
export function jsonLdScript(data: unknown): string {
  return JSON.stringify(data).replace(/</g, "\\u003c");
}
