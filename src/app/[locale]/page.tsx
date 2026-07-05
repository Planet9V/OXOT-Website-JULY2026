import { notFound } from "next/navigation";
import { isLocale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { Button } from "@/components/ui/button";
import { ThemeToggle } from "@/components/theme-toggle";

export default async function Home({
  params
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();
  const t = getDictionary(locale);

  return (
    <main className="mx-auto flex min-h-screen max-w-3xl flex-col items-start justify-center gap-6 px-6">
      <div className="self-end">
        <ThemeToggle label={t.theme.toggle} />
      </div>
      <h1 className="text-4xl font-bold tracking-tight">{t.home.hero.title}</h1>
      <p className="text-lg text-muted-foreground">{t.home.hero.subtitle}</p>
      <Button>{t.home.hero.cta}</Button>
    </main>
  );
}
