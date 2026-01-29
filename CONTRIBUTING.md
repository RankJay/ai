# Contributing to ai-init

Thank you for your interest in contributing to ai-init. This document outlines the process and guidelines for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Contributor License Agreement](#contributor-license-agreement)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Making Changes](#making-changes)
- [Pull Request Process](#pull-request-process)
- [Style Guidelines](#style-guidelines)
- [Reporting Issues](#reporting-issues)

---

## Code of Conduct

This project maintains a professional and respectful environment. Contributors are expected to:

- Be respectful and constructive in discussions
- Focus on technical merit in code reviews
- Accept feedback gracefully
- Help others learn and grow

Harassment, discrimination, and unprofessional behavior are not tolerated.

---

## Contributor License Agreement

By submitting a contribution to this project, you agree to the following terms:

1. **Copyright Assignment**: You assign all copyright and intellectual property rights in your contribution to the project maintainer (RankJay).

2. **Original Work**: You certify that your contribution is your original work, or you have the right to submit it under the project's license.

3. **No Warranty**: You provide your contribution "as is" without warranty of any kind.

4. **License Acknowledgment**: You acknowledge that your contribution will be licensed under the PolyForm Noncommercial License 1.0.0.

This agreement allows the maintainer to:
- Maintain unified copyright ownership
- Relicense the project if needed in the future
- Enforce the license against violators

If you cannot agree to these terms, please do not submit contributions.

---

## Getting Started

### Prerequisites

- [Rust](https://www.rust-lang.org/tools/install) (latest stable)
- Git
- A Unix-like environment (Linux, macOS, or WSL on Windows)

### Finding Work

- Check [open issues](https://github.com/RankJay/ai/issues) for bugs and feature requests
- Look for issues labeled `good first issue` for beginner-friendly tasks
- Review the roadmap for planned features

---

## Development Setup

1. **Fork and clone the repository**

   ```bash
   git clone https://github.com/YOUR_USERNAME/ai.git
   cd ai
   ```

2. **Build the project**

   ```bash
   cargo build
   ```

3. **Run tests**

   ```bash
   cargo test
   ```

4. **Run the binary locally**

   ```bash
   cargo run -- init
   cargo run -- doctor
   ```

### Project Structure

```
ai/
├── src/
│   ├── main.rs           # CLI entry point
│   ├── commands/         # Command implementations
│   ├── embed/            # Embedded file management
│   ├── fs/               # File system operations
│   ├── git/              # Git detection
│   └── upgrade/          # Self-upgrade logic
├── public/               # Template files (embedded at compile time)
├── install.sh            # Unix installation script
└── install.ps1           # Windows installation script
```

---

## Making Changes

### Branch Naming

Use descriptive branch names:

- `feature/add-new-command` - New features
- `fix/doctor-path-issue` - Bug fixes
- `docs/update-readme` - Documentation changes
- `refactor/simplify-fs-module` - Code refactoring

### Commit Messages

Write clear, concise commit messages:

```
Add --verbose flag to doctor command

- Show detailed file status during health check
- Include timestamps for modified files
- Add color-coded output for issues
```

- Use present tense ("Add feature" not "Added feature")
- First line is a summary (50 characters or less)
- Include details in the body if needed
- Reference issues when applicable (`Fixes #123`)

---

## Pull Request Process

1. **Update your fork** with the latest changes from `main`

   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Ensure all tests pass**

   ```bash
   cargo test
   cargo clippy
   cargo fmt --check
   ```

3. **Create the pull request**

   - Provide a clear description of the changes
   - Reference any related issues
   - Include testing instructions if applicable

4. **Address review feedback**

   - Respond to comments constructively
   - Push additional commits to address feedback
   - Request re-review when ready

### Pull Request Checklist

- [ ] Code compiles without warnings (`cargo build`)
- [ ] All tests pass (`cargo test`)
- [ ] Code is formatted (`cargo fmt`)
- [ ] No clippy warnings (`cargo clippy`)
- [ ] Documentation updated if needed
- [ ] Commit messages are clear and descriptive

---

## Style Guidelines

### Rust Code

- Follow standard Rust conventions
- Use `cargo fmt` for formatting
- Address all `cargo clippy` warnings
- Write documentation comments for public items
- Prefer explicit error handling over panics

### Templates and Scripts

- Keep scripts readable and auditable
- Add comments for non-obvious logic
- Test on all supported platforms when possible
- Follow platform conventions (bash for Unix, PowerShell for Windows)

### Documentation

- Use clear, concise language
- Include examples where helpful
- Keep the README focused on usage
- Put detailed documentation in appropriate files

---

## Reporting Issues

### Bug Reports

Include the following information:

- **Version**: Output of `ai-init --version`
- **Platform**: OS and architecture
- **Steps to reproduce**: Minimal steps to trigger the bug
- **Expected behavior**: What should happen
- **Actual behavior**: What actually happens
- **Error messages**: Full error output if applicable

### Feature Requests

Include:

- **Use case**: Why you need this feature
- **Proposed solution**: How you envision it working
- **Alternatives**: Other approaches you've considered

---

## Questions?

If you have questions about contributing, open a [discussion](https://github.com/RankJay/ai/discussions) or reach out to the maintainer.

Thank you for contributing to ai-init.
