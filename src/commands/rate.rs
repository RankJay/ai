use console::style;
use dialoguer::{Input, Select};
use thiserror::Error;

const GITHUB_REPO: &str = "https://github.com/RankJay/ai";

#[derive(Error, Debug)]
pub enum RateError {
    #[error("Dialog error: {0}")]
    Dialog(#[from] dialoguer::Error),
}

pub fn run() -> Result<(), RateError> {
    println!();
    println!("{}", style("Rate this repository").bold().cyan());
    println!("{}", style("═".repeat(50)).dim());
    println!();
    println!("We'd love to hear your feedback about ai-init!");
    println!();

    // Get rating (1-5 stars)
    let ratings = vec![
        "⭐ (1) - Needs improvement",
        "⭐⭐ (2) - Below average",
        "⭐⭐⭐ (3) - Good",
        "⭐⭐⭐⭐ (4) - Very good",
        "⭐⭐⭐⭐⭐ (5) - Excellent",
    ];

    let selection = Select::new()
        .with_prompt("How would you rate ai-init?")
        .items(&ratings)
        .default(4) // Default to 5 stars
        .interact()?;

    let rating = selection + 1; // Convert index to 1-5 rating

    // Get optional feedback
    println!();
    let feedback: String = Input::new()
        .with_prompt("Additional feedback (optional, press Enter to skip)")
        .allow_empty(true)
        .interact_text()?;

    // Display thank you message
    println!();
    println!("{}", style("═".repeat(50)).dim());
    println!();
    println!(
        "{} Thank you for rating ai-init {} {}!",
        style("✓").green().bold(),
        "⭐".repeat(rating),
        style(format!("({}/5)", rating)).dim()
    );
    
    if !feedback.trim().is_empty() {
        println!();
        println!("Your feedback:");
        println!("{}", style(format!("\"{}\"", feedback.trim())).italic());
    }

    println!();
    println!("Your feedback helps make ai-init better for everyone.");
    println!();
    println!(
        "{} You can also:",
        style("→").blue()
    );
    println!("  • Star the repository: {}", style(GITHUB_REPO).cyan().underlined());
    println!("  • Report issues: {}/issues", style(GITHUB_REPO).cyan());
    println!("  • Contribute: {}/pulls", style(GITHUB_REPO).cyan());
    println!();

    Ok(())
}
