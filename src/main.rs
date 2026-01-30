use clap::{Parser, Subcommand};

mod commands;
mod embed;
mod fs;
mod git;
mod upgrade;

/// AI workflow template manager for git repositories
#[derive(Parser)]
#[command(name = "ai-init")]
#[command(author, version, about, long_about = None)]
#[command(propagate_version = true)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Initialize AI workflow templates in the current git repository
    Init {
        /// Only install specific categories (comma-separated: ai,rules,commands,hooks,skills,agents)
        #[arg(long, value_delimiter = ',')]
        only: Option<Vec<String>>,

        /// Skip specific categories (comma-separated: ai,rules,commands,hooks,skills,agents)
        #[arg(long, value_delimiter = ',')]
        skip: Option<Vec<String>>,

        /// Overwrite existing files without prompting
        #[arg(long, short)]
        force: bool,
    },

    /// Check repository for missing or broken AI workflow files
    Doctor {
        /// Automatically fix detected issues
        #[arg(long)]
        fix: bool,
    },

    /// Upgrade ai-init to the latest version
    Upgrade {
        /// Skip confirmation prompt
        #[arg(long, short = 'y')]
        yes: bool,
    },

    /// Remove AI workflow files from the repository
    Uninstall {
        /// Remove files without prompting
        #[arg(long, short)]
        force: bool,
    },

    /// Rate and provide feedback for ai-init
    Rate,
}

fn main() {
    let cli = Cli::parse();

    let result: Result<(), Box<dyn std::error::Error>> = match cli.command {
        Commands::Init { only, skip, force } => commands::init::run(only, skip, force)
            .map_err(|e| Box::new(e) as Box<dyn std::error::Error>),
        Commands::Doctor { fix } => {
            commands::doctor::run(fix).map_err(|e| Box::new(e) as Box<dyn std::error::Error>)
        }
        Commands::Upgrade { yes } => {
            commands::upgrade::run(yes).map_err(|e| Box::new(e) as Box<dyn std::error::Error>)
        }
        Commands::Uninstall { force } => {
            commands::uninstall::run(force).map_err(|e| Box::new(e) as Box<dyn std::error::Error>)
        }
        Commands::Rate => {
            commands::rate::run().map_err(|e| Box::new(e) as Box<dyn std::error::Error>)
        }
    };

    if let Err(e) = result {
        eprintln!("Error: {}", e);
        std::process::exit(1);
    }
}
