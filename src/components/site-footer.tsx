import Link from "next/link";
import type { Locale } from "@/i18n/config";
import { getMenu } from "@/lib/content";
import { getDictionary } from "@/i18n/dictionaries";
import { LocaleSwitcher } from "@/components/locale-switcher";
import { NewsletterSignup } from "@/components/newsletter-signup";
import { CookieSettingsButton } from "@/components/cookie-consent";
import type { SocialLink } from "@/lib/socials";

// Contact address, shared with the legal pages.
const CONTACT_EMAIL = "hello@oxot.eu";

// Bilingual brand strings (CLAUDE.md: no user-facing string ships in one language).
const T = {
  en: {
    tagline: "Operational Excellence in Operational Technology",
    blurb: "OT cybersecurity consultancy — turning IEC 62443, NIS2, the Cyber Resilience Act, the AI Act and the Machinery Regulation into defensible security for industrial systems.",
    nav: "Navigation",
    lang: "Language",
    rights: "All rights reserved."
  },
  nl: {
    tagline: "Operationele excellentie in operationele technologie",
    blurb: "OT-cyberbeveiligingsadviesbureau — IEC 62443, NIS2, de Cyber Resilience Act, de AI-verordening en de Machineverordening vertaald naar verdedigbare beveiliging voor industriële systemen.",
    nav: "Navigatie",
    lang: "Taal",
    rights: "Alle rechten voorbehouden."
  }
} as const;

export async function SiteFooter({ locale, socials }: { locale: Locale; socials: readonly SocialLink[] }) {
  const t = T[locale as "en" | "nl"] ?? T.en;
  const f = getDictionary(locale).footer;
  let items: { label: string; href: string }[] = [];
  try { items = await getMenu("main", locale); } catch { items = []; }
  const year = new Date().getFullYear();

  return (
    <footer className="mt-20 border-t border-border bg-card/40">
      <div className="mx-auto grid max-w-6xl gap-10 px-6 py-14 sm:grid-cols-2 lg:grid-cols-[1.6fr_1fr_1fr_auto] lg:px-8">
        {/* Brand + tagline */}
        <div>
          <Link href={`/${locale}`} aria-label="OXOT — home"
            className="select-none text-lg font-semibold tracking-[0.3em] text-foreground no-underline">
            O<span className="text-primary">X</span>OT
          </Link>
          <p className="mt-3 text-sm font-medium text-foreground/90" style={{ fontFamily: "var(--font-display)" }}>
            {t.tagline}
          </p>
          <p className="mt-3 max-w-md text-sm leading-relaxed text-muted-foreground">{t.blurb}</p>
          <a href={`mailto:${CONTACT_EMAIL}`}
            className="mt-3 inline-block text-sm text-foreground/70 no-underline transition-colors duration-150 ease-brand hover:text-primary">
            {CONTACT_EMAIL}
          </a>

          {/* Newsletter */}
          <div className="mt-8">
            <NewsletterSignup locale={locale} strings={f.newsletter} />
          </div>
        </div>

        {/* Navigation */}
        <nav aria-label={t.nav}>
          <p className="text-xs font-semibold uppercase tracking-[0.2em] text-muted-foreground">{t.nav}</p>
          <ul className="mt-4 space-y-2">
            {items.map((it, i) => (
              <li key={i}>
                <Link href={it.href}
                  className="text-sm text-foreground/70 no-underline transition-colors duration-150 ease-brand hover:text-primary">
                  {it.label}
                </Link>
              </li>
            ))}
          </ul>
        </nav>

        {/* Connect */}
        {socials.length > 0 && (
          <nav aria-label={f.connect}>
            <p className="text-xs font-semibold uppercase tracking-[0.2em] text-muted-foreground">{f.connect}</p>
            <ul className="mt-4 space-y-2">
              {socials.map((s) => (
                <li key={s.label}>
                  <a href={s.url} target="_blank" rel="noopener noreferrer"
                    className="text-sm text-foreground/70 no-underline transition-colors duration-150 ease-brand hover:text-primary">
                    {s.label}
                  </a>
                </li>
              ))}
            </ul>
          </nav>
        )}

        {/* Language */}
        <div>
          <p className="text-xs font-semibold uppercase tracking-[0.2em] text-muted-foreground">{t.lang}</p>
          <div className="mt-4"><LocaleSwitcher locale={locale} /></div>
        </div>
      </div>

      {/* Disclaimer + legal links */}
      <div className="border-t border-border">
        <div className="mx-auto flex max-w-6xl flex-col items-start justify-between gap-3 px-6 py-5 text-xs text-muted-foreground md:flex-row md:items-center lg:px-8">
          <p className="max-w-2xl leading-relaxed">{f.disclaimer}</p>
          <div className="flex shrink-0 items-center gap-3">
            <Link href={`/${locale}/privacy`}
              className="text-muted-foreground no-underline transition-colors duration-150 ease-brand hover:text-primary">
              {f.privacy}
            </Link>
            <span aria-hidden>·</span>
            <Link href={`/${locale}/terms`}
              className="text-muted-foreground no-underline transition-colors duration-150 ease-brand hover:text-primary">
              {f.terms}
            </Link>
            <span aria-hidden>·</span>
            <CookieSettingsButton label={f.cookieSettings} />
          </div>
        </div>
      </div>

      <div className="border-t border-border">
        <div className="mx-auto flex max-w-6xl flex-col items-start justify-between gap-2 px-6 py-5 text-xs text-muted-foreground sm:flex-row sm:items-center lg:px-8">
          <span>© {year} OXOT. {t.rights}</span>
          <span className="tracking-wide">O<span className="text-primary">X</span>OT — {t.tagline}</span>
        </div>
      </div>
    </footer>
  );
}
