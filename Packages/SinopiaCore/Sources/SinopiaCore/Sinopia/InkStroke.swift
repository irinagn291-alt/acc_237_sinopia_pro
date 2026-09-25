import Foundation

/// One PencilKit stroke plus the spolvero tails it produced. Undo peels this unit.
public struct InkStroke: Sendable, Equatable, Identifiable {
    public let id: UUID
    public let sequence: UInt64
    public let payload: Data
    public let marks: [SpolveroMark]

    public init(
        id: UUID = UUID(),
        sequence: UInt64,
        payload: Data,
        marks: [SpolveroMark] = []
    ) {
        self.id = id
        self.sequence = sequence
        self.payload = payload
        self.marks = marks
    }
}

enum StrokeBlobCodec {
    static func encode(_ strokes: [Data]) -> Data {
        var data = Data()
        var count = UInt32(strokes.count).littleEndian
        data.append(contentsOf: withUnsafeBytes(of: &count) { Array($0) })
        for blob in strokes {
            var length = UInt32(blob.count).littleEndian
            data.append(contentsOf: withUnsafeBytes(of: &length) { Array($0) })
            data.append(blob)
        }
        return data
    }

    static func decode(_ data: Data) -> [Data] {
        var cursor = ByteCursor(data)
        guard let count = try? cursor.readUInt32() else { return data.isEmpty ? [] : [data] }
        var blobs: [Data] = []
        blobs.reserveCapacity(Int(count))
        for _ in 0..<count {
            guard let blob = try? cursor.readLengthPrefixed() else { return blobs }
            blobs.append(blob)
        }
        return blobs
    }
}
