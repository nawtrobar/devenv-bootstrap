---
description: Systematically debug a problem by tracing root cause before suggesting fixes
allowed-tools: Glob, Grep, Read, Bash, LS, WebSearch
---

Debug the following issue: $ARGUMENTS

## Approach

Work through these steps in order — do not jump to a fix before completing diagnosis.

1. **Reproduce** — run the failing command or test if possible. Capture exact error output.

2. **Locate** — find the relevant code using Grep/Glob. Trace the execution path from the entry point to where the error occurs.

3. **Hypothesize** — list 2-3 possible root causes, ranked by likelihood. For each, note what evidence would confirm or rule it out.

4. **Verify** — check the evidence for each hypothesis. Read relevant code, check types, look at recent git changes (`git log -p --follow <file>`).

5. **Root cause** — state the confirmed root cause in one sentence.

6. **Fix** — propose the minimal change that addresses the root cause. Do not refactor or clean up unrelated code.

7. **Validate** — run tests or re-run the failing step to confirm the fix works.
