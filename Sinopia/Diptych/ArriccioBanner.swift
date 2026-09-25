import SwiftUI
import SinopiaCore

/// Yesterday's one-sided leaf, carried onto today's diptych.
struct ArriccioBanner: View {
    let arriccio: Arriccio
    let name: String

    var body: some View {
        HStack(alignment: .center, spacing: Space.steps(2)) {
            Image("snp_ArriccioCarry")
                .resizable()
                .scaledToFit()
                .frame(width: Space.steps(8), height: Space.steps(8))
                .clipped()
            VStack(alignment: .leading, spacing: Space.unit) {
                Text("Carried over")
                    .font(TypeScale.headline)
                    .foregroundStyle(Palette.ink)
                Text("\(name) already sketched. The other half is still open.")
                    .font(TypeScale.callout)
                    .foregroundStyle(Palette.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(Space.steps(2))
        .plate()
        .accessibilityElement(children: .combine)
    }
}
