"use client";
import { useEffect, useState, useCallback } from "react";

type Message = {
  id: string; name: string; email: string; company: string | null;
  message: string; locale: string; page: string | null;
  handled: boolean; created_at: string;
};

export function ContactInbox() {
  const [messages, setMessages] = useState<Message[]>([]);
  const [loading, setLoading] = useState(true);

  const load = useCallback(async () => {
    const res = await fetch("/api/admin/contact");
    if (res.ok) setMessages((await res.json()).messages);
    setLoading(false);
  }, []);
  useEffect(() => { void load(); }, [load]);

  async function toggle(id: string, handled: boolean) {
    await fetch("/api/admin/contact", {
      method: "PATCH",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ id, handled })
    });
    void load();
  }

  const open = messages.filter((m) => !m.handled).length;

  return (
    <section className="space-y-4">
      <h2 className="font-semibold">
        Contact enquiries{" "}
        {open > 0 && (
          <span className="ml-2 rounded-full bg-primary px-2 py-0.5 text-xs text-primary-foreground">{open} new</span>
        )}
      </h2>
      {loading ? (
        <p className="text-sm text-muted-foreground">Loading…</p>
      ) : messages.length === 0 ? (
        <p className="text-sm text-muted-foreground">No enquiries yet.</p>
      ) : (
        <ul className="space-y-3">
          {messages.map((m) => (
            <li key={m.id} className={`rounded-lg border p-4 ${m.handled ? "border-border opacity-60" : "border-primary/40"}`}>
              <div className="flex flex-wrap items-baseline justify-between gap-2">
                <span className="font-medium">{m.name}{m.company ? ` · ${m.company}` : ""}</span>
                <span className="text-xs text-muted-foreground">
                  {new Date(m.created_at).toLocaleString()} · {m.locale}{m.page ? ` · ${m.page}` : ""}
                </span>
              </div>
              <a href={`mailto:${m.email}`} className="text-sm text-primary underline underline-offset-2">{m.email}</a>
              <p className="mt-2 whitespace-pre-wrap text-sm text-muted-foreground">{m.message}</p>
              <button
                onClick={() => toggle(m.id, !m.handled)}
                className="mt-3 text-xs text-primary underline underline-offset-2"
              >
                {m.handled ? "Mark as new" : "Mark handled"}
              </button>
            </li>
          ))}
        </ul>
      )}
    </section>
  );
}
