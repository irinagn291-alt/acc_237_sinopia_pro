import SwiftUI
import UIKit

/// Three steps, then names. Skip still writes defaults.
struct OnboardingFlow: View {
    @Bindable var model: LeafModel
    @State private var page = 0
    @State private var leftName = "Left"
    @State private var rightName = "Right"

    var body: some View {
        VStack(alignment: .leading, spacing: Space.steps(2)) {
            HStack {
                Spacer()
                Button {
                    model.skipOnboarding()
                } label: {
                    Text("Skip")
                        .font(TypeScale.headline)
                        .foregroundStyle(Palette.ink)
                        .frame(minWidth: Space.hit, minHeight: Space.hit)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Skip")
            }
            ScrollView {
                Group {
                    switch page {
                    case 0:
                        pageBody(
                            image: "snp_Onboarding1",
                            title: "Two halves, one leaf.",
                            line: "Each person sketches their side. Both stay visible."
                        )
                    case 1:
                        pageBody(
                            image: "snp_Onboarding2",
                            title: "Ink can cross the seam.",
                            line: "A stroke that passes the center leaves a tint on the other half."
                        )
                    case 2:
                        pageBody(
                            image: "snp_Onboarding3",
                            title: "Press locks the day.",
                            line: "When both halves hold ink, Press writes the keepsake."
                        )
                    default:
                        names
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .scrollDismissesKeyboard(.interactively)
            .simultaneousGesture(TapGesture().onEnded {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            Button {
                if page < 3 {
                    page += 1
                } else {
                    model.finishOnboarding(left: leftName, right: rightName)
                }
            } label: {
                Text(page < 3 ? "Continue" : "Start")
                    .frame(maxWidth: .infinity, minHeight: Space.hit)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PressButtonStyle())
        }
        .padding(Space.steps(3))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Palette.background.ignoresSafeArea())
    }

    private func pageBody(image: String, title: String, line: String) -> some View {
        VStack(alignment: .leading, spacing: Space.steps(2)) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(maxHeight: Space.steps(36))
                .clipped()
            Text(title)
                .font(TypeScale.display)
                .foregroundStyle(Palette.ink)
                .lineLimit(2)
            Text(line)
                .font(TypeScale.body)
                .foregroundStyle(Palette.muted)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var names: some View {
        VStack(alignment: .leading, spacing: Space.steps(2)) {
            Image("snp_BondPair")
                .resizable()
                .scaledToFit()
                .frame(height: Space.steps(20))
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipped()
            Text("Name both people.")
                .font(TypeScale.display)
                .foregroundStyle(Palette.ink)
                .lineLimit(2)
            PersonField(title: "Left name", name: $leftName)
            PersonField(title: "Right name", name: $rightName)
        }
    }
}
