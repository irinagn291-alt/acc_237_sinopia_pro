import Foundation

/// Every count on screen goes through one formatter.
enum CountFormat {
    static let decimal: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    static func text(_ value: Int) -> String {
        decimal.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

enum DayLabel {
    static let medium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    static func text(_ date: Date) -> String {
        medium.string(from: date)
    }
}
