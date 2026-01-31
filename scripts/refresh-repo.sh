#!/usr/bin/env bash
set -euo pipefail

# Navigate to repo root
cd "$(dirname "$0")/.."

UPSTREAM_URL="https://github.com/openclaw/openclaw.git"
UPSTREAM_REMOTE="upstream"

printf "🔍 Checking for upstream remote...\n"

# Check if upstream remote exists
if ! git remote get-url "$UPSTREAM_REMOTE" >/dev/null 2>&1; then
  printf "➕ Adding upstream remote: $UPSTREAM_URL\n"
  git remote add "$UPSTREAM_REMOTE" "$UPSTREAM_URL"
else
  CURRENT_URL=$(git remote get-url "$UPSTREAM_REMOTE")
  printf "✓ Upstream remote exists: $CURRENT_URL\n"

  # Update URL if it doesn't match
  if [ "$CURRENT_URL" != "$UPSTREAM_URL" ]; then
    printf "🔧 Updating upstream URL to: $UPSTREAM_URL\n"
    git remote set-url "$UPSTREAM_REMOTE" "$UPSTREAM_URL"
  fi
fi

printf "\n📥 Fetching from upstream...\n"
git fetch "$UPSTREAM_REMOTE"

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)
printf "\n📍 Current branch: $CURRENT_BRANCH\n"

# Check for uncommitted changes
if ! git diff-index --quiet HEAD -- 2>/dev/null; then
  printf "\n⚠️  Warning: You have uncommitted changes.\n"
  printf "Please commit or stash your changes before merging.\n"
  exit 1
fi

printf "\n🔀 Merging upstream/main into $CURRENT_BRANCH...\n"
if git merge "$UPSTREAM_REMOTE/main" --no-edit; then
  printf "\n✅ Successfully merged upstream changes!\n"
else
  printf "\n❌ Merge failed. Please resolve conflicts manually.\n"
  exit 1
fi

printf "\n📊 Summary:\n"
git log --oneline HEAD~5..HEAD 2>/dev/null || git log --oneline -5

printf "\n💡 Tip: Run 'git push' to push the merged changes to your fork.\n"
