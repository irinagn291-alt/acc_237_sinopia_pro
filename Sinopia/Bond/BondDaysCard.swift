import SwiftUI

/// Bond day count. Milestones 7, 30, 90, 365.
struct BondDaysCard: View {
    let days: Int
    let reached: [Int]
    let next: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: Space.steps(2)) {
            Text(CountFormat.text(days))
                .font(TypeScale.counting(TypeScale.display))
                .foregroundStyle(Palette.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .frame(minWidth: Space.steps(12), alignment: .leading)
            Text(days == 1 ? "day bonded" : "days bonded")
                .font(TypeScale.body)
                .foregroundStyle(Palette.ink)
            Text(milestoneLine)
                .font(TypeScale.callout)
                .foregroundStyle(Palette.muted)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Space.steps(2))
        .frame(maxWidth: .infinity, alignment: .leading)
        .plate()
    }

    private var milestoneLine: String {
        if reached.isEmpty {
            if let next {
                return "Next mark at \(CountFormat.text(next)) days."
            }
            return "No mark yet."
        }
        let listed = reached.map { CountFormat.text($0) }.joined(separator: ", ")
        if let next {
            return "Marks \(listed). Next \(CountFormat.text(next))."
        }
        return "Marks \(listed)."
    }
}
