"use client";
import Link from "next/link";
import { ArrowRight, Check } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Reveal } from "@/components/motion/fx";
import type { ConformityHomeHero } from "@/lib/conformity-home";

const EYEBROW = "text-xs font-semibold uppercase tracking-[0.2em] text-primary";
const DISPLAY = { fontFamily: "var(--font-display)" } as const;

/**
 * The animated text column of the hero. Uses the app's <Reveal> (fade + rise on
 * mount, with a guaranteed-visible fallback) for a staggered load-in slide-up —
 * this is the reliable animation the rest of the site uses. A bare framer-motion
 * `animate` on an SSR-rendered above-the-fold element does NOT reliably fire and
 * left the hero stuck at opacity 0, so we deliberately use Reveal here. Rounded-
 * full pill CTAs match the source styling. Rendered inside the server <Hero>
 * alongside the PDF <HeroCarousel>.
 */
export function HeroIntro({ hero, locale }: { hero: ConformityHomeHero; locale: string }) {
  return (
    <div>
      <Reveal delay={0} y={12}>
        <p className={EYEBROW}>{hero.eyebrow}</p>
      </Reveal>
      <Reveal delay={0.08}>
        <h1
          className="mt-4 text-4xl font-bold leading-[1.05] tracking-tight text-foreground sm:text-6xl"
          style={DISPLAY}
        >
          {hero.title}
        </h1>
      </Reveal>
      <Reveal delay={0.16}>
        <p className="mt-6 max-w-xl text-base leading-relaxed text-muted-foreground sm:text-lg">
          {hero.subtitle}
        </p>
      </Reveal>
      <Reveal delay={0.24}>
        <div className="mt-8 flex flex-wrap gap-3">
          <Button
            asChild
            size="lg"
            className="h-12 rounded-full px-8 text-base shadow-lg shadow-primary/20 hover:shadow-primary/40"
          >
            <Link href={`/${locale}${hero.primaryCta.href}`}>
              {hero.primaryCta.label}
              <ArrowRight />
            </Link>
          </Button>
          <Button asChild size="lg" variant="outline" className="h-12 rounded-full px-8 text-base">
            <Link href={`/${locale}${hero.secondaryCta.href}`}>{hero.secondaryCta.label}</Link>
          </Button>
        </div>
      </Reveal>
      <Reveal delay={0.32}>
        <ul className="mt-8 flex flex-wrap gap-x-6 gap-y-2">
          {hero.bullets.map((b) => (
            <li key={b} className="flex items-center gap-2 text-sm text-muted-foreground">
              <Check className="h-4 w-4 shrink-0 text-primary" aria-hidden />
              {b}
            </li>
          ))}
        </ul>
      </Reveal>
    </div>
  );
}
