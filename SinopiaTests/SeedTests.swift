import XCTest
import SinopiaCore
@testable import Sinopia

final class SeedTests: XCTestCase {
    func test_demoKey_isVersioned() {
        XCTAssertEqual(PreferenceKeys.demoSeed, "snp.demo.v1")
    }

    func test_seedBondDays_coverTheSevenDayMark() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let now = calendar.date(from: DateComponents(year: 2026, month: 9, day: 22))!
        let codex = DemoSeed.codex(now: now, calendar: calendar)
        let days = BondDays.count(now: now, bondedAt: codex.bond.bondedAt, calendar: calendar)
        XCTAssertEqual(days, 10)
        XCTAssertTrue(BondDays.reachedMilestones(days: days).contains(7))
        XCTAssertFalse(BondDays.reachedMilestones(days: days).contains(30))
    }
}
