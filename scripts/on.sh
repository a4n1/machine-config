#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <file>"
  exit 1
fi

INPUT="$1"

FILE="$INPUT"
LINE=""
COL=""

if [[ "$INPUT" =~ ^([^:]+):([0-9]+):([0-9]+)$ ]]; then
  FILE="${BASH_REMATCH[1]}"
  LINE="${BASH_REMATCH[2]}"
  COL="${BASH_REMATCH[3]}"
elif [[ "$INPUT" =~ ^([^:]+):([0-9]+)$ ]]; then
  FILE="${BASH_REMATCH[1]}"
  LINE="${BASH_REMATCH[2]}"
fi

if [ ! -f "$FILE" ]; then
  echo "Error: file does not exist $FILE"
  exit 1
fi

if [ -z "${TMUX:-}" ]; then
  echo "Error: not inside a tmux session"
  exit 1
fi

if [ -z "$EDITOR" ]; then
  echo "Error: \$EDITOR is not set"
  exit 1
fi

CURRENT_SESSION="$(tmux display-message -p '#{session_name}')"

TARGET_PANE=$(
  tmux list-panes -a -F '#{pane_id} #{pane_current_command} #{session_name}' |
    awk -v editor="$EDITOR" -v session="$CURRENT_SESSION" '
      $2 == editor && $3 == session { print $1; exit }
    '
)

if [ -z "$TARGET_PANE" ]; then
  echo "No pane running $EDITOR found in this tmux session"
  exit 1
fi

if [ -n "$LINE" ] && [ -n "$COL" ]; then
  tmux send-keys -t "$TARGET_PANE" \
    Escape ":e $(printf '%q' "$FILE") | call cursor($LINE,$COL)" Enter
elif [ -n "$LINE" ]; then
  tmux send-keys -t "$TARGET_PANE" \
    Escape ":e $(printf '%q' "$FILE") | $LINE" Enter
else
  tmux send-keys -t "$TARGET_PANE" \
    Escape ":e $(printf '%q' "$FILE")" Enter
fi

PANE_TARGET="$(tmux display-message -p -t "$TARGET_PANE" '#{session_name}:#{window_index}.#{pane_index}')"
tmux switch-client -t "${PANE_TARGET%%:*}"
tmux select-window -t "${PANE_TARGET%.*}"
tmux select-pane -t "$PANE_TARGET"
