# ai-init

CLI tool to initialize AI workflow templates in git repositories.

## Installation

### Quick Install

**Linux/macOS:**

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

If you prefer to install manually:

1. Download the appropriate binary for your platform from [GitHub Releases](https://github.com/RankJay/ai/releases/latest)
2. Rename it to `ai-init` (or `ai-init.exe` on Windows)
3. Make it executable (Unix): `chmod +x ai-init`
4. Move it to a directory in your PATH (e.g., `~/.local/bin` or `/usr/local/bin`)
5. Verify installation: `ai-init --version`

### Upgrade

To upgrade to the latest version:

```bash
ai-init upgrade
```

Or re-run the installation script.

## Usage

### Initialize AI Workflow Templates

Initialize AI workflow templates in the current git repository:

```bash
ai-init init
```

**Options:**

- `--only <categories>`: Only install specific categories (comma-separated: ai,rules,commands,hooks,skills,agents)
- `--skip <categories>`: Skip specific categories
- `--force`: Overwrite existing files without prompting

**Examples:**

```bash
# Install only AI templates
ai-init init --only ai

# Skip hooks
ai-init init --skip hooks

# Force overwrite all files
ai-init init --force
```

### Check Repository Health

Check your repository for missing or broken AI workflow files:

```bash
ai-init doctor
```

**Options:**

- `--fix`: Automatically fix detected issues

### Upgrade ai-init

Upgrade ai-init to the latest version:

```bash
ai-init upgrade
```

**Options:**

- `-y, --yes`: Skip confirmation prompt

### Uninstall

Remove AI workflow files from the repository:

```bash
ai-init uninstall
```

**Options:**

- `--force`: Remove files without prompting

## Commands

- `init` - Initialize AI workflow templates in the current git repository
- `doctor` - Check repository for missing or broken AI workflow files
- `upgrade` - Upgrade ai-init to the latest version
- `uninstall` - Remove AI workflow files from the repository
