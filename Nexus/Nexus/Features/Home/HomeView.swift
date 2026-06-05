import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 64))

            Button("Test") {
                Task {
                    do {
                        try await NotificationManager.shared.send(
                            .otp(code: "123456")
                        )
                    } catch {
                        print("Notification error:", error.localizedDescription)
                    }
                }
            }
                .font(.largeTitle)
                .fontWeight(.bold)
                .pointerStyle(.link)

            Text("Powered by Rust")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Accueil")
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
