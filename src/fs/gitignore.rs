use std::fs;
use std::path::Path;

/// Update .gitignore to include .cursor/ and .ai/ if not present.
/// Returns true if file was modified.
pub fn update_gitignore(path: &Path) -> std::io::Result<bool> {
    let content = fs::read_to_string(path)?;
    let mut lines: Vec<&str> = content.lines().collect();
    let mut modified = false;

    // Check and add .cursor/
    if !lines
        .iter()
        .any(|l| l.trim() == ".cursor/" || l.trim() == ".cursor")
    {
        lines.push(".cursor/");
        modified = true;
    }

    // Check and add .ai/
    if !lines
        .iter()
        .any(|l| l.trim() == ".ai/" || l.trim() == ".ai")
    {
        lines.push(".ai/");
        modified = true;
    }

    if modified {
        let new_content = lines.join("\n") + "\n";
        fs::write(path, new_content)?;
    }

    Ok(modified)
}
