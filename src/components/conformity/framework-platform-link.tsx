import Link from "next/link";
import { ArrowRight } from "lucide-react";
import { getRegulation } from "@/lib/conformity";
import type { Locale } from "@/i18n/config";

// Cross-link banner shown on the framework article pages (/cra, /nis2, /ai-act,
// /machine-act, /iec-62443) pointing into the Conformity Platform, pre-filtered
// to that regulation. Bilingual, dark/light-safe. Renders nothing for non-
// framework slugs. Closes the loop: articles → matrix/requirements.
const SLUG_TO_REG: Record<string, string> = {
  cra: "cra",
  nis2: "nis2",
  "ai-act": "ai_act",
  "machine-act": "machinery",
  "iec-62443": "iec_62443"
};

const STR = {
  en: {
    eyebrow: "In the Conformity Platform",
    body: (n: number) =>
      `${n} obligations from this framework are mapped once onto the shared, cross-regulation control model.`,
    reqs: "Explore its requirements",
    matrix: "See it in the matrix"
  },
  nl: {
    eyebrow: "In het Conformiteitsplatform",
    body: (n: number) =>
      `${n} verplichtingen uit dit kader zijn één keer afgebeeld op het gedeelde, kaderoverschrijdende beheersmodel.`,
    reqs: "Verken de vereisten",
    matrix: "Bekijk in de matrix"
  }
} as const;

export async function FrameworkPlatformLink({
  slug,
  locale
}: {
  slug: string;
  locale: string;
}) {
  const regKey = SLUG_TO_REG[slug];
  if (!regKey) return null;
  const reg = await getRegulation(regKey, locale as Locale);
  if (!reg) return null;
  const s = STR[locale === "nl" ? "nl" : "en"];

  return (
    <aside className="not-prose mb-10 rounded-xl border border-primary/25 bg-primary/[0.05] p-5">
      <p className="text-xs font-semibold uppercase tracking-[0.18em] text-primary">
        {s.eyebrow}
      </p>
      <p className="mt-2 text-sm leading-relaxed text-foreground">{s.body(reg.requirementCount)}</p>
      <div className="mt-4 flex flex-wrap gap-x-6 gap-y-2 text-sm font-medium">
        <Link
          href={`/${locale}/conformity-platform/requirements?reg=${regKey}`}
          className="group inline-flex items-center gap-1.5 text-primary no-underline"
        >
          {s.reqs}
          <ArrowRight className="h-4 w-4 transition-transform group-hover:translate-x-0.5" />
        </Link>
        <Link
          href={`/${locale}/conformity-platform/matrix`}
          className="group inline-flex items-center gap-1.5 text-primary no-underline"
        >
          {s.matrix}
          <ArrowRight className="h-4 w-4 transition-transform group-hover:translate-x-0.5" />
        </Link>
      </div>
    </aside>
  );
}
