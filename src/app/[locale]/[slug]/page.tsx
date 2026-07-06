import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { isLocale } from "@/i18n/config";
import { getPublishedPage } from "@/lib/content";
import { MarkdownContent } from "@/components/markdown";
import { alternates, articleJsonLd, jsonLdScript, ogImageUrl, SITE_URL } from "@/lib/seo";

export const dynamic = "force-dynamic";

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
  return (
    <main className="mx-auto max-w-3xl px-6 py-12">
      {jsonLd && (
        <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: jsonLdScript(jsonLd) }} />
      )}
      <h1 className="mb-6 text-4xl font-bold tracking-tight">{page.title}</h1>
      <article>
        <MarkdownContent source={page.body} />
      </article>
    </main>
  );
}
