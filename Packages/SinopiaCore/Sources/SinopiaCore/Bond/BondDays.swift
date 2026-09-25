import Foundation

/// Family invariant: whole days from startOfDay(bondedAt) to startOfDay(now).
public enum BondDays {
    public static let milestones: [Int] = [7, 30, 90, 365]

    public static func count(
        now: Date,
        bondedAt: Date,
        calendar: Calendar = .current
    ) -> Int {
        let start = calendar.startOfDay(for: bondedAt)
        let end = calendar.startOfDay(for: now)
        let days = calendar.dateComponents([.day], from: start, to: end).day ?? 0
        return max(0, days)
    }

    public static func reachedMilestones(days: Int) -> [Int] {
        milestones.filter { days >= $0 }
    }

    public static func nextMilestone(days: Int) -> Int? {
        milestones.first { days < $0 }
    }
}
