import Foundation

/// Exactly one phase per Giornata. The fold never parks a day in two phases at once.
public enum GiornataPhase: UInt8, Sendable, Equatable {
    case fresh = 0
    case halved = 1
    case pressed = 2
}
