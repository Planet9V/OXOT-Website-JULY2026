// Generic, reusable, effect-rich blocks for building NEW dynamic pages in the
// CMS (docs/BLOCK-CMS-PLAN.md, Phase 3). Server components; they reuse the same
// motion primitives (Reveal/Stagger/CountUp/SpotlightCard) as the flagship
// sections, so pages built from them get the same polished animations and honor
// the global stylesheet (foreground/muted/border/primary tokens) + dark/light.
import Link from "next/link";
import {
  Reveal,
  Stagger,
  StaggerItem,
  CountUp,
  SpotlightCard
} from "@/components/motion/fx";
import { Button } from "@/components/ui/button";
import { ArrowRight, Sparkles, ShieldCheck, Gauge, Layers, Network, Cpu, Boxes } from "lucide-react";
import type { Locale } from "@/i18n/config";

const EYEBROW = "text-xs font-semibold uppercase tracking-[0.2em] text-primary";
const DISPLAY = { fontFamily: "var(--font-display)" } as const;

// Curated icon set for the feature-grid block (admins pick by name).
const ICONS: Record<string, React.ElementType> = {
  sparkles: Sparkles, shield: ShieldCheck, gauge: Gauge, layers: Layers,
  network: Network, cpu: Cpu, boxes: Boxes, arrow: ArrowRight
};
function Icon({ name }: { name?: string }) {
  const C = ICONS[(name ?? "sparkles").toLowerCase()] ?? Sparkles;
  return <C className="h-5 w-5 text-primary" />;
}

function Cta({ locale, label, href, variant = "default" }: { locale: Locale; label?: string; href?: string; variant?: "default" | "outline" }) {
  if (!label) return null;
  const to = (href ?? "/contact").startsWith("http") ? href! : `/${locale}${href ?? "/contact"}`;
  return (
    <Button asChild size="lg" variant={variant}>
      <Link href={to}>
        {label}
        {variant === "default" && <ArrowRight />}
      </Link>
    </Button>
  );
}

/* ---------------- Generic Hero ---------------- */
export interface GenericHeroConfig {
  eyebrow?: string;
  title?: string;
  titleAccent?: string;
  subtitle?: string;
  primaryCta?: { label?: string; href?: string };
  secondaryCta?: { label?: string; href?: string };
  align?: "left" | "center";
}
export function GenericHero({ config, locale }: { config: GenericHeroConfig; locale: Locale }) {
  const center = config.align === "center";
  return (
    <section className="relative overflow-hidden border-b border-border">
      <div aria-hidden className="pointer-events-none absolute -right-24 -top-24 -z-10 h-[42vh] w-[42vh] rounded-full bg-primary/10 blur-3xl" />
      <div className={`relative mx-auto max-w-6xl px-4 py-16 sm:py-24 ${center ? "text-center" : ""}`}>
        <Reveal>
          {config.eyebrow ? <p className={EYEBROW}>{config.eyebrow}</p> : null}
          <h1 className="mt-3 text-3xl font-bold leading-[1.08] tracking-tight text-foreground sm:text-5xl" style={DISPLAY}>
            {config.title} {config.titleAccent ? <span className="text-primary">{config.titleAccent}</span> : null}
          </h1>
          {config.subtitle ? (
            <p className={`mt-5 max-w-xl text-base leading-relaxed text-muted-foreground ${center ? "mx-auto" : ""}`}>{config.subtitle}</p>
          ) : null}
          <div className={`mt-7 flex flex-wrap items-center gap-3 ${center ? "justify-center" : ""}`}>
            <Cta locale={locale} label={config.primaryCta?.label} href={config.primaryCta?.href} />
            <Cta locale={locale} label={config.secondaryCta?.label} href={config.secondaryCta?.href} variant="outline" />
          </div>
        </Reveal>
      </div>
    </section>
  );
}

