import SwiftUI

/// One spring, used only for the Press commit. Everything else eases out.
enum Motion {
    static let spring = Animation.spring(response: 0.4, dampingFraction: 0.8)
    static let ease = Animation.easeOut(duration: 0.25)

    static func commit(reduceMotion: Bool) -> Animation {
        reduceMotion ? ease : spring
    }
}
