import type { ReactNode } from "react";
import { notFound } from "next/navigation";
import { isLocale, locales } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { ChatWidget } from "@/components/agent/chat-widget";
import { SiteNav } from "@/components/site-nav";
import { SiteFooter } from "@/components/site-footer";

export const dynamic = "force-dynamic";

export function generateStaticParams() {
  return locales.map((locale) => ({ locale }));
}

export default async function LocaleLayout({
  children,
  params
}: {
  children: ReactNode;
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();
  const t = getDictionary(locale);
  return (
    <div lang={locale}>
      <SiteNav locale={locale} />
      {children}
      <SiteFooter locale={locale} />
      <ChatWidget locale={locale} strings={t.agent} />
    </div>
  );
}
