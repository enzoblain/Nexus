import SwiftUI

struct RoleSelectionView: View {
    let onServerSelected: () -> Void
    let onClientSelected: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Image(systemName: "network")
                .font(.system(size: 60))
                .foregroundStyle(.primary)

            VStack(spacing: 8) {
                Text("Bienvenue sur Nexus")
                    .font(.largeTitle)
                    .fontWeight(.semibold)

                Text("Choisissez le rôle de cet appareil dans votre réseau.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 16) {
                #if os(macOS)
                RoleCard(
                    icon: "server.rack",
                    title: "Serveur",
                    description: "Stocke les données et les rend disponibles aux appareils autorisés."
                ) {
                    onServerSelected()
                }

                Divider()
                    .padding(.horizontal, 20)
                #endif

                RoleCard(
                    icon: "desktopcomputer",
                    title: "Client",
                    description: "Connectez cet appareil à un serveur Nexus."
                ) {
                    onClientSelected()
                }
            }
        }
        .padding(40)
        .frame(maxWidth: 600)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    RoleSelectionView(
        onServerSelected: {},
        onClientSelected: {}
    )
    .frame(width: 700, height: 520)
}
