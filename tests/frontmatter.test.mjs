import { describe, it, expect } from "vitest";
import { parseFrontmatter } from "../scripts/lib/frontmatter.mjs";

describe("parseFrontmatter", () => {
  it("parses keys and splits only on the first colon (values may contain colons)", () => {
    const { meta, body } = parseFrontmatter(
      ["---", "title: IEC 62443: A Guide", "meta_title: Zones & Conduits | OXOT", "published: true", "---", "", "Body here."].join("\n")
    );
    expect(meta.title).toBe("IEC 62443: A Guide");
    expect(meta.meta_title).toBe("Zones & Conduits | OXOT");
    expect(meta.published).toBe("true");
    expect(body).toBe("Body here.");
  });

  it("strips matching single or double quotes around a value", () => {
    const { meta } = parseFrontmatter(['---', 'title: "Quoted Title"', "excerpt: 'Single quoted'", "---", "x"].join("\n"));
    expect(meta.title).toBe("Quoted Title");
    expect(meta.excerpt).toBe("Single quoted");
  });

  it("returns the whole input as body when there is no frontmatter", () => {
    const { meta, body } = parseFrontmatter("Just content, no frontmatter.");
    expect(Object.keys(meta)).toHaveLength(0);
    expect(body).toBe("Just content, no frontmatter.");
  });

  it("ignores lines without a colon", () => {
    const { meta } = parseFrontmatter(["---", "title: Ok", "this-has-no-colon", "---", "b"].join("\n"));
    expect(meta.title).toBe("Ok");
    expect(meta["this-has-no-colon"]).toBeUndefined();
  });
});
