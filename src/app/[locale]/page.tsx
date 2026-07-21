import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { isLocale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { getCraHome } from "@/lib/cra-home";
import { alternates } from "@/lib/seo";
import { ThemeToggle } from "@/components/theme-toggle";
import { blocksRoutingEnabled } from "@/lib/blocks/flag";
import { BlockRenderer } from "@/components/blocks/block-renderer";
import {
  Hero,
  StatBand,
  DepartureBoard,
  RoadsSplit,
  Personas,
  Engine,
  Retainer,
  WhyOxot,
  IntakeSection,
  FinalCta
} from "@/components/cra-home/sections";

// PHASE C: the CRA-readiness intake landing page is now the front door at
// /[locale]. The previous conformity-platform home is fully preserved and
// still live at /[locale]/conformity (src/app/[locale]/conformity/page.tsx).
export const dynamic = "force-dynamic";

export async function generateMetadata({
  params
}: {
  params: Promise<{ locale: string }>;
}): Promise<Metadata> {
  const { locale } = await params;
  if (!isLocale(locale)) return {};
  const t = getDictionary(locale).craHome;
  return {
    title: t.meta.title,
    description: t.meta.description,
    alternates: alternates(locale, "")
  };
}

export default async function Home({
  params,
  searchParams
}: {
  params: Promise<{ locale: string }>;
  searchParams?: Promise<Record<string, string | string[] | undefined>>;
}) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();
  const t = getDictionary(locale);

  // Block path when the flag opts in (?blocks=1 or BLOCKS_ROUTING). Default =
  // the coded sections below (byte-identical). The Home page is block-editable
  // in the CMS Page Builder under the slug 'home'.
  const useBlocks = blocksRoutingEnabled("home", await searchParams);
  if (useBlocks) {
    return (
      <main className="bg-background text-foreground">
        <div className="mx-auto flex max-w-6xl justify-end px-4 pt-4">
          <ThemeToggle label={t.theme.toggle} />
        </div>
        <BlockRenderer slug="home" locale={locale} />
      </main>
    );
  }

  // Admin-editable CRA home content (DB-backed, JSON defaults). getCraHome
  // wraps its DB read in try/catch, so the front door never 500s if the DB
  // is down — it degrades to the shipped JSON defaults.
  const home = await getCraHome(locale);

  return (
    <main className="bg-background text-foreground">
      <div className="mx-auto flex max-w-6xl justify-end px-4 pt-4">
        <ThemeToggle label={t.theme.toggle} />
      </div>

      <Hero
        hero={home.hero}
        locale={locale}
        assistLabel={t.agent.assistCtaLabel}
        seedTemplate={t.agent.seedTemplate}
      />
      <StatBand band={home.statBand} />
      <DepartureBoard board={home.departureBoard} />
      <RoadsSplit split={home.roadsSplit} assistLabel={t.agent.assistCtaLabel} seedTemplate={t.agent.seedTemplate} />
      <Personas personas={home.personas} />
      <Engine engine={home.engine} />
      <Retainer retainer={home.retainer} />
      <WhyOxot why={home.whyOxot} />
      <IntakeSection
        intake={home.intake}
        process={home.process}
        locale={locale}
        strings={{ form: t.intakeForm, success: t.intakeSuccess }}
      />
      <FinalCta cta={home.finalCta} />
    </main>
  );
}
