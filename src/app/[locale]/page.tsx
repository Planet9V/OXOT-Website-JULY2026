import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { isLocale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { getCraHome } from "@/lib/cra-home";
import { alternates } from "@/lib/seo";
import { ThemeToggle } from "@/components/theme-toggle";
import {
  Hero,
  DepartureBoard,
  RoadsSplit,
  Personas,
  Retainer,
  ProcessStrip,
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
  params
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();
  const t = getDictionary(locale);

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
        intake={{ form: t.intakeForm, success: t.intakeSuccess }}
        assistLabel={t.agent.assistCtaLabel}
        seedTemplate={t.agent.seedTemplate}
      />
      <DepartureBoard board={home.departureBoard} />
      <RoadsSplit split={home.roadsSplit} assistLabel={t.agent.assistCtaLabel} seedTemplate={t.agent.seedTemplate} />
      <Personas personas={home.personas} />
      <Retainer retainer={home.retainer} />
      <ProcessStrip process={home.process} />
      <FinalCta cta={home.finalCta} />
    </main>
  );
}
