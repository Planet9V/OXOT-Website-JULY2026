import type { ReactNode } from "react";
import Link from "next/link";
import { notFound } from "next/navigation";
import { ChevronRight } from "lucide-react";
import { isLocale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { ConformitySubnav } from "@/components/conformity/conformity-subnav";

export const dynamic = "force-dynamic";

export default async function ConformityLayout({
  children,
  params
}: {
  children: ReactNode;
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();
  const t = getDictionary(locale).conformity;

  return (
    <main className="bg-background">
      <div className="mx-auto max-w-6xl px-4 py-10">
        {/* Breadcrumb */}
        <nav aria-label="Breadcrumb" className="mb-6">
          <ol className="flex flex-wrap items-center gap-1.5 text-xs text-muted-foreground">
            <li>
              <Link href={`/${locale}`} className="no-underline hover:text-foreground">
                {t.breadcrumb.home}
              </Link>
            </li>
            <li aria-hidden><ChevronRight className="h-3.5 w-3.5" /></li>
            <li>
              <Link href={`/${locale}/frameworks`} className="no-underline hover:text-foreground">
                {t.breadcrumb.frameworks}
              </Link>
            </li>
            <li aria-hidden><ChevronRight className="h-3.5 w-3.5" /></li>
            <li aria-current="page" className="text-foreground">{t.breadcrumb.platform}</li>
          </ol>
        </nav>

        {/* Header band */}
        <header className="mb-6">
          <p className="text-xs font-semibold uppercase tracking-[0.2em] text-primary">
            {t.kicker}
          </p>
          <h1
            className="mt-3 max-w-3xl text-3xl font-bold leading-[1.1] tracking-tight sm:text-4xl"
            style={{ fontFamily: "var(--font-display)" }}
          >
            {t.title}
          </h1>
          <p className="mt-4 max-w-2xl text-base leading-relaxed text-muted-foreground">
            {t.subtitle}
          </p>
        </header>

        {/* Sub-nav */}
        <ConformitySubnav locale={locale} labels={t.tabs} />

        <div className="mt-8">{children}</div>
      </div>
    </main>
  );
}
