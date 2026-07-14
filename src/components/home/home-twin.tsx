"use client";
import Link from "next/link";
import { Reveal, Parallax, CountUp } from "@/components/motion/fx";
import { RiskMap } from "@/components/home/home-hero";
import type { HomeHero } from "@/lib/site-content";

export interface TwinContent {
  eyebrow: string;
  heading: string;
  body: string;
  points: string[];
  cta: string;
}

export function HomeTwin({
  content,
  card,
  locale
}: {
  content: TwinContent;
  card: HomeHero["card"];
  locale: string;
}) {
  return (
    <section className="ed-twin">
      <div className="ed-twin-grid">
        <Reveal>
          <div className="ed-twin-copy">
            <p className="ed-eyebrow">{content.eyebrow}</p>
            <h2 className="ed-h2">{content.heading}</h2>
            <p className="ed-twin-body">{content.body}</p>
            <ul className="ed-twin-points">
              {content.points.map((p) => (
                <li key={p}>
                  <span className="ed-twin-dot" aria-hidden />
                  <span>{p}</span>
                </li>
              ))}
            </ul>
            <Link href={`/${locale}/cyber-digital-twin`} className="ed-btn-link">
              {content.cta}
            </Link>
          </div>
        </Reveal>

        <Reveal delay={0.15} y={30}>
          <Parallax distance={16}>
            <div className="ed-card">
              <div className="ed-card-head">
                <span className="ed-card-title">{card.title}</span>
                <span className="ed-card-tag">{card.tag}</span>
              </div>
              <RiskMap findingsLabel={card.findingsLabel} />
              <div className="ed-stats">
                {card.stats.map((s) => (
                  <div className="ed-stat" key={s.l}>
                    <div className={`ed-stat-n${s.accent ? " is-accent" : ""}`}>
                      <CountUp value={s.n} />
                    </div>
                    <div className="ed-stat-l">{s.l}</div>
                  </div>
                ))}
              </div>
            </div>
          </Parallax>
        </Reveal>
      </div>
    </section>
  );
}
