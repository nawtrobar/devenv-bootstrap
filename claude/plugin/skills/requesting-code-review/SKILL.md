---
name: requesting-code-review
description: Use when the user wants their code reviewed, asks for a review of changes on a branch or diff, or says "review this", "check my code", "what do you think of these changes". Invokes the code-reviewer agent for a structured review: reads the actual diff, produces Strengths → Critical/Important/Minor findings → merge verdict. Never trusts reports — reads the code itself.
---

# Requesting a Code Review

## What to provide

Before invoking the reviewer, gather:

```bash
# The diff to review
git diff <base-branch>..HEAD

# Or for staged changes only
git diff --cached

# Base and head SHAs for reference
git log --oneline -5
```

## Invoke code-reviewer

Pass to `code-reviewer`:
- The diff or file range to review
- What the change is supposed to do (the spec or task description)
- Base SHA before changes, current HEAD SHA
- Any specific concerns to focus on

## What the reviewer checks

The reviewer reads the actual code (not your description of it) and reports:

**Strengths** — what was done well and why it matters

**Issues by severity:**
| Severity | Criteria |
|----------|---------|
| **Critical** | Data loss, security vulnerability, broken functionality, crash path |
| **Important** | Architecture problem, missing error handling, test gap |
| **Minor** | Code style, naming, optimization, polish |

**Merge verdict:** Ready to merge / Yes with fixes / No

## After receiving review

- **Critical findings:** Must fix before merge. Use the systematic-debugging skill to address root causes.
- **Important findings:** Should fix. Create a plan if they're non-trivial.
- **Minor findings:** Optional. Address now or defer — your call.

After fixing Critical or Important issues: re-run the review on the updated diff.

## What the reviewer will NOT flag

- Pre-existing issues not introduced by this change
- Issues a linter/typechecker would catch automatically
- Style issues not required by project conventions
- Things that look like bugs but are clearly intentional
