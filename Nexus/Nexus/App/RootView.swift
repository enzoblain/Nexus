import SwiftUI

struct RootView: View {
    @EnvironmentObject private var settings: AppSettings

    var body: some View {
        NavigationStack {
            if settings.accountType == .undefined {
                SetupView()
            } else {
                HomeView()
            }
        }
    }
}

#Preview {
    RootView()
}
