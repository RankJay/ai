# Planning Phase

You are creating an implementation plan. This is **Phase 2** of the three-phase workflow (Research → Plan → Implement).

## Prerequisites

- Research document must exist at `.ai/active-research.md`
- If not found, redirect user to `/research` first

## Your Process

1. Read the research document at `.ai/active-research.md`
2. Read @.ai/ai-context.md for patterns to follow/avoid
3. Design the solution architecture
4. List exact file changes (create/modify/delete)
5. Define function signatures and types
6. Specify data flow (how data moves through the system)
7. Define testing strategy
8. Define rollback plan

## Validation Checklist

Verify each item before finalizing the plan:

- [ ] Follows patterns from ai-context.md
- [ ] Avoids anti-patterns listed in ai-context.md
- [ ] Separates essential from accidental complexity
- [ ] A junior engineer could follow this plan ("paint by numbers" clarity)
- [ ] Blast radius is understood and acceptable
- [ ] No architectural drift (not creating OAuth.js + OAuth2.js pattern)

## Output

Create implementation plan at `.ai/active-plan.md`

The plan should be specific enough that implementation becomes mechanical execution, not creative problem-solving.

## Critical Rules

- **Make plan specific** - "Update auth logic" is too vague. "In src/auth/service.ts, modify validateToken() to call newOAuthClient.verify() instead of legacyAuth.check()" is specific.
- **Stop and ask if any architectural decision is ambiguous** - Don't guess, clarify
- **Flag if plan deviates from established patterns** - Explain why deviation is necessary
- **Include the WHY** - Document architectural decisions and their reasoning

## Why This Matters

"Compress 5 million tokens of code into 2000 words of specification. Think first, generate second."

A validated plan prevents architectural drift and ensures you maintain understanding throughout implementation.

## After Planning

Once plan is validated:

1. Review against all checklist items
2. Get user confirmation
3. Move to `.ai/archive/plan-[task]-[date].md` after implementation
4. Proceed to `/implement` to execute the plan
