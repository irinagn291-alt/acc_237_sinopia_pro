import Foundation

/// Names and inks for the two persons who share the leaf.
public struct Bond: Sendable, Equatable {
    public let leftName: String
    public let rightName: String
    public let leftInk: InkAssignment
    public let rightInk: InkAssignment
    public let bondedAt: Date

    public init(
        leftName: String,
        rightName: String,
        leftInk: InkAssignment,
        rightInk: InkAssignment,
        bondedAt: Date
    ) {
        self.leftName = leftName
        self.rightName = rightName
        self.leftInk = leftInk
        self.rightInk = rightInk
        self.bondedAt = bondedAt
    }

    public static func gesso(bondedAt: Date = Date(timeIntervalSince1970: 0)) -> Bond {
        Bond(
            leftName: "Left",
            rightName: "Right",
            leftInk: .leftDefault,
            rightInk: .rightDefault,
            bondedAt: bondedAt
        )
    }
}
