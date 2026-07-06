import { describe, it, expect } from "vitest";
import { renderToStaticMarkup } from "react-dom/server";
import { MarkdownContent } from "@/components/markdown";

const render = (src: string) => renderToStaticMarkup(<MarkdownContent source={src} />);

describe("MarkdownContent renderer", () => {
  it("renders a GFM table with header and body cells", () => {
    const html = render(["| A | B |", "| --- | --- |", "| 1 | 2 |"].join("\n"));
    expect(html).toContain("<table");
    expect(html).toContain(">A<");
    expect(html).toContain(">1<");
    expect(html).toContain(">2<");
  });

  it("renders a NOTE callout with its label", () => {
    const html = render("> [!NOTE]\n> Consent is required before capture.");
    expect(html).toContain("Note");
    expect(html).toContain("Consent is required before capture.");
  });

  it("renders raw svg inside the fixed diagram panel", () => {
    const html = render("```svg\n<svg><text>hi</text></svg>\n```");
    expect(html).toContain("oxot-diagram");
    expect(html).toContain("<svg>");
  });

  it("de-duplicates repeated heading anchor ids", () => {
    const html = render("## Overview\n\ntext\n\n## Overview\n\nmore");
    expect(html).toContain('id="overview"');
    expect(html).toContain('id="overview-2"');
  });

  it("builds a bold + link inline correctly", () => {
    const html = render("See **NIS2** at [EUR-Lex](https://eur-lex.europa.eu).");
    expect(html).toContain("<strong");
    expect(html).toContain('href="https://eur-lex.europa.eu"');
    expect(html).toContain('target="_blank"');
  });

  it("terminates on an unclosed fence (no infinite loop)", () => {
    // Missing closing ``` — must still return without hanging.
    const html = render("```svg\n<svg></svg>\n\nmore text with no close");
    expect(typeof html).toBe("string");
    expect(html.length).toBeGreaterThan(0);
  });

  it("shows a table-of-contents when there are 3+ h2 headings", () => {
    const html = render("## One\n\nx\n\n## Two\n\ny\n\n## Three\n\nz");
    expect(html).toContain("On this page");
  });
});
