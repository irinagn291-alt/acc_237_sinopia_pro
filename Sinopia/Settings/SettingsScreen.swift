import SwiftUI

/// Preferences, export format, reset, contact, and a second pass at onboarding.
struct SettingsScreen: View {
    @Bindable var model: LeafModel
    @State private var confirmReset = false
    @State private var haptics = true

    var body: some View {
        Group {
            if model.preferencesReady {
                form
            } else {
                empty
            }
        }
        .voidChrome()
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { haptics = model.hapticsEnabled }
        .confirmationDialog(
            "Erase every leaf?",
            isPresented: $confirmReset,
            titleVisibility: .visible
        ) {
            Button("Erase", role: .destructive) {
                Task { await model.resetAll() }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Pressed leaves and today's ink are removed.")
        }
    }

    private var form: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Space.steps(3)) {
                if let note = model.statusLine, !note.isEmpty, note != "Saved." {
                    Text(note)
                        .font(TypeScale.callout)
                        .foregroundStyle(Palette.ink)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Toggle(isOn: $haptics) {
                    Text("Haptics")
                        .font(TypeScale.body)
                        .foregroundStyle(Palette.ink)
                }
                .tint(Palette.accent)
                .frame(minHeight: Space.hit)
                .onChange(of: haptics) { _, value in
                    model.setHaptics(value)
                }
                VStack(alignment: .leading, spacing: Space.unit) {
                    Text("Export")
                        .font(TypeScale.caption)
                        .foregroundStyle(Palette.muted)
                    Text(model.exportFormat.uppercased())
                        .font(TypeScale.body)
                        .foregroundStyle(Palette.ink)
                    Text("Pressed leaves share as a PNG.")
                        .font(TypeScale.callout)
                        .foregroundStyle(Palette.muted)
                }
                .padding(Space.steps(2))
                .frame(maxWidth: .infinity, alignment: .leading)
                .plate()
                #if targetEnvironment(simulator)
                Text("Demo leaves are loaded on Simulator.")
                    .font(TypeScale.callout)
                    .foregroundStyle(Palette.muted)
                    .fixedSize(horizontal: false, vertical: true)
                #endif
                ContactRow()
                Button {
                    model.reopenOnboarding()
                } label: {
                    Text("Show introduction")
                        .frame(maxWidth: .infinity, minHeight: Space.hit)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PressButtonStyle(prominent: false))
                Button {
                    confirmReset = true
                } label: {
                    Text("Erase every leaf")
                        .frame(maxWidth: .infinity, minHeight: Space.hit)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PressButtonStyle(prominent: false, destructive: true))
            }
            .padding(Space.steps(2))
        }
    }

    private var empty: some View {
        VStack(alignment: .leading, spacing: Space.steps(2)) {
            Spacer(minLength: Space.steps(2))
            Text("Preferences are unset.")
                .font(TypeScale.display)
                .foregroundStyle(Palette.ink)
                .lineLimit(2)
            Text("Haptics and PNG export start from here.")
                .font(TypeScale.body)
                .foregroundStyle(Palette.muted)
            Spacer(minLength: Space.steps(2))
            Button {
                model.setHaptics(true)
                model.setExportFormat("png")
                haptics = true
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
