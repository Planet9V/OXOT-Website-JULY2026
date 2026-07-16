import {
  Reveal,
  Stagger,
  StaggerItem,
  CountUp,
  SpotlightCard
} from "@/components/motion/fx";
import { IntakeForm, type IntakeFormStrings, type IntakeSuccessStrings } from "@/components/cra-home/intake-form";
import { DepartureBoard as DepartureBoardChart } from "@/components/cra-home/departure-board";
import { RoadsSplit as RoadsSplitInteractive } from "@/components/cra-home/roads-split";
import { PersonaCard } from "@/components/cra-home/persona-card";
import { AskAssistantButton } from "@/components/cra-home/ask-assistant-button";
import { BookIntakeButton } from "@/components/cra-home/book-intake-button";
import { HeroCarousel } from "@/components/conformity-home/hero-carousel";
import { getCarouselSlides, staticHeroSlides } from "@/lib/carousel";
import type {
  CraHomeHero,
  CraHomeStatBand,
  CraHomeDepartureBoard,
  CraHomeRoadsSplit,
  CraHomePersonas,
  CraHomeEngine,
  CraHomeRetainer,
  CraHomeWhyOxot,
  CraHomeIntake,
  CraHomeProcess,
  CraHomeFinalCta
} from "@/lib/cra-home";
import type { Locale } from "@/i18n/config";

const EYEBROW = "text-xs font-semibold uppercase tracking-[0.2em] text-primary";
const H2 =
  "mt-3 max-w-2xl text-3xl font-bold leading-[1.1] tracking-tight text-foreground sm:text-4xl";
const DISPLAY = { fontFamily: "var(--font-display)" } as const;

export interface IntakeStrings {
  form: IntakeFormStrings;
  success: IntakeSuccessStrings;
}

/** 1 — Hero: CRA headline + credibility + "2026 reality" + a primary intake CTA
 *  on the left; the admin-editable hero carousel on the right. Async server
 *  component: it fetches the DB-backed carousel slides (with the shipped static
 *  deck as fallback) and passes them down to <HeroCarousel>. The intake form no
 *  longer lives here — it has its own dedicated section (#intake) lower down. */
export async function Hero({
  hero,
  locale,
  assistLabel,
  seedTemplate
}: {
  hero: CraHomeHero;
  locale: Locale;
  assistLabel: string;
  seedTemplate: string;
}) {
  const dbSlides = await getCarouselSlides(locale);
  const slides = dbSlides.length > 0 ? dbSlides : staticHeroSlides(locale);
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
          <div className="mt-6 max-w-xl rounded-[var(--radius)] border border-primary/30 bg-primary/5 p-4 text-xs leading-relaxed text-foreground">
            {hero.realityCallout}
          </div>
          <div className="mt-7 flex flex-wrap items-center gap-3">
            <BookIntakeButton label={hero.ctaLabel} />
            <AskAssistantButton label={assistLabel} seedTemplate={seedTemplate} />
          </div>
        </Reveal>
        <Reveal delay={0.1}>
          <HeroCarousel locale={locale} slides={slides} />
        </Reveal>
      </div>
    </section>
  );
}

