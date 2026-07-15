import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { isLocale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { getHomeContent } from "@/lib/site-content";
import { ThemeToggle } from "@/components/theme-toggle";
import { HomeHero } from "@/components/home/home-hero";
import { HomeApproach } from "@/components/home/home-approach";
import { HomeTwin } from "@/components/home/home-twin";
import { HomeFrameworks } from "@/components/home/home-frameworks";
import { HomeCta } from "@/components/home/home-cta";
import { alternates } from "@/lib/seo";

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
  return {
    title: hero.title,
    description: hero.subtitle,
    alternates: alternates(locale, "/industrial-operations")
  };
}

export default async function IndustrialOperations({
  params
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();
  const t = getDictionary(locale);
  const { hero, services } = await getHomeContent(locale);
  const home = t.home;

  return (
    <main className="editorial">
      <div className="ed-toggle"><ThemeToggle label={t.theme.toggle} /></div>
      <div className="ed-wrap">
        <HomeHero hero={hero} locale={locale} />
        <HomeApproach content={home.approach} />
        <HomeTwin content={home.twin} card={hero.card} locale={locale} />
        <HomeFrameworks
          eyebrow={home.frameworksBand.eyebrow}
          heading={home.frameworksBand.heading}
          frameworks={services.frameworks}
          locale={locale}
        />
        <HomeCta cta={services.cta} locale={locale} />
      </div>
    </main>
  );
}
