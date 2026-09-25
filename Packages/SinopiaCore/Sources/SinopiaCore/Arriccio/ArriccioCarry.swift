import Foundation

/// Rolls a Halved day with one empty Sinopia onto the next daykey.
public enum ArriccioCarry {
    public static func record(from giornata: Giornata) -> Arriccio? {
        guard giornata.phase == .halved else { return nil }
        let left = giornata.left.isFilled
        let right = giornata.right.isFilled
        if left && !right {
            return Arriccio(carriedFrom: giornata.daykey, filledSide: .left)
        }
        if right && !left {
            return Arriccio(carriedFrom: giornata.daykey, filledSide: .right)
        }
        return nil
    }

    public static func carry(from giornata: Giornata, into next: DayKey) -> Giornata? {
        guard let record = record(from: giornata) else { return nil }
        let left: Sinopia
        let right: Sinopia
        switch record.filledSide {
        case .left:
            left = giornata.left
            right = Sinopia.empty(side: .right, inkID: giornata.right.inkID)
        case .right:
            left = Sinopia.empty(side: .left, inkID: giornata.left.inkID)
            right = giornata.right
        }
        return Giornata(
            daykey: next,
            phase: .halved,
            left: left,
            right: right,
            pressMark: nil,
            arriccio: record
        )
    }
}
