import SwiftUI
import SinopiaCore
import UIKit

/// Read-only pressed leaf, pushed inside the Pontata sheet.
struct PressedLeafView: View {
    let giornata: Giornata
    @State private var shareURL: URL?

    var body: some View {
        VStack(alignment: .leading, spacing: Space.steps(2)) {
            Text(title)
                .font(TypeScale.title)
                .foregroundStyle(Palette.ink)
                .lineLimit(4)
                .minimumScaleFactor(0.7)
                .fixedSize(horizontal: false, vertical: true)
            HStack(spacing: 0) {
                StrokePreview(payloads: giornata.left.strokes, inkID: giornata.left.inkID)
                Rectangle().fill(Palette.ink).frame(width: Space.hairline)
                StrokePreview(payloads: giornata.right.strokes, inkID: giornata.right.inkID)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: Radius.card, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.card, style: .continuous)
                    .stroke(Palette.muted.opacity(0.45), lineWidth: Space.hairline)
            )
            if let shareURL {
                ShareLink(item: shareURL) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity, minHeight: Space.hit)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PressButtonStyle(prominent: false))
            } else {
                Button {} label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity, minHeight: Space.hit)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PressButtonStyle(prominent: false))
                .disabled(true)
                .accessibilityLabel("Share")
            }
        }
        .padding(Space.steps(2))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .voidChrome()
        .navigationTitle("Pressed")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            shareURL = PressedExport.png(giornata)
        }
    }

    private var title: String {
        if let date = giornata.daykey.date() {
            return DayLabel.text(date)
        }
        return "Pressed leaf"
    }
}

enum PressedExport {
    static func png(_ giornata: Giornata) -> URL? {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 600, height: 400))
        let image = renderer.image { ctx in
            UIColor.white.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: 600, height: 400))
            let left = StrokeDrawing.compose(giornata.left.strokes).image(from: CGRect(x: 0, y: 0, width: 300, height: 400), scale: 1)
            let right = StrokeDrawing.compose(giornata.right.strokes).image(from: CGRect(x: 0, y: 0, width: 300, height: 400), scale: 1)
            left.draw(in: CGRect(x: 0, y: 0, width: 300, height: 400))
            right.draw(in: CGRect(x: 300, y: 0, width: 300, height: 400))
        }
        guard let data = image.pngData() else { return nil }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("giornata-\(giornata.daykey.raw).png")
        do {
            try data.write(to: url, options: .atomic)
            return url
        } catch {
            return nil
        }
    }
}
