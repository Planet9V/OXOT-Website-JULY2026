// Block CMS — field schemas driving the admin builder forms (Phase 3).
// CLIENT-SAFE: pure data, no @/lib/db. The builder renders a structured form
// from `fields`; blocks with `fields: []` use the JSON power-editor. Generic
// blocks have rich schemas (for composing new dynamic pages); the flagship
// CDT/Conformity blocks are labelled + categorized and edited via JSON (their
// configs are deeply structured and page-specific).
import type { BlockType } from "@/lib/blocks/types";

export type Field =
  | { key: string; label: string; type: "text" | "textarea" | "number" | "boolean" | "image" | "icon" | "markdown"; placeholder?: string; help?: string }
  | { key: string; label: string; type: "select"; options: { value: string; label: string }[] }
  | { key: string; label: string; type: "link" } // { label, href }
  | { key: string; label: string; type: "list"; itemLabel?: string; fields: Field[] }; // array of objects

export interface BlockSchema {
  type: BlockType;
  label: string;
  category: "generic" | "cdt" | "conformity";
  /** Show in the "add block" palette for arbitrary/new pages. */
  palette: boolean;
  /** One-line description for the palette. */
  hint?: string;
  /** Sensible starter config when a block is added. */
  defaultConfig: () => unknown;
  /** Structured form fields. Empty => JSON power-editor only. */
  fields: Field[];
}

const link = (key: string, label: string): Field => ({ key, label, type: "link" });

