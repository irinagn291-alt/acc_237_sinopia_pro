import Foundation

/// Launch keys, not tabs. Parsed once after onboarding from ProcessInfo arguments.
public enum ReviewScreenKey: String, Sendable, Equatable {
    case today
    case log
    case goals
    case settings

    public static func parse(arguments: [String]) -> ReviewScreenKey? {
        guard let index = arguments.firstIndex(of: "-ReviewScreen") else { return nil }
        let next = arguments.index(after: index)
        guard next < arguments.endIndex else { return nil }
        return ReviewScreenKey(rawValue: arguments[next])
    }
}
