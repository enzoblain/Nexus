use thiserror::Error;

#[derive(Debug, Error)]
pub enum PathsError {
    #[error("Failed to resolve project directories")]
    ProjectDirsNotFound,

    #[error("Failed to create application root directory")]
    RootDirectoryCreationFailed,

    #[error("Config file not found")]
    ConfigNotFound,

    #[error("Failed to read config file")]
    ConfigReadFailed,

    #[error("Failed to write config file")]
    ConfigWriteFailed,

    #[error("Failed to serialize config")]
    ConfigSerializationFailed,

    #[error("Invalid config format")]
    InvalidConfig,

    #[error("Failed to delete config file")]
    ConfigDeleteFailed,

    #[error("Failed to delete application root directory")]
    RootDirectoryDeletionFailed,
}
