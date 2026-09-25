import XCTest
@testable import SinopiaCore

final class BondDaysTests: XCTestCase {
    func test_count_isStartOfDayNowMinusStartOfDayBondedAt() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let bonded = calendar.date(from: DateComponents(year: 2026, month: 9, day: 1, hour: 23))!
        let now = calendar.date(from: DateComponents(year: 2026, month: 9, day: 21, hour: 1))!
        let startBonded = calendar.startOfDay(for: bonded)
        let startNow = calendar.startOfDay(for: now)
        let span = calendar.dateComponents([.day], from: startBonded, to: startNow).day
        XCTAssertEqual(BondDays.count(now: now, bondedAt: bonded, calendar: calendar), span)
        XCTAssertEqual(span, 20)
    }

    func test_milestones_areSevenThirtyNinetyThreeSixtyFive() {
        XCTAssertEqual(BondDays.milestones, [7, 30, 90, 365])
        XCTAssertEqual(BondDays.reachedMilestones(days: 30), [7, 30])
        XCTAssertEqual(BondDays.nextMilestone(days: 30), 90)
    }
}
