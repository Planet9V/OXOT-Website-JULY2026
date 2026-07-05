# syntax=docker/dockerfile:1
# Multi-stage: `dev` (used by docker-compose for Claude Code + Next.js dev),
# `builder` compiles the app, `runner` is the slim production image pushed to GHCR.

########## base ##########
FROM node:22-bookworm-slim AS base
WORKDIR /workspace
ENV NODE_ENV=development

########## dev ##########
FROM base AS dev
# Core dev tools from Debian mirrors (required).
RUN apt-get update && apt-get install -y --no-install-recommends git curl ca-certificates gnupg \
 && rm -rf /var/lib/apt/lists/*
# GitHub CLI (optional convenience). Best-effort: a flaky external repo must NOT break the build.
# gh is also available on the host, so the container not having it is non-fatal.
RUN ( set -e; install -d -m 0755 /etc/apt/keyrings \
 && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null \
 && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
 && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list \
 && apt-get update && apt-get install -y --no-install-recommends gh \
 && rm -rf /var/lib/apt/lists/* ) \
 || echo "WARN: GitHub CLI (gh) install skipped in container — use gh on the host instead."
# Claude Code CLI + Valyu skills CLI available in the dev container
RUN npm install -g @anthropic-ai/claude-code || true
# NOTE: secrets are injected at runtime via env_file — never baked in here.

########## builder ##########
FROM base AS builder
COPY package*.json ./
RUN npm ci || npm install
COPY . .
RUN npm run build || echo "no build script yet"

########## runner (production, -> GHCR) ##########
FROM node:22-bookworm-slim AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /workspace/ ./
EXPOSE 3000
CMD ["npm", "run", "start"]
