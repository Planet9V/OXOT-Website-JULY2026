import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { isLocale, type Locale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { alternates } from "@/lib/seo";
import { getRequirements, getRegulations, getThemes, OBLIGATION_TYPES } from "@/lib/conformity";
import { RequirementsExplorer } from "@/components/conformity/requirements-explorer";

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
    title: `${t.tabs.requirements} — ${t.breadcrumb.platform} | OXOT`,
    description: t.subtitle,
    alternates: alternates(locale, "/conformity-platform/requirements")
  };
}

export default async function RequirementsPage({
  params
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();
  const t = getDictionary(locale).conformity;
  const [requirements, regulations, themes] = await Promise.all([
    getRequirements(locale as Locale),
    getRegulations(locale as Locale),
    getThemes(locale as Locale)
  ]);

  return (
    <RequirementsExplorer
      requirements={requirements}
      regulations={regulations.map((r) => ({ value: r.key, label: r.shortName }))}
      themes={themes.map((th) => ({ value: th.key, label: th.name }))}
      obligationTypeKeys={[...OBLIGATION_TYPES]}
      labels={{
        regulation: t.filters.regulation,
        theme: t.filters.theme,
        obligation: t.filters.obligation,
        allRegulations: t.filters.allRegulations,
        allThemes: t.filters.allThemes,
        allObligations: t.filters.allObligations,
        search: t.filters.search,
        searchPlaceholder: t.filters.searchPlaceholder,
        of: t.filters.of,
        countSuffix: t.filters.countSuffix,
        empty: t.filters.empty,
        table: t.table,
        obligationTypes: t.obligationTypes
      }}
    />
  );
}
