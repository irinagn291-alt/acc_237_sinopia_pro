import XCTest
@testable import SinopiaCore

final class SpolveroBleedTests: XCTestCase {
    func test_crossingStroke_emitsTail() {
        let points = [
            BleedGeometry.Point(x: 10, y: 10),
            BleedGeometry.Point(x: 90, y: 12),
        ]
        XCTAssertTrue(BleedGeometry.crossesCenter(points: points, centerX: 50))
        let tail = BleedGeometry.tailAfterCenter(points: points, centerX: 50)
        XCTAssertFalse(tail.isEmpty)
        XCTAssertEqual(tail.first?.x, 50)
    }

    func test_localStroke_doesNotBleed() {
        let points = [
            BleedGeometry.Point(x: 10, y: 10),
            BleedGeometry.Point(x: 20, y: 12),
        ]
        XCTAssertFalse(BleedGeometry.crossesCenter(points: points, centerX: 50))
        XCTAssertTrue(BleedGeometry.tailAfterCenter(points: points, centerX: 50).isEmpty)
    }
}
