set -euo pipefail
 
if [ "$#" -eq 0 ]; then
  echo "Usage: $0 <change-id> [change-id ...]" >&2
  exit 1
fi
 
bookmarks=()
 
for change in "$@"; do
  bookmark=$(jj bookmark list -r "$change" 2>/dev/null | head -n1 | cut -d: -f1)
 
  if [ -z "$bookmark" ]; then
    jj git push --change "$change" 2>/dev/null
 
    bookmark=$(jj bookmark list -r "$change" 2>/dev/null \
      | grep -oE '^push-[a-zA-Z0-9]+' | head -n1 || true)
  fi
 
  if [ -z "$bookmark" ]; then
    echo "Error: could not find or create a bookmark for change $change" >&2
    exit 1
  fi
 
  bookmarks+=("$bookmark")
done
 
gh stack link "${bookmarks[@]}"
