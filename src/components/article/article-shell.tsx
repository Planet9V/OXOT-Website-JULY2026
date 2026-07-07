"use client";
import * as React from "react";
import Link from "next/link";
import { motion, useReducedMotion, useScroll, useSpring } from "motion/react";
import { Clock, CalendarDays, Link2, ArrowRight, List } from "lucide-react";
import { Aurora } from "@/components/motion/fx";
import { cn } from "@/lib/utils";

type Toc = { id: string; text: string }[];

function useScrollSpy(ids: string[]) {
  const [active, setActive] = React.useState<string | null>(ids[0] ?? null);
  React.useEffect(() => {
    if (!ids.length) return;
    const obs = new IntersectionObserver(
      (entries) => {
        const vis = entries.filter((e) => e.isIntersecting).sort((a, b) => a.boundingClientRect.top - b.boundingClientRect.top);
        if (vis[0]) setActive(vis[0].target.id);
      },
      { rootMargin: "-96px 0px -70% 0px", threshold: 0 }
    );
    ids.forEach((id) => { const el = document.getElementById(id); if (el) obs.observe(el); });
    return () => obs.disconnect();
  }, [ids]);
  return active;
}

const RELATED: { slug: string; label: string; note: Record<"en" | "nl", string> }[] = [
  { slug: "cra", label: "Cyber Resilience Act", note: { en: "Security as a condition of market access for products", nl: "Beveiliging als voorwaarde voor markttoegang van producten" } },
  { slug: "nis2", label: "NIS2 Directive", note: { en: "Risk-management & reporting duties for operators", nl: "Risicobeheer- en meldplicht voor operators" } },
  { slug: "iec-62443", label: "IEC 62443", note: { en: "The engineering backbone for OT security", nl: "De engineering-ruggengraat voor OT-beveiliging" } },
  { slug: "ai-act", label: "AI Act", note: { en: "AI in safety-related and industrial contexts", nl: "AI in veiligheidsgerelateerde en industriële context" } },
  { slug: "machine-act", label: "Machinery Regulation", note: { en: "Cybersecurity inside the machine safety case", nl: "Cybersecurity binnen de machineveiligheidscase" } },
  { slug: "ts-50701", label: "TS 50701", note: { en: "IEC 62443 adapted to railway systems", nl: "IEC 62443 toegepast op spoorwegsystemen" } }
];

