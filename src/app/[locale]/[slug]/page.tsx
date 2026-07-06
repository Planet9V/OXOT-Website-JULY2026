import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { isLocale } from "@/i18n/config";
import { getPublishedPage } from "@/lib/content";
import { MarkdownContent } from "@/components/markdown";

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
    openGraph: {
      title,
      description,
      type: page.contentType === "article" ? "article" : "website",
      locale,
      images: page.ogImage ? [{ url: page.ogImage }] : undefined
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
  return (
    <main className="mx-auto max-w-3xl px-6 py-12">
      <h1 className="mb-6 text-4xl font-bold tracking-tight">{page.title}</h1>
      <article>
        <MarkdownContent source={page.body} />
      </article>
    </main>
  );
}
