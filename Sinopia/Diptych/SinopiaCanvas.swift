import PencilKit
import SinopiaCore
import SwiftUI

/// One PKCanvasView for a half of the leaf, plus the bleed band at the seam.
struct SinopiaCanvas: UIViewRepresentable {
    var payloads: [Data]
    var inkID: UInt8
    var enabled: Bool
    var ownsPicker: Bool
    var originX: CGFloat
    var onStroke: (Data, [BleedGeometry.Point]) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onStroke: onStroke)
    }

    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.delegate = context.coordinator
        canvas.backgroundColor = .clear
        canvas.isOpaque = false
        canvas.drawingPolicy = .anyInput
        canvas.tool = PKInkingTool(.pen, color: InkSwatch.uiColor(inkID), width: Space.unit)
        canvas.isScrollEnabled = false
        context.coordinator.install(payloads, on: canvas)
        return canvas
    }

    func updateUIView(_ canvas: PKCanvasView, context: Context) {
        context.coordinator.onStroke = onStroke
        context.coordinator.originX = originX
        canvas.isUserInteractionEnabled = enabled
        canvas.tool = PKInkingTool(.pen, color: InkSwatch.uiColor(inkID), width: Space.unit)
        context.coordinator.sync(payloads, on: canvas)
        PickerHost.shared.attach(canvas, active: ownsPicker && enabled)
    }

    final class Coordinator: NSObject, PKCanvasViewDelegate {
        var onStroke: (Data, [BleedGeometry.Point]) -> Void
        var originX: CGFloat = 0
        private var appliedCount = 0
        private var applying = false

        init(onStroke: @escaping (Data, [BleedGeometry.Point]) -> Void) {
            self.onStroke = onStroke
        }

        func install(_ payloads: [Data], on canvas: PKCanvasView) {
            applying = true
            canvas.drawing = StrokeDrawing.compose(payloads)
            appliedCount = canvas.drawing.strokes.count
            applying = false
        }

        func sync(_ payloads: [Data], on canvas: PKCanvasView) {
            let composed = StrokeDrawing.compose(payloads)
            guard composed.strokes.count != appliedCount else { return }
            applying = true
            canvas.undoManager?.disableUndoRegistration()
            canvas.drawing = composed
            canvas.undoManager?.enableUndoRegistration()
            appliedCount = composed.strokes.count
            applying = false
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            guard !applying else { return }
            let strokes = canvasView.drawing.strokes
            guard strokes.count > appliedCount, let newest = strokes.last else {
                appliedCount = strokes.count
                return
            }
            appliedCount = strokes.count
            let data = PKDrawing(strokes: [newest]).dataRepresentation()
            onStroke(data, StrokeDrawing.sample(newest, originX: originX))
        }
    }
}

enum StrokeDrawing {
    static func compose(_ payloads: [Data]) -> PKDrawing {
        var strokes: [PKStroke] = []
        for payload in payloads {
            if let drawing = try? PKDrawing(data: payload) {
                strokes.append(contentsOf: drawing.strokes)
            }
        }
        return PKDrawing(strokes: strokes)
    }

    static func raster(_ payloads: [Data]) -> UIImage {
        let drawing = compose(payloads)
        let bounds = drawing.bounds
        let rect: CGRect
        if bounds.isNull || bounds.width < 1 || bounds.height < 1 {
            rect = CGRect(x: 0, y: 0, width: 180, height: 220)
        } else {
            rect = bounds.insetBy(dx: -12, dy: -12)
        }
        return drawing.image(from: rect, scale: 2)
    }

    static func sample(_ stroke: PKStroke, originX: CGFloat) -> [BleedGeometry.Point] {
        let path = stroke.path
        guard path.count > 0 else { return [] }
        var points: [BleedGeometry.Point] = []
        points.reserveCapacity(path.count)
        for index in 0..<path.count {
            let location = path[index].location
            points.append(
                BleedGeometry.Point(
                    x: Double(location.x + originX),
                    y: Double(location.y)
                )
            )
        }
        return points
    }
}

enum InkSwatch {
    static func color(_ id: UInt8) -> Color {
        id == InkAssignment.leftDefault.id ? Palette.accent : Palette.ink
    }

    static func uiColor(_ id: UInt8) -> UIColor {
        id == InkAssignment.leftDefault.id
            ? (UIColor(named: "accent") ?? .black)
            : (UIColor(named: "ink") ?? .black)
    }
}

@MainActor
final class PickerHost {
    static let shared = PickerHost()
    private let picker = PKToolPicker()

    func attach(_ canvas: PKCanvasView, active: Bool) {
        picker.addObserver(canvas)
        if active {
            canvas.becomeFirstResponder()
            picker.setVisible(true, forFirstResponder: canvas)
        } else {
            picker.setVisible(false, forFirstResponder: canvas)
        }
    }
}
