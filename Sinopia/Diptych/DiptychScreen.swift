import SwiftUI
import SinopiaCore

/// Root leaf. Sketch and Press share this frame. Pontata and Bond are sheets.
struct DiptychScreen: View {
    @Bindable var model: LeafModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: Space.steps(2)) {
                header
                if let note = fileNote {
                    VStack(alignment: .leading, spacing: Space.unit) {
                        Text(note)
                            .font(TypeScale.callout)
                            .foregroundStyle(Palette.ink)
                            .fixedSize(horizontal: false, vertical: true)
                        Button("Retry") {
                            Task { await model.reload() }
                        }
                        .buttonStyle(PressButtonStyle(prominent: false))
                    }
                }
                if model.showsGesso {
                    GessoEmptyLeaf { model.beginSketch() }
                } else {
                    leaf(in: proxy.size)
                    PressControl(verdict: PressRule.evaluate(model.liveGiornata)) {
                        model.press()
                    }
                }
            }
            .padding(.horizontal, Space.steps(3))
            .padding(.bottom, Space.steps(2))
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .top)
        }
        .voidChrome()
        .toolbar { toolbar }
        .navigationTitle("Leaf")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Space.unit) {
            Text("Sketch both halves.")
                .font(TypeScale.display)
                .foregroundStyle(Palette.ink)
                .lineLimit(4)
                .minimumScaleFactor(0.7)
                .fixedSize(horizontal: false, vertical: true)
            Text("Press when both sides hold ink.")
                .font(TypeScale.body)
                .foregroundStyle(Palette.muted)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, Space.unit)
    }

    private var fileNote: String? {
        guard let line = model.statusLine else { return nil }
        if line == "The leaf file could not be read." || line == "Restored the last good leaf." {
            return line
        }
        return nil
    }

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                model.openPontata()
            } label: {
                Image(systemName: "square.grid.2x2")
                    .foregroundStyle(Palette.ink)
                    .frame(width: Space.hit, height: Space.hit)
                    .contentShape(Rectangle())
            }
            .accessibilityLabel("Pontata")
        }
        ToolbarItem(placement: .topBarTrailing) {
            HStack(spacing: 0) {
                Button {
                    model.undo()
                } label: {
                    Image(systemName: "arrow.uturn.backward")
                        .foregroundStyle(Palette.ink)
                        .frame(width: Space.hit, height: Space.hit)
                        .contentShape(Rectangle())
                }
                .accessibilityLabel("Undo")
                Button {
                    model.openBond()
                } label: {
                    Image(systemName: "person.2")
                        .foregroundStyle(Palette.ink)
                        .frame(width: Space.hit, height: Space.hit)
                        .contentShape(Rectangle())
                }
                .accessibilityLabel("Bond")
            }
        }
    }

    private func leaf(in size: CGSize) -> some View {
        let giornata = model.liveGiornata
        let locked = giornata.phase == .pressed
        let carried = giornata.arriccio
        return VStack(alignment: .leading, spacing: Space.steps(2)) {
            if let carried {
                ArriccioBanner(
                    arriccio: carried,
                    name: carried.filledSide == .left ? model.codex.bond.leftName : model.codex.bond.rightName
                )
            }
            nameRow(giornata)
            GeometryReader { geo in
                let half = geo.size.width / 2
                ZStack(alignment: .topLeading) {
                    halfCanvas(
                        side: .left,
                        sinopia: giornata.left,
                        width: half + Space.bleed,
                        originX: 0,
                        leafWidth: geo.size.width,
                        locked: locked || carried?.filledSide == .left
                    )
                    halfCanvas(
                        side: .right,
                        sinopia: giornata.right,
                        width: half + Space.bleed,
                        originX: half - Space.bleed,
                        leafWidth: geo.size.width,
                        locked: locked || carried?.filledSide == .right
                    )
                    .offset(x: half - Space.bleed)
                    CenterRule()
                        .frame(maxHeight: .infinity)
                        .offset(x: half - Space.hairline / 2)
                    SpolveroOverlay(marks: giornata.left.spolvero + giornata.right.spolvero)
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
                .background(Palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.card, style: .continuous)
                        .stroke(Palette.muted.opacity(0.45), lineWidth: Space.hairline)
                )
                .clipShape(RoundedRectangle(cornerRadius: Radius.card, style: .continuous))
                .opacity(model.pressFolded && reduceMotion ? 0.55 : 1)
                .rotation3DEffect(
                    .degrees(model.pressFolded && !reduceMotion ? 12 : 0),
                    axis: (x: 1, y: 0, z: 0),
                    perspective: 0.4
                )
                .animation(reduceMotion ? .easeOut(duration: 0.25) : Motion.spring, value: model.pressFolded)
            }
            .frame(maxHeight: .infinity)
        }
    }

    private func nameRow(_ giornata: Giornata) -> some View {
        HStack(spacing: Space.steps(2)) {
            personChip(
                name: model.codex.bond.leftName,
                ink: giornata.left.inkID,
                side: .left,
                selected: model.activeSide == .left
            )
            Spacer(minLength: Space.unit)
            personChip(
                name: model.codex.bond.rightName,
                ink: giornata.right.inkID,
                side: .right,
                selected: model.activeSide == .right
            )
        }
    }

    private func personChip(name: String, ink: UInt8, side: SinopiaSide, selected: Bool) -> some View {
        Button {
            model.activeSide = side
        } label: {
            HStack(spacing: Space.unit) {
                Circle()
                    .fill(InkSwatch.color(ink))
                    .frame(width: Space.steps(2), height: Space.steps(2))
                    .overlay(Circle().stroke(Palette.ink, lineWidth: Space.hairline))
                Text(name)
                    .font(TypeScale.headline)
                    .foregroundStyle(Palette.ink)
                    .lineLimit(1)
            }
            .padding(.horizontal, Space.steps(2))
            .frame(minHeight: Space.hit)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Palette.surface, in: RoundedRectangle(cornerRadius: Radius.chip, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.chip, style: .continuous)
                    .stroke(selected ? Palette.accent : Palette.muted.opacity(0.45), lineWidth: Space.hairline)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(name), \(side == .left ? "left" : "right") half")
        .accessibilityAddTraits(selected ? .isSelected : [])
    }

    private func halfCanvas(
        side: SinopiaSide,
        sinopia: Sinopia,
        width: CGFloat,
        originX: CGFloat,
        leafWidth: CGFloat,
        locked: Bool
    ) -> some View {
        SinopiaCanvas(
            payloads: sinopia.strokes,
            inkID: sinopia.inkID,
            enabled: !locked,
            ownsPicker: model.activeSide == side && !locked,
            originX: originX,
            onStroke: { data, points in
                model.sketch(side: side, payload: data, points: points, leafWidth: Double(leafWidth))
            }
        )
        .frame(width: width)
        .opacity(locked && sinopia.isFilled ? 0.45 : 1)
        .accessibilityLabel(side == .left ? "Left sinopia" : "Right sinopia")
    }
}
