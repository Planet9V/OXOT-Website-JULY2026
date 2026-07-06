import { describe, it, expect, vi, beforeEach } from "vitest";

// Capture the args passed to pool.query so we can assert the SQL shape + params
// without a live database. vi.hoisted lets the mock factory (which is hoisted to
// the top of the file) reference `query` safely.
const { query } = vi.hoisted(() => ({ query: vi.fn() }));
vi.mock("@/lib/db", () => ({ pool: { query } }));
vi.mock("@/lib/embeddings", () => ({ embed: vi.fn(async () => [0.1, 0.2, 0.3]) }));

import { retrieve } from "@/lib/retrieval";

describe("retrieve", () => {
  beforeEach(() => {
    query.mockReset();
    query.mockResolvedValue({
      rows: [{ id: "7", text: "chunk", page_id: "nis2", score: "0.12" }]
    });
  });

  it("passes a parameterized vector literal, locale, page and k", async () => {
    const out = await retrieve("reporting deadlines", "en", "nis2", 6);

    expect(query).toHaveBeenCalledTimes(1);
    const [sql, params] = query.mock.calls[0];

    // SQL uses parameter placeholders, the cosine operator, locale filter and page boost.
    expect(sql).toContain("<=>");
    expect(sql).toContain("$1::vector");
    expect(sql).toContain("locale = $2");
    expect(sql).toContain("page_id = $3");
    expect(sql).toContain("LIMIT $4");

    // Params: vector literal is a well-formed "[...]" string; then locale, page, k.
    expect(params[0]).toMatch(/^\[.*\]$/);
    expect(params[0]).toBe("[0.1,0.2,0.3]");
    expect(params[1]).toBe("en");
    expect(params[2]).toBe("nis2");
    expect(params[3]).toBe(6);

    // Rows are normalized to numbers/strings.
    expect(out[0]).toEqual({ id: 7, text: "chunk", pageId: "nis2", score: 0.12 });
  });

  it("passes null for the page when none is provided", async () => {
    await retrieve("q", "nl");
    const [, params] = query.mock.calls[0];
    expect(params[1]).toBe("nl");
    expect(params[2]).toBeNull();
    expect(params[3]).toBe(6); // default k
  });
});
