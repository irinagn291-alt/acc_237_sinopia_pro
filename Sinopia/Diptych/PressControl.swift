import SwiftUI
import SinopiaCore

/// Verdict of the split. Enabled only when both halves hold ink.
struct PressControl: View {
    let verdict: PressVerdict
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Space.unit) {
            Button(action: action) {
                Text("Press")
                    .frame(maxWidth: .infinity, minHeight: Space.hit)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PressButtonStyle())
            .disabled(!verdict.isEnabled)
            .accessibilityHint(verdict.isEnabled ? "Locks today's leaf" : reason)

            if !verdict.isEnabled {
                Text(reason)
                    .font(TypeScale.callout)
                    .foregroundStyle(Palette.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var reason: String {
        if case .refused(let refusal) = verdict {
            return PressCopy.line(refusal)
        }
        return "Press"
    }
}
