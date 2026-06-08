---
description: Autonomously complete a development task end-to-end. tech-lead plans → engineers implement → two-stage review per engineer (spec then quality) → QA → security → final review. No completion claims without fresh verification evidence.
allowed-tools: Glob, Grep, Read, Edit, Write, Bash, Agent, TodoWrite
---

# Autonomous task: $ARGUMENTS

## Verification mandate

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

Before marking any phase complete: run the relevant command, read the full output, then report. "Should be passing" is not verification.

---

## Phase 0 — Branch

Before writing any code, create a feature branch:

```bash
git checkout -b <kebab-case-task-name>
```

Derive the name from the task description: 3–5 words, kebab-case (e.g. `add-user-profile-page`). If already on a non-main/master branch, skip this step.

---

## Phase 1 — Planning (tech-lead)

Invoke the `tech-lead` agent with the task description and the full codebase context. It will produce a DELEGATION PLAN with:
- Which engineers are needed and in what order
- Each engineer's specific scope and "done when" criteria
- Explicit API contracts and interfaces that downstream engineers depend on

If tech-lead says the task is too ambiguous: surface its questions and stop. Do not proceed with an ambiguous plan.

---

## Phase 2 — Implementation with two-stage review

For each engineer in the execution order from the plan:

### 2a. Engineer implements
Pass: scoped task description + "done when" criteria + any upstream contracts (API shapes, type definitions, component list) from prior engineers.

Engineer reports back with: files changed, contracts produced, how to verify.

### 2b. Spec compliance review (spec-reviewer)
Invoke `spec-reviewer` with:
- The engineer's assigned spec/scope
- The engineer's report
- Instruction to verify independently by reading the actual code

**If spec-reviewer finds issues:** Send findings back to the same engineer to fix, then re-run spec-reviewer. Do not proceed to quality review until spec compliance passes.

### 2c. Code quality review (code-reviewer)
Only invoke after spec compliance passes.

Pass: what was built (from engineer report), the plan/requirements, base SHA before this engineer's work, current HEAD SHA.

**If code-reviewer finds Critical or Important issues:** Send findings back to the engineer to fix, then re-run code-reviewer. Only Minor issues may be deferred.

### Standard execution order
1. `backend-engineer` — no dependencies; outputs API contracts
2. `frontend-engineer` — after backend; consumes contracts
3. `devops-engineer` — after backend; if infra changes needed
4. *(repeat 2a → 2b → 2c for each)*

If an engineer surfaces a blocker that prevents downstream engineers from starting: resolve it before continuing.

---

## Phase 3 — QA

Invoke `qa-engineer` with:
- QA scope from the plan
- API contracts from backend engineer
- Component list from frontend engineer
- Instruction to run the test suite, write missing tests, and report any bugs found

**If QA finds bugs:** Send each bug to the appropriate engineer (backend or frontend), have them fix it using `/tdd` discipline, then re-run QA.

**Verify:** Run the test suite after QA completes. Read the output. Report actual pass count.

---

## Phase 4 — Security

Invoke `security-engineer` with:
- Instruction to review all changes made during this task
- Focus: new endpoints, auth changes, user input handling, data exposure

**If security verdict is BLOCK:** Send Critical/High findings to the appropriate engineer, have them fix, then re-run security review. Only proceed to final review after a PASS verdict.

---

## Phase 5 — Final review

Invoke `code-reviewer` for a final pass on the full diff since the task began:
```bash
git diff <sha-before-task>..HEAD
```

This catches anything the per-engineer reviews missed and confirms the integrated whole is coherent.

---

## Phase 6 — Commit, push, and PR

After all phases complete:

### 6a. Verify
Run the full test suite — read the actual output:
```bash
<test command>
```

### 6b. Commit
Stage and commit all changes with a conventional commit:
```bash
git add -A
git commit -m "feat: <task title in imperative mood>"
```

### 6c. PR
1. Push the branch and create the PR:
   ```bash
   git push -u origin HEAD
   gh pr create --title "<task title>" --body "..."
   ```
   PR body: summary bullets of what was built + test plan checklist.
2. Launch the code-reviewer sub-agent against the full diff.
3. End your response with this summary followed by the PR URL on its own line:

```
## Task summary: <task title>

### Verification
Tests: <N> passing, 0 failing

### What was built
<2-4 bullets>

### Engineers
- backend-engineer: <one-line>
- frontend-engineer: <one-line>
- ...

### Review results
- Spec compliance: passed for all engineers
- Code quality: <N Critical fixed, N Important fixed, N Minor deferred>
- Security: PASS / BLOCK-then-fixed

### Files changed
<git diff --stat from task start to HEAD>

### Follow-up items
<anything deferred, or None>
```

4. Await user review — do not claim the task complete until the user has reviewed.

---

## Rules

- Never skip the security phase for tasks that add endpoints, handle user input, or change auth
- Never mark the task complete if any engineer has an unresolved blocker
- Two-stage review is per-engineer — not just at the end
- Spec compliance must pass before code quality review starts
- Fresh test run required before claiming the task is done
- Always create a branch (Phase 0) before writing any code
