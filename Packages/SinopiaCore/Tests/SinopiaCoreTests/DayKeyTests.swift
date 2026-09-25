import XCTest
@testable import SinopiaCore

final class DayKeyTests: XCTestCase {
    func test_fromDate_usesStartOfDayComponents() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        var parts = DateComponents()
        parts.year = 2026
        parts.month = 9
        parts.day = 21
        parts.hour = 18
        let date = calendar.date(from: parts)!
        let key = DayKey.from(date: date, calendar: calendar)
        XCTAssertEqual(key.raw, 20260921)
    }

    func test_next_advancesOneCalendarDay() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let key = DayKey(raw: 20260921)
        XCTAssertEqual(key.next(calendar: calendar)?.raw, 20260922)
    }
}
