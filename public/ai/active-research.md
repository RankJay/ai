# Research: Rust CLI Distribution Tool

Date: 2026-01-27

## Task Overview

Create a Rust-based CLI binary that allows users to install this AI-assisted development framework into their Cursor workspace. The CLI should handle copying all framework files, setting up directory structures, and initializing required components.

## Components Involved

### Framework Structure (What needs to be distributed)

1. **`.cursor/rules/`** - Always-on AI guidelines (MDC files)
   - `core-principles.mdc`
   - `three-phase-workflow.mdc`
   - `ai-guidelines.mdc`
   - `security-patterns.mdc`

2. **`.cursor/commands/`** - User-invokable workflows (COMMAND.md files)
   - `research/COMMAND.md`
   - `plan/COMMAND.md`
   - `implement/COMMAND.md`
   - `review/COMMAND.md`
   - `commit/COMMAND.md`

3. **`.cursor/skills/`** - Specialized capabilities (SKILL.md files)
   - `architecture-decision/SKILL.md`
   - `code-review/SKILL.md`
   - `research-methodology/SKILL.md`
   - `security-audit/SKILL.md`

4. **`.cursor/hooks/`** - Automated guardrails
   - `hooks.json` - Hook configuration
   - `inject-context.ps1` - SessionStart hook script
   - `post-edit-check.ps1` - AfterFileEdit hook script
   - `extract-learnings.ps1` - Stop hook script

5. **`.ai/`** - Active context and working documents
   - `ai-context.md` - Project knowledge (user will customize)
   - `ai-guardrails.md` - Checklists (if exists)
   - `template/` - Templates for research.md and plan.md

### CLI Requirements

- **Installation**: Copy framework files to target workspace
- **Initialization**: Create `.ai/` directory structure with templates
- **Validation**: Check if Cursor workspace exists, detect conflicts
- **Cross-platform**: Must work on Windows, macOS, Linux
- **Distribution**: Binary distribution (crates.io, GitHub releases, or both)

## Dependencies

### External Dependencies (Rust ecosystem)

- **CLI framework**: `clap` (most popular, feature-rich) or `argh` (minimal)
- **File operations**: `std::fs` (standard library) + `walkdir` for recursive directory traversal
- **Path handling**: `std::path` + `path-slash` for cross-platform paths
- **Error handling**: `anyhow` or `thiserror` for error propagation
- **Logging**: `env_logger` or `tracing` for user feedback
- **Template processing**: `handlebars` or simple string replacement
- **Archive/embedding**: `include_dir` to embed framework files in binary

### Platform Considerations

- **Windows**: PowerShell scripts (.ps1) - hooks use PowerShell
- **macOS/Linux**: May need to handle script execution differently
- **Path separators**: Framework uses relative paths, hooks reference `$PSScriptRoot`

## Current Implementation

### Manual Installation Process (Current State)

Users currently must:
1. Clone or download this repository
2. Manually copy `.cursor/` directory to their workspace root
3. Manually create `.ai/` directory
4. Copy `ai-context.md` template (or create from scratch)
5. Customize `ai-context.md` for their project

### Hook Path References

Critical discovery: Hooks use relative paths that assume specific structure:
- `inject-context.ps1` references `..\..\..\.ai\ai-context.md` (3 levels up from hooks dir)
- `post-edit-check.ps1` references `..\..\..\.ai\edit-log.txt`
- This means hooks must be at `.cursor/hooks/` and `.ai/` must be at workspace root

## Constraints

### Technical Constraints

1. **PowerShell dependency**: Hooks are PowerShell scripts - Windows native, but macOS/Linux need PowerShell Core installed
2. **Path assumptions**: Hooks assume specific directory structure (`.cursor/hooks/` relative to workspace root)
3. **Cursor workspace detection**: Need to identify Cursor workspace root (may differ from git root)
4. **Conflict handling**: What if `.cursor/rules/` already exists? Overwrite? Merge? Skip?

