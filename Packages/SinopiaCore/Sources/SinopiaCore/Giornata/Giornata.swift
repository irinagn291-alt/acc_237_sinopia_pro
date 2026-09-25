import Foundation

/// One day's split leaf. PairEntry for this family: two Sinopie keyed by daykey.
public struct Giornata: Sendable, Equatable, Identifiable {
    public var id: DayKey { daykey }
    public let daykey: DayKey
    public let phase: GiornataPhase
    public let left: Sinopia
    public let right: Sinopia
    public let pressMark: PressMark?
    public let arriccio: Arriccio?

    public init(
        daykey: DayKey,
        phase: GiornataPhase,
        left: Sinopia,
        right: Sinopia,
        pressMark: PressMark? = nil,
        arriccio: Arriccio? = nil
    ) {
        self.daykey = daykey
        self.phase = phase
        self.left = left
        self.right = right
        self.pressMark = pressMark
        self.arriccio = arriccio
    }

    public static func fresh(daykey: DayKey, bond: Bond) -> Giornata {
        Giornata(
            daykey: daykey,
            phase: .fresh,
            left: .empty(side: .left, inkID: bond.leftInk.id),
            right: .empty(side: .right, inkID: bond.rightInk.id)
        )
    }

    public func sinopia(on side: SinopiaSide) -> Sinopia {
        switch side {
        case .left: return left
        case .right: return right
        }
    }

    public func replacing(side: SinopiaSide, with half: Sinopia, phase: GiornataPhase) -> Giornata {
        Giornata(
            daykey: daykey,
            phase: phase,
            left: side == .left ? half : left,
            right: side == .right ? half : right,
            pressMark: pressMark,
            arriccio: arriccio
        )
    }
}
