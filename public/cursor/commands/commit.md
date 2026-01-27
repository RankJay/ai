# Commit Changes

Create a git commit with proper context and documentation.

## Process

1. **Review staged changes**
   - Run `git status` to see what will be committed
   - Run `git diff --staged` to review actual changes

2. **Verify documentation is updated**
   - [ ] `.ai/ai-context.md` updated if patterns changed
   - [ ] Research/plan docs moved to `.ai/archive/` if applicable
   - [ ] Any new patterns documented

3. **Draft commit message**

   Follow this format:

   ```txt
   [type]: Brief description (50 chars max)
   
   Detailed explanation of:
   - What changed and why
   - Architectural decisions made
   - Reference to research/plan docs if applicable
   
   Related: [issue/ticket number if applicable]
   ```

   Types: feat, fix, refactor, docs, test, chore

4. **Stage all relevant files**

   ```bash
   git add [files]
   git add .ai/ai-context.md  # if updated
   ```

5. **Create commit**

   ```bash
   git commit -m "Your message"
   ```

6. **Verify commit**

   ```bash
   git log -1 --stat
   ```

## Commit Message Guidelines

### Good Examples

```txt
feat: Implement OAuth2 authentication service

- Migrated from legacy auth shim to new centralized OAuth
- Extracted auth logic to service layer (src/auth/oauthService.ts)
- Maintained API contract for backward compatibility
- Added feature flag for rollback capability

Research: .ai/archive/research-oauth-migration-20260127.md
Plan: .ai/archive/plan-oauth-migration-20260127.md
```

```txt
refactor: Separate auth logic from business logic

- Moved permission checks from controllers to auth service
- Prevents mixing concerns that caused migration issues
- Follows pattern established in ai-context.md

Addresses anti-pattern: "Mixing business logic with auth checks"
```

### Bad Examples

```txt
fix: stuff
```

```txt
updated files
```

```txt
implemented the feature we talked about
```

## What to Include

**Always commit together**:

- Code changes
- Updated `.ai/ai-context.md` (if patterns changed)
- Test files
- Documentation updates

**Never commit**:

- `.ai/active-research.md` (working document)
- `.ai/active-plan.md` (working document)
- Secrets or credentials
- Debug logs

## After Commit

1. Verify commit looks correct: `git log -1 -p`
2. If working on a branch, consider: `git push`
3. Archive research/plan docs to `.ai/archive/`
4. Clean up working documents

## Integration with Three-Phase Workflow

Your commit message should reference the research and plan that led to this implementation:

```txt
Research: .ai/archive/research-[task]-[date].md
Plan: .ai/archive/plan-[task]-[date].md
```

This creates a traceable link from problem → research → plan → implementation.
