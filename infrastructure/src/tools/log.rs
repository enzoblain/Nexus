use std::path::PathBuf;
use tracing_appender::rolling;
use tracing_subscriber::fmt;

pub fn init_logs(path: &PathBuf) {
    let file_appender = rolling::daily(path, "flowpilot.log");

    fmt().with_writer(file_appender).init();
}
