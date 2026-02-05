# inject-context.ps1
# SessionStart hook - Injects lean ai-summary.md + dynamic workflow state

# Read input from stdin
$input = [Console]::In.ReadToEnd() | ConvertFrom-Json

# Base path for .ai folder
$aiPath = Join-Path $PSScriptRoot "..\..\.ai"

# 1. Read static summary (lean context)
$summaryPath = Join-Path $aiPath "ai-summary.md"
$summaryContent = ""

if (Test-Path $summaryPath) {
    $summaryContent = Get-Content $summaryPath -Raw
} else {
    # Fallback: Try ai-context.md if ai-summary.md doesn't exist yet
    $contextPath = Join-Path $aiPath "ai-context.md"
    if (Test-Path $contextPath) {
        $summaryContent = Get-Content $contextPath -Raw
    }
}

# 2. Detect workflow state from active files
$workflowState = "## Workflow State (auto-detected)`n`n"
$hasActiveFiles = $false

# Check active-research.md
$researchPath = Join-Path $aiPath "active-research.md"
if (Test-Path $researchPath) {
    $hasActiveFiles = $true
    $researchContent = Get-Content $researchPath -Raw
    
    # Parse frontmatter for task and status
    $task = "unknown"
    $status = "research"
    
    if ($researchContent -match '(?s)^---\s*\n(.*?)\n---') {
        $frontmatter = $Matches[1]
        if ($frontmatter -match 'task:\s*["'']?([^"''\n]+)') {
            $task = $Matches[1].Trim()
        }
        if ($frontmatter -match 'status:\s*(\S+)') {
            $status = $Matches[1].Trim()
        }
    }
    
    $workflowState += "- **Active research**: ``.ai/active-research.md`` (task: $task, status: $status)`n"
}

# Check active-plan.md
$planPath = Join-Path $aiPath "active-plan.md"
if (Test-Path $planPath) {
    $hasActiveFiles = $true
    $planContent = Get-Content $planPath -Raw
    
    # Parse frontmatter for task and status
    $task = "unknown"
    $status = "planning"
    
    if ($planContent -match '(?s)^---\s*\n(.*?)\n---') {
        $frontmatter = $Matches[1]
        if ($frontmatter -match 'task:\s*["'']?([^"''\n]+)') {
            $task = $Matches[1].Trim()
        }
        if ($frontmatter -match 'status:\s*(\S+)') {
            $status = $Matches[1].Trim()
        }
    }
    
    $workflowState += "- **Active plan**: ``.ai/active-plan.md`` (task: $task, status: $status)`n"
    
    # Add helpful tip based on status
    if ($status -eq "planning") {
        $workflowState += "`nTip: Run ``/implement`` when ready to execute this plan.`n"
    } elseif ($status -eq "implementing") {
        $workflowState += "`nTip: Implementation in progress. Follow the plan step by step.`n"
    }
}

# If no active files, indicate clean slate
if (-not $hasActiveFiles) {
    $workflowState += "No active research or plan. Use ``/research [task]`` to start a new task.`n"
}

# 3. Build combined context
if ($summaryContent) {
    $combinedContext = "# Project Summary (from .ai/ai-summary.md)`n`n" + $summaryContent + "`n`n---`n`n" + $workflowState + "`n---`n`nFor full patterns and constraints, reference ``.ai/ai-context.md``."

    $output = @{
        additional_context = $combinedContext
    } | ConvertTo-Json -Depth 10
    
    Write-Output $output
} else {
    # No summary file - return empty but inform about setup
    $output = @{
        additional_context = "No .ai/ai-summary.md found. Run ``ai-init`` to set up AI workflow templates."
    } | ConvertTo-Json -Depth 10
    Write-Output $output
}

exit 0
