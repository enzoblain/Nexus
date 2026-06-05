import SwiftUI
import AppKit

@main
struct NexusApp: App {
    @StateObject
    private var settings = AppSettings()

    @Environment(\.scenePhase)
    private var scenePhase

    var body: some Scene {
        WindowGroup {
            Group {
                if settings.notificationsStatus == .refused {
                    NotificationsRequiredView()
                } else {
                    RootView()
                }
            }
            .environmentObject(settings)
            .task {
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
                if newPhase == .active {
                    Task {
                        await settings.refreshNotificationsStatus()
                    }
                }
            }
            .onReceive(
                NotificationCenter.default.publisher(
                    for: NSApplication.didBecomeActiveNotification
                )
            ) { _ in
                Task {
                    await settings.refreshNotificationsStatus()
                }
            }
        }
    }
}
