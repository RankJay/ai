# post-edit-check.ps1
# AfterFileEdit hook - Runs after AI edits files

# Read input from stdin
$input = [Console]::In.ReadToEnd() | ConvertFrom-Json

$filePath = $input.file_path
$edits = $input.edits

# Log the edit for audit trail
$logPath = Join-Path $PSScriptRoot "..\..\..\.ai\edit-log.txt"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$logEntry = "[$timestamp] Edited: $filePath ($($edits.Count) change(s))`n"

# Append to log file
Add-Content -Path $logPath -Value $logEntry -ErrorAction SilentlyContinue

# Optional: Run formatter/linter here
# Example: npx prettier --write $filePath
# Example: eslint --fix $filePath

# Return empty response (no modifications to the edit)
$output = @{} | ConvertTo-Json
Write-Output $output
exit 0
