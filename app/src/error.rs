use thiserror::Error;

use infrastructure::filesystem::PathsError;

#[derive(Debug, Error)]
pub enum AppError {
    #[error("Project is already initialized")]
    AlreadyInitialized,

    #[error("User count must be greater than 0")]
    InvalidUserCount,

    #[error("Telegram registration channel closed")]
    RegistrationChannelClosed,

    #[error("Failed to send registration response")]
    RegistrationResponseSendFailed,

    #[error(transparent)]
    Paths(#[from] PathsError),
}
