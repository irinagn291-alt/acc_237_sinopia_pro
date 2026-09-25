import XCTest
@testable import SinopiaCore

final class GiornataFoldTests: XCTestCase {
    private var day: DayKey { DayKey(raw: 20260921) }

    func test_firstSketch_foldsFreshToHalved() {
        let result = GiornataFold.sketch(.gesso(), daykey: day, on: .left, payload: Data([1]))
        guard case .applied(let next) = result else {
            return XCTFail("sketch should apply")
        }
        XCTAssertEqual(next.giornata(for: day)?.phase, .halved)
        XCTAssertTrue(next.giornata(for: day)?.left.isFilled == true)
        XCTAssertFalse(next.giornata(for: day)?.right.isFilled == true)
    }

    func test_undoPeelsNewestStrokeAndItsSpolvero() {
        let mark = SpolveroMark(sourceSide: .left, tailPath: Data([9]), inkID: 0)
        var codex = Codex.gesso()
        if case .applied(let a) = GiornataFold.sketch(
            codex,
            daykey: day,
            on: .left,
            payload: Data([1]),
            marks: [mark]
        ) {
            codex = a
        }
        if case .applied(let b) = GiornataFold.sketch(codex, daykey: day, on: .right, payload: Data([2])) {
            codex = b
        }
        guard case .applied(let undone) = GiornataFold.undo(codex, daykey: day) else {
            return XCTFail("undo should apply")
        }
        let giornata = undone.giornata(for: day)
        XCTAssertEqual(giornata?.right.inkStrokes.count, 0)
        XCTAssertEqual(giornata?.left.spolvero.count, 1)
        guard case .applied(let empty) = GiornataFold.undo(undone, daykey: day) else {
            return XCTFail("second undo should apply")
        }
        XCTAssertEqual(empty.giornata(for: day)?.phase, .fresh)
        XCTAssertTrue(empty.giornata(for: day)?.left.spolvero.isEmpty == true)
    }

    func test_arriccioCarry_keepsFilledHalfOnNextDay() {
        var codex = Codex.gesso()
        if case .applied(let a) = GiornataFold.sketch(codex, daykey: day, on: .left, payload: Data([1])) {
            codex = a
        }
        let nextDay = DayKey(raw: 20260922)
        let rolled = GiornataFold.rollDay(codex, from: day, to: nextDay)
        let carried = rolled.giornata(for: nextDay)
        XCTAssertEqual(carried?.phase, .halved)
        XCTAssertEqual(carried?.arriccio?.filledSide, .left)
        XCTAssertTrue(carried?.left.isFilled == true)
        XCTAssertNil(rolled.giornata(for: day))
    }
}
