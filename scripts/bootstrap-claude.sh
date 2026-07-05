#!/usr/bin/env bash
# Install Superpowers (obra marketplace) + Valyu skill into the container's Claude Code.
# Requires the `claude` CLI (v2.1.195+) and a logged-in session. Idempotent.
set -euo pipefail

if ! command -v claude >/dev/null 2>&1; then
  echo "claude CLI not found — install @anthropic-ai/claude-code first." >&2
  exit 1
fi

echo "==> Registering Superpowers marketplace (obra)"
claude plugin marketplace add obra/superpowers-marketplace || true

echo "==> Installing Superpowers (project scope)"
claude plugin install superpowers@superpowers-marketplace --scope project || \
  echo "If this failed, run interactively: /plugin install superpowers@superpowers-marketplace"

echo "==> Installing Valyu research skill"
npx --yes skills add valyuAI/skills || echo "Run 'npx skills add valyuAI/skills' manually if this failed."

echo "==> Done. Karpathy rules are already active via CLAUDE.md + .claude/skills/karpathy-guidelines."
