use dialoguer::Confirm;
use std::fs;
use std::path::Path;

pub enum CopyResult {
    Created,
    Overwritten,
    Skipped,
}

/// Copy content to target path, prompting if file exists (unless force=true)
pub fn copy_with_prompt(
    target: &Path,
    content: &str,
    force: bool,
) -> std::io::Result<CopyResult> {
    // Ensure parent directories exist
    if let Some(parent) = target.parent() {
        fs::create_dir_all(parent)?;
    }

    // Check if file exists
    if target.exists() {
        if force {
            fs::write(target, content)?;
            return Ok(CopyResult::Overwritten);
        }

        // Prompt user
        let prompt = format!(
            "File exists: {}. Overwrite?",
            target.file_name().unwrap_or_default().to_string_lossy()
        );

        let overwrite = Confirm::new()
            .with_prompt(prompt)
            .default(false)
            .interact()
            .unwrap_or(false);

        if overwrite {
            fs::write(target, content)?;
            Ok(CopyResult::Overwritten)
        } else {
            Ok(CopyResult::Skipped)
        }
    } else {
        fs::write(target, content)?;
        Ok(CopyResult::Created)
    }
}
