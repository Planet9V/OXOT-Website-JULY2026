"use client";
import Link from "next/link";
import { motion, useReducedMotion } from "motion/react";
import type { HomeHero as Hero } from "@/lib/site-content";
import { Aurora, Reveal, Stagger, CountUp, Parallax } from "@/components/motion/fx";
import { MediaCarousel } from "@/components/media-carousel";

export function RiskMap({ findingsLabel }: { findingsLabel: string }) {
  const reduce = useReducedMotion();
  const line = (d: string, i: number) => (
    <motion.line key={i} {...parse(d)} stroke="#c9cdd6" strokeWidth="1"
      initial={reduce ? false : { pathLength: 0, opacity: 0 }}
      whileInView={{ pathLength: 1, opacity: 1 }} viewport={{ once: true }}
      transition={{ duration: 0.9, delay: 0.2 + i * 0.08, ease: "easeInOut" }} />
  );
  return (
    <svg viewBox="0 0 420 280" className="ed-svg" role="img" aria-label="Cyber Digital Twin risk map">
      <defs>
        <radialGradient id="g1b" cx="50%" cy="50%" r="50%">
          <stop offset="0%" stopColor="#e8700a" stopOpacity=".9" />
          <stop offset="100%" stopColor="#e8700a" stopOpacity="0" />
        </radialGradient>
      </defs>
      <g>{LINES.map((d, i) => line(d, i))}</g>
      <rect x="118" y="44" width="230" height="180" rx="10" fill="none" stroke="#c9cdd6" strokeDasharray="4 5" />
      <text x="128" y="38" fontFamily="Instrument Sans" fontSize="10" letterSpacing="1.5" fill="#9aa0ac">ZONE · CONTROL</text>
      <text x="60" y="26" fontFamily="Instrument Sans" fontSize="10" letterSpacing="1.5" fill="#9aa0ac">{findingsLabel}</text>
      <g fill="#fff" stroke="#161d2b" strokeWidth="1.5">
        <rect x="40" y="62" width="20" height="16" rx="3" /><rect x="40" y="122" width="20" height="16" rx="3" /><rect x="40" y="182" width="20" height="16" rx="3" />
      </g>
      <g fill="#7d8494"><circle cx="270" cy="70" r="5" /><circle cx="360" cy="110" r="5" /><circle cx="300" cy="150" r="5" /><circle cx="360" cy="200" r="5" /></g>
      <motion.circle cx="180" cy="120" r="34" fill="url(#g1b)"
        animate={reduce ? undefined : { scale: [1, 1.18, 1], opacity: [0.85, 0.55, 0.85] }}
        style={{ transformOrigin: "180px 120px" }}
        transition={{ duration: 2.4, repeat: Infinity, ease: "easeInOut" }} />
      <circle cx="180" cy="120" r="9" fill="#e8700a" />
      <text x="180" y="168" textAnchor="middle" fontFamily="Instrument Sans" fontSize="10" letterSpacing="1.5" fill="#e8700a" fontWeight="600">RISK</text>
    </svg>
  );
}
const LINES = [
  "60,70 180,120", "60,130 180,120", "60,190 180,120",
  "180,120 270,70", "180,120 300,150", "270,70 360,110", "300,150 360,200"
];
function parse(d: string) {
  const [a, b] = d.split(" ");
  const [x1, y1] = a.split(",");
  const [x2, y2] = b.split(",");
  return { x1, y1, x2, y2 };
}

export function HomeHero({ hero, locale }: { hero: Hero; locale: string }) {
  return (
    <section className="relative">
      <Aurora />
      <div className="ed-hero relative">
        <div>
          <Stagger>
            <Stagger.Item><p className="ed-eyebrow">{hero.kicker}</p></Stagger.Item>
            <Stagger.Item><h1 className="ed-h1">{hero.title}</h1></Stagger.Item>
            <Stagger.Item><p className="ed-lede">{hero.subtitle}</p></Stagger.Item>
            <Stagger.Item>
              <div className="ed-actions">
                <Link href={`/${locale}/contact`} className="ed-btn-primary">{hero.cta}</Link>
                <Link href={`/${locale}/cyber-digital-twin`} className="ed-btn-link">{hero.cta2}</Link>
              </div>
            </Stagger.Item>
            <Stagger.Item>
              <div className="ed-trust">
                <span className="ed-trust-label">{hero.trustLabel}</span>
                <div className="ed-trust-list">
                  {hero.industries.map((n, i) => (
                    <span key={n} className="contents"><span>{n}</span>{i < hero.industries.length - 1 && <span>·</span>}</span>
                  ))}
                </div>
              </div>
            </Stagger.Item>
          </Stagger>
        </div>

        <Reveal delay={0.15} y={30}>
          <Parallax distance={16}>
          {hero.heroPdf ? (
            <MediaCarousel
              items={[{ kind: "pdf", src: `/api/media/${hero.heroPdf}` }]}
              ratio="16 / 9"
              className="w-full"
              autoPlayMs={5000}
              locale={locale}
            />
          ) : (
            <div className="ed-card">
              <div className="ed-card-head">
                <span className="ed-card-title">{hero.card.title}</span>
                <span className="ed-card-tag">{hero.card.tag}</span>
              </div>
              <RiskMap findingsLabel={hero.card.findingsLabel} />
              <div className="ed-stats">
                {hero.card.stats.map((s) => (
                  <div className="ed-stat" key={s.l}>
                    <div className={`ed-stat-n${s.accent ? " is-accent" : ""}`}><CountUp value={s.n} /></div>
                    <div className="ed-stat-l">{s.l}</div>
                  </div>
                ))}
              </div>
            </div>
          )}
          </Parallax>
        </Reveal>
      </div>
    </section>
  );
}
