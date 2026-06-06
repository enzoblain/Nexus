import OSLog
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func authorizationStatus() async -> NotificationsStatus {
        let settings = await UNUserNotificationCenter.current()
            .notificationSettings()

        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return .accepted

        case .denied:
            return .refused

        case .notDetermined:
            return .undefined

        @unknown default:
            return .refused
        }
    }

    func requestAuthorization() async throws {
        do {
            try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            Logger(
                subsystem: Bundle.main.bundleIdentifier ?? "Nexus",
                category: "notifications"
            ).error("Failed to request authorization: \(error.localizedDescription)")

            throw error
        }
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

        do {
            try await UNUserNotificationCenter.current()
                .add(request)
        } catch {
            Logger(
                subsystem: Bundle.main.bundleIdentifier ?? "Nexus",
                category: "notifications"
            ).error("Failed to send notification: \(error.localizedDescription)")

            throw error
        }
    }
}
