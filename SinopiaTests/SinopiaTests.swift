import XCTest
@testable import Sinopia
import SinopiaCore

final class SinopiaTests: XCTestCase {
    func test_appModuleImports() {
        XCTAssertEqual(String(describing: SinopiaApp.self), "SinopiaApp")
    }

    func test_reviewScreenKeys_areLaunchArgumentsNotTabs() {
        XCTAssertEqual(
            ReviewScreenKey.parse(arguments: ["-ReviewScreen", "today"]),
            .today
        )
        XCTAssertEqual(
            ReviewScreenKey.parse(arguments: ["-ReviewScreen", "log"]),
            .log
        )
        XCTAssertEqual(
            ReviewScreenKey.parse(arguments: ["-ReviewScreen", "goals"]),
            .goals
        )
        XCTAssertEqual(
            ReviewScreenKey.parse(arguments: ["-ReviewScreen", "settings"]),
            .settings
        )
        XCTAssertNil(ReviewScreenKey.parse(arguments: ["-ReviewScreen"]))
    }

    @MainActor
    func test_codexStore_keepsMemoryWhenFileMissingAfterApply() async throws {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent("snp-store-\(UUID().uuidString)", isDirectory: true)
        let file = CodexFile(directoryURL: directory)
        let store = CodexStore(file: file)
        await store.load()
        XCTAssertTrue(store.codex.isGesso)
        let sketched = GiornataFold.sketch(
            store.codex,
            daykey: DayKey(raw: 20260921),
            on: .left,
            payload: Data([8])
        )
        store.apply(sketched, flushImmediately: true)
        await store.flush()
        XCTAssertTrue(store.codex.giornata(for: DayKey(raw: 20260921))?.left.isFilled == true)
        await store.resetAllData()
        XCTAssertTrue(store.codex.isGesso)
    }

    func test_familyInvariant_bondDays() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let bonded = calendar.date(from: DateComponents(year: 2026, month: 1, day: 1))!
        let now = calendar.date(from: DateComponents(year: 2026, month: 1, day: 8))!
        XCTAssertEqual(BondDays.count(now: now, bondedAt: bonded, calendar: calendar), 7)
        XCTAssertTrue(BondDays.reachedMilestones(days: 7).contains(7))
    }
}
