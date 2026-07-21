import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { isLocale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { getSummary, type ConformitySummary } from "@/lib/conformity";
import { getConformityHome } from "@/lib/conformity-home";
import { alternates } from "@/lib/seo";
import { ThemeToggle } from "@/components/theme-toggle";
import { blocksRoutingEnabled } from "@/lib/blocks/flag";
import { BlockRenderer } from "@/components/blocks/block-renderer";
import { Reveal } from "@/components/motion/fx";
import { ConsultingCarousel } from "@/components/conformity-home/consulting-carousel";
import { Faq } from "@/components/conformity-home/faq";
import {
  Hero,
  RegulationBand,
  Stats,
  Platform,
  Problem,
  Shift,
  Comparison,
  HowItWorks,
  Testimonial,
  FinalCta
} from "@/components/conformity-home/sections";

// PHASE C ZERO-LOSS PRESERVE: this is byte-for-byte the previous
// src/app/[locale]/page.tsx body, kept live at /[locale]/conformity so the
// conformity-home content model, admin editor and route are fully intact and
// reachable — nothing here was touched besides the route location and metadata.
export const dynamic = "force-dynamic";

export async function generateMetadata({
  params
}: {
  params: Promise<{ locale: string }>;
}): Promise<Metadata> {
  const { locale } = await params;
  if (!isLocale(locale)) return {};
  const t = getDictionary(locale).conformityHome;
  return {
    title: t.meta.title,
    description: t.meta.description,
    alternates: alternates(locale, "conformity")
  };
}

export default async function ConformityHomePage({
  params,
  searchParams
}: {
  params: Promise<{ locale: string }>;
  searchParams?: Promise<Record<string, string | string[] | undefined>>;
}) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();
  const t = getDictionary(locale);
  const c = t.conformityHome;

  // Phase 2: render from page_blocks when the flag opts in (?blocks=1 or the
  // BLOCKS_ROUTING env). Default = the coded sections below (byte-identical).
  // The KPI shell (getSummary data-* attrs) is preserved either way.
  const useBlocks = blocksRoutingEnabled("conformity", await searchParams);

  // Admin-editable home content (DB-backed, JSON defaults). The lib wraps its DB
  // read in try/catch, so this page never 500s if the DB is down. Only the coded
  // path needs it — the block path reads page_blocks.
  const home = useBlocks ? null : await getConformityHome(locale);

  // Resilient data fetch: must never 500 if the DB is down.
  let summary: ConformitySummary;
  try {
    summary = await getSummary();
  } catch {
    // mappingCount fallback: count of non-empty theme×regulation matrix cells (47),
    // matching the "Mapped combinations" KPI label — see conformity.kpi.mappings in
    // both dictionaries and docs/CONFORMITY-APP.md §10.1 for the definitions considered.
    summary = { regulationCount: 5, requirementCount: 78, themeCount: 15, mappingCount: 47 };
  }

  return (
    <main
      className="bg-background text-foreground"
      data-regulations={summary.regulationCount}
      data-requirements={summary.requirementCount}
      data-themes={summary.themeCount}
      data-mappings={summary.mappingCount}
    >
      <div className="mx-auto flex max-w-6xl justify-end px-4 pt-4">
        <ThemeToggle label={t.theme.toggle} />
      </div>

      {useBlocks ? (
        <BlockRenderer slug="conformity" locale={locale} />
      ) : (
        <>
          <Hero hero={home!.hero} locale={locale} />

          {/* 2 — Consultancy carousel (dictionary-driven, unchanged) */}
          <section className="border-b border-border py-16">
            <div className="mx-auto max-w-6xl px-4">
              <Reveal>
                <ConsultingCarousel slides={c.carousel.slides} locale={locale} labels={c.carousel.labels} />
              </Reveal>
            </div>
          </section>

          <RegulationBand logoWall={home!.logoWall} />
          <Stats stats={home!.stats} />
          <Platform featureGrid={home!.featureGrid} />
          <Problem problem={home!.problem} />
          <Shift shift={home!.shift} locale={locale} />
          <Comparison comparison={home!.comparison} />
          <HowItWorks steps={home!.steps} />
          <Testimonial quote={home!.quote} />

          {/* 11 — FAQ */}
          <section className="border-b border-border py-20">
            <div className="mx-auto max-w-4xl px-4">
              <Reveal>
                <p className="text-xs font-semibold uppercase tracking-[0.2em] text-primary">
                  {home!.faq.eyebrow}
                </p>
                <h2
                  className="mt-3 text-3xl font-bold leading-[1.1] tracking-tight text-foreground sm:text-4xl"
                  style={{ fontFamily: "var(--font-display)" }}
                >
                  {home!.faq.title}
                </h2>
              </Reveal>
              <Reveal>
                <div className="mt-8">
                  <Faq items={home!.faq.items} />
                </div>
              </Reveal>
            </div>
          </section>

          <FinalCta cta={home!.cta} locale={locale} />
        </>
      )}
    </main>
  );
}
