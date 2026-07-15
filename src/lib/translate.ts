import type { ChatMessage } from "@/lib/llm/provider";
import { chat } from "@/lib/llm";

export interface TranslatablePage {
  title: string;
  body: string;
  metaTitle: string;
  metaDescription: string;
  excerpt: string;
}

const LOCALE_NAMES: Record<string, string> = { en: "English", nl: "Dutch" };

function buildSystemPrompt(sourceLocale: string, targetLocale: string): string {
  const source = LOCALE_NAMES[sourceLocale] ?? sourceLocale;
  const target = LOCALE_NAMES[targetLocale] ?? targetLocale;
  return [
    `You are a professional translator converting website content from ${source} to ${target}.`,
    `Translate ALL human-readable text from ${source} to ${target}.`,
    `PRESERVE the markdown structure exactly: headings, lists, tables, links, and code fences must keep their exact syntax and nesting.`,
    `Do NOT translate URLs, hrefs, code (inside inline code or fenced code blocks), or numbers.`,
    `If a field is empty in the source, keep it empty in the output — never invent content.`,
    `Return STRICT JSON with exactly these keys: "title", "body", "metaTitle", "metaDescription", "excerpt".`,
    `Do not include any other keys, commentary, or markdown code fences around the JSON. Return only the raw JSON object.`,
  ].join(" ");
}

function buildUserPrompt(input: TranslatablePage): string {
  return JSON.stringify({
    title: input.title ?? "",
    body: input.body ?? "",
    metaTitle: input.metaTitle ?? "",
    metaDescription: input.metaDescription ?? "",
    excerpt: input.excerpt ?? "",
  });
}

// Strip ```json ... ``` or ``` ... ``` fences if the model wraps its JSON output.
function stripCodeFences(text: string): string {
  const trimmed = text.trim();
  const fenced = trimmed.match(/^```(?:json)?\s*([\s\S]*?)\s*```$/i);
  return fenced ? fenced[1].trim() : trimmed;
}

/**
 * Translate a page's fields from sourceLocale to targetLocale via the shared
 * chat() LLM provider (Ollama primary / OpenRouter fallback). Returns the same
 * shape, translated. Throws a clear error if the LLM call fails or the
 * response cannot be parsed as the expected JSON shape.
 */
export async function translatePage(
  input: TranslatablePage,
  sourceLocale: string,
  targetLocale: string
): Promise<TranslatablePage> {
  const messages: ChatMessage[] = [
    { role: "system", content: buildSystemPrompt(sourceLocale, targetLocale) },
    { role: "user", content: buildUserPrompt(input) },
  ];

  let raw: string;
  try {
    const result = await chat(messages);
    raw = result.content;
  } catch (err) {
    throw new Error(
      `Translation failed: LLM call errored (${err instanceof Error ? err.message : String(err)})`
    );
  }

  const cleaned = stripCodeFences(raw);
  let parsed: unknown;
  try {
    parsed = JSON.parse(cleaned);
  } catch {
    throw new Error("Translation failed: LLM response was not valid JSON.");
  }

  if (
    typeof parsed !== "object" ||
    parsed === null ||
    !("title" in parsed) ||
    !("body" in parsed) ||
    !("metaTitle" in parsed) ||
    !("metaDescription" in parsed) ||
    !("excerpt" in parsed)
  ) {
    throw new Error("Translation failed: LLM response JSON was missing expected keys.");
  }

  const p = parsed as Record<string, unknown>;
  const asString = (v: unknown) => (typeof v === "string" ? v : "");

  return {
    title: asString(p.title),
    body: asString(p.body),
    metaTitle: asString(p.metaTitle),
    metaDescription: asString(p.metaDescription),
    excerpt: asString(p.excerpt),
  };
}
