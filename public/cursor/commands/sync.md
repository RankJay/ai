# Sync Configuration

This command synchronizes the local configuration and template files to the `public/` directory.

## Items Synchronized

1. **Cursor Config**: `.cursor/` -> `public/cursor/`
2. **AI Guardrails**: `.ai/ai-guardrails.md` -> `public/ai/ai-guardrails.md`
3. **AI Templates**: `.ai/template/` -> `public/ai/template/`

## Command

Run the following PowerShell command in the workspace root:

```powershell
# Sync Cursor Config
Copy-Item -Path ".cursor\*" -Destination "public\cursor" -Recurse -Force

# Sync AI Guardrails
Copy-Item -Path ".ai\ai-guardrails.md" -Destination "public\ai\ai-guardrails.md" -Force

# Sync AI Templates
Copy-Item -Path ".ai\template\*" -Destination "public\ai\template" -Recurse -Force
```

## Why This Matters

Ensures that the public-facing documentation, templates, and cursor configuration stay in sync with the active development environment.
