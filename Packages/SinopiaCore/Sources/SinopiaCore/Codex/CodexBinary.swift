import Foundation

public enum CodexReadFailure: Error, Sendable, Equatable {
    case truncated
    case badMagic
    case unknownVersion
    case unexpectedValue
}

/// Little-endian SNPC codec. Unknown version or a short tail become Gesso.
public enum CodexBinary {
    public static let magic = Data([0x53, 0x4E, 0x50, 0x43]) // SNPC
    public static let currentVersion: UInt8 = 1

    public static func encode(_ codex: Codex) -> Data {
        var out = Data()
        out.append(magic)
        out.append(codex.schemaVersion)
        writeBond(&out, codex.bond)
        let ordered = codex.giornate.values.sorted { $0.daykey < $1.daykey }
        writeUInt32(&out, UInt32(ordered.count))
        for giornata in ordered {
            writeGiornata(&out, giornata)
        }
        return out
    }

    /// Recoverable decode. Failures map to Gesso so a corrupt tail never crashes.
    public static func decode(_ data: Data) -> Codex {
        do {
            return try decodeStrict(data)
        } catch {
            return .gesso()
        }
    }

    public static func decodeStrict(_ data: Data) throws -> Codex {
        var cursor = ByteCursor(data)
        let header = try cursor.readExact(4)
        guard header == magic else { throw CodexReadFailure.badMagic }
        let version = try cursor.readUInt8()
        guard version == currentVersion else { throw CodexReadFailure.unknownVersion }
        let bond = try readBond(&cursor)
        let count = try cursor.readUInt32()
        var map: [DayKey: Giornata] = [:]
        for _ in 0..<count {
            let giornata = try readGiornata(&cursor)
            map[giornata.daykey] = giornata
        }
        return Codex(schemaVersion: version, bond: bond, giornate: map)
    }

    private static func writeBond(_ out: inout Data, _ bond: Bond) {
        writeUTF8(&out, bond.leftName)
        writeUTF8(&out, bond.rightName)
        out.append(bond.leftInk.id)
        out.append(bond.rightInk.id)
        writeDouble(&out, bond.bondedAt.timeIntervalSince1970)
    }

    private static func readBond(_ cursor: inout ByteCursor) throws -> Bond {
        let leftName = try cursor.readUTF8()
        let rightName = try cursor.readUTF8()
        let leftInk = try cursor.readUInt8()
        let rightInk = try cursor.readUInt8()
        let bondedAt = Date(timeIntervalSince1970: try cursor.readDouble())
        return Bond(
            leftName: leftName,
            rightName: rightName,
            leftInk: InkAssignment(id: leftInk),
            rightInk: InkAssignment(id: rightInk),
            bondedAt: bondedAt
        )
    }

    private static func writeGiornata(_ out: inout Data, _ giornata: Giornata) {
        writeInt32(&out, giornata.daykey.raw)
        out.append(giornata.phase.rawValue)
        writeDouble(&out, giornata.pressMark?.pressedAt ?? 0)
        writeSinopia(&out, giornata.left)
        writeSinopia(&out, giornata.right)
        if let arriccio = giornata.arriccio {
            out.append(1)
            writeInt32(&out, arriccio.carriedFrom.raw)
            out.append(arriccio.filledSide.rawValue)
        } else {
            out.append(0)
        }
    }

    private static func readGiornata(_ cursor: inout ByteCursor) throws -> Giornata {
        let daykey = DayKey(raw: try cursor.readInt32())
        guard let phase = GiornataPhase(rawValue: try cursor.readUInt8()) else {
            throw CodexReadFailure.unexpectedValue
        }
        let pressedAt = try cursor.readDouble()
        let left = try readSinopia(&cursor)
        let right = try readSinopia(&cursor)
        let hasArriccio = try cursor.readUInt8()
        var arriccio: Arriccio?
        if hasArriccio != 0 {
            let from = DayKey(raw: try cursor.readInt32())
            guard let side = SinopiaSide(rawValue: try cursor.readUInt8()) else {
                throw CodexReadFailure.unexpectedValue
            }
            arriccio = Arriccio(carriedFrom: from, filledSide: side)
        }
        let mark: PressMark? = phase == .pressed
            ? PressMark(daykey: daykey, pressedAt: pressedAt)
            : nil
        return Giornata(
            daykey: daykey,
            phase: phase,
            left: left,
            right: right,
            pressMark: mark,
            arriccio: arriccio
        )
    }

    private static func writeSinopia(_ out: inout Data, _ half: Sinopia) {
        out.append(half.side.rawValue)
        out.append(half.inkID)
        writeLengthPrefixed(&out, StrokePack.encode(half.inkStrokes))
        writeUInt32(&out, UInt32(half.spolvero.count))
        for mark in half.spolvero {
            out.append(mark.sourceSide.rawValue)
            out.append(mark.inkID)
            writeLengthPrefixed(&out, mark.tailPath)
        }
    }

