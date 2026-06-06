---
name: using-git-worktrees
description: Use when starting isolated feature work in a new branch — when the user wants to work on a feature without affecting the main working tree, or when multiple features should be developed in parallel. Creates a worktree at .worktrees/<branch>, installs dependencies, and verifies a clean test baseline. Also use when the user asks to "isolate" work or "create a branch" for a feature.
---

# Using Git Worktrees

Create an isolated working environment for feature work without disturbing the main repo.

## Step 0: Detect existing isolation

Before creating anything, check if we're already in a worktree:

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
git rev-parse --show-superproject-working-tree 2>/dev/null
```

- If `GIT_DIR != GIT_COMMON` and NOT in a submodule: already in an isolated worktree → report the path and branch, skip to Step 3
- If `GIT_DIR == GIT_COMMON`: normal repo → continue to Step 1

## Step 1: Create the worktree

Check the `.worktrees/` directory:

```bash
ls -d .worktrees 2>/dev/null || echo "will create"
git check-ignore -q .worktrees 2>/dev/null || echo "NOT ignored"
```

If `.worktrees/` exists but is **not** gitignored: add it to `.gitignore`, commit, then proceed.

If `.worktrees/` doesn't exist: create it, add to `.gitignore`, commit.

```bash
BRANCH="<branch-name>"
git worktree add .worktrees/$BRANCH -b $BRANCH
cd .worktrees/$BRANCH
```

Report: `Worktree created at .worktrees/$BRANCH on branch $BRANCH`

## Step 2: Install dependencies

Auto-detect and run:

```bash
[ -f package.json ]      && npm install
[ -f Cargo.toml ]        && cargo build
[ -f requirements.txt ]  && pip install -r requirements.txt
[ -f pyproject.toml ]    && poetry install
[ -f go.mod ]            && go mod download
```

## Step 3: Verify clean baseline

Run the project's test suite:

```bash
npm test / cargo test / pytest / go test ./...
```

**If tests fail:** Report the failures and ask whether to proceed or investigate first. Do NOT proceed silently with a broken baseline — you won't be able to tell new bugs from pre-existing ones.

**If tests pass:** Report ready.

```
Worktree ready at .worktrees/<branch>
Tests passing (<N> tests, 0 failures)
Ready to implement: <feature description>
```

## Cleanup note

When work is done, use the finishing-a-development-branch skill to handle merging/PR creation and worktree removal. Don't delete worktrees manually.

## Red flags

- Never create a worktree when Step 0 detects you're already in one
- Never skip the `.gitignore` check — worktree contents getting committed causes hard-to-debug issues
- Never proceed with a failing baseline without explicit confirmation
