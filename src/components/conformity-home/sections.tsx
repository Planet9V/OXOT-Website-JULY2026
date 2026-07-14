import Link from "next/link";
import { ArrowRight, Check, X } from "lucide-react";
import type { Dictionary } from "@/i18n/dictionaries";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import {
  Aurora,
  Reveal,
  Stagger,
  StaggerItem,
  CountUp,
  Marquee,
  SpotlightCard
} from "@/components/motion/fx";

// The `conformityHome` slice of the dictionary drives every string on this page.
type CH = Dictionary["conformityHome"];

const EYEBROW = "text-xs font-semibold uppercase tracking-[0.2em] text-primary";
const H2 =
  "mt-3 max-w-2xl text-3xl font-bold leading-[1.1] tracking-tight text-foreground sm:text-4xl";
const DISPLAY = { fontFamily: "var(--font-display)" } as const;

/** 1 — Hero. */
export function Hero({ t, locale }: { t: CH["hero"]; locale: string }) {
  return (
    <section className="relative overflow-hidden border-b border-border">
      <Aurora />
      <div className="relative mx-auto max-w-6xl px-4 py-20 sm:py-28">
        <Reveal>
          <p className={EYEBROW}>{t.kicker}</p>
          <h1
            className="mt-4 max-w-3xl text-4xl font-bold leading-[1.05] tracking-tight text-foreground sm:text-6xl"
            style={DISPLAY}
          >
            {t.title}
          </h1>
          <p className="mt-6 max-w-2xl text-base leading-relaxed text-muted-foreground sm:text-lg">
            {t.subtitle}
          </p>
          <div className="mt-8 flex flex-wrap gap-3">
            <Button asChild size="lg">
              <Link href={`/${locale}/conformity-platform`}>
                {t.ctaPrimary}
                <ArrowRight />
              </Link>
            </Button>
            <Button asChild size="lg" variant="outline">
              <Link href={`/${locale}/industrial-operations`}>{t.ctaSecondary}</Link>
            </Button>
          </div>
          <ul className="mt-8 flex flex-wrap gap-x-6 gap-y-2">
            {t.bullets.map((b) => (
              <li key={b} className="flex items-center gap-2 text-sm text-muted-foreground">
                <Check className="h-4 w-4 shrink-0 text-primary" aria-hidden />
                {b}
              </li>
            ))}
          </ul>
        </Reveal>
      </div>
    </section>
  );
}

