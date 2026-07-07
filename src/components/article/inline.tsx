import React from "react";

/**
 * Shared, pure inline-markdown helpers. No "use client" — safe to import from
 * BOTH the server renderer (markdown.tsx) and client block components
 * (blocks.tsx), because these are plain functions with no server-only deps.
 */

export type Inline = React.ReactNode;

export function slugify(s: string): string {
  return s.toLowerCase().replace(/[^\w\s-]/g, "").trim().replace(/\s+/g, "-").slice(0, 80);
}

/** Strip inline markdown to plain text — used for table sort keys / aria labels. */
export function plainText(text: string): string {
  return text
    .replace(/!\[[^\]]*\]\([^)]*\)/g, "")
    .replace(/\[([^\]]+)\]\([^)]*\)/g, "$1")
    .replace(/\*\*([^*]+)\*\*/g, "$1")
    .replace(/`([^`]+)`/g, "$1")
    .replace(/\*([^*]+)\*/g, "$1")
    .trim();
}

/** Render inline **bold** *italic* `code` [text](url) ![alt](img) to React nodes. */
export function parseInline(text: string, keyBase: string): Inline[] {
  const nodes: Inline[] = [];
  const pattern =
    /(!\[([^\]]*)\]\((https?:\/\/[^\s)]+|\/[^\s)]+)\))|(\[([^\]]+)\]\((https?:\/\/[^\s)]+|\/[^\s)]+)\))|(\*\*([^*]+)\*\*)|(`([^`]+)`)|(\*([^*]+)\*)/g;
  let last = 0, m: RegExpExecArray | null, i = 0;
  while ((m = pattern.exec(text)) !== null) {
    if (m.index > last) nodes.push(<React.Fragment key={`${keyBase}-t${i++}`}>{text.slice(last, m.index)}</React.Fragment>);
    const key = `${keyBase}-i${i++}`;
    if (m[1]) {
      nodes.push(<img key={key} src={m[3]} alt={m[2]} className="my-1 inline-block max-h-6 align-middle" />);
    } else if (m[4]) {
      const ext = m[6].startsWith("http");
      nodes.push(
        <a key={key} href={m[6]} target={ext ? "_blank" : undefined} rel={ext ? "noopener noreferrer" : undefined}
           className="text-primary underline underline-offset-2 hover:opacity-80">{m[5]}</a>
      );
    } else if (m[7]) {
      nodes.push(<strong key={key} className="font-semibold text-foreground">{m[8]}</strong>);
    } else if (m[9]) {
      nodes.push(<code key={key} className="rounded bg-muted px-1.5 py-0.5 text-sm">{m[10]}</code>);
    } else if (m[11]) {
      nodes.push(<em key={key}>{m[12]}</em>);
    }
    last = m.index + m[0].length;
  }
  if (last < text.length) nodes.push(<React.Fragment key={`${keyBase}-t${i++}`}>{text.slice(last)}</React.Fragment>);
  return nodes;
}
