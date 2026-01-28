use crate::embed::{self, FileCategory};
use crate::fs::{copy_with_prompt, update_gitignore};
use crate::git::find_repo_root;
use console::style;
use thiserror::Error;

#[derive(Error, Debug)]
pub enum InitError {
    #[error(
        "Not in a git repository. Run from a directory with .git or its immediate subdirectory."
    )]
    NotInGitRepo,
    #[error("Invalid category: {0}. Valid: ai, rules, commands, hooks, skills, agents")]
    InvalidCategory(String),
    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),
    // #[error("User cancelled")]
    // Cancelled,
}

pub fn run(
    only: Option<Vec<String>>,
    skip: Option<Vec<String>>,
    force: bool,
) -> Result<(), InitError> {
    // 1. Find git repo root
    let repo_root = find_repo_root()?.ok_or(InitError::NotInGitRepo)?;

    println!(
        "{} Found git repository at: {}",
        style("✓").green(),
        repo_root.display()
    );

    // 2. Parse category filters
    let only_cats = parse_categories(only)?;
    let skip_cats = parse_categories(skip)?;

    // 3. Get filtered file list
    let files = embed::get_files_by_categories(only_cats.as_deref(), skip_cats.as_deref());

    println!("{} Installing {} files...", style("→").blue(), files.len());

    // 4. Copy each file
    let mut installed = 0;
    let mut skipped = 0;

    for file in &files {
        let target = repo_root.join(file.target_path);

        match copy_with_prompt(&target, file.content, force)? {
            crate::fs::CopyResult::Created | crate::fs::CopyResult::Overwritten => {
                println!("  {} {}", style("✓").green(), file.target_path);
                installed += 1;
            }
            crate::fs::CopyResult::Skipped => {
                println!("  {} {} (skipped)", style("-").yellow(), file.target_path);
                skipped += 1;
            }
        }
    }

    // 5. Update .gitignore
    let gitignore_path = repo_root.join(".gitignore");
    if gitignore_path.exists() {
        let updated = update_gitignore(&gitignore_path)?;
        if updated {
            println!(
                "  {} .gitignore (added .cursor/ and .ai/)",
                style("✓").green()
            );
        }
    }

    // 6. Summary
    println!();
    println!(
        "{} Installation complete: {} installed, {} skipped",
        style("✓").green().bold(),
        installed,
        skipped
    );

    Ok(())
}

fn parse_categories(cats: Option<Vec<String>>) -> Result<Option<Vec<FileCategory>>, InitError> {
    match cats {
        None => Ok(None),
        Some(strs) => {
            let mut result = Vec::new();
            for s in strs {
                let cat = FileCategory::from_str(&s)
                    .ok_or_else(|| InitError::InvalidCategory(s.clone()))?;
                result.push(cat);
            }
            Ok(Some(result))
        }
    }
}
