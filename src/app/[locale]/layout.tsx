import type { ReactNode } from "react";
import { notFound } from "next/navigation";
import { isLocale, locales } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { ChatWidget } from "@/components/agent/chat-widget";
import { SiteNav } from "@/components/site-nav";
import { SiteFooter } from "@/components/site-footer";
import { SocialFeed } from "@/components/social-feed";
import { getPublicSocials } from "@/lib/socials";
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
  const socials = await getPublicSocials();
  return (
    <div lang={locale}>
      <a href="#main-content" className="skip-link">
        {t.a11y.skipToContent}
      </a>
      <SiteNav locale={locale} />
      {/* Each page already renders its own <main>; this div just gives the
          skip-link a stable landmark to jump to without nesting <main> tags. */}
      <div id="main-content">{children}</div>
      {/* Standard on every page: "Follow Along" social feed, then the footer. */}
      <SocialFeed socialLinks={socials} strings={t.footer.social} />
      <SiteFooter locale={locale} socials={socials} />
      <CookieConsent locale={locale} strings={t.cookies} />
      <ChatWidget locale={locale} strings={t.agent} />
      <AnalyticsTracker />
    </div>
  );
}
