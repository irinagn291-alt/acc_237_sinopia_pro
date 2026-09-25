import Foundation

/// Record written when Press locks a Halved giornata. Keyed by daykey.
public struct PressMark: Sendable, Equatable, Identifiable {
    public var id: DayKey { daykey }
    public let daykey: DayKey
    public let pressedAt: TimeInterval

    public init(daykey: DayKey, pressedAt: TimeInterval) {
        self.daykey = daykey
        self.pressedAt = pressedAt
    }
}
