#!/usr/bin/env bash
# PreToolUse(Bash) guard: refuse operations that land work on the default branch
# (main/master) — commit, merge, rebase, or push — while it is checked out.
# Enforces the rule "all changes land on a review branch; the human integrates."
# Exit code 2 blocks the tool call and feeds stderr back to Claude.

input=$(cat)

# Extract the Bash command being run (with or without jq).
if command -v jq >/dev/null 2>&1; then
  cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')
else
  cmd=$(printf '%s' "$input" \
    | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' \
    | sed 's/.*"command"[[:space:]]*:[[:space:]]*"//; s/"$//')
fi

# Only intervene on git operations that advance/integrate a branch.
case "$cmd" in
  *git*commit*|*git*merge*|*git*rebase*|*git*push*) ;;
  *) exit 0 ;;
esac

# Allow explicit opt-outs (amend/rebase fixups occasionally need it) via env var.
[ "${ALLOW_MAIN_COMMIT:-0}" = "1" ] && exit 0

# symbolic-ref resolves the branch name even on an unborn branch (fresh repo,
# before the first commit), which rev-parse does not.
branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --abbrev-ref HEAD 2>/dev/null)

if [ "$branch" = "main" ] || [ "$branch" = "master" ]; then
  echo "BLOCKED: refusing to commit/merge/rebase/push on '$branch'." >&2
  echo "Work goes on a review branch; the human integrates to the mainline." >&2
  echo "Create one first:  git switch -c <descriptive-name>" >&2
  echo "(Override a single call with ALLOW_MAIN_COMMIT=1 — rarely needed.)" >&2
  exit 2
fi

exit 0