### User Experience Constraints

1. **Non-destructive**: Should not overwrite user's existing customizations
2. **Idempotent**: Running install twice should be safe (detect existing installation)
3. **Clear feedback**: User should understand what was installed and what to do next
4. **Minimal dependencies**: Binary should be self-contained (embed framework files)

### Distribution Constraints

1. **Binary size**: Embedding all framework files increases binary size
2. **Update mechanism**: How do users update to new framework versions?
3. **Versioning**: CLI should report version, framework should have version

## Questions/Uncertainties

### Architecture Questions

1. **File embedding strategy**: 
   - Option A: Embed all files in binary using `include_dir!` macro (larger binary, simpler)
   - Option B: Download from GitHub release on first run (smaller binary, requires network)
   - Option C: Bundle as tarball/zip alongside binary (medium size, requires extraction)

2. **Workspace detection**:
   - How to detect Cursor workspace root? Look for `.cursor/` directory? Check parent directories?
   - What if user runs CLI from subdirectory?

3. **Conflict resolution**:
   - If `.cursor/rules/core-principles.mdc` exists, should we:
     - Skip (preserve user changes)
     - Overwrite (force update)
     - Backup and replace (safe update)
     - Merge (complex, probably not worth it)

4. **Initialization scope**:
   - Should CLI create `.ai/ai-context.md` from template?
   - Should it be empty or have example content?
   - Should CLI create `.ai/archive/` directory?

5. **PowerShell on non-Windows**:
   - Hooks are PowerShell scripts - will they work on macOS/Linux?
   - Should CLI check for PowerShell availability?
   - Should CLI provide alternative shell scripts?

### Distribution Questions

1. **Release mechanism**:
   - Publish to crates.io as `ai-dev-framework-installer`?
   - GitHub Releases with pre-built binaries?
   - Both?

2. **Update strategy**:
   - Should CLI have `update` command to fetch latest framework version?
   - How to version framework files vs CLI version?

3. **Installation scope**:
   - Global install (`cargo install`) vs project-local?
   - Should CLI support both?

## Essential vs Accidental Complexity

### Essential Complexity

- Copying files to correct locations
- Creating directory structure
- Detecting workspace root
- Handling conflicts gracefully
- Cross-platform path handling

### Accidental Complexity (to avoid)

- Complex merge logic for existing files
- Dependency on external services for file fetching
- Over-engineered update mechanisms
- Trying to support every edge case upfront

## Research Findings

### Rust CLI Best Practices

- Use `clap` with derive macros for clean CLI definition
- Use `anyhow` for error handling (simpler than `thiserror` for CLI apps)
- Use `include_dir!` macro to embed static files in binary
- Use `walkdir` for recursive directory operations
- Use `std::fs::create_dir_all` for directory creation

### Cursor Workspace Structure

- Cursor workspace root is typically where `.cursor/` directory lives
- Can detect by looking for `.cursor/` directory in current or parent directories
- Workspace root may differ from git root (user might have nested repos)

### PowerShell Cross-Platform

- PowerShell Core (pwsh) is available on macOS/Linux
- Scripts should work if PowerShell Core is installed
- CLI should check for PowerShell availability or provide clear error

## Next Steps

1. **Decision needed**: File embedding strategy (recommend Option A - embed in binary for simplicity)
2. **Decision needed**: Conflict resolution strategy (recommend backup-and-replace for safety)
3. **Decision needed**: Initialization scope (recommend creating `.ai/` with template files)
4. **Decision needed**: Distribution method (recommend both crates.io and GitHub releases)

## Validation Checklist

- [ ] Understand what files need to be distributed ✓
- [ ] Understand directory structure requirements ✓
- [ ] Understand hook path dependencies ✓
- [ ] Identify platform considerations ✓
- [ ] Identify key architectural decisions needed ✓
- [ ] Research Rust CLI best practices ✓
