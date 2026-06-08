---
description: Plan and implement a sprint of features. Pass a list of features/stories as arguments, or point to a file. Tech-lead sequences and sizes them, then each feature is implemented via the full autonomous task flow.
allowed-tools: Glob, Grep, Read, Edit, Write, Bash(git log:*), Bash(git status:*), Bash(git diff:*), Bash(git checkout:*), Bash(git add:*), Bash(git commit:*), Bash(git push:*), Bash(gh pr create:*), Bash(gh pr view:*), Bash(gh pr list:*), Agent, TodoWrite
---

# Sprint execution

Features to implement: **$ARGUMENTS**

(If $ARGUMENTS is a file path, read it. If it's a comma-separated list, treat each item as a feature. If it's a freeform description, extract the distinct features from it.)

---

## Phase 0 — Branch

Create a sprint branch before writing any code:

```bash
git checkout -b sprint/<short-description>
```

Derive the name from the sprint scope: 2–4 words (e.g. `sprint/user-auth-and-profiles`). If already on a non-main/master branch, skip this step.

---

## Phase 1 — Sprint planning (tech-lead)

Invoke the `tech-lead` agent with all features and the instruction to produce a **sprint plan**:

```
Analyze the following features against the current codebase and produce a sprint plan:

<features list>

For each feature:
1. Size it: XS (<2h), S (half-day), M (full day), L (2+ days)
2. Identify dependencies between features (which must be done first)
3. Identify shared infrastructure that should be built once (shared components, DB migrations, auth middleware) vs feature-specific work
4. Sequence them: shared infrastructure first, then features in dependency order, parallel where possible

Output format:
## SPRINT PLAN
### Shared infrastructure (build first)
- <list>

### Feature sequence
1. <Feature A> [S] — no dependencies
2. <Feature B> [M] — depends on Feature A (needs its API)
3. <Feature C> [XS] — independent, can parallelize with B
...

### Risks
- <anything that could block the sprint>
```

---

## Phase 2 — Shared infrastructure

If the tech-lead identified shared infrastructure, implement it first using **phases 1–5 of the task flow** (tech-lead → engineers → QA → security → final review). Skip task Phase 0 (branch already exists) and task Phase 6 (no per-feature PR — the sprint PR is created in Phase 4).

Commit the shared infrastructure before moving to features.

---

## Phase 3 — Feature implementation

For each feature in the sequence:

1. Run **phases 1–5 of the task flow** for that feature (tech-lead → engineers → QA → security → final review). Skip task Phase 0 (branch already exists) and task Phase 6 (no per-feature PR).
2. Commit the feature when complete (conventional commit: `feat: <feature name>`)
3. Proceed to the next feature

For features the tech-lead marked as parallelizable: note them as candidates for parallel branches but implement sequentially unless the user has indicated otherwise.

---

## Phase 4 — Push and PR

After all features are committed:

1. Launch the code-reviewer sub-agent against the full sprint diff (before opening the PR so findings can go in the body).
2. Push the sprint branch and create a PR:
   ```bash
   git push -u origin HEAD
   gh pr create --title "sprint: <short-description>" --body "..."
   ```
   PR body: table of features shipped + code-reviewer findings from step 1 + test plan checklist.
3. End your response with the sprint summary below followed by the PR URL on its own line:

```
## Sprint summary: <description>

### Features shipped
| Feature | Size | Engineers | Tests | Security |
|---------|------|-----------|-------|---------|
| <name>  | S    | backend, frontend | +12 tests | PASS |
| ...

### Review results
- Code quality: <N Critical fixed, N Important fixed, N Minor deferred>
- Security: PASS / BLOCK-then-fixed (<summary>)

### Total changes
<git diff --stat from sprint start to now>

### Deferred / not completed
<anything that was too large, blocked, or explicitly deferred>

### Suggested follow-up
<tech debt, follow-on features, or risks to address next sprint>
```

4. Await user review — do not claim the sprint complete until the user has reviewed.

---

## Rules
- Create a branch (Phase 0) before writing any code
- Commit after each feature so the git log tells the story of the sprint
- If a feature turns out to be L or XL during implementation, surface this immediately rather than letting it run indefinitely
- Don't start the next feature if the current one has unresolved security blocks or failing tests
