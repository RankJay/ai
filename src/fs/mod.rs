mod copy;
mod gitignore;

pub use copy::{copy_with_prompt, CopyResult};
pub use gitignore::update_gitignore;
