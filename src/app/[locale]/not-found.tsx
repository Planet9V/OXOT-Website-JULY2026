"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { isLocale, defaultLocale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { Button } from "@/components/ui/button";

// Next.js does not pass the [locale] route param into not-found.tsx, so the
// locale is read from the browser's current pathname instead (falls back to
// "en" if it can't be determined — e.g. during the first static render pass).
export default function LocaleNotFound() {
  const pathname = usePathname() ?? "";
  const seg = pathname.split("/").filter(Boolean)[0];
  const locale = isLocale(seg) ? seg : defaultLocale;
  const t = getDictionary(locale).notFound;

  return (
    <main
      id="main-content"
      className="mx-auto flex min-h-[60vh] max-w-2xl flex-col items-center justify-center px-6 py-24 text-center"
    >
      <p className="oxot-kicker mb-4">404</p>
      <h1
        className="text-4xl font-bold tracking-tight sm:text-5xl"
        style={{ fontFamily: "var(--font-display)" }}
      >
        {t.title}
      </h1>
      <p className="mt-4 max-w-md text-muted-foreground">{t.body}</p>
      <div className="mt-8 flex flex-wrap items-center justify-center gap-3">
        <Button asChild>
          <Link href={`/${locale}`}>{t.backHome}</Link>
        </Button>
        <Button asChild variant="outline">
          <Link href={`/${locale}/contact`}>{t.contact}</Link>
        </Button>
      </div>
    </main>
  );
}
