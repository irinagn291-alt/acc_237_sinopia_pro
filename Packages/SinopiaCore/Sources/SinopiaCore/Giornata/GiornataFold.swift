import Foundation

/// Illegal moves return values. The view never reaches a state the fold refused.
public enum FoldRefusal: Sendable, Equatable {
    case freshLeaf
    case pressedLeaf
    case missingHalf
    case emptyUndo
}

public enum FoldResult: Sendable, Equatable {
    case applied(Codex)
    case refused(FoldRefusal)
}

/// Pure fold over Giornate. Sketch, Press, Undo, and day roll live here, not in a View.
public enum GiornataFold {
    public static func sketch(
        _ codex: Codex,
        daykey: DayKey,
        on side: SinopiaSide,
        payload: Data,
        marks: [SpolveroMark] = []
    ) -> FoldResult {
        let giornata = codex.giornata(for: daykey) ?? Giornata.fresh(daykey: daykey, bond: codex.bond)
        if giornata.phase == .pressed {
            return .refused(.pressedLeaf)
        }
        let sequence = nextSequence(giornata)
        let stroke = InkStroke(sequence: sequence, payload: payload, marks: marks)
        let nextHalf = giornata.sinopia(on: side).appending(stroke)
        let updated = giornata.replacing(side: side, with: nextHalf, phase: .halved)
        return .applied(codex.upsert(updated))
    }

    public static func press(
        _ codex: Codex,
        daykey: DayKey,
        at pressedAt: TimeInterval
    ) -> FoldResult {
        guard let giornata = codex.giornata(for: daykey) else {
            return .refused(.freshLeaf)
        }
        switch PressRule.evaluate(giornata) {
        case .refused(let reason):
            return .refused(reason)
        case .ready:
            let mark = PressMark(daykey: daykey, pressedAt: pressedAt)
            let locked = Giornata(
                daykey: daykey,
                phase: .pressed,
                left: giornata.left,
                right: giornata.right,
                pressMark: mark,
                arriccio: giornata.arriccio
            )
            return .applied(codex.upsert(locked))
        }
    }

    public static func undo(_ codex: Codex, daykey: DayKey) -> FoldResult {
        guard let giornata = codex.giornata(for: daykey) else {
            return .refused(.emptyUndo)
        }
        if giornata.phase == .pressed {
            return .refused(.pressedLeaf)
        }
        guard let side = newestSide(giornata) else {
            return .refused(.emptyUndo)
        }
        let (peeledHalf, removed) = giornata.sinopia(on: side).peelingLast()
        guard removed != nil else { return .refused(.emptyUndo) }
        let left = side == .left ? peeledHalf : giornata.left
        let right = side == .right ? peeledHalf : giornata.right
        let phase: GiornataPhase = (left.isFilled || right.isFilled) ? .halved : .fresh
        let updated = Giornata(
            daykey: daykey,
            phase: phase,
            left: left,
            right: right,
            pressMark: nil,
            arriccio: giornata.arriccio
        )
        return .applied(codex.upsert(updated))
    }

    public static func rollDay(_ codex: Codex, from old: DayKey, to next: DayKey) -> Codex {
        guard let current = codex.giornata(for: old) else { return codex }
        if current.phase == .pressed {
            return codex
        }
        if let carried = ArriccioCarry.carry(from: current, into: next) {
            return codex.removing(old).upsert(carried)
        }
        if current.phase == .fresh {
            return codex.removing(old)
        }
        return codex
    }

    private static func nextSequence(_ giornata: Giornata) -> UInt64 {
        let all = giornata.left.inkStrokes + giornata.right.inkStrokes
        return (all.map(\.sequence).max() ?? 0) + 1
    }

    private static func newestSide(_ giornata: Giornata) -> SinopiaSide? {
        let leftSeq = giornata.left.inkStrokes.last?.sequence
        let rightSeq = giornata.right.inkStrokes.last?.sequence
        switch (leftSeq, rightSeq) {
        case (nil, nil):
            return nil
        case (.some, nil):
            return .left
        case (nil, .some):
            return .right
        case (let left?, let right?):
            return left >= right ? .left : .right
        }
    }
}
