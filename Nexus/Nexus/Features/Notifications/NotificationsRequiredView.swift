import SwiftUI
import AppKit

struct NotificationsRequiredView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bell.slash.fill")
                .font(.system(size: 64))

            Text("Notifications requises")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Nexus nécessite les notifications pour fonctionner correctement.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Button("Ouvrir les réglages") {
                if let url = URL(
                    string: "x-apple.systempreferences:com.apple.Notifications"
                ) {
                    NSWorkspace.shared.open(url)
                }
            }
            .buttonStyle(.borderedProminent)
            .pointerStyle(.link)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NotificationsRequiredView()
}
