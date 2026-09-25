import SwiftUI
import UIKit

/// Optima, one family, six steps. Missing faces fall back once, here.
enum TypeScale {
    private static let boldFace = "Optima-Bold"
    private static let regularFace = "Optima-Regular"

    static let display = face(boldFace, size: 34, relativeTo: .largeTitle)
    static let title = face(boldFace, size: 22, relativeTo: .title2)
    static let headline = face(boldFace, size: 17, relativeTo: .headline)
    static let body = face(regularFace, size: 17, relativeTo: .body)
    static let callout = face(regularFace, size: 15, relativeTo: .callout)
    static let caption = face(regularFace, size: 13, relativeTo: .caption)

    private static func face(_ name: String, size: CGFloat, relativeTo style: Font.TextStyle) -> Font {
        if UIFont(name: name, size: size) != nil {
            return Font.custom(name, size: size, relativeTo: style)
        }
        return Font.system(style)
    }

    static func counting(_ step: Font) -> Font {
        step.monospacedDigit()
    }
}
