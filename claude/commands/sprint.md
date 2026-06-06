---
description: Plan and implement a sprint of features. Pass a list of features/stories as arguments, or point to a file. Tech-lead sequences and sizes them, then each feature is implemented via the full autonomous task flow.
allowed-tools: Glob, Grep, Read, Write, Bash(git log:*), Bash(git status:*), Bash(git diff:*), Agent, TodoWrite
---

# Sprint execution

Features to implement: **$ARGUMENTS**

(If $ARGUMENTS is a file path, read it. If it's a comma-separated list, treat each item as a feature. If it's a freeform description, extract the distinct features from it.)

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

If the tech-lead identified shared infrastructure, implement it first using the `/task` flow (invoke tech-lead → engineers → QA → security → review).

Commit the shared infrastructure before moving to features.

---

## Phase 3 — Feature implementation

For each feature in the sequence:

1. Run the full `/task` flow for that feature
2. Commit the feature when complete (conventional commit: `feat: <feature name>`)
3. Proceed to the next feature

For features the tech-lead marked as parallelizable: note them as candidates for parallel branches but implement sequentially unless the user has indicated otherwise.

---

## Phase 4 — Sprint summary

After all features are complete:

```
## Sprint complete

### Features shipped
| Feature | Size | Engineers | Tests | Security |
|---------|------|-----------|-------|---------|
| <name>  | S    | backend, frontend | +12 tests | PASS |
| ...

### Total changes
<git diff --stat from sprint start to now>

### Deferred / not completed
<anything that was too large, blocked, or explicitly deferred>

### Suggested follow-up
<tech debt, follow-on features, or risks to address next sprint>
```

---

## Rules
- Commit after each feature so the git log tells the story of the sprint
- If a feature turns out to be L or XL during implementation, surface this immediately rather than letting it run indefinitely
- Don't start the next feature if the current one has unresolved security blocks or failing tests
