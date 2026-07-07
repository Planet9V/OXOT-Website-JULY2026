"use client";
import * as React from "react";
import Link from "next/link";
import { motion, useInView, useReducedMotion, animate as motionAnimate } from "motion/react";
import { ArrowUpDown, ArrowUp, ArrowDown, ArrowRight } from "lucide-react";
import { parseInline, plainText } from "./inline";
import { SpotlightCard } from "@/components/motion/fx";
import { cn } from "@/lib/utils";

const EASE = [0.22, 1, 0.36, 1] as const;

/* ─────────────────────────── Reveal wrapper ───────────────────────────
   Fades + rises a *feature* block into view once. We only ever wrap tables,
   diagrams, callouts, timelines, compare + keyfacts — never body prose — so
   all paragraph text stays SSR-visible and the drop-cap / numbered-H2 CSS
   selectors (which target direct children of .article-prose) keep working. */
export function RevealBlock({ children, className, y = 22 }: { children: React.ReactNode; className?: string; y?: number }) {
  const ref = React.useRef<HTMLDivElement>(null);
  const inView = useInView(ref, { once: true, margin: "-60px" });
  const reduce = useReducedMotion();
  return (
    <motion.div
      ref={ref}
      initial={reduce ? false : { opacity: 0, y }}
      animate={inView ? { opacity: 1, y: 0 } : undefined}
      transition={{ duration: 0.6, ease: EASE }}
      className={className}
    >
      {children}
    </motion.div>
  );
}

/* ───────────────────── Leading-integer count-up ─────────────────────
   Animates the leading whole-number of a stat value (e.g. "€35 mln", "24 h",
   "2 December 2027") from 0 on scroll-in. Decimals (1,4% / 2.5) and word-first
   values (Article 15, Regulation (EU) …) render static — safe across locales. */
function StatValue({ value }: { value: string }) {
  const ref = React.useRef<HTMLSpanElement>(null);
  const inView = useInView(ref, { once: true, margin: "-40px" });
  const reduce = useReducedMotion();
  const m = /^(\s*[€$£±≈~]?\s*)(\d+)([\s\S]*)$/.exec(value);
  const isDecimal = !!m && /^[.,]\d/.test(m[3]);
  const animatable = !!m && !isDecimal;
  const target = animatable ? parseInt(m![2], 10) : 0;
  const [display, setDisplay] = React.useState<number>(animatable && !reduce ? 0 : target);

  React.useEffect(() => {
    if (!animatable || reduce || !inView) return;
    const controls = motionAnimate(0, target, {
      duration: 1.2, ease: [0.16, 1, 0.3, 1],
      onUpdate: (v) => setDisplay(Math.round(v)),
    });
    return () => controls.stop();
  }, [animatable, reduce, inView, target]);

  if (!animatable) return <span ref={ref}>{parseInline(value, "sv")}</span>;
  return (
    <span ref={ref}>
      {m![1]}
      <span className="tabular-nums">{display}</span>
      {parseInline(m![3], "sv")}
    </span>
  );
}

/* ─────────────────────────── keyfacts ─────────────────────────── */
export function KeyFacts({ facts, label }: { facts: { k: string; v: string }[]; label: string }) {
  const ref = React.useRef<HTMLDivElement>(null);
  const inView = useInView(ref, { once: true, margin: "-60px" });
  const reduce = useReducedMotion();
  return (
    <div ref={ref} className="my-8 rounded-2xl border border-primary/25 bg-primary/5 p-5">
      <div className="mb-4 text-xs font-semibold uppercase tracking-[0.2em] text-primary">{label}</div>
      <motion.dl
        className="grid gap-x-6 gap-y-4 sm:grid-cols-2 lg:grid-cols-3"
        initial="hide"
        animate={inView ? "show" : "hide"}
        variants={{ show: { transition: { staggerChildren: 0.06 } } }}
      >
        {facts.map((f, i) => (
          <motion.div
            key={i}
            variants={reduce ? undefined : { hide: { opacity: 0, y: 12 }, show: { opacity: 1, y: 0, transition: { duration: 0.5, ease: EASE } } }}
            className="rounded-xl border border-primary/15 bg-card p-3 transition-colors hover:border-primary/40"
          >
            <dt className="text-[11px] font-medium uppercase tracking-wide text-muted-foreground">{f.k}</dt>
            <dd className="mt-1 text-base font-semibold text-foreground">
              <StatValue value={f.v} />
            </dd>
          </motion.div>
        ))}
      </motion.dl>
    </div>
  );
}

