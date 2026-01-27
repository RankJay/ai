---
name: architecture-decision
description: "Invoke when making architectural decisions, choosing between design patterns, or establishing new conventions. Use when the user asks 'should I use X or Y' or 'how should I structure this'."
---

# Architecture Decision Skill

Guide architectural decision-making to prevent drift and maintain coherence.

## When to Use

Automatically invoke when:

- User asks "should I use X or Y?"
- User asks "how should I structure this?"
- Multiple valid approaches exist
- Establishing new patterns or conventions
- Making technology choices
- Designing system boundaries
- Refactoring architecture

## Decision Framework

### 1. Understand the Context

Before recommending an approach:

- What problem are we solving?
- What constraints exist?
- What patterns are already established (check ai-context.md)?
- What's the blast radius of this decision?

### 2. Identify Options

List viable approaches with:

- **Pros**: Benefits and advantages
- **Cons**: Drawbacks and trade-offs
- **Complexity**: Essential vs accidental
- **Fit**: How well it aligns with existing architecture

### 3. Apply Decision Criteria

Evaluate each option against:

**Simplicity**

- Does it reduce or increase complexity?
- Is it simple or just easy?
- Can it be explained in a few sentences?

**Maintainability**

- Can someone else understand this in 6 months?
- Does it follow established patterns?
- Is it consistent with the rest of the codebase?

**Coherence**

- Does it fit the existing architecture?
- Does it create or reduce architectural drift?
- Does it establish a pattern we want to replicate?

**Essential vs Accidental**

- Is this complexity inherent to the problem?
- Or is it from our solution approach?
- Are we adding accidental complexity?

**Blast Radius**

- How many components affected?
- What breaks if this is wrong?
- How hard to change later?

### 4. Check Against ai-context.md

- Does this follow established principles?
- Does this avoid known anti-patterns?
- Is this consistent with past decisions?
- Should this become a new pattern?

## Common Decision Patterns

### Technology Choices

When choosing between technologies (Redis vs Postgres, REST vs GraphQL):

```markdown
## Decision: [Technology Choice]

### Context
- [What we're trying to achieve]
- [Current constraints]
- [Existing tech stack]

### Options
1. **[Option A]**
   - Pros: [benefits]
   - Cons: [drawbacks]
   - Complexity: [essential/accidental]
   - Fit: [how it aligns]

2. **[Option B]**
   - Pros: [benefits]
   - Cons: [drawbacks]
   - Complexity: [essential/accidental]
   - Fit: [how it aligns]

### Recommendation: [Chosen option]

**Why**: [reasoning based on criteria]

**Trade-offs accepted**: [what we're giving up]

**Reversibility**: [how hard to change later]

### Document in ai-context.md
Add to Architectural Principles:
"We use [choice] for [use case] because [reason]"
```

### Pattern Choices

When choosing design patterns:

```markdown
## Decision: [Pattern Choice]

### Problem
[What we're trying to solve]

### Pattern Options
1. **[Pattern A]**: [description]
   - When to use: [scenarios]
   - Complexity: [assessment]
   - Examples in codebase: [references]

2. **[Pattern B]**: [description]
   - When to use: [scenarios]
   - Complexity: [assessment]
   - Examples in codebase: [references]

### Recommendation: [Chosen pattern]

**Why**: [reasoning]

**Consistency**: [how it fits existing code]

**Precedent**: [similar decisions made before]
```

### Service Boundary Decisions

When defining service boundaries:

```markdown
## Decision: [Service Boundary]

### Current State
[How it's organized now]

### Proposed Boundaries
- Service A: [responsibilities]
- Service B: [responsibilities]
- Interface: [how they communicate]

### Evaluation
- Clear responsibilities? [yes/no + explanation]
- Minimal coupling? [yes/no + explanation]
- High cohesion? [yes/no + explanation]
- Testable independently? [yes/no + explanation]

### Recommendation
[Proposed structure with reasoning]
```

## Red Flags

Watch for these warning signs:

**"It's easier this way"**

- Easy ≠ Simple
- Convenience now may create complexity later
- Question if it's truly simpler or just more accessible

**"Everyone does it this way"**

- Does it fit YOUR architecture?
- Cargo-culting patterns can introduce misfit

**"We can refactor later"**

- Will we actually refactor?
- Is this creating technical debt?
- Should we do it right now instead?

**"Let's use the latest thing"**

- Is it stable and proven?
- Does it solve a real problem?
- Or are we chasing novelty?

## Output Format

```markdown
## Architectural Decision: [Topic]

### Context
[Problem and constraints]

### Options Considered
1. [Option A]: [summary]
2. [Option B]: [summary]
3. [Option C]: [summary]

### Decision: [Chosen option]

### Reasoning
- **Simplicity**: [how it's simpler]
- **Maintainability**: [how it's maintainable]
- **Coherence**: [how it fits]
- **Essential Complexity**: [justified complexity]

### Trade-offs
- [What we're giving up]
- [What we're gaining]

### Implementation Notes
- [How to implement]
- [Patterns to follow]
- [Pitfalls to avoid]

### Documentation
Add to `.ai/ai-context.md`:
- Architectural Principles: [new principle]
- Patterns to Follow: [new pattern]
- Patterns to Avoid: [anti-pattern]
```

## Integration with Workflow

This skill supports the Planning phase:

1. Architectural decisions made during planning
2. Documented in the plan
3. Referenced in implementation
4. Added to ai-context.md after validation

## Why This Matters

"Each turn optimizes for immediate satisfaction, not systemic coherence."

Without explicit architectural decision-making:

- Patterns proliferate inconsistently
- Technical debt accumulates
- Architectural drift occurs
- Maintenance becomes impossible

Making decisions explicit and documented prevents drift and maintains coherence.
