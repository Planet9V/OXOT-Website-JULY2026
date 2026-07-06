import type { Metadata } from "next";
import { notFound } from "next/navigation";
import Link from "next/link";
import { isLocale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { ThemeToggle } from "@/components/theme-toggle";
import { alternates, organizationJsonLd, jsonLdScript } from "@/lib/seo";

export async function generateMetadata({
  params
}: {
  params: Promise<{ locale: string }>;
}): Promise<Metadata> {
  const { locale } = await params;
  if (!isLocale(locale)) return {};
  const t = getDictionary(locale);
  return {
    title: t.home.hero.title,
    description: t.home.hero.subtitle,
    alternates: alternates(locale, "")
  };
}

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

  return (
    <main className="editorial">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: jsonLdScript(organizationJsonLd()) }}
      />
      <div className="ed-toggle">
        <ThemeToggle label={t.theme.toggle} />
      </div>

      {/* ─── HERO (hero_1b) ─────────────────────────────────────────── */}
      <div className="ed-wrap">
        <section className="ed-hero">
          <div>
            <p className="ed-eyebrow">{hero.kicker}</p>
            <h1 className="ed-h1">{hero.title}</h1>
            <p className="ed-lede">{hero.subtitle}</p>
            <div className="ed-actions">
              <Link href={`/${locale}/contact`} className="ed-btn-primary">
                {hero.cta}
              </Link>
              <Link href={`/${locale}/cyber-digital-twin`} className="ed-btn-link">
                {hero.cta2}
              </Link>
            </div>
            <div className="ed-trust">
              <span className="ed-trust-label">{hero.trustLabel}</span>
              <div className="ed-trust-list">
                {hero.industries.map((name, i) => (
                  <span key={name} className="contents">
                    <span>{name}</span>
                    {i < hero.industries.length - 1 && <span>·</span>}
                  </span>
                ))}
              </div>
            </div>
          </div>

          {/* insight card */}
          <div className="ed-card">
            <div className="ed-card-head">
              <span className="ed-card-title">{hero.card.title}</span>
              <span className="ed-card-tag">{hero.card.tag}</span>
            </div>
            <svg viewBox="0 0 420 280" className="ed-svg" role="img" aria-label={hero.card.title}>
              <defs>
                <radialGradient id="g1b" cx="50%" cy="50%" r="50%">
                  <stop offset="0%" stopColor="#e8700a" stopOpacity=".9" />
                  <stop offset="100%" stopColor="#e8700a" stopOpacity="0" />
                </radialGradient>
              </defs>
              <g stroke="#c9cdd6" strokeWidth="1">
                <line x1="60" y1="70" x2="180" y2="120" />
                <line x1="60" y1="130" x2="180" y2="120" />
                <line x1="60" y1="190" x2="180" y2="120" />
                <line x1="180" y1="120" x2="270" y2="70" />
                <line x1="180" y1="120" x2="300" y2="150" />
                <line x1="270" y1="70" x2="360" y2="110" />
                <line x1="300" y1="150" x2="360" y2="200" />
              </g>
              <rect x="118" y="44" width="230" height="180" rx="10" fill="none" stroke="#c9cdd6" strokeDasharray="4 5" />
              <text x="128" y="38" fontFamily="Instrument Sans" fontSize="10" letterSpacing="1.5" fill="#9aa0ac">ZONE · CONTROL</text>
              <text x="60" y="26" fontFamily="Instrument Sans" fontSize="10" letterSpacing="1.5" fill="#9aa0ac">{hero.card.findingsLabel}</text>
              <g fill="#fff" stroke="#161d2b" strokeWidth="1.5">
                <rect x="40" y="62" width="20" height="16" rx="3" />
                <rect x="40" y="122" width="20" height="16" rx="3" />
                <rect x="40" y="182" width="20" height="16" rx="3" />
              </g>
              <g fill="#7d8494">
                <circle cx="270" cy="70" r="5" />
                <circle cx="360" cy="110" r="5" />
                <circle cx="300" cy="150" r="5" />
                <circle cx="360" cy="200" r="5" />
              </g>
              <circle cx="180" cy="120" r="34" fill="url(#g1b)" />
              <circle cx="180" cy="120" r="9" fill="#e8700a" />
              <text x="180" y="168" textAnchor="middle" fontFamily="Instrument Sans" fontSize="10" letterSpacing="1.5" fill="#e8700a" fontWeight="600">RISK</text>
            </svg>
            <div className="ed-stats">
              {hero.card.stats.map((s) => (
                <div className="ed-stat" key={s.l}>
                  <div className={`ed-stat-n${s.accent ? " is-accent" : ""}`}>{s.n}</div>
                  <div className="ed-stat-l">{s.l}</div>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* ─── DIENSTEN (services_2a) ──────────────────────────────── */}
        <section>
          <div className="ed-sec-head">
            <div>
              <p className="ed-eyebrow">{services.eyebrow}</p>
              <h2 className="ed-h2">{services.heading}</h2>
            </div>
            <p className="ed-sec-intro">{services.intro}</p>
          </div>

          <div className="ed-grid">
            {services.items.map((it, i) => (
              <Link key={it.name} href={`/${locale}${it.href}`} className="ed-svc">
                <div className="ed-svc-num">
                  <b>{String(i + 1).padStart(2, "0")}</b>
                  <i />
                </div>
                <h3>{it.name}</h3>
                <p>{it.desc}</p>
                <span className="ed-svc-link">
                  {services.more} <span className="arrow">→</span>
                </span>
              </Link>
            ))}

            {/* 8th slot — CTA panel */}
            <div className="ed-svc-cta">
              <h3>{services.cta.title}</h3>
              <p>{services.cta.body}</p>
              <Link href={`/${locale}/contact`}>{services.cta.button}</Link>
            </div>
          </div>
        </section>
      </div>
    </main>
  );
}
