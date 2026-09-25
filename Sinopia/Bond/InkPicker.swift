import SwiftUI
import SinopiaCore

/// Distinct inks. Swap is the only move that keeps them different.
struct InkPicker: View {
    let leftInk: UInt8
    let rightInk: UInt8
    let leftName: String
    let rightName: String
    let swap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Space.steps(2)) {
            HStack(spacing: Space.steps(2)) {
                swatch(name: leftName, ink: leftInk)
                swatch(name: rightName, ink: rightInk)
            }
            Button(action: swap) {
                Text("Swap inks")
                    .frame(maxWidth: .infinity, minHeight: Space.hit)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PressButtonStyle(prominent: false))
            if leftInk == rightInk {
                Text("Inks must differ. Swap again.")
                    .font(TypeScale.callout)
                    .foregroundStyle(Palette.ink)
            }
        }
    }

    private func swatch(name: String, ink: UInt8) -> some View {
        HStack(spacing: Space.unit) {
            RoundedRectangle(cornerRadius: Radius.chip, style: .continuous)
                .fill(InkSwatch.color(ink))
                .frame(width: Space.steps(4), height: Space.steps(4))
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.chip, style: .continuous)
                        .stroke(Palette.ink, lineWidth: Space.hairline)
                )
            Text(name)
                .font(TypeScale.body)
                .foregroundStyle(Palette.ink)
                .lineLimit(1)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, minHeight: Space.hit, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(name) ink")
    }
}
