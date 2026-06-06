---
name: systematic-debugging
description: Use when investigating a bug, unexpected behavior, test failure, error message, or broken feature. Enforces root-cause investigation before proposing any fix: read the full error, reproduce it consistently, trace the data flow, find working comparisons, then form one hypothesis and test minimally. Hard stop after 3 failed attempts — architectural discussion required before attempt 4.
---

# Systematic Debugging

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you haven't completed Phase 1, you cannot propose fixes. "Quick fix first, then investigate" is how debugging sessions turn into 3-hour thrashing sessions.

---

## Phase 1: Root cause investigation

**Complete ALL of these before forming a hypothesis:**

**1. Read the error carefully**
- Read stack traces completely — don't skim past line numbers, file paths, error codes
- Error messages often contain the exact solution

**2. Reproduce consistently**
- Can you trigger it reliably? What are the exact steps?
- If not reproducible: gather more data, do not guess

**3. Check recent changes**
- `git log --oneline -20` and `git diff` — what changed that could cause this?
- New dependencies, config changes, environmental differences

**4. Gather evidence in multi-component systems**

If the system has multiple layers (API → service → database, CI → build → deploy):

Add diagnostic instrumentation at each boundary BEFORE proposing fixes:
```
For each component boundary:
  - Log what data enters the component
  - Log what data exits the component
  - Check env/config propagation at each layer
  - Check state at each layer

Run once to see WHERE it breaks, then investigate that specific component.
```

This takes 15 minutes. Skipping it takes 3 hours.

**5. Trace data flow**
- Where does the bad value originate?
- What called this with the bad value?
- Keep tracing up the call stack until you find the source
- Fix at the source, not at the symptom

---

## Phase 2: Pattern analysis

**Before forming a fix hypothesis:**

1. Find working examples — locate similar working code in the same codebase
2. Compare against references — if implementing a pattern, read the reference completely (not skimming)
3. Identify differences — list every difference between working and broken, however small
4. Understand dependencies — what environment, config, or state assumptions does this code make?

---

## Phase 3: Hypothesis and testing

1. **Form one specific hypothesis** — "I think X is the root cause because Y." Write it down.
2. **Test minimally** — make the smallest possible change to test the hypothesis. One variable at a time.
3. **Verify before continuing** — did it work? Yes → Phase 4. No → form a NEW hypothesis. Do NOT add more fixes on top of a fix that didn't work.
4. **If you don't know** — say "I don't understand X." Do not pretend to know. Research or ask.

---

## Phase 4: Implementation

1. **Write a failing test** — simplest automated test that reproduces the bug. Use TDD discipline.
2. **Implement the single fix** — address the root cause identified in Phase 1. One change. No "while I'm here" improvements.
3. **Verify the fix** — run tests. Does the failing test now pass? Do all other tests still pass?

### Hard stop at 3 failed attempts

If you have tried 3 fixes and none worked:

**STOP. Do not attempt Fix #4.**

Three failed fixes is a signal of an architectural problem, not a missing detail. Patterns that indicate this:
- Each fix reveals a new problem in a different place
- Fixes require "massive refactoring" to implement properly
- Each fix creates new symptoms elsewhere

Discuss the architecture before attempting more fixes.

---

## Verification before claiming done

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

Before saying "fixed":
1. Run the test that reproduces the original bug — does it pass?
2. Run the full test suite — does everything still pass?
3. THEN claim the fix works.

"Should be fixed now" is not verification. Running the test is verification.

---

## Red flags — stop and return to Phase 1

- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "Add multiple changes, run tests"
- "Skip the test, I'll manually verify"
- "It's probably X, let me fix that" (before completing Phase 1)
- "Here are the main problems: [list of fixes without investigation]"
- "One more fix attempt" after already trying 2+
- Each fix is revealing a new problem in a different place

**All of these mean: return to Phase 1.**
