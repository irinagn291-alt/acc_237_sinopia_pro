import Foundation

/// Verdict for the Press control. The view displays the reason; it never invents one.
public enum PressVerdict: Sendable, Equatable {
    case ready
    case refused(FoldRefusal)

    public var isEnabled: Bool {
        if case .ready = self { return true }
        return false
    }
}

public enum PressRule {
    public static func evaluate(_ giornata: Giornata) -> PressVerdict {
        switch giornata.phase {
        case .fresh:
            return .refused(.freshLeaf)
        case .pressed:
            return .refused(.pressedLeaf)
        case .halved:
            if giornata.left.isFilled && giornata.right.isFilled {
                return .ready
            }
            return .refused(.missingHalf)
        }
    }
}
