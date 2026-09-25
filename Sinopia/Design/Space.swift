import CoreGraphics

/// Base unit 8. Every inset in a view is a multiple of this.
enum Space {
    static let unit: CGFloat = 8
    static let hairline: CGFloat = 1
    static let hit: CGFloat = 44
    static let bleed: CGFloat = 24

    static func steps(_ count: CGFloat) -> CGFloat { unit * count }
}
