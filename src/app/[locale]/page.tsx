import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { isLocale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { getSummary, type ConformitySummary } from "@/lib/conformity";
import { alternates, organizationJsonLd, jsonLdScript } from "@/lib/seo";
import { ThemeToggle } from "@/components/theme-toggle";
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

// Fresh on every request; keeps admin/CMS edits and DB-backed data current.
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
    alternates: alternates(locale, "")
  };
}

export default async function Home({
  params
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();
  const t = getDictionary(locale);
  const c = t.conformityHome;

  // Resilient data fetch: the front door must never 500 if the DB is down.
  let summary: ConformitySummary;
  try {
    summary = await getSummary();
  } catch {
    summary = { regulationCount: 5, requirementCount: 78, themeCount: 15, mappingCount: 61 };
  }

  return (
    <main
      className="bg-background text-foreground"
      data-regulations={summary.regulationCount}
      data-requirements={summary.requirementCount}
      data-themes={summary.themeCount}
      data-mappings={summary.mappingCount}
    >
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: jsonLdScript(organizationJsonLd()) }}
      />
      <div className="mx-auto flex max-w-6xl justify-end px-4 pt-4">
        <ThemeToggle label={t.theme.toggle} />
      </div>

      <Hero t={c.hero} locale={locale} />

      {/* 2 — Consultancy carousel */}
      <section className="border-b border-border py-16">
        <div className="mx-auto max-w-6xl px-4">
          <Reveal>
            <ConsultingCarousel slides={c.carousel.slides} locale={locale} labels={c.carousel.labels} />
          </Reveal>
        </div>
      </section>

      <RegulationBand t={c.regBand} />
      <Stats t={c.stats} />
      <Platform t={c.platform} locale={locale} />
      <Problem t={c.problem} />
      <Shift t={c.shift} locale={locale} />
      <Comparison t={c.comparison} />
      <HowItWorks t={c.howItWorks} />
      <Testimonial t={c.testimonial} />

      {/* 11 — FAQ */}
      <section className="border-b border-border py-20">
        <div className="mx-auto max-w-4xl px-4">
          <Reveal>
            <p className="text-xs font-semibold uppercase tracking-[0.2em] text-primary">
              {c.faq.eyebrow}
            </p>
            <h2
              className="mt-3 text-3xl font-bold leading-[1.1] tracking-tight text-foreground sm:text-4xl"
              style={{ fontFamily: "var(--font-display)" }}
            >
              {c.faq.heading}
            </h2>
          </Reveal>
          <Reveal>
            <div className="mt-8">
              <Faq items={c.faq.items} />
            </div>
          </Reveal>
        </div>
      </section>

      <FinalCta t={c.cta} locale={locale} />
    </main>
  );
}
