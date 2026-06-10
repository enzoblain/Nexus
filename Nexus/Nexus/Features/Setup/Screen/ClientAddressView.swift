import SwiftUI

struct ClientAddressView: View {
    let onBack: () -> Void
    let onContinue: (String) -> Void

    @State private var serverAddress = ""

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
        VStack(alignment: .leading) {
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
                        "Entrez l'adresse du serveur Nexus auquel vous souhaitez vous connecter."
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
                .background(.regularMaterial)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 16,
                        style: .continuous
                    )
                )

                Button("Continuer") {
                    onContinue(serverAddress)
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
            .frame(maxWidth: .infinity)

            Spacer()
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ClientAddressView(
        onBack: {},
        onContinue: { _ in }
    )
    .frame(width: 700, height: 520)
}
