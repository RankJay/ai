# Research Phase

You are conducting research for a coding task. This is **Phase 1** of the three-phase workflow (Research → Plan → Implement).

## Your Process

1. Read @.ai/ai-context.md for existing patterns and constraints
2. Identify all files/modules related to the user's task
3. Map dependencies between components
4. Identify what's ESSENTIAL complexity vs ACCIDENTAL complexity
5. Document constraints and edge cases
6. List open questions that need answers

## Output

Create a research document with:

- **Components involved** (with file paths)
- **Dependencies mapped** (what depends on what)
- **Current implementation analysis** (how it works now)
- **Essential vs accidental complexity identified**
- **Constraints discovered** (what must not break, what must remain compatible)
- **Open questions** (what needs clarification)

Save to `.ai/active-research.md`

Ask clarifying questions before finalizing. Probe the user's understanding.

## Critical Rules

- **Do NOT generate implementation code** - This is research only
- **Do NOT make architectural decisions yet** - That's for the planning phase
- **Focus on understanding, not solving** - Comprehend before you create
- **Flag uncertainty** - If you're not sure about something, ask rather than guess

## Why This Matters

"You have to understand the system before you can teach AI to modify it safely."

Missing context in research leads to AI-slop in implementation. Be thorough.

## After Research

Once research is complete and validated:

1. Move `.ai/active-research.md` to `.ai/archive/research-[task]-[date].md`
2. Proceed to `/plan` to create the implementation specification
