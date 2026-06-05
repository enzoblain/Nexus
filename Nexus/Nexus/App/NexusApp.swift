import SwiftUI
import AppKit

@main
struct NexusApp: App {
    @StateObject
    private var settings = AppSettings()

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
                guard shouldRequireNotifications else { return }

                await settings.refreshNotificationsStatus()

                if settings.notificationsStatus == .notDetermined {
                    do {
                        _ = try await NotificationManager.shared
                            .requestAuthorization()

                        await settings.refreshNotificationsStatus()
                    } catch {
                        print(error)
                    }
                }
            }
            .onChange(of: scenePhase) { _, newPhase in
                guard shouldRequireNotifications else { return }

                if newPhase == .active {
                    Task {
                        await settings.refreshNotificationsStatus()
                    }
                }
            }
            #if os(macOS)
            .onReceive(
                NotificationCenter.default.publisher(
                    for: NSApplication.didBecomeActiveNotification
                )
            ) { _ in
                guard shouldRequireNotifications else { return }

                Task {
                    await settings.refreshNotificationsStatus()
                }
            }
            #endif
        }
        .windowStyle(.hiddenTitleBar)
    }
}
