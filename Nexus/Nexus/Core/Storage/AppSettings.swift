import Combine
import SwiftUI
import UserNotifications

final class AppSettings: ObservableObject {
    @AppStorage("account_type")
    private var rawAccountType = AccountType.server.rawValue

    @Published
    private(set) var notificationsStatus: NotificationsStatus = .notDetermined

    var accountType: AccountType {
        get { AccountType(rawValue: rawAccountType) ?? .server }
        set { rawAccountType = newValue.rawValue }
    }

    @MainActor
    func refreshNotificationsStatus() async {
        let settings = await UNUserNotificationCenter.current()
            .notificationSettings()

        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            notificationsStatus = .accepted

        case .denied:
            notificationsStatus = .refused

        case .notDetermined:
            notificationsStatus = .notDetermined

        @unknown default:
            notificationsStatus = .refused
        }
    }
}
