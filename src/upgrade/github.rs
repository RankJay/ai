use serde::Deserialize;
use thiserror::Error;

#[derive(Error, Debug)]
pub enum GithubError {
    #[error("HTTP request failed: {0}")]
    Request(#[from] reqwest::Error),
    #[error("Release not found")]
    NotFound,
    #[error("Asset not found: {0}")]
    AssetNotFound(String),
}

#[derive(Debug, Deserialize)]
pub struct Release {
    pub tag_name: String,
    pub assets: Vec<Asset>,
}

#[derive(Debug, Deserialize)]
pub struct Asset {
    pub name: String,
    pub browser_download_url: String,
}

pub struct LatestRelease {
    pub version: String,
    pub tag: String,
}

/// Get latest release info from GitHub
pub fn get_latest_release(repo: &str) -> Result<LatestRelease, GithubError> {
    let url = format!("https://api.github.com/repos/{}/releases/latest", repo);

    let client = reqwest::blocking::Client::new();
    let response = client.get(&url).header("User-Agent", "ai-init").send()?;

    if response.status() == 404 {
        return Err(GithubError::NotFound);
    }

    let release: Release = response.json()?;

    Ok(LatestRelease {
        version: release.tag_name.clone(),
        tag: release.tag_name,
    })
}

/// Download a release asset
pub fn download_release_asset(
    repo: &str,
    tag: &str,
    asset_name: &str,
) -> Result<Vec<u8>, GithubError> {
    // First, get the release to find asset URL
    let url = format!(
        "https://api.github.com/repos/{}/releases/tags/{}",
        repo, tag
    );

    let client = reqwest::blocking::Client::new();
    let response = client.get(&url).header("User-Agent", "ai-init").send()?;

    let release: Release = response.json()?;

    // Find the matching asset
    let asset = release
        .assets
        .iter()
        .find(|a| a.name == asset_name)
        .ok_or_else(|| GithubError::AssetNotFound(asset_name.to_string()))?;

    // Download the asset
    let data = client
        .get(&asset.browser_download_url)
        .header("User-Agent", "ai-init")
        .send()?
        .bytes()?
        .to_vec();

    Ok(data)
}
