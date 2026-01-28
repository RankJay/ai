# post-edit-check.ps1
# AfterFileEdit hook - Validates AI edits and warns about common mistakes

# Read input from stdin
$inputData = [Console]::In.ReadToEnd() | ConvertFrom-Json

$filePath = $inputData.file_path
$edits = $inputData.edits

# Log the edit for audit trail
$logPath = Join-Path $PSScriptRoot "..\..\.ai\edit-log.txt"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$logEntry = "[$timestamp] Edited: $filePath ($($edits.Count) change(s))"
Add-Content -Path $logPath -Value $logEntry -ErrorAction SilentlyContinue

# Define code file extensions to validate
$codeExtensions = @('.ts', '.tsx', '.js', '.jsx', '.py', '.rs', '.go', '.java', '.cs', '.cpp', '.c', '.rb', '.php')

# Get file extension
$extension = [System.IO.Path]::GetExtension($filePath).ToLower()

# Initialize warnings array
$warnings = @()

# Only validate code files
if ($codeExtensions -contains $extension) {
    
    # Read file content
    if (Test-Path $filePath) {
        $content = Get-Content $filePath -Raw -ErrorAction SilentlyContinue
        
        if ($content) {
            # Check for console.log (JS/TS)
            if ($extension -in @('.ts', '.tsx', '.js', '.jsx')) {
                if ($content -match 'console\.log\(') {
                    $warnings += "console.log found - consider using a logger"
                }
            }
            
            # Check for 'any' type (TypeScript)
            if ($extension -in @('.ts', '.tsx')) {
                if ($content -match ':\s*any\b') {
                    $warnings += "': any' type found - consider explicit typing"
                }
            }
            
            # Check for TODO/FIXME comments (all languages)
            if ($content -match '\b(TODO|FIXME|XXX|HACK)\b') {
                $warnings += "TODO/FIXME comment found - AI may have left placeholder"
            }
            
            # Check for commented-out code blocks (heuristic: multiple consecutive comment lines)
            $lines = $content -split "`n"
            $commentStreak = 0
            foreach ($line in $lines) {
                if ($line -match '^\s*(//|#|/\*|\*)\s*\S') {
                    $commentStreak++
                    if ($commentStreak -ge 5) {
                        $warnings += "Large commented block found - may be dead code"
                        break
                    }
                } else {
                    $commentStreak = 0
                }
            }
            
            # Check for print statements (Python)
            if ($extension -eq '.py') {
                if ($content -match '\bprint\s*\(') {
                    $warnings += "print() found - consider using logging"
                }
            }
            
            # Check for unwrap/expect without context (Rust)
            if ($extension -eq '.rs') {
                if ($content -match '\.(unwrap|expect)\s*\(\s*\)') {
                    $warnings += ".unwrap() or .expect() with no message found - consider proper error handling"
                }
            }
        }
    }
}

# Build output
if ($warnings.Count -gt 0) {
    $output = @{
        warnings = $warnings
        message = "Validation found $($warnings.Count) potential issue(s) in $filePath"
    } | ConvertTo-Json -Depth 10
} else {
    $output = @{} | ConvertTo-Json
}

Write-Output $output
exit 0
