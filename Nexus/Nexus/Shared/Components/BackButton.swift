import SwiftUI

struct BackButton: View {
    let action: () -> Void

    var body: some View {
        HStack {
            Button(action: action) {
                Label("Retour", systemImage: "chevron.left")
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(minWidth: 100)
                    .glassEffect(
                        .regular,
                        in: .capsule
                    )
                    .overlay {
                        Capsule()
                            .strokeBorder(
                                .white.opacity(0.15),
                                lineWidth: 1
                            )
                    }
                    .contentShape(Capsule())
            }
            .buttonStyle(.plain)

            #if os(macOS)
            .onHover { hovering in
                if hovering {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pop()
                }
            }
            #endif

            Spacer()
        }
    }
}

#Preview {
    BackButton { }
        .padding()
}
