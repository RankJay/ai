# Post-Generation Review

Run the post-generation validation checklist to detect AI-slop and ensure code quality.

## Checklist

For each piece of generated code, verify:

### 1. Explainability Test

**Can you explain how this works to a junior engineer?**

Not just "it authenticates users" but "it uses JWT tokens stored in httpOnly cookies, validates them against this service, and handles refresh via this mechanism."

- [ ] PASS: Can explain the mechanism in detail
- [ ] FAIL: Cannot explain how it works

### 2. Essential vs Accidental Complexity

**Is the complexity necessary or incidental?**

Essential = The inherent difficulty of the problem
Accidental = Complexity from our solution approach

- [ ] PASS: Complexity is justified and necessary
- [ ] CONCERN: Some accidental complexity exists
- [ ] FAIL: Significant unnecessary complexity

### 3. Modifiability Test

**Could you modify this if requirements changed?**

- [ ] PASS: Confident in making changes
- [ ] CONCERN: Would need significant research first
- [ ] FAIL: Would be afraid to touch this code

### 4. Debuggability Test

**Could you debug this at 3am without internet?**

- [ ] PASS: Could trace through and fix issues
- [ ] CONCERN: Would struggle with some parts
- [ ] FAIL: Would be lost

### 5. Pattern Compliance

**Does this follow patterns in ai-context.md?**

Check against:

- Architectural principles
- Established patterns
- Service boundaries
- Naming conventions

- [ ] PASS: Follows all established patterns
- [ ] CONCERN: Minor deviations
- [ ] FAIL: Violates established patterns

### 6. Anti-pattern Check

**Does this avoid pitfalls in ai-context.md?**

Check for:

- Known problematic patterns
- Architectural drift (OAuth.js + OAuth2.js pattern)
- Mixing concerns (auth + business logic)
- Technical debt being treated as requirements

- [ ] PASS: No anti-patterns detected
- [ ] CONCERN: Potential issues
- [ ] FAIL: Contains known anti-patterns

## Output Format

For each item, report:

- **PASS/CONCERN/FAIL** with explanation
- **Specific concerns** if FAIL or CONCERN
- **Suggestions for improvement**
- **Code snippets** showing problematic areas

## If Any FAIL

Recommend whether to:

- **Refactor before shipping** - Fix now
- **Add to technical debt tracker** - Fix later with plan
- **Flag for senior review** - Get expert opinion
- **Revert and revise plan** - Plan was insufficient

## AI-Slop Indicators

Watch for these red flags:

- Solutions that work but aren't maintainable
- Patterns that function but don't fit the architecture
- Code that passes tests but can't be explained
- Unnecessary complexity
- Multiple files solving the same problem differently

## After Review

If all items PASS:

1. Update `.ai/ai-context.md` if new patterns emerged
2. Proceed to `/commit`

If any items FAIL:

1. Address the issues
2. Re-run `/review`
3. Only commit when all items pass
