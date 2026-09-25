import SwiftUI
import SinopiaCore

/// Archive wall of pressed giornate, newest first. One sheet, then a push.
struct PontataSheet: View {
    @Bindable var model: LeafModel
    @Environment(\.dismiss) private var dismiss

    private let columns = [
        GridItem(.flexible(), spacing: Space.steps(2)),
        GridItem(.flexible(), spacing: Space.steps(2))
    ]

    var body: some View {
        NavigationStack {
            Group {
                if let note = model.statusLine, note == "The leaf file could not be read.", model.codex.pressedNewestFirst.isEmpty {
                    errorPage(note)
                } else if model.codex.pressedNewestFirst.isEmpty {
                    PontataEmpty { dismiss() }
                } else {
                    wall
                }
            }
            .voidChrome()
            .navigationTitle("Leaves")
            .navigationBarTitleDisplayMode(.inline)
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
            .navigationDestination(for: DayKey.self) { key in
                if let giornata = model.codex.giornata(for: key) {
                    PressedLeafView(giornata: giornata)
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Palette.background)
    }

    private var wall: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Space.steps(2)) {
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
                Text("Pressed leaves, newest first.")
                    .font(TypeScale.body)
                    .foregroundStyle(Palette.muted)
                    .fixedSize(horizontal: false, vertical: true)
                LazyVGrid(columns: columns, spacing: Space.steps(2)) {
                    ForEach(model.codex.pressedNewestFirst) { giornata in
                        NavigationLink(value: giornata.daykey) {
                            GiornataTile(giornata: giornata)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(Space.steps(3))
        }
        .contentMargins(.bottom, Space.steps(4), for: .scrollContent)
    }

    private func errorPage(_ note: String) -> some View {
        VStack(alignment: .leading, spacing: Space.steps(2)) {
            Spacer(minLength: Space.steps(2))
            Image("snp_EmptyList")
                .resizable()
                .scaledToFit()
                .frame(height: Space.steps(24))
                .frame(maxWidth: .infinity)
                .clipped()
            Text("The wall did not load.")
                .font(TypeScale.display)
                .foregroundStyle(Palette.ink)
                .lineLimit(2)
            Text(note)
                .font(TypeScale.body)
                .foregroundStyle(Palette.muted)
            Spacer(minLength: Space.steps(2))
            Button {
                Task { await model.reload() }
            } label: {
                Text("Retry")
                    .frame(maxWidth: .infinity, minHeight: Space.hit)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PressButtonStyle())
        }
        .padding(Space.steps(3))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}
