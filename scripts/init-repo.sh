#!/usr/bin/env bash
# Create + push the OXOT repo. Run AFTER `gh auth login` as Planet9v.
set -euo pipefail

OWNER="Planet9v"
REPO="OXOT-Website-JULY2026"

command -v gh >/dev/null || { echo "gh not installed"; exit 1; }
gh auth status >/dev/null || { echo "Run: gh auth login  (as $OWNER)"; exit 1; }

# Initialize the repo FIRST so the secret check below can consult .gitignore.
git init -b main 2>/dev/null || true
git config user.email >/dev/null 2>&1 || git config user.email "mckenneyengineers@gmail.com"
git config user.name  >/dev/null 2>&1 || git config user.name  "Jim McKenney"

# Safety: refuse to run if the real secret file is NOT ignored.
if ! git check-ignore -q .env.local; then
  echo "WARNING: .env.local is NOT gitignored — aborting to avoid leaking secrets." >&2
  exit 1
fi

git add -A
git commit -m "chore: initial project scaffold" || echo "nothing to commit"

if gh repo view "$OWNER/$REPO" >/dev/null 2>&1; then
  git remote add origin "https://github.com/$OWNER/$REPO.git" 2>/dev/null || true
  git push -u origin main
else
  gh repo create "$OWNER/$REPO" --public --source=. --remote=origin --push
fi

# Enable secret-scanning push protection (public repo)
gh api -X PATCH "repos/$OWNER/$REPO" \
  -f security_and_analysis='{"secret_scanning":{"status":"enabled"},"secret_scanning_push_protection":{"status":"enabled"}}' \
  >/dev/null 2>&1 || echo "Note: enable secret scanning in repo Settings if the API call was skipped."

echo "Done: https://github.com/$OWNER/$REPO"
