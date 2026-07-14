"use client";

import * as React from "react";
import type { Locale } from "@/i18n/config";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

/** Strings shape for the newsletter block (mirrors the `footer.newsletter` dictionary key). */
export interface NewsletterStrings {
  heading: string;
  placeholder: string;
  subscribe: string;
  subscribing: string;
  helper: string;
  success: string;
  invalid: string;
  error: string;
}

type Status = "idle" | "loading" | "ok" | "error";

const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export function NewsletterSignup({
  locale,
  strings
}: {
  locale: Locale;
  strings: NewsletterStrings;
}) {
  const [email, setEmail] = React.useState("");
  const [status, setStatus] = React.useState<Status>("idle");
  const [message, setMessage] = React.useState("");

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!EMAIL_RE.test(email.trim())) {
      setStatus("error");
      setMessage(strings.invalid);
      return;
    }
    setStatus("loading");
    setMessage("");
    try {
      const res = await fetch("/api/newsletter/subscribe", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ email: email.trim(), locale, source: "footer" })
      });
      if (res.ok) {
        setStatus("ok");
        setMessage(strings.success);
        setEmail("");
      } else {
        setStatus("error");
        setMessage(strings.invalid);
      }
    } catch {
      setStatus("error");
      setMessage(strings.error);
    }
  }

  return (
    <div>
      <p className="text-xs font-semibold uppercase tracking-[0.2em] text-muted-foreground">
        {strings.heading}
      </p>
      <form onSubmit={onSubmit} className="mt-4 flex flex-col gap-2 sm:flex-row" noValidate>
        <label htmlFor="newsletter-email" className="sr-only">
          {strings.placeholder}
        </label>
        <Input
          id="newsletter-email"
          type="email"
          name="email"
          autoComplete="email"
          placeholder={strings.placeholder}
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          disabled={status === "loading"}
          aria-invalid={status === "error"}
          className="sm:max-w-[16rem]"
        />
        <Button type="submit" disabled={status === "loading"} className="shrink-0">
          {status === "loading" ? strings.subscribing : strings.subscribe}
        </Button>
      </form>
      {message ? (
        <p
          role="status"
          className={
            "mt-2 text-xs " +
            (status === "ok" ? "text-primary" : "text-destructive")
          }
        >
          {message}
        </p>
      ) : (
        <p className="mt-2 max-w-sm text-xs leading-relaxed text-muted-foreground">
          {strings.helper}
        </p>
      )}
    </div>
  );
}
