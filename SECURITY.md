# Security Policy

## Supported Versions

Security updates are provided for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | Yes                |

Only the latest release receives security updates. Users are encouraged to upgrade to the latest version.

## Reporting a Vulnerability

**Do not open public issues for security vulnerabilities.**

To report a security vulnerability:

1. **Email**: Contact the maintainer directly through GitHub ([@RankJay](https://github.com/RankJay))
2. **GitHub Security Advisories**: Use the [private vulnerability reporting](https://github.com/RankJay/ai/security/advisories/new) feature if available

### What to Include

- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

### Response Timeline

- **Acknowledgment**: Within 48 hours
- **Initial Assessment**: Within 7 days
- **Resolution Target**: Within 30 days for critical issues

You will be kept informed of progress toward resolution.

## Security Practices

### Binary Distribution

- All release binaries are built via GitHub Actions in a reproducible environment
- SHA256 checksums are published with every release (`checksums.txt`)
- Installation scripts verify checksums before installing

### Installation Scripts

- Scripts are plain text and auditable
- HTTPS-only downloads from GitHub
- No obfuscation or minification
- User PATH only (no system modifications)
- No elevated privileges required

### Self-Upgrade

- Downloads are verified against checksums from GitHub Releases
- Atomic binary replacement prevents corruption
- Upgrades only from official GitHub Releases

## Verifying Downloads

Always verify the checksum of downloaded binaries:

**Linux / macOS:**

```bash
# Download the binary and checksums
curl -LO https://github.com/RankJay/ai/releases/latest/download/ai-init-linux-amd64
curl -LO https://github.com/RankJay/ai/releases/latest/download/checksums.txt

# Verify
sha256sum -c checksums.txt --ignore-missing
```

**Windows (PowerShell):**

```powershell
# Download the binary and checksums
Invoke-WebRequest -Uri "https://github.com/RankJay/ai/releases/latest/download/ai-init-windows-amd64.exe" -OutFile "ai-init.exe"
Invoke-WebRequest -Uri "https://github.com/RankJay/ai/releases/latest/download/checksums.txt" -OutFile "checksums.txt"

# Get expected checksum
$expected = (Get-Content checksums.txt | Select-String "ai-init-windows-amd64.exe").ToString().Split(" ")[0]

# Verify
$actual = (Get-FileHash -Algorithm SHA256 ai-init.exe).Hash.ToLower()
if ($actual -eq $expected) { Write-Host "Checksum verified" } else { Write-Host "Checksum mismatch!" }
```

## Security Considerations for Users

### Before Running Installation Scripts

Review the scripts before execution:

```bash
# Review Unix script
curl -fsSL https://raw.githubusercontent.com/RankJay/ai/main/install.sh | less

# Review Windows script
iwr -useb https://raw.githubusercontent.com/RankJay/ai/main/install.ps1 | Select-Object -ExpandProperty Content
```

### Template Security

The AI workflow templates installed by ai-init may contain:

- Configuration files for AI assistants
- Workflow rules and guidelines
- Hook scripts

Review installed templates in the `.ai/`, `.cursor/`, and related directories after installation.

## Known Security Considerations

- **No code execution**: ai-init only copies template files; it does not execute arbitrary code
- **Local only**: All operations are local to the git repository
- **No network after install**: The tool only contacts GitHub for upgrades (when explicitly requested)
