mod actions;
mod cli;
mod error;

use anyhow::Result;
use clap::Parser;
use tracing::{error, info};

use crate::actions::{add_user, delete, init};
use crate::cli::{Cli, Commands};
use infrastructure::filesystem::Paths;
use infrastructure::tools::log::init_logs;

#[tokio::main]
async fn main() {
    if let Err(err) = run().await {
        error!("{}", err);
    }
}

async fn run() -> Result<()> {
    let paths = Paths::load()?;
    let log_folder = paths.logs();

    init_logs(log_folder);

    let cli = Cli::parse();
    let command = cli.command().as_ref().unwrap_or(&Commands::Start);

    info!("Launching FlowPilot with command: {:?}", command);

    match command {
        Commands::Init { token } => {
            init(&paths, token)?;
        }
        Commands::Delete { target } => {
            delete(&paths, target)?;
        }
        Commands::AddUser { count } => {
            add_user(&paths, *count).await?;
        }
        Commands::Start => {}
    }

    info!("FlowPilot execution completed successfully");
    Ok(())
}
