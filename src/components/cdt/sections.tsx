import Link from "next/link";
import {
  Reveal,
  Stagger,
  StaggerItem,
  CountUp,
  SpotlightCard
} from "@/components/motion/fx";
import { Button } from "@/components/ui/button";
import { ArrowRight } from "lucide-react";
import { AskAssistantButton } from "@/components/cra-home/ask-assistant-button";
import { SevenLayerGraph } from "@/components/cdt/seven-layer-graph";
import { BomDrilldownTable } from "@/components/cdt/bom-drilldown-table";
import { PriorityMatrix } from "@/components/cdt/priority-matrix";
import { MonteCarloViz } from "@/components/cdt/monte-carlo-viz";
import type {
  CdtHero,
  CdtStatBand,
  CdtLivingModel,
  CdtBoms,
  CdtDrilldown,
  CdtConsequence,
  CdtPriority,
  CdtMonteCarlo,
  CdtMethodology,
  CdtOutcomes,
  CdtFinalCta
} from "@/lib/cdt";
import type { Locale } from "@/i18n/config";

const EYEBROW = "text-xs font-semibold uppercase tracking-[0.2em] text-primary";
const H2 =
  "mt-3 max-w-2xl text-3xl font-bold leading-[1.1] tracking-tight text-foreground sm:text-4xl";
const DISPLAY = { fontFamily: "var(--font-display)" } as const;

/** Primary CTA — a link to the contact page, styled as the brand button. */
function ContactCta({ locale, label }: { locale: Locale; label: string }) {
  return (
    <Button asChild size="lg">
      <Link href={`/${locale}/contact`}>
        {label}
        <ArrowRight />
      </Link>
    </Button>
  );
}

/** 1 — Hero: the CDT thesis on the left, the interactive seven-layer graph right. */
export function Hero({
  hero,
  model,
  locale,
  assistLabel,
  seedTemplate
}: {
  hero: CdtHero;
  model: CdtLivingModel;
  locale: Locale;
  assistLabel: string;
  seedTemplate: string;
}) {
  return (
    <section className="relative overflow-hidden border-b border-border">
      <div
        aria-hidden
        className="pointer-events-none absolute -right-24 -top-24 -z-10 h-[42vh] w-[42vh] rounded-full bg-primary/10 blur-3xl"
      />
      <div
        aria-hidden
        className="pointer-events-none absolute inset-0 -z-10 bg-[linear-gradient(to_right,#8882_1px,transparent_1px),linear-gradient(to_bottom,#8882_1px,transparent_1px)] bg-[size:4rem_4rem] opacity-20 [mask-image:radial-gradient(ellipse_60%_50%_at_50%_0%,#000_70%,transparent_100%)] dark:opacity-10"
      />
      <div className="relative mx-auto grid max-w-6xl items-center gap-10 px-4 py-16 sm:py-24 lg:grid-cols-2 lg:gap-12">
        <Reveal>
          <p className={EYEBROW}>{hero.eyebrow}</p>
          <h1
            className="mt-3 text-3xl font-bold leading-[1.08] tracking-tight text-foreground sm:text-5xl"
            style={DISPLAY}
          >
            {hero.title} <span className="text-primary">{hero.titleAccent}</span>
          </h1>
          <p className="mt-5 max-w-xl text-base leading-relaxed text-muted-foreground">{hero.subtitle}</p>
          <ul className="mt-6 flex flex-wrap gap-x-5 gap-y-2 text-xs text-foreground">
            {hero.badges.map((b) => (
              <li key={b} className="border-l-2 border-primary pl-2">
                {b}
              </li>
            ))}
          </ul>
          <div className="mt-7 flex flex-wrap items-center gap-3">
            <ContactCta locale={locale} label={hero.ctaLabel} />
            <AskAssistantButton label={assistLabel} seedTemplate={seedTemplate} />
          </div>
        </Reveal>
        <Reveal delay={0.1}>
          <div className="rounded-[calc(var(--radius)+4px)] border border-border bg-card/60 p-4 shadow-e1 sm:p-6">
            <SevenLayerGraph model={model} />
          </div>
        </Reveal>
      </div>
    </section>
  );
}

