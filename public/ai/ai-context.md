# Project Context

> **Purpose**: This document is the compressed knowledge of your system. It's automatically injected into every AI session via the sessionStart hook. Keep it under 2000 words for token efficiency.
> **Last Updated**: [Update this date when you make changes]

---

## System Overview

**What this system does:**
[Describe in 200-300 words: the purpose, main functionality, and key user flows]

**Key components and interactions:**

- [Component 1]: [Purpose and role]
- [Component 2]: [Purpose and role]
- [How they interact]

**Major architectural decisions:**

1. **[Decision 1]**: [What and WHY]
2. **[Decision 2]**: [What and WHY]

---

## Architectural Principles

### Patterns We Follow (and WHY)

- **[Pattern name]**: [Description and reasoning]
  - Example: "Service layer pattern - business logic in services, controllers stay thin. Makes testing easier and separates concerns."

- **[Pattern name]**: [Description and reasoning]

### Patterns We AVOID (and WHY)

- **[Anti-pattern name]**: [What it is and why we avoid it]
  - Example: "Mixing business logic with auth checks - makes refactoring dangerous and security audits impossible."

- **[Anti-pattern name]**: [What it is and why we avoid it]

### Fundamental Guidelines

- **Simple over Easy**: Choose solutions that are simple (one responsibility, no entanglement) over solutions that are merely easy (within reach, frictionless to add)
- **Essential vs Accidental**: Always distinguish between complexity inherent to the problem vs complexity from our solution approach
- **Ownership Test**: If you can't explain it, debug it at 3am, and modify it confidently, you don't own it yet

---

## Critical Constraints

### Performance Requirements

### Security Requirements

### Known Technical Debt

**Important**: AI treats technical debt as architectural requirements. Explicitly flag legacy patterns here.

- **[Debt item 1]**: [What it is, why it exists, DO NOT preserve this pattern]
  - Example: "Auth shim between old OAuth (2019) and new centralized OAuth - exists for backward compatibility during migration. DO NOT use this pattern in new code."

- **[Debt item 2]**: [What it is, why it exists, guidance]

---

## Common Pitfalls

**What has broken before:**

- [Pitfall 1]: [What happened and how to avoid]
  - Example: "Mixing business logic with auth checks caused migration issues - keep auth in service layer"

- [Pitfall 2]: [What happened and how to avoid]

**Patterns that caused problems:**

- [Problem pattern 1]: [Why it was problematic]
  - Example: "OAuth.js + OAuth2.js + session-handler.js pattern - multiple overlapping auth implementations created security gaps and maintenance nightmares"

- [Problem pattern 2]: [Why it was problematic]

---

## File/Module Map

### Core Modules

- **[Module/Directory]**: [Purpose]
  - Key files: `[file path]` - [what it does]
  - Key files: `[file path]` - [what it does]

### Service Boundaries

- **[Service A]** ↔ **[Service B]**: [How they interact]
- **[Service B]** ↔ **[Service C]**: [How they interact]

### What Touches What

- **[Component A]** depends on:

---

## Usage Notes

### For AI Sessions

This context is automatically injected at session start. Reference it when:

- Making architectural decisions
- Choosing between patterns
- Avoiding known pitfalls
- Understanding constraints

### For Developers

Update this document:

- After significant architectural decisions
- When new patterns are established
- When pitfalls are discovered
- After major refactoring

Keep it concise - this is context compression, not comprehensive documentation.

### Three-Phase Workflow Integration

- **Research Phase**: Check this for existing patterns and constraints
- **Planning Phase**: Validate plans against principles and anti-patterns
- **Implementation Phase**: Follow established patterns documented here
- **After Completion**: Update with new learnings

---

## Example Entries

### Example Architectural Principle

- **Repository Pattern for Data Access**: All database access goes through repository classes in `src/repositories/`. Controllers never query the database directly. This makes testing easier (mock repositories) and centralizes data access logic.

### Example Anti-Pattern

- **God Controllers**: Controllers with >200 lines or >5 responsibilities. We had a UserController that handled auth, profile, settings, and notifications - became unmaintainable. Keep controllers thin, delegate to services.

### Example Technical Debt

- **Legacy XML Config**: Old config system uses XML files in `config/legacy/`. New code should use JSON in `config/`. DO NOT add new XML configs. Migration planned for Q2.

### Example Common Pitfall

- **Circular Dependencies**: Had A → B → C → A cycle that caused initialization issues. Now we enforce: services can depend on repositories, controllers can depend on services, but no cycles allowed.

---

**Remember**: This is your project's compressed knowledge. Keep it updated, keep it concise, keep it actionable.
