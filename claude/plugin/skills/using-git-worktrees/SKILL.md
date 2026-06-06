---
name: using-git-worktrees
description: Use when starting isolated feature work in a new branch — when the user wants to work on a feature without affecting the main working tree, or when multiple features should be developed in parallel. Creates a worktree at .worktrees/<branch>, installs dependencies, and verifies a clean test baseline. Also use when the user asks to "isolate" work or "create a branch" for a feature.
---

# Using Git Worktrees

Create an isolated working environment for feature work without disturbing the main repo.

**Core principle:** Detect existing isolation first. Then use native tools. Then fall back to git. Never fight the harness.

## Step 0: Detect existing isolation

Before creating anything, check if we're already in a worktree:

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
git rev-parse --show-superproject-working-tree 2>/dev/null
```

- If `GIT_DIR != GIT_COMMON` and NOT in a submodule: already in an isolated worktree → report the path and branch, skip to Step 3
- If `GIT_DIR == GIT_COMMON`: normal repo → continue to Step 1

## Step 1: Get consent

Ask before creating a worktree:

> "Would you like me to set up an isolated worktree? It protects your current branch from changes."

If the user declines, work in place and skip to Step 3.

## Step 2: Create the worktree

### Step 2a: Check for native tools first

Before using `git worktree add`, check if the environment provides a native worktree tool (e.g., `EnterWorktree`, `/worktree` command, `--worktree` flag). If one exists, use it — native tools handle directory placement and cleanup automatically. Using `git worktree add` when a native tool is available creates state the harness can't track.

Only proceed to Step 2b if no native tool is available.

### Step 2b: Git worktree fallback

#### Directory selection (follow this priority order)

1. **User's declared preference** in instructions — use it without asking
2. **Existing project-local directory:**
   ```bash
   ls -d .worktrees 2>/dev/null   # preferred (dot-hidden)
   ls -d worktrees 2>/dev/null    # alternative
   ```
   If found, use it. If both exist, `.worktrees/` wins.
3. **Existing global directory:**
   ```bash
   project=$(basename "$(git rev-parse --show-toplevel)")
   ls -d ~/.config/superpowers/worktrees/$project 2>/dev/null
   ```
4. **Default:** `.worktrees/` at project root

#### Safety verification (project-local directories only)

**MUST verify directory is gitignored before creating worktree:**

```bash
git check-ignore -q .worktrees 2>/dev/null || echo "NOT ignored"
```

If NOT ignored: add to `.gitignore`, commit the change, then proceed.

Global directories (`~/.config/superpowers/worktrees/`) need no verification.

#### Create the worktree

```bash
BRANCH="<branch-name>"
git worktree add "$LOCATION/$BRANCH" -b "$BRANCH"
cd "$LOCATION/$BRANCH"
```

**Sandbox fallback:** If `git worktree add` fails with a permission error, report that the sandbox blocked worktree creation and continue working in the current directory instead.

## Step 3: Install dependencies

Auto-detect and run:

```bash
[ -f package.json ]      && npm install
[ -f Cargo.toml ]        && cargo build
[ -f requirements.txt ]  && pip install -r requirements.txt
[ -f pyproject.toml ]    && poetry install
[ -f go.mod ]            && go mod download
```

## Step 4: Verify clean baseline

Run the project's test suite:

```bash
npm test / cargo test / pytest / go test ./...
```

**If tests fail:** Report the failures and ask whether to proceed or investigate first. Do NOT proceed silently with a broken baseline — you won't be able to tell new bugs from pre-existing ones.

**If tests pass:** Report ready.

```
Worktree ready at <path>
Tests passing (<N> tests, 0 failures)
Ready to implement: <feature description>
```

## Cleanup note

When work is done, use the finishing-a-development-branch skill to handle merging/PR creation and worktree removal. Don't delete worktrees manually.

## Red flags

- Never create a worktree when Step 0 detects you're already in one
- Never use `git worktree add` when a native tool (EnterWorktree, etc.) is available
- Never skip the `.gitignore` check for project-local directories
- Never proceed with a failing baseline without explicit confirmation
