import SwiftUI

/// Full-page empty codex. One headline, one line, Sketch at the foot.
struct GessoEmptyLeaf: View {
    let onSketch: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Space.steps(2)) {
            Spacer(minLength: Space.steps(2))
            Image("snp_GessoLeaf")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: Space.steps(28))
                .clipped()
            Text("Blank leaf.")
                .font(TypeScale.display)
                .foregroundStyle(Palette.ink)
                .lineLimit(2)
            Text("Sketch the first half. The other person draws beside you.")
                .font(TypeScale.body)
                .foregroundStyle(Palette.muted)
                .lineSpacing(Space.unit)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: Space.steps(2))
            Button(action: onSketch) {
                Text("Sketch")
                    .frame(maxWidth: .infinity, minHeight: Space.hit)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PressButtonStyle())
        }
        .padding(Space.steps(3))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Palette.background)
    }
}
