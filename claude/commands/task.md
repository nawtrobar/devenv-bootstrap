---
description: Autonomously complete a development task end-to-end by delegating to specialist engineers. The tech-lead plans the work, engineers implement in dependency order, then QA and security review before a final code-review pass.
allowed-tools: Glob, Grep, Read, Edit, Write, Bash, Agent, TodoWrite
---

# Autonomous task execution

Complete the following task end-to-end: **$ARGUMENTS**

---

## Phase 1 — Planning (tech-lead)

Invoke the `tech-lead` agent with:
- The task description above
- Instruction to read the codebase and produce a DELEGATION PLAN in the format defined in its system prompt

Parse the plan output to extract:
- Which engineers are needed (frontend, backend, devops, qa, security — or a subset)
- What each engineer's specific scope and "done when" criteria are
- The execution order and dependencies

If the tech-lead says the task is too ambiguous, surface its questions to the user and stop.

---

## Phase 2 — Implementation (engineers in dependency order)

Use the execution order from the plan. The standard order is:

1. **backend-engineer** (if needed) — pass: the task scope + "Done when" criteria + instruction to output API contracts
2. **frontend-engineer** (if needed) — pass: the task scope + the API contracts from step 1
3. **devops-engineer** (if needed) — pass: the task scope + what was built in steps 1-2

After each engineer completes, read their output report before proceeding to the next.

If an engineer surfaces a blocker or open question that prevents another engineer from starting, pause and resolve it before continuing.

---

## Phase 3 — Quality gate

4. **qa-engineer** — pass: the QA scope from the plan + the API contracts + list of components built. Instruction: run the test suite, write missing tests, report any bugs found.

   - If QA finds bugs: invoke the appropriate engineer (backend or frontend) to fix them, then re-run QA.

5. **security-engineer** — pass: instruction to review all changes made during this task for security issues.

   - If security verdict is BLOCK: invoke the appropriate engineer to fix critical/high findings, then re-run security review.

---

## Phase 4 — Final review

6. **code-reviewer** — pass: instruction to review the full diff (`git diff main..HEAD` or the appropriate base) for correctness bugs, security issues, and simplification opportunities.

---

## Phase 5 — Summary

After all phases complete, output a concise summary:

```
## Task complete: <task title>

### What was built
<2-4 bullet points describing the user-visible or system-level changes>

### Engineers involved
- backend-engineer: <one-line summary of what they built>
- frontend-engineer: <one-line summary>
- ...

### Tests added
<count and brief description>

### Security verdict
<PASS / BLOCK-then-fixed, with any notable findings>

### Files changed
<git diff --stat output or equivalent>

### Next steps
<any follow-up items surfaced by engineers, or None>
```

---

## Rules
- Do not skip the security phase for tasks that add endpoints, handle user input, or change auth logic
- Do not mark the task complete if any engineer reported an unresolved blocker
- If the codebase has no test suite, qa-engineer should note this rather than invent one from scratch
- Keep each engineer's prompt self-contained — include all context they need (they don't share memory)
