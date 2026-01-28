use crate::upgrade::github::{get_latest_release, download_release_asset};
use console::style;
use dialoguer::Confirm;
use semver::Version;
use thiserror::Error;

const CURRENT_VERSION: &str = env!("CARGO_PKG_VERSION");
const GITHUB_REPO: &str = "RankJay/ai";

#[derive(Error, Debug)]
pub enum UpgradeError {
    #[error("Failed to check for updates: {0}")]
    CheckFailed(String),
    #[error("Failed to download update: {0}")]
    DownloadFailed(String),
    #[error("Failed to apply update: {0}")]
    ApplyFailed(String),
    #[error("User cancelled")]
    Cancelled,
}

pub fn run(skip_confirm: bool) -> Result<(), UpgradeError> {
    println!("{} Current version: v{}", style("→").blue(), CURRENT_VERSION);
    println!("{} Checking for updates...", style("→").blue());

    // 1. Get latest release from GitHub
    let latest = get_latest_release(GITHUB_REPO)
        .map_err(|e| UpgradeError::CheckFailed(e.to_string()))?;

    let current = Version::parse(CURRENT_VERSION).unwrap();
    let latest_version = Version::parse(&latest.version.trim_start_matches('v'))
        .map_err(|e| UpgradeError::CheckFailed(format!("Invalid version: {}", e)))?;

    // 2. Compare versions
    if latest_version <= current {
        println!(
            "{} Already up to date (v{})",
            style("✓").green().bold(),
            CURRENT_VERSION
        );
        return Ok(());
    }

    println!(
        "{} New version available: v{} → v{}",
        style("!").yellow(),
        CURRENT_VERSION,
        latest_version
    );

    // 3. Confirm upgrade
    if !skip_confirm {
        let confirm = Confirm::new()
            .with_prompt("Do you want to upgrade?")
            .default(true)
            .interact()
            .map_err(|e| UpgradeError::CheckFailed(e.to_string()))?;

        if !confirm {
            return Err(UpgradeError::Cancelled);
        }
    }

    // 4. Download platform-appropriate binary
    println!("{} Downloading...", style("→").blue());
    
    let asset_name = get_asset_name();
    let binary_data = download_release_asset(GITHUB_REPO, &latest.tag, &asset_name)
        .map_err(|e| UpgradeError::DownloadFailed(e.to_string()))?;

    // 5. Replace self
    println!("{} Installing...", style("→").blue());
    
    // Write binary data to a temporary file first
    let temp_dir = std::env::temp_dir();
    let temp_file = temp_dir.join(format!("ai-init-upgrade-{}", std::process::id()));
    std::fs::write(&temp_file, &binary_data)
        .map_err(|e| UpgradeError::ApplyFailed(format!("Failed to write temp file: {}", e)))?;
    
    self_replace::self_replace(&temp_file)
        .map_err(|e| UpgradeError::ApplyFailed(e.to_string()))?;
    
    // Clean up temp file (best effort, ignore errors)
    let _ = std::fs::remove_file(&temp_file);

    println!(
        "{} Successfully upgraded to v{}",
        style("✓").green().bold(),
        latest_version
    );

    Ok(())
}

/// Get platform-specific asset name
fn get_asset_name() -> String {
    let os = if cfg!(target_os = "windows") {
        "windows"
    } else if cfg!(target_os = "macos") {
        "darwin"
    } else {
        "linux"
    };

    let arch = if cfg!(target_arch = "x86_64") {
        "amd64"
    } else if cfg!(target_arch = "aarch64") {
        "arm64"
    } else {
        "amd64" // fallback
    };

    let ext = if cfg!(target_os = "windows") { ".exe" } else { "" };

    format!("ai-init-{}-{}{}", os, arch, ext)
}
