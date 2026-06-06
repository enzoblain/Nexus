import Combine
import SwiftUI
import UserNotifications

final class AppSettings: ObservableObject {
    @AppStorage("account_type")
    private var rawAccountType = AccountType.undefined.rawValue

    @Published
    private(set) var notificationsStatus: NotificationsStatus = .undefined

    var accountType: AccountType {
        get { AccountType(rawValue: rawAccountType) ?? .undefined }
        set { rawAccountType = newValue.rawValue }
    }

    @MainActor
        func refreshNotificationsStatus() async {
            notificationsStatus = await NotificationManager.shared
                .authorizationStatus()
        }
}
