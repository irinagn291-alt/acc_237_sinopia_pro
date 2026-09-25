import SwiftUI

/// One person's name on the bond sheet.
struct PersonField: View {
    let title: String
    @Binding var name: String
    @FocusState private var focused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: Space.unit) {
            Text(title)
                .font(TypeScale.caption)
                .foregroundStyle(Palette.muted)
            TextField(title, text: $name)
                .font(TypeScale.body)
                .foregroundStyle(Palette.ink)
                .textInputAutocapitalization(.words)
                .focused($focused)
                .padding(.horizontal, Space.steps(2))
                .frame(minHeight: Space.hit)
                .background(Palette.surface, in: RoundedRectangle(cornerRadius: Radius.chip, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.chip, style: .continuous)
                        .stroke(focused ? Palette.accent : Palette.muted.opacity(0.45), lineWidth: Space.hairline)
                )
        }
    }
}
