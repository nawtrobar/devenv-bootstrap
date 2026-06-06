---
name: writing-plans
description: Use when turning a spec, approved design, or set of requirements into a step-by-step implementation plan. Maps files first, then decomposes into TDD tasks with actual code (no placeholders), exact test commands, and expected output. Use after brainstorming produces an approved spec, or when the user asks to plan before implementing.
---

# Writing Implementation Plans

Write a plan comprehensive enough that an engineer with zero codebase context and questionable test design habits can execute it correctly. Every step gets actual code and exact commands — no placeholders, no "TBD", no "add appropriate error handling".

**Save to:** `docs/plans/YYYY-MM-DD-<feature-name>.md`

---

## Step 1: Scope check

If the spec/requirements covers multiple independent subsystems, flag this and suggest separate plans — one per subsystem. Each plan should produce working, testable software on its own.

## Step 2: File structure map

Before defining tasks, map which files will be created or modified and what each one is responsible for:

```
Files:
- Create: src/auth/jwt.ts          — JWT sign/verify utilities
- Create: src/auth/middleware.ts   — Express auth middleware
- Modify: src/routes/index.ts      — Wire up auth middleware
- Test:   tests/auth/jwt.test.ts
- Test:   tests/auth/middleware.test.ts
```

Design rules:
- Each file has one clear responsibility with a well-defined interface
- Files that change together live together
- Split by responsibility, not by technical layer
- In existing codebases, follow established patterns — don't unilaterally restructure

## Step 3: Plan header

Every plan starts with:

```markdown
# <Feature Name> Implementation Plan

**Goal:** <one sentence — what this builds>
**Architecture:** <2-3 sentences — approach and key decisions>
**Tech stack:** <key technologies and libraries>

---
```

## Step 4: Tasks — bite-sized, TDD, no placeholders

Each task is 2-5 minutes of work. Each step in a task is one action.

**Task format:**

```markdown
### Task N: <Component name>

**Files:**
- Create: `exact/path/to/file.ts`
- Modify: `exact/path/to/existing.ts` (lines 45-60)
- Test: `tests/exact/path/test.ts`

- [ ] **Step 1: Write the failing test**

\`\`\`typescript
test('returns 401 when token is missing', async () => {
  const res = await request(app).get('/api/protected');
  expect(res.status).toBe(401);
  expect(res.body.error).toBe('Authentication required');
});
\`\`\`

- [ ] **Step 2: Run test — verify it fails**

\`\`\`bash
npm test tests/auth/middleware.test.ts
\`\`\`
Expected: FAIL — "Cannot read property 'authorization' of undefined" or similar

- [ ] **Step 3: Write minimal implementation**

\`\`\`typescript
export function requireAuth(req, res, next) {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'Authentication required' });
  // verify token...
}
\`\`\`

- [ ] **Step 4: Run test — verify it passes**

\`\`\`bash
npm test tests/auth/middleware.test.ts
\`\`\`
Expected: PASS

- [ ] **Step 5: Commit**

\`\`\`bash
git add tests/auth/middleware.test.ts src/auth/middleware.ts
git commit -m "feat: add auth middleware requiring bearer token"
\`\`\`
```

## No placeholders — these are plan failures

Never write:
- "TBD", "TODO", "implement later"
- "Add appropriate error handling" or "handle edge cases" without showing the code
- "Write tests for the above" without writing the test code
- "Similar to Task N" — repeat the code, engineers may read tasks out of order
- Steps that describe what to do without showing the code
- References to types or functions not defined in any task

## Step 5: Self-review

After writing the complete plan, check it against the spec:

1. **Spec coverage** — can you point to a task for every requirement? List gaps.
2. **Placeholder scan** — search for "TBD", "TODO", vague steps. Fix them.
3. **Consistency** — do type names, function names, and method signatures match across all tasks?

Fix issues inline before saving.

## Step 6: Offer execution path

After saving the plan:
```
Plan saved to docs/plans/<filename>.md

Ready to execute. Two options:

1. Autonomous delegation — tech-lead → engineers → QA → security → review
2. Execute inline — work through tasks in this session

Which approach?
```
