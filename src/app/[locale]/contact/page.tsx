import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { isLocale, type Locale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { getPublishedPage } from "@/lib/content";
import { MarkdownContent } from "@/components/markdown";
import { ContactForm } from "@/components/contact-form";
import { alternates } from "@/lib/seo";

export const dynamic = "force-dynamic";

export async function generateMetadata({
  params
}: {
  params: Promise<{ locale: string }>;
}): Promise<Metadata> {
  const { locale } = await params;
  if (!isLocale(locale)) return {};
  const page = await getPublishedPage("contact", locale);
  return {
    title: page?.metaTitle ?? "Contact",
    description: page?.metaDescription ?? page?.excerpt ?? undefined,
    alternates: alternates(locale, "/contact")
  };
}

export default async function ContactPage({
  params
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();
  const l = locale as Locale;
  const t = getDictionary(l);
  // CMS copy stays editable in the admin; the form is appended below it.
  const page = await getPublishedPage("contact", l);

  return (
    <main className="mx-auto max-w-3xl px-6 py-12">
      <h1 className="mb-6 text-4xl font-bold tracking-tight">{page?.title ?? "Contact"}</h1>
      {page?.body && (
        <article className="mb-10">
          <MarkdownContent source={page.body} toc={false} />
        </article>
      )}
      <div className="rounded-2xl border border-border p-6 sm:p-8">
        <ContactForm locale={l} strings={t.contact} />
      </div>
    </main>
  );
}
