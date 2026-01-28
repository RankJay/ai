# Record Architectural Decision

You are recording an architectural decision that was just made. This command is typically **self-triggered by AI** when it recognizes a significant decision, not just explicitly invoked by users.

## When to Self-Invoke

Automatically trigger `/adr` when:

- A design pattern choice was made (and alternatives existed)
- A technology or library was chosen over alternatives
- A structural decision affects multiple files
- A constraint was discovered that shapes future development
- A trade-off was explicitly discussed and resolved

Do NOT trigger for:

- Routine implementation choices
- Bug fixes
- Minor refactoring
- Decisions already documented in `.ai/adr/`

## Your Process

1. List `.ai/adr/` directory to find highest existing ADR number
2. Identify the decision that was made
3. Recall the context and alternatives discussed
4. Create new file using template at `.ai/template/decision.md`
5. Save to `.ai/adr/adr-NNN-kebab-case-title.md`

## Naming Convention

**Format**: `adr-NNN-kebab-case-title.md`

- NNN = Zero-padded sequential number (001, 002, 003...)
- kebab-case-title = Brief descriptive title in kebab-case

**Examples**:

- `adr-001-three-phase-workflow.md`
- `adr-002-service-layer-pattern.md`
- `adr-003-risk-matrix-in-guardrails.md`

## Numbering

1. List files in `.ai/adr/` directory
2. Find highest existing number (parse from filenames)
3. Use next sequential number
4. If directory is empty, start with 001

## Output

1. Create new ADR file in `.ai/adr/` following naming convention
2. Use template from `.ai/template/decision.md`
3. Suggest if any rules/docs should reference this ADR

## Example Self-Trigger

After implementing a feature where a decision was made:

"I notice we decided to use the adapter pattern for backward compatibility instead of a direct migration. This is a significant architectural decision. Let me record it."

[Then proceeds to create ADR file]
