---
name: brainstorming
description: Use before any feature, component, or behavior change — when the user describes what they want to build, asks how to approach something new, or has an idea to explore. Explores intent and constraints through dialogue, proposes 2-3 distinct approaches, gets design approval section by section, writes a spec document, then hands off to the planning skill. Never writes code during this phase.
---

# Brainstorming

Turn an idea into a fully formed design through collaborative dialogue. No code is written during this session.

<HARD-GATE>
Do NOT write any code, scaffold any files, or invoke any implementation action until:
1. A design has been presented
2. The user has explicitly approved it
3. A spec document has been written and the user has reviewed it

This applies regardless of how simple the task seems.
</HARD-GATE>

## Anti-pattern: "This is too simple to need a design"

Every task goes through this process. A config change, a single function, a small refactor — all of them. Simple tasks are where unexamined assumptions waste the most time. The design can be short, but it must be presented and approved.

## Process (complete each step in order)

### 1. Explore project context
Read the current codebase state: relevant files, docs, recent commits. Understand what exists before proposing anything.

If the request describes multiple independent subsystems, flag this immediately and help decompose into sub-projects before proceeding. Each sub-project gets its own brainstorm → spec → plan → implementation cycle.

### 2. Ask clarifying questions — ONE AT A TIME
- Understand purpose, constraints, and success criteria
- Prefer multiple-choice questions where possible
- Only one question per message — wait for the answer before asking the next
- Focus on what will affect the design, not implementation details

### 3. Propose 2-3 approaches
Present distinct approaches with trade-offs. Lead with your recommendation and explain why. Be concrete — not "option A vs B" but actual design choices.

### 4. Present design — section by section, get approval after each
Cover: architecture, components, data flow, error handling, testing approach. Scale each section to its complexity (a few sentences for simple, up to 300 words for nuanced). Ask "does this look right?" after each section. Revise until approved.

Design for isolation and clarity:
- Each component has one clear purpose and a well-defined interface
- Can you explain what it does without reading its internals?
- Can you change internals without breaking consumers?

### 5. Write spec document
Save to `docs/specs/YYYY-MM-DD-<topic>.md` and commit.

Spec self-review before showing the user — scan for:
- Placeholders: "TBD", "TODO", vague requirements → fix them
- Contradictions: do sections conflict? Does architecture match features?
- Scope: is this focused enough for one implementation plan?
- Ambiguity: could any requirement be interpreted two ways? → pick one, make it explicit

### 6. User reviews spec
Present:
> "Spec written and committed to `<path>`. Please review it and let me know if you want any changes before we start the implementation plan."

Wait for explicit approval. Make any requested changes and re-run self-review. Only proceed once approved.

### 7. Hand off to planning
After spec approval, apply the writing-plans skill with the spec path to create the implementation plan. Do not write code directly.

## Key principles
- One question at a time — never overwhelm
- YAGNI ruthlessly — remove anything not directly needed
- Always propose 2-3 approaches before committing
- Validate incrementally — present, get approval, move on
- In existing codebases, follow existing patterns
