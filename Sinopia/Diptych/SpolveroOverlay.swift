import SwiftUI
import SinopiaCore

/// Tinted tail drawn on the adjacent half. Lives only on the diptych.
struct SpolveroOverlay: View {
    let marks: [SpolveroMark]

    var body: some View {
        Canvas { context, _ in
            for mark in marks {
                let points = TailCodec.decode(mark.tailPath)
                guard points.count >= 2 else { continue }
                var path = Path()
                path.move(to: CGPoint(x: points[0].x, y: points[0].y))
                for point in points.dropFirst() {
                    path.addLine(to: CGPoint(x: point.x, y: point.y))
                }
                context.stroke(
                    path,
                    with: .color(InkSwatch.color(mark.inkID).opacity(0.85)),
                    lineWidth: Space.unit
                )
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

enum TailCodec {
    static func decode(_ data: Data) -> [BleedGeometry.Point] {
        guard data.count >= 4 else { return [] }
        return data.withUnsafeBytes { raw in
            let count = UInt32(littleEndian: raw.loadUnaligned(as: UInt32.self))
            var points: [BleedGeometry.Point] = []
            var offset = 4
            for _ in 0..<count {
                guard offset + 16 <= raw.count else { break }
                let x = Double(bitPattern: UInt64(littleEndian: raw.loadUnaligned(fromByteOffset: offset, as: UInt64.self)))
                offset += 8
                let y = Double(bitPattern: UInt64(littleEndian: raw.loadUnaligned(fromByteOffset: offset, as: UInt64.self)))
                offset += 8
                points.append(BleedGeometry.Point(x: x, y: y))
            }
            return points
        }
    }
}
