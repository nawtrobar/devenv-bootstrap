---
name: subagent-driven-development
description: Use for complex multi-component tasks that benefit from parallel specialist work — when a task touches both frontend and backend, requires QA and security review, or is large enough that delegation to specialist engineers would be faster and more thorough than doing it inline. Orchestrates: tech-lead plans → engineers implement → two-stage review per engineer (spec compliance then code quality) → QA → security → final review.
---

# Subagent-Driven Development

Delegate a task to specialist sub-agents for parallel, reviewed implementation.

## Verification mandate

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

Before marking any phase complete: run the relevant command, read the full output, then report.

---

## Phase 1 — Planning (tech-lead)

Invoke the `tech-lead` agent with the task description and codebase context. It produces a DELEGATION PLAN with:
- Which engineers are needed and in what order
- Each engineer's specific scope and "done when" criteria
- Explicit API contracts and interfaces that downstream engineers depend on

If tech-lead says the task is too ambiguous: surface its questions and stop. Do not proceed with an ambiguous plan.

---

## Phase 2 — Implementation with two-stage review

For each engineer in the execution order from the plan:

### 2a. Engineer implements
Pass: scoped task description + "done when" criteria + any upstream contracts from prior engineers.

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

---

## Phase 3 — QA

Invoke `qa-engineer` with:
- QA scope from the plan
- API contracts from backend engineer
- Component list from frontend engineer
- Instruction to run the test suite, write missing tests, and report any bugs found

**If QA finds bugs:** Send each bug to the appropriate engineer, have them fix it using TDD discipline, then re-run QA.

**Verify:** Run the test suite after QA completes. Read the output. Report actual pass count.

---

## Phase 4 — Security

Invoke `security-engineer` with:
- Instruction to review all changes made during this task
- Focus: new endpoints, auth changes, user input handling, data exposure

**If security verdict is BLOCK:** Send Critical/High findings to the appropriate engineer, have them fix, then re-run security review.

---

## Phase 5 — Final review

Invoke `code-reviewer` for a final pass on the full diff since the task began:
```bash
git diff <sha-before-task>..HEAD
```

---

## Phase 6 — Summary

Run fresh verification, then report:

```
## Task complete: <task title>

### Verification
Tests: <N> passing, 0 failing (run <timestamp>)

### What was built
<2-4 bullets>

### Engineers
- backend-engineer: <one-line>
- frontend-engineer: <one-line>

### Review results
- Spec compliance: passed for all engineers
- Code quality: <N Critical fixed, N Important fixed, N Minor deferred>
- Security: PASS

### Files changed
<git diff --stat>
```

---

## Rules

- Never skip the security phase for tasks that add endpoints, handle user input, or change auth
- Two-stage review is per-engineer — not just at the end
- Spec compliance must pass before code quality review starts
- Fresh test run required before claiming the task is done
