#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Usage: notes <name>"
  exit 1
fi

nvim "scp://notes@thirver//home/notes/$1.txt"
