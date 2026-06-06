---
name: receiving-code-review
description: Use when a code review has been returned with findings that need to be addressed — when the user has received review feedback and needs to work through it systematically. Processes Critical findings first (must fix), then Important (should fix), defers Minor. Re-runs the review after fixes are complete to confirm resolution.
---

# Receiving a Code Review

When review findings come back, address them in order of severity.

## Step 1: Triage the findings

Read every finding before starting work:

- **Critical** — blocking, must fix before merge
- **Important** — should fix, address in this PR unless genuinely deferred
- **Minor** — optional, can defer with a note

## Step 2: Address Critical findings first

For each Critical finding:

1. Understand the root cause (use systematic-debugging if needed)
2. Write a test that catches the bug if the finding is a correctness/security issue
3. Fix it
4. Verify: run the test suite, confirm the finding is resolved

Do not address Important or Minor items until all Critical items are resolved and verified.

## Step 3: Address Important findings

For each Important finding:

1. Determine if it should be fixed now or deferred (deferral requires an explicit reason)
2. If fixing: same process as Critical — test first if applicable, fix, verify
3. If deferring: create a follow-up note with the specific reason

## Step 4: Minor findings

Decide case by case: fix inline now, or defer. Either is acceptable. Document deferred minors.

## Step 5: Re-request review

After addressing Critical and Important findings:

```bash
# Show what changed since the last review
git diff <last-review-sha>..HEAD
```

Pass to `code-reviewer` with:
- The new diff (changes made in response to review)
- The original findings and how each was addressed
- Any findings that were intentionally deferred and why

## Rules

- Never mark Critical findings as "won't fix" without explicit user decision
- A fix is not complete until tests run and pass — "should be fixed" is not verification
- Re-review is required after fixing Critical or Important findings — don't self-certify
- Deferred minors don't require re-review; document them in the PR description
