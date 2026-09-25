import SwiftUI
import SinopiaCore

/// One pressed giornata on the wall. The thumbnail stays inside its frame.
struct GiornataTile: View {
    let giornata: Giornata

    var body: some View {
        VStack(alignment: .leading, spacing: Space.unit) {
            thumbnail
                .frame(maxWidth: .infinity)
                .frame(height: Space.steps(18))
                .clipped()
                .background(Palette.background)
                .clipShape(RoundedRectangle(cornerRadius: Radius.chip, style: .continuous))
            Text(label)
                .font(TypeScale.counting(TypeScale.caption))
                .foregroundStyle(Palette.ink)
                .lineLimit(1)
        }
        .padding(Space.steps(2))
        .frame(maxWidth: .infinity, alignment: .leading)
        .plate()
    }

    private var thumbnail: some View {
        HStack(spacing: 0) {
            half(giornata.left)
            Rectangle()
                .fill(Palette.ink)
                .frame(width: Space.hairline)
            half(giornata.right)
        }
    }

    private func half(_ sinopia: Sinopia) -> some View {
        StrokePreview(payloads: sinopia.strokes, inkID: sinopia.inkID)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
    }

    private var label: String {
        if let date = giornata.daykey.date() {
            return DayLabel.text(date)
        }
        return CountFormat.text(Int(giornata.daykey.raw))
    }
}

/// Raster of a half. The live PencilKit surface stays on the diptych only.
struct StrokePreview: View {
    var payloads: [Data]
    var inkID: UInt8

    var body: some View {
        Image(uiImage: StrokeDrawing.raster(payloads))
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(InkSwatch.color(inkID).opacity(0.12))
            .clipped()
            .accessibilityHidden(true)
    }
}
