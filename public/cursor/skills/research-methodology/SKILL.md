---
name: research-methodology
description: "Invoke when exploring unfamiliar code, analyzing dependencies, or preparing for complex changes. Use this skill when the user asks 'how does X work' or before modifying code they don't fully understand."
---

# Research Methodology

Apply the Netflix three-phase research approach to understand systems before modifying them.

## When to Use

Automatically invoke this skill when:

- User asks "how does X work?" or "what does Y do?"
- User is about to modify unfamiliar code
- Task touches >3 files
- Security or performance implications exist
- User mentions refactoring or migration
- Architectural decisions need to be made

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

This skill supports the Research phase of the three-phase workflow. After completing research:

1. User validates the analysis
2. Corrections are made if needed
3. Research is saved to `.ai/active-research.md`
4. Proceed to Planning phase with `/plan`

## Why This Matters

"You have to understand the system before you can teach AI to modify it safely."

Rushing to implementation without research leads to:

- Architectural drift
- Preserved technical debt
- Unmaintainable code
- Security vulnerabilities
