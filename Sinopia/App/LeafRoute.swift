import Foundation

/// One sheet at a time. The split leaf never leaves the root.
enum LeafRoute: String, Identifiable, Equatable {
    case pontata
    case bond

    var id: String { rawValue }
}

enum BondDestination: Hashable {
    case settings
}
