import Foundation

/// In-memory source of truth. The file is a projection of this value.
public struct Codex: Sendable, Equatable {
    public let schemaVersion: UInt8
    public let bond: Bond
    public let giornate: [DayKey: Giornata]

    public init(schemaVersion: UInt8 = 1, bond: Bond, giornate: [DayKey: Giornata] = [:]) {
        self.schemaVersion = schemaVersion
        self.bond = bond
        self.giornate = giornate
    }

    public static func gesso(bond: Bond = .gesso()) -> Codex {
        Codex(schemaVersion: 1, bond: bond, giornate: [:])
    }

    public var isGesso: Bool {
        Gesso.isEmpty(self)
    }

    public func giornata(for daykey: DayKey) -> Giornata? {
        giornate[daykey]
    }

    public func upsert(_ giornata: Giornata) -> Codex {
        var next = giornate
        next[giornata.daykey] = giornata
        return Codex(schemaVersion: schemaVersion, bond: bond, giornate: next)
    }

    public func removing(_ daykey: DayKey) -> Codex {
        var next = giornate
        next.removeValue(forKey: daykey)
        return Codex(schemaVersion: schemaVersion, bond: bond, giornate: next)
    }

    public func replacingBond(_ bond: Bond) -> Codex {
        Codex(schemaVersion: schemaVersion, bond: bond, giornate: giornate)
    }

    public var pressedNewestFirst: [Giornata] {
        giornate.values
            .filter { $0.phase == .pressed }
            .sorted { $0.daykey > $1.daykey }
    }
}
