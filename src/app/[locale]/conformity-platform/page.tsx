import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { ArrowRight } from "lucide-react";
import { isLocale, type Locale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { alternates } from "@/lib/seo";
import { getSummary, getRegulations, getTimeline } from "@/lib/conformity";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Reveal, Stagger, CountUp } from "@/components/motion/fx";

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
  const [summary, regulations, timeline] = await Promise.all([
    getSummary(),
    getRegulations(locale as Locale),
    getTimeline(locale as Locale)
  ]);

  const kpis = [
    { label: t.kpi.regulations, value: summary.regulationCount },
    { label: t.kpi.requirements, value: summary.requirementCount },
    { label: t.kpi.themes, value: summary.themeCount },
    { label: t.kpi.mappings, value: summary.mappingCount }
  ];

  const maxReq = Math.max(1, ...regulations.map((r) => r.requirementCount));
  const shortNameByKey = new Map(regulations.map((r) => [r.key, r.shortName]));
  const dateFmt = (d: string) =>
    new Date(d).toLocaleDateString(locale === "nl" ? "nl-NL" : "en-GB", {
      year: "numeric",
      month: "short",
      day: "numeric"
    });

  return (
    <div className="space-y-12">
      {/* KPI cards */}
      <Stagger className="grid grid-cols-2 gap-4 lg:grid-cols-4">
        {kpis.map((k) => (
          <Stagger.Item key={k.label}>
            <Card className="p-5">
              <div className="text-3xl font-bold tracking-tight text-foreground">
                <CountUp value={String(k.value)} />
              </div>
              <div className="mt-1 text-sm text-muted-foreground">{k.label}</div>
            </Card>
          </Stagger.Item>
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

      {/* Key dates */}
      <Reveal>
        <section>
          <h2 className="text-xl font-semibold tracking-tight text-foreground">
            {t.overview.keyDates}
          </h2>
          <p className="mt-1 text-sm text-muted-foreground">{t.overview.keyDatesHint}</p>
          <ol className="mt-5 space-y-4 border-l border-border pl-6">
            {timeline.map((e, i) => (
              <li key={`${e.date}-${i}`} className="relative">
                <span className="absolute -left-[27px] top-1.5 h-2.5 w-2.5 rounded-full border-2 border-primary bg-background" />
                <div className="flex flex-wrap items-center gap-x-3 gap-y-1">
                  <time className="text-sm font-semibold tabular-nums text-foreground">
                    {dateFmt(e.date)}
                  </time>
                  {e.regulationKey && shortNameByKey.has(e.regulationKey) && (
                    <Badge variant="secondary">{shortNameByKey.get(e.regulationKey)}</Badge>
                  )}
                </div>
                <p className="mt-1 text-sm text-muted-foreground">{e.label}</p>
              </li>
            ))}
          </ol>
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
