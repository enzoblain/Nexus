import SwiftUI

struct ServerSetupView: View {
    let onBack: () -> Void

    @State private var port = "8080"
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            Color(nsColor: .windowBackgroundColor)
                .ignoresSafeArea()

            VStack {
                BackButton{
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

                        TextField(
                            "8080",
                            text: $port
                        )
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
                    .glassEffect(
                        .regular,
                        in: .rect(cornerRadius: 16)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.clear, lineWidth: 1)
                    }

                    if let errorMessage {
                        HStack(spacing: 10) {
                            Image(systemName: "exclamationmark.triangle.fill")

                            Text(errorMessage)

                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: 300)
                        .foregroundStyle(.red)
                        .glassEffect(
                            .regular,
                            in: .rect(cornerRadius: 12)
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    .red.opacity(0.5),
                                    lineWidth: 1
                                )
                        }
                        .animation(.easeInOut(duration: 0.2), value: errorMessage)
                    }

                    Button("Démarrer le serveur") {
                        // TODO: Check si le port actuel marche
                        if (true) {
                            withAnimation(.smooth) {
                                errorMessage = "Le port est déjà utilisé."
                            }
                        } else {}
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
        .transition(.move(edge: .trailing))
    }
}

#Preview {
    ServerSetupView {}
}
