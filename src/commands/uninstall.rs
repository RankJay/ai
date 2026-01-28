use crate::git::find_repo_root;
use console::style;
use dialoguer::Confirm;
use std::fs;
use thiserror::Error;

#[derive(Error, Debug)]
pub enum UninstallError {
    #[error("Not in a git repository")]
    NotInGitRepo,
    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),
    #[error("Dialog error: {0}")]
    Dialog(#[from] dialoguer::Error),
    #[error("User cancelled")]
    Cancelled,
}

pub fn run(force: bool) -> Result<(), UninstallError> {
    let repo_root = find_repo_root()?.ok_or(UninstallError::NotInGitRepo)?;

    let ai_dir = repo_root.join(".ai");
    let cursor_dir = repo_root.join(".cursor");

    let ai_exists = ai_dir.exists();
    let cursor_exists = cursor_dir.exists();

    if !ai_exists && !cursor_exists {
        println!(
            "{} Nothing to uninstall. No .ai/ or .cursor/ directories found.",
            style("✓").green()
        );
        return Ok(());
    }

    // Show what will be removed
    println!("{} The following will be removed:", style("!").yellow());
    if ai_exists {
        println!("  - .ai/");
    }
    if cursor_exists {
        println!("  - .cursor/");
    }

    // Confirm
    if !force {
        let confirm = Confirm::new()
            .with_prompt("Are you sure you want to remove these directories?")
            .default(false)
            .interact()?;

        if !confirm {
            return Err(UninstallError::Cancelled);
        }
    }

    // Remove directories
    if ai_exists {
        fs::remove_dir_all(&ai_dir)?;
        println!("  {} Removed .ai/", style("✓").green());
    }
    if cursor_exists {
        fs::remove_dir_all(&cursor_dir)?;
        println!("  {} Removed .cursor/", style("✓").green());
    }

    println!();
    println!("{} Uninstall complete.", style("✓").green().bold());

    Ok(())
}