/** 2 — Headline stat band. */
export function StatBand({ band }: { band: CdtStatBand }) {
  return (
    <section className="border-b border-border bg-muted/30 py-10 sm:py-12">
      <div className="mx-auto max-w-6xl px-4">
        <Stagger className="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
          {band.items.map((s) => (
            <StaggerItem key={s.label}>
              <div className="border-l-2 border-primary pl-4">
                <div className="text-2xl font-bold text-foreground sm:text-3xl" style={DISPLAY}>
                  <CountUp value={s.value} />
                </div>
                <p className="mt-1 text-sm font-semibold text-foreground">{s.label}</p>
                {s.sub ? <p className="mt-0.5 text-xs leading-snug text-muted-foreground">{s.sub}</p> : null}
              </div>
            </StaggerItem>
          ))}
        </Stagger>
      </div>
    </section>
  );
}

/** 3 — The living model: the "one structured view" narrative + graph points. */
export function LivingModel({ model }: { model: CdtLivingModel }) {
  return (
    <section className="border-b border-border py-16 sm:py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <p className={EYEBROW}>{model.eyebrow}</p>
          <h2 className={H2} style={DISPLAY}>
            {model.title}
          </h2>
          <p className="mt-4 max-w-3xl text-base leading-relaxed text-muted-foreground">{model.body}</p>
        </Reveal>
        <Stagger className="mt-8 grid gap-4 sm:grid-cols-2">
          {model.points.map((p) => (
            <StaggerItem key={p} className="h-full">
              <div className="flex h-full items-start gap-3 rounded-[var(--radius)] border border-border bg-card p-4">
                <span className="mt-1 h-2 w-2 shrink-0 rounded-full bg-primary" aria-hidden />
                <p className="text-sm leading-relaxed text-muted-foreground">{p}</p>
              </div>
            </StaggerItem>
          ))}
        </Stagger>
      </div>
    </section>
  );
}

/** 4 — BOMs: the five standardised, DEXPI-extended bills of materials. */
export function Boms({ boms }: { boms: CdtBoms }) {
  return (
    <section className="border-b border-border bg-muted/30 py-16 sm:py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <p className={EYEBROW}>{boms.eyebrow}</p>
          <h2 className={H2} style={DISPLAY}>
            {boms.title}
          </h2>
          <p className="mt-4 max-w-3xl text-base leading-relaxed text-muted-foreground">{boms.intro}</p>
        </Reveal>
        <Stagger className="mt-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {boms.boms.map((b) => (
            <StaggerItem key={b.code} className="h-full">
              <SpotlightCard className="h-full rounded-[calc(var(--radius)+2px)] border border-border bg-card p-5">
                <div className="flex items-center gap-2">
                  <span className="rounded bg-primary/10 px-2 py-1 text-[11px] font-bold text-primary">{b.code}</span>
                  <span className="text-sm font-semibold text-foreground" style={DISPLAY}>
                    {b.name}
                  </span>
                </div>
                <p className="mt-3 text-sm leading-relaxed text-muted-foreground">{b.desc}</p>
                <p className="mt-3 text-[11px] leading-snug text-foreground/70">
                  <span className="font-semibold uppercase tracking-wide text-muted-foreground">Carries · </span>
                  {b.carries}
                </p>
              </SpotlightCard>
            </StaggerItem>
          ))}
        </Stagger>
        <div className="mt-6 grid gap-4 sm:grid-cols-2">
          <Reveal>
            <p className="rounded-[var(--radius)] border border-primary/20 bg-primary/5 p-4 text-xs leading-relaxed text-foreground">
              {boms.standardNote}
            </p>
          </Reveal>
          <Reveal delay={0.1}>
            <p className="rounded-[var(--radius)] border border-border bg-card p-4 text-xs leading-relaxed text-muted-foreground">
              {boms.dependencyNote}
            </p>
          </Reveal>
        </div>
      </div>
    </section>
  );
}

