---
description: Push the current branch and open a GitHub pull request
allowed-tools: Bash(git status:*), Bash(git log:*), Bash(git diff:*), Bash(git push:*), Bash(gh pr create:*), Bash(gh pr view:*)
---

Push the current branch and open a pull request.

1. Run `git status` and `git log main..HEAD --oneline` to see what's going out.
2. Push the branch: `git push -u origin HEAD`
3. Summarize ALL commits in the branch (not just the latest) to draft the PR body.
4. Create the PR with `gh pr create`:
   - Title: concise, ≤70 chars, imperative mood
   - Body: brief bullet summary + test plan checklist
5. Launch the code-reviewer agent in the background against the PR diff.
6. End your response with the PR URL on its own line so the user can navigate directly to it.

If the branch is already pushed and a PR exists, open it with `gh pr view --web` instead.