/* ─────────────────────────── timeline ─────────────────────────── */
export function TimelineBlock({ items }: { items: { d: string; e: string }[] }) {
  const ref = React.useRef<HTMLOListElement>(null);
  const inView = useInView(ref, { once: true, margin: "-60px" });
  const reduce = useReducedMotion();
  return (
    <ol ref={ref} className="relative my-8 space-y-0 pl-6">
      {/* animated spine */}
      <motion.span
        aria-hidden
        className="absolute left-0 top-1 w-px bg-border"
        initial={reduce ? { height: "100%" } : { height: 0 }}
        animate={inView ? { height: "100%" } : undefined}
        transition={{ duration: 0.9, ease: EASE }}
      />
      {items.map((it, i) => (
        <motion.li
          key={i}
          className="relative pb-6 last:pb-0"
          initial={reduce ? false : { opacity: 0, x: -8 }}
          animate={inView ? { opacity: 1, x: 0 } : undefined}
          transition={{ duration: 0.45, delay: reduce ? 0 : 0.15 + i * 0.12, ease: EASE }}
        >
          <span className="absolute -left-[27px] top-1 h-3 w-3 rounded-full border-2 border-primary bg-background" />
          <div className="font-mono text-xs font-semibold uppercase tracking-wide text-primary">{it.d}</div>
          <div className="mt-1 text-sm text-muted-foreground">{parseInline(it.e, `tl-${i}`)}</div>
        </motion.li>
      ))}
    </ol>
  );
}

/* ─────────────────────────── compare ───────────────────────────
   Desktop: side-by-side cards (comparison stays visible) with reveal +
   hover-focus (the other column dims). Mobile: a segmented toggle so a
   tall stack becomes a flip — this is where a Tabs pattern genuinely helps. */
export function CompareBlock({ cols }: { cols: { title: string; rows: string[] }[] }) {
  const ref = React.useRef<HTMLDivElement>(null);
  const inView = useInView(ref, { once: true, margin: "-60px" });
  const reduce = useReducedMotion();
  const [hovered, setHovered] = React.useState<number | null>(null);
  const [active, setActive] = React.useState(0);

  const Card = ({ c, i, dim }: { c: { title: string; rows: string[] }; i: number; dim: boolean }) => (
    <motion.div
      onMouseEnter={() => setHovered(i)}
      onMouseLeave={() => setHovered(null)}
      initial={reduce ? false : { opacity: 0, y: 16 }}
      animate={inView ? { opacity: dim ? 0.55 : 1, y: 0 } : undefined}
      transition={{ duration: 0.5, delay: reduce ? 0 : i * 0.08, ease: EASE }}
      whileHover={reduce ? undefined : { y: -3 }}
      className="rounded-2xl border border-border bg-card p-5 transition-colors hover:border-primary/50"
    >
      <div className="mb-3 border-b border-border pb-2 font-semibold text-foreground" style={{ fontFamily: "var(--font-display)" }}>{c.title}</div>
      <ul className="space-y-2">
        {c.rows.map((r, ri) => (
          <li key={ri} className="flex gap-2 text-sm text-muted-foreground">
            <span className="mt-1.5 h-1.5 w-1.5 shrink-0 rounded-full bg-primary" />
            <span>{parseInline(r, `cmp-${i}-${ri}`)}</span>
          </li>
        ))}
      </ul>
    </motion.div>
  );

  return (
    <div ref={ref} className="my-8">
      {/* mobile segmented toggle */}
      {cols.length === 2 && (
        <div className="mb-3 grid grid-cols-2 gap-1 rounded-lg border border-border bg-muted/40 p-1 sm:hidden">
          {cols.map((c, i) => (
            <button
              key={i}
              onClick={() => setActive(i)}
              className={cn("rounded-md px-3 py-1.5 text-xs font-medium transition-colors",
                active === i ? "bg-primary text-primary-foreground" : "text-muted-foreground")}
            >
              {c.title}
            </button>
          ))}
        </div>
      )}
      {/* mobile: single active card */}
      <div className="sm:hidden">
        <Card c={cols[active] ?? cols[0]} i={active} dim={false} />
      </div>
      {/* desktop: side-by-side with hover-focus + optional center VS */}
      <div className="hidden gap-4 sm:grid sm:grid-cols-2">
        {cols.map((c, i) => (
          <Card key={i} c={c} i={i} dim={hovered !== null && hovered !== i} />
        ))}
      </div>
    </div>
  );
}

