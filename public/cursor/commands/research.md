# /research [task description]

Perform the Research phase of the three-phase workflow.

## Purpose

Understand the system before modifying it. Compress understanding into documented findings that will inform the planning phase.

## First Steps

1. Read `.ai/ai-context.md` for existing patterns and constraints
2. Read `.ai/template/research.md` for output structure
3. For complex tasks (touching >5 files or unfamiliar territory), spawn the **researcher subagent**

## Process

1. **Map the landscape** - Identify all files, modules, and components involved
2. **Trace dependencies** - What depends on what? What's the blast radius?
3. **Analyze current implementation** - How does it work now?
4. **Separate essential from accidental** - What's inherent vs from technical debt?
5. **Discover constraints** - What must not break? What must remain compatible?
6. **Find edge cases** - What's not obvious from a surface read?
7. **Identify risk areas** - Security, performance, high coupling

## Output Requirements

Create `.ai/active-research.md` with:

- **YAML frontmatter**: task name, created date, status: research
- **Components involved** (with file paths)
- **Dependencies mapped** (what depends on what)
- **Current implementation analysis** (how it works now)
- **Essential vs accidental complexity identified**
- **Constraints discovered** (what must not break, what must remain compatible)
- **Open questions** (what needs clarification)

Use the structure from `.ai/template/research.md`.

## When to Spawn Researcher Subagent

For large or complex tasks, spawn the researcher subagent:

- Task involves >5 files
- Exploring unfamiliar code areas
- Security-sensitive components
- Architectural decisions needed

The subagent will do deep exploration and return a summary.

## Quality Criteria

Research is complete when:

- [ ] All relevant files identified with specific paths
- [ ] Dependencies are traced and documented
- [ ] Essential vs accidental complexity is explicitly labeled
- [ ] Constraints are discovered and documented
- [ ] Open questions are listed (if any)
- [ ] Risk areas are flagged

## After Research

Once research is complete and validated:

1. User reviews and approves findings
2. Proceed to `/plan` to create the implementation specification
3. Archive happens automatically after `/implement` completes
