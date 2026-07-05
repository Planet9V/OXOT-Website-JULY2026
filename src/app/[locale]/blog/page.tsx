import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { isLocale } from "@/i18n/config";
import { listArticles } from "@/lib/content";

export const dynamic = "force-dynamic";

export async function generateMetadata({
  params
}: {
  params: Promise<{ locale: string }>;
}): Promise<Metadata> {
  const { locale } = await params;
  const nl = locale === "nl";
  return {
    title: nl ? "Kennisbank | OXOT" : "Insights | OXOT",
    description: nl
      ? "Artikelen en inzichten over OT-cybersecurity van OXOT."
      : "Articles and insights on OT cybersecurity from OXOT."
  };
}

export default async function BlogIndex({
  params
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();
  const articles = await listArticles(locale);
  const nl = locale === "nl";

  return (
    <main className="mx-auto max-w-3xl px-6 py-12">
      <h1 className="mb-6 text-3xl font-bold tracking-tight">
        {nl ? "Kennisbank" : "Insights"}
      </h1>
      {articles.length === 0 ? (
        <p className="text-muted-foreground">
          {nl ? "Binnenkort verschijnen hier artikelen." : "Articles are coming soon."}
        </p>
      ) : (
        <ul className="space-y-6">
          {articles.map((a) => (
            <li key={a.slug} className="border-b border-border pb-6">
              <Link
                href={`/${locale}/${a.slug}`}
                className="text-xl font-semibold hover:text-primary"
              >
                {a.title}
              </Link>
              {a.excerpt && (
                <p className="mt-2 text-muted-foreground">{a.excerpt}</p>
              )}
            </li>
          ))}
        </ul>
      )}
    </main>
  );
}