    private static func readSinopia(_ cursor: inout ByteCursor) throws -> Sinopia {
        guard let side = SinopiaSide(rawValue: try cursor.readUInt8()) else {
            throw CodexReadFailure.unexpectedValue
        }
        let ink = try cursor.readUInt8()
        let blob = try cursor.readLengthPrefixed()
        let markCount = try cursor.readUInt32()
        var marks: [SpolveroMark] = []
        for _ in 0..<markCount {
            guard let source = SinopiaSide(rawValue: try cursor.readUInt8()) else {
                throw CodexReadFailure.unexpectedValue
            }
            let inkID = try cursor.readUInt8()
            let tail = try cursor.readLengthPrefixed()
            marks.append(SpolveroMark(sourceSide: source, tailPath: tail, inkID: inkID))
        }
        var strokes = StrokePack.decode(blob)
        if strokes.isEmpty, !blob.isEmpty {
            strokes = [InkStroke(sequence: 1, payload: blob, marks: marks)]
        } else if let lastIndex = strokes.indices.last, !marks.isEmpty {
            let last = strokes[lastIndex]
            strokes[lastIndex] = InkStroke(
                id: last.id,
                sequence: last.sequence,
                payload: last.payload,
                marks: last.marks.isEmpty ? marks : last.marks
            )
        }
        return Sinopia(side: side, inkID: ink, inkStrokes: strokes)
    }

    private static func writeUTF8(_ out: inout Data, _ text: String) {
        writeLengthPrefixed(&out, Data(text.utf8))
    }

    private static func writeLengthPrefixed(_ out: inout Data, _ blob: Data) {
        writeUInt32(&out, UInt32(blob.count))
        out.append(blob)
    }

    private static func writeInt32(_ out: inout Data, _ value: Int32) {
        var little = value.littleEndian
        out.append(contentsOf: withUnsafeBytes(of: &little) { Array($0) })
    }

    private static func writeUInt32(_ out: inout Data, _ value: UInt32) {
        var little = value.littleEndian
        out.append(contentsOf: withUnsafeBytes(of: &little) { Array($0) })
    }

    private static func writeUInt64(_ out: inout Data, _ value: UInt64) {
        var little = value.littleEndian
        out.append(contentsOf: withUnsafeBytes(of: &little) { Array($0) })
    }

    private static func writeDouble(_ out: inout Data, _ value: Double) {
        writeUInt64(&out, value.bitPattern)
    }
}

enum StrokePack {
    static func encode(_ strokes: [InkStroke]) -> Data {
        var data = Data()
        var count = UInt32(strokes.count).littleEndian
        data.append(contentsOf: withUnsafeBytes(of: &count) { Array($0) })
        for stroke in strokes {
            var sequence = stroke.sequence.littleEndian
            data.append(contentsOf: withUnsafeBytes(of: &sequence) { Array($0) })
            let idBytes = Data(stroke.id.uuidString.utf8)
            var idLen = UInt32(idBytes.count).littleEndian
            data.append(contentsOf: withUnsafeBytes(of: &idLen) { Array($0) })
            data.append(idBytes)
            var payloadLen = UInt32(stroke.payload.count).littleEndian
            data.append(contentsOf: withUnsafeBytes(of: &payloadLen) { Array($0) })
            data.append(stroke.payload)
            var markCount = UInt32(stroke.marks.count).littleEndian
            data.append(contentsOf: withUnsafeBytes(of: &markCount) { Array($0) })
            for mark in stroke.marks {
                let side = mark.sourceSide.rawValue
                data.append(side)
                data.append(mark.inkID)
                var tailLen = UInt32(mark.tailPath.count).littleEndian
                data.append(contentsOf: withUnsafeBytes(of: &tailLen) { Array($0) })
                data.append(mark.tailPath)
            }
        }
        return data
    }

    static func decode(_ data: Data) -> [InkStroke] {
        var cursor = ByteCursor(data)
        guard let count = try? cursor.readUInt32() else { return [] }
        var strokes: [InkStroke] = []
        for _ in 0..<count {
            guard let sequence = try? cursor.readUInt64(),
                  let idText = try? cursor.readUTF8(),
                  let payload = try? cursor.readLengthPrefixed(),
                  let markCount = try? cursor.readUInt32()
            else { return strokes }
            var marks: [SpolveroMark] = []
            for _ in 0..<markCount {
                guard let sideRaw = try? cursor.readUInt8(),
                      let side = SinopiaSide(rawValue: sideRaw),
                      let ink = try? cursor.readUInt8(),
                      let tail = try? cursor.readLengthPrefixed()
                else { return strokes }
                marks.append(SpolveroMark(sourceSide: side, tailPath: tail, inkID: ink))
            }
            let id = UUID(uuidString: idText) ?? UUID()
            strokes.append(InkStroke(id: id, sequence: sequence, payload: payload, marks: marks))
        }
        return strokes
    }
}
