---
name: verification-before-completion
description: Use before reporting any task, feature, fix, or implementation as complete or done. Requires running fresh verification — tests, build, command output — and reading the actual results before claiming success. "Should be passing" and "looks correct" are not verification. This applies to every completion claim without exception.
---

# Verification Before Completion

## The Mandate

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

This is not a suggestion. Before saying "done", "fixed", "complete", "working", or any synonym:

1. **Run the verification command** — the actual test suite, build, or check relevant to what was just built
2. **Read the full output** — not just the summary, not just the last line
3. **Count failures yourself** — don't trust "tests passed" banners; read the numbers
4. **Then report** — with the actual output, pass count, and any warnings

---

## What counts as verification

| Claim | Required verification |
|-------|----------------------|
| "Tests pass" | Run the full test suite, read output, report N passing / 0 failing |
| "Bug is fixed" | Run the test that reproduces the bug, confirm it passes; run full suite |
| "Feature works" | Run all tests for the feature; show "how to verify" steps |
| "Build succeeds" | Run the build command, read the output, confirm exit 0 |
| "No regressions" | Run the full test suite after changes, not just affected tests |

---

## What does NOT count as verification

- A previous test run from earlier in the session
- "It looked correct when I read the code"
- "The logic should work"
- "I tested this manually before" (with no record)
- "The same pattern works elsewhere"
- "I'm confident this is right"
- Running only the tests you just wrote (run the full suite)
- Seeing a green checkmark in passing output without reading the failure count

---

## Verification report format

After running verification, report:

```
Verification:
  Command: npm test (or pytest, cargo test, etc.)
  Result: 47 passing, 0 failing
  Duration: 3.2s
```

If there are failures, list them — do not skip or summarize away. Fix them before claiming done.

---

## Special cases

### "I can't run the tests" (missing environment, credentials, etc.)
Say so explicitly: "I cannot verify — [reason]. The implementation should be correct but has not been run."

Do NOT claim it works. Let the user decide whether to trust an unverified implementation.

### Test suite takes too long
Run the focused suite for the changed code, then run the full suite. Report both results separately. Do not skip the full suite.

### UI / frontend changes
If the test suite passes but the feature is visual:
1. Run the test suite (required)
2. State explicitly: "The test suite passes but I was unable to verify the UI in a browser."

Do not claim the feature works visually without visual verification.
