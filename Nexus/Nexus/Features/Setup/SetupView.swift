import SwiftUI

struct SetupView: View {
    @State private var selectedAccountType: AccountType?

    var body: some View {
        Group {
            switch selectedAccountType {
            case .server:
                ServerSetupView {
                    withAnimation(.smooth) {
                        selectedAccountType = nil
                    }
                }

            case .client:
                ClientSetupView {
                    withAnimation(.smooth) {
                        selectedAccountType = nil
                    }
                }

            case nil:
                roleSelectionView
            }
        }
        .animation(.smooth, value: selectedAccountType)
    }

    private var roleSelectionView: some View {
        ZStack {
            Color(nsColor: .windowBackgroundColor)
                .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 32) {
                    Image(systemName: "network")
                        .font(.system(size: 60))
                        .foregroundStyle(.primary)

                    VStack(spacing: 8) {
                        Text("Bienvenue sur Nexus")
                            .font(.largeTitle)
                            .fontWeight(.semibold)

                        Text(
                            "Choisissez le rôle de cet appareil dans votre réseau."
                        )
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    }

                    VStack(spacing: 16) {
                        #if os(macOS)
                        RoleCard(
                            icon: "server.rack",
                            title: "Serveur",
                            description:
                                "Stocke les données et les rend disponibles aux appareils autorisés."
                        ) {
                            withAnimation(.smooth) {
                                selectedAccountType = .server
                            }
                        }

                        Divider()
                            .padding(.horizontal, 20)
                        #endif

                        RoleCard(
                            icon: "desktopcomputer",
                            title: "Client",
                            description:
                                "Connectez cet appareil à un serveur Nexus."
                        ) {
                            withAnimation(.smooth) {
                                selectedAccountType = .client
                            }
                        }
                    }
                }
                .padding(32)
                .frame(maxWidth: 600)

                Spacer()
            }
        }
        .transition(.opacity.combined(with: .scale))
    }
}
