# Plan: Rust CLI Distribution Tool

Date: 2026-01-27

## Architectural Decisions

### Decisions Made (from user input)

1. **File embedding**: Download from GitHub release on first run (smaller binary, requires network)
2. **Conflict resolution**: User option for skip or overwrite (interactive choice)
3. **Distribution**: GitHub Releases with pre-built binaries

### Additional Decisions

1. **CLI project location**: Create `cli/` directory at repository root (keeps CLI separate from framework)
2. **CLI name**: `ai-dev-framework-installer` (descriptive, matches purpose)
3. **CLI commands**:
   - `install` (default) - Install framework to current or specified workspace
   - `version` - Show CLI and framework versions
   - `update` - Update framework files from latest GitHub release
4. **Workspace detection**: Search current directory and parents for `.cursor/` directory (indicates Cursor workspace)
5. **Version tracking**: Store framework version in `.ai/.framework-version` file after installation
6. **Cache strategy**: Download framework files to temp directory, extract, then copy to workspace

## Implementation Steps

### Step 1: Create Rust CLI Project Structure

1. Create `cli/` directory at repository root
2. Initialize Rust project: `cargo init --name ai-dev-framework-installer --bin` in `cli/`
3. Create `cli/Cargo.toml` with dependencies:
   - `clap = { version = "4.5", features = ["derive"] }` - CLI framework
   - `anyhow = "1.0"` - Error handling
   - `reqwest = { version = "0.12", features = ["blocking", "json"] }` - HTTP client for GitHub API
   - `serde = { version = "1.0", features = ["derive"] }` - JSON deserialization
   - `serde_json = "1.0"` - JSON parsing
   - `zip = "0.6"` - Extract downloaded zip files
   - `walkdir = "2.4"` - Recursive directory traversal
   - `dirs = "5.0"` - Get temp directory paths
   - `console = "0.15"` - Terminal output styling

### Step 2: Define CLI Structure

**File**: `cli/src/main.rs`

Structure:

- `main()` function: Parse CLI args, dispatch to command handlers
- `Cli` struct with `clap::Parser` derive
- Commands enum: `Install`, `Version`, `Update`
- Each command has its own handler function

**CLI Args**:

```rust
#[derive(Parser)]
#[command(name = "ai-dev-framework-installer")]
#[command(about = "Install AI-assisted development framework into Cursor workspace")]
struct Cli {
    #[command(subcommand)]
    command: Option<Commands>,
    
    #[arg(long, help = "Target workspace directory (default: auto-detect)")]
    workspace: Option<PathBuf>,
    
    #[arg(long, help = "Skip interactive prompts (use defaults)")]
    yes: bool,
}

#[derive(Subcommand)]
enum Commands {
    /// Install framework into workspace
    Install {
        #[arg(long, help = "Target workspace directory")]
        workspace: Option<PathBuf>,
    },
    /// Show CLI and framework versions
    Version,
    /// Update framework files from latest release
    Update {
        #[arg(long, help = "Target workspace directory")]
        workspace: Option<PathBuf>,
    },
}
```

### Step 3: Implement Workspace Detection

**File**: `cli/src/workspace.rs`

Function signature:

```rust
pub fn find_workspace_root(start_dir: &Path) -> anyhow::Result<PathBuf>
```

Logic:

1. Start from `start_dir` (current directory or user-specified)
2. Check if `.cursor/` directory exists in current directory
3. If not found, check parent directory
4. Repeat until root filesystem or found
5. Return error if not found: "No Cursor workspace found. Run from workspace root or specify --workspace"

### Step 4: Implement GitHub Release Download

**File**: `cli/src/github.rs`

Function signatures:

```rust
pub struct ReleaseInfo {
    pub tag_name: String,
    pub assets: Vec<Asset>,
}

pub struct Asset {
    pub name: String,
    pub download_url: String,
}

pub fn get_latest_release() -> anyhow::Result<ReleaseInfo>
pub fn download_asset(asset_url: &str, dest_path: &Path) -> anyhow::Result<()>
```

Logic:

1. `get_latest_release()`: GET `https://api.github.com/repos/[OWNER]/[REPO]/releases/latest`
   - Parse JSON response
   - Extract `tag_name` and `assets` array
   - Find asset with name matching pattern `framework-*.zip` (or similar)
   - Return `ReleaseInfo`
2. `download_asset()`: Download file from URL to destination path
   - Use `reqwest::blocking::get()`
   - Write to file using `std::fs::File::create()`
   - Show progress indicator

**Note**: Replace `[OWNER]` and `[REPO]` with actual GitHub repository owner/name. This should be configurable or detected from git remote.

### Step 5: Implement Framework Extraction

**File**: `cli/src/extract.rs`

Function signature:

```rust
pub fn extract_framework(zip_path: &Path, temp_dir: &Path) -> anyhow::Result<PathBuf>
```

Logic:

