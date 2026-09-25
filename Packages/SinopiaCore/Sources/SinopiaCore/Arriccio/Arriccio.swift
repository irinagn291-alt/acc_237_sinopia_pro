import Foundation

/// One-sided midnight giornata. The filled half carries onto the next Diptych.
public struct Arriccio: Sendable, Equatable {
    public let carriedFrom: DayKey
    public let filledSide: SinopiaSide

    public init(carriedFrom: DayKey, filledSide: SinopiaSide) {
        self.carriedFrom = carriedFrom
        self.filledSide = filledSide
    }
}
