"use client";
import * as React from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { cn } from "@/lib/utils";
import { LocaleSwitcher } from "@/components/locale-switcher";

type Item = { label: string; href: string };

/**
 * Sticky, scroll-aware primary nav.
 * At rest: transparent, hairline border. Scrolled: blurred translucent surface
 * + e1 elevation + condensed padding. Links use a growing underline; the active
 * route holds it. All transitions ride the shared motion tokens (ease-brand / dur-2)
 * and are neutralised by the global prefers-reduced-motion guard.
 */
export function SiteNavClient({ locale, items }: { locale: string; items: Item[] }) {
  const [scrolled, setScrolled] = React.useState(false);
  const pathname = usePathname() || `/${locale}`;
  const home = `/${locale}`;

  React.useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 8);
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  const isActive = (href: string) =>
    pathname === href || (href !== home && pathname.startsWith(href + "/")) || (href !== home && pathname.startsWith(href));

  return (
    <nav
      className={cn(
        "sticky top-0 z-50 flex items-center justify-between gap-4 px-6 text-sm ease-brand",
        "transition-[background-color,box-shadow,border-color,padding] duration-[250ms]",
        "border-b",
        scrolled
          ? "border-border bg-background/80 py-2 shadow-e1 backdrop-blur-md supports-[backdrop-filter]:bg-background/70"
          : "border-transparent bg-background py-3"
      )}
    >
      <div className="flex flex-wrap items-center gap-x-5 gap-y-1">
        {/* OXOT wordmark — links home. Orange X echoes "eXcellence". */}
        <Link
          href={home}
          aria-label="OXOT — home"
          className="mr-1 select-none text-[15px] font-semibold tracking-[0.28em] text-foreground no-underline transition-opacity duration-150 ease-brand hover:opacity-80"
        >
          O<span className="text-primary">X</span>OT
        </Link>
        {items.map((it, i) => {
          const active = isActive(it.href);
          return (
            <Link
              key={i}
              href={it.href}
              aria-current={active ? "page" : undefined}
              className={cn(
                "relative py-1 no-underline transition-colors duration-150 ease-brand",
                "after:absolute after:inset-x-0 after:-bottom-0.5 after:h-px after:origin-left after:bg-primary",
                "after:transition-transform after:duration-200 after:ease-brand",
                active
                  ? "text-foreground after:scale-x-100"
                  : "text-foreground/70 hover:text-foreground after:scale-x-0 hover:after:scale-x-100"
              )}
            >
              {it.label}
            </Link>
          );
        })}
      </div>
      <LocaleSwitcher locale={locale} />
    </nav>
  );
}
