"use client";
import Link from "next/link";
import { motion, useMotionValue, useMotionTemplate } from "motion/react";
import type { HomeServices as Services } from "@/lib/site-content";
import { Reveal, Marquee } from "@/components/motion/fx";

const FRAMEWORKS = [
  { label: "IEC 62443", href: "/iec-62443" },
  { label: "NIS2", href: "/nis2" },
  { label: "Cyber Resilience Act", href: "/cra" },
  { label: "AI Act", href: "/ai-act" },
  { label: "Machinery Regulation", href: "/machine-act" },
  { label: "TS 50701", href: "/ts-50701" }
];

function ServiceCell({ i, name, desc, href, more, locale }: {
  i: number; name: string; desc: string; href: string; more: string; locale: string;
}) {
  const mx = useMotionValue(-200);
  const my = useMotionValue(-200);
  const glow = useMotionTemplate`radial-gradient(230px circle at ${mx}px ${my}px, rgba(232,112,10,0.10), transparent 72%)`;
  return (
    <Link
      href={`/${locale}${href}`}
      className="ed-svc group relative"
      onMouseMove={(e) => { const r = e.currentTarget.getBoundingClientRect(); mx.set(e.clientX - r.left); my.set(e.clientY - r.top); }}
    >
      <motion.span aria-hidden className="pointer-events-none absolute inset-0 opacity-0 transition-opacity duration-300 group-hover:opacity-100" style={{ background: glow }} />
      <span className="relative">
        <span className="ed-svc-num"><b>{String(i + 1).padStart(2, "0")}</b><i /></span>
        <h3>{name}</h3>
        <p>{desc}</p>
        <span className="ed-svc-link">{more} <span className="arrow">→</span></span>
      </span>
    </Link>
  );
}

export function HomeServices({ services, locale }: { services: Services; locale: string }) {
  return (
    <section>
      <Reveal>
        <div className="ed-sec-head">
          <div>
            <p className="ed-eyebrow">{services.eyebrow}</p>
            <h2 className="ed-h2">{services.heading}</h2>
          </div>
          <p className="ed-sec-intro">{services.intro}</p>
        </div>
      </Reveal>

      {/* frameworks marquee */}
      <div className="border-b border-[rgba(22,29,43,0.1)] py-4">
        <Marquee duration={30}>
          {FRAMEWORKS.map((f) => (
            <Link key={f.label} href={`/${locale}${f.href}`}
              className="flex items-center gap-2 whitespace-nowrap font-[500] text-[13px] tracking-wide text-[rgba(22,29,43,0.55)] transition-colors hover:text-[#e8700a]">
              <span className="h-1.5 w-1.5 rounded-full bg-[#e8700a]" /> {f.label}
            </Link>
          ))}
        </Marquee>
      </div>

      <Reveal y={30}>
        <div className="ed-grid">
          {services.items.map((it, i) => (
            <ServiceCell key={it.name} i={i} name={it.name} desc={it.desc} href={it.href} more={services.more} locale={locale} />
          ))}
          <div className="ed-svc-cta">
            <h3>{services.cta.title}</h3>
            <p>{services.cta.body}</p>
            <Link href={`/${locale}/contact`}>{services.cta.button}</Link>
          </div>
        </div>
      </Reveal>
    </section>
  );
}
