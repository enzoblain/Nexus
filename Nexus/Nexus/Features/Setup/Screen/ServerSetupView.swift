import SwiftUI

struct ServerSetupView: View {
    let onBack: () -> Void

    @EnvironmentObject private var settings: AppSettings

    @State private var port = "8080"
    @State private var errorMessage: String?

    var body: some View {
        VStack(alignment: .leading) {
            BackButton {
                onBack()
            }

            Spacer()

            VStack(spacing: 24) {
                Image(systemName: "server.rack")
                    .font(.system(size: 48))

                VStack(spacing: 8) {
                    Text("Configuration du serveur")
                        .font(.largeTitle)
                        .fontWeight(.semibold)

                    Text(
                        "Choisissez le port sur lequel le serveur Nexus écoutera les connexions."
                    )
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                }

                HStack(spacing: 12) {
                    Image(systemName: "network")

                    TextField("8080", text: $port)
                        .textFieldStyle(.plain)
                        .onChange(of: port) { _, newValue in
                            port = String(
                                newValue
                                    .filter(\.isNumber)
                                    .prefix(5)
                            )

                            withAnimation(.smooth) {
                                errorMessage = nil
                            }
                        }
                }
                .padding()
                .frame(maxWidth: 300)
                .background(.regularMaterial)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 16,
                        style: .continuous
                    )
                )

                if let errorMessage {
                    HStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill")

                        Text(errorMessage)

                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: 300)
                    .foregroundStyle(.red)
                    .background(.regularMaterial)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 12,
                            style: .continuous
                        )
                    )
                    .overlay {
                        RoundedRectangle(
                            cornerRadius: 12,
                            style: .continuous
                        )
                        .stroke(
                            .red.opacity(0.4),
                            lineWidth: 1
                        )
                    }
                }

                Button("Démarrer le serveur") {
                    Task {
                        let portNumber = Int(port) ?? 0

                        guard (1...65535).contains(portNumber) else {
                            withAnimation(.smooth) {
                                errorMessage = "Port invalide."
                            }
                            return
                        }

                        // TODO: Vérifier si le port est disponible

                        settings.accountType = .server

                        try? await NotificationManager.shared
                            .requestAuthorization()

                        await settings.refreshNotificationsStatus()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(port.isEmpty || errorMessage != nil)

                #if os(macOS)
                .onHover { hovering in
                    if hovering {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                }
                #endif
            }
            .frame(maxWidth: .infinity)

            Spacer()
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ServerSetupView(
        onBack: {}
    )
    .environmentObject(AppSettings())
    .frame(width: 700, height: 520)
}
