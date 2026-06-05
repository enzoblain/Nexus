import SwiftUI

struct OTPView: View {
    let onBack: () -> Void

    @State private var code = ""
    @State private var errorMessage: String?
    @State private var isLoading = false
    @State private var showHome = false

    private var isValid: Bool {
        code.count == 6
    }

    var body: some View {
        Group {
            if showHome {
                HomeView()
            } else {
                content
            }
        }
        .animation(.smooth, value: showHome)
    }

    private var content: some View {
        ZStack {
            Color(nsColor: .windowBackgroundColor)
                .ignoresSafeArea()

            VStack {
                HStack {
                    BackButton(action: onBack)

                    Spacer()
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
                        .glassEffect(
                            .regular,
                            in: .rect(cornerRadius: 16)
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
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
                    }

                    Button {
                        isLoading = true

                        Task {
                            try? await Task.sleep(for: .seconds(2))

                            let isOTPValid = true

                            await MainActor.run {
                                isLoading = false

                                if isOTPValid {
                                    withAnimation(.smooth) {
                                        showHome = true
                                    }
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
    OTPView(
        onBack: {}
    )
}
