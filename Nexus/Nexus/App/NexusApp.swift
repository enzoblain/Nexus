import SwiftUI

@main
struct NexusApp: App {
    @StateObject private var settings = AppSettings()

    @Environment(\.scenePhase)
    private var scenePhase

    private var shouldRequireNotifications: Bool {
        #if os(macOS)
        settings.accountType == .server
        #else
        false
        #endif
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if shouldRequireNotifications &&
                    settings.notificationsStatus == .refused {
                    NotificationsRequiredView()
                } else {
                    RootView()
                }
            }
            .environmentObject(settings)
            .task {
                await settings.refreshNotificationsStatus()
            }
            .onChange(of: scenePhase) { _, phase in
                guard phase == .active else { return }

                Task {
                    await settings.refreshNotificationsStatus()
                }
            }
        }
        .windowStyle(.hiddenTitleBar)
    }
}
