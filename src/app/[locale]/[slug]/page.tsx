import { notFound } from "next/navigation";
import { isLocale } from "@/i18n/config";
import { getPublishedPage } from "@/lib/content";

export const dynamic = "force-dynamic";

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
      <h1 className="mb-4 text-3xl font-bold tracking-tight">{page.title}</h1>
      <article className="whitespace-pre-wrap leading-relaxed text-foreground">
        {page.body}
      </article>
    </main>
  );
}
