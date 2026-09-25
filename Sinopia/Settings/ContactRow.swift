import SwiftUI

/// App Review finds the product at this address. It opens outside the app.
struct ContactRow: View {
    private let url = URL(string: "https://sinopialeaf-press.pro/contact-us")

    var body: some View {
        if let url {
            Link(destination: url) {
                HStack {
                    Text("Contact")
                        .font(TypeScale.body)
                        .foregroundStyle(Palette.ink)
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .foregroundStyle(Palette.muted)
                }
                .padding(.horizontal, Space.steps(2))
                .frame(maxWidth: .infinity, minHeight: Space.hit)
                .contentShape(Rectangle())
            }
            .plate()
            .accessibilityHint("Opens the contact page")
        }
    }
}
