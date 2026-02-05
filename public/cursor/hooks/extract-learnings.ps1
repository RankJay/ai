# extract-learnings.ps1
# Stop hook - Surfaces informative message after substantial sessions

# Read input from stdin
$input = [Console]::In.ReadToEnd() | ConvertFrom-Json

# Only process on successful completion
if ($input.status -ne "completed") {
    $output = @{} | ConvertTo-Json
    Write-Output $output
    exit 0
}

# Check if we've already looped
if ($input.loop_count -ge 1) {
    $output = @{} | ConvertTo-Json
    Write-Output $output
    exit 0
}

# Count edits in this session (if available from edit log)
$editLogPath = Join-Path $PSScriptRoot "..\..\.ai\edit-log.txt"
$editCount = 0

if (Test-Path $editLogPath) {
    # Count lines (each line is one edit)
    $editCount = (Get-Content $editLogPath | Measure-Object -Line).Lines
}

# If substantial edits, suggest context review
if ($editCount -gt 5) {
    $output = @{
        followup_message = "Session had $editCount file edits. Consider: Does .ai/ai-summary.md or .ai/ai-context.md need updating with new patterns or learnings?"
    } | ConvertTo-Json -Depth 10
    Write-Output $output
} else {
    # Light session - no followup needed
    $output = @{} | ConvertTo-Json
    Write-Output $output
}

exit 0
