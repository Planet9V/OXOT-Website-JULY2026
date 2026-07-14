"use client";

import * as React from "react";
import { usePathname } from "next/navigation";

// First-party, consent-gated visitor tracker. Ported from the source web client
// (artifacts/oxot-web/src/hooks/analytics-core.ts + use-analytics.ts):
//  - fires a lightweight page-view beacon once per public route view;
//  - records outbound link clicks;
//  - never tracks unless the visitor has accepted all cookies.
// This app stores consent in the `oxot_cookie_consent` cookie ("all" | "essential"),
// so tracking runs only when the value is "all". Failures never break the page.

const SESSION_KEY = "oxot-visitor";

function hasConsent(): boolean {
  if (typeof document === "undefined") return false;
  const match = document.cookie.match(/(?:^|;\s*)oxot_cookie_consent=([^;]+)/);
  return match ? decodeURIComponent(match[1]) === "all" : false;
}

function getSessionId(): string {
  try {
    let id = localStorage.getItem(SESSION_KEY);
    if (!id) {
      id =
        crypto.randomUUID?.() ??
        `${Date.now()}-${Math.random().toString(36).slice(2)}`;
      localStorage.setItem(SESSION_KEY, id);
    }
    return id;
  } catch {
    return "anon";
  }
}

function getDevice(): string {
  const w = window.innerWidth;
  if (w < 768) return "mobile";
  if (w < 1024) return "tablet";
  return "desktop";
}

function localeFromPath(path: string): string {
  return path.startsWith("/nl") ? "nl" : "en";
}

function send(payload: Record<string, unknown>): void {
  try {
    void fetch("/api/track", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
      keepalive: true,
    }).catch(() => {});
  } catch {
    /* never let tracking break the page */
  }
}

export function AnalyticsTracker() {
  const pathname = usePathname();
  const lastPath = React.useRef<string | null>(null);

  // Page view on navigation.
  React.useEffect(() => {
    if (!pathname || lastPath.current === pathname) return;
    if (!hasConsent()) return;
    lastPath.current = pathname;
    send({
      type: "page_view",
      path: pathname,
      locale: localeFromPath(pathname),
      sessionId: getSessionId(),
      referrer:
        (typeof document !== "undefined" ? document.referrer : "") || undefined,
      device: getDevice(),
    });
  }, [pathname]);

  // Outbound link clicks.
  React.useEffect(() => {
    function onClick(e: MouseEvent) {
      if (!hasConsent()) return;
      const target = e.target as HTMLElement | null;
      const anchor = target?.closest?.("a") as HTMLAnchorElement | null;
      if (!anchor || !anchor.href) return;
      let url: URL;
      try {
        url = new URL(anchor.href, window.location.origin);
      } catch {
        return;
      }
      if (url.protocol !== "http:" && url.protocol !== "https:") return;
      const isOutbound = url.host !== window.location.host;
      if (!isOutbound) return;
      send({
        type: "link_click",
        href: url.href,
        kind: "outbound",
        path: window.location.pathname,
        locale: localeFromPath(window.location.pathname),
        sessionId: getSessionId(),
        referrer:
          (typeof document !== "undefined" ? document.referrer : "") || undefined,
      });
    }
    document.addEventListener("click", onClick, { capture: true });
    return () => document.removeEventListener("click", onClick, { capture: true });
  }, []);

  return null;
}
