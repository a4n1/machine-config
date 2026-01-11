#!/usr/bin/env sh

if [ -n "$TMUX" ]; then
  tmux list-sessions -F '#{session_name}' \
    | fzf \
    | xargs -I {} tmux switch-client -t {}
else
  session="$(tmux list-sessions -F '#{session_name}' | fzf)"

  if [ -n "$session" ]; then
    tmux attach-session -t "$session"
  fi
fi
