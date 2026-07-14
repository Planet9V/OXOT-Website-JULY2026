"use client";
import Link from "next/link";
import { Reveal } from "@/components/motion/fx";

export interface CtaContent { title: string; body: string; button: string }

export function HomeCta({ cta, locale }: { cta: CtaContent; locale: string }) {
  return (
    <section className="ed-ctaband">
      <Reveal>
        <div className="ed-ctaband-inner">
          <div>
            <h2 className="ed-ctaband-title">{cta.title}</h2>
            <p className="ed-ctaband-body">{cta.body}</p>
          </div>
          <Link href={`/${locale}/contact`} className="ed-ctaband-btn">
            {cta.button}
          </Link>
        </div>
      </Reveal>
    </section>
  );
}
