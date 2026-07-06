import { notFound } from "next/navigation";
import Link from "next/link";
import { isLocale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { ThemeToggle } from "@/components/theme-toggle";
import { HeroVisual } from "@/components/hero-visual";

export default async function Home({
  params
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();
  const t = getDictionary(locale);
  const hero = t.home.hero;
  const services = t.home.services;

  const ctaBase =
    "inline-flex items-center justify-center rounded-lg px-5 py-2.5 text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-2";

  return (
    <main className="mx-auto max-w-6xl px-6 py-12">
      <div className="mb-6 flex justify-end">
        <ThemeToggle label={t.theme.toggle} />
      </div>

      <section className="grid items-center gap-10 lg:grid-cols-2">
        {/* left: the signature orange rule + kicker + serif headline */}
        <div className="border-l-2 border-primary pl-6">
          <p className="oxot-kicker">{hero.kicker}</p>
          <h1 className="mt-3 text-4xl font-bold tracking-tight sm:text-5xl">
            {hero.title}
          </h1>
          <p className="mt-6 text-lg text-muted-foreground">{hero.subtitle}</p>
          <p className="mt-4 text-base text-muted-foreground">{hero.subtitle2}</p>
          <div className="mt-8 flex flex-wrap gap-3">
            <Link
              href={`/${locale}/contact`}
              className={`${ctaBase} bg-primary text-primary-foreground hover:opacity-90`}
            >
              {hero.cta}
            </Link>
            <Link
              href={`/${locale}/cyber-digital-twin`}
              className={`${ctaBase} border border-border bg-background hover:bg-muted`}
            >
              {hero.cta2}
            </Link>
          </div>
        </div>

        {/* right: the Cyber Digital Twin visual */}
        <div className="hidden lg:block">
          <HeroVisual className="h-auto w-full" />
        </div>
      </section>

      <section className="mt-24 border-t border-border pt-12">
        <h2 className="text-2xl font-semibold tracking-tight">
          {services.heading}
        </h2>
        <div className="mt-6 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {services.items.map((it) => (
            <Link
              key={it.name}
              href={`/${locale}${it.href}`}
              className="group rounded-lg border border-border p-5 transition-colors hover:border-primary"
            >
              <h3 className="font-semibold group-hover:text-primary">{it.name}</h3>
              <p className="mt-2 text-sm text-muted-foreground">{it.desc}</p>
            </Link>
          ))}
        </div>
      </section>
    </main>
  );
}
