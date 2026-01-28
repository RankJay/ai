use crate::embed::{self, EmbeddedFile};
use crate::fs::update_gitignore;
use crate::git::find_repo_root;
use console::style;
use dialoguer::Confirm;
use thiserror::Error;

#[derive(Error, Debug)]
pub enum DoctorError {
    #[error("Not in a git repository")]
    NotInGitRepo,
    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),
    #[error("Dialog error: {0}")]
    Dialog(#[from] dialoguer::Error),
}

pub fn run(auto_fix: bool) -> Result<(), DoctorError> {
    let repo_root = find_repo_root()?.ok_or(DoctorError::NotInGitRepo)?;
    
    println!(
        "{} Checking repository at: {}",
        style("→").blue(),
        repo_root.display()
    );
    println!();

    let files = embed::get_all_files();
    let mut missing: Vec<&EmbeddedFile> = Vec::new();
    let mut present = 0;

    // Check each file existence
    for file in &files {
        let target = repo_root.join(file.target_path);
        if target.exists() {
            present += 1;
        } else {
            missing.push(file);
        }
    }

    // Check .gitignore entries
    let gitignore_path = repo_root.join(".gitignore");
    let gitignore_needs_update = if gitignore_path.exists() {
        let content = std::fs::read_to_string(&gitignore_path)?;
        !content.contains(".cursor/") || !content.contains(".ai/")
    } else {
        false
    };

    // Report results
    println!("{} Files present: {}/{}", style("✓").green(), present, files.len());
    
    if missing.is_empty() && !gitignore_needs_update {
        println!();
        println!("{} All checks passed!", style("✓").green().bold());
        return Ok(());
    }

    // Report missing files
    if !missing.is_empty() {
        println!();
        println!("{} Missing files:", style("✗").red());
        for file in &missing {
            println!("  - {}", file.target_path);
        }
    }

    // Report gitignore issues
    if gitignore_needs_update {
        println!();
        println!(
            "{} .gitignore missing entries for .cursor/ and/or .ai/",
            style("✗").red()
        );
    }

    // Offer to fix
    if !missing.is_empty() || gitignore_needs_update {
        println!();
        
        let should_fix = if auto_fix {
            true
        } else {
            Confirm::new()
                .with_prompt("Would you like to fix these issues?")
                .default(true)
                .interact()?
        };

        if should_fix {
            // Create missing files
            for file in &missing {
                let target = repo_root.join(file.target_path);
                if let Some(parent) = target.parent() {
                    std::fs::create_dir_all(parent)?;
                }
                std::fs::write(&target, file.content)?;
                println!("  {} Created {}", style("✓").green(), file.target_path);
            }

            // Fix gitignore
            if gitignore_needs_update {
                update_gitignore(&gitignore_path)?;
                println!("  {} Updated .gitignore", style("✓").green());
            }

            println!();
            println!("{} All issues fixed!", style("✓").green().bold());
        }
    }

    Ok(())
}
