# Sinopia

Sinopia is a daily drawing leaf for two people who share one device. Each person sketches their half of today's split canvas. When both halves hold ink, Press locks the day as one keepsake.

It is for couples, close friends, or a parent and child who want a drawn ritual, not a typed one.

## Architecture

The codex is a pure fold over Giornate, keyed by a daykey in YYYYMMDD form. Each Giornata is exactly one phase: Fresh, Halved, or Pressed. Sketch appends PencilKit strokes and folds Fresh to Halved on the first ink. Press writes a PressMark and folds Halved to Pressed only when both sinopie hold strokes. Press on Fresh and Sketch on Pressed come back as refusals, so the view never invents those states.

That suits this product because the leaf is a single shared object with illegal moves. A list of notes would hide the seam, the lock, and the carry. The reducer stays in SinopiaCore, free of SwiftUI, and the app only presents the fold.

## Bleed-and-press

Strokes whose path crosses the center rule copy their tail into the adjacent half as a SpolveroMark, tinted in the sketcher's ink. Undo peels that stroke and its spolvero together. A giornata with one empty half at midnight stays Halved as an Arriccio and returns on the next diptych with the filled half dimmed. An empty codex is Gesso, the full-page blank leaf.

## How it differs

Pugillar, the other pair diary, is typed and blind until Seal. Sinopia is drawn, both halves stay visible, and the seam bleeds. The verb is sketch and press.

## Build

```bash
cd apps/Sinopia
xcodegen generate
xcodebuild -scheme Sinopia -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO build
```

## Art

Style: holographic iridescent illustration. Thin film on plaster, one seam, no text.

Base prompt:

Holographic iridescent illustration: thin film interference across a smooth plaster or pressed paper surface, the sheen shifting with the viewing angle so a flat plane reads as depth without any 3D render. Hand drawn illustration line under the sheen, calligraphic and slightly flared, as if a brush laid a sinopia sketch that was then sealed under a prismatic film. Technique is flat vector illustration plus a soft refractive gradient sweep and a faint diffraction banding, no photography, no lens flare, no chrome bevel, no drop shadow stack. Mood is quiet and ceremonial, two halves meeting at a single clean seam, airy negative space, one luminous focal point and nothing else competing. Use only the fixed palette tokens; no text, no letters, no numerals, no emoji, no UI chrome, no betting or casino motifs.

- snp_AppIcon: A single pressed leaf seen flat, split down the middle by one hairline seam, with two mirrored brush marks meeting and blending at the seam into a small iridescent bloom. Centered emblem filling the canvas edge to edge, flat illustration with thin film sheen, ceremonial and calm. No text, no letters, no numerals, no border, no rounded corner mask, no transparency.
- snp_Splash: Full bleed pressed plaster field with a faint vertical seam at the exact center and a slow iridescent sweep crossing it once, two soft brush traces reaching toward the seam from either side. Fills the entire canvas with no cut out subject, airy and quiet, illustration with thin film interference. No text, no glyphs, no UI elements.
- snp_Onboarding1: base prompt, a person or object that is this product in one glance. Hard cutout, solid subject, transparent corners.
- snp_Onboarding2: base prompt, the primary action mid-gesture. Hard cutout.
- snp_Onboarding3: base prompt, a later moment when the product has accumulated meaning. Hard cutout.
- snp_EmptyHome: base prompt, a solid closed bowl, crate or folded cloth waiting to be used. Hard cutout.
- snp_EmptyList: base prompt, an empty list, shelf or page. Hard cutout.
- snp_CardBackdrop: Full bleed pressed paper texture with a barely visible center seam and a wide diagonal iridescent sheen, low contrast so type can sit on it. No text.
- snp_ControlFace: base prompt, the face of a single physical control. Hard cutout.
- snp_TwistHero: base prompt, an emblem of the bleed-and-press seam. Hard cutout.
- snp_SuccessMark: base prompt, a confirmation mark. Hard cutout.
- snp_HeaderDecor: base prompt, a wide decorative band. Hard cutout.
- snp_GessoLeaf: Cutout of an empty split leaf standing upright, the two halves blank and the center seam drawn as one clean line, a single iridescent glint riding the seam. Solid opaque subject, transparent corners, no text.
- snp_PressSeal: Cutout of a small pressed seal shaped like two leaf halves folded together and clamped, edges bloomed with thin film iridescence where the halves meet. Solid opaque subject, transparent corners, no text.
- snp_ArriccioCarry: Cutout of a single leaf half with one filled brush mark and one blank half folding over to wait, the blank half dimmed and the seam catching a thin iridescent edge. Solid opaque subject, transparent corners, no text.
- snp_PontataWall: Cutout of a small stack of pressed leaves fanned into a tight wall, each leaf showing its center seam, the topmost catching an iridescent sweep. Solid opaque subject, transparent corners, no text.
- snp_BondPair: Cutout of two brush marks, distinct in weight and gesture, curving toward each other until their tails overlap into one iridescent bloom. Solid opaque subject, transparent corners, no text.
