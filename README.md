# ai-init

A cross-platform CLI tool that initializes AI workflow templates in git repositories. Embed best practices, rules, commands, hooks, and skills directly into your projects.

[![Release](https://img.shields.io/github/v/release/RankJay/ai?style=flat-square)](https://github.com/RankJay/ai/releases/latest)
[![License](https://img.shields.io/badge/license-PolyForm%20Noncommercial-blue?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macos%20%7C%20windows-lightgrey?style=flat-square)](https://github.com/RankJay/ai/releases)

---

## Table of Contents

- [About](#about)
- [Features](#features)
- [Installation](#installation)
  - [Quick Install](#quick-install)
  - [Manual Installation](#manual-installation)
  - [Upgrading](#upgrading)
- [Usage](#usage)
  - [Initialize Templates](#initialize-templates)
  - [Check Repository Health](#check-repository-health)
  - [Uninstall Templates](#uninstall-templates)
- [Commands](#commands)
- [Built With](#built-with)
- [Contributing](#contributing)
- [Security](#security)
- [License](#license)
- [Contact](#contact)

---

## About

**ai-init** solves the problem of inconsistent AI workflow setups across projects. Instead of manually copying configuration files, templates, and best practices from project to project, ai-init embeds everything at compile time and deploys it with a single command.

The tool follows a three-phase workflow philosophy: **Research, Plan, Implement**. Templates include structured approaches for complex tasks, guardrails for AI-assisted development, and context management for maintaining architectural coherence.

### Why ai-init?

- **Consistency**: Same workflow templates across all your projects
- **Self-contained**: Single binary with no external dependencies
- **Cross-platform**: Native binaries for Linux, macOS, and Windows
- **Self-updating**: Built-in upgrade command fetches the latest release
- **Selective installation**: Choose which template categories to install

---

## Features

| Feature | Description |
|---------|-------------|
| Template Embedding | All templates compiled into binary at build time |
| Selective Install | Install only specific categories with `--only` or `--skip` |
| Repository Health | Validate and fix missing workflow files with `doctor` |
| Self-Upgrade | Atomic binary replacement via GitHub Releases |
| Cross-Platform | Native binaries for Linux, macOS (Intel/ARM), Windows |
| Checksum Verification | SHA256 verification for all downloads |

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

| Flag | Description |
|------|-------------|
| `--only <categories>` | Install specific categories only (comma-separated) |
| `--skip <categories>` | Skip specific categories |
| `--force` | Overwrite existing files without prompting |

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

| Flag | Description |
|------|-------------|
| `--fix` | Automatically fix detected issues |

### Uninstall Templates

Remove AI workflow files from the repository:

```bash
ai-init uninstall
```

**Options:**

| Flag | Description |
|------|-------------|
| `--force` | Remove files without prompting |

---

## Commands

| Command | Description |
|---------|-------------|
| `init` | Initialize AI workflow templates in the current git repository |
| `doctor` | Check repository for missing or broken AI workflow files |
| `upgrade` | Upgrade ai-init to the latest version |
| `uninstall` | Remove AI workflow files from the repository |

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
