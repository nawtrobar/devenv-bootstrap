---
name: finishing-a-development-branch
description: Use when a feature branch is complete and ready to merge, push, or close — when the user says they're done with a feature, wants to merge their work, wants to open a PR, or wants to clean up after development. Verifies tests pass first, detects workspace state, presents merge/PR/keep/discard options, and handles worktree cleanup correctly based on provenance.
---

# Finishing a Development Branch

## Step 1: Verify tests pass

Run the full test suite before offering any options:

```bash
npm test / cargo test / pytest / go test ./...
```

**If tests fail:**
```
Tests failing (<N> failures). Fix before completing:

<show failures>

Cannot merge or create PR until tests pass.
```

Stop. Do not proceed to Step 2 until tests pass.

## Step 2: Detect workspace state

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
BRANCH=$(git branch --show-current)
```

- `GIT_DIR == GIT_COMMON`: normal repo → 4-option menu
- `GIT_DIR != GIT_COMMON`, named branch: linked worktree → 4-option menu (with cleanup)
- `GIT_DIR != GIT_COMMON`, detached HEAD: externally managed → 3-option menu (no local merge)

## Step 3: Determine base branch

```bash
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null
```

If ambiguous, ask: "This branch split from `main` — is that correct?"

## Step 4: Present options

**Normal repo or named-branch worktree:**
```
Tests passing. Implementation complete. What would you like to do?

1. Merge to <base-branch> locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)
4. Discard this work

Which option?
```

**Detached HEAD:**
```
Tests passing. You're on a detached HEAD (externally managed workspace).

1. Push as new branch and create a Pull Request
2. Keep as-is (I'll handle it later)
3. Discard this work

Which option?
```

## Step 5: Execute

### Option 1 — Merge locally
```bash
MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
cd "$MAIN_ROOT"
git checkout <base-branch> && git pull
git merge <feature-branch>
<run tests again — verify merged result is clean>
```
Then remove worktree (Step 6), then delete branch: `git branch -d <feature-branch>`

### Option 2 — Push and create PR
```bash
git push -u origin <feature-branch>
gh pr create --title "<title>" --body "$(cat <<'EOF'
## Summary
<2-3 bullets of what changed>

## Test plan
- [ ] <verification steps>
EOF
)"
```
After creating the PR:
1. Launch the code-reviewer as a sub-agent against the PR diff.
2. End your response with the PR URL on its own line.
3. Await the review result, surface it to the user, then stop — do not claim the task complete until the user has reviewed.

**Do NOT remove the worktree** — it's needed for PR iteration.

### Option 3 — Keep as-is
Report: "Branch `<name>` kept. Worktree preserved at `<path>`."
Do not remove worktree.

### Option 4 — Discard
Confirm first:
```
This permanently deletes:
- Branch <name>
- All commits: <list>
- Worktree at <path>

Type 'discard' to confirm.
```
Wait for the exact word "discard". Then: remove worktree (Step 6), then `git branch -D <feature-branch>`.

## Step 6: Worktree cleanup (Options 1 and 4 only)

```bash
WORKTREE_PATH=$(git rev-parse --show-toplevel)
```

- If path is under `.worktrees/`, `worktrees/`, or `~/.config/superpowers/worktrees/`: we created it, we remove it
  ```bash
  MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
  cd "$MAIN_ROOT"
  git worktree remove "$WORKTREE_PATH"
  git worktree prune
  ```
- If path is elsewhere: the harness owns it — do NOT remove it

## Rules

- Never merge or PR with failing tests
- Never delete work without typed "discard" confirmation
- Never force-push without explicit request
- Remove worktree AFTER merge succeeds, not before
- Only clean up worktrees we created (provenance check above)
- Always `cd` to main repo root before `git worktree remove`
