import XCTest
import SinopiaCore
@testable import Sinopia

final class DiptychStateTests: XCTestCase {
    func test_pressCopy_namesTheRefusal() {
        XCTAssertEqual(PressCopy.line(.freshLeaf), "Sketch both halves first.")
        XCTAssertEqual(PressCopy.line(.missingHalf), "One half is still empty.")
        XCTAssertEqual(PressCopy.line(.pressedLeaf), "This leaf is pressed.")
    }

    func test_seededLeaf_pressIsReadyAndWallHasFour() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let now = calendar.date(from: DateComponents(year: 2026, month: 9, day: 22))!
        let codex = DemoSeed.codex(now: now, calendar: calendar)
        let today = DayKey.from(date: now, calendar: calendar)
        let live = codex.giornata(for: today)
        XCTAssertEqual(live?.phase, .halved)
        XCTAssertEqual(PressRule.evaluate(live!).isEnabled, true)
        XCTAssertEqual(codex.pressedNewestFirst.count, 4)
        XCTAssertFalse(codex.isGesso)
        XCTAssertFalse(live?.left.spolvero.isEmpty ?? true)
    }

    func test_twist_undoPeelsSpolveroWithTheStroke() {
        let day = DayKey(raw: 20260922)
        var codex = Codex.gesso()
        let mark = SpolveroMark(
            sourceSide: .left,
            tailPath: BleedGeometry.encodeTail([
                BleedGeometry.Point(x: 1, y: 1),
                BleedGeometry.Point(x: 2, y: 2)
            ]),
            inkID: 0
        )
        codex = {
            if case .applied(let next) = GiornataFold.sketch(codex, daykey: day, on: .left, payload: Data([1]), marks: [mark]) {
                return next
            }
            return codex
        }()
        XCTAssertEqual(codex.giornata(for: day)?.left.spolvero.count, 1)
        if case .applied(let peeled) = GiornataFold.undo(codex, daykey: day) {
            XCTAssertTrue(peeled.giornata(for: day)?.left.spolvero.isEmpty ?? false)
        } else {
            XCTFail("undo")
        }
    }
}
