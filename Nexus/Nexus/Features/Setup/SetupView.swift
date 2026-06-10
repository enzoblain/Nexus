import SwiftUI

struct SetupView: View {
    @State private var step: SetupStep = .roleSelection
    @State private var serverAddress = ""

    var body: some View {
        ZStack {
            Color(nsColor: .windowBackgroundColor)
                .ignoresSafeArea()

            content
                .frame(width: 700, height: 520)
                .glassEffect(
                    .regular,
                    in: .rect(cornerRadius: 36)
                )
        }
        .animation(.smooth(duration: 0.4), value: step)
    }

    @ViewBuilder
    private var content: some View {
        switch step {
        case .roleSelection:
            RoleSelectionView(
                onServerSelected: {
                    step = .serverSetup
                },
                onClientSelected: {
                    step = .clientAddress
                }
            )
            .transition(.scale.combined(with: .opacity))

        case .serverSetup:
            ServerSetupView {
                step = .roleSelection
            }
            .transition(.scale.combined(with: .opacity))

        case .clientAddress:
            ClientAddressView(
                onBack: {
                    step = .roleSelection
                },
                onContinue: { address in
                    serverAddress = address
                    step = .clientOTP
                }
            )
            .transition(.scale.combined(with: .opacity))

        case .clientOTP:
            ClientOTPView(
                onBack: {
                    step = .clientAddress
                }
            )
            .transition(.scale.combined(with: .opacity))
        }
    }
}

#Preview {
    SetupView()
}
