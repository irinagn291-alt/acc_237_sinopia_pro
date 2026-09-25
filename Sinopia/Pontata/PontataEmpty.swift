import SwiftUI

/// Full page before the first Press.
struct PontataEmpty: View {
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Space.steps(2)) {
            Spacer(minLength: Space.steps(2))
            Image("snp_PontataWall")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: Space.steps(28))
                .clipped()
            Text("No pressed leaves.")
                .font(TypeScale.display)
                .foregroundStyle(Palette.ink)
                .lineLimit(2)
            Text("Press today's leaf. It lands here, newest first.")
                .font(TypeScale.body)
                .foregroundStyle(Palette.muted)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: Space.steps(2))
            Button(action: onClose) {
                Text("Back to the leaf")
                    .frame(maxWidth: .infinity, minHeight: Space.hit)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PressButtonStyle())
        }
        .padding(Space.steps(3))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}
