// Block CMS — server registry (docs/BLOCK-CMS-PLAN.md §C.2/C.3).
// SERVER MODULE: it value-imports the section components (which import the
// "use client" interactive leaves). It must NEVER be imported by a client
// component — the admin editor forms live in a separate client registry.
//
// Each adapter renders the EXISTING section component with the EXACT props the
// live route passes today (verified against src/app/[locale]/cyber-digital-twin/
// page.tsx and src/app/[locale]/conformity/page.tsx), so the block-composed
// output is identical to the coded routes by construction. TypeScript enforces
// prop-shape parity: a wrong prop fails `tsc`.
import type { ReactNode } from "react";
import type { Locale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import type { BlockType } from "@/lib/blocks/types";

// --- CDT sections + config types ---
import {
  Hero as CdtHeroSection,
  StatBand as CdtStatBandSection,
  LivingModel as CdtLivingModelSection,
  Boms as CdtBomsSection,
  Drilldown as CdtDrilldownSection,
  Consequence as CdtConsequenceSection,
  Priority as CdtPrioritySection,
  MonteCarlo as CdtMonteCarloSection,
  Methodology as CdtMethodologySection,
  Outcomes as CdtOutcomesSection,
  FinalCta as CdtFinalCtaSection
} from "@/components/cdt/sections";
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

// --- Conformity sections + config types ---
import {
  Hero as ConformityHeroSection,
  RegulationBand as ConformityRegulationBandSection,
  Stats as ConformityStatsSection,
  Platform as ConformityPlatformSection,
  Problem as ConformityProblemSection,
  Shift as ConformityShiftSection,
  Comparison as ConformityComparisonSection,
  HowItWorks as ConformityHowItWorksSection,
  Testimonial as ConformityTestimonialSection,
  FinalCta as ConformityFinalCtaSection
} from "@/components/conformity-home/sections";
import { ConsultingCarousel } from "@/components/conformity-home/consulting-carousel";
import { Faq } from "@/components/conformity-home/faq";
import { Reveal } from "@/components/motion/fx";
import type {
  ConformityHomeHero,
  ConformityHomeLogoWall,
  ConformityHomeStat,
  ConformityHomeFeatureGrid,
  ConformityHomeProblemShift,
  ConformityHomeComparison,
  ConformityHomeSteps,
  ConformityHomeQuote,
  ConformityHomeFaq,
  ConformityHomeCta
} from "@/lib/conformity-home";

// --- Home / CRA-readiness sections + config types ---
import {
  Hero as CraHeroSection,
  StatBand as CraStatBandSection,
  DepartureBoard as CraDepartureBoardSection,
  RoadsSplit as CraRoadsSplitSection,
  Personas as CraPersonasSection,
  Engine as CraEngineSection,
  Retainer as CraRetainerSection,
  WhyOxot as CraWhyOxotSection,
  IntakeSection as CraIntakeSection,
  FinalCta as CraFinalCtaSection
} from "@/components/cra-home/sections";
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

// --- Generic prose block ---
import { MarkdownContent } from "@/components/markdown";
// --- Generic effect-rich blocks (for new dynamic pages) ---
import {
  GenericHero,
  GenericStats,
  GenericFeatureGrid,
  GenericCta,
  GenericMedia,
  GenericDivider
} from "@/components/blocks/generic-sections";
import type {
  GenericHeroConfig,
  GenericStatsConfig,
  GenericFeatureGridConfig,
  GenericCtaConfig,
  GenericMediaConfig,
  GenericDividerConfig
} from "@/components/blocks/generic-sections";

type Dict = ReturnType<typeof getDictionary>;

/**
 * Everything an adapter may need beyond its own `config`:
 *  - locale         : several sections take it (Outcomes, FinalCta, Shift, Hero…)
 *  - dict           : dictionary-bound content (CDT hero agent labels, the
 *                     conformity consulting carousel)
 *  - sibling(type)  : the config of another block on the same page — the CDT
 *                     hero needs the livingModel to render its seven-layer graph
 */
export interface RenderCtx {
  locale: Locale;
  dict: Dict;
  sibling: (type: BlockType) => unknown;
}

export interface BlockDef {
  type: BlockType;
  /** Human label for the admin palette. */
  label: string;
  /** Render the existing section with identical props. Returns a JSX element so
   *  async server components (e.g. the conformity Hero) resolve normally. */
  Render: (config: unknown, ctx: RenderCtx) => ReactNode;
}

const H2_DISPLAY = { fontFamily: "var(--font-display)" } as const;

export const BLOCK_REGISTRY: Record<BlockType, BlockDef> = {
  // ---------------- Cyber Digital Twin ----------------
  "cdt.hero": {
    type: "cdt.hero",
    label: "CDT — Hero",
    Render: (config, ctx) => (
      <CdtHeroSection
        hero={config as CdtHero}
        model={ctx.sibling("cdt.livingModel") as CdtLivingModel}
        locale={ctx.locale}
        assistLabel={ctx.dict.agent.assistCtaLabel}
        seedTemplate={ctx.dict.agent.seedTemplate}
      />
    )
  },
  "cdt.statBand": {
    type: "cdt.statBand",
    label: "CDT — Stat band",
    Render: (config) => <CdtStatBandSection band={config as CdtStatBand} />
  },
  "cdt.livingModel": {
    type: "cdt.livingModel",
    label: "CDT — Living model",
    Render: (config) => <CdtLivingModelSection model={config as CdtLivingModel} />
  },
  "cdt.boms": {
    type: "cdt.boms",
    label: "CDT — BOMs",
    Render: (config) => <CdtBomsSection boms={config as CdtBoms} />
  },
  "cdt.drilldown": {
    type: "cdt.drilldown",
    label: "CDT — Drilldown",
    Render: (config) => <CdtDrilldownSection drilldown={config as CdtDrilldown} />
  },
  "cdt.consequence": {
    type: "cdt.consequence",
    label: "CDT — Consequence",
    Render: (config) => <CdtConsequenceSection consequence={config as CdtConsequence} />
  },
  "cdt.priority": {
    type: "cdt.priority",
    label: "CDT — Priority matrix",
    Render: (config) => <CdtPrioritySection priority={config as CdtPriority} />
  },
  "cdt.monteCarlo": {
    type: "cdt.monteCarlo",
    label: "CDT — Monte Carlo",
    Render: (config) => <CdtMonteCarloSection monteCarlo={config as CdtMonteCarlo} />
  },
  "cdt.methodology": {
    type: "cdt.methodology",
    label: "CDT — Methodology",
    Render: (config) => <CdtMethodologySection methodology={config as CdtMethodology} />
  },
  "cdt.outcomes": {
    type: "cdt.outcomes",
    label: "CDT — Outcomes",
    Render: (config, ctx) => (
      <CdtOutcomesSection outcomes={config as CdtOutcomes} locale={ctx.locale} />
    )
  },
  "cdt.finalCta": {
    type: "cdt.finalCta",
    label: "CDT — Final CTA",
    Render: (config, ctx) => (
      <CdtFinalCtaSection cta={config as CdtFinalCta} locale={ctx.locale} />
    )
  },

  // ---------------- Conformity ----------------
  "conformity.hero": {
    type: "conformity.hero",
    label: "Conformity — Hero",
    Render: (config, ctx) => (
      <ConformityHeroSection hero={config as ConformityHomeHero} locale={ctx.locale} />
    )
  },
  "conformity.consultingCarousel": {
    type: "conformity.consultingCarousel",
    label: "Conformity — Consulting carousel",
    // Dictionary-bound + inline wrapper markup (conformity/page.tsx:86-92).
    Render: (_config, ctx) => (
      <section className="border-b border-border py-16">
        <div className="mx-auto max-w-6xl px-4">
          <Reveal>
            <ConsultingCarousel
              slides={ctx.dict.conformityHome.carousel.slides}
              locale={ctx.locale}
              labels={ctx.dict.conformityHome.carousel.labels}
            />
          </Reveal>
        </div>
      </section>
    )
  },
  "conformity.regulationBand": {
    type: "conformity.regulationBand",
    label: "Conformity — Regulation band",
    Render: (config) => (
      <ConformityRegulationBandSection logoWall={config as ConformityHomeLogoWall} />
    )
  },
  "conformity.stats": {
    type: "conformity.stats",
    label: "Conformity — Stats",
    Render: (config) => <ConformityStatsSection stats={config as ConformityHomeStat[]} />
  },
  "conformity.platform": {
    type: "conformity.platform",
    label: "Conformity — Platform",
    Render: (config) => (
      <ConformityPlatformSection featureGrid={config as ConformityHomeFeatureGrid} />
    )
  },
  "conformity.problem": {
    type: "conformity.problem",
    label: "Conformity — Problem",
    Render: (config) => (
      <ConformityProblemSection problem={config as ConformityHomeProblemShift} />
    )
  },
  "conformity.shift": {
    type: "conformity.shift",
    label: "Conformity — Shift",
    Render: (config, ctx) => (
      <ConformityShiftSection shift={config as ConformityHomeProblemShift} locale={ctx.locale} />
    )
  },
  "conformity.comparison": {
    type: "conformity.comparison",
    label: "Conformity — Comparison",
    Render: (config) => (
      <ConformityComparisonSection comparison={config as ConformityHomeComparison} />
    )
  },
  "conformity.howItWorks": {
    type: "conformity.howItWorks",
    label: "Conformity — How it works",
    Render: (config) => <ConformityHowItWorksSection steps={config as ConformityHomeSteps} />
  },
  "conformity.testimonial": {
    type: "conformity.testimonial",
    label: "Conformity — Testimonial",
    Render: (config) => <ConformityTestimonialSection quote={config as ConformityHomeQuote} />
  },
  "conformity.faq": {
    type: "conformity.faq",
    label: "Conformity — FAQ",
    // Inline wrapper markup (conformity/page.tsx:104-123).
    Render: (config) => {
      const faq = config as ConformityHomeFaq;
      return (
        <section className="border-b border-border py-20">
          <div className="mx-auto max-w-4xl px-4">
            <Reveal>
              <p className="text-xs font-semibold uppercase tracking-[0.2em] text-primary">
                {faq.eyebrow}
              </p>
              <h2
                className="mt-3 text-3xl font-bold leading-[1.1] tracking-tight text-foreground sm:text-4xl"
                style={H2_DISPLAY}
              >
                {faq.title}
              </h2>
            </Reveal>
            <Reveal>
              <div className="mt-8">
                <Faq items={faq.items} />
              </div>
            </Reveal>
          </div>
        </section>
      );
    }
  },
  "conformity.finalCta": {
    type: "conformity.finalCta",
    label: "Conformity — Final CTA",
    Render: (config, ctx) => (
      <ConformityFinalCtaSection cta={config as ConformityHomeCta} locale={ctx.locale} />
    )
  },

  // ---------------- Home / CRA-readiness ----------------
  "cra.hero": {
    type: "cra.hero", label: "Home — Hero",
    Render: (config, ctx) => (
      <CraHeroSection hero={config as CraHomeHero} locale={ctx.locale}
        assistLabel={ctx.dict.agent.assistCtaLabel} seedTemplate={ctx.dict.agent.seedTemplate} />
    )
  },
  "cra.statBand": {
    type: "cra.statBand", label: "Home — Stat band",
    Render: (config) => <CraStatBandSection band={config as CraHomeStatBand} />
  },
  "cra.departureBoard": {
    type: "cra.departureBoard", label: "Home — Departure board",
    Render: (config) => <CraDepartureBoardSection board={config as CraHomeDepartureBoard} />
  },
  "cra.roadsSplit": {
    type: "cra.roadsSplit", label: "Home — Roads / map",
    Render: (config, ctx) => (
      <CraRoadsSplitSection split={config as CraHomeRoadsSplit}
        assistLabel={ctx.dict.agent.assistCtaLabel} seedTemplate={ctx.dict.agent.seedTemplate} />
    )
  },
  "cra.personas": {
    type: "cra.personas", label: "Home — Personas",
    Render: (config) => <CraPersonasSection personas={config as CraHomePersonas} />
  },
  "cra.engine": {
    type: "cra.engine", label: "Home — Engine",
    Render: (config) => <CraEngineSection engine={config as CraHomeEngine} />
  },
  "cra.retainer": {
    type: "cra.retainer", label: "Home — Retainer",
    Render: (config) => <CraRetainerSection retainer={config as CraHomeRetainer} />
  },
  "cra.whyOxot": {
    type: "cra.whyOxot", label: "Home — Why OXOT",
    Render: (config) => <CraWhyOxotSection why={config as CraHomeWhyOxot} />
  },
  "cra.intake": {
    type: "cra.intake", label: "Home — Intake form",
    // Composite: config carries both the intake and process sub-objects.
    Render: (config, ctx) => {
      const c = config as { intake: CraHomeIntake; process: CraHomeProcess };
      return (
        <CraIntakeSection intake={c.intake} process={c.process} locale={ctx.locale}
          strings={{ form: ctx.dict.intakeForm, success: ctx.dict.intakeSuccess }} />
      );
    }
  },
  "cra.finalCta": {
    type: "cra.finalCta", label: "Home — Final CTA",
    Render: (config) => <CraFinalCtaSection cta={config as CraHomeFinalCta} />
  },

  // ---------------- Generic, effect-rich (new dynamic pages) ----------------
  prose: {
    type: "prose",
    label: "Prose (Markdown)",
    Render: (config, ctx) => (
      <MarkdownContent
        source={(config as { markdown?: string }).markdown ?? ""}
        toc={false}
        locale={ctx.locale}
      />
    )
  },
  "block.hero": {
    type: "block.hero",
    label: "Hero",
    Render: (config, ctx) => <GenericHero config={config as GenericHeroConfig} locale={ctx.locale} />
  },
  "block.stats": {
    type: "block.stats",
    label: "Stat counters",
    Render: (config) => <GenericStats config={config as GenericStatsConfig} />
  },
  "block.featureGrid": {
    type: "block.featureGrid",
    label: "Feature grid",
    Render: (config) => <GenericFeatureGrid config={config as GenericFeatureGridConfig} />
  },
  "block.cta": {
    type: "block.cta",
    label: "CTA banner",
    Render: (config, ctx) => <GenericCta config={config as GenericCtaConfig} locale={ctx.locale} />
  },
  "block.media": {
    type: "block.media",
    label: "Image / media",
    Render: (config) => <GenericMedia config={config as GenericMediaConfig} />
  },
  "block.divider": {
    type: "block.divider",
    label: "Divider / spacer",
    Render: (config) => <GenericDivider config={config as GenericDividerConfig} />
  }
};