/** 5 — Drill-down BOM table: the interactive component→org tree. */
export function Drilldown({ drilldown }: { drilldown: CdtDrilldown }) {
  return (
    <section className="border-b border-border py-16 sm:py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <h2 className={H2} style={DISPLAY}>
            {drilldown.title}
          </h2>
          <p className="mt-4 max-w-3xl text-base leading-relaxed text-muted-foreground">{drilldown.intro}</p>
        </Reveal>
        <Reveal delay={0.05}>
          <div className="mt-8">
            <BomDrilldownTable data={drilldown} />
          </div>
        </Reveal>
        <Stagger className="mt-6 grid gap-2 sm:grid-cols-2">
          {drilldown.legend.map((l) => (
            <StaggerItem key={l.key}>
              <p className="text-[11px] leading-snug text-muted-foreground">
                <span className="font-semibold uppercase tracking-wide text-foreground">{l.key}</span> — {l.label}
              </p>
            </StaggerItem>
          ))}
        </Stagger>
      </div>
    </section>
  );
}

/** 6 — Consequence-driven safety & reliability: FMECA / RCIL / SCIL. */
export function Consequence({ consequence }: { consequence: CdtConsequence }) {
  return (
    <section className="border-b border-border bg-muted/30 py-16 sm:py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <p className={EYEBROW}>{consequence.eyebrow}</p>
          <h2 className={H2} style={DISPLAY}>
            {consequence.title}
          </h2>
          <p className="mt-4 max-w-3xl text-base leading-relaxed text-muted-foreground">{consequence.intro}</p>
        </Reveal>
        <Stagger className="mt-8 grid gap-5 lg:grid-cols-3">
          {consequence.methods.map((m) => (
            <StaggerItem key={m.code} className="h-full">
              <div className="h-full rounded-[calc(var(--radius)+2px)] border-t-4 border-primary bg-card p-5">
                <p className="text-sm font-bold uppercase tracking-wide text-primary">{m.code}</p>
                <h3 className="mt-1 text-base font-semibold text-foreground" style={DISPLAY}>
                  {m.name}
                </h3>
                <p className="mt-2 text-sm leading-relaxed text-muted-foreground">{m.body}</p>
              </div>
            </StaggerItem>
          ))}
        </Stagger>
        <Reveal>
          <p className="mt-6 rounded-[var(--radius)] border border-primary/20 bg-primary/5 p-4 text-sm leading-relaxed text-foreground">
            {consequence.note}
          </p>
        </Reveal>
      </div>
    </section>
  );
}

/** 7 — NOW / NEXT / NEVER prioritization matrix. */
export function Priority({ priority }: { priority: CdtPriority }) {
  return (
    <section className="border-b border-border py-16 sm:py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <p className={EYEBROW}>{priority.eyebrow}</p>
          <h2 className={H2} style={DISPLAY}>
            {priority.title}
          </h2>
          <p className="mt-4 max-w-3xl text-base leading-relaxed text-muted-foreground">{priority.intro}</p>
        </Reveal>
        <Reveal delay={0.05}>
          <div className="mt-8">
            <PriorityMatrix priority={priority} />
          </div>
        </Reveal>
      </div>
    </section>
  );
}

/** 8 — Monte Carlo prediction pipeline. */
export function MonteCarlo({ monteCarlo }: { monteCarlo: CdtMonteCarlo }) {
  return (
    <section className="border-b border-border bg-muted/30 py-16 sm:py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <p className={EYEBROW}>{monteCarlo.eyebrow}</p>
          <h2 className={H2} style={DISPLAY}>
            {monteCarlo.title}
          </h2>
          <p className="mt-4 max-w-3xl text-base leading-relaxed text-muted-foreground">{monteCarlo.intro}</p>
        </Reveal>
        <Reveal delay={0.05}>
          <div className="mt-8">
            <MonteCarloViz data={monteCarlo} />
          </div>
        </Reveal>
      </div>
    </section>
  );
}

