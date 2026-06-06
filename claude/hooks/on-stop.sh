#!/usr/bin/env bash
# Runs after Claude finishes a turn. Prints a brief git summary if in a repo.

if git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  status=$(git status --short 2>/dev/null)
  branch=$(git branch --show-current 2>/dev/null)
  if [ -n "$status" ]; then
    printf '\033[0;33m[git:%s]\033[0m %d changed file(s)\n' \
      "$branch" "$(echo "$status" | wc -l | tr -d ' ')"
  fi
fi
