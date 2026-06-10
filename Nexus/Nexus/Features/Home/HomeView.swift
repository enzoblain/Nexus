import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var settings: AppSettings

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 64))

            Button("Test") {
                settings.accountType = .undefined
            }
            .font(.largeTitle)
            .fontWeight(.bold)

            #if os(macOS)
            .onHover { hovering in
                if hovering {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pop()
                }
            }
            #endif

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
            .environmentObject(AppSettings())
    }
}