/** 3 — Regulation band (marquee). */
export function RegulationBand({ t }: { t: CH["regBand"] }) {
  return (
    <section className="border-b border-border py-12">
      <div className="mx-auto max-w-6xl px-4">
        <p className="text-center text-xs font-semibold uppercase tracking-[0.2em] text-muted-foreground">
          {t.label}
        </p>
      </div>
      <div className="mt-8">
        <Marquee duration={34}>
          {t.items.map((it) => (
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
export function Stats({ t }: { t: CH["stats"] }) {
  const isNumeric = (v: string) => /^[0-9]+%?$/.test(v);
  return (
    <section className="border-b border-border py-16">
      <div className="mx-auto max-w-6xl px-4">
        <Stagger className="grid grid-cols-2 gap-6 lg:grid-cols-4">
          {t.items.map((s) => (
            <StaggerItem key={s.label}>
              <div
                className="text-4xl font-bold tracking-tight text-primary sm:text-5xl"
                style={DISPLAY}
              >
                {isNumeric(s.value) ? <CountUp value={s.value} /> : s.value}
              </div>
              <div className="mt-2 text-sm leading-relaxed text-muted-foreground">{s.label}</div>
            </StaggerItem>
          ))}
        </Stagger>
      </div>
    </section>
  );
}

/** 5 — The Platform (6-card grid). */
export function Platform({ t, locale }: { t: CH["platform"]; locale: string }) {
  return (
    <section className="border-b border-border py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <p className={EYEBROW}>{t.eyebrow}</p>
          <h2 className={H2} style={DISPLAY}>
            {t.heading}
          </h2>
          <p className="mt-4 max-w-2xl text-base leading-relaxed text-muted-foreground">
            {t.intro}
          </p>
        </Reveal>
        <Stagger className="mt-10 grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
          {t.cards.map((c) => (
            <StaggerItem key={c.title} className="h-full">
              <SpotlightCard className="h-full">
                <Card className="h-full p-6">
                  <h3 className="text-base font-semibold text-foreground">{c.title}</h3>
                  <p className="mt-2 text-sm leading-relaxed text-muted-foreground">{c.body}</p>
                </Card>
              </SpotlightCard>
            </StaggerItem>
          ))}
        </Stagger>
        <Reveal>
          <Button asChild className="mt-10">
            <Link href={`/${locale}/conformity-platform`}>
              {t.cta}
              <ArrowRight />
            </Link>
          </Button>
        </Reveal>
      </div>
    </section>
  );
}

/** 6 — The Problem. */
export function Problem({ t }: { t: CH["problem"] }) {
  return (
    <section className="border-b border-border py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <p className={EYEBROW}>{t.eyebrow}</p>
          <h2 className={H2} style={DISPLAY}>
            {t.heading}
          </h2>
          <p className="mt-4 max-w-2xl text-base leading-relaxed text-muted-foreground">
            {t.body}
          </p>
        </Reveal>
        <Stagger className="mt-8 grid gap-4 sm:grid-cols-3">
          {t.items.map((it) => (
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
export function Shift({ t, locale }: { t: CH["shift"]; locale: string }) {
  return (
    <section className="border-b border-border py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <p className={EYEBROW}>{t.eyebrow}</p>
          <h2 className={H2} style={DISPLAY}>
            {t.heading}
          </h2>
          <p className="mt-4 max-w-2xl text-base leading-relaxed text-muted-foreground">
            {t.body}
          </p>
        </Reveal>
        <Stagger className="mt-8 grid gap-4 sm:grid-cols-3">
          {t.items.map((it) => (
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
            <Link href={`/${locale}/conformity-platform`}>
              {t.cta}
              <ArrowRight />
            </Link>
          </Button>
        </Reveal>
      </div>
    </section>
  );
}

/** 8 — Comparison table. */
export function Comparison({ t }: { t: CH["comparison"] }) {
  return (
    <section className="border-b border-border py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <p className={EYEBROW}>{t.eyebrow}</p>
          <h2 className={H2} style={DISPLAY}>
            {t.heading}
          </h2>
        </Reveal>
        <Reveal>
          <div className="mt-8 overflow-x-auto rounded-[var(--radius)] border border-border">
            <table className="w-full border-collapse text-left text-sm">
              <thead>
                <tr className="bg-muted/50">
                  <th className="p-4 font-medium text-foreground">{t.columns.feature}</th>
                  <th className="p-4 font-medium text-muted-foreground">{t.columns.silos}</th>
                  <th className="p-4 font-medium text-primary">{t.columns.oxot}</th>
                </tr>
              </thead>
              <tbody>
                {t.rows.map((r) => (
                  <tr key={r.feature} className="border-t border-border">
                    <td className="p-4 font-medium text-foreground">{r.feature}</td>
                    <td className="p-4 text-muted-foreground">{r.silos}</td>
                    <td className="p-4">
                      <Check className="h-5 w-5 text-primary" aria-label={t.columns.oxot} />
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

/** 9 — How it works. */
export function HowItWorks({ t }: { t: CH["howItWorks"] }) {
  return (
    <section className="border-b border-border py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <p className={EYEBROW}>{t.eyebrow}</p>
          <h2 className={H2} style={DISPLAY}>
            {t.heading}
          </h2>
        </Reveal>
        <Stagger className="mt-10 grid gap-6 sm:grid-cols-3">
          {t.steps.map((s) => (
            <StaggerItem key={s.k}>
              <div className="h-full rounded-[var(--radius)] border border-border bg-card p-6">
                <div className="text-3xl font-bold tracking-tight text-primary" style={DISPLAY}>
                  {s.k}
                </div>
                <h3 className="mt-3 text-base font-semibold text-foreground">{s.title}</h3>
                <p className="mt-2 text-sm leading-relaxed text-muted-foreground">{s.body}</p>
              </div>
            </StaggerItem>
          ))}
        </Stagger>
      </div>
    </section>
  );
}

/** 10 — Testimonial. */
export function Testimonial({ t }: { t: CH["testimonial"] }) {
  return (
    <section className="border-b border-border py-20">
      <div className="mx-auto max-w-4xl px-4">
        <Reveal>
          <figure>
            <blockquote
              className="text-2xl font-medium leading-snug tracking-tight text-foreground sm:text-3xl"
              style={DISPLAY}
            >
              &ldquo;{t.quote}&rdquo;
            </blockquote>
            <figcaption className="mt-6 text-sm text-muted-foreground">
              <span className="font-semibold text-foreground">{t.author}</span>
              {" — "}
              {t.company}
            </figcaption>
          </figure>
        </Reveal>
      </div>
    </section>
  );
}

/** 12 — Final CTA. */
export function FinalCta({ t, locale }: { t: CH["cta"]; locale: string }) {
  return (
    <section className="py-24">
      <div className="mx-auto max-w-4xl px-4 text-center">
        <Reveal>
          <h2
            className="text-3xl font-bold leading-[1.1] tracking-tight text-foreground sm:text-4xl"
            style={DISPLAY}
          >
            {t.heading}
          </h2>
          <div className="mt-8 flex flex-wrap justify-center gap-3">
            <Button asChild size="lg">
              <Link href={`/${locale}/conformity-platform`}>
                {t.ctaPrimary}
                <ArrowRight />
              </Link>
            </Button>
            <Button asChild size="lg" variant="outline">
              <Link href={`/${locale}/contact`}>{t.ctaSecondary}</Link>
            </Button>
          </div>
        </Reveal>
      </div>
    </section>
  );
}
