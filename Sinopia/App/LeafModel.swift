import Foundation
import SinopiaCore

/// Presentation seam. Screens call the fold through this type and never touch the file.
@MainActor
@Observable
final class LeafModel {
    private let store: CodexStore
    private let defaults: UserDefaults
    private(set) var codex: Codex
    var route: LeafRoute?
    var bondPath: [BondDestination] = []
    var onboardingDone: Bool
    var sketchingBlank = false
    var pressFolded = false
    var statusLine: String?
    var activeSide: SinopiaSide = .left
    private var reviewConsumed = false
    private var preferenceTick = 0

    init(store: CodexStore, defaults: UserDefaults = .standard) {
        self.store = store
        self.defaults = defaults
        self.codex = store.codex
        self.onboardingDone = defaults.bool(forKey: PreferenceKeys.onboardingComplete)
    }

    func bootstrap() async {
        await store.load()
        codex = store.codex
        await DemoSeed.installIfNeeded(store: store, defaults: defaults)
        codex = store.codex
        onboardingDone = defaults.bool(forKey: PreferenceKeys.onboardingComplete)
        rollIfNeeded()
        noteLoad()
        consumeReviewIfReady()
    }

    func finishOnboarding(left: String, right: String) {
        let leftName = left.trimmingCharacters(in: .whitespacesAndNewlines)
        let rightName = right.trimmingCharacters(in: .whitespacesAndNewlines)
        let bond = Bond(
            leftName: leftName.isEmpty ? "Left" : leftName,
            rightName: rightName.isEmpty ? "Right" : rightName,
            leftInk: codex.bond.leftInk,
            rightInk: codex.bond.rightInk,
            bondedAt: codex.bond.bondedAt == Date(timeIntervalSince1970: 0) ? Date() : codex.bond.bondedAt
        )
        store.apply(codex.replacingBond(bond), flushImmediately: true)
        codex = store.codex
        defaults.set(true, forKey: PreferenceKeys.onboardingComplete)
        if defaults.object(forKey: PreferenceKeys.hapticsEnabled) == nil {
            defaults.set(true, forKey: PreferenceKeys.hapticsEnabled)
        }
        if defaults.object(forKey: PreferenceKeys.exportFormat) == nil {
            defaults.set("png", forKey: PreferenceKeys.exportFormat)
        }
        onboardingDone = true
        consumeReviewIfReady()
    }

    func skipOnboarding() {
        finishOnboarding(left: "Left", right: "Right")
    }

    func reopenOnboarding() {
        defaults.set(false, forKey: PreferenceKeys.onboardingComplete)
        onboardingDone = false
        route = nil
        bondPath = []
    }

    var hapticsEnabled: Bool {
        if defaults.object(forKey: PreferenceKeys.hapticsEnabled) == nil { return true }
        return defaults.bool(forKey: PreferenceKeys.hapticsEnabled)
    }

    func setHaptics(_ enabled: Bool) {
        defaults.set(enabled, forKey: PreferenceKeys.hapticsEnabled)
        preferenceTick += 1
    }

    var exportFormat: String {
        defaults.string(forKey: PreferenceKeys.exportFormat) ?? "png"
    }

    func setExportFormat(_ value: String) {
        defaults.set(value, forKey: PreferenceKeys.exportFormat)
        preferenceTick += 1
    }

    var preferencesReady: Bool {
        _ = preferenceTick
        return defaults.object(forKey: PreferenceKeys.hapticsEnabled) != nil
    }

    var today: DayKey { DayKey.from(date: Date()) }

    var liveGiornata: Giornata {
        codex.giornata(for: today) ?? Giornata.fresh(daykey: today, bond: codex.bond)
    }

    var showsGesso: Bool {
        codex.isGesso && !sketchingBlank
    }

    func beginSketch() {
        sketchingBlank = true
    }

    func sketch(side: SinopiaSide, payload: Data, points: [BleedGeometry.Point], leafWidth: Double) {
        let center = leafWidth / 2
        var marks: [SpolveroMark] = []
        if BleedGeometry.crossesCenter(points: points, centerX: center) {
            let tail = BleedGeometry.tailAfterCenter(points: points, centerX: center)
            let ink = side == .left ? codex.bond.leftInk.id : codex.bond.rightInk.id
            if !tail.isEmpty {
                marks = [
                    SpolveroMark(
                        sourceSide: side,
                        tailPath: BleedGeometry.encodeTail(tail),
                        inkID: ink
                    )
                ]
            }
        }
        let result = GiornataFold.sketch(codex, daykey: today, on: side, payload: payload, marks: marks)
        apply(result)
    }

