import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { isLocale } from "@/i18n/config";
import { getPublishedPage } from "@/lib/content";
import { MarkdownContent, extractToc } from "@/components/markdown";
import { ArticleShell } from "@/components/article/article-shell";
import { alternates, articleJsonLd, jsonLdScript, ogImageUrl, SITE_URL } from "@/lib/seo";

export const dynamic = "force-dynamic";

// Category kicker per framework slug (falls back for other CMS pages).
const KICKER: Record<string, { en: string; nl: string }> = {
  cra: { en: "EU Regulation 2024/2847", nl: "EU-verordening 2024/2847" },
  nis2: { en: "EU Directive 2022/2555", nl: "EU-richtlijn 2022/2555" },
  "ai-act": { en: "EU Regulation 2024/1689", nl: "EU-verordening 2024/1689" },
  "machine-act": { en: "EU Regulation 2023/1230", nl: "EU-verordening 2023/1230" },
  "iec-62443": { en: "International Standard", nl: "Internationale norm" },
  "ts-50701": { en: "CENELEC Technical Specification", nl: "CENELEC technische specificatie" },
  frameworks: { en: "OT Frameworks & Regulations", nl: "OT-kaders & regelgeving" }
};

export async function generateMetadata({
  params
}: {
  params: Promise<{ locale: string; slug: string }>;
}): Promise<Metadata> {
  const { locale, slug } = await params;
  if (!isLocale(locale)) return {};
  const page = await getPublishedPage(slug, locale);
  if (!page) return {};
  const title = page.metaTitle ?? page.title;
  const description = page.metaDescription ?? page.excerpt ?? undefined;
  return {
    title,
    description,
    alternates: alternates(locale, `/${slug}`),
    openGraph: {
      title,
      description,
      type: page.contentType === "article" ? "article" : "website",
      locale,
      images: [{ url: ogImageUrl(page.ogImage) }]
    }
  };
}

export default async function CmsPage({
  params
}: {
  params: Promise<{ locale: string; slug: string }>;
}) {
  const { locale, slug } = await params;
  if (!isLocale(locale)) notFound();
  const page = await getPublishedPage(slug, locale);
  if (!page) notFound();
  const jsonLd =
    page.contentType === "article"
      ? articleJsonLd({
          title: page.metaTitle ?? page.title,
          description: page.metaDescription ?? page.excerpt,
          url: `${SITE_URL}/${locale}/${slug}`,
          image: page.ogImage
        })
      : null;
  const toc = extractToc(page.body);
  const words = page.body.replace(/```[\s\S]*?```/g, "").split(/\s+/).filter(Boolean).length;
  const readingMin = Math.max(1, Math.round(words / 200));
  const sources = (page.body.match(/\]\(https?:\/\//g) ?? []).length;
  const kicker = KICKER[slug]?.[locale as "en" | "nl"] ?? (page.contentType === "article" ? "OXOT Insights" : "OT Cybersecurity");
  const updated = page.publishedAt ? new Date(page.publishedAt).toLocaleDateString(locale === "nl" ? "nl-NL" : "en-GB", { year: "numeric", month: "short", day: "numeric" }) : null;
  const ctaLabel = locale === "nl"
    ? "Vertaal deze regelgeving naar praktische, risicogebaseerde stappen voor uw OT-omgeving."
    : "Turn this regulation into practical, risk-based steps for your OT environment.";

  return (
    <main>
      {jsonLd && (
        <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: jsonLdScript(jsonLd) }} />
      )}
      <ArticleShell
        kicker={kicker}
        title={page.title}
        dek={page.excerpt}
        readingMin={readingMin}
        updated={updated}
        sources={sources}
        toc={toc}
        ctaLabel={ctaLabel}
        ctaHref={`/${locale}/contact`}
        slug={slug}
        locale={locale}
      >
        <MarkdownContent source={page.body} toc={false} />
      </ArticleShell>
    </main>
  );
}
