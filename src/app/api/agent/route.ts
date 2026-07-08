import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { isLocale, type Locale } from "@/i18n/config";
import { retrieve } from "@/lib/retrieval";
import { chatStream } from "@/lib/llm/stream";
import type { ChatMessage } from "@/lib/llm/provider";

export const runtime = "nodejs";

// Bilingual, grounded system prompt. The agent answers in the visitor's locale,
// cites retrieved chunks, and admits uncertainty instead of inventing (Karpathy rule 6).
function systemPrompt(locale: Locale, context: string): string {
  const langRule =
    locale === "nl"
      ? "Antwoord altijd in het Nederlands."
      : "Always answer in English.";
  return [
    "You are the OXOT website assistant.",
    langRule,
    "Use ONLY the CONTEXT below to answer. If the answer is not in the context, say you don't know and offer to connect the visitor with the team.",
    "Be concise. Cite the sources you used by their [id].",
    "",
    "CONTEXT:",
    context || "(no relevant content found)"
  ].join("\n");
}

export async function POST(req: NextRequest) {
  const body = (await req.json().catch(() => ({}))) as {
    sessionId?: string;
    message?: string;
    locale?: string;
    pageId?: string;
  };

  if (!body.sessionId || !body.message) {
    return NextResponse.json(
      { error: "sessionId and message required" },
      { status: 400 }
    );
  }
  const locale: Locale = body.locale && isLocale(body.locale) ? body.locale : "en";

  // Session must exist and have consent (behavioral grounding is consent-gated).
  const sess = await pool.query(
    `SELECT consent_at FROM visitor_sessions WHERE id = $1`,
    [body.sessionId]
  );
  if (!sess.rows.length) {
    return NextResponse.json({ error: "session not found" }, { status: 404 });
  }
  if (!sess.rows[0].consent_at) {
    return NextResponse.json({ error: "consent required" }, { status: 403 });
  }

  // Retrieve grounding chunks (locale-filtered, current-page boosted). If the
  // embedding backend (Ollama) is down, degrade gracefully to no context rather
  // than 500ing the whole request — the agent can still answer / offer contact.
  let chunks: Awaited<ReturnType<typeof retrieve>> = [];
  try {
    chunks = await retrieve(body.message, locale, body.pageId);
  } catch (err) {
    console.error("[agent] retrieval failed, answering without context:", err);
  }
  const context = chunks
    .map((c) => `[${c.id}] (${c.pageId}) ${c.text}`)
    .join("\n\n");
  const citedIds = chunks.map((c) => c.id);

  const messages: ChatMessage[] = [
    { role: "system", content: systemPrompt(locale, context) },
    { role: "user", content: body.message }
  ];

  // Persist the user turn.
  await pool.query(
    `INSERT INTO agent_messages (session_id, role, text) VALUES ($1, 'user', $2)`,
    [body.sessionId, body.message]
  );

  // Stream the answer; persist the assistant turn (with provider + citations) at the end.
  let full = "";
  let provider = "unknown";
  const encoder = new TextEncoder();
  const stream = new ReadableStream<Uint8Array>({
    async start(controller) {
      try {
        for await (const delta of chatStream(messages, (p) => (provider = p))) {
          full += delta;
          controller.enqueue(encoder.encode(delta));
        }
      } catch (err) {
        controller.enqueue(encoder.encode("\n[error generating response]"));
        console.error("[agent] generation error:", err);
      } finally {
        controller.close();
        try {
          await pool.query(
            `INSERT INTO agent_messages (session_id, role, text, cited_chunk_ids, provider)
             VALUES ($1, 'assistant', $2, $3, $4)`,
            [body.sessionId, full, citedIds, provider]
          );
        } catch (e) {
          console.error("[agent] failed to persist assistant message:", e);
        }
      }
    }
  });

  return new Response(stream, {
    headers: {
      "content-type": "text/plain; charset=utf-8",
      "x-agent-citations": JSON.stringify(citedIds),
      "cache-control": "no-store"
    }
  });
}
