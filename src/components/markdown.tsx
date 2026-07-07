import React from "react";
import { Carousel, type Slide } from "./carousel";
import { parseInline, slugify } from "./article/inline";
import { RevealBlock, KeyFacts, TimelineBlock, CompareBlock, DataTable, CtaCard } from "./article/blocks";

/**
 * Dependency-free, server-side Markdown renderer for CMS page bodies. Parsing
 * runs on the server; interactive/animated feature blocks (keyfacts, timeline,
 * compare, tables, CTAs, and scroll-reveal wrappers) are delegated to small
 * client components in ./article/blocks so body prose stays SSR-visible.
 * Supported: headings (# .. ####) w/ anchor ids + TOC, ---/*** rules,
 * > blockquotes and > [!NOTE|TIP|WARNING|IMPORTANT] callouts, lists, GFM
 * tables, images, fenced blocks (code, svg, carousel, keyfacts, timeline,
 * compare, cta, html), and inline **bold** *italic* `code` [text](url).
 */

/** Extract the H2 table of contents with the SAME de-duplicated ids the renderer
 *  assigns, so a sidebar TOC's anchors match the rendered headings. */
export function extractToc(source: string): { id: string; text: string }[] {
  const seen = new Map<string, number>();
  const out: { id: string; text: string }[] = [];
  let inFence = false;
  for (const raw of source.replace(/\r\n/g, "\n").split("\n")) {
    if (/^\s*```/.test(raw)) { inFence = !inFence; continue; }
    if (inFence) continue;
    const h = /^(#{1,4})\s+(.*)$/.exec(raw);
    if (!h) continue;
    const base = slugify(h[2]) || "section";
    const n = seen.get(base) ?? 0;
    seen.set(base, n + 1);
    const id = n === 0 ? base : `${base}-${n + 1}`;
    if (h[1].length === 2) out.push({ id, text: h[2].replace(/\*\*|\*|`/g, "") });
  }
  return out;
}

const CALLOUT: Record<string, { cls: string; label: string }> = {
  NOTE: { cls: "border-primary/60 bg-primary/5", label: "Note" },
  TIP: { cls: "border-green-500/50 bg-green-500/5", label: "Tip" },
  IMPORTANT: { cls: "border-primary/70 bg-primary/10", label: "Important" },
  WARNING: { cls: "border-orange-500/60 bg-orange-500/10", label: "Warning" }
};

