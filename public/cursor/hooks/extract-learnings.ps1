# extract-learnings.ps1
# Stop hook - Analyzes completed session and suggests context updates

# Read input from stdin
$input = [Console]::In.ReadToEnd() | ConvertFrom-Json

# Only process on successful completion
if ($input.status -ne "completed") {
    $output = @{} | ConvertTo-Json
    Write-Output $output
    exit 0
}

# Check if we've already looped too many times
if ($input.loop_count -ge 3) {
    $output = @{} | ConvertTo-Json
    Write-Output $output
    exit 0
}

# Path to transcript (if available)
$transcriptPath = $input.transcript_path

# For now, just prompt the user to review and update context
# In a more advanced version, this could analyze the transcript
# and suggest specific updates

$message = @"
Session completed. Consider updating your project context:

1. Did you discover new patterns or anti-patterns?
2. Were there architectural decisions made?
3. Did you identify new pitfalls or constraints?
4. Should the File/Module Map be updated?
5. Should active research/plan docs be archived to .ai/archive/?

Update .ai/ai-context.md to capture these learnings for future sessions.
"@

# Return empty response (no auto-continue for now)
# To enable auto-continue, uncomment the followup_message line:
$output = @{
    # followup_message = "Review session and update .ai/ai-context.md if needed"
} | ConvertTo-Json -Depth 10

Write-Output $output
exit 0
