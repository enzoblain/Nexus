import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestAuthorization() async throws -> Bool {
        try await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound])
    }

    func send(_ type: NotificationType) async throws {
        let notification = type.content

        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.subtitle = notification.subtitle ?? ""
        content.body = notification.body
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        try await UNUserNotificationCenter.current()
            .add(request)
    }
}
