import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { ArrowRight, ExternalLink } from "lucide-react";
import { isLocale, type Locale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { alternates } from "@/lib/seo";
import { getRegulations } from "@/lib/conformity";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Reveal, Stagger, SpotlightCard } from "@/components/motion/fx";

export const dynamic = "force-dynamic";

export async function generateMetadata({
  params
}: {
  params: Promise<{ locale: string }>;
}): Promise<Metadata> {
  const { locale } = await params;
  if (!isLocale(locale)) return {};
  const t = getDictionary(locale).conformity;
  return {
    title: `${t.tabs.regulations} — ${t.breadcrumb.platform} | OXOT`,
    description: t.regulations.intro,
    alternates: alternates(locale, "/conformity-platform/regulations")
  };
}

export default async function RegulationsPage({
  params
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();
  const t = getDictionary(locale).conformity;
  const regulations = await getRegulations(locale as Locale);

  return (
    <div className="space-y-6">
      <Reveal>
        <p className="text-sm text-muted-foreground">{t.regulations.intro}</p>
      </Reveal>

      <Stagger className="grid gap-5 md:grid-cols-2">
        {regulations.map((r) => {
          const year = r.inForceDate ? r.inForceDate.slice(0, 4) : null;
          return (
            <Stagger.Item key={r.key}>
              <SpotlightCard className="h-full">
                <Card className="flex h-full flex-col p-6">
                  <div className="flex items-start justify-between gap-3">
                    <div>
                      <div className="text-lg font-semibold tracking-tight text-foreground">
                        {r.shortName}
                      </div>
                      <div className="text-sm text-muted-foreground">{r.name}</div>
                    </div>
                    {r.jurisdiction && (
                      <Badge variant="outline" className="shrink-0">
                        {r.jurisdiction}
                      </Badge>
                    )}
                  </div>

                  <div className="mt-3 flex flex-wrap items-center gap-x-4 gap-y-1 text-sm">
                    {year && (
                      <span className="text-muted-foreground">
                        {t.inForce} {year}
                      </span>
                    )}
                    <span className="font-medium text-foreground">
                      {r.requirementCount} {t.regulations.requirementsCount}
                    </span>
                  </div>

                  {r.fullTitle && (
                    <p className="mt-3 text-sm font-medium text-foreground">{r.fullTitle}</p>
                  )}
                  {r.summary && (
                    <p className="mt-2 text-sm leading-relaxed text-muted-foreground">
                      {r.summary}
                    </p>
                  )}

                  <div className="mt-5 flex flex-wrap items-center gap-4 pt-1">
                    {r.sourceUrl && (
                      <a
                        href={r.sourceUrl}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="inline-flex items-center gap-1.5 text-sm font-medium text-primary no-underline hover:underline"
                      >
                        {t.officialText}
                        <ExternalLink className="h-3.5 w-3.5" />
                      </a>
                    )}
                    <Link
                      href={`/${locale}/conformity-platform/matrix`}
                      className="inline-flex items-center gap-1.5 text-sm font-medium text-foreground no-underline hover:text-primary"
                    >
                      {t.viewInMatrix}
                      <ArrowRight className="h-3.5 w-3.5" />
                    </Link>
                  </div>
                </Card>
              </SpotlightCard>
            </Stagger.Item>
          );
        })}
      </Stagger>
    </div>
  );
}