export const BLOCK_SCHEMAS: Record<BlockType, BlockSchema> = {
  // ---------------- Generic (palette) ----------------
  prose: {
    type: "prose", label: "Prose", category: "generic", palette: true,
    hint: "Rich Markdown text.",
    defaultConfig: () => ({ markdown: "## Heading\n\nWrite your content here." }),
    fields: [{ key: "markdown", label: "Content (Markdown)", type: "markdown" }]
  },
  "block.hero": {
    type: "block.hero", label: "Hero", category: "generic", palette: true,
    hint: "Big headline, subtitle and CTAs with a reveal animation.",
    defaultConfig: () => ({
      eyebrow: "Eyebrow", title: "A bold headline", titleAccent: "that converts",
      subtitle: "A supporting sentence that explains the value.",
      align: "left",
      primaryCta: { label: "Get started", href: "/contact" },
      secondaryCta: { label: "", href: "" }
    }),
    fields: [
      { key: "eyebrow", label: "Eyebrow", type: "text" },
      { key: "title", label: "Title", type: "text" },
      { key: "titleAccent", label: "Title accent (colored)", type: "text" },
      { key: "subtitle", label: "Subtitle", type: "textarea" },
      { key: "align", label: "Alignment", type: "select", options: [{ value: "left", label: "Left" }, { value: "center", label: "Center" }] },
      link("primaryCta", "Primary button"),
      link("secondaryCta", "Secondary button")
    ]
  },
  "block.stats": {
    type: "block.stats", label: "Stat counters", category: "generic", palette: true,
    hint: "Animated count-up statistics.",
    defaultConfig: () => ({ items: [{ value: "99%", label: "Uptime", sub: "" }, { value: "24/7", label: "Support", sub: "" }] }),
    fields: [
      { key: "items", label: "Stats", type: "list", itemLabel: "Stat", fields: [
        { key: "value", label: "Value", type: "text", placeholder: "99%" },
        { key: "label", label: "Label", type: "text" },
        { key: "sub", label: "Sub-label", type: "text" }
      ] }
    ]
  },
  "block.featureGrid": {
    type: "block.featureGrid", label: "Feature grid", category: "generic", palette: true,
    hint: "Cards with icons, staggered reveal.",
    defaultConfig: () => ({
      eyebrow: "Features", title: "What you get",
      cards: [
        { icon: "sparkles", title: "Feature one", body: "Describe the benefit." },
        { icon: "shield", title: "Feature two", body: "Describe the benefit." },
        { icon: "gauge", title: "Feature three", body: "Describe the benefit." }
      ]
    }),
    fields: [
      { key: "eyebrow", label: "Eyebrow", type: "text" },
      { key: "title", label: "Title", type: "text" },
      { key: "cards", label: "Cards", type: "list", itemLabel: "Card", fields: [
        { key: "icon", label: "Icon", type: "icon", help: "sparkles, shield, gauge, layers, network, cpu, boxes, arrow" },
        { key: "title", label: "Title", type: "text" },
        { key: "body", label: "Body", type: "textarea" }
      ] }
    ]
  },
  "block.cta": {
    type: "block.cta", label: "CTA banner", category: "generic", palette: true,
    hint: "Centered call-to-action with buttons.",
    defaultConfig: () => ({ title: "Ready to start?", subtitle: "Talk to our team.", primaryCta: { label: "Contact us", href: "/contact" }, secondaryCta: { label: "", href: "" } }),
    fields: [
      { key: "title", label: "Title", type: "text" },
      { key: "subtitle", label: "Subtitle", type: "textarea" },
      link("primaryCta", "Primary button"),
      link("secondaryCta", "Secondary button")
    ]
  },
  "block.media": {
    type: "block.media", label: "Image / media", category: "generic", palette: true,
    hint: "A framed image with optional caption.",
    defaultConfig: () => ({ src: "", alt: "", caption: "", aspect: "16/9" }),
    fields: [
      { key: "src", label: "Image URL", type: "image" },
      { key: "alt", label: "Alt text", type: "text" },
      { key: "caption", label: "Caption", type: "text" },
      { key: "aspect", label: "Aspect ratio", type: "select", options: [
        { value: "16/9", label: "16:9" }, { value: "4/3", label: "4:3" }, { value: "1/1", label: "1:1" }, { value: "21/9", label: "21:9" }
      ] }
    ]
  },
  "block.divider": {
    type: "block.divider", label: "Divider / spacer", category: "generic", palette: true,
    hint: "A horizontal rule or vertical space.",
    defaultConfig: () => ({ variant: "line", size: "md" }),
    fields: [
      { key: "variant", label: "Style", type: "select", options: [{ value: "line", label: "Line" }, { value: "space", label: "Blank space" }] },
      { key: "size", label: "Size", type: "select", options: [{ value: "sm", label: "Small" }, { value: "md", label: "Medium" }, { value: "lg", label: "Large" }] }
    ]
  },

  // ---------------- Flagship CDT (JSON power-editor) ----------------
  "cdt.hero": jsonBlock("cdt.hero", "CDT — Hero", "cdt"),
  "cdt.statBand": jsonBlock("cdt.statBand", "CDT — Stat band", "cdt"),
  "cdt.livingModel": jsonBlock("cdt.livingModel", "CDT — Living model", "cdt"),
  "cdt.boms": jsonBlock("cdt.boms", "CDT — BOMs", "cdt"),
  "cdt.drilldown": jsonBlock("cdt.drilldown", "CDT — Drilldown", "cdt"),
  "cdt.consequence": jsonBlock("cdt.consequence", "CDT — Consequence", "cdt"),
  "cdt.priority": jsonBlock("cdt.priority", "CDT — Priority matrix", "cdt"),
  "cdt.monteCarlo": jsonBlock("cdt.monteCarlo", "CDT — Monte Carlo", "cdt"),
  "cdt.methodology": jsonBlock("cdt.methodology", "CDT — Methodology", "cdt"),
  "cdt.outcomes": jsonBlock("cdt.outcomes", "CDT — Outcomes", "cdt"),
  "cdt.finalCta": jsonBlock("cdt.finalCta", "CDT — Final CTA", "cdt"),

  // ---------------- Flagship Conformity (JSON power-editor) ----------------
  "conformity.hero": jsonBlock("conformity.hero", "Conformity — Hero", "conformity"),
  "conformity.consultingCarousel": jsonBlock("conformity.consultingCarousel", "Conformity — Consulting carousel", "conformity"),
  "conformity.regulationBand": jsonBlock("conformity.regulationBand", "Conformity — Regulation band", "conformity"),
  "conformity.stats": jsonBlock("conformity.stats", "Conformity — Stats", "conformity"),
  "conformity.platform": jsonBlock("conformity.platform", "Conformity — Platform", "conformity"),
  "conformity.problem": jsonBlock("conformity.problem", "Conformity — Problem", "conformity"),
  "conformity.shift": jsonBlock("conformity.shift", "Conformity — Shift", "conformity"),
  "conformity.comparison": jsonBlock("conformity.comparison", "Conformity — Comparison", "conformity"),
  "conformity.howItWorks": jsonBlock("conformity.howItWorks", "Conformity — How it works", "conformity"),
  "conformity.testimonial": jsonBlock("conformity.testimonial", "Conformity — Testimonial", "conformity"),
  "conformity.faq": jsonBlock("conformity.faq", "Conformity — FAQ", "conformity"),
  "conformity.finalCta": jsonBlock("conformity.finalCta", "Conformity — Final CTA", "conformity")
};

function jsonBlock(type: BlockType, label: string, category: "cdt" | "conformity"): BlockSchema {
  return { type, label, category, palette: false, defaultConfig: () => ({}), fields: [] };
}

/** Block types offered in the "add block" palette for arbitrary/new pages. */
export const PALETTE_BLOCKS: BlockType[] = (Object.values(BLOCK_SCHEMAS) as BlockSchema[])
  .filter((s) => s.palette)
  .map((s) => s.type);

export function schemaFor(type: BlockType): BlockSchema | undefined {
  return BLOCK_SCHEMAS[type];
}
