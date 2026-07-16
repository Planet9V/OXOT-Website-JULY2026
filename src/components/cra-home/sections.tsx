import { Reveal, Stagger, StaggerItem } from "@/components/motion/fx";
import { IntakeForm, type IntakeFormStrings, type IntakeSuccessStrings } from "@/components/cra-home/intake-form";
import { DepartureBoard as DepartureBoardChart } from "@/components/cra-home/departure-board";
import { RoadsSplit as RoadsSplitInteractive } from "@/components/cra-home/roads-split";
import { PersonaCard } from "@/components/cra-home/persona-card";
import { AskAssistantButton } from "@/components/cra-home/ask-assistant-button";
import { BookIntakeButton } from "@/components/cra-home/book-intake-button";
import type {
  CraHomeHero,
  CraHomeDepartureBoard,
  CraHomeRoadsSplit,
  CraHomePersonas,
  CraHomeRetainer,
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

/** 1 — Hero: headline + "2026 reality" callout on the left, the intake form
 *  (with an "ask the assistant" escape hatch) on the right. */
export function Hero({
  hero,
  locale,
  intake,
  assistLabel,
  seedTemplate
}: {
  hero: CraHomeHero;
  locale: Locale;
  intake: IntakeStrings;
  assistLabel: string;
  seedTemplate: string;
}) {
  return (
    <section className="relative overflow-hidden border-b border-border">
      <div
        aria-hidden
        className="pointer-events-none absolute -right-24 -top-24 -z-10 h-[42vh] w-[42vh] rounded-full bg-primary/10 blur-3xl"
      />
      <div className="relative mx-auto grid max-w-6xl items-start gap-10 px-4 py-16 sm:py-24 lg:grid-cols-[1.1fr_0.9fr] lg:gap-12">
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
          <div className="mt-6">
            <AskAssistantButton label={assistLabel} seedTemplate={seedTemplate} />
          </div>
        </Reveal>
        <Reveal delay={0.1} className="lg:sticky lg:top-6">
          <h2 className="text-lg font-semibold text-foreground" style={DISPLAY}>
            {hero.formHeading}
          </h2>
          <p className="mt-1 text-sm text-muted-foreground">{hero.formSub}</p>
          <div className="mt-4">
            <IntakeForm
              locale={locale}
              strings={intake.form}
              successStrings={intake.success}
              leaveWith={hero.leaveWith}
            />
          </div>
        </Reveal>
      </div>
    </section>
  );
}

/** 2 — The departure board: scroll-animated bars over an 18-month axis. */
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

/** 3 — Road split: three roads to the CE mark, clickable to preselect a segment. */
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
        <Reveal>
          <div className="mt-6 flex justify-center">
            <AskAssistantButton label={assistLabel} seedTemplate={seedTemplate} />
          </div>
        </Reveal>
      </div>
    </section>
  );
}

/** 4 — Persona teasers: five positions in the chain, each clickable. */
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
              <PersonaCard card={c} />
            </StaggerItem>
          ))}
        </Stagger>
      </div>
    </section>
  );
}

/** 5 — Retainer: three phases + the reserved-seat tile, visually distinct. */
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

/** 6 — Process strip: five steps, step 2 names Vincent deliberately. */
export function ProcessStrip({ process }: { process: CraHomeProcess }) {
  return (
    <section className="border-b border-border py-16 sm:py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          <h2 className={H2} style={DISPLAY}>
            {process.title}
          </h2>
        </Reveal>
        <Stagger className="mt-8 grid gap-5 sm:grid-cols-2 lg:grid-cols-5">
          {process.steps.map((s) => (
            <StaggerItem key={s.number}>
              <div className="h-full rounded-[var(--radius)] border border-border bg-card p-5">
                <div className="text-2xl font-bold text-primary" style={DISPLAY}>
                  {s.number}
                </div>
                <h3 className="mt-2 text-sm font-semibold text-foreground">{s.title}</h3>
                <p className="mt-2 text-xs leading-relaxed text-muted-foreground">{s.body}</p>
              </div>
            </StaggerItem>
          ))}
        </Stagger>
      </div>
    </section>
  );
}

/** 7 — Final CTA: "The wall is fixed. The queue is not." */
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
