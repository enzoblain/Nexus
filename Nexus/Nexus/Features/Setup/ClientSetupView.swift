import SwiftUI

struct ClientSetupView: View {
    let onBack: () -> Void

    @State private var serverAddress = ""
    @State private var showOTP = false

    private var isValidAddress: Bool {
        let pattern =
            #"^((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.){3}(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d):([1-9]\d{0,4})$"#

        guard serverAddress.range(
            of: pattern,
            options: .regularExpression
        ) != nil else {
            return false
        }

        let port = Int(serverAddress.split(separator: ":").last ?? "") ?? 0
        return (1...65535).contains(port)
    }

    var body: some View {
        Group {
            if showOTP {
                OTPView(
                    onBack: {
                        withAnimation(.smooth) {
                            showOTP = false
                        }
                    },
                )
                .transition(.move(edge: .trailing))
            } else {
                configurationView
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.smooth, value: showOTP)
    }

    private var configurationView: some View {
        ZStack {
            Color(nsColor: .windowBackgroundColor)
                .ignoresSafeArea()

            VStack {
                BackButton {
                    onBack()
                }

                Spacer()

                VStack(spacing: 24) {
                    Image(systemName: "desktopcomputer")
                        .font(.system(size: 48))

                    VStack(spacing: 8) {
                        Text("Connexion à un serveur")
                            .font(.largeTitle)
                            .fontWeight(.semibold)

                        Text(
                            "Entrez l'adresse IP du serveur Nexus auquel vous souhaitez vous connecter."
                        )
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    }

                    TextField(
                        "192.168.1.10:8080",
                        text: $serverAddress
                    )
                    .textFieldStyle(.plain)
                    .padding()
                    .frame(maxWidth: 400)
                    .glassEffect(
                        .regular,
                        in: .rect(cornerRadius: 16)
                    )

                    Button("Continuer") {
                        withAnimation(.smooth) {
                            showOTP = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!isValidAddress)

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
                .padding(32)
                .frame(maxWidth: 600)
                .glassEffect(
                    .regular,
                    in: .rect(cornerRadius: 32)
                )

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    ClientSetupView {}
}
