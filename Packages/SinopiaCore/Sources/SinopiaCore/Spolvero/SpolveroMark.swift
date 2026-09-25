import Foundation

/// Tail copied into the adjacent half when a stroke crosses the center sinopia rule.
public struct SpolveroMark: Sendable, Equatable, Identifiable {
    public let id: UUID
    public let sourceSide: SinopiaSide
    public let tailPath: Data
    public let inkID: UInt8

    public init(
        id: UUID = UUID(),
        sourceSide: SinopiaSide,
        tailPath: Data,
        inkID: UInt8
    ) {
        self.id = id
        self.sourceSide = sourceSide
        self.tailPath = tailPath
        self.inkID = inkID
    }
}
