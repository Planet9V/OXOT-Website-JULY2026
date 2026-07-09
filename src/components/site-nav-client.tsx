"use client";
import * as React from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { motion, AnimatePresence, useReducedMotion } from "motion/react";
import { ChevronDown, Menu as MenuIcon, X, ArrowRight } from "lucide-react";
import { cn } from "@/lib/utils";
import { LocaleSwitcher } from "@/components/locale-switcher";
import type { MenuNode } from "@/lib/content";

const EASE = [0.22, 1, 0.36, 1] as const;

/**
 * Sticky mega-menu nav. Top-level items with children open an animated dropdown
 * panel (label + description per child); leaf items are plain links with a growing
 * underline + active state. Fully tokenized (dark/light), keyboard-accessible, and
 * collapses to a mobile accordion. Motion is disabled under reduced-motion.
 */
export function SiteNavClient({ locale, items }: { locale: string; items: MenuNode[] }) {
  const [scrolled, setScrolled] = React.useState(false);
  const [openId, setOpenId] = React.useState<number | null>(null);
  const [mobileOpen, setMobileOpen] = React.useState(false);
  const [mobileAcc, setMobileAcc] = React.useState<number | null>(null);
  const pathname = usePathname() || `/${locale}`;
  const home = `/${locale}`;
  const reduce = useReducedMotion();
  const closeTimer = React.useRef<number | null>(null);

  React.useEffect(() => {
    const f = () => setScrolled(window.scrollY > 8);
    f();
    window.addEventListener("scroll", f, { passive: true });
    return () => window.removeEventListener("scroll", f);
  }, []);

  React.useEffect(() => {
    const f = (e: KeyboardEvent) => { if (e.key === "Escape") { setOpenId(null); setMobileOpen(false); } };
    window.addEventListener("keydown", f);
    return () => window.removeEventListener("keydown", f);
  }, []);

  React.useEffect(() => {
    document.body.style.overflow = mobileOpen ? "hidden" : "";
    return () => { document.body.style.overflow = ""; };
  }, [mobileOpen]);

  // close menus on route change
  React.useEffect(() => { setOpenId(null); setMobileOpen(false); }, [pathname]);

  const isActive = (href: string) => pathname === href || (href !== home && pathname.startsWith(href));
  const nodeActive = (n: MenuNode) => isActive(n.href) || n.children.some((c) => isActive(c.href));

  const open = (id: number) => { if (closeTimer.current) clearTimeout(closeTimer.current); setOpenId(id); };
  const scheduleClose = () => { if (closeTimer.current) clearTimeout(closeTimer.current); closeTimer.current = window.setTimeout(() => setOpenId(null), 130); };

  const Brand = (
    <Link href={home} aria-label="OXOT — home"
      className="mr-1 select-none text-[15px] font-semibold tracking-[0.28em] text-foreground no-underline transition-opacity duration-150 ease-brand hover:opacity-80">
      O<span className="text-primary">X</span>OT
    </Link>
  );

  return (
    <nav
      className={cn(
        "sticky top-0 z-50 ease-brand transition-[background-color,box-shadow,border-color,padding] duration-[250ms] border-b",
        scrolled
          ? "border-border bg-background/80 py-2 shadow-e1 backdrop-blur-md supports-[backdrop-filter]:bg-background/70"
          : "border-transparent bg-background py-3"
      )}
    >
      <div className="flex items-center justify-between gap-4 px-6 text-sm">
        {/* Desktop */}
        <ul className="hidden items-center gap-x-1 md:flex">
          <li className="mr-3">{Brand}</li>
          {items.map((n) => {
            const active = nodeActive(n);
            if (!n.children.length) {
              return (
                <li key={n.id}>
                  <Link href={n.href} aria-current={isActive(n.href) ? "page" : undefined}
                    className={cn(
                      "relative rounded-md px-3 py-1.5 no-underline transition-colors duration-150 ease-brand",
                      "after:absolute after:inset-x-3 after:-bottom-0.5 after:h-px after:origin-left after:bg-primary after:transition-transform after:duration-200 after:ease-brand",
                      active ? "text-foreground after:scale-x-100" : "text-foreground/70 hover:text-foreground after:scale-x-0 hover:after:scale-x-100"
                    )}>
                    {n.label}
                  </Link>
                </li>
              );
            }
            const isOpen = openId === n.id;
            return (
              <li key={n.id} className="relative" onMouseEnter={() => open(n.id)} onMouseLeave={scheduleClose}>
                <button
                  onClick={() => setOpenId(isOpen ? null : n.id)}
                  aria-expanded={isOpen}
                  aria-haspopup="true"
                  className={cn(
                    "inline-flex items-center gap-1 rounded-md px-3 py-1.5 transition-colors duration-150 ease-brand",
                    active || isOpen ? "text-foreground" : "text-foreground/70 hover:text-foreground"
                  )}>
                  {n.label}
                  <ChevronDown className={cn("h-3.5 w-3.5 transition-transform duration-200 ease-brand", isOpen && "rotate-180")} />
                </button>
                <AnimatePresence>
                  {isOpen && (
                    <motion.div
                      initial={reduce ? false : { opacity: 0, y: 8 }}
                      animate={{ opacity: 1, y: 0 }}
                      exit={reduce ? undefined : { opacity: 0, y: 8 }}
                      transition={{ duration: 0.2, ease: EASE }}
                      onMouseEnter={() => open(n.id)}
                      onMouseLeave={scheduleClose}
                      className="absolute left-0 top-full z-50 pt-2"
                    >
                      <div className="w-[min(92vw,32rem)] overflow-hidden rounded-2xl border border-border bg-popover p-2 shadow-e3">
                        <ul className="grid gap-1 sm:grid-cols-2">
                          {n.children.map((c) => (
                            <li key={c.id}>
                              <Link href={c.href} onClick={() => setOpenId(null)}
                                className="group block rounded-xl p-3 no-underline transition-colors duration-150 ease-brand hover:bg-accent">
                                <span className="flex items-center gap-1.5 text-sm font-semibold text-foreground">
                                  {c.label}
                                  <ArrowRight className="h-3.5 w-3.5 -translate-x-1 opacity-0 transition-all duration-200 ease-brand group-hover:translate-x-0 group-hover:opacity-100 group-hover:text-primary" />
                                </span>
                                {c.description && <span className="mt-0.5 block text-xs leading-relaxed text-muted-foreground">{c.description}</span>}
                              </Link>
                            </li>
                          ))}
                        </ul>
                      </div>
                    </motion.div>
                  )}
                </AnimatePresence>
              </li>
            );
          })}
        </ul>

        {/* Mobile: brand + hamburger */}
        <div className="flex w-full items-center justify-between md:hidden">
          {Brand}
          <button onClick={() => setMobileOpen((v) => !v)} aria-label="Menu" aria-expanded={mobileOpen}
            className="grid h-9 w-9 place-items-center rounded-md text-foreground transition-colors hover:bg-accent">
            {mobileOpen ? <X className="h-5 w-5" /> : <MenuIcon className="h-5 w-5" />}
          </button>
        </div>

        <div className="hidden md:block"><LocaleSwitcher locale={locale} /></div>
      </div>

      {/* Mobile accordion panel */}
      <AnimatePresence>
        {mobileOpen && (
          <motion.div
            initial={reduce ? false : { opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: "auto" }}
            exit={reduce ? undefined : { opacity: 0, height: 0 }}
            transition={{ duration: 0.25, ease: EASE }}
            className="overflow-hidden border-t border-border bg-background md:hidden"
          >
            <ul className="space-y-1 px-4 py-3">
              {items.map((n) => (
                <li key={n.id}>
                  {!n.children.length ? (
                    <Link href={n.href} className="block rounded-md px-3 py-2 text-sm text-foreground/80 no-underline hover:bg-accent">{n.label}</Link>
                  ) : (
                    <>
                      <button onClick={() => setMobileAcc(mobileAcc === n.id ? null : n.id)}
                        className="flex w-full items-center justify-between rounded-md px-3 py-2 text-sm text-foreground/80 hover:bg-accent" aria-expanded={mobileAcc === n.id}>
                        {n.label}
                        <ChevronDown className={cn("h-4 w-4 transition-transform duration-200 ease-brand", mobileAcc === n.id && "rotate-180")} />
                      </button>
                      <AnimatePresence>
                        {mobileAcc === n.id && (
                          <motion.ul
                            initial={reduce ? false : { opacity: 0, height: 0 }}
                            animate={{ opacity: 1, height: "auto" }}
                            exit={reduce ? undefined : { opacity: 0, height: 0 }}
                            transition={{ duration: 0.2, ease: EASE }}
                            className="overflow-hidden pl-3"
                          >
                            {n.children.map((c) => (
                              <li key={c.id}>
                                <Link href={c.href} className="block rounded-md px-3 py-2 text-sm text-muted-foreground no-underline hover:bg-accent hover:text-foreground">
                                  {c.label}
                                </Link>
                              </li>
                            ))}
                          </motion.ul>
                        )}
                      </AnimatePresence>
                    </>
                  )}
                </li>
              ))}
              <li className="px-3 pt-2"><LocaleSwitcher locale={locale} /></li>
            </ul>
          </motion.div>
        )}
      </AnimatePresence>
    </nav>
  );
}
