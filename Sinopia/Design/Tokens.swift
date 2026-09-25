import SwiftUI

/// Named colours in Assets. The branded recipe is background #FFFFFF,
/// surface #FFFFFF, ink #000000, accent #09A664, muted #6B6B6B.
/// Views reach those names through this accessor.
enum Palette {
    static let background = Color("background")
    static let surface = Color("surface")
    static let ink = Color("ink")
    static let accent = Color("accent")
    static let muted = Color("muted")
}
