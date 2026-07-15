"use client";
import { useEffect, useMemo, useRef, useState } from "react";
import { usePathname } from "next/navigation";
import type { Locale } from "@/i18n/config";
import { Button } from "@/components/ui/button";

// Derive the current page id from the pathname so the agent's page-boost and
// click/page beacons reflect the page the visitor is actually on (not "home").
// "/en" or "/nl" -> "home"; "/en/nis2" -> "nis2"; "/en/blog/x" -> "blog/x".
function pageIdFromPath(pathname: string): string {
  const parts = pathname.split("/").filter(Boolean);
  return parts.length <= 1 ? "home" : parts.slice(1).join("/");
}

type Msg = { role: "user" | "assistant"; text: string };

// localStorage flag: proactive greeting has already been shown to this browser.
const GREETED_KEY = "oxot_greeted";

export interface AgentStrings {
  title: string;
  greeting: string;
  proactiveGreeting: string;
  placeholder: string;
  send: string;
  open: string;
  consent: { title: string; body: string; accept: string; decline: string };
}

export function ChatWidget({
  locale,
  strings
}: {
  locale: Locale;
  strings: AgentStrings;
}) {
  const pathname = usePathname();
  const pageId = useMemo(() => pageIdFromPath(pathname), [pathname]);
  const [open, setOpen] = useState(false);
  const [consent, setConsent] = useState<boolean | null>(null);
  const [sessionId, setSessionId] = useState<string | null>(null);
  const [messages, setMessages] = useState<Msg[]>([
    { role: "assistant", text: strings.greeting }
  ]);
  const [input, setInput] = useState("");
  const [busy, setBusy] = useState(false);
  const [firstVisit, setFirstVisit] = useState(false);
  const endRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    endRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  // First-time visitor: pop the widget open (still consent-gated — no greeting
  // text renders until consent is accepted, see the `consent !== true` branch below).
  useEffect(() => {
    if (typeof window === "undefined") return;
    try {
      if (!window.localStorage.getItem(GREETED_KEY)) {
        setFirstVisit(true);
        setOpen(true);
      }
    } catch { /* ignore */ }
  }, []);

  // Consent-gated: create session, record a page-view, wire click beacons.
  async function accept() {
    const res = await fetch("/api/session", {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ locale, consent: true })
    });
    const { sessionId: sid } = await res.json();
    setSessionId(sid);
    setConsent(true);
    // Expose the session id so a later contact form can link the enquiry to this chat.
    try { window.localStorage.setItem("oxot_session", sid); } catch { /* ignore */ }
    // First-time visitor: show the proactive welcome as the first transcript
    // message now that consent has just been granted, once per browser.
    if (firstVisit) {
      setMessages([{ role: "assistant", text: strings.proactiveGreeting }]);
      try { window.localStorage.setItem(GREETED_KEY, "1"); } catch { /* ignore */ }
      setFirstVisit(false);
    }
    void beacon(sid, "page", pageId);
  }

  function beacon(sid: string, type: string, page?: string, element?: string) {
    return fetch("/api/events", {
      method: "POST",
      headers: { "content-type": "application/json" },
      keepalive: true,
      body: JSON.stringify({ sessionId: sid, type, pageId: page, element })
    }).catch(() => {});
  }

  useEffect(() => {
    if (!consent || !sessionId) return;
    const onClick = (e: MouseEvent) => {
      const el = e.target as HTMLElement | null;
      const label = el?.closest("a,button")?.textContent?.trim().slice(0, 60);
      if (label) void beacon(sessionId, "click", pageId, label);
    };
    document.addEventListener("click", onClick);
    return () => document.removeEventListener("click", onClick);
  }, [consent, sessionId, pageId]);

  async function send() {
    const q = input.trim();
    if (!q || !sessionId || busy) return;
    setInput("");
    setMessages((m) => [...m, { role: "user", text: q }, { role: "assistant", text: "" }]);
    setBusy(true);
    try {
      const res = await fetch("/api/agent", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ sessionId, message: q, locale, pageId })
      });
      if (!res.body) throw new Error("no stream");
      const reader = res.body.getReader();
      const dec = new TextDecoder();
      for (;;) {
        const { done, value } = await reader.read();
        if (done) break;
        const delta = dec.decode(value, { stream: true });
        setMessages((m) => {
          const copy = [...m];
          copy[copy.length - 1] = {
            role: "assistant",
            text: copy[copy.length - 1].text + delta
          };
          return copy;
        });
      }
    } catch {
      setMessages((m) => {
        const copy = [...m];
        copy[copy.length - 1] = { role: "assistant", text: "…" };
        return copy;
      });
    } finally {
      setBusy(false);
    }
  }

  if (!open) {
    return (
      <div className="fixed bottom-4 right-4 z-50">
        <Button onClick={() => setOpen(true)}>{strings.open}</Button>
      </div>
    );
  }

  return (
    <div className="fixed bottom-4 right-4 z-50 flex h-[28rem] w-80 flex-col overflow-hidden rounded-lg border border-border bg-background shadow-xl">
      <div className="flex items-center justify-between border-b border-border px-3 py-2">
        <span className="font-medium">{strings.title}</span>
        <button aria-label="close" onClick={() => setOpen(false)}>×</button>
      </div>

      {consent !== true ? (
        <div className="flex flex-1 flex-col justify-center gap-3 p-4 text-sm">
          <p className="font-medium">{strings.consent.title}</p>
          <p className="text-muted-foreground">{strings.consent.body}</p>
          <div className="flex gap-2">
            <Button onClick={accept}>{strings.consent.accept}</Button>
            <Button variant="outline" onClick={() => setConsent(false)}>
              {strings.consent.decline}
            </Button>
          </div>
        </div>
      ) : (
        <>
          <div className="flex-1 space-y-2 overflow-y-auto p-3 text-sm">
            {messages.map((m, i) => (
              <div
                key={i}
                className={
                  m.role === "user"
                    ? "ml-auto w-fit rounded-lg bg-primary px-3 py-2 text-primary-foreground"
                    : "w-fit rounded-lg bg-muted px-3 py-2 text-muted-foreground"
                }
              >
                {m.text}
              </div>
            ))}
            <div ref={endRef} />
          </div>
          <form
            className="flex gap-2 border-t border-border p-2"
            onSubmit={(e) => {
              e.preventDefault();
              void send();
            }}
          >
            <input
              className="flex-1 rounded-lg border border-border bg-background px-3 py-2 text-sm"
              placeholder={strings.placeholder}
              value={input}
              onChange={(e) => setInput(e.target.value)}
              disabled={busy}
            />
            <Button type="submit" disabled={busy}>
              {strings.send}
            </Button>
          </form>
        </>
      )}
    </div>
  );
}