/* ─────────────────────────── data table ───────────────────────────
   Dependency-free (matches the renderer's no-lib ethos). Zebra + row hover
   everywhere; numeric-aware click-to-sort headers when the table is large
   enough (>= 5 rows) that sorting is useful. */
function numify(s: string): number | null {
  const m = s.match(/-?\d[\d.,  ]*\d|-?\d/);
  if (!m) return null;
  let t = m[0].replace(/[\s ]/g, "");
  const lc = t.lastIndexOf(","), ld = t.lastIndexOf(".");
  if (lc > -1 && ld > -1) t = lc > ld ? t.replace(/\./g, "").replace(",", ".") : t.replace(/,/g, "");
  else if (lc > -1) t = t.length - lc - 1 <= 2 ? t.replace(",", ".") : t.replace(/,/g, "");
  const n = parseFloat(t);
  return isNaN(n) ? null : n;
}

export function DataTable({ header, rows }: { header: string[]; rows: string[][] }) {
  const sortable = rows.length >= 5;
  const colIsNumeric = React.useMemo(
    () => header.map((_, c) => {
      const vals = rows.map((r) => plainText(r[c] ?? "")).filter(Boolean);
      if (!vals.length) return false;
      return vals.filter((v) => numify(v) !== null).length >= Math.ceil(vals.length * 0.6);
    }),
    [header, rows]
  );
  const [sort, setSort] = React.useState<{ col: number; dir: 1 | -1 } | null>(null);

  const sorted = React.useMemo(() => {
    if (!sort) return rows;
    const { col, dir } = sort;
    const numeric = colIsNumeric[col];
    return [...rows].sort((a, b) => {
      const av = plainText(a[col] ?? ""), bv = plainText(b[col] ?? "");
      if (numeric) {
        const an = numify(av), bn = numify(bv);
        if (an === null && bn === null) return 0;
        if (an === null) return 1;
        if (bn === null) return -1;
        return (an - bn) * dir;
      }
      return av.localeCompare(bv, undefined, { numeric: true }) * dir;
    });
  }, [rows, sort, colIsNumeric]);

  const toggle = (col: number) =>
    setSort((s) => (s && s.col === col ? { col, dir: s.dir === 1 ? -1 : 1 } : { col, dir: 1 }));

  return (
    <div className="my-6 overflow-x-auto rounded-lg border border-border">
      <table className="w-full text-sm">
        <thead className="bg-muted/60">
          <tr>
            {header.map((h, c) => (
              <th key={c} className="px-4 py-2.5 text-left font-semibold text-foreground">
                {sortable ? (
                  <button
                    onClick={() => toggle(c)}
                    className="group inline-flex items-center gap-1.5 transition-colors hover:text-primary"
                    aria-label={`Sort by ${plainText(h)}`}
                  >
                    {parseInline(h, `th-${c}`)}
                    {sort?.col === c ? (
                      sort.dir === 1 ? <ArrowUp className="h-3.5 w-3.5 text-primary" /> : <ArrowDown className="h-3.5 w-3.5 text-primary" />
                    ) : (
                      <ArrowUpDown className="h-3.5 w-3.5 text-muted-foreground/50 group-hover:text-primary" />
                    )}
                  </button>
                ) : (
                  parseInline(h, `th-${c}`)
                )}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {sorted.map((r, ri) => (
            <tr key={ri} className={cn("border-t border-border transition-colors hover:bg-accent/60", ri % 2 === 1 && "bg-muted/20")}>
              {r.map((cell, ci) => (
                <td key={ci} className={cn("px-4 py-2.5 align-top text-muted-foreground", colIsNumeric[ci] && "tabular-nums")}>
                  {parseInline(cell, `td-${ri}-${ci}`)}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

/* ─────────────────────────── mid-page CTA ─────────────────────────── */
export function CtaCard({ heading, body, label, href }: { heading: string; body: string; label: string; href: string }) {
  return (
    <RevealBlock className="my-10">
      <div className="group relative overflow-hidden rounded-2xl border border-primary/30 bg-gradient-to-br from-primary/10 via-primary/5 to-transparent p-6 sm:p-7">
        <div className="pointer-events-none absolute -right-16 -top-16 h-40 w-40 rounded-full bg-primary/10 blur-3xl transition-opacity duration-500 group-hover:opacity-80" />
        <p className="text-xs font-semibold uppercase tracking-[0.2em] text-primary">OXOT</p>
        <h3 className="mt-2 text-xl font-semibold tracking-tight text-foreground" style={{ fontFamily: "var(--font-display)" }}>{heading}</h3>
        <p className="mt-2 max-w-xl text-sm text-muted-foreground">{body}</p>
        <Link href={href} className="mt-4 inline-flex items-center gap-2 rounded-lg bg-primary px-4 py-2 text-sm font-medium text-primary-foreground transition-all hover:bg-primary/90 hover:gap-3">
          {label} <ArrowRight className="h-4 w-4" />
        </Link>
      </div>
    </RevealBlock>
  );
}

/* ─────────────────────────── cards grid ───────────────────────────
   ```cards
   Title :: /en/href :: Short description
   ...
   ```
   Renders a responsive grid of spotlight link tiles. Used by Services,
   Frameworks, About and the Cyber Digital Twin page. */
export function CardGrid({ items }: { items: { title: string; href: string; desc: string }[] }) {
  const ref = React.useRef<HTMLDivElement>(null);
  const inView = useInView(ref, { once: true, margin: "-60px" });
  const reduce = useReducedMotion();
  const external = (h: string) => /^https?:\/\//.test(h);
  return (
    <motion.div
      ref={ref}
      className="my-8 grid gap-4 sm:grid-cols-2"
      initial="hide"
      animate={inView ? "show" : "hide"}
      variants={{ show: { transition: { staggerChildren: 0.06 } } }}
    >
      {items.map((it, i) => {
        const linked = !!it.href;
        const body = (
          <>
            <div className="flex items-start justify-between gap-3">
              <span className="font-semibold text-foreground" style={{ fontFamily: "var(--font-display)" }}>{parseInline(it.title, `cardt-${i}`)}</span>
              {linked && <ArrowRight className="mt-0.5 h-4 w-4 shrink-0 text-muted-foreground transition-transform group-hover:translate-x-0.5 group-hover:text-primary" />}
            </div>
            {it.desc && <p className="mt-2 text-sm text-muted-foreground">{parseInline(it.desc, `cardd-${i}`)}</p>}
          </>
        );
        return (
          <motion.div
            key={i}
            variants={reduce ? undefined : { hide: { opacity: 0, y: 14 }, show: { opacity: 1, y: 0, transition: { duration: 0.5, ease: EASE } } }}
          >
            {linked ? (
              <Link href={it.href} target={external(it.href) ? "_blank" : undefined} rel={external(it.href) ? "noopener noreferrer" : undefined} className="block h-full no-underline">
                <SpotlightCard className="h-full rounded-2xl border border-border bg-card p-5 transition-colors hover:border-primary/50">{body}</SpotlightCard>
              </Link>
            ) : (
              // non-linked info card: no arrow, no hover-lift/glow (not misleadingly clickable)
              <div className="h-full rounded-2xl border border-border bg-card p-5">{body}</div>
            )}
          </motion.div>
        );
      })}
    </motion.div>
  );
}

/* ─────────────────── interactive framework selector ───────────────────
   The Frameworks-hub centerpiece: pick your role → see exactly which EU
   frameworks apply and why, each linking to its detailed (upgraded) page. */
const FW: Record<string, { name: string; tag: Record<"en" | "nl", string> }> = {
  nis2: { name: "NIS2", tag: { en: "Directive (EU) 2022/2555", nl: "Richtlijn (EU) 2022/2555" } },
  cra: { name: "Cyber Resilience Act", tag: { en: "Regulation (EU) 2024/2847", nl: "Verordening (EU) 2024/2847" } },
  "ai-act": { name: "AI Act", tag: { en: "Regulation (EU) 2024/1689", nl: "Verordening (EU) 2024/1689" } },
  "machine-act": { name: "Machinery Regulation", tag: { en: "Regulation (EU) 2023/1230", nl: "Verordening (EU) 2023/1230" } },
  "iec-62443": { name: "IEC 62443", tag: { en: "International standard", nl: "Internationale norm" } },
  "ts-50701": { name: "TS 50701", tag: { en: "CENELEC Technical Specification", nl: "CENELEC technische specificatie" } },
};

type RoleDef = { id: string; label: Record<"en" | "nl", string>; apply: { slug: string; why: Record<"en" | "nl", string> }[] };
const ROLES: RoleDef[] = [
  { id: "operator", label: { en: "I operate an essential / important service", nl: "Ik exploiteer een essentiële/belangrijke dienst" }, apply: [
    { slug: "nis2", why: { en: "Your primary obligation — ten risk-management measures and 24/72-hour reporting.", nl: "Uw primaire verplichting — tien risicobeheersmaatregelen en 24/72-uursmelding." } },
    { slug: "iec-62443", why: { en: "The engineering method to meet NIS2 and prove it.", nl: "De technische methode om aan NIS2 te voldoen en het aan te tonen." } },
  ] },
  { id: "manufacturer", label: { en: "I make products with digital elements", nl: "Ik maak producten met digitale elementen" }, apply: [
    { slug: "cra", why: { en: "Security-by-design, SBOM and 24-hour vulnerability reporting.", nl: "Security-by-design, SBOM en 24-uurs kwetsbaarheidsmelding." } },
    { slug: "iec-62443", why: { en: "Secure development (4-1) and component security (4-2).", nl: "Veilige ontwikkeling (4-1) en componentbeveiliging (4-2)." } },
  ] },
  { id: "machine", label: { en: "I build or integrate machinery", nl: "Ik bouw of integreer machines" }, apply: [
    { slug: "machine-act", why: { en: "Protection against corruption becomes part of the safety case.", nl: "Bescherming tegen corruptie wordt onderdeel van het veiligheidsdossier." } },
    { slug: "ai-act", why: { en: "An AI safety component in machinery is automatically high-risk.", nl: "Een AI-veiligheidscomponent in een machine is automatisch hoogrisico." } },
    { slug: "cra", why: { en: "The digital components are products with digital elements too.", nl: "De digitale componenten zijn óók producten met digitale elementen." } },
    { slug: "iec-62443", why: { en: "The method threading through all of them.", nl: "De methode die door alle regimes heen loopt." } },
  ] },
  { id: "ai", label: { en: "I deploy AI in a safety / high-risk role", nl: "Ik zet AI in voor een veiligheids-/hoogrisicorol" }, apply: [
    { slug: "ai-act", why: { en: "Classification, human oversight and Article 15 robustness.", nl: "Classificatie, menselijk toezicht en robuustheid onder Artikel 15." } },
    { slug: "iec-62443", why: { en: "Article 15 robustness maps to control-system security.", nl: "Robuustheid onder Artikel 15 sluit aan op besturingsbeveiliging." } },
  ] },
  { id: "rail", label: { en: "I operate or supply railways", nl: "Ik exploiteer of lever voor spoorwegen" }, apply: [
    { slug: "ts-50701", why: { en: "The rail-specific cybersecurity method, tied to the safety lifecycle.", nl: "De spoorspecifieke cybersecuritymethode, gekoppeld aan de veiligheidslevenscyclus." } },
    { slug: "nis2", why: { en: "Rail transport is an essential-entity sector.", nl: "Spoorvervoer is een sector van essentiële entiteiten." } },
    { slug: "iec-62443", why: { en: "The foundation TS 50701 extends.", nl: "Het fundament dat TS 50701 uitbreidt." } },
  ] },
];

export function FrameworkSelector({ locale = "en" }: { locale?: string }) {
  const l = (locale === "nl" ? "nl" : "en") as "en" | "nl";
  const [role, setRole] = React.useState(ROLES[0].id);
  const reduce = useReducedMotion();
  const current = ROLES.find((r) => r.id === role) ?? ROLES[0];
  return (
    <div className="my-8 rounded-2xl border border-border bg-muted/20 p-5 sm:p-6">
      <div className="mb-4 text-xs font-semibold uppercase tracking-[0.2em] text-primary">
        {l === "nl" ? "Welke kaders gelden voor mij?" : "Which frameworks apply to me?"}
      </div>
      <div className="flex flex-wrap gap-2">
        {ROLES.map((r) => (
          <button
            key={r.id}
            onClick={() => setRole(r.id)}
            className={cn("rounded-full border px-3.5 py-1.5 text-sm transition-colors",
              role === r.id ? "border-primary bg-primary text-primary-foreground" : "border-border text-muted-foreground hover:border-primary/50 hover:text-foreground")}
          >
            {r.label[l]}
          </button>
        ))}
      </div>
      <motion.div key={role} className="mt-5 grid gap-3 sm:grid-cols-2"
        initial="hide" animate="show" variants={{ show: { transition: { staggerChildren: 0.07 } } }}>
        {current.apply.map((a, i) => {
          const fw = FW[a.slug];
          return (
            <motion.div key={a.slug + i}
              variants={reduce ? undefined : { hide: { opacity: 0, y: 12 }, show: { opacity: 1, y: 0, transition: { duration: 0.45, ease: EASE } } }}>
              <Link href={`/${locale}/${a.slug}`} className="group block h-full rounded-xl border border-border bg-card p-4 no-underline transition-colors hover:border-primary/60">
                <div className="flex items-center justify-between gap-2">
                  <span className="font-semibold text-foreground group-hover:text-primary" style={{ fontFamily: "var(--font-display)" }}>{fw?.name ?? a.slug}</span>
                  <ArrowRight className="h-4 w-4 shrink-0 text-muted-foreground transition-transform group-hover:translate-x-0.5 group-hover:text-primary" />
                </div>
                <div className="mt-0.5 text-[11px] font-medium uppercase tracking-wide text-muted-foreground">{fw?.tag[l]}</div>
                <p className="mt-2 text-sm text-muted-foreground">{a.why[l]}</p>
              </Link>
            </motion.div>
          );
        })}
      </motion.div>
      <p className="mt-4 text-xs text-muted-foreground">
        {l === "nl"
          ? "Eén connected, AI-ondersteunde installatie kan meerdere regimes tegelijk raken — wij behandelen ze als één risicogebaseerd programma."
          : "One connected, AI-enabled line can trigger several regimes at once — we handle them as a single risk-based programme."}
      </p>
    </div>
  );
}

/* Named client widgets, addressed from markdown via ```widget\n<name>\n``` */
export function Widget({ name, locale }: { name: string; locale?: string }) {
  if (name === "framework-selector") return <FrameworkSelector locale={locale} />;
  return null;
}
