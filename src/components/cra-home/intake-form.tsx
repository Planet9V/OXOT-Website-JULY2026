"use client";
import { useEffect, useRef, useState } from "react";
import { usePathname } from "next/navigation";
import type { Locale } from "@/i18n/config";
import { Button } from "@/components/ui/button";
// Client-safe segments module (no pg import), so this client bundle never pulls
// in the database pool that src/lib/intake.ts depends on.
import { SEGMENTS, isSegment, type Segment } from "@/lib/segments";

export interface IntakeFormStrings {
  nameLabel: string;
  namePlaceholder: string;
  orgLabel: string;
  orgPlaceholder: string;
  emailLabel: string;
  emailPlaceholder: string;
  segmentLabel: string;
  segmentOptions: Record<Segment, string>;
  roleLabel: string;
  submit: string;
  submitting: string;
  leaveWith: string;
  errName: string;
  errEmail: string;
  errSegment: string;
  errorGeneric: string;
  errorRate: string;
}

export interface IntakeSuccessStrings {
  heading: string;
  body: string;
  scheduleHeading: string;
  scheduleFallback: string;
  bookCta: string;
}

type Scheduling = { provider: "none" | "calcom" | "calendly"; url: string };
type State = "idle" | "submitting" | "success" | "error";

export function IntakeForm({
  locale,
  strings,
  successStrings,
  leaveWith,
  defaultSegment
}: {
  locale: Locale;
  strings: IntakeFormStrings;
  successStrings: IntakeSuccessStrings;
  /** CMS-editable "you leave the call with…" copy (cra_home.hero.leaveWith); falls
   *  back to the dictionary string when not supplied. */
  leaveWith?: string;
  defaultSegment?: Segment;
}) {
  const pathname = usePathname();
  const formRef = useRef<HTMLDivElement>(null);
  const [state, setState] = useState<State>("idle");
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [topError, setTopError] = useState<string | null>(null);
  const [segment, setSegment] = useState<Segment>(defaultSegment ?? "manufacturer");
  const [scheduling, setScheduling] = useState<Scheduling | null>(null);
  const [utm, setUtm] = useState<Record<string, string>>({});
  const [sessionId, setSessionId] = useState<string | null>(null);

  // Any other section (departure board roads, road-split cards, persona cards,
  // the "Ask the assistant" button) can preselect a segment and jump here by
  // dispatching window.dispatchEvent(new CustomEvent("oxot:intake-preselect",
  // { detail: { segment } })) — no shared store needed for one field.
  useEffect(() => {
    function onPreselect(e: Event) {
      const detail = (e as CustomEvent<{ segment?: string }>).detail;
      if (detail?.segment && isSegment(detail.segment)) setSegment(detail.segment);
      formRef.current?.scrollIntoView({ behavior: "smooth", block: "start" });
    }
    window.addEventListener("oxot:intake-preselect", onPreselect as EventListener);
    return () => window.removeEventListener("oxot:intake-preselect", onPreselect as EventListener);
  }, []);

  useEffect(() => {
    try {
      setSessionId(window.localStorage.getItem("oxot_session"));
    } catch {
      /* ignore */
    }
    try {
      const params = new URLSearchParams(window.location.search);
      const captured: Record<string, string> = {};
      for (const [k, v] of params.entries()) {
        if (k.startsWith("utm_")) captured[k] = v;
      }
      setUtm(captured);
    } catch {
      /* ignore */
    }
  }, []);

  const errText = (field: string) =>
    field === "name" ? strings.errName : field === "email" ? strings.errEmail : strings.errSegment;

  async function onSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setState("submitting");
    setErrors({});
    setTopError(null);
    const fd = new FormData(e.currentTarget);
    const payload = {
      name: fd.get("name"),
      email: fd.get("email"),
      company: fd.get("company"),
      role: fd.get("role"),
      segment,
      website: fd.get("website"), // honeypot
      locale,
      page: pathname,
      sessionId,
      utm
    };
    try {
      const res = await fetch("/api/intake", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify(payload)
      });
      const data = await res.json().catch(() => ({}));
      if (res.ok && data.ok) {
        setScheduling(data.scheduling ?? { provider: "none", url: "" });
        setState("success");
        return;
      }
      if (res.status === 429) {
        setTopError(strings.errorRate);
      } else if (data.errors && typeof data.errors === "object") {
        setErrors(data.errors);
        setTopError(null);
      } else {
        setTopError(strings.errorGeneric);
      }
      setState("error");
    } catch {
      setTopError(strings.errorGeneric);
      setState("error");
    }
  }

  const field =
    "w-full rounded-lg border border-border bg-background px-3 py-2.5 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary";
  const label = "mb-1.5 block text-sm font-medium text-foreground";
  const errCls = "mt-1 text-xs text-orange-600 dark:text-orange-400";

  if (state === "success") {
    return (
      <div ref={formRef} id="intake-form" className="rounded-xl border border-primary/40 bg-primary/5 p-6">
        <h3 className="text-lg font-semibold text-foreground">{successStrings.heading}</h3>
        <p className="mt-2 text-sm leading-relaxed text-muted-foreground">{successStrings.body}</p>
        <div className="mt-4 rounded-lg border border-border bg-background p-3 text-xs leading-relaxed text-foreground">
          {leaveWith || strings.leaveWith}
        </div>
        {scheduling && scheduling.provider !== "none" && scheduling.url ? (
          <div className="mt-5">
            <p className="text-sm font-medium text-foreground">{successStrings.scheduleHeading}</p>
            <iframe
              src={scheduling.url}
              title={successStrings.scheduleHeading}
              className="mt-2 h-[560px] w-full rounded-lg border border-border"
            />
            <a
              href={scheduling.url}
              target="_blank"
              rel="noopener noreferrer"
              className="mt-2 inline-block text-xs font-medium text-primary underline underline-offset-2"
            >
              {successStrings.bookCta}
            </a>
          </div>
        ) : (
          <p className="mt-5 text-sm text-muted-foreground">{successStrings.scheduleFallback}</p>
        )}
      </div>
    );
  }

  return (
    <div ref={formRef} id="intake-form" className="rounded-xl border border-border bg-card p-6 shadow-sm">
      <form onSubmit={onSubmit} className="space-y-4" noValidate>
        {topError && (
          <div className="rounded-lg border border-orange-500/50 bg-orange-500/10 p-3 text-sm">{topError}</div>
        )}
        <div>
          <label htmlFor="if-name" className={label}>
            {strings.nameLabel}
          </label>
          <input
            id="if-name"
            name="name"
            className={field}
            placeholder={strings.namePlaceholder}
            aria-invalid={!!errors.name}
            autoComplete="name"
          />
          {errors.name && <p className={errCls}>{errText("name")}</p>}
        </div>
        <div>
          <label htmlFor="if-org" className={label}>
            {strings.orgLabel}
          </label>
          <input
            id="if-org"
            name="company"
            className={field}
            placeholder={strings.orgPlaceholder}
            autoComplete="organization"
          />
        </div>
        <div>
          <label htmlFor="if-email" className={label}>
            {strings.emailLabel}
          </label>
          <input
            id="if-email"
            name="email"
            type="email"
            className={field}
            placeholder={strings.emailPlaceholder}
            aria-invalid={!!errors.email}
            autoComplete="email"
          />
          {errors.email && <p className={errCls}>{errText("email")}</p>}
        </div>
        <div>
          <label htmlFor="if-segment" className={label}>
            {strings.segmentLabel}
          </label>
          <select
            id="if-segment"
            name="segment"
            className={field}
            value={segment}
            aria-invalid={!!errors.segment}
            onChange={(e) => {
              const v = e.target.value;
              if (isSegment(v)) setSegment(v);
            }}
          >
            {SEGMENTS.map((s) => (
              <option key={s} value={s}>
                {strings.segmentOptions[s]}
              </option>
            ))}
          </select>
          {errors.segment && <p className={errCls}>{errText("segment")}</p>}
        </div>
        <div>
          <label htmlFor="if-role" className={label}>
            {strings.roleLabel}
          </label>
          <input id="if-role" name="role" className={field} autoComplete="organization-title" />
        </div>
        {/* Honeypot: visually hidden, off-screen; bots fill it, humans don't. */}
        <div aria-hidden className="absolute -left-[9999px] h-0 w-0 overflow-hidden">
          <label htmlFor="if-website">Website</label>
          <input id="if-website" name="website" tabIndex={-1} autoComplete="off" />
        </div>
        <Button type="submit" disabled={state === "submitting"} className="w-full">
          {state === "submitting" ? strings.submitting : strings.submit}
        </Button>
        <p className="text-xs leading-relaxed text-muted-foreground">{leaveWith || strings.leaveWith}</p>
      </form>
    </div>
  );
}