/** 9 — Methodology: Assess → Model → Improve → Sustain. */
export function Methodology({ methodology }: { methodology: CdtMethodology }) {
  return (
    <section className="border-b border-border py-16 sm:py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <p className={EYEBROW}>{methodology.eyebrow}</p>
          <h2 className={H2} style={DISPLAY}>
            {methodology.title}
          </h2>
          <p className="mt-4 max-w-2xl text-base leading-relaxed text-muted-foreground">{methodology.intro}</p>
        </Reveal>
        <Stagger className="mt-8 grid gap-5 sm:grid-cols-2 lg:grid-cols-4">
          {methodology.steps.map((s) => (
            <StaggerItem key={s.number} className="h-full">
              <SpotlightCard className="h-full rounded-[var(--radius)] border border-border bg-card p-5">
                <span className="text-2xl font-bold text-primary/40" style={DISPLAY}>
                  {s.number}
                </span>
                <h3 className="mt-1 text-base font-semibold text-foreground" style={DISPLAY}>
                  {s.title}
                </h3>
                <p className="mt-2 text-sm leading-relaxed text-muted-foreground">{s.body}</p>
              </SpotlightCard>
            </StaggerItem>
          ))}
        </Stagger>
      </div>
    </section>
  );
}

/** 10 — Outcomes: what the one model unlocks (CRA headline card links to /cra). */
export function Outcomes({ outcomes, locale }: { outcomes: CdtOutcomes; locale: Locale }) {
  return (
    <section className="border-b border-border bg-muted/30 py-16 sm:py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <p className={EYEBROW}>{outcomes.eyebrow}</p>
          <h2 className={H2} style={DISPLAY}>
            {outcomes.title}
          </h2>
          <p className="mt-4 max-w-2xl text-base leading-relaxed text-muted-foreground">{outcomes.intro}</p>
        </Reveal>
        <Stagger className="mt-8 grid gap-5 sm:grid-cols-2">
          {outcomes.cards.map((c, i) => {
            const inner = (
              <SpotlightCard
                className={`h-full rounded-[calc(var(--radius)+2px)] border p-6 ${
                  i === 0 ? "border-primary/40 bg-primary/5" : "border-border bg-card"
                }`}
              >
                <h3 className="text-base font-semibold text-foreground" style={DISPLAY}>
                  {c.title}
                </h3>
                <p className="mt-2 text-sm leading-relaxed text-muted-foreground">{c.body}</p>
                {c.href ? (
                  <span className="mt-3 inline-flex items-center gap-1 text-sm font-semibold text-primary">
                    <ArrowRight className="h-4 w-4" aria-hidden />
                  </span>
                ) : null}
              </SpotlightCard>
            );
            return (
              <StaggerItem key={c.title} className="h-full">
                {c.href ? (
                  <Link href={`/${locale}${c.href}`} className="block h-full">
                    {inner}
                  </Link>
                ) : (
                  inner
                )}
              </StaggerItem>
            );
          })}
        </Stagger>
      </div>
    </section>
  );
}

/** 11 — Final CTA. */
export function FinalCta({ cta, locale }: { cta: CdtFinalCta; locale: Locale }) {
  return (
    <section className="py-20 sm:py-24">
      <div className="mx-auto max-w-4xl px-4 text-center">
        <Reveal>
          <h2
            className="text-3xl font-bold leading-[1.1] tracking-tight text-foreground sm:text-4xl"
            style={DISPLAY}
          >
            {cta.title}
          </h2>
          <p className="mx-auto mt-4 max-w-2xl text-base leading-relaxed text-muted-foreground">{cta.line}</p>
          <div className="mt-8 flex justify-center">
            <ContactCta locale={locale} label={cta.ctaLabel} />
          </div>
        </Reveal>
      </div>
    </section>
  );
}
