mod actions;
mod cli;
mod error;

use anyhow::Result;
use clap::Parser;

use crate::actions::{add_user, delete, init};
use crate::cli::{Cli, Commands};

use infrastructure::filesystem::Paths;

#[tokio::main]
async fn main() -> Result<()> {
    let paths = Paths::load()?;

    let cli = Cli::parse();
    match cli.command() {
        Some(Commands::Init { token }) => init(&paths, token)?,
        Some(Commands::Delete { target }) => delete(&paths, target)?,
        Some(Commands::AddUser { count }) => add_user(&paths, *count).await?,
        _ => {}
    }

    Ok(())
}
