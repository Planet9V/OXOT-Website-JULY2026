"use client";
import * as React from "react";
import Link from "next/link";
import { motion, useReducedMotion } from "motion/react";
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

export function ArticleShell({
  kicker, title, dek, readingMin, updated, sources, toc, ctaLabel, ctaHref, children
}: {
  kicker: string; title: string; dek?: string | null;
  readingMin: number; updated?: string | null; sources: number;
  toc: Toc; ctaLabel: string; ctaHref: string; children: React.ReactNode;
}) {
  const ids = React.useMemo(() => toc.map((t) => t.id), [toc]);
  const active = useScrollSpy(ids);
  const reduce = useReducedMotion();

  return (
    <div className="bg-background">
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
            <span className="inline-flex items-center gap-1.5"><Clock className="h-4 w-4" /> {readingMin} min read</span>
            {updated && <span className="inline-flex items-center gap-1.5"><CalendarDays className="h-4 w-4" /> Updated {updated}</span>}
            {sources > 0 && <span className="inline-flex items-center gap-1.5"><Link2 className="h-4 w-4" /> {sources} cited sources</span>}
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
              <p className="mb-3 flex items-center gap-2 text-xs font-semibold uppercase tracking-widest text-muted-foreground"><List className="h-3.5 w-3.5" /> On this page</p>
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

          <div className="mt-14 rounded-2xl border border-border bg-card p-8">
            <p className="text-xs font-semibold uppercase tracking-[0.2em] text-primary">OXOT</p>
            <h3 className="mt-2 text-2xl font-semibold tracking-tight" style={{ fontFamily: "var(--font-display)" }}>Talk to an expert about {kicker.toLowerCase().includes("regulation") || kicker.toLowerCase().includes("directive") || kicker.toLowerCase().includes("standard") ? "this" : "your"} compliance</h3>
            <p className="mt-2 max-w-xl text-muted-foreground">{ctaLabel}</p>
            <Link href={ctaHref} className="mt-5 inline-flex items-center gap-2 rounded-lg bg-primary px-5 py-2.5 text-sm font-medium text-primary-foreground transition-colors hover:bg-primary/90">
              Talk to an OT security expert <ArrowRight className="h-4 w-4" />
            </Link>
          </div>
        </article>
      </div>
    </div>
  );
}
