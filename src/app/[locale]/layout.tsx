import type { ReactNode } from "react";
import { notFound } from "next/navigation";
import { isLocale, locales } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { ChatWidget } from "@/components/agent/chat-widget";
import { SiteNav } from "@/components/site-nav";
import { SiteFooter } from "@/components/site-footer";
import { SocialFeed } from "@/components/social-feed";
import { SOCIALS } from "@/lib/socials";
import { CookieConsent } from "@/components/cookie-consent";
import { AnalyticsTracker } from "@/components/analytics-tracker";

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
      {/* Standard on every page: "Follow Along" social feed, then the footer. */}
      <SocialFeed socialLinks={SOCIALS} strings={t.footer.social} />
      <SiteFooter locale={locale} />
      <CookieConsent locale={locale} strings={t.cookies} />
      <ChatWidget locale={locale} strings={t.agent} />
      <AnalyticsTracker />
    </div>
  );
}
