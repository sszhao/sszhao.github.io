#!/usr/bin/env bash
set -euo pipefail

# ── Push to deploy ──
# Commits all changes and pushes to trigger GitHub Actions deploy
#
# Usage:
#   ./push.sh                # auto-generates commit message
#   ./push.sh "My message"   # custom commit message

cd "$(git rev-parse --show-toplevel)"

# Check for changes
if git diff --quiet && git diff --cached --quiet; then
  echo "Nothing to commit."
  exit 0
fi

# Generate commit message
if [ -n "${1:-}" ]; then
  MSG="$1"
else
  # Auto-detect from newest post
  NEWEST=$(ls -t _posts/*.md 2>/dev/null | head -1)
  if [ -n "$NEWEST" ]; then
    TITLE=$(awk -F': *' '/^title:/{gsub(/"/,"");print $2}' "$NEWEST")
    MSG="Add blog: $TITLE"
  else
    MSG="Update site"
  fi
fi

git add -A
git commit -m "$MSG"
git push origin master

echo ""
echo "Pushed! Check https://www.shengdongzhao.com in ~2 minutes."
