#!/usr/bin/env bash

dir_name="$(basename "$PWD")"

if tmux has-session -t "$dir_name" 2>/dev/null; then
  tmux attach-session -t "$dir_name"
else
  tmux new -s "$dir_name" "$SHELL"
fi
