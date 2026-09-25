import Foundation

/// Pure geometry for the bleed-and-press twist. A stroke whose polyline crosses
/// the center rule emits a tail for SpolveroMark; otherwise the stroke stays local.
public enum BleedGeometry {
    public struct Point: Sendable, Equatable {
        public let x: Double
        public let y: Double

        public init(x: Double, y: Double) {
            self.x = x
            self.y = y
        }
    }

    public static func crossesCenter(points: [Point], centerX: Double) -> Bool {
        guard points.count >= 2 else { return false }
        var sawLeft = false
        var sawRight = false
        for point in points {
            if point.x < centerX { sawLeft = true }
            if point.x > centerX { sawRight = true }
            if sawLeft && sawRight { return true }
        }
        for index in points.indices.dropLast() {
            let a = points[index]
            let b = points[index + 1]
            if segmentCrosses(a: a, b: b, centerX: centerX) {
                return true
            }
        }
        return false
    }

    /// Points from the first crossing to the end of the stroke, the tail that bleeds.
    public static func tailAfterCenter(points: [Point], centerX: Double) -> [Point] {
        guard points.count >= 2 else { return [] }
        for index in points.indices.dropLast() {
            let a = points[index]
            let b = points[index + 1]
            if segmentCrosses(a: a, b: b, centerX: centerX) {
                let crossed = intersection(a: a, b: b, centerX: centerX)
                return [crossed] + Array(points[(index + 1)...])
            }
        }
        return []
    }

    public static func encodeTail(_ points: [Point]) -> Data {
        var data = Data()
        var count = UInt32(points.count).littleEndian
        data.append(contentsOf: withUnsafeBytes(of: &count) { Array($0) })
        for point in points {
            var x = point.x.bitPattern.littleEndian
            var y = point.y.bitPattern.littleEndian
            data.append(contentsOf: withUnsafeBytes(of: &x) { Array($0) })
            data.append(contentsOf: withUnsafeBytes(of: &y) { Array($0) })
        }
        return data
    }

    private static func segmentCrosses(a: Point, b: Point, centerX: Double) -> Bool {
        (a.x - centerX) * (b.x - centerX) < 0
    }

    private static func intersection(a: Point, b: Point, centerX: Double) -> Point {
        let dx = b.x - a.x
        if dx == 0 { return Point(x: centerX, y: a.y) }
        let t = (centerX - a.x) / dx
        return Point(x: centerX, y: a.y + t * (b.y - a.y))
    }
}
