use std::env;
use std::path::PathBuf;

/// Find the git repository root by looking for .git directory.
/// Checks current directory and one level up (immediate parent).
pub fn find_repo_root() -> std::io::Result<Option<PathBuf>> {
    let current = env::current_dir()?;

    // Check current directory
    if current.join(".git").exists() {
        return Ok(Some(current));
    }

    // Check parent directory (one level up only)
    if let Some(parent) = current.parent() {
        if parent.join(".git").exists() {
            return Ok(Some(parent.to_path_buf()));
        }
    }

    Ok(None)
}
