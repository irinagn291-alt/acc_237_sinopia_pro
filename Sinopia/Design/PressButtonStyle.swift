import SwiftUI

/// Filled, bordered primary. Accent is the live verb. Destructive is separate.
struct PressButtonStyle: ButtonStyle {
    var prominent: Bool = true
    var destructive: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        PressButtonBody(
            configuration: configuration,
            prominent: prominent,
            destructive: destructive
        )
    }
}

private struct PressButtonBody: View {
    let configuration: ButtonStyleConfiguration
    let prominent: Bool
    let destructive: Bool
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        configuration.label
            .font(TypeScale.headline)
            .foregroundStyle(foreground)
            .frame(maxWidth: .infinity, minHeight: Space.hit)
            .padding(.horizontal, Space.steps(2))
            .background(background, in: RoundedRectangle(cornerRadius: Radius.card, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.card, style: .continuous)
                    .stroke(border, lineWidth: Space.hairline)
            )
            .contentShape(RoundedRectangle(cornerRadius: Radius.card, style: .continuous))
            .opacity(configuration.isPressed ? 0.72 : 1)
    }

    private var foreground: Color {
        if !isEnabled { return Palette.muted }
        if destructive { return Palette.ink }
        return prominent ? Palette.background : Palette.ink
    }

    private var background: Color {
        if !isEnabled { return Palette.surface }
        if destructive { return Palette.surface }
        return prominent ? Palette.accent : Palette.surface
    }

    private var border: Color {
        if destructive { return Palette.ink }
        if !isEnabled { return Palette.muted }
        return prominent ? Palette.accent : Palette.ink
    }
}

extension View {
    /// Hairline plus flat fill. The only elevation language.
    func plate() -> some View {
        background(Palette.surface, in: RoundedRectangle(cornerRadius: Radius.card, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.card, style: .continuous)
                    .stroke(Palette.muted.opacity(0.45), lineWidth: Space.hairline)
            )
    }

    /// Void fill through the safe area, including the bar.
    func voidChrome() -> some View {
        background(Palette.background.ignoresSafeArea())
            .toolbarBackground(Palette.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
