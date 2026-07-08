import Link from "next/link";
import type { Locale } from "@/i18n/config";
import { getMenu } from "@/lib/content";
import { LocaleSwitcher } from "@/components/locale-switcher";

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

export async function SiteFooter({ locale }: { locale: Locale }) {
  const t = T[locale as "en" | "nl"] ?? T.en;
  let items: { label: string; href: string }[] = [];
  try { items = await getMenu("main", locale); } catch { items = []; }
  const year = new Date().getFullYear();

  return (
    <footer className="mt-20 border-t border-border bg-card/40">
      <div className="mx-auto grid max-w-6xl gap-10 px-6 py-14 sm:grid-cols-2 lg:grid-cols-[1.6fr_1fr_auto] lg:px-8">
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

        {/* Language */}
        <div>
          <p className="text-xs font-semibold uppercase tracking-[0.2em] text-muted-foreground">{t.lang}</p>
          <div className="mt-4"><LocaleSwitcher locale={locale} /></div>
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
