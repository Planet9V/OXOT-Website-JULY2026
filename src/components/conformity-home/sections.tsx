import Link from "next/link";
import {
  ArrowRight,
  Check,
  X,
  Library,
  FileCheck,
  ScanSearch,
  FileOutput,
  ShieldAlert,
  Users,
  type LucideIcon
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { HeroCarousel } from "@/components/conformity-home/hero-carousel";
import { HeroIntro } from "@/components/conformity-home/hero-intro";
import { getCarouselSlides, staticHeroSlides } from "@/lib/carousel";
import {
  Reveal,
  Stagger,
  StaggerItem,
  CountUp,
  Marquee,
  SpotlightCard
} from "@/components/motion/fx";
import type {
  ConformityHomeHero,
  ConformityHomeLogoWall,
  ConformityHomeStat,
  ConformityHomeFeatureGrid,
  ConformityHomeProblemShift,
  ConformityHomeComparison,
  ConformityHomeSteps,
  ConformityHomeQuote,
  ConformityHomeCta
} from "@/lib/conformity-home";

const EYEBROW = "text-xs font-semibold uppercase tracking-[0.2em] text-primary";
const H2 =
  "mt-3 max-w-2xl text-3xl font-bold leading-[1.1] tracking-tight text-foreground sm:text-4xl";
const DISPLAY = { fontFamily: "var(--font-display)" } as const;

// Map the icon-name strings stored in the DB content to lucide components.
const ICONS: Record<string, LucideIcon> = {
  Library,
  FileCheck,
  ScanSearch,
  FileOutput,
  ShieldAlert,
  Users
};
function iconFor(name: string): LucideIcon {
  return ICONS[name] ?? FileCheck;
}

/** 1 — Hero. Ported animation lives in <HeroIntro>; DB-backed <HeroCarousel> on
 * the right. Slides come from carousel_slides (migration 033); if the table is
 * empty or the DB is down, getCarouselSlides() returns [] and we fall back to the
 * shipped static deck so the front door never breaks. */
export async function Hero({ hero, locale }: { hero: ConformityHomeHero; locale: string }) {
  const dbSlides = await getCarouselSlides(locale);
  const slides = dbSlides.length > 0 ? dbSlides : staticHeroSlides(locale);
  return (
    <section className="relative overflow-hidden border-b border-border">
      {/* Background décor — dark/light-safe radial blobs + masked grid (source port). */}
      <div
        aria-hidden
        className="pointer-events-none absolute -right-24 -top-24 -z-10 h-[42vh] w-[42vh] rounded-full bg-primary/5 blur-3xl"
      />
      <div
        aria-hidden
        className="pointer-events-none absolute -bottom-24 -left-24 -z-10 h-[38vh] w-[38vh] rounded-full bg-primary/5 blur-3xl"
      />
      <div
        aria-hidden
        className="pointer-events-none absolute inset-0 -z-10 bg-[linear-gradient(to_right,#8882_1px,transparent_1px),linear-gradient(to_bottom,#8882_1px,transparent_1px)] bg-[size:4rem_4rem] opacity-20 [mask-image:radial-gradient(ellipse_60%_50%_at_50%_0%,#000_70%,transparent_100%)] dark:opacity-10"
      />
      <div className="relative mx-auto grid max-w-6xl items-center gap-10 px-4 py-20 sm:py-28 lg:grid-cols-2 lg:gap-12">
        <HeroIntro hero={hero} locale={locale} />

        {/* Auto-advancing hero showcase on the right (stacks below on mobile).
            DB-backed slides (carousel_slides) with static fallback; CSS animation
            (not JS Reveal) so it can never get stuck hidden. */}
        <div className="animate-in fade-in fill-mode-both delay-200 duration-700">
          <HeroCarousel locale={locale} slides={slides} />
        </div>
      </div>
    </section>
  );
}

/** 3 — Regulation band (marquee). */
export function RegulationBand({ logoWall }: { logoWall: ConformityHomeLogoWall }) {
  return (
    <section className="border-b border-border py-12">
      <div className="mx-auto max-w-6xl px-4">
        <p className="text-center text-xs font-semibold uppercase tracking-[0.2em] text-muted-foreground">
          {logoWall.title}
        </p>
      </div>
      <div className="mt-8">
        <Marquee duration={34}>
          {logoWall.logos.map((it) => (
            <span
              key={it}
              className="inline-flex items-center gap-2 rounded-full border border-border bg-card px-5 py-2 text-sm font-medium text-foreground"
            >
              <span className="h-1.5 w-1.5 rounded-full bg-primary" aria-hidden />
              {it}
            </span>
          ))}
        </Marquee>
      </div>
    </section>
  );
}

/** 4 — Stats. CountUp only for the pure-number values. */
export function Stats({ stats }: { stats: ConformityHomeStat[] }) {
  const isNumeric = (v: string) => /^[0-9]+%?$/.test(v);
  return (
    <section className="border-b border-border py-16">
      <div className="mx-auto max-w-6xl px-4">
        <Stagger className="grid grid-cols-2 gap-6 lg:grid-cols-4">
          {stats.map((s) => (
            <StaggerItem key={s.label}>
              <div
                className="text-4xl font-bold tracking-tight text-primary sm:text-5xl"
                style={DISPLAY}
              >
                {isNumeric(s.value) ? <CountUp value={s.value} /> : s.value}
              </div>
              <div className="mt-2 text-sm font-medium leading-relaxed text-foreground">
                {s.label}
              </div>
              <div className="mt-1 text-sm leading-relaxed text-muted-foreground">{s.sublabel}</div>
            </StaggerItem>
          ))}
        </Stagger>
      </div>
    </section>
  );
}

/** 5 — The Platform (6-card feature grid, with named icons). */
export function Platform({ featureGrid }: { featureGrid: ConformityHomeFeatureGrid }) {
  return (
    <section className="border-b border-border py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <p className={EYEBROW}>{featureGrid.eyebrow}</p>
          <h2 className={H2} style={DISPLAY}>
            {featureGrid.title}
          </h2>
          <p className="mt-4 max-w-2xl text-base leading-relaxed text-muted-foreground">
            {featureGrid.subtitle}
          </p>
        </Reveal>
        <Stagger className="mt-10 grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
          {featureGrid.features.map((f) => {
            const Icon = iconFor(f.icon);
            return (
              <StaggerItem key={f.title} className="h-full">
                <SpotlightCard className="h-full">
                  <Card className="h-full p-6">
                    <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10 text-primary">
                      <Icon className="h-5 w-5" aria-hidden />
                    </div>
                    <h3 className="mt-4 text-base font-semibold text-foreground">{f.title}</h3>
                    <p className="mt-2 text-sm leading-relaxed text-muted-foreground">
                      {f.description}
                    </p>
                  </Card>
                </SpotlightCard>
              </StaggerItem>
            );
          })}
        </Stagger>
      </div>
    </section>
  );
}

/** 6 — The Problem. */
export function Problem({ problem }: { problem: ConformityHomeProblemShift }) {
  return (
    <section className="border-b border-border py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <p className={EYEBROW}>{problem.eyebrow}</p>
          <h2 className={H2} style={DISPLAY}>
            {problem.title}
          </h2>
          <p className="mt-4 max-w-2xl text-base leading-relaxed text-muted-foreground">
            {problem.body}
          </p>
        </Reveal>
        <Stagger className="mt-8 grid gap-4 sm:grid-cols-3">
          {problem.bullets.map((it) => (
            <StaggerItem key={it}>
              <div className="flex h-full items-start gap-3 rounded-[var(--radius)] border border-border bg-card p-5">
                <X className="mt-0.5 h-4 w-4 shrink-0 text-destructive" aria-hidden />
                <span className="text-sm leading-relaxed text-foreground">{it}</span>
              </div>
            </StaggerItem>
          ))}
        </Stagger>
      </div>
    </section>
  );
}

/** 7 — The Shift. */
export function Shift({
  shift,
  locale
}: {
  shift: ConformityHomeProblemShift;
  locale: string;
}) {
  return (
    <section className="border-b border-border py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <p className={EYEBROW}>{shift.eyebrow}</p>
          <h2 className={H2} style={DISPLAY}>
            {shift.title}
          </h2>
          <p className="mt-4 max-w-2xl text-base leading-relaxed text-muted-foreground">
            {shift.body}
          </p>
        </Reveal>
        <Stagger className="mt-8 grid gap-4 sm:grid-cols-3">
          {shift.bullets.map((it) => (
            <StaggerItem key={it}>
              <div className="flex h-full items-start gap-3 rounded-[var(--radius)] border border-border bg-card p-5">
                <Check className="mt-0.5 h-4 w-4 shrink-0 text-primary" aria-hidden />
                <span className="text-sm leading-relaxed text-foreground">{it}</span>
              </div>
            </StaggerItem>
          ))}
        </Stagger>
        <Reveal>
          <Button asChild className="mt-10">
            <Link href={`/${locale}${shift.cta.href}`}>
              {shift.cta.label}
              <ArrowRight />
            </Link>
          </Button>
        </Reveal>
      </div>
    </section>
  );
}

/** 8 — Comparison table. */
export function Comparison({ comparison }: { comparison: ConformityHomeComparison }) {
  const [leftCol, rightCol] = comparison.columns;
  return (
    <section className="border-b border-border py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <p className={EYEBROW}>{comparison.eyebrow}</p>
          <h2 className={H2} style={DISPLAY}>
            {comparison.title}
          </h2>
          <p className="mt-4 max-w-2xl text-base leading-relaxed text-muted-foreground">
            {comparison.subtitle}
          </p>
        </Reveal>
        <Reveal>
          <div className="mt-8 overflow-x-auto rounded-[var(--radius)] border border-border">
            <table className="w-full border-collapse text-left text-sm">
              <thead>
                <tr className="bg-muted/50">
                  <th className="p-4 font-medium text-foreground" />
                  <th className="p-4 font-medium text-muted-foreground">{leftCol}</th>
                  <th className="p-4 font-medium text-primary">{rightCol}</th>
                </tr>
              </thead>
              <tbody>
                {comparison.rows.map((r) => (
                  <tr key={r.label} className="border-t border-border">
                    <td className="p-4 font-medium text-foreground">{r.label}</td>
                    <td className="p-4 text-muted-foreground">
                      {r.left || (
                        <X className="h-5 w-5 text-destructive/70" aria-label={leftCol} />
                      )}
                    </td>
                    <td className="p-4">
                      {r.right ? (
                        <Check className="h-5 w-5 text-primary" aria-label={rightCol} />
                      ) : (
                        <X className="h-5 w-5 text-destructive/70" aria-label={rightCol} />
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </Reveal>
      </div>
    </section>
  );
}

/** 9 — How it works (4 steps). */
export function HowItWorks({ steps }: { steps: ConformityHomeSteps }) {
  return (
    <section className="border-b border-border py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <p className={EYEBROW}>{steps.eyebrow}</p>
          <h2 className={H2} style={DISPLAY}>
            {steps.title}
          </h2>
        </Reveal>
        <Stagger className="mt-10 grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
          {steps.steps.map((s) => (
            <StaggerItem key={s.number}>
              <div className="h-full rounded-[var(--radius)] border border-border bg-card p-6">
                <div className="text-3xl font-bold tracking-tight text-primary" style={DISPLAY}>
                  {s.number}
                </div>
                <h3 className="mt-3 text-base font-semibold text-foreground">{s.title}</h3>
                <p className="mt-2 text-sm leading-relaxed text-muted-foreground">{s.description}</p>
              </div>
            </StaggerItem>
          ))}
        </Stagger>
      </div>
    </section>
  );
}

/** 10 — Testimonial. */
export function Testimonial({ quote }: { quote: ConformityHomeQuote }) {
  return (
    <section className="border-b border-border py-20">
      <div className="mx-auto max-w-4xl px-4">
        <Reveal>
          <figure>
            <blockquote
              className="text-2xl font-medium leading-snug tracking-tight text-foreground sm:text-3xl"
              style={DISPLAY}
            >
              &ldquo;{quote.quote}&rdquo;
            </blockquote>
            <figcaption className="mt-6 text-sm text-muted-foreground">
              <span className="font-semibold text-foreground">{quote.author}</span>
              {" — "}
              {quote.role}
            </figcaption>
          </figure>
        </Reveal>
      </div>
    </section>
  );
}

/** 12 — Final CTA. */
export function FinalCta({ cta, locale }: { cta: ConformityHomeCta; locale: string }) {
  return (
    <section className="py-24">
      <div className="mx-auto max-w-4xl px-4 text-center">
        <Reveal>
          <h2
            className="text-3xl font-bold leading-[1.1] tracking-tight text-foreground sm:text-4xl"
            style={DISPLAY}
          >
            {cta.title}
          </h2>
          <p className="mx-auto mt-4 max-w-2xl text-base leading-relaxed text-muted-foreground">
            {cta.subtitle}
          </p>
          <div className="mt-8 flex flex-wrap justify-center gap-3">
            <Button asChild size="lg">
              <Link href={`/${locale}${cta.primaryCta.href}`}>
                {cta.primaryCta.label}
                <ArrowRight />
              </Link>
            </Button>
            <Button asChild size="lg" variant="outline">
              <Link href={`/${locale}${cta.secondaryCta.href}`}>{cta.secondaryCta.label}</Link>
            </Button>
          </div>
        </Reveal>
      </div>
    </section>
  );
}