/** 2 — Headline stat band: the four exec-briefing headline numbers. */
export function StatBand({ band }: { band: CraHomeStatBand }) {
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

/** 3 — The departure board: scroll-animated bars over an 18-month axis. */
export function DepartureBoard({ board }: { board: CraHomeDepartureBoard }) {
  return (
    <section className="border-b border-border py-16 sm:py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <h2 className={H2} style={DISPLAY}>
            {board.title}
          </h2>
          <p className="mt-4 max-w-2xl text-base leading-relaxed text-muted-foreground">{board.intro}</p>
        </Reveal>
        <div className="mt-8">
          <DepartureBoardChart board={board} />
        </div>
      </div>
    </section>
  );
}

/** 4 — The pathway: an interactive SVG road map to the CE mark, plus the CRA
 *  obligations stat bar. */
export function RoadsSplit({
  split,
  assistLabel,
  seedTemplate
}: {
  split: CraHomeRoadsSplit;
  assistLabel: string;
  seedTemplate: string;
}) {
  return (
    <section className="border-b border-border bg-muted/30 py-16 sm:py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <h2 className={H2} style={DISPLAY}>
            {split.title}
          </h2>
          <p className="mt-4 max-w-2xl text-base leading-relaxed text-muted-foreground">{split.intro}</p>
        </Reveal>
        <div className="mt-8">
          <RoadsSplitInteractive split={split} />
        </div>

        {/* CRA obligations stat bar. */}
        <Stagger className="mt-8 grid grid-cols-2 gap-px overflow-hidden rounded-[var(--radius)] border border-border bg-border sm:grid-cols-3 lg:grid-cols-6">
          {split.statBar.map((s) => (
            <StaggerItem key={s.value} className="bg-card">
              <div className="h-full p-4">
                <div className="text-sm font-bold text-primary" style={DISPLAY}>
                  {s.value}
                </div>
                <p className="mt-1 text-[11px] leading-snug text-muted-foreground">{s.label}</p>
              </div>
            </StaggerItem>
          ))}
        </Stagger>

        <Reveal>
          <div className="mt-6 flex justify-center">
            <AskAssistantButton label={assistLabel} seedTemplate={seedTemplate} />
          </div>
        </Reveal>
      </div>
    </section>
  );
}

/** 5 — Persona teasers: five positions in the chain, each with its BUYS line. */
export function Personas({ personas }: { personas: CraHomePersonas }) {
  return (
    <section className="border-b border-border py-16 sm:py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <h2 className={H2} style={DISPLAY}>
            {personas.title}
          </h2>
          <p className="mt-4 max-w-2xl text-base leading-relaxed text-muted-foreground">{personas.intro}</p>
        </Reveal>
        <Stagger className="mt-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-5">
          {personas.cards.map((c) => (
            <StaggerItem key={c.segment} className="h-full">
              <PersonaCard card={c} buysLabel={personas.buysLabel} />
            </StaggerItem>
          ))}
        </Stagger>
      </div>
    </section>
  );
}

/** 6 — The engine: the cyber digital twin — standardised BOMs, the 7-step IEC
 *  62443 risk process, and the "every output twice" dual-format principle. */
export function Engine({ engine }: { engine: CraHomeEngine }) {
  return (
    <section className="border-b border-border py-16 sm:py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <p className={EYEBROW}>{engine.eyebrow}</p>
          <h2 className={H2} style={DISPLAY}>
            {engine.title}
          </h2>
          <p className="mt-4 max-w-3xl text-base leading-relaxed text-muted-foreground">{engine.intro}</p>
        </Reveal>

        <div className="mt-10 grid gap-6 lg:grid-cols-2">
          {/* Standardised bills of materials. */}
          <Reveal>
            <div className="h-full rounded-[calc(var(--radius)+2px)] border border-border bg-card p-6">
              <h3 className="text-sm font-bold uppercase tracking-wide text-primary">{engine.bomsTitle}</h3>
              <Stagger className="mt-4 space-y-2.5">
                {engine.boms.map((b) => (
                  <StaggerItem key={b.code}>
                    <div className="flex items-start gap-3 rounded-lg border border-border bg-background p-3">
                      <span className="shrink-0 rounded bg-primary/10 px-2 py-1 text-[11px] font-bold text-primary">
                        {b.code}
                      </span>
                      <span className="text-xs leading-snug text-muted-foreground">{b.label}</span>
                    </div>
                  </StaggerItem>
                ))}
              </Stagger>
              <p className="mt-4 text-xs leading-relaxed text-foreground/80">{engine.bomsNote}</p>
            </div>
          </Reveal>

          {/* The 7-step IEC 62443 risk process. */}
          <Reveal delay={0.1}>
            <div className="h-full rounded-[calc(var(--radius)+2px)] border border-border bg-card p-6">
              <h3 className="text-sm font-bold uppercase tracking-wide text-primary">{engine.riskTitle}</h3>
              <Stagger className="mt-4 space-y-2.5">
                {engine.riskSteps.map((s) => (
                  <StaggerItem key={s.number}>
                    <div className="flex items-start gap-3">
                      <span className="flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-primary text-[11px] font-bold text-primary-foreground">
                        {s.number}
                      </span>
                      <p className="text-xs leading-snug text-muted-foreground">
                        <strong className="text-foreground">{s.title}</strong> — {s.body}
                      </p>
                    </div>
                  </StaggerItem>
                ))}
              </Stagger>
              <p className="mt-4 rounded-lg border border-primary/20 bg-primary/5 p-3 text-xs leading-relaxed text-foreground">
                {engine.riskNote}
              </p>
            </div>
          </Reveal>
        </div>

        {/* Every output, twice. */}
        <Reveal>
          <h3 className="mt-10 text-center text-sm font-bold uppercase tracking-wide text-foreground" style={DISPLAY}>
            {engine.outputsTitle}
          </h3>
        </Reveal>
        <div className="mt-4 grid gap-6 sm:grid-cols-2">
          <SpotlightCard className="h-full rounded-[calc(var(--radius)+2px)] border border-border bg-card p-6">
            <p className="text-xs font-bold uppercase tracking-wide text-primary">{engine.humanLabel}</p>
            <p className="mt-2 text-sm leading-relaxed text-muted-foreground">{engine.outputsHuman}</p>
          </SpotlightCard>
          <SpotlightCard className="h-full rounded-[calc(var(--radius)+2px)] border border-border bg-card p-6">
            <p className="text-xs font-bold uppercase tracking-wide text-primary">{engine.machineLabel}</p>
            <p className="mt-2 text-sm leading-relaxed text-muted-foreground">{engine.outputsMachine}</p>
          </SpotlightCard>
        </div>
        <Reveal>
          <p className="mx-auto mt-6 max-w-3xl text-center text-sm leading-relaxed text-muted-foreground">
            {engine.outputsNote}
          </p>
        </Reveal>
      </div>
    </section>
  );
}

/** 7 — Retainer: three phases + the reserved-seat tile, visually distinct. */
export function Retainer({ retainer }: { retainer: CraHomeRetainer }) {
  return (
    <section className="border-b border-border py-16 sm:py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <h2 className={H2} style={DISPLAY}>
            {retainer.title}
          </h2>
          <p className="mt-4 max-w-2xl text-base leading-relaxed text-muted-foreground">{retainer.intro}</p>
        </Reveal>
        <Stagger className="mt-8 grid gap-5 sm:grid-cols-2 lg:grid-cols-4">
          {retainer.phases.map((p) => (
            <StaggerItem key={p.tag} className="h-full">
              <div className="h-full rounded-[var(--radius)] border-t-4 border-primary bg-card p-5">
                <p className="text-[11px] font-bold uppercase tracking-wide text-primary">{p.tag}</p>
                <h3 className="mt-2 text-base font-semibold text-foreground" style={DISPLAY}>
                  {p.title}
                </h3>
                <p className="mt-2 text-sm leading-relaxed text-muted-foreground">{p.body}</p>
              </div>
            </StaggerItem>
          ))}
          <StaggerItem className="h-full">
            <div className="h-full rounded-[var(--radius)] bg-primary p-5 text-primary-foreground">
              <p className="text-[11px] font-bold uppercase tracking-wide">{retainer.reservedSeat.tag}</p>
              <h3 className="mt-2 text-base font-semibold" style={DISPLAY}>
                {retainer.reservedSeat.title}
              </h3>
              <p className="mt-2 text-sm leading-relaxed opacity-90">{retainer.reservedSeat.body}</p>
            </div>
          </StaggerItem>
        </Stagger>
        <Reveal>
          <p className="mt-6 text-xs text-muted-foreground">{retainer.digitalTwin}</p>
        </Reveal>
      </div>
    </section>
  );
}

/** 8 — Why OXOT wins: the four-pillar model band. */
export function WhyOxot({ why }: { why: CraHomeWhyOxot }) {
  return (
    <section className="border-b border-border bg-muted/30 py-16 sm:py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <p className={EYEBROW}>{why.eyebrow}</p>
          <h2 className={H2} style={DISPLAY}>
            {why.title}
          </h2>
          <p className="mt-4 max-w-2xl text-base leading-relaxed text-muted-foreground">{why.intro}</p>
        </Reveal>
        <Stagger className="mt-8 grid gap-5 sm:grid-cols-2 lg:grid-cols-4">
          {why.pillars.map((p) => (
            <StaggerItem key={p.title} className="h-full">
              <SpotlightCard className="h-full rounded-[var(--radius)] border border-border bg-card p-5">
                <h3 className="text-base font-semibold text-foreground" style={DISPLAY}>
                  {p.title}
                </h3>
                <p className="mt-2 text-sm leading-relaxed text-muted-foreground">{p.body}</p>
              </SpotlightCard>
            </StaggerItem>
          ))}
        </Stagger>
      </div>
    </section>
  );
}

/** 9 — Intake: persuasive copy + the 5-step "press the button" walkthrough on
 *  the left, the intake form on the right. Anchor target (#intake) for every
 *  "Book the intake" CTA on the page. */
export function IntakeSection({
  intake,
  process,
  locale,
  strings
}: {
  intake: CraHomeIntake;
  process: CraHomeProcess;
  locale: Locale;
  strings: IntakeStrings;
}) {
  return (
    <section id="intake" className="scroll-mt-20 border-b border-border py-16 sm:py-20">
      <div className="mx-auto grid max-w-6xl items-start gap-10 px-4 lg:grid-cols-2 lg:gap-14">
        <Reveal>
          <p className={EYEBROW}>{intake.eyebrow}</p>
          <h2 className={H2} style={DISPLAY}>
            {intake.title}
          </h2>
          <p className="mt-4 text-base leading-relaxed text-muted-foreground">{intake.intro}</p>

          <ol className="mt-8 space-y-4 border-l border-border pl-6">
            {process.steps.map((s) => (
              <li key={s.number} className="relative">
                <span className="absolute -left-[33px] flex h-6 w-6 items-center justify-center rounded-full bg-primary text-[11px] font-bold text-primary-foreground">
                  {s.number}
                </span>
                <p className="text-sm font-semibold text-foreground">{s.title}</p>
                <p className="mt-0.5 text-sm leading-relaxed text-muted-foreground">{s.body}</p>
              </li>
            ))}
          </ol>

          <div className="mt-8 rounded-[var(--radius)] border border-primary/30 bg-primary/5 p-4 text-sm leading-relaxed text-foreground">
            {intake.promise}
          </div>
        </Reveal>

        <Reveal delay={0.1} className="lg:sticky lg:top-6">
          <h3 className="text-lg font-semibold text-foreground" style={DISPLAY}>
            {intake.formHeading}
          </h3>
          <p className="mt-1 text-sm text-muted-foreground">{intake.formSub}</p>
          <div className="mt-4">
            <IntakeForm
              locale={locale}
              strings={strings.form}
              successStrings={strings.success}
              leaveWith={intake.promise}
            />
          </div>
        </Reveal>
      </div>
    </section>
  );
}

/** 10 — Final CTA: "The wall is fixed. The queue is not." */
export function FinalCta({ cta }: { cta: CraHomeFinalCta }) {
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
            <BookIntakeButton label={cta.ctaLabel} />
          </div>
        </Reveal>
      </div>
    </section>
  );
}