1. Create temp directory using `dirs::cache_dir()` + `ai-dev-framework/`
2. Extract zip file to temp directory using `zip::ZipArchive`
3. Find extracted root (should contain `.cursor/` directory)
4. Return path to extracted root

### Step 6: Implement Conflict Detection and Resolution

**File**: `cli/src/install.rs`

Function signatures:

```rust
pub struct Conflict {
    pub path: PathBuf,
    pub reason: ConflictReason,
}

pub enum ConflictReason {
    FileExists,
    DirectoryExists,
}

pub fn detect_conflicts(framework_root: &Path, workspace_root: &Path) -> Vec<Conflict>
pub fn resolve_conflict(conflict: &Conflict, action: ConflictAction) -> anyhow::Result<()>

pub enum ConflictAction {
    Skip,
    Overwrite,
}
```

Logic:

1. `detect_conflicts()`:
   - Walk framework directory structure using `walkdir::WalkDir`
   - For each file in framework, check if corresponding file exists in workspace
   - Return list of conflicts
2. `resolve_conflict()`:
   - If `Skip`: Do nothing
   - If `Overwrite`: Copy file from framework to workspace (create parent dirs if needed)

### Step 7: Implement Interactive Conflict Resolution

**File**: `cli/src/prompt.rs`

Function signature:

```rust
pub fn prompt_conflict_resolution(conflicts: &[Conflict]) -> anyhow::Result<Vec<(PathBuf, ConflictAction)>>
```

Logic:

1. Display each conflict with path
2. For each conflict, prompt: "File exists: {path}. [S]kip, [O]verwrite, [A]ll overwrite, [Q]uit?"
3. Parse user input (single char: s, o, a, q)
4. Return vector of (path, action) pairs
5. If "all overwrite" selected, apply to all remaining conflicts

### Step 8: Implement Framework Installation

**File**: `cli/src/install.rs`

Function signature:

```rust
pub fn install_framework(
    workspace_root: &Path,
    framework_root: &Path,
    conflicts: Vec<(PathBuf, ConflictAction)>,
    non_interactive: bool,
) -> anyhow::Result<()>
```

Logic:

1. Walk framework directory structure
2. For each file:
   - Check if in conflicts list
   - If conflict exists and action is Skip, continue to next file
   - Otherwise, copy file to workspace (preserving relative path structure)
   - Create parent directories as needed using `std::fs::create_dir_all()`
3. Create `.ai/` directory structure:
   - `.ai/template/` directory
   - Copy `template/research.md` and `template/plan.md` if they exist in framework
   - Create `.ai/archive/` directory
4. Write framework version to `.ai/.framework-version` file

### Step 9: Implement Main Install Command

**File**: `cli/src/main.rs` (in install command handler)

Logic:

1. Determine workspace root (use `--workspace` arg or auto-detect)
2. Check if framework already installed (check for `.ai/.framework-version`)
3. If installed and not `--force`, prompt: "Framework already installed. Update? [y/N]"
4. Get latest release from GitHub
5. Download framework zip to temp file
6. Extract framework to temp directory
7. Detect conflicts
8. If conflicts exist and not `--yes` flag, prompt user for resolution
9. Install framework files
10. Display success message with next steps

### Step 10: Implement Version Command

**File**: `cli/src/main.rs` (in version command handler)

Logic:

1. Read CLI version from `Cargo.toml` (via `env!("CARGO_PKG_VERSION")`)
2. Check if workspace has installed framework (read `.ai/.framework-version`)
3. Display:

   ```txt
   CLI Version: {version}
   Framework Version: {installed_version or "Not installed"}
   Latest Available: {latest_release_tag}
   ```

### Step 11: Implement Update Command

**File**: `cli/src/main.rs` (in update command handler)

Logic:

1. Determine workspace root
2. Check if framework installed (error if not)
3. Get latest release from GitHub
4. Compare with installed version (read `.ai/.framework-version`)
5. If same version, display "Already up to date"
6. Otherwise, proceed with install logic (reuse install function)

### Step 12: Add Error Handling and User Feedback

**File**: `cli/src/error.rs` (optional, or use anyhow context)

- Use `anyhow::Context` for error messages
- Display user-friendly error messages
- Use `console::style()` for colored output (success=green, error=red, info=blue)

### Step 13: Create GitHub Release Asset Structure

**Note**: This is a manual step, but document the process:

1. Create zip file containing framework files:
   - Structure: `framework-{version}.zip`
   - Contents: All `.cursor/` and `.ai/template/` directories
   - Exclude: `.ai/active-*`, `.ai/archive/`, `.git/`, etc.
2. Upload to GitHub Releases
3. Tag release with version (e.g., `v1.0.0`)

### Step 14: Update .gitignore

Add to `.gitignore`:

```txt
# Rust build artifacts
cli/target/
cli/Cargo.lock
```

### Step 15: Create README for CLI

**File**: `cli/README.md`

Document:

