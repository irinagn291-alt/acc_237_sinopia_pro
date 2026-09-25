import XCTest
@testable import SinopiaCore

final class PressRefusalTests: XCTestCase {
    private var day: DayKey { DayKey(raw: 20260921) }

    func test_pressOnFresh_isRefused() {
        let codex = Codex.gesso()
        let result = GiornataFold.press(codex, daykey: day, at: 1)
        XCTAssertEqual(result, .refused(.freshLeaf))
    }

    func test_pressOnHalvedMissingHalf_isRefused() {
        var codex = Codex.gesso()
        if case .applied(let next) = GiornataFold.sketch(codex, daykey: day, on: .left, payload: Data([1])) {
            codex = next
        } else {
            XCTFail("sketch should apply")
            return
        }
        let result = GiornataFold.press(codex, daykey: day, at: 1)
        XCTAssertEqual(result, .refused(.missingHalf))
    }

    func test_pressWhenBothFilled_locks() {
        var codex = Codex.gesso()
        if case .applied(let a) = GiornataFold.sketch(codex, daykey: day, on: .left, payload: Data([1])) {
            codex = a
        }
        if case .applied(let b) = GiornataFold.sketch(codex, daykey: day, on: .right, payload: Data([2])) {
            codex = b
        }
        let result = GiornataFold.press(codex, daykey: day, at: 42)
        guard case .applied(let next) = result else {
            return XCTFail("press should apply")
        }
        XCTAssertEqual(next.giornata(for: day)?.phase, .pressed)
        XCTAssertEqual(next.giornata(for: day)?.pressMark?.pressedAt, 42)
    }

    func test_sketchOnPressed_isRefused() {
        var codex = Codex.gesso()
        if case .applied(let a) = GiornataFold.sketch(codex, daykey: day, on: .left, payload: Data([1])) {
            codex = a
        }
        if case .applied(let b) = GiornataFold.sketch(codex, daykey: day, on: .right, payload: Data([2])) {
            codex = b
        }
        if case .applied(let c) = GiornataFold.press(codex, daykey: day, at: 1) {
            codex = c
        }
        let result = GiornataFold.sketch(codex, daykey: day, on: .left, payload: Data([3]))
        XCTAssertEqual(result, .refused(.pressedLeaf))
    }
}
