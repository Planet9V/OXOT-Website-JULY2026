import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { isLocale, type Locale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { alternates } from "@/lib/seo";
import { getThemes, getRegulations, getMatrixCells } from "@/lib/conformity";
import { MatrixGrid } from "@/components/conformity/matrix-grid";
import { Reveal } from "@/components/motion/fx";

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
    title: `${t.tabs.matrix} — ${t.breadcrumb.platform} | OXOT`,
    description: t.matrix.intro,
    alternates: alternates(locale, "/conformity-platform/matrix")
  };
}

export default async function MatrixPage({
  params
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();
  const t = getDictionary(locale).conformity;
  const [themes, regulations, cells] = await Promise.all([
    getThemes(locale as Locale),
    getRegulations(locale as Locale),
    getMatrixCells()
  ]);

  return (
    <div className="space-y-5">
      <Reveal>
        <p className="text-sm text-muted-foreground">{t.matrix.intro}</p>
      </Reveal>
      <MatrixGrid
        themes={themes.map((th) => ({ key: th.key, label: th.name }))}
        regulations={regulations.map((r) => ({ key: r.key, label: r.shortName }))}
        cells={cells}
        labels={{
          themeColumn: t.matrix.themeColumn,
          legend: t.matrix.legend,
          empty: t.matrix.empty,
          detailTitle: t.matrix.detailTitle,
          refsLabel: t.matrix.refsLabel
        }}
      />
    </div>
  );
}
