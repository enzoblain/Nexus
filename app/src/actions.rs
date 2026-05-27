use infrastructure::config::Config;
use infrastructure::filesystem::Paths;
use infrastructure::telegram::register_allowed_users;
use tokio::spawn;
use tokio::sync::mpsc;
use tracing::{info, warn};

use crate::cli::DeleteTarget;
use crate::error::AppError;

pub(crate) fn init(paths: &Paths, token: &str) -> Result<(), AppError> {
    if paths.config_exists() {
        warn!("Initialization skipped: FlowPilot is already configured");
        return Err(AppError::AlreadyInitialized);
    }

    info!("Creating FlowPilot configuration");

    let mut config = Config::default();
    config.set_telegram_token(token);

    paths.save_config(&config)?;

    info!("Configuration saved successfully");
    info!("FlowPilot initialization completed");

    Ok(())
}

pub(crate) fn delete(paths: &Paths, target: &DeleteTarget) -> Result<(), AppError> {
    match target {
        DeleteTarget::All => {
            info!("Removing all FlowPilot data");
            paths.delete_all()?;
            info!("All application data removed");
        }
        DeleteTarget::Config => {
            info!("Removing configuration file");
            paths.delete_config()?;
            info!("Configuration file removed");
        }
    }

    Ok(())
}

pub(crate) async fn add_user(paths: &Paths, count: usize) -> Result<(), AppError> {
    if count == 0 {
        warn!("User registration aborted: count is 0");
        return Err(AppError::InvalidUserCount);
    }

    info!("Loading FlowPilot configuration");
    let mut config = paths.load_config()?;

    let token = config.telegram_token().to_string();
    let (tx, mut rx) = mpsc::channel(count);

    info!("Starting Telegram registration listener");
    let handle = spawn(register_allowed_users(token, tx));
    info!("Waiting for {} unique Telegram user(s)", count);

    let mut added_count = 0;
    while added_count < count {
        let (chat_id, response_tx) = rx.recv().await.ok_or(AppError::RegistrationChannelClosed)?;
        info!("Received registration request from {}", chat_id);

        let added = config.add_allowed_chat_id(chat_id);
        if added {
            added_count += 1;

            info!(
                "User {} registered successfully ({}/{})",
                chat_id, added_count, count
            );

            paths.save_config(&config)?;
            info!("Configuration updated");
        } else {
            warn!("Registration ignored: user {} already exists", chat_id);
        }

        response_tx
            .send(added)
            .map_err(|_| AppError::RegistrationResponseSendFailed)?;
    }

    info!("Stopping Telegram registration listener");
    handle.abort();
    info!("User registration process completed");

    Ok(())
}
