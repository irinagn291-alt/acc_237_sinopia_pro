import Foundation

/// Which half of the split leaf a stroke or spolvero belongs to.
public enum SinopiaSide: UInt8, Sendable, Equatable {
    case left = 0
    case right = 1

    public var opposite: SinopiaSide {
        switch self {
        case .left: return .right
        case .right: return .left
        }
    }
}
