import SwiftUI

struct ClientOTPView: View {
    let onBack: () -> Void

    @EnvironmentObject private var settings: AppSettings

    @State private var code = ""
    @State private var errorMessage: String?
    @State private var isLoading = false

    private var isValid: Bool {
        code.count == 6
    }

    var body: some View {
        VStack(alignment: .leading) {
            BackButton {
                onBack()
            }

            Spacer()

            VStack(spacing: 24) {
                Image(systemName: "lock.shield")
                    .font(.system(size: 48))

                VStack(spacing: 8) {
                    Text("Code de vérification")
                        .font(.largeTitle)
                        .fontWeight(.semibold)

                    Text(
                        "Entrez le code à 6 chiffres affiché sur le serveur Nexus."
                    )
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                }

                TextField("123456", text: $code)
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.center)
                    .font(
                        .system(
                            size: 28,
                            weight: .medium,
                            design: .monospaced
                        )
                    )
                    .padding()
                    .frame(width: 220)
                    .background(.regularMaterial)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 16,
                            style: .continuous
                        )
                    )
                    .overlay {
                        RoundedRectangle(
                            cornerRadius: 16,
                            style: .continuous
                        )
                        .stroke(
                            errorMessage == nil ? .clear : .red,
                            lineWidth: 1
                        )
                    }
                    .onChange(of: code) { _, newValue in
                        code = String(
                            newValue
                                .filter(\.isNumber)
                                .prefix(6)
                        )

                        withAnimation(.smooth) {
                            errorMessage = nil
                        }
                    }

                if let errorMessage {
                    HStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill")

                        Text(errorMessage)

                        Spacer()
                    }
                    .padding()
                    .frame(width: 300)
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
                            .red.opacity(0.5),
                            lineWidth: 1
                        )
                    }
                }

                Button {
                    isLoading = true

                    Task {
                        try? await Task.sleep(for: .seconds(2))

                        let isOTPValid = true

                        await MainActor.run {
                            isLoading = false

                            if isOTPValid {
                                settings.accountType = .client
                            } else {
                                withAnimation(.smooth) {
                                    errorMessage = "Code OTP invalide."
                                }
                            }
                        }
                    }
                } label: {
                    if isLoading {
                        ProgressView()
                            .controlSize(.small)
                    } else {
                        Text("Continuer")
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(!isValid || isLoading)

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
    ClientOTPView(
        onBack: {}
    )
    .environmentObject(AppSettings())
    .frame(width: 700, height: 520)
}
