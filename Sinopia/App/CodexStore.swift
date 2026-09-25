import Foundation
import SinopiaCore

/// Main-actor seam. The UI reads Codex from here and never talks to CodexFile.
@MainActor
public final class CodexStore {
    public private(set) var codex: Codex
    public private(set) var loadNotice: CodexLoadOutcome?
    public private(set) var lastPersistError: String?
    private let file: CodexFile
    private var persistTask: Task<Void, Never>?

    public init(file: CodexFile, starting: Codex = .gesso()) {
        self.file = file
        self.codex = starting
    }

    public func load() async {
        let outcome = await file.load()
        loadNotice = outcome
        switch outcome {
        case .loaded(let value), .recoveredFromBackup(let value):
            codex = value
        case .gessoFallback:
            codex = .gesso()
        }
    }

    public func apply(_ next: Codex, flushImmediately: Bool = false) {
        codex = next
        if flushImmediately {
            persistTask?.cancel()
            persistTask = Task { await self.flush() }
        } else {
            schedulePersist()
        }
    }

    public func apply(_ result: FoldResult, flushImmediately: Bool = false) {
        if case .applied(let next) = result {
            apply(next, flushImmediately: flushImmediately)
        }
    }

    public func flush() async {
        persistTask?.cancel()
        persistTask = nil
        await commit()
    }

    public func resetAllData() async {
        persistTask?.cancel()
        persistTask = nil
        do {
            try await file.resetAllData()
            lastPersistError = nil
        } catch is CancellationError {
            return
        } catch {
            lastPersistError = String(describing: error)
        }
        codex = .gesso()
    }

    public func handleScenePhaseInactive() async {
        await flush()
    }

    private func schedulePersist() {
        persistTask?.cancel()
        persistTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(300))
            guard let self, !Task.isCancelled else { return }
            await self.commit()
        }
    }

    /// Writes the in-memory codex. Does not cancel the caller, so a debounced task can finish its own save.
    private func commit() async {
        do {
            try await file.save(codex)
            lastPersistError = nil
        } catch is CancellationError {
            return
        } catch {
            lastPersistError = String(describing: error)
        }
    }
}
