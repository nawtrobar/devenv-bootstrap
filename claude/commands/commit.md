---
description: Stage all changes and create a conventional commit with a generated message
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git add:*), Bash(git commit:*)
---

Create a conventional commit for the current changes.

1. Run `git status` and `git diff` to understand what changed.
2. Run `git add -A` to stage everything (warn user if any sensitive files like `.env` are staged).
3. Draft a commit message following Conventional Commits format:
   - `feat:` new feature
   - `fix:` bug fix
   - `refactor:` restructuring without behavior change
   - `docs:` documentation only
   - `chore:` tooling, dependencies, config
   - `test:` test additions or changes
   - Subject line: imperative mood, ≤72 chars, no period.
   - Body only if the WHY is non-obvious.
4. Run the commit using a heredoc so formatting is preserved.
5. Show the final `git log --oneline -1` to confirm.
