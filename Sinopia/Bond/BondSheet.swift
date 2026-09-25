import SwiftUI
import SinopiaCore
import UIKit

/// Names, inks, bond days. Settings pushes from here.
struct BondSheet: View {
    @Bindable var model: LeafModel
    @Binding var path: [BondDestination]
    @Environment(\.dismiss) private var dismiss
    @State private var leftName = ""
    @State private var rightName = ""

    var body: some View {
        Group {
            if model.codex.bond.leftName.trimmingCharacters(in: .whitespaces).isEmpty
                && model.codex.bond.rightName.trimmingCharacters(in: .whitespaces).isEmpty {
                empty
            } else {
                form
            }
        }
        .voidChrome()
        .navigationTitle("People")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: BondDestination.self) { destination in
            if destination == .settings {
                SettingsScreen(model: model)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Palette.ink)
                        .frame(width: Space.hit, height: Space.hit)
                        .contentShape(Rectangle())
                }
                .accessibilityLabel("Close")
            }
        }
        .onAppear {
            leftName = model.codex.bond.leftName
            rightName = model.codex.bond.rightName
        }
    }

    private var form: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Space.steps(3)) {
                Text("Who draws each half.")
                    .font(TypeScale.body)
                    .foregroundStyle(Palette.muted)
                    .fixedSize(horizontal: false, vertical: true)
                if let note = model.statusLine, note == "The leaf file could not be read." {
                    Text(note)
                        .font(TypeScale.callout)
                        .foregroundStyle(Palette.ink)
                        .fixedSize(horizontal: false, vertical: true)
                    Button("Retry") {
                        Task { await model.reload() }
                    }
                    .buttonStyle(PressButtonStyle(prominent: false))
                }
                Image("snp_BondPair")
                    .resizable()
                    .scaledToFit()
                    .frame(height: Space.steps(16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .clipped()
                PersonField(title: "Left name", name: $leftName)
                PersonField(title: "Right name", name: $rightName)
                if leftName.trimmingCharacters(in: .whitespaces).isEmpty
                    || rightName.trimmingCharacters(in: .whitespaces).isEmpty {
                    Text("Name both people.")
                        .font(TypeScale.callout)
                        .foregroundStyle(Palette.ink)
                }
                Button {
                    model.rename(left: leftName, right: rightName)
                } label: {
                    Text("Save")
                        .frame(maxWidth: .infinity, minHeight: Space.hit)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PressButtonStyle())
                InkPicker(
                    leftInk: model.codex.bond.leftInk.id,
                    rightInk: model.codex.bond.rightInk.id,
                    leftName: model.codex.bond.leftName,
                    rightName: model.codex.bond.rightName,
                    swap: { model.swapInks() }
                )
                BondDaysCard(
                    days: model.bondDayCount,
                    reached: BondDays.reachedMilestones(days: model.bondDayCount),
                    next: BondDays.nextMilestone(days: model.bondDayCount)
                )
                Button {
                    path.append(.settings)
                } label: {
                    HStack {
                        Text("Settings")
                            .font(TypeScale.body)
                            .foregroundStyle(Palette.ink)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Palette.muted)
                    }
                    .padding(.horizontal, Space.steps(2))
                    .frame(maxWidth: .infinity, minHeight: Space.hit)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .plate()
            }
            .padding(Space.steps(3))
        }
        .scrollDismissesKeyboard(.interactively)
        .simultaneousGesture(TapGesture().onEnded {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        })
    }

    private var empty: some View {
        VStack(alignment: .leading, spacing: Space.steps(2)) {
            Spacer(minLength: Space.steps(2))
            Image("snp_BondPair")
                .resizable()
                .scaledToFit()
                .frame(height: Space.steps(24))
                .frame(maxWidth: .infinity)
                .clipped()
            Text("Name the pair.")
                .font(TypeScale.display)
                .foregroundStyle(Palette.ink)
                .lineLimit(2)
            Text("Each person keeps one half and one ink.")
                .font(TypeScale.body)
                .foregroundStyle(Palette.muted)
            PersonField(title: "Left name", name: $leftName)
            PersonField(title: "Right name", name: $rightName)
            Spacer(minLength: Space.steps(2))
            Button {
                model.rename(left: leftName, right: rightName)
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity, minHeight: Space.hit)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PressButtonStyle())
        }
        .padding(Space.steps(3))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}
