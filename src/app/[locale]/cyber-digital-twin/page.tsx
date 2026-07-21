import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { isLocale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { getCdt } from "@/lib/cdt";
import { alternates } from "@/lib/seo";
import { ThemeToggle } from "@/components/theme-toggle";
import { blocksRoutingEnabled } from "@/lib/blocks/flag";
import { BlockRenderer } from "@/components/blocks/block-renderer";
import {
  Hero,
  StatBand,
  LivingModel,
  Boms,
  Drilldown,
  Consequence,
  Priority,
  MonteCarlo,
  Methodology,
  Outcomes,
  FinalCta
} from "@/components/cdt/sections";

// OXOT's flagship page. This static route shadows the legacy markdown [slug]
// page of the same slug ('cyber-digital-twin') — the old pages row stays intact
// (zero-loss). Content is DB-backed (site_blocks key='cdt_home') with shipped
// JSON defaults; getCdt() wraps its DB read in try/catch so the page never 500s.
export const dynamic = "force-dynamic";

export async function generateMetadata({
  params
}: {
  params: Promise<{ locale: string }>;
}): Promise<Metadata> {
  const { locale } = await params;
  if (!isLocale(locale)) return {};
  const t = getDictionary(locale).cdt;
  return {
    title: t.meta.title,
    description: t.meta.description,
    alternates: alternates(locale, "/cyber-digital-twin")
  };
}

export default async function CyberDigitalTwinPage({
  params,
  searchParams
}: {
  params: Promise<{ locale: string }>;
  searchParams?: Promise<Record<string, string | string[] | undefined>>;
}) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();
  const t = getDictionary(locale);

  // Phase 2: render from page_blocks when the flag opts in (?blocks=1 or the
  // BLOCKS_ROUTING env). Default = the coded sections below (byte-identical).
  const useBlocks = blocksRoutingEnabled("cyber-digital-twin", await searchParams);
  const cdt = useBlocks ? null : await getCdt(locale);

  return (
    <main className="bg-background text-foreground">
      <div className="mx-auto flex max-w-6xl justify-end px-4 pt-4">
        <ThemeToggle label={t.theme.toggle} />
      </div>

      {useBlocks ? (
        <BlockRenderer slug="cyber-digital-twin" locale={locale} />
      ) : (
        <>
          <Hero
            hero={cdt!.hero}
            model={cdt!.livingModel}
            locale={locale}
            assistLabel={t.agent.assistCtaLabel}
            seedTemplate={t.agent.seedTemplate}
          />
          <StatBand band={cdt!.statBand} />
          <LivingModel model={cdt!.livingModel} />
          <Boms boms={cdt!.boms} />
          <Drilldown drilldown={cdt!.drilldown} />
          <Consequence consequence={cdt!.consequence} />
          <Priority priority={cdt!.priority} />
          <MonteCarlo monteCarlo={cdt!.monteCarlo} />
          <Methodology methodology={cdt!.methodology} />
          <Outcomes outcomes={cdt!.outcomes} locale={locale} />
          <FinalCta cta={cdt!.finalCta} locale={locale} />
        </>
      )}
    </main>
  );
}
