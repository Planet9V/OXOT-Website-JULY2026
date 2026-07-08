"use client";
import * as React from "react";
import {
  motion, useInView, useMotionValue, useMotionTemplate, animate, useReducedMotion,
  useScroll, useTransform,
  type TargetAndTransition
} from "motion/react";
import { cn } from "@/lib/utils";

const EASE = [0.22, 1, 0.36, 1] as const;

/** Fade + rise into view once. */
export function Reveal({
  children, delay = 0, y = 26, className
}: { children: React.ReactNode; delay?: number; y?: number; className?: string }) {
  const ref = React.useRef<HTMLDivElement>(null);
  const inView = useInView(ref, { once: true, margin: "-70px" });
  const reduce = useReducedMotion();
  return (
    <motion.div
      ref={ref}
      initial={reduce ? false : { opacity: 0, y }}
      animate={inView ? { opacity: 1, y: 0 } : undefined}
      transition={{ duration: 0.65, delay, ease: EASE }}
      className={className}
    >
      {children}
    </motion.div>
  );
}

/** Stagger children as they enter. Use with <Stagger.Item>. */
export function Stagger({ children, className, gap = 0.08 }: { children: React.ReactNode; className?: string; gap?: number }) {
  const ref = React.useRef<HTMLDivElement>(null);
  const inView = useInView(ref, { once: true, margin: "-70px" });
  return (
    <motion.div ref={ref} initial="hide" animate={inView ? "show" : "hide"}
      variants={{ show: { transition: { staggerChildren: gap } } }} className={className}>
      {children}
    </motion.div>
  );
}
Stagger.Item = function Item({ children, className, y = 20 }: { children: React.ReactNode; className?: string; y?: number }) {
  return (
    <motion.div variants={{ hide: { opacity: 0, y }, show: { opacity: 1, y: 0, transition: { duration: 0.6, ease: EASE } } }} className={className}>
      {children}
    </motion.div>
  );
};

/** Count a number up when it scrolls into view. Preserves non-digit suffix/prefix. */
export function CountUp({ value, className }: { value: string; className?: string }) {
  const ref = React.useRef<HTMLSpanElement>(null);
  const inView = useInView(ref, { once: true, margin: "-40px" });
  const reduce = useReducedMotion();
  const digits = value.replace(/[^0-9]/g, "");
  const target = parseInt(digits || "0", 10);
  const [display, setDisplay] = React.useState(reduce ? value : value.replace(digits, "0"));

  React.useEffect(() => {
    if (!inView || reduce || !digits) { if (reduce) setDisplay(value); return; }
    const controls = animate(0, target, {
      duration: 1.4, ease: [0.16, 1, 0.3, 1],
      onUpdate: (v) => setDisplay(value.replace(digits, String(Math.round(v))))
    });
    return () => controls.stop();
  }, [inView, reduce, target, digits, value]);

  return <span ref={ref} className={className}>{display}</span>;
}

/** Drifting aurora blobs — subtle brand-coloured ambient background. */
export function Aurora({ className }: { className?: string }) {
  const reduce = useReducedMotion();
  const blob = (extra: string, anim: TargetAndTransition) => (
    <motion.div
      className={cn("absolute rounded-full blur-[110px]", extra)}
      animate={reduce ? undefined : anim}
      transition={{ duration: 20, repeat: Infinity, repeatType: "mirror", ease: "easeInOut" }}
    />
  );
  return (
    <div className={cn("pointer-events-none absolute inset-0 overflow-hidden", className)} aria-hidden>
      {blob("-top-40 left-[15%] h-[46vh] w-[46vh] bg-primary/20", { x: [0, 70, 0], y: [0, 40, 0] })}
      {blob("top-[10%] right-[8%] h-[40vh] w-[40vh] bg-sky-500/10", { x: [0, -60, 0], y: [0, 50, 0] })}
      {blob("bottom-[-10%] left-[30%] h-[42vh] w-[42vh] bg-primary/10", { x: [0, 40, 0], y: [0, -40, 0] })}
    </div>
  );
}

/** Subtle scroll-linked vertical parallax for a top-of-page hero visual.
 *  Driven off window scrollY (dev/prod consistent, no per-element measurement):
 *  the visual drifts up to `distance`px over the first `range`px of scroll.
 *  Restrained by design; disabled entirely for reduced-motion. */
export function Parallax({ children, distance = 18, range = 600, className }: { children: React.ReactNode; distance?: number; range?: number; className?: string }) {
  const reduce = useReducedMotion();
  const { scrollY } = useScroll();
  const y = useTransform(scrollY, [0, range], [0, -distance]);
  return (
    <motion.div style={reduce ? undefined : { y }} className={className}>
      {children}
    </motion.div>
  );
}

/** Infinite horizontal marquee. */
export function Marquee({ children, duration = 26, className }: { children: React.ReactNode; duration?: number; className?: string }) {
  const reduce = useReducedMotion();
  return (
    <div className={cn("relative overflow-hidden", className)}
      style={{ maskImage: "linear-gradient(90deg,transparent,#000 8%,#000 92%,transparent)", WebkitMaskImage: "linear-gradient(90deg,transparent,#000 8%,#000 92%,transparent)" }}>
      <motion.div className="flex w-max gap-10"
        animate={reduce ? undefined : { x: ["0%", "-50%"] }}
        transition={{ duration, repeat: Infinity, ease: "linear" }}>
        {children}{children}
      </motion.div>
    </div>
  );
}

/** Card wrapper with a cursor-following spotlight glow + lift on hover. */
export function SpotlightCard({ children, className }: { children: React.ReactNode; className?: string }) {
  const mx = useMotionValue(-200);
  const my = useMotionValue(-200);
  const bg = useMotionTemplate`radial-gradient(240px circle at ${mx}px ${my}px, hsl(var(--primary) / 0.10), transparent 72%)`;
  return (
    <motion.div
      onMouseMove={(e) => { const r = e.currentTarget.getBoundingClientRect(); mx.set(e.clientX - r.left); my.set(e.clientY - r.top); }}
      whileHover={{ y: -3 }}
      transition={{ type: "spring", stiffness: 300, damping: 24 }}
      className={cn("group relative", className)}
    >
      <motion.div className="pointer-events-none absolute inset-0 opacity-0 transition-opacity duration-300 group-hover:opacity-100" style={{ background: bg }} />
      {children}
    </motion.div>
  );
}
