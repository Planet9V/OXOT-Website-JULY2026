"use client";

/**
 * SocialFeed — the public "Follow Along" section. Ported from the source repo
 * (Celestial-Agent-Nexus artifacts/oxot-web/src/components/social-feed.tsx) and
 * made bilingual + wired into the shared layout so it appears above the footer on
 * EVERY page. Renders a live X/Twitter timeline embed and a LinkedIn follow card
 * from the site's social links. Uses the platforms' native embed widgets — no API
 * credentials required (complements, but doesn't depend on, the admin integrations).
 */
import { useEffect } from "react";
import { Linkedin, Twitter } from "lucide-react";

export interface SocialFeedStrings {
  heading: string;
  subtitle: string;
  onXSuffix: string;
  loading: string;
  linkedinTitle: string;
  linkedinBlurb: string;
  linkedinCta: string;
}

interface SocialLink { platform: string; url: string }

function extractTwitterHandle(url: string): string | null {
  try {
    const u = new URL(url);
    if (["twitter.com", "x.com", "www.twitter.com", "www.x.com"].includes(u.hostname)) {
      return u.pathname.split("/").filter(Boolean)[0] ?? null;
    }
  } catch {
    /* ignore malformed URLs */
  }
  return null;
}

function isLinkedInUrl(url: string): boolean {
  try {
    return new URL(url).hostname.includes("linkedin.com");
  } catch {
    return false;
  }
}

function TwitterEmbed({ handle, strings }: { handle: string; strings: SocialFeedStrings }) {
  useEffect(() => {
    if (typeof window === "undefined") return;
    const win = window as unknown as { twttr?: { widgets?: { load?: () => void } } };
    if (win.twttr?.widgets?.load) {
      win.twttr.widgets.load();
      return;
    }
    if (document.getElementById("twitter-widget-script")) return;
    const script = document.createElement("script");
    script.id = "twitter-widget-script";
    script.src = "https://platform.twitter.com/widgets.js";
    script.async = true;
    document.body.appendChild(script);
  }, [handle]);

  return (
    <div className="w-full overflow-hidden rounded-xl border border-border bg-card">
      <div className="flex items-center gap-2 border-b border-border px-4 py-3">
        <Twitter className="h-4 w-4 text-[#1DA1F2]" />
        <span className="text-sm font-semibold">@{handle} {strings.onXSuffix}</span>
      </div>
      <div className="p-2">
        {/* eslint-disable-next-line @next/next/no-html-link-for-pages */}
        <a
          className="twitter-timeline"
          data-height="440"
          data-theme="dark"
          data-chrome="noheader nofooter noborders transparent"
          href={`https://twitter.com/${handle}`}
        >
          {strings.loading}
        </a>
      </div>
    </div>
  );
}

function LinkedInCard({ url, strings }: { url: string; strings: SocialFeedStrings }) {
  return (
    <div className="flex w-full flex-col items-center gap-4 rounded-xl border border-border bg-card p-6 text-center">
      <div className="flex h-12 w-12 items-center justify-center rounded-full bg-[#0077B5]">
        <Linkedin className="h-6 w-6 text-white" />
      </div>
      <div>
        <p className="text-sm font-semibold">{strings.linkedinTitle}</p>
        <p className="mt-1 text-xs text-muted-foreground">{strings.linkedinBlurb}</p>
      </div>
      <a
        href={url}
        target="_blank"
        rel="noopener noreferrer"
        className="inline-flex items-center gap-2 rounded-md bg-[#0077B5] px-4 py-2 text-sm font-medium text-white transition-colors hover:bg-[#005f94]"
      >
        <Linkedin className="h-4 w-4" />
        {strings.linkedinCta}
      </a>
    </div>
  );
}

export function SocialFeed({
  socialLinks,
  strings
}: {
  socialLinks: readonly SocialLink[];
  strings: SocialFeedStrings;
}) {
  const twitterLink = socialLinks.find(
    (l) => l.platform.toLowerCase().includes("twitter") || l.platform.toLowerCase() === "x" || extractTwitterHandle(l.url) !== null
  );
  const linkedInLink = socialLinks.find(
    (l) => l.platform.toLowerCase().includes("linkedin") || isLinkedInUrl(l.url)
  );
  const twitterHandle = twitterLink ? extractTwitterHandle(twitterLink.url) : null;
  if (!twitterHandle && !linkedInLink) return null;
  const hasBoth = twitterHandle && linkedInLink;

  return (
    <section className="border-t border-border bg-card/20">
      <div className="mx-auto max-w-6xl px-6 py-14 lg:px-8">
        <div className="mb-8 text-center">
          <h2 className="text-2xl font-bold md:text-3xl" style={{ fontFamily: "var(--font-display)" }}>
            {strings.heading}
          </h2>
          <p className="mt-2 text-sm text-muted-foreground md:text-base">{strings.subtitle}</p>
        </div>
        <div className={`grid gap-6 ${hasBoth ? "grid-cols-1 md:grid-cols-2" : "mx-auto max-w-lg grid-cols-1"}`}>
          {twitterHandle && <TwitterEmbed handle={twitterHandle} strings={strings} />}
          {linkedInLink && <LinkedInCard url={linkedInLink.url} strings={strings} />}
        </div>
      </div>
    </section>
  );
}
