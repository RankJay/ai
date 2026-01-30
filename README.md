# ai-init

**Understanding must precede generation.** A CLI tool that embeds structured AI workflows into your repositories, transforming reactive debt-fixing into proactive, enterprise-grade development.

[![Release](https://img.shields.io/github/v/release/RankJay/ai?style=flat-square)](https://github.com/RankJay/ai/releases/latest)
[![License](https://img.shields.io/badge/license-PolyForm%20Noncommercial-blue?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macos%20%7C%20windows-lightgrey?style=flat-square)](https://github.com/RankJay/ai/releases)

## The Problem We're Solving

We've optimized for code generation speed while understanding velocity has remained constant. When you can generate 1000 lines in 30 seconds but need 30 minutes to understand them, you inevitably accumulate **incomprehension faster than insight**.

This creates a vicious cycle: AI generates code → you discover issues → you over-prompt to fix them → AI generates more code → the cycle repeats. You're not building systems; you're managing technical debt in real-time.

**The technical reality:** Without structure, AI treats technical debt as architectural requirements. Without guardrails, architectural coherence drifts with each conversational turn. Without context compression, you're constantly rediscovering what you already knew.

**The human cost:** Stress. Overhead. The constant weight of accumulating debt that you'll have to deal with later.

## The Philosophy

### Understanding Must Precede Generation

Speed is fine—even desirable. But clarity of approach is non-negotiable. The fastest path to production-ready code isn't generating more code; it's generating the *right* code, structured correctly from the start.

**Core principle:** Compress understanding before expanding code. Think first, generate second.

This manifests as a **three-phase workflow**:

1. **Research** → Understand the system before teaching AI to modify it
2. **Plan** → Make architectural decisions while you can still see them clearly  
3. **Implement** → Execute the validated specification, not invent solutions on the fly

### Essential vs Accidental Complexity

AI cannot distinguish between complexity inherent to the problem and complexity introduced by our solution approach. It treats technical debt as architectural requirements. You must explicitly identify and separate them.

**The ownership test:** If you can't explain it to a junior engineer, debug it at 3am without internet, and modify it confidently when requirements change—you don't own it yet.

### Context Compression

Each conversational turn optimizes for immediate satisfaction, not systemic coherence. AI has no memory of architectural intent across turns. This creates sedimentary layers of abandoned approaches.

**Solution:** Maintain `.ai/ai-context.md` as compressed knowledge—the 2000-word specification that represents 5 million tokens of code. Update it after every significant learning. Reference it before every architectural decision.

---

## How ai-init Embodies This Philosophy

**ai-init** isn't just a tool—it's philosophy as infrastructure. It embeds structured workflows, guardrails, and context management directly into your repositories, making consistency automatic and debt prevention systematic.

### What It Provides

**Templates** (`.ai/`): Research templates, planning frameworks, context compression patterns. The structure that prevents reactive fixing.

**Rules** (`.cursor/rules/`): Core principles, three-phase workflow enforcement, security patterns. The guardrails that prevent architectural drift.

**Commands** (`.cursor/commands/`): `/research`, `/plan`, `/implement`, `/review`. The workflows that enforce understanding-first development.

**Hooks** (`.cursor/hooks/`): Automatic context injection, post-edit validation, learning extraction. The automation that maintains coherence.

**Skills** (`.cursor/skills/`): Architecture decision frameworks, code review methodologies, security audit patterns. The expertise that elevates quality.

**Agents** (`.cursor/agents/`): Specialized AI personas for research and verification. The specialization that prevents AI-slop.

### The Technical Reality

When you run `ai-init init`, you're not just copying files. You're installing:

- **Proactive structure** instead of reactive fixing
- **Context compression** instead of constant rediscovery  
- **Architectural coherence** instead of conversational drift
- **Ownership validation** instead of incomprehension debt
- **Stress-free development** instead of accumulating overhead

**One command. Consistent across all projects. Self-contained binary. No external dependencies.**

---

## Installation

### Quick Install

**Linux / macOS:**

```bash
curl -fsSL https://raw.githubusercontent.com/RankJay/ai/main/install.sh | bash
```

**Windows (PowerShell):**

```powershell
iwr -useb https://raw.githubusercontent.com/RankJay/ai/main/install.ps1 | iex
```

> **Note for Windows users**: If you encounter execution policy restrictions, run:
>
> ```powershell
> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```

### Manual Installation

1. Download the appropriate binary for your platform from [GitHub Releases](https://github.com/RankJay/ai/releases/latest)
2. Verify the checksum against `checksums.txt`
3. Rename to `ai-init` (or `ai-init.exe` on Windows)
4. Make executable (Unix): `chmod +x ai-init`
5. Move to a directory in your PATH
6. Verify: `ai-init --version`

### Upgrading

```bash
ai-init upgrade
```

Or re-run the installation script to get the latest version.

---

## Usage

### Initialize Templates

Initialize AI workflow templates in the current git repository:

```bash
ai-init init
```

**Options:**

| Flag                  | Description                                        |
|-----------------------|----------------------------------------------------|
| `--only <categories>` | Install specific categories only (comma-separated) |
| `--skip <categories>` | Skip specific categories                           |
| `--force`             | Overwrite existing files without prompting         |

**Available categories:** `ai`, `rules`, `commands`, `hooks`, `skills`, `agents`

**Examples:**

```bash
# Install only AI templates and rules
ai-init init --only ai,rules

# Install everything except hooks
ai-init init --skip hooks

# Force overwrite all existing files
ai-init init --force
```

### Check Repository Health

Validate your repository for missing or broken AI workflow files:

```bash
ai-init doctor
```

**Options:**

| Flag    | Description                       |
|---------|-----------------------------------|
| `--fix` | Automatically fix detected issues |

### Uninstall Templates

Remove AI workflow files from the repository:

```bash
ai-init uninstall
```

**Options:**

| Flag      | Description                    |
|-----------|--------------------------------|
| `--force` | Remove files without prompting |

---

## The Workflow in Practice

### Phase 1: Research

**Goal:** Understand the system before teaching AI to modify it.

```bash
# Use the /research command (installed via ai-init)
/research [task description]
```

**Output:** A validated research document at `.ai/active-research.md` that maps dependencies, identifies essential vs accidental complexity, and compresses understanding into actionable knowledge.

**Technical reality:** You're building the foundation. Without this, you're generating code into a void.

### Phase 2: Planning

**Goal:** Make architectural decisions while you can still see them clearly.

```bash
# Use the /plan command (installed via ai-init)
/plan
```

**Output:** A validated plan at `.ai/active-plan.md` with signatures, types, data flow—"paint by numbers" clarity that a junior engineer could execute.

**Technical reality:** You're compressing architectural intent. Without this, each AI turn optimizes for local satisfaction, not systemic coherence.

### Phase 3: Implementation

**Goal:** Execute the validated specification.

```bash
# Use the /implement command (installed via ai-init)
/implement
```

**Output:** Code that follows the plan exactly. Review is conformance verification, not understanding what got invented.

**Technical reality:** You're generating code from understanding, not generating understanding from code.

---

## Commands

| Command     | Description                                                    |
|-------------|----------------------------------------------------------------|
| `init`      | Initialize AI workflow templates in the current git repository |
| `doctor`    | Check repository for missing or broken AI workflow files       |
| `upgrade`   | Upgrade ai-init to the latest version                          |
| `uninstall` | Remove AI workflow files from the repository                   |

---

## Built With

- [Rust](https://www.rust-lang.org/) - Systems programming language
- [clap](https://crates.io/crates/clap) - Command line argument parser
- [dialoguer](https://crates.io/crates/dialoguer) - Interactive CLI prompts
- [reqwest](https://crates.io/crates/reqwest) - HTTP client for downloads
- [self-replace](https://crates.io/crates/self-replace) - Atomic binary self-replacement

---

## Contributing

Contributions are welcome and appreciated. Please read [CONTRIBUTING.md](CONTRIBUTING.md) before submitting changes.

**Quick start:**

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -m 'Add your feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Open a Pull Request

By contributing, you agree that your contributions will be licensed under the same license as the project and that you assign copyright ownership to the project maintainer.

---

## Security

Security is taken seriously. Please review [SECURITY.md](SECURITY.md) for:

- Supported versions
- Reporting vulnerabilities
- Security practices

**Do not** open public issues for security vulnerabilities. Follow the responsible disclosure process in SECURITY.md.

---

## License

This project is licensed under the **PolyForm Noncommercial License 1.0.0**.

**You may:**

- Use for personal, research, educational, and noncommercial purposes
- Modify and create derivative works
- Distribute copies for noncommercial purposes

**You may not:**

- Use for commercial purposes or monetization
- Sublicense or transfer your license

See [LICENSE](LICENSE) for the full license text.

**Commercial licensing**: Contact the maintainer for commercial use inquiries.

---

## Contact

**RankJay** - Project Maintainer

- GitHub: [@RankJay](https://github.com/RankJay)
- Project: [https://github.com/RankJay/ai](https://github.com/RankJay/ai)
