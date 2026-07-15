import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { isLocale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { Button } from "@/components/ui/button";

export const dynamic = "force-dynamic";

export async function generateMetadata({
  params
}: {
  params: Promise<{ locale: string }>;
}): Promise<Metadata> {
  const { locale } = await params;
  if (!isLocale(locale)) return {};
  return { title: getDictionary(locale).newsletterResult.confirmedTitle };
}

export default async function NewsletterConfirmedPage({
  params
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();
  const t = getDictionary(locale).newsletterResult;

  return (
    <main className="mx-auto flex min-h-[60vh] max-w-2xl flex-col items-center justify-center px-6 py-24 text-center">
      <h1
        className="text-3xl font-bold tracking-tight sm:text-4xl"
        style={{ fontFamily: "var(--font-display)" }}
      >
        {t.confirmedTitle}
      </h1>
      <p className="mt-4 max-w-md text-muted-foreground">{t.confirmedBody}</p>
      <div className="mt-8">
        <Button asChild>
          <Link href={`/${locale}`}>{t.backHome}</Link>
        </Button>
      </div>
    </main>
  );
}