    func press() {
        let result = GiornataFold.press(codex, daykey: today, at: Date().timeIntervalSince1970)
        if case .applied = result {
            pressFolded = true
            if hapticsEnabled {
                PressHaptic.fire()
            }
            apply(result, flushImmediately: true)
            route = .pontata
        } else {
            apply(result)
        }
    }

    func undo() {
        apply(GiornataFold.undo(codex, daykey: today))
    }

    func rename(left: String, right: String) {
        let bond = Bond(
            leftName: left,
            rightName: right,
            leftInk: codex.bond.leftInk,
            rightInk: codex.bond.rightInk,
            bondedAt: codex.bond.bondedAt
        )
        store.apply(codex.replacingBond(bond))
        codex = store.codex
        statusLine = store.lastPersistError == nil ? "Saved." : store.lastPersistError
    }

    func swapInks() {
        let bond = Bond(
            leftName: codex.bond.leftName,
            rightName: codex.bond.rightName,
            leftInk: codex.bond.rightInk,
            rightInk: codex.bond.leftInk,
            bondedAt: codex.bond.bondedAt
        )
        store.apply(codex.replacingBond(bond), flushImmediately: true)
        codex = store.codex
    }

    func resetAll() async {
        await store.resetAllData()
        codex = store.codex
        sketchingBlank = false
        statusLine = store.lastPersistError
        route = nil
    }

    func openPontata() {
        route = .pontata
        bondPath = []
    }

    func openBond() {
        bondPath = []
        route = .bond
    }

    func openSettings() {
        bondPath = [.settings]
        route = .bond
    }

    func sceneInactive() async {
        await store.flush()
    }

    func reload() async {
        await store.load()
        codex = store.codex
        noteLoad()
    }

    var bondDayCount: Int {
        BondDays.count(now: Date(), bondedAt: codex.bond.bondedAt)
    }

    private func apply(_ result: FoldResult, flushImmediately: Bool = false) {
        switch result {
        case .applied(let next):
            store.apply(next, flushImmediately: flushImmediately)
            codex = store.codex
            statusLine = store.lastPersistError
        case .refused(let reason):
            statusLine = PressCopy.line(reason)
        }
    }

    private func rollIfNeeded() {
        guard codex.giornata(for: today) == nil else { return }
        let calendar = Calendar.current
        guard let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: Date())) else {
            return
        }
        let old = DayKey.from(date: yesterday, calendar: calendar)
        let next = GiornataFold.rollDay(codex, from: old, to: today)
        if next != codex {
            store.apply(next, flushImmediately: true)
            codex = store.codex
        }
    }

    private func noteLoad() {
        switch store.loadNotice {
        case .recoveredFromBackup:
            statusLine = "Restored the last good leaf."
        case .gessoFallback:
            statusLine = "The leaf file could not be read."
        case .loaded, .none:
            break
        }
    }

    private func consumeReviewIfReady() {
        guard onboardingDone, !reviewConsumed else { return }
        reviewConsumed = true
        let arguments = ProcessInfo.processInfo.arguments
        guard arguments.contains("-ReviewScreen") else { return }
        guard let key = ReviewScreenKey.parse(arguments: arguments) else { return }
        switch key {
        case .today:
            route = nil
        case .log:
            route = .pontata
        case .goals:
            bondPath = []
            route = .bond
        case .settings:
            bondPath = [.settings]
            route = .bond
        }
    }
}

enum PressCopy {
    static func line(_ refusal: FoldRefusal) -> String {
        switch refusal {
        case .freshLeaf:
            return "Sketch both halves first."
        case .missingHalf:
            return "One half is still empty."
        case .pressedLeaf:
            return "This leaf is pressed."
        case .emptyUndo:
            return "Nothing to peel."
        }
    }
}

enum PressHaptic {
    @MainActor
    static func fire() {
        #if canImport(UIKit)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        #endif
    }
}

import UIKit
