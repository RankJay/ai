/// Embedded file with metadata
pub struct EmbeddedFile {
    /// Relative path from repo root (e.g., ".ai/ai-context.md")
    pub target_path: &'static str,
    /// File content embedded at compile time
    pub content: &'static str,
    /// Category for --only/--skip filtering
    pub category: FileCategory,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum FileCategory {
    AiTemplates,    // .ai/ files
    Rules,          // .cursor/rules/
    Commands,       // .cursor/commands/
    Hooks,          // .cursor/hooks/
    Skills,         // .cursor/skills/
    Agents,         // .cursor/agents/
}

impl FileCategory {
    #[allow(dead_code)]
    pub fn as_str(&self) -> &'static str {
        match self {
            Self::AiTemplates => "ai",
            Self::Rules => "rules",
            Self::Commands => "commands",
            Self::Hooks => "hooks",
            Self::Skills => "skills",
            Self::Agents => "agents",
        }
    }

    pub fn from_str(s: &str) -> Option<Self> {
        match s.to_lowercase().as_str() {
            "ai" => Some(Self::AiTemplates),
            "rules" => Some(Self::Rules),
            "commands" => Some(Self::Commands),
            "hooks" => Some(Self::Hooks),
            "skills" => Some(Self::Skills),
            "agents" => Some(Self::Agents),
            _ => None,
        }
    }
}

/// Returns all embedded files
pub fn get_all_files() -> Vec<EmbeddedFile> {
    vec![
        // .ai/ files
        EmbeddedFile {
            target_path: ".ai/ai-context.md",
            content: include_str!("../../public/ai/ai-context.md"),
            category: FileCategory::AiTemplates,
        },
        EmbeddedFile {
            target_path: ".ai/ai-guardrails.md",
            content: include_str!("../../public/ai/ai-guardrails.md"),
            category: FileCategory::AiTemplates,
        },
        EmbeddedFile {
            target_path: ".ai/template/decision.md",
            content: include_str!("../../public/ai/template/decision.md"),
            category: FileCategory::AiTemplates,
        },
        EmbeddedFile {
            target_path: ".ai/template/plan.md",
            content: include_str!("../../public/ai/template/plan.md"),
            category: FileCategory::AiTemplates,
        },
        EmbeddedFile {
            target_path: ".ai/template/research.md",
            content: include_str!("../../public/ai/template/research.md"),
            category: FileCategory::AiTemplates,
        },
        
        // .cursor/rules/
        EmbeddedFile {
            target_path: ".cursor/rules/ai-guidelines.mdc",
            content: include_str!("../../public/cursor/rules/ai-guidelines.mdc"),
            category: FileCategory::Rules,
        },
        EmbeddedFile {
            target_path: ".cursor/rules/core-principles.mdc",
            content: include_str!("../../public/cursor/rules/core-principles.mdc"),
            category: FileCategory::Rules,
        },
        EmbeddedFile {
            target_path: ".cursor/rules/security-patterns.mdc",
            content: include_str!("../../public/cursor/rules/security-patterns.mdc"),
            category: FileCategory::Rules,
        },
        EmbeddedFile {
            target_path: ".cursor/rules/three-phase-workflow.mdc",
            content: include_str!("../../public/cursor/rules/three-phase-workflow.mdc"),
            category: FileCategory::Rules,
        },
        
        // .cursor/commands/
        EmbeddedFile {
            target_path: ".cursor/commands/adr.md",
            content: include_str!("../../public/cursor/commands/adr.md"),
            category: FileCategory::Commands,
        },
        EmbeddedFile {
            target_path: ".cursor/commands/commit.md",
            content: include_str!("../../public/cursor/commands/commit.md"),
            category: FileCategory::Commands,
        },
        EmbeddedFile {
            target_path: ".cursor/commands/implement.md",
            content: include_str!("../../public/cursor/commands/implement.md"),
            category: FileCategory::Commands,
        },
        EmbeddedFile {
            target_path: ".cursor/commands/plan.md",
            content: include_str!("../../public/cursor/commands/plan.md"),
            category: FileCategory::Commands,
        },
        EmbeddedFile {
            target_path: ".cursor/commands/research.md",
            content: include_str!("../../public/cursor/commands/research.md"),
            category: FileCategory::Commands,
        },
        EmbeddedFile {
            target_path: ".cursor/commands/review.md",
            content: include_str!("../../public/cursor/commands/review.md"),
            category: FileCategory::Commands,
        },
        EmbeddedFile {
            target_path: ".cursor/commands/sync.md",
            content: include_str!("../../public/cursor/commands/sync.md"),
            category: FileCategory::Commands,
        },
        
        // .cursor/hooks/
        EmbeddedFile {
            target_path: ".cursor/hooks.json",
            content: include_str!("../../public/cursor/hooks.json"),
            category: FileCategory::Hooks,
        },
        EmbeddedFile {
            target_path: ".cursor/hooks/extract-learnings.ps1",
            content: include_str!("../../public/cursor/hooks/extract-learnings.ps1"),
            category: FileCategory::Hooks,
        },
        EmbeddedFile {
            target_path: ".cursor/hooks/inject-context.ps1",
            content: include_str!("../../public/cursor/hooks/inject-context.ps1"),
            category: FileCategory::Hooks,
        },
        EmbeddedFile {
            target_path: ".cursor/hooks/post-edit-check.ps1",
            content: include_str!("../../public/cursor/hooks/post-edit-check.ps1"),
            category: FileCategory::Hooks,
        },
        
        // .cursor/agents/
        EmbeddedFile {
            target_path: ".cursor/agents/researcher.md",
            content: include_str!("../../public/cursor/agents/researcher.md"),
            category: FileCategory::Agents,
        },
        EmbeddedFile {
            target_path: ".cursor/agents/verifier.md",
            content: include_str!("../../public/cursor/agents/verifier.md"),
            category: FileCategory::Agents,
        },
        
        // .cursor/skills/
        EmbeddedFile {
            target_path: ".cursor/skills/architecture-decision/SKILL.md",
            content: include_str!("../../public/cursor/skills/architecture-decision/SKILL.md"),
            category: FileCategory::Skills,
        },
        EmbeddedFile {
            target_path: ".cursor/skills/code-review/SKILL.md",
            content: include_str!("../../public/cursor/skills/code-review/SKILL.md"),
            category: FileCategory::Skills,
        },
        EmbeddedFile {
            target_path: ".cursor/skills/research-methodology/SKILL.md",
            content: include_str!("../../public/cursor/skills/research-methodology/SKILL.md"),
            category: FileCategory::Skills,
        },
        EmbeddedFile {
            target_path: ".cursor/skills/security-audit/SKILL.md",
            content: include_str!("../../public/cursor/skills/security-audit/SKILL.md"),
            category: FileCategory::Skills,
        },
    ]
}

/// Get files filtered by category
pub fn get_files_by_categories(
    only: Option<&[FileCategory]>,
    skip: Option<&[FileCategory]>,
) -> Vec<EmbeddedFile> {
    get_all_files()
        .into_iter()
        .filter(|f| {
            if let Some(only_cats) = only {
                if !only_cats.contains(&f.category) {
                    return false;
                }
            }
            if let Some(skip_cats) = skip {
                if skip_cats.contains(&f.category) {
                    return false;
                }
            }
            true
        })
        .collect()
}
