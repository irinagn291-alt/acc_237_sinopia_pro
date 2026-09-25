import XCTest
@testable import SinopiaCore

final class CodexBinaryTests: XCTestCase {
    func test_roundTrip_preservesBondAndGiornata() async throws {
        let day = DayKey(raw: 20260921)
        var codex = Codex.gesso(bond: Bond(
            leftName: "Ada",
            rightName: "Baz",
            leftInk: .leftDefault,
            rightInk: .rightDefault,
            bondedAt: Date(timeIntervalSince1970: 1_700_000_000)
        ))
        if case .applied(let a) = GiornataFold.sketch(codex, daykey: day, on: .left, payload: Data([4, 5])) {
            codex = a
        }
        if case .applied(let b) = GiornataFold.sketch(codex, daykey: day, on: .right, payload: Data([6])) {
            codex = b
        }
        if case .applied(let c) = GiornataFold.press(codex, daykey: day, at: 99) {
            codex = c
        }

        let data = CodexBinary.encode(codex)
        XCTAssertEqual(Array(data.prefix(4)), [0x53, 0x4E, 0x50, 0x43])
        let restored = try CodexBinary.decodeStrict(data)
        XCTAssertEqual(restored.bond.leftName, "Ada")
        XCTAssertEqual(restored.giornata(for: day)?.phase, .pressed)
        XCTAssertEqual(restored.giornata(for: day)?.left.strokes.first, Data([4, 5]))

        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent("snp-codex-\(UUID().uuidString)", isDirectory: true)
        let file = CodexFile(directoryURL: directory)
        try await file.save(codex)
        let outcome = await file.load()
        guard case .loaded(let disk) = outcome else {
            return XCTFail("expected loaded codex")
        }
        XCTAssertEqual(disk.bond.rightName, "Baz")
        try await file.resetAllData()
        let empty = await file.load()
        guard case .loaded(let gesso) = empty else {
            return XCTFail("reset should load gesso")
        }
        XCTAssertTrue(gesso.isGesso)
    }

    func test_unknownVersion_isGesso() {
        var data = CodexBinary.encode(.gesso())
        data[4] = 99
        let decoded = CodexBinary.decode(data)
        XCTAssertTrue(decoded.isGesso)
    }

    func test_shortTail_isGesso() {
        let decoded = CodexBinary.decode(Data([0x53, 0x4E, 0x50, 0x43, 0x01, 0x00]))
        XCTAssertTrue(decoded.isGesso)
    }

    func test_byteCursor_reportsTruncation() {
        var cursor = ByteCursor(Data([0x01]))
        XCTAssertThrowsError(try cursor.readUInt32()) { error in
            XCTAssertEqual(error as? ByteCursor.Failure, .truncated)
        }
    }

    func test_corruptPrimary_fallsBackToBackup() async throws {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent("snp-backup-\(UUID().uuidString)", isDirectory: true)
        let file = CodexFile(directoryURL: directory)
        var codex = Codex.gesso()
        if case .applied(let next) = GiornataFold.sketch(
            codex,
            daykey: DayKey(raw: 20260101),
            on: .left,
            payload: Data([1])
        ) {
            codex = next
        }
        try await file.save(codex)
        if case .applied(let next) = GiornataFold.sketch(
            codex,
            daykey: DayKey(raw: 20260101),
            on: .right,
            payload: Data([2])
        ) {
            try await file.save(next)
        }
        try Data([0x00, 0x01]).write(to: file.fileURL)
        let outcome = await file.load()
        guard case .recoveredFromBackup(let recovered) = outcome else {
            return XCTFail("expected backup recovery, got \(outcome)")
        }
        XCTAssertTrue(recovered.giornata(for: DayKey(raw: 20260101))?.left.isFilled == true)
    }
}
