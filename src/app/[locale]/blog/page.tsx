import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { ArrowRight } from "lucide-react";
import { isLocale } from "@/i18n/config";
import { listArticles } from "@/lib/content";
import { Aurora } from "@/components/motion/fx";
import { CardGrid } from "@/components/article/blocks";

export const dynamic = "force-dynamic";

export async function generateMetadata({
  params
}: {
  params: Promise<{ locale: string }>;
}): Promise<Metadata> {
  const { locale } = await params;
  if (!isLocale(locale)) return {};
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
  const items = articles.map((a) => ({
    title: a.title,
    href: `/${locale}/${a.slug}`,
    desc: a.excerpt ?? ""
  }));

  return (
    <main className="bg-background">
      {/* hero */}
      <header className="relative overflow-hidden border-b border-border">
        <Aurora className="opacity-70" />
        <div className="relative mx-auto max-w-6xl px-6 pb-12 pt-16 lg:px-8">
          <p className="text-xs font-semibold uppercase tracking-[0.2em] text-primary">
            {nl ? "OXOT Kennisbank" : "OXOT Insights"}
          </p>
          <h1
            className="mt-4 max-w-3xl text-4xl font-bold leading-[1.08] tracking-tight sm:text-5xl"
            style={{ fontFamily: "var(--font-display)" }}
          >
            {nl ? "Inzichten in OT-cybersecurity" : "Insights on OT cybersecurity"}
          </h1>
          <p className="mt-5 max-w-2xl text-lg leading-relaxed text-muted-foreground">
            {nl
              ? "Analyses, standpunten en praktische gidsen over het beveiligen van industriële omgevingen — van regelgeving tot risicomodellering."
              : "Analysis, points of view and practical guides on securing industrial environments — from regulation to risk modelling."}
          </p>
        </div>
      </header>

      {/* articles */}
      <div className="mx-auto max-w-6xl px-6 py-12 lg:px-8">
        {items.length === 0 ? (
          <div className="rounded-2xl border border-dashed border-border p-10 text-center">
            <p className="text-muted-foreground">
              {nl ? "Binnenkort verschijnen hier artikelen." : "Articles are coming soon."}
            </p>
            <Link
              href={`/${locale}/frameworks`}
              className="mt-4 inline-flex items-center gap-2 text-sm font-medium text-primary hover:gap-3"
            >
              {nl ? "Bekijk intussen de kaders" : "Explore the frameworks meanwhile"}
              <ArrowRight className="h-4 w-4" />
            </Link>
          </div>
        ) : (
          <CardGrid items={items} />
        )}
      </div>
    </main>
  );
}
