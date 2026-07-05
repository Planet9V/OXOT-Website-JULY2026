---
name: karpathy-guidelines
description: The Karpathy rules for LLM coding. ALWAYS applies in this repo. Use on every coding task — think before coding, simplicity first, surgical changes, goal-driven, and the self-check protocol. On any conflict with other guidance, these win.
---

# Karpathy Guidelines (project law)

Derived from Andrej Karpathy's observations on LLM coding pitfalls (Jan 2026).
**On any conflict, these rules win** (see CLAUDE.md §1).

## Core four
1. **Think before coding.** State assumptions, surface ambiguity, ask instead of guessing.
2. **Simplicity first (YAGNI).** Minimum code that solves the stated problem. No speculative abstractions.
3. **Surgical changes.** Don't touch adjacent code. Every changed line traces to the task.
4. **Goal-driven execution.** Turn vague asks into verifiable success criteria before starting.

## Self-check protocol
5. **Verify before claiming done** — show evidence (tests/output/diff), not assertions.
6. **Report uncertainty** — if unsure, say so and stop; never bluff.
7. **Stop when confused** — looped twice with no progress? halt and re-plan.
8. **Keep a running assumptions list** in the PR description.
9. **Prefer evidence over confidence** — a passing test, not "it should work".
10. **Leave the tree greener** — no new lint/type regressions.

## Apply it
- Before editing: restate the goal + success criteria; list assumptions.
- While editing: keep the diff minimal and on-scope.
- Before "done": run the check that proves it (test, build, `i18n:check`), and paste the result.
