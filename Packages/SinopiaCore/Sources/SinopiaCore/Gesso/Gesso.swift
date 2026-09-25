import Foundation

/// Empty-codex marker. Diptych renders the full-page empty leaf when this is true.
public enum Gesso {
    public static func isEmpty(_ codex: Codex) -> Bool {
        codex.giornate.isEmpty
    }
}
