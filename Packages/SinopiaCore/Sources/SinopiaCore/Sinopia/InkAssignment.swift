import Foundation

/// Stable ink identifier mapped later to a PKInkingTool. Stored as a byte in the codex.
public struct InkAssignment: Sendable, Equatable {
    public let id: UInt8

    public init(id: UInt8) {
        self.id = id
    }

    public static let leftDefault = InkAssignment(id: 0)
    public static let rightDefault = InkAssignment(id: 1)
}