export function ArticleShell({
  kicker, title, dek, readingMin, updated, sources, toc, ctaLabel, ctaHref, slug, locale, children
}: {
  kicker: string; title: string; dek?: string | null;
  readingMin: number; updated?: string | null; sources: number;
  toc: Toc; ctaLabel: string; ctaHref: string; slug: string; locale: string; children: React.ReactNode;
}) {
  const related = RELATED.filter((r) => r.slug !== slug).slice(0, 5);
  const ids = React.useMemo(() => toc.map((t) => t.id), [toc]);
  const active = useScrollSpy(ids);
  const reduce = useReducedMotion();
  const nl = locale === "nl";
  const { scrollYProgress } = useScroll();
  const progress = useSpring(scrollYProgress, { stiffness: 120, damping: 30, mass: 0.3 });

  return (
    <div className="bg-background">
      {/* reading progress */}
      <motion.div
        aria-hidden
        style={{ scaleX: reduce ? undefined : progress }}
        className="fixed inset-x-0 top-0 z-50 h-[3px] origin-left bg-gradient-to-r from-primary to-primary/60"
      />
      {/* HERO */}
      <header className="relative overflow-hidden border-b border-border">
        <Aurora className="opacity-70" />
        <div className="relative mx-auto max-w-6xl px-6 pb-12 pt-16 lg:px-8">
          <motion.p initial={reduce ? false : { opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.5 }}
            className="text-xs font-semibold uppercase tracking-[0.2em] text-primary">{kicker}</motion.p>
          <motion.h1 initial={reduce ? false : { opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6, delay: 0.05 }}
            className="mt-4 max-w-4xl text-4xl font-bold leading-[1.08] tracking-tight sm:text-5xl" style={{ fontFamily: "var(--font-display)" }}>{title}</motion.h1>
          {dek && (
            <motion.p initial={reduce ? false : { opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6, delay: 0.12 }}
              className="mt-5 max-w-2xl text-lg leading-relaxed text-muted-foreground">{dek}</motion.p>
          )}
          <motion.div initial={reduce ? false : { opacity: 0 }} animate={{ opacity: 1 }} transition={{ duration: 0.6, delay: 0.2 }}
            className="mt-6 flex flex-wrap items-center gap-x-5 gap-y-2 text-sm text-muted-foreground">
            <span className="inline-flex items-center gap-1.5"><Clock className="h-4 w-4" /> {readingMin} {nl ? "min leestijd" : "min read"}</span>
            {updated && <span className="inline-flex items-center gap-1.5"><CalendarDays className="h-4 w-4" /> {nl ? "Bijgewerkt" : "Updated"} {updated}</span>}
            {sources > 0 && <span className="inline-flex items-center gap-1.5"><Link2 className="h-4 w-4" /> {sources} {nl ? "bronnen" : "cited sources"}</span>}
          </motion.div>
        </div>
      </header>

      {/* BODY */}
      <div className={cn("mx-auto max-w-6xl gap-10 px-6 py-12 lg:px-8",
        toc.length >= 2 ? "grid lg:grid-cols-[240px_minmax(0,1fr)]" : "block")}>
        {/* sticky TOC */}
        {toc.length >= 2 && (
          <aside className="hidden lg:block">
            <div className="sticky top-24">
              <p className="mb-3 flex items-center gap-2 text-xs font-semibold uppercase tracking-widest text-muted-foreground"><List className="h-3.5 w-3.5" /> {nl ? "Op deze pagina" : "On this page"}</p>
              <nav className="space-y-1 border-l border-border">
                {toc.map((t) => (
                  <a key={t.id} href={`#${t.id}`}
                    className={cn("-ml-px block border-l-2 py-1 pl-3 text-sm transition-colors",
                      active === t.id ? "border-primary font-medium text-primary" : "border-transparent text-muted-foreground hover:text-foreground")}>
                    {t.text}
                  </a>
                ))}
              </nav>
            </div>
          </aside>
        )}

        {/* article */}
        <article className="article-prose min-w-0 max-w-3xl">
          {children}

          {/* Related regulations — internal cross-links (navigation + SEO) */}
          {related.length > 0 && (
            <section className="mt-14">
              <p className="text-xs font-semibold uppercase tracking-[0.2em] text-primary">{locale === "nl" ? "Gerelateerde kaders" : "Related frameworks"}</p>
              <div className="mt-4 grid gap-3 sm:grid-cols-2">
                {related.map((r) => (
                  <Link key={r.slug} href={`/${locale}/${r.slug}`}
                    className="group flex items-start justify-between gap-3 rounded-xl border border-border p-4 transition-colors hover:border-primary hover:bg-accent">
                    <span>
                      <span className="block text-sm font-semibold group-hover:text-primary">{r.label}</span>
                      <span className="mt-0.5 block text-xs text-muted-foreground">{r.note[locale as "en" | "nl"] ?? r.note.en}</span>
                    </span>
                    <ArrowRight className="mt-0.5 h-4 w-4 shrink-0 text-muted-foreground transition-transform group-hover:translate-x-0.5 group-hover:text-primary" />
                  </Link>
                ))}
              </div>
            </section>
          )}

          <div className="mt-10 rounded-2xl border border-border bg-card p-8">
            <p className="text-xs font-semibold uppercase tracking-[0.2em] text-primary">OXOT</p>
            <h3 className="mt-2 text-2xl font-semibold tracking-tight" style={{ fontFamily: "var(--font-display)" }}>{nl ? "Praat met een expert over uw compliance" : `Talk to an expert about ${kicker.toLowerCase().includes("regulation") || kicker.toLowerCase().includes("directive") || kicker.toLowerCase().includes("standard") ? "this" : "your"} compliance`}</h3>
            <p className="mt-2 max-w-xl text-muted-foreground">{ctaLabel}</p>
            <Link href={ctaHref} className="mt-5 inline-flex items-center gap-2 rounded-lg bg-primary px-5 py-2.5 text-sm font-medium text-primary-foreground transition-colors hover:bg-primary/90">
              {nl ? "Praat met een OT-beveiligingsexpert" : "Talk to an OT security expert"} <ArrowRight className="h-4 w-4" />
            </Link>
          </div>
        </article>
      </div>
    </div>
  );
}
