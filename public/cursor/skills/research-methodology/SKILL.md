---
name: research-methodology
description: "Invoke when AI needs guidance on HOW to approach exploration - thinking patterns, analysis strategies, and methodology. NOT for explicit /research command output (that's handled by the command itself)."
---

# Research Methodology Skill

Provides thinking patterns and analytical approaches for understanding systems. This skill guides HOW to think about exploration, while the `/research` command defines WHAT to output.

## Relationship to /research Command

- **This skill**: Guides AI thinking when exploring code (methodology, patterns, strategies)
- **`/research` command**: User-invoked workflow that produces output to `.ai/active-research.md`

Use this skill when you need to think through an exploration approach, even outside of explicit `/research` invocations.

## When to Use

Automatically invoke this skill when:

- AI is uncertain about how to approach understanding unfamiliar code
- Need to decide what aspects of a system to investigate
- Analyzing whether a change is safe requires systematic thinking
- User asks "how does X work?" without invoking `/research`
- Making decisions about exploration depth and strategy

## Process

### 1. Map the Dependency Graph

- Identify all files/modules involved
- Trace imports and dependencies
- Document what depends on what
- Find circular dependencies or tight coupling

### 2. Identify Service Boundaries

- Where do responsibilities change?
- What are the interfaces between components?
- Which boundaries are clean vs leaky?

### 3. Distinguish Essential vs Accidental Complexity

**Essential Complexity**: The inherent difficulty of the problem

- Users must authenticate
- Data must be validated
- Transactions must be atomic

**Accidental Complexity**: Complexity from our solution

- Legacy workarounds
- Technical debt
- Outdated patterns
- "That weird gRPC-pretending-to-be-GraphQL thing from 2019"

Flag which is which. AI treats technical debt as architectural requirements - you must explicitly identify it.

### 4. Document Hidden Constraints

- What must not break?
- What must remain compatible?
- What are the performance requirements?
- What are the security requirements?
- What edge cases exist in the current implementation?

### 5. Surface Edge Cases

- Look for error handling
- Check for null/undefined checks
- Find validation logic
- Identify race conditions or timing issues

## Output

Provide structured analysis with:

```markdown
## Components Involved
- [file path]: [purpose]
- [file path]: [purpose]

## Dependency Relationships
- X depends on Y because [reason]
- A calls B which calls C
- [diagram if complex]

## Essential vs Accidental Complexity
**Essential:**
- [what's inherent to the problem]

**Accidental:**
- [what's from our solution approach]
- [flag legacy patterns to avoid preserving]

## Constraints Discovered
- [what must not break]
- [what must remain compatible]
- [performance/security requirements]

## Edge Cases Found
- [error conditions]
- [validation logic]
- [race conditions]

## Risk Areas
- [high blast radius changes]
- [security-sensitive code]
- [performance-critical paths]

## Open Questions
- [what needs clarification]
- [what's uncertain]
```

## Critical Guidelines

- **Be thorough** - Missing context causes AI-slop in implementation
- **Flag uncertainty** - If you're not sure, say so rather than guessing
- **Reference specific file paths and line numbers** - Make it actionable
- **Identify patterns from ai-context.md** - Check if existing patterns apply
- **Call out anti-patterns** - Flag problematic code that shouldn't be replicated

## Integration with Workflow

This skill provides the **thinking methodology** that supports:

- The `/research` command (explicit research workflow)
- Ad-hoc exploration when user asks questions
- Pre-implementation analysis during any task

**Key distinction**: This skill helps AI think systematically. The `/research` command produces the formal output document.

## Why This Matters

"You have to understand the system before you can teach AI to modify it safely."

Rushing to implementation without research leads to:

- Architectural drift
- Preserved technical debt
- Unmaintainable code
- Security vulnerabilities
