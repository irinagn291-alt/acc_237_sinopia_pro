import SwiftUI

/// Leaf-locked root. One sheet, never a tab bar.
@MainActor
struct ContentView: View {
    @Bindable var model: LeafModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        Group {
            if model.onboardingDone {
                NavigationStack {
                    DiptychScreen(model: model)
                }
                .sheet(item: $model.route) { route in
                    switch route {
                    case .pontata:
                        PontataSheet(model: model)
                    case .bond:
                        NavigationStack(path: $model.bondPath) {
                            BondSheet(model: model, path: $model.bondPath)
                        }
                        .presentationDetents([.large])
                        .presentationDragIndicator(.visible)
                        .presentationBackground(Palette.background)
                    }
                }
            } else {
                OnboardingFlow(model: model)
            }
        }
        .preferredColorScheme(.dark)
        .tint(Palette.accent)
        .task { await model.bootstrap() }
        .onChange(of: scenePhase) { _, phase in
            if phase == .inactive {
                Task { await model.sceneInactive() }
            }
        }
    }
}