- Installation instructions (download from GitHub Releases)
- Usage examples
- Commands reference
- Requirements (PowerShell for hooks on non-Windows)

## File Changes

### Create

- `cli/Cargo.toml` - Rust project configuration
- `cli/src/main.rs` - CLI entry point and command dispatch
- `cli/src/workspace.rs` - Workspace detection logic
- `cli/src/github.rs` - GitHub API interaction
- `cli/src/extract.rs` - Zip extraction logic
- `cli/src/install.rs` - Framework installation logic
- `cli/src/prompt.rs` - Interactive prompts
- `cli/README.md` - CLI documentation
- `.github/workflows/release.yml` - GitHub Actions workflow for building and releasing binaries

### Modify

- `.gitignore` - Add Rust build artifacts

### Delete

- None

## Function Signatures/Types

### Core Types

```rust
// cli/src/main.rs
pub struct Cli { ... }
pub enum Commands { ... }

// cli/src/workspace.rs
pub fn find_workspace_root(start_dir: &Path) -> anyhow::Result<PathBuf>

// cli/src/github.rs
pub struct ReleaseInfo { tag_name: String, assets: Vec<Asset> }
pub struct Asset { name: String, download_url: String }
pub fn get_latest_release() -> anyhow::Result<ReleaseInfo>
pub fn download_asset(asset_url: &str, dest_path: &Path) -> anyhow::Result<()>

// cli/src/extract.rs
pub fn extract_framework(zip_path: &Path, temp_dir: &Path) -> anyhow::Result<PathBuf>

// cli/src/install.rs
pub struct Conflict { path: PathBuf, reason: ConflictReason }
pub enum ConflictReason { FileExists, DirectoryExists }
pub enum ConflictAction { Skip, Overwrite }
pub fn detect_conflicts(framework_root: &Path, workspace_root: &Path) -> Vec<Conflict>
pub fn resolve_conflict(conflict: &Conflict, action: ConflictAction) -> anyhow::Result<()>
pub fn install_framework(...) -> anyhow::Result<()>

// cli/src/prompt.rs
pub fn prompt_conflict_resolution(conflicts: &[Conflict]) -> anyhow::Result<Vec<(PathBuf, ConflictAction)>>
```

## Data Flow

1. **User runs CLI**: `ai-dev-framework-installer install`
2. **Workspace detection**: CLI searches for `.cursor/` directory (current dir → parents)
3. **GitHub API call**: Fetch latest release info (tag, assets)
4. **Download**: Download framework zip to temp directory
5. **Extract**: Extract zip to temp directory, locate framework root
6. **Conflict detection**: Walk framework files, check if exist in workspace
7. **User interaction**: If conflicts and not `--yes`, prompt for each conflict
8. **Installation**: Copy files from framework to workspace (respecting skip/overwrite decisions)
9. **Version tracking**: Write framework version to `.ai/.framework-version`
10. **Success message**: Display installation summary

## Testing Strategy

### Manual Testing Scenarios

1. **Fresh installation**:
   - Run `install` in empty directory → should error (no workspace)
   - Run `install` in Cursor workspace → should download and install

2. **Conflict handling**:
   - Install framework
   - Modify a rule file
   - Run `install` again → should detect conflict and prompt

3. **Update**:
   - Install old version
   - Run `update` → should fetch latest and update

4. **Version check**:
   - Run `version` → should show CLI and framework versions

### Unit Tests (if time permits)

- `workspace.rs`: Test workspace detection logic
- `github.rs`: Mock GitHub API responses
- `install.rs`: Test conflict detection

## Rollback Plan

1. **If CLI has bugs**: Users can manually delete `.cursor/` and `.ai/` directories
2. **If framework files corrupted**: Re-run `install` command (will re-download)
3. **If wrong version installed**: Run `update` to get correct version
4. **Git integration**: Framework files should be committed to git, so users can `git checkout` to restore

## Validation Checklist

- [x] Follows patterns from ai-context.md (simple over easy, essential vs accidental)
- [x] Avoids anti-patterns (no complex merge logic, no over-engineering)
- [x] Separates essential from accidental complexity (download/extract/install are separate concerns)
- [x] A junior engineer could follow this plan (specific file paths, function signatures, logic flow)
- [x] Blast radius is understood (new `cli/` directory, no changes to existing framework)
- [x] No architectural drift (single CLI tool, not multiple installers)

## Open Questions (Resolved)

1. ✅ File embedding: Download from GitHub (user decision)
2. ✅ Conflict resolution: User option skip/overwrite (user decision)
3. ✅ Distribution: GitHub Releases (user decision)
4. ✅ Workspace detection: Search for `.cursor/` directory (plan decision)
5. ✅ CLI location: `cli/` directory at root (plan decision)

## Notes

- GitHub repository owner/name needs to be configured (could be env var or detected from git remote)
- PowerShell availability check could be added but hooks will fail gracefully if not available
- Framework version should match GitHub release tag format (e.g., `v1.0.0`)
