import OSLog

enum Loggers {
    static let notifications = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "Nexus",
        category: "notifications"
    )
}
