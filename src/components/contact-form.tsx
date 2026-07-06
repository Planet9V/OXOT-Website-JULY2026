"use client";
import { useState } from "react";
import { usePathname } from "next/navigation";
import type { Locale } from "@/i18n/config";
import { Button } from "@/components/ui/button";

export interface ContactStrings {
  nameLabel: string; namePlaceholder: string;
  emailLabel: string; emailPlaceholder: string;
  companyLabel: string; companyPlaceholder: string;
  messageLabel: string; messagePlaceholder: string;
  submit: string; submitting: string;
  success: string; errorGeneric: string; errorRate: string;
  errName: string; errEmail: string; errMessage: string;
}

type State = "idle" | "submitting" | "success" | "error";

export function ContactForm({ locale, strings }: { locale: Locale; strings: ContactStrings }) {
  const pathname = usePathname();
  const [state, setState] = useState<State>("idle");
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [topError, setTopError] = useState<string | null>(null);

  const errText = (field: string) =>
    field === "name" ? strings.errName : field === "email" ? strings.errEmail : strings.errMessage;

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
      message: fd.get("message"),
      website: fd.get("website"), // honeypot
      locale,
      page: pathname
    };
    try {
      const res = await fetch("/api/contact", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify(payload)
      });
      const data = await res.json().catch(() => ({}));
      if (res.ok && data.ok) {
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

  if (state === "success") {
    return (
      <div className="rounded-xl border border-primary/40 bg-primary/5 p-6 text-sm">
        {strings.success}
      </div>
    );
  }

  const field = "w-full rounded-lg border border-border bg-background px-3 py-2.5 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary";
  const label = "mb-1.5 block text-sm font-medium";
  const errCls = "mt-1 text-xs text-orange-600 dark:text-orange-400";

  return (
    <form onSubmit={onSubmit} className="space-y-5" noValidate>
      {topError && (
        <div className="rounded-lg border border-orange-500/50 bg-orange-500/10 p-3 text-sm">{topError}</div>
      )}
      <div>
        <label htmlFor="cf-name" className={label}>{strings.nameLabel}</label>
        <input id="cf-name" name="name" className={field} placeholder={strings.namePlaceholder}
               aria-invalid={!!errors.name} autoComplete="name" />
        {errors.name && <p className={errCls}>{errText("name")}</p>}
      </div>
      <div>
        <label htmlFor="cf-email" className={label}>{strings.emailLabel}</label>
        <input id="cf-email" name="email" type="email" className={field} placeholder={strings.emailPlaceholder}
               aria-invalid={!!errors.email} autoComplete="email" />
        {errors.email && <p className={errCls}>{errText("email")}</p>}
      </div>
      <div>
        <label htmlFor="cf-company" className={label}>{strings.companyLabel}</label>
        <input id="cf-company" name="company" className={field} placeholder={strings.companyPlaceholder}
               autoComplete="organization" />
      </div>
      <div>
        <label htmlFor="cf-message" className={label}>{strings.messageLabel}</label>
        <textarea id="cf-message" name="message" rows={6} className={field} placeholder={strings.messagePlaceholder}
                  aria-invalid={!!errors.message} />
        {errors.message && <p className={errCls}>{errText("message")}</p>}
      </div>
      {/* Honeypot: visually hidden, off-screen; bots fill it, humans don't. */}
      <div aria-hidden className="absolute -left-[9999px] h-0 w-0 overflow-hidden" >
        <label htmlFor="cf-website">Website</label>
        <input id="cf-website" name="website" tabIndex={-1} autoComplete="off" />
      </div>
      <Button type="submit" disabled={state === "submitting"}>
        {state === "submitting" ? strings.submitting : strings.submit}
      </Button>
    </form>
  );
}
