"use client";

import * as React from "react";
import Link from "next/link";
import type { Locale } from "@/i18n/config";
import { Button } from "@/components/ui/button";

const COOKIE_NAME = "oxot_cookie_consent";
const MAX_AGE_SECONDS = 60 * 60 * 24 * 180; // ~180 days
const OPEN_EVENT = "oxot:open-cookie-settings";

/** Strings shape for the consent banner (mirrors the `cookies` dictionary key). */
export interface CookieStrings {
  title: string;
  body: string;
  acceptAll: string;
  declineNonEssential: string;
  policyLink: string;
  settingsLabel: string;
}

/** Reopen the consent banner from anywhere (e.g. the footer "Cookie settings" button). */
export function openCookieSettings(): void {
  if (typeof window !== "undefined") {
    window.dispatchEvent(new Event(OPEN_EVENT));
  }
}

function readConsent(): string | null {
  if (typeof document === "undefined") return null;
  const match = document.cookie.match(/(?:^|;\s*)oxot_cookie_consent=([^;]+)/);
  return match ? decodeURIComponent(match[1]) : null;
}

function writeConsent(value: "all" | "essential"): void {
  document.cookie = `${COOKIE_NAME}=${value}; path=/; max-age=${MAX_AGE_SECONDS}; SameSite=Lax`;
}

/**
 * A tiny client button the (server-rendered) footer can mount to reopen the banner.
 * Kept event-based so no React context has to span the server/client boundary.
 */
export function CookieSettingsButton({
  label,
  className
}: {
  label: string;
  className?: string;
}) {
  return (
    <button
      type="button"
      onClick={openCookieSettings}
      className={
        className ??
        "text-muted-foreground no-underline transition-colors duration-150 ease-brand hover:text-primary"
      }
    >
      {label}
    </button>
  );
}

export function CookieConsent({
  locale,
  strings
}: {
  locale: Locale;
  strings: CookieStrings;
}) {
  const [open, setOpen] = React.useState(false);

  React.useEffect(() => {
    if (!readConsent()) setOpen(true);
    const handler = () => setOpen(true);
    window.addEventListener(OPEN_EVENT, handler);
    return () => window.removeEventListener(OPEN_EVENT, handler);
  }, []);

  if (!open) return null;

  const choose = (value: "all" | "essential") => {
    writeConsent(value);
    setOpen(false);
  };

  return (
    <div
      role="dialog"
      aria-modal="false"
      aria-label={strings.title}
      className="fixed inset-x-0 bottom-0 z-50 border-t border-border bg-card/95 shadow-e2 backdrop-blur supports-[backdrop-filter]:bg-card/80"
    >
      <div className="mx-auto flex max-w-6xl flex-col gap-4 px-6 py-5 lg:flex-row lg:items-center lg:justify-between lg:px-8">
        <div className="max-w-2xl">
          <p className="text-sm font-semibold text-foreground">{strings.title}</p>
          <p className="mt-1 text-sm leading-relaxed text-muted-foreground">
            {strings.body}{" "}
            <Link
              href={`/${locale}/cookies`}
              className="text-primary underline-offset-4 hover:underline"
            >
              {strings.policyLink}
            </Link>
          </p>
        </div>
        <div className="flex shrink-0 flex-col gap-2 sm:flex-row">
          <Button variant="outline" size="sm" onClick={() => choose("essential")}>
            {strings.declineNonEssential}
          </Button>
          <Button variant="default" size="sm" onClick={() => choose("all")}>
            {strings.acceptAll}
          </Button>
        </div>
      </div>
    </div>
  );
}
