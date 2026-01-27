# inject-context.ps1
# SessionStart hook - Injects ai-context.md into every session

# Read input from stdin
$input = [Console]::In.ReadToEnd() | ConvertFrom-Json

# Path to ai-context.md
$contextPath = Join-Path $PSScriptRoot "..\..\..\.ai\ai-context.md"

# Check if ai-context.md exists
if (Test-Path $contextPath) {
    $contextContent = Get-Content $contextPath -Raw
    
    # Return JSON with additional_context
    $output = @{
        additional_context = @"
# Project Context (from .ai/ai-context.md)

$contextContent

---

This context is automatically injected at session start. Reference it for project-specific patterns, constraints, and anti-patterns.
"@
    } | ConvertTo-Json -Depth 10
    
    Write-Output $output
} else {
    # No context file found - return empty response
    $output = @{} | ConvertTo-Json
    Write-Output $output
}

exit 0
