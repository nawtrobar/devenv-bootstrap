---
description: Enforce the RED-GREEN-REFACTOR TDD cycle for a specific feature or bugfix. Write the failing test first, watch it fail, write minimal code to pass, verify, then refactor. Use before writing any implementation code.
allowed-tools: Glob, Grep, Read, Edit, Write, Bash
---

# TDD: $ARGUMENTS

## The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

If you wrote code before the test: delete it. Start over. No exceptions — not "keep as reference", not "adapt it while writing tests". Delete means delete.

## RED-GREEN-REFACTOR cycle

Repeat this cycle for each behavior to implement.

---

### RED — Write one failing test

Write the simplest test that describes the desired behavior.

Good test:
```
- Tests one specific behavior
- Name describes what it tests ("rejects empty email", "retries 3 times on failure")
- Tests real code, not mocks (avoid mocks unless the dependency is external I/O)
```

Bad test:
```
- Vague name ("test1", "it works")
- Tests mock behavior instead of real behavior
- Tests multiple things at once ("validates and submits and redirects")
```

---

### Verify RED — Watch it fail (MANDATORY, never skip)

Run the test. Confirm:
- It fails (not errors out — a compilation error means fix the error first)
- The failure message says what you expect ("function not defined", "expected X got Y")
- It fails because the feature is missing, not because of a typo

If the test passes immediately: you are testing existing behavior. Fix the test.

```bash
# Example — use your project's actual test command
npm test path/to/test.test.ts
pytest tests/test_feature.py::test_specific_behavior -v
cargo test test_name
```

---

### GREEN — Write minimal code to pass

Write the simplest possible implementation that makes the test pass. Nothing more.

- No extra parameters "for future use"
- No configuration options not tested
- No "while I'm here" improvements
- YAGNI: you aren't gonna need it

---

### Verify GREEN — Watch it pass (MANDATORY)

Run the full test suite, not just the new test.

Confirm:
- New test passes
- All existing tests still pass
- No errors or warnings in output

If existing tests fail: fix them before continuing. Do not move to Refactor with a broken suite.

---

### REFACTOR — Clean up (only after GREEN)

Now improve the code without changing behavior:
- Remove duplication
- Improve names
- Extract helpers or constants
- Improve readability

After every refactor step: run tests. Stay green.

---

### Repeat

Move to the next behavior. Write the next failing test.

---

## Rationalizations to reject

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Simple code breaks. Test takes 30 seconds. |
| "I'll add tests after" | Tests after pass immediately — they prove nothing. |
| "I already manually tested it" | Manual tests have no record, can't re-run, miss edge cases. |
| "Keep the code as reference while writing tests" | You'll adapt it. That's testing after. Delete it. |
| "TDD will slow me down" | TDD is faster than debugging. Debugging is the slow path. |
| "Deleting X hours of work is wasteful" | Sunk cost. Keeping untested code is the real waste. |

## Red flags — stop and restart from RED

- Code exists before any test was written
- Test passed on first run without any implementation
- You can't explain exactly why the test failed
- Tests are being added "to get to 80% coverage" not to drive design
- "I'm being pragmatic" appears in your internal monologue

## Bug fix pattern

Bug found → write failing test that reproduces it → follow RED-GREEN-REFACTOR → the test prevents regression.

Never fix a bug without a test that would have caught it.

## Verification checklist before marking done

- [ ] Every new function/method has a test that was written first
- [ ] Watched each test fail before implementing
- [ ] Each test failed for the expected reason
- [ ] Wrote the minimal code to pass each test
- [ ] All tests pass, suite is clean
- [ ] No mocks unless the dependency is external I/O
- [ ] Edge cases and error paths are covered
