import Link from "next/link";
import { ArrowRight, Check } from "lucide-react";
import { Button } from "@/components/ui/button";
import type { ConformityHomeHero } from "@/lib/conformity-home";

const EYEBROW = "text-xs font-semibold uppercase tracking-[0.2em] text-primary";
const DISPLAY = { fontFamily: "var(--font-display)" } as const;

/**
 * Animated text column of the hero — uses tailwindcss-animate CSS keyframes
 * (`animate-in fade-in slide-in-from-bottom` with staggered delays), NOT JS-driven
 * motion. CSS animations always complete and end at the element's natural (visible)
 * state, so the above-the-fold hero can never get stuck at opacity 0 (which is what
 * happened with both raw framer-motion and the Reveal wrapper here). Rounded-full
 * pill CTAs match the source styling. Rendered by the server <Hero> next to the
 * PDF <HeroCarousel>.
 */
export function HeroIntro({ hero, locale }: { hero: ConformityHomeHero; locale: string }) {
  return (
    <div>
      <p className={`${EYEBROW} animate-in fade-in slide-in-from-bottom-2 fill-mode-both duration-700`}>
        {hero.eyebrow}
      </p>
      <h1
        className="mt-4 text-4xl font-bold leading-[1.05] tracking-tight text-foreground animate-in fade-in slide-in-from-bottom-3 fill-mode-both delay-100 duration-700 sm:text-6xl"
        style={DISPLAY}
      >
        {hero.title}
      </h1>
      <p className="mt-6 max-w-xl text-base leading-relaxed text-muted-foreground animate-in fade-in slide-in-from-bottom-3 fill-mode-both delay-200 duration-700 sm:text-lg">
        {hero.subtitle}
      </p>
      <div className="mt-8 flex flex-wrap gap-3 animate-in fade-in slide-in-from-bottom-3 fill-mode-both delay-300 duration-700">
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
      <ul className="mt-8 flex flex-wrap gap-x-6 gap-y-2 animate-in fade-in fill-mode-both delay-500 duration-700">
        {hero.bullets.map((b) => (
          <li key={b} className="flex items-center gap-2 text-sm text-muted-foreground">
            <Check className="h-4 w-4 shrink-0 text-primary" aria-hidden />
            {b}
          </li>
        ))}
      </ul>
    </div>
  );
}
