enum NotificationType {
    case otp(code: String)

    var content: NotificationContent {
        switch self {
        case .otp(let code):
            return NotificationContent(
                title: "Code de vérification",
                subtitle: nil,
                body: code
            )
        }
    }
}
