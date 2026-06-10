import SwiftUI

struct RoleCard: View {
    let icon: String
    let title: String
    let description: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)

                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
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
        .glassEffect(.regular, in: .rect(cornerRadius: 20))
    }
}

#Preview {
    RoleCard(
        icon: "server.rack",
        title: "Serveur",
        description:
            "Stocke les données et les rend disponibles aux appareils autorisés."
    ) { }
    .padding()
}
