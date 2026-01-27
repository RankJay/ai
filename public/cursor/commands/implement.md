# Implementation Phase

You are implementing a validated plan. This is **Phase 3** of the three-phase workflow (Research → Plan → Implement).

## Prerequisites

- Plan document must exist at `.ai/active-plan.md`
- If not found, redirect user to `/plan` first
- Plan must be validated (user has reviewed and approved it)

## Your Process

1. Read @.ai/ai-context.md for patterns
2. Read `.ai/active-plan.md` for the implementation spec
3. Execute the plan step by step
4. Stop if anything is ambiguous - **ASK rather than invent**

## Rules

- **Follow the plan EXACTLY** - This is mechanical execution, not creative problem-solving
- **Do not add features not in the plan** - Scope creep creates complexity
- **Do not change architectural decisions** - If the plan is wrong, stop and revise the plan
- **If you discover the plan is incomplete, STOP and say so** - Don't improvise
- **Reference specific sections of the plan as you implement** - Show which part you're executing

## After Each Step

- Verify the change matches the plan
- Note any deviations for review
- If deviation is necessary, explain why and get approval

## Why This Matters

At this phase, review is just verifying conformance to the plan, not understanding what got invented. This only works if you follow the plan exactly.

"The AI executes the spec. Review is just verifying conformance, not understanding what got invented."

## Post-Generation Validation (from ai-guardrails.md)

After implementation, verify:

- [ ] I can explain how this works to a junior engineer
- [ ] I can identify essential vs accidental complexity
- [ ] I could modify this if requirements changed
- [ ] I could debug this at 3am
- [ ] This follows our architectural principles (check ai-context.md)
- [ ] This doesn't repeat past mistakes (check ai-context.md "Common Pitfalls")

If any checkbox is empty, do not proceed to commit. Address issues first.

## When Implementation is Complete

1. Run `/review` to validate against post-generation checklist
2. Move `.ai/active-plan.md` to `.ai/archive/plan-[task]-[date].md`
3. Move `.ai/active-research.md` to `.ai/archive/research-[task]-[date].md`
4. Update `.ai/ai-context.md` with any new patterns or learnings
5. Use `/commit` to commit changes with proper context

## If You Get Stuck

If you encounter something not covered in the plan:

1. **STOP implementation**
2. Document what's unclear
3. Ask the user for clarification
4. Update the plan if needed
5. Resume implementation

Never improvise solutions that aren't in the validated plan.
