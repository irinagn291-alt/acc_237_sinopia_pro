import Foundation

/// One half of the split leaf. PairEntry in this lexicon: a named person's drawing surface.
public struct Sinopia: Sendable, Equatable, Identifiable {
    public let id: SinopiaSide
    public let side: SinopiaSide
    public let inkID: UInt8
    public let inkStrokes: [InkStroke]

    public init(side: SinopiaSide, inkID: UInt8, inkStrokes: [InkStroke] = []) {
        self.id = side
        self.side = side
        self.inkID = inkID
        self.inkStrokes = inkStrokes
    }

    public var isFilled: Bool {
        !inkStrokes.isEmpty
    }

    public var strokes: [Data] {
        inkStrokes.map(\.payload)
    }

    public var spolvero: [SpolveroMark] {
        inkStrokes.flatMap(\.marks)
    }

    public var strokeData: Data {
        StrokeBlobCodec.encode(strokes)
    }

    public func appending(_ stroke: InkStroke) -> Sinopia {
        Sinopia(side: side, inkID: inkID, inkStrokes: inkStrokes + [stroke])
    }

    public func peelingLast() -> (Sinopia, InkStroke?) {
        guard let last = inkStrokes.last else { return (self, nil) }
        return (
            Sinopia(side: side, inkID: inkID, inkStrokes: Array(inkStrokes.dropLast())),
            last
        )
    }

    public static func empty(side: SinopiaSide, inkID: UInt8) -> Sinopia {
        Sinopia(side: side, inkID: inkID)
    }
}
