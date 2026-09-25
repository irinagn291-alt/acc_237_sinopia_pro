import Foundation

/// Calendar day identity in YYYYMMDD form. The fold keys every Giornata by this value.
public struct DayKey: Sendable, Hashable, Comparable, Equatable {
    public let raw: Int32

    public init(raw: Int32) {
        self.raw = raw
    }

    public static func from(date: Date, calendar: Calendar = .current) -> DayKey {
        let start = calendar.startOfDay(for: date)
        let parts = calendar.dateComponents([.year, .month, .day], from: start)
        let year = parts.year ?? 1970
        let month = parts.month ?? 1
        let day = parts.day ?? 1
        let value = year * 10_000 + month * 100 + day
        return DayKey(raw: Int32(value))
    }

    public func date(calendar: Calendar = .current) -> Date? {
        var parts = DateComponents()
        parts.year = Int(raw) / 10_000
        parts.month = (Int(raw) / 100) % 100
        parts.day = Int(raw) % 100
        return calendar.date(from: parts).map { calendar.startOfDay(for: $0) }
    }

    public func next(calendar: Calendar = .current) -> DayKey? {
        guard let start = date(calendar: calendar),
              let advanced = calendar.date(byAdding: .day, value: 1, to: start)
        else { return nil }
        return DayKey.from(date: advanced, calendar: calendar)
    }

    public static func < (lhs: DayKey, rhs: DayKey) -> Bool {
        lhs.raw < rhs.raw
    }
}
