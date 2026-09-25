import SwiftUI

/// The single hairline between the two sinopie.
struct CenterRule: View {
    var body: some View {
        Rectangle()
            .fill(Palette.ink)
            .frame(width: Space.hairline)
            .accessibilityHidden(true)
    }
}
