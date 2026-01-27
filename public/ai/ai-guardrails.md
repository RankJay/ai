# Safeguards and Guardrails

## Pre-Generation Checklist

- [ ] I can describe what I'm building in 100 words
- [ ] I've sketched the architecture (boxes & arrows)
- [ ] I know which patterns to follow (reference ai-context.md)
- [ ] I know which patterns to avoid (reference ai-context.md)
- [ ] I've listed key decisions and WHY
- [ ] I know what success looks like
- [ ] I know the blast radius if this is wrong

If any checkbox is empty, I'm not ready to generate.

## Post-Generation Validation

- [ ] I can explain how this works to a junior engineer
- [ ] I can identify essential vs accidental complexity  
- [ ] I could modify this if requirements changed
- [ ] I could debug this at 3am
- [ ] This follows our architectural principles (check ai-context.md)
- [ ] This doesn't repeat past mistakes (check ai-context.md "Common Pitfalls")

If any checkbox is empty, I don't ship yet.

## The "Stop and Think" Triggers

Certain situations should trigger an automatic pause:

STOP if you're about to:

- Generate code for security/auth/payments
- Refactor something touching >8 files
- Use a pattern you're not familiar with
- Work on something that's broken before
- Feel rushed or pressured

When stopped, ask:

- Do I have enough context? (Check permanent + task context)
- Have I done research phase? (Should have research doc)
- Have I validated a plan? (Should have plan doc)
- What's the worst case if this is wrong?

## Context Freshness Check

Last updated: [Date]

Since last update:

- [ ] New architectural decisions made?
- [ ] New patterns adopted?  
- [ ] New pitfalls discovered?
- [ ] Technical debt changed?

If yes to any: Update ai-context.md before proceeding

## Maintaining Knowledge Across Conversations

Here's a workflow for keeping context fresh:

### After Each Significant Task

1. **Extract learnings:**
   - What did you discover?
   - What patterns worked/didn't work?
   - What would you do differently?

2. **Update ai-context.md:**
   - Add to "Common Pitfalls" if you hit issues
   - Add to "Architectural Principles" if you made a decision
   - Update "File/Module Map" if structure changed

3. **Archive task docs:**

    ```txt
    /ai-context/
        ai-context.md          (permanent, always updated)
        /archive/
        research-auth-migration-2024-12.md
        plan-auth-migration-2024-12.md
    ```

4. **Weekly review:**
   - Read through ai-context.md
   - Is anything outdated?
   - Is anything missing?
   - Keep it under 2000 words (merge or remove old content)

## A Concrete Example: Auth Migration

Let me show you how this would actually work:

### Day 1: Research Phase

**Start new conversation:**

```txt
I'm migrating from old auth shim to new OAuth service.

[Paste ai-context.md - which includes:]
- System uses auth shim between old OAuth (2019) and new centralized OAuth
- Shim exists because full migration was too complex
- Known issue: Permission checks woven through business logic
- Constraint: Can't break existing API contracts

Analyze these files and map dependencies:
- src/auth/authShim.ts
- src/services/userService.ts  
- src/controllers/userController.ts
```

**During research:**

- AI identifies 47 files that import authShim
- You discover 12 files have mixed business + auth logic
- AI misses that some routes bypass shim entirely
- You correct it, provide context

**Save output:** `research-auth-migration.md`

### Day 2: Planning Phase

**Continue or start fresh with:**

```txt
[Paste ai-context.md]
[Paste research-auth-migration.md]

Create implementation plan for migrating users endpoint first (lowest risk).

Plan should:
1. Extract auth logic from business logic
2. Create service layer for new OAuth
3. Update userController to use service
4. Maintain API contract
5. Add feature flag for rollback
```

**Validate plan against checklists:**

- Pre-generation checklist: ✓
- Architectural principles: Does it separate concerns? ✓
- Common pitfalls: Avoids mixing business + auth? ✓

**Save output:** `plan-auth-migration-users.md`

### Day 3+: Implementation Phase

**New conversation (fresh context):**

```txt
[Paste ai-context.md]
[Paste plan-auth-migration-users.md]

Implement step 1: Create OAuth service wrapper

Follow plan exactly. Stop if ambiguous.
