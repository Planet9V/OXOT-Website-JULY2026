"use client";
import Link from "next/link";
import { Reveal, Marquee } from "@/components/motion/fx";
import type { HomeFrameworkLink } from "@/lib/site-content";

const FALLBACK: HomeFrameworkLink[] = [
  { label: "IEC 62443", href: "/iec-62443" },
  { label: "NIS2", href: "/nis2" },
  { label: "Cyber Resilience Act", href: "/cra" },
  { label: "AI Act", href: "/ai-act" },
  { label: "Machinery Regulation", href: "/machine-act" },
  { label: "TS 50701", href: "/ts-50701" }
];

export function HomeFrameworks({
  eyebrow,
  heading,
  frameworks,
  locale
}: {
  eyebrow: string;
  heading: string;
  frameworks?: HomeFrameworkLink[];
  locale: string;
}) {
  const items = frameworks?.length ? frameworks : FALLBACK;
  return (
    <section className="ed-fwb">
      <Reveal>
        <div className="ed-fwb-head">
          <p className="ed-eyebrow">{eyebrow}</p>
          <h2 className="ed-h2">{heading}</h2>
        </div>
      </Reveal>
      <div className="ed-fwb-rail">
        <Marquee duration={30}>
          {items.map((f) => (
            <Link key={f.label} href={`/${locale}${f.href}`} className="ed-fwb-chip">
              <span className="ed-fwb-dot" /> {f.label}
            </Link>
          ))}
        </Marquee>
      </div>
    </section>
  );
}