function parseCarousel(raw: string): Slide[] {
  return raw.split(/\n---\n/).map((chunk) => {
    const lines = chunk.trim().split("\n");
    const first = lines[0] ?? "";
    if (/^#{1,3}\s+/.test(first) || (lines.length > 1 && first.length < 90)) {
      return { title: first.replace(/^#{1,3}\s+/, ""), body: lines.slice(1).join(" ").trim() };
    }
    return { body: chunk.trim() };
  }).filter((s) => s.title || s.body);
}

export function MarkdownContent({ source, toc = true, locale = "en" }: { source: string; toc?: boolean; locale?: string }) {
  const nl = locale === "nl";
  const lines = source.replace(/\r\n/g, "\n").split("\n");
  const blocks: React.ReactNode[] = [];
  const headings: { id: string; text: string }[] = [];
  const seenIds = new Map<string, number>();
  const uniqueId = (text: string) => {
    const base = slugify(text) || "section";
    const n = seenIds.get(base) ?? 0;
    seenIds.set(base, n + 1);
    return n === 0 ? base : `${base}-${n + 1}`;
  };
  let i = 0, key = 0;

  const isBlockStart = (l: string) =>
    /^(#{1,4})\s/.test(l) || /^\s*(-{3,}|\*{3,})\s*$/.test(l) || /^\s*>/.test(l) ||
    /^\s*[-*]\s+/.test(l) || /^\s*\d+\.\s+/.test(l) || /^\s*```/.test(l) || /^\s*\|.*\|/.test(l);

  while (i < lines.length) {
    const line = lines[i];
    if (!line.trim()) { i++; continue; }

    // Fenced blocks
    const fence = /^\s*```(\w*)\s*$/.exec(line);
    if (fence) {
      const lang = fence[1];
      const buf: string[] = [];
      i++;
      while (i < lines.length && !/^\s*```\s*$/.test(lines[i])) { buf.push(lines[i]); i++; }
      i++; // closing ```
      const content = buf.join("\n");
      if (lang === "svg") {
        blocks.push(
          <RevealBlock key={key++}>
            <figure className="oxot-diagram my-8 overflow-x-auto rounded-xl p-4 [&_svg]:mx-auto [&_svg]:h-auto [&_svg]:max-w-full"
                     dangerouslySetInnerHTML={{ __html: content }} />
          </RevealBlock>
        );
      } else if (lang === "carousel") {
        blocks.push(<RevealBlock key={key++}><Carousel slides={parseCarousel(content)} /></RevealBlock>);
      } else if (lang === "keyfacts") {
        // "Label :: Value" per line.
        const facts = content.split("\n").map((l) => l.split("::")).filter((p) => p.length >= 2)
          .map((p) => ({ k: p[0].trim(), v: p.slice(1).join("::").trim() }));
        blocks.push(<KeyFacts key={key++} facts={facts} label={nl ? "In één oogopslag" : "At a glance"} />);
      } else if (lang === "timeline") {
        // "Date :: Event" per line.
        const items = content.split("\n").map((l) => l.split("::")).filter((p) => p.length >= 2)
          .map((p) => ({ d: p[0].trim(), e: p.slice(1).join("::").trim() }));
        blocks.push(<TimelineBlock key={key++} items={items} />);
      } else if (lang === "compare") {
        // Columns split by a "---" line; first line = title, rest = "- " bullets.
        const cols = content.split(/\n-{3,}\n/).map((c) => {
          const ls = c.trim().split("\n");
          return { title: (ls[0] ?? "").replace(/^#+\s*/, "").trim(), rows: ls.slice(1).map((l) => l.replace(/^[-*]\s+/, "").trim()).filter(Boolean) };
        }).filter((c) => c.title || c.rows.length);
        blocks.push(<CompareBlock key={key++} cols={cols} />);
      } else if (lang === "cta") {
        // line0 = heading, line1 = body, line2 = "Label :: /href"
        const ls = content.split("\n").map((s) => s.trim()).filter(Boolean);
        const heading = ls[0] ?? (nl ? "Praat met een OT-beveiligingsexpert" : "Talk to an OT security expert");
        const body = ls[1] ?? "";
        const parts = (ls[2] ?? "").split("::");
        const label = (parts[0]?.trim()) || (nl ? "Neem contact op" : "Talk to an expert");
        const href = (parts[1]?.trim()) || `/${locale}/contact`;
        blocks.push(<CtaCard key={key++} heading={heading} body={body} label={label} href={href} />);
      } else if (lang === "html") {
        blocks.push(<RevealBlock key={key++}><div className="my-6 [&_video]:w-full [&_video]:rounded-xl [&_iframe]:w-full" dangerouslySetInnerHTML={{ __html: content }} /></RevealBlock>);
      } else {
        blocks.push(
          <pre key={key++} className="my-6 overflow-x-auto rounded-lg border border-border bg-muted/40 p-4 text-sm">
            <code>{content}</code>
          </pre>
        );
      }
      continue;
    }

    // GFM table → interactive DataTable (sortable when large; zebra + hover)
    if (/^\s*\|.*\|/.test(line) && i + 1 < lines.length && /^\s*\|?[\s:|-]+\|?\s*$/.test(lines[i + 1]) && lines[i + 1].includes("-")) {
      const cells = (r: string) => r.trim().replace(/^\||\|$/g, "").split("|").map((c) => c.trim());
      const header = cells(line);
      i += 2;
      const rows: string[][] = [];
      while (i < lines.length && /^\s*\|.*\|/.test(lines[i])) { rows.push(cells(lines[i])); i++; }
      blocks.push(<RevealBlock key={key++}><DataTable header={header} rows={rows} /></RevealBlock>);
      continue;
    }

    // Horizontal rule
    if (/^\s*(-{3,}|\*{3,})\s*$/.test(line)) { blocks.push(<hr key={key++} className="my-10 border-border" />); i++; continue; }

    // Headings (with anchor id; collect h2 for TOC)
    const h = /^(#{1,4})\s+(.*)$/.exec(line);
    if (h) {
      const level = h[1].length;
      const text = h[2];
      const id = uniqueId(text);
      if (level === 2) headings.push({ id, text });
      const content = parseInline(text, `h${key}`);
      const cls =
        level === 1 ? "mt-2 mb-4 text-4xl font-bold tracking-tight" :
        level === 2 ? "mt-14 mb-4 scroll-mt-20 text-2xl font-semibold tracking-tight border-b border-border pb-2" :
        level === 3 ? "mt-8 mb-3 scroll-mt-20 text-xl font-semibold" :
                      "mt-6 mb-2 text-lg font-semibold";
      const Tag = (`h${level}` as unknown) as keyof React.JSX.IntrinsicElements;
      blocks.push(<Tag key={key++} id={id} className={cls}>{content}</Tag>);
      i++;
      continue;
    }

    // Callout: > [!TYPE] ...  (else normal blockquote)
    if (/^\s*>/.test(line)) {
      const buf: string[] = [];
      while (i < lines.length && /^\s*>/.test(lines[i])) { buf.push(lines[i].replace(/^\s*>\s?/, "")); i++; }
      const joined = buf.join("\n");
      const cm = /^\[!(NOTE|TIP|IMPORTANT|WARNING)\]\s*([\s\S]*)$/.exec(joined.trim());
      if (cm) {
        const c = CALLOUT[cm[1]];
        blocks.push(
          <RevealBlock key={key++} y={16}>
            <aside className={`my-6 rounded-lg border-l-4 p-4 ${c.cls}`}>
              <div className="mb-1 text-xs font-semibold uppercase tracking-wide text-foreground">{c.label}</div>
              <div className="text-sm text-muted-foreground">{parseInline(cm[2].replace(/\n/g, " ").trim(), `cal${key}`)}</div>
            </aside>
          </RevealBlock>
        );
      } else {
        blocks.push(
          <blockquote key={key++} className="my-6 border-l-4 border-primary pl-4 italic text-muted-foreground">
            {parseInline(joined.replace(/\n/g, " "), `q${key}`)}
          </blockquote>
        );
      }
      continue;
    }

    // Unordered list
    if (/^\s*[-*]\s+/.test(line)) {
      const items: React.ReactNode[] = [];
      while (i < lines.length && /^\s*[-*]\s+/.test(lines[i])) { items.push(<li key={items.length}>{parseInline(lines[i].replace(/^\s*[-*]\s+/, ""), `ul${key}-${items.length}`)}</li>); i++; }
      blocks.push(<ul key={key++} className="my-4 list-disc space-y-1.5 pl-6 text-muted-foreground">{items}</ul>);
      continue;
    }

    // Ordered list
    if (/^\s*\d+\.\s+/.test(line)) {
      const items: React.ReactNode[] = [];
      while (i < lines.length && /^\s*\d+\.\s+/.test(lines[i])) { items.push(<li key={items.length}>{parseInline(lines[i].replace(/^\s*\d+\.\s+/, ""), `ol${key}-${items.length}`)}</li>); i++; }
      blocks.push(<ol key={key++} className="my-4 list-decimal space-y-1.5 pl-6 text-muted-foreground">{items}</ol>);
      continue;
    }

    // Standalone image line
    const img = /^\s*!\[([^\]]*)\]\((https?:\/\/[^\s)]+|\/[^\s)]+)\)\s*$/.exec(line);
    if (img) {
      blocks.push(<figure key={key++} className="my-8"><img src={img[2]} alt={img[1]} className="mx-auto max-w-full rounded-xl border border-border" />{img[1] && <figcaption className="mt-2 text-center text-sm text-muted-foreground">{img[1]}</figcaption>}</figure>);
      i++;
      continue;
    }

    // Paragraph
    const para: string[] = [];
    while (i < lines.length && lines[i].trim() && !isBlockStart(lines[i])) { para.push(lines[i]); i++; }
    blocks.push(<p key={key++} className="my-4 leading-relaxed text-muted-foreground">{parseInline(para.join(" "), `p${key}`)}</p>);
  }

  const tocNode =
    toc && headings.length >= 3 ? (
      <nav className="mb-10 rounded-xl border border-border bg-muted/20 p-5">
        <div className="mb-2 text-xs font-semibold uppercase tracking-widest text-muted-foreground">{nl ? "Op deze pagina" : "On this page"}</div>
        <ul className="grid gap-1.5 sm:grid-cols-2">
          {headings.map((hd) => (
            <li key={hd.id}>
              <a href={`#${hd.id}`} className="text-sm text-primary underline-offset-2 hover:underline">{hd.text}</a>
            </li>
          ))}
        </ul>
      </nav>
    ) : null;

  return <div className="max-w-none">{tocNode}{blocks}</div>;
}
