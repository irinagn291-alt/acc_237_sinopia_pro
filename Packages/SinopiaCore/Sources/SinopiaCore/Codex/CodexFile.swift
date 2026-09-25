import Foundation

public enum CodexLoadOutcome: Sendable, Equatable {
    case loaded(Codex)
    case recoveredFromBackup(Codex)
    case gessoFallback
}

/// Disk projection of Codex. All IO is async. The file is never the live source of truth.
public actor CodexFile {
    public nonisolated let directoryURL: URL
    public nonisolated let fileURL: URL
    public nonisolated let backupURL: URL
    public nonisolated let temporaryURL: URL

    public init(directoryURL: URL) {
        self.directoryURL = directoryURL
        self.fileURL = directoryURL.appendingPathComponent("codex.snp", isDirectory: false)
        self.backupURL = directoryURL.appendingPathComponent("codex.snp.backup", isDirectory: false)
        self.temporaryURL = directoryURL.appendingPathComponent("codex.snp.tmp", isDirectory: false)
    }

    public static func applicationSupport() throws -> CodexFile {
        let support = try FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        return CodexFile(directoryURL: support.appendingPathComponent("snp", isDirectory: true))
    }

    public func load() async -> CodexLoadOutcome {
        try? Task.checkCancellation()
        if FileManager.default.fileExists(atPath: fileURL.path) {
            if let data = try? Data(contentsOf: fileURL),
               let codex = try? CodexBinary.decodeStrict(data) {
                return .loaded(codex)
            }
            if let data = try? Data(contentsOf: backupURL),
               let codex = try? CodexBinary.decodeStrict(data) {
                return .recoveredFromBackup(codex)
            }
            return .gessoFallback
        }
        return .loaded(.gesso())
    }

    public func save(_ codex: Codex) async throws {
        try Task.checkCancellation()
        try FileManager.default.createDirectory(
            at: directoryURL,
            withIntermediateDirectories: true
        )
        if FileManager.default.fileExists(atPath: fileURL.path) {
            if FileManager.default.fileExists(atPath: backupURL.path) {
                try FileManager.default.removeItem(at: backupURL)
            }
            try FileManager.default.copyItem(at: fileURL, to: backupURL)
        }
        let data = CodexBinary.encode(codex)
        if FileManager.default.fileExists(atPath: temporaryURL.path) {
            try FileManager.default.removeItem(at: temporaryURL)
        }
        try data.write(to: temporaryURL, options: .atomic)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            _ = try FileManager.default.replaceItemAt(fileURL, withItemAt: temporaryURL)
        } else {
            try FileManager.default.moveItem(at: temporaryURL, to: fileURL)
        }
    }

    public func resetAllData() async throws {
        try Task.checkCancellation()
        let urls = [fileURL, backupURL, temporaryURL]
        for url in urls where FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
    }
}
