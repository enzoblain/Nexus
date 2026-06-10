import SwiftUI

struct ClientOTPView: View {
    let onBack: () -> Void

    @EnvironmentObject private var settings: AppSettings

    @State private var code = ""
    @State private var errorMessage: String?

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

                VerificationField(
                    value: $code,
                    verify: { code in
                        try? await Task.sleep(for: .seconds(2))

                        // TODO: Vérification réelle auprès du serveur
                        let isOTPValid = true

                        await MainActor.run {
                            if isOTPValid {
                                settings.accountType = .client
                            } else {
                                withAnimation(.smooth) {
                                    errorMessage = "Code OTP invalide."
                                }
                            }
                        }

                        return isOTPValid ? .valid : .invalid
                    }
                )
                .onChange(of: code) { _, _ in
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
