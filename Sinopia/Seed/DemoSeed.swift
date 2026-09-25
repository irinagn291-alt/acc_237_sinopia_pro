import Foundation
import PencilKit
import SinopiaCore

/// Simulator-only demo. One versioned key. Home Press is enabled.
enum DemoSeed {
    static func codex(now: Date, calendar: Calendar = .current) -> Codex {
        let bonded = calendar.date(byAdding: .day, value: -10, to: calendar.startOfDay(for: now)) ?? now
        let bond = Bond(
            leftName: "Mara",
            rightName: "Leo",
            leftInk: .leftDefault,
            rightInk: .rightDefault,
            bondedAt: bonded
        )
        var book = Codex.gesso(bond: bond)
        let today = DayKey.from(date: now, calendar: calendar)
        for offset in 1...4 {
            guard let date = calendar.date(byAdding: .day, value: -offset, to: calendar.startOfDay(for: now)) else {
                continue
            }
            let key = DayKey.from(date: date, calendar: calendar)
            let left = Sinopia(
                side: .left,
                inkID: bond.leftInk.id,
                inkStrokes: [InkStroke(sequence: 1, payload: drawingData(side: .left, salt: offset))]
            )
            let right = Sinopia(
                side: .right,
                inkID: bond.rightInk.id,
                inkStrokes: [InkStroke(sequence: 2, payload: drawingData(side: .right, salt: offset))]
            )
            let giornata = Giornata(
                daykey: key,
                phase: .pressed,
                left: left,
                right: right,
                pressMark: PressMark(daykey: key, pressedAt: date.timeIntervalSince1970)
            )
            book = book.upsert(giornata)
        }
        let liveLeft = Sinopia(
            side: .left,
            inkID: bond.leftInk.id,
            inkStrokes: [
                InkStroke(
                    sequence: 1,
                    payload: drawingData(side: .left, salt: 0),
                    marks: [
                        SpolveroMark(
                            sourceSide: .left,
                            tailPath: BleedGeometry.encodeTail([
                                BleedGeometry.Point(x: 180, y: 80),
                                BleedGeometry.Point(x: 220, y: 120)
                            ]),
                            inkID: bond.leftInk.id
                        )
                    ]
                )
            ]
        )
        let liveRight = Sinopia(
            side: .right,
            inkID: bond.rightInk.id,
            inkStrokes: [InkStroke(sequence: 2, payload: drawingData(side: .right, salt: 0))]
        )
        let live = Giornata(
            daykey: today,
            phase: .halved,
            left: liveLeft,
            right: liveRight
        )
        return book.upsert(live)
    }

    @MainActor
    static func installIfNeeded(store: CodexStore, defaults: UserDefaults) async {
        #if targetEnvironment(simulator)
        guard defaults.bool(forKey: PreferenceKeys.demoSeed) == false else { return }
        let seeded = codex(now: Date())
        store.apply(seeded, flushImmediately: true)
        await store.flush()
        defaults.set(true, forKey: PreferenceKeys.demoSeed)
        defaults.set(true, forKey: PreferenceKeys.onboardingComplete)
        defaults.set(true, forKey: PreferenceKeys.hapticsEnabled)
        defaults.set("png", forKey: PreferenceKeys.exportFormat)
        #endif
    }

    static func drawingData(side: SinopiaSide, salt: Int) -> Data {
        let baseX: CGFloat = side == .left ? 24 : 36
        let wobble = CGFloat(salt * 14)
        let points = [
            PKStrokePoint(location: CGPoint(x: baseX, y: 40 + wobble), timeOffset: 0, size: CGSize(width: 6, height: 6), opacity: 1, force: 1, azimuth: 0, altitude: 1),
            PKStrokePoint(location: CGPoint(x: baseX + 70, y: 90 + wobble), timeOffset: 0.1, size: CGSize(width: 8, height: 8), opacity: 1, force: 1, azimuth: 0, altitude: 1),
            PKStrokePoint(location: CGPoint(x: baseX + 30, y: 150), timeOffset: 0.2, size: CGSize(width: 5, height: 5), opacity: 1, force: 1, azimuth: 0, altitude: 1)
        ]
        let path = PKStrokePath(controlPoints: points, creationDate: Date())
        let color: UIColor = side == .left ? (UIColor(named: "accent") ?? .black) : (UIColor(named: "ink") ?? .black)
        let stroke = PKStroke(ink: PKInk(.pen, color: color), path: path)
        return PKDrawing(strokes: [stroke]).dataRepresentation()
    }
}
