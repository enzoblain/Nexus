use tokio::spawn;
use tokio::sync::mpsc;

use crate::cli::DeleteTarget;
use crate::error::AppError;
use infrastructure::config::Config;
use infrastructure::filesystem::Paths;
use infrastructure::telegram::register_allowed_users;

pub(crate) fn init(paths: &Paths, token: &str) -> Result<(), AppError> {
    if paths.config_exists() {
        println!("FlowPilot is already initialized.");

        return Err(AppError::AlreadyInitialized);
    }

    println!("Initializing FlowPilot...");

    let mut config = Config::default();
    config.set_telegram_token(token);

    paths.save_config(&config)?;

    println!("Configuration created successfully.");
    println!("FlowPilot initialized.");

    Ok(())
}

pub(crate) fn delete(paths: &Paths, target: &DeleteTarget) -> Result<(), AppError> {
    match target {
        DeleteTarget::All => {
            println!("Deleting all FlowPilot data...");

            paths.delete_all()?;

            println!("All FlowPilot data deleted.");
        }

        DeleteTarget::Config => {
            println!("Deleting FlowPilot config...");

            paths.delete_config()?;

            println!("FlowPilot config deleted.");
        }
    }

    Ok(())
}

pub(crate) async fn add_user(paths: &Paths, count: usize) -> Result<(), AppError> {
    if count == 0 {
        return Err(AppError::InvalidUserCount);
    }

    let mut config = paths.load_config()?;
    let token = config.telegram_token().to_string();

    let (tx, mut rx) = mpsc::channel(count);
    let handle = spawn(register_allowed_users(token, tx));

    println!("Waiting for {} Telegram user(s)...", count);

    let mut added_count = 0;
    while added_count < count {
        let (chat_id, response_tx) = rx.recv().await.ok_or(AppError::RegistrationChannelClosed)?;
        let added = config.add_allowed_chat_id(chat_id);

        if added {
            added_count += 1;

            println!("[{}/{}] Added user {}", added_count, count, chat_id);

            paths.save_config(&config)?;
        } else {
            println!(
                "[{}/{}] User {} already exists",
                added_count, count, chat_id
            );
        }

        response_tx
            .send(added)
            .map_err(|_| AppError::RegistrationResponseSendFailed)?;
    }

    handle.abort();

    println!("Done.");
    Ok(())
}