/* ---------------- Generic Stats (count-up) ---------------- */
export interface GenericStatsConfig {
  items?: { value: string; label: string; sub?: string }[];
}
export function GenericStats({ config }: { config: GenericStatsConfig }) {
  const items = config.items ?? [];
  return (
    <section className="border-b border-border bg-muted/30 py-10 sm:py-12">
      <div className="mx-auto max-w-6xl px-4">
        <Stagger className="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
          {items.map((s, i) => (
            <StaggerItem key={`${s.label}-${i}`}>
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

/* ---------------- Generic Feature Grid ---------------- */
export interface GenericFeatureGridConfig {
  eyebrow?: string;
  title?: string;
  cards?: { icon?: string; title: string; body: string }[];
}
export function GenericFeatureGrid({ config }: { config: GenericFeatureGridConfig }) {
  const cards = config.cards ?? [];
  return (
    <section className="border-b border-border py-16 sm:py-20">
      <div className="mx-auto max-w-6xl px-4">
        <Reveal>
          {config.eyebrow ? <p className={EYEBROW}>{config.eyebrow}</p> : null}
          {config.title ? (
            <h2 className="mt-3 max-w-2xl text-3xl font-bold leading-[1.1] tracking-tight text-foreground sm:text-4xl" style={DISPLAY}>
              {config.title}
            </h2>
          ) : null}
        </Reveal>
        <Stagger className="mt-10 grid gap-6 md:grid-cols-2 lg:grid-cols-3">
          {cards.map((c, i) => (
            <StaggerItem key={`${c.title}-${i}`}>
              <SpotlightCard className="h-full rounded-[calc(var(--radius)+2px)] border border-border bg-card/60 p-6">
                <Icon name={c.icon} />
                <h3 className="mt-4 font-semibold text-foreground">{c.title}</h3>
                <p className="mt-2 text-sm leading-relaxed text-muted-foreground">{c.body}</p>
              </SpotlightCard>
            </StaggerItem>
          ))}
        </Stagger>
      </div>
    </section>
  );
}

/* ---------------- Generic CTA banner ---------------- */
export interface GenericCtaConfig {
  title?: string;
  subtitle?: string;
  primaryCta?: { label?: string; href?: string };
  secondaryCta?: { label?: string; href?: string };
}
export function GenericCta({ config, locale }: { config: GenericCtaConfig; locale: Locale }) {
  return (
    <section className="border-b border-border py-16 sm:py-20">
      <div className="mx-auto max-w-4xl px-4 text-center">
        <Reveal>
          <h2 className="text-3xl font-bold leading-[1.1] tracking-tight text-foreground sm:text-4xl" style={DISPLAY}>
            {config.title}
          </h2>
          {config.subtitle ? <p className="mx-auto mt-4 max-w-2xl text-base leading-relaxed text-muted-foreground">{config.subtitle}</p> : null}
          <div className="mt-7 flex flex-wrap items-center justify-center gap-3">
            <Cta locale={locale} label={config.primaryCta?.label} href={config.primaryCta?.href} />
            <Cta locale={locale} label={config.secondaryCta?.label} href={config.secondaryCta?.href} variant="outline" />
          </div>
        </Reveal>
      </div>
    </section>
  );
}

/* ---------------- Generic Media (image) ---------------- */
export interface GenericMediaConfig {
  src?: string;
  alt?: string;
  caption?: string;
  aspect?: "16/9" | "4/3" | "1/1" | "21/9";
}
export function GenericMedia({ config }: { config: GenericMediaConfig }) {
  if (!config.src) return null;
  const aspect = config.aspect ?? "16/9";
  return (
    <section className="border-b border-border py-12">
      <div className="mx-auto max-w-5xl px-4">
        <Reveal>
          <div className="overflow-hidden rounded-[calc(var(--radius)+4px)] border border-border bg-card/60 shadow-e1">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img src={config.src} alt={config.alt ?? ""} className="w-full object-cover" style={{ aspectRatio: aspect }} />
          </div>
          {config.caption ? <p className="mt-3 text-center text-xs text-muted-foreground">{config.caption}</p> : null}
        </Reveal>
      </div>
    </section>
  );
}

/* ---------------- Generic Divider / spacer ---------------- */
export interface GenericDividerConfig {
  variant?: "line" | "space";
  size?: "sm" | "md" | "lg";
}
export function GenericDivider({ config }: { config: GenericDividerConfig }) {
  const pad = config.size === "lg" ? "py-16" : config.size === "sm" ? "py-6" : "py-10";
  if (config.variant === "space") return <div className={pad} aria-hidden />;
  return (
    <div className={`mx-auto max-w-6xl px-4 ${pad}`}>
      <div className="h-px w-full bg-border" />
    </div>
  );
}
