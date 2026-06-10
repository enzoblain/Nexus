import SwiftUI

struct VerificationField: View {
    @Binding var value: String

    @State private var state: TypingState = .typing
    @State private var showCaret = true

    @FocusState private var isActive: Bool

    var verify: (String) async -> TypingState

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<6, id: \.self) { index in
                characterView(index)
            }
        }
        .background {
            TextField("", text: $value)
                .focused($isActive)
                #if os(iOS)
                .keyboardType(.numberPad)
                #endif
                .frame(width: 0, height: 0)
                .opacity(0)
                .allowsHitTesting(false)
                .onChange(of: value) { _, newValue in
                    value = String(
                        newValue
                            .filter(\.isNumber)
                            .prefix(6)
                    )

                    guard value.count == 6 else {
                        state = .typing
                        return
                    }

                    Task {
                        state = await verify(value)
                    }
                }
        }
        .contentShape(.rect)
        .onTapGesture {
            isActive = true
        }
        .task {
            isActive = true

            while true {
                try? await Task.sleep(for: .milliseconds(500))
                showCaret.toggle()
            }
        }
    }

    @ViewBuilder
    private func characterView(_ index: Int) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(borderColor(for: index), lineWidth: 1.5)
            .frame(width: 50, height: 50)
            .overlay {
                let character = character(at: index)

                if !character.isEmpty {
                    Text(character)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .transition(.blurReplace)
                } else if isActive && value.count == index {
                    Rectangle()
                        .frame(width: 2, height: 24)
                        .opacity(showCaret ? 1 : 0)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: value)
    }

    private func character(at index: Int) -> String {
        guard value.count > index else {
            return ""
        }

        let stringIndex = value.index(
            value.startIndex,
            offsetBy: index
        )

        return String(value[stringIndex])
    }

    private func borderColor(for index: Int) -> Color {
        switch state {
        case .typing:
            if isActive && value.count == index {
                return .accentColor
            }

            return .gray

        case .valid:
            return .green

        case .invalid:
            return .red
        }
    }
}

#Preview {
    @Previewable @State var code = ""

    VerificationField(
        value: $code,
        verify: { code in
            try? await Task.sleep(for: .seconds(1))

            return code == "123456"
                ? .valid
                : .invalid
        }
    )
    .padding()
}
