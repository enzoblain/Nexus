use clap::{Parser, Subcommand, ValueEnum};

#[derive(Parser)]
#[command(author, version, about = "FlowPilot Telegram AI assistant")]
pub(crate) struct Cli {
    #[command(subcommand)]
    command: Option<Commands>,
}

impl Cli {
    pub(crate) fn command(&self) -> &Option<Commands> {
        &self.command
    }
}

#[derive(Debug, Subcommand)]
pub(crate) enum Commands {
    /// Initialize the application
    Init {
        /// Telegram bot token
        #[arg(short, long)]
        token: String,
    },

    /// Add allowed Telegram users
    AddUser {
        /// Number of users to wait for
        count: usize,
    },

    /// Delete application data
    Delete {
        #[arg(value_enum)]
        target: DeleteTarget,
    },

    /// Start the FlowPilot Telegram bot
    Start,
}

#[derive(Clone, Debug, ValueEnum)]
pub(crate) enum DeleteTarget {
    /// Delete all application data
    All,
    /// Delete only the config file
    Config,
}
