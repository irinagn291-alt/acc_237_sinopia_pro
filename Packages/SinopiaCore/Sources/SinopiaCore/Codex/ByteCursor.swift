import Foundation

/// Bounds-checked reader. A short tail is a typed failure, never a trap.
public struct ByteCursor: Sendable {
    public enum Failure: Error, Sendable, Equatable {
        case truncated
        case unexpectedValue
    }

    private let data: Data
    private var offset: Int

    public init(_ data: Data) {
        self.data = data
        self.offset = 0
    }

    public var remaining: Int {
        data.count - offset
    }

    public mutating func readUInt8() throws -> UInt8 {
        guard remaining >= 1 else { throw Failure.truncated }
        let value = data[data.startIndex + offset]
        offset += 1
        return value
    }

    public mutating func readInt32() throws -> Int32 {
        Int32(bitPattern: try readUInt32())
    }

    public mutating func readUInt32() throws -> UInt32 {
        let raw = try readExact(4)
        var value: UInt32 = 0
        _ = withUnsafeMutableBytes(of: &value) { dest in
            raw.copyBytes(to: dest)
        }
        return UInt32(littleEndian: value)
    }

    public mutating func readUInt64() throws -> UInt64 {
        let raw = try readExact(8)
        var value: UInt64 = 0
        _ = withUnsafeMutableBytes(of: &value) { dest in
            raw.copyBytes(to: dest)
        }
        return UInt64(littleEndian: value)
    }

    public mutating func readDouble() throws -> Double {
        Double(bitPattern: try readUInt64())
    }

    public mutating func readExact(_ count: Int) throws -> Data {
        guard count >= 0, remaining >= count else { throw Failure.truncated }
        let start = data.startIndex + offset
        let slice = data[start..<(start + count)]
        offset += count
        return Data(slice)
    }

    public mutating func readLengthPrefixed() throws -> Data {
        let length = try readUInt32()
        return try readExact(Int(length))
    }

    public mutating func readUTF8() throws -> String {
        let bytes = try readLengthPrefixed()
        guard let text = String(data: bytes, encoding: .utf8) else {
            throw Failure.unexpectedValue
        }
        return text
    }
}
