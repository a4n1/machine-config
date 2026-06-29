#!/usr/bin/env bash
set -euo pipefail

REV="${1:-@}"

BRANCH=$(jj log -r "$REV" --no-graph -T 'bookmarks' | tr -d ' \n')

if [ -z "$BRANCH" ]; then
  echo "Warning: no bookmark found for revset '$REV'" >&2
  exit 1
fi

gh pr view "$BRANCH" --web 2>/dev/null || gh pr create --head "$BRANCH" --web
