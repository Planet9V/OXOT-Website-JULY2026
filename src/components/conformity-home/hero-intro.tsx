"use client";
import * as React from "react";
import Link from "next/link";
import { ArrowRight, Check } from "lucide-react";
import { motion, useReducedMotion } from "motion/react";
import { Button } from "@/components/ui/button";
import type { ConformityHomeHero } from "@/lib/conformity-home";

const EYEBROW = "text-xs font-semibold uppercase tracking-[0.2em] text-primary";
const DISPLAY = { fontFamily: "var(--font-display)" } as const;

/**
 * The animated text column of the hero. Ported from the source hero-section:
 * load-in slide-ups (eyebrow → h1 → subtitle → CTAs), reduced-motion aware,
 * rounded-full pill CTAs. Rendered inside the server <Hero> alongside the PDF
 * <HeroCarousel>. Uses the `motion` package (not framer-motion).
 *
 * The animation is triggered by a post-mount state flip (not a static `animate`
 * on mount): a bare `animate` on an SSR-rendered motion element does not reliably
 * transition from `initial`, which left the above-the-fold hero stuck at opacity 0.
 * Flipping `shown` in an effect forces the animation to play, and a safety timeout
 * guarantees the content can never stay hidden.
 */
export function HeroIntro({ hero, locale }: { hero: ConformityHomeHero; locale: string }) {
  const reduce = useReducedMotion();
  const [shown, setShown] = React.useState(false);
  React.useEffect(() => {
    const raf = requestAnimationFrame(() => setShown(true));
    const t = setTimeout(() => setShown(true), 400); // belt-and-braces fallback
    return () => {
      cancelAnimationFrame(raf);
      clearTimeout(t);
    };
  }, []);
  const rise = (delay: number, y = 20) =>
    reduce
      ? {}
      : {
          initial: { opacity: 0, y },
          animate: shown ? { opacity: 1, y: 0 } : { opacity: 0, y },
          transition: { duration: 0.5, delay }
        };

  return (
    <div>
      <motion.p className={EYEBROW} {...rise(0, 10)}>
        {hero.eyebrow}
      </motion.p>
      <motion.h1
        className="mt-4 text-4xl font-bold leading-[1.05] tracking-tight text-foreground sm:text-6xl"
        style={DISPLAY}
        {...rise(0.1)}
      >
        {hero.title}
      </motion.h1>
      <motion.p
        className="mt-6 max-w-xl text-base leading-relaxed text-muted-foreground sm:text-lg"
        {...rise(0.2)}
      >
        {hero.subtitle}
      </motion.p>
      <motion.div className="mt-8 flex flex-wrap gap-3" {...rise(0.3)}>
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
        <Button
          asChild
          size="lg"
          variant="outline"
          className="h-12 rounded-full px-8 text-base"
        >
          <Link href={`/${locale}${hero.secondaryCta.href}`}>{hero.secondaryCta.label}</Link>
        </Button>
      </motion.div>
      <motion.ul className="mt-8 flex flex-wrap gap-x-6 gap-y-2" {...rise(0.4)}>
        {hero.bullets.map((b) => (
          <li key={b} className="flex items-center gap-2 text-sm text-muted-foreground">
            <Check className="h-4 w-4 shrink-0 text-primary" aria-hidden />
            {b}
          </li>
        ))}
      </motion.ul>
    </div>
  );
}
