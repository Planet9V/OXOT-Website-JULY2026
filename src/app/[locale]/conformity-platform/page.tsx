import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { ArrowRight } from "lucide-react";
import { isLocale, type Locale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { alternates } from "@/lib/seo";
import { getSummary, getRegulations, getTimeline, getThemes, getMatrixCells } from "@/lib/conformity";
import { Card } from "@/components/ui/card";
import { Reveal, Stagger, CountUp , StaggerItem} from "@/components/motion/fx";
import { CoverageRing } from "@/components/conformity/coverage-ring";
import { Timeline } from "@/components/conformity/timeline";

export const dynamic = "force-dynamic";

// Regulation key → published framework page slug.
const FRAMEWORK_SLUG: Record<string, string> = {
  cra: "cra",
  ai_act: "ai-act",
  machinery: "machine-act",
  iec_62443: "iec-62443",
  nis2: "nis2"
};

export async function generateMetadata({
  params
}: {
  params: Promise<{ locale: string }>;
}): Promise<Metadata> {
  const { locale } = await params;
  if (!isLocale(locale)) return {};
  const t = getDictionary(locale).conformity;
  return {
    title: `${t.title} | OXOT`,
    description: t.subtitle,
    alternates: alternates(locale, "/conformity-platform")
  };
}

export default async function ConformityOverview({
  params
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();
  const t = getDictionary(locale).conformity;
  const [summary, regulations, timeline, themes, cells] = await Promise.all([
    getSummary(),
    getRegulations(locale as Locale),
    getTimeline(locale as Locale),
    getThemes(locale as Locale),
    getMatrixCells()
  ]);

  // Theme coverage per regulation: a theme is "covered" when a matrix cell for
  // that theme+regulation maps at least one requirement.
  const coverage = regulations.map((r) => ({
    key: r.key,
    shortName: r.shortName,
    covered: themes.filter((th) =>
      cells.some(
        (c) => c.themeKey === th.key && c.regulationKey === r.key && c.requirementCount > 0
      )
    ).length,
    total: themes.length
  }));

  const kpis = [
    { label: t.kpi.regulations, value: summary.regulationCount },
    { label: t.kpi.requirements, value: summary.requirementCount },
    { label: t.kpi.themes, value: summary.themeCount },
    { label: t.kpi.mappings, value: summary.mappingCount }
  ];

  const maxReq = Math.max(1, ...regulations.map((r) => r.requirementCount));
  const regShortNames: Record<string, string> = Object.fromEntries(
    regulations.map((r) => [r.key, r.shortName])
  );
  const today = new Date().toISOString();

  return (
    <div className="space-y-12">
      {/* KPI cards */}
      <Stagger className="grid grid-cols-2 gap-4 lg:grid-cols-4">
        {kpis.map((k) => (
          <StaggerItem key={k.label}>
            <Card className="p-5">
              <div className="text-3xl font-bold tracking-tight text-foreground">
                <CountUp value={String(k.value)} />
              </div>
              <div className="mt-1 text-sm text-muted-foreground">{k.label}</div>
            </Card>
          </StaggerItem>
        ))}
      </Stagger>

      {/* Requirements by regulation */}
      <Reveal>
        <section>
          <h2 className="text-xl font-semibold tracking-tight text-foreground">
            {t.overview.byRegulation}
          </h2>
          <p className="mt-1 text-sm text-muted-foreground">{t.overview.byRegulationHint}</p>
          <div className="mt-5 space-y-3">
            {regulations.map((r) => {
              const slug = FRAMEWORK_SLUG[r.key];
              const pct = Math.round((r.requirementCount / maxReq) * 100);
              const row = (
                <div className="flex items-center gap-4">
                  <div className="w-28 shrink-0 text-sm font-medium text-foreground">
                    {r.shortName}
                  </div>
                  <div className="relative h-6 flex-1 overflow-hidden rounded-[var(--radius)] bg-muted">
                    <div
                      className="h-full rounded-[var(--radius)] bg-primary/80"
                      style={{ width: `${Math.max(pct, 4)}%` }}
                    />
                  </div>
                  <div className="w-10 shrink-0 text-right text-sm tabular-nums text-muted-foreground">
                    {r.requirementCount}
                  </div>
                </div>
              );
              return slug ? (
                <Link
                  key={r.key}
                  href={`/${locale}/${slug}`}
                  className="block rounded-[var(--radius)] no-underline transition-colors hover:bg-accent/40"
                >
                  {row}
                </Link>
              ) : (
                <div key={r.key}>{row}</div>
              );
            })}
          </div>
        </section>
      </Reveal>

      {/* Theme coverage by regulation */}
      <Reveal>
        <section>
          <h2 className="text-xl font-semibold tracking-tight text-foreground">
            {t.overview.coverage}
          </h2>
          <p className="mt-1 text-sm text-muted-foreground">{t.overview.coverageHint}</p>
          <div className="mt-6 grid grid-cols-2 justify-items-center gap-6 sm:grid-cols-3 lg:grid-cols-5">
            {coverage.map((c) => (
              <CoverageRing
                key={c.key}
                covered={c.covered}
                total={c.total}
                shortName={c.shortName}
              />
            ))}
          </div>
        </section>
      </Reveal>

      {/* Key dates */}
      <Reveal>
        <section>
          <h2 className="text-xl font-semibold tracking-tight text-foreground">
            {t.overview.keyDates}
          </h2>
          <p className="mt-1 text-sm text-muted-foreground">{t.overview.keyDatesHint}</p>
          <Timeline
            events={timeline}
            regShortNames={regShortNames}
            today={today}
            locale={locale as Locale}
            labels={{
              inForce: t.timeline.inForce,
              upcoming: t.timeline.upcoming,
              today: t.timeline.today
            }}
          />
        </section>
      </Reveal>

      <Reveal>
        <Link
          href={`/${locale}/conformity-platform/regulations`}
          className="inline-flex items-center gap-2 text-sm font-medium text-primary no-underline hover:gap-3"
        >
          {t.tabs.regulations}
          <ArrowRight className="h-4 w-4" />
        </Link>
      </Reveal>
    </div>
  );
}
