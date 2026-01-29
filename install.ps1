#Requires -Version 5.1

$ErrorActionPreference = "Stop"

# Constants
$REPO = "RankJay/ai"
$GITHUB_API = "https://api.github.com/repos/${REPO}/releases/latest"
$DEFAULT_INSTALL_DIR = "$env:LOCALAPPDATA\Programs\ai-init"
$BINARY_NAME = "ai-init.exe"

# Get platform information
function Get-PlatformInfo {
    $arch = if ([Environment]::Is64BitOperatingSystem) { "amd64" } else { "unsupported" }
    return @{
        OS = "windows"
        Arch = $arch
    }
}

# Prompt for installation directory
function Get-InstallDirectory {
    param([string]$Default)
    $prompt = "Installation directory [${Default}]: "
    $userInput = Read-Host -Prompt $prompt
    if ([string]::IsNullOrWhiteSpace($userInput)) {
        return $Default
    }
    return $userInput
}

# Check if ai-init is already installed
function Test-ExistingInstallation {
    param([string]$InstallDir)
    $binaryPath = Join-Path $InstallDir $BINARY_NAME
    return Test-Path $binaryPath
}

# Prompt user for upgrade
function Request-Upgrade {
    param([string]$InstallPath)
    Write-Host "ai-init is already installed at ${InstallPath}" -ForegroundColor Yellow
    $response = Read-Host "Upgrade? [Y/n]"
    return $response -notmatch "^[Nn]"
}

# Get latest release from GitHub API
function Get-LatestRelease {
    try {
        $response = Invoke-RestMethod -Uri $GITHUB_API -Headers @{"User-Agent"="ai-init-installer"}
        return @{
            Tag = $response.tag_name
            Version = $response.tag_name.TrimStart('v')
        }
    }
    catch {
        Write-Error "Failed to fetch latest release: $_"
        exit 1
    }
}

# Get asset name for platform
function Get-AssetName {
    param(
        [string]$OS,
        [string]$Arch
    )
    return "ai-init-${OS}-${Arch}.exe"
}

# Download file
function Download-File {
    param(
        [string]$Url,
        [string]$OutputPath
    )
    try {
        Write-Host "Downloading from ${Url}..."
        Invoke-WebRequest -Uri $Url -OutFile $OutputPath -UseBasicParsing
    }
    catch {
        Write-Error "Failed to download ${Url}: $_"
        exit 1
    }
}

# Verify SHA256 checksum
function Test-Checksum {
    param(
        [string]$BinaryPath,
        [string]$ChecksumsPath
    )
    $assetName = Split-Path $BinaryPath -Leaf
    $checksumLine = Get-Content $ChecksumsPath | Select-String $assetName
    if (-not $checksumLine) {
        return $false
    }
    $expectedHash = $checksumLine.ToString().Split()[0]
    $actualHash = (Get-FileHash -Path $BinaryPath -Algorithm SHA256).Hash.ToLower()
    return $expectedHash -eq $actualHash
}

# Add directory to user PATH
function Add-ToPath {
    param([string]$InstallDir)
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*${InstallDir}*") {
        $newPath = "${InstallDir};${currentPath}"
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
        $env:Path = "${InstallDir};${env:Path}"
        Write-Host "Added ${InstallDir} to PATH" -ForegroundColor Green
    }
    else {
        Write-Host "${InstallDir} is already in PATH" -ForegroundColor Yellow
    }
}

# Verify installation works
function Test-Installation {
    param([string]$InstallDir)
    $binaryPath = Join-Path $InstallDir $BINARY_NAME
    
    if (-not (Test-Path $binaryPath)) {
        Write-Error "Binary not found at ${binaryPath}"
        exit 1
    }
    
    try {
        $version = & $binaryPath --version 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Installation verification failed. ai-init may not be working correctly."
            exit 1
        }
    }
    catch {
        Write-Error "Installation verification failed: $_"
        exit 1
    }
}

# Main installation function
function Install-AiInit {
    Write-Host "Installing ai-init..." -ForegroundColor Cyan
    Write-Host ""
    
    # 1. Get platform info
    $platformInfo = Get-PlatformInfo
    if ($platformInfo.Arch -eq "unsupported") {
        Write-Error "Unsupported architecture. Only 64-bit Windows is supported."
        exit 1
    }
    
    Write-Host "Detected platform: $($platformInfo.OS) ($($platformInfo.Arch))" -ForegroundColor Green
    
    # 2. Get installation directory
    $installDir = Get-InstallDirectory $DEFAULT_INSTALL_DIR
    
    # 3. Check for existing installation
    if (Test-ExistingInstallation $installDir) {
        $installPath = Join-Path $installDir $BINARY_NAME
        if (-not (Request-Upgrade $installPath)) {
            Write-Host "Installation cancelled."
            exit 0
        }
    }
    
    # 4. Create installation directory
    if (-not (Test-Path $installDir)) {
        New-Item -ItemType Directory -Path $installDir -Force | Out-Null
    }
    
    if (-not (Test-Path $installDir -PathType Container)) {
        Write-Error "Cannot create directory ${installDir}. Check permissions."
        exit 1
    }
    
    # 5. Get latest release info
    Write-Host "Fetching latest release..."
    $release = Get-LatestRelease
    Write-Host "Latest version: $($release.Tag)" -ForegroundColor Green
    
    # 6. Download binary and checksums
    $assetName = Get-AssetName $platformInfo.OS $platformInfo.Arch
    $downloadUrl = "https://github.com/${REPO}/releases/download/$($release.Tag)/${assetName}"
    $checksumsUrl = "https://github.com/${REPO}/releases/download/$($release.Tag)/checksums.txt"
    
    $tempDir = New-TemporaryFile | ForEach-Object { Remove-Item $_; New-Item -ItemType Directory -Path $_ }
    $binaryTemp = Join-Path $tempDir $assetName
    $checksumsTemp = Join-Path $tempDir "checksums.txt"
    
    try {
        Download-File $downloadUrl $binaryTemp
        Download-File $checksumsUrl $checksumsTemp
        
        # 7. Verify checksum
        Write-Host "Verifying checksum..."
        if (-not (Test-Checksum $binaryTemp $checksumsTemp)) {
            Write-Error "Checksum verification failed. Aborting installation."
            exit 1
        }
        Write-Host "Checksum verified" -ForegroundColor Green
        
        # 8. Install binary
        Write-Host "Installing binary..."
        Move-Item -Path $binaryTemp -Destination (Join-Path $installDir $BINARY_NAME) -Force
        
        # 9. Add to PATH
        Write-Host "Updating PATH..."
        Add-ToPath $installDir
        
        # 10. Verify installation
        Write-Host "Verifying installation..."
        Test-Installation $installDir
        
        # 11. Success message
        Write-Host ""
        Write-Host "ai-init installed successfully!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Installed to: ${installDir}"
        $version = & (Join-Path $installDir $BINARY_NAME) --version 2>&1 | Select-Object -First 1
        Write-Host "Version: ${version}"
        Write-Host ""
        Write-Host "PATH has been updated. You may need to restart your terminal."
        Write-Host ""
        Write-Host "Run ai-init --help to get started."
    }
    finally {
        Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Run main function
Install-AiInit
