import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { ArrowRight } from "lucide-react";
import { isLocale, type Locale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { alternates } from "@/lib/seo";
import { getThemes } from "@/lib/conformity";
import { Card } from "@/components/ui/card";
import { Reveal, Stagger , StaggerItem} from "@/components/motion/fx";

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
    title: `${t.tabs.themes} — ${t.breadcrumb.platform} | OXOT`,
    description: t.themes.intro,
    alternates: alternates(locale, "/conformity-platform/themes")
  };
}

export default async function ThemesPage({
  params
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();
  const t = getDictionary(locale).conformity;
  const themes = await getThemes(locale as Locale);

  return (
    <div className="space-y-6">
      <Reveal>
        <p className="text-sm text-muted-foreground">{t.themes.intro}</p>
      </Reveal>

      <Stagger className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {themes.map((theme) => (
          <StaggerItem key={theme.key}>
            <Link
              href={`/${locale}/conformity-platform/matrix`}
              className="group block h-full no-underline"
            >
              <Card className="flex h-full flex-col p-5 transition-colors hover:border-primary/40">
                <div className="flex items-start justify-between gap-2">
                  <h2 className="font-semibold tracking-tight text-foreground">{theme.name}</h2>
                  <ArrowRight className="mt-1 h-4 w-4 shrink-0 -translate-x-1 text-muted-foreground opacity-0 transition-all group-hover:translate-x-0 group-hover:opacity-100 group-hover:text-primary" />
                </div>
                {theme.description && (
                  <p className="mt-2 flex-1 text-sm leading-relaxed text-muted-foreground">
                    {theme.description}
                  </p>
                )}
                <div className="mt-4 text-sm font-medium text-foreground">
                  {theme.requirementCount}{" "}
                  <span className="font-normal text-muted-foreground">
                    {t.mappedRequirements}
                  </span>
                </div>
              </Card>
            </Link>
          </StaggerItem>
        ))}
      </Stagger>
    </div>
  );
}
