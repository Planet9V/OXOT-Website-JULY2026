import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { isLocale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { getHomeContent } from "@/lib/site-content";
import { ThemeToggle } from "@/components/theme-toggle";
import { HomeHero } from "@/components/home/home-hero";
import { HomeServices } from "@/components/home/home-services";
import { alternates, organizationJsonLd, jsonLdScript } from "@/lib/seo";

// Read the CMS content fresh on every request so admin edits appear immediately.
export const dynamic = "force-dynamic";

export async function generateMetadata({
  params
}: {
  params: Promise<{ locale: string }>;
}): Promise<Metadata> {
  const { locale } = await params;
  if (!isLocale(locale)) return {};
  const { hero } = await getHomeContent(locale);
  return { title: hero.title, description: hero.subtitle, alternates: alternates(locale, "") };
}

export default async function Home({
  params
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();
  const t = getDictionary(locale);
  const { hero, services } = await getHomeContent(locale);

  return (
    <main className="editorial">
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: jsonLdScript(organizationJsonLd()) }} />
      <div className="ed-toggle"><ThemeToggle label={t.theme.toggle} /></div>
      <div className="ed-wrap">
        <HomeHero hero={hero} locale={locale} />
        <HomeServices services={services} locale={locale} />
      </div>
    </main>
  );
}
