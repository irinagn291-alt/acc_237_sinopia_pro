# Sinopia — Build Specification

> Portfolio app 132, batch pending. This document is the complete brief for
> building this application. Read all of it before writing any code. Anything
> not specified here is your decision, but must stay consistent with section 3.

**One-line positioning:** Draw your half of a shared daily sketch and press it into a keepsake.

| Field | Value |
| --- | --- |
| Product name | Sinopia |
| Bundle identifier | `com.sinopialeaf.press` |
| Domain | https://sinopialeaf-press.pro |
| Contact URL | https://sinopialeaf-press.pro/contact-us |
| Deployment target | iOS 17.0 |
| Swift version | 6.2, strict concurrency `complete` |
| Devices | iPhone and iPad, portrait |
| Interface style | Light |
| Asset prefix | `snp_` |
| User-Agent | `Sinopia/1.0 (iOS; +https://sinopialeaf-press.pro)` |

---

## 1. Non-negotiable constraints

1. **No CocoaPods.** Dependencies come from Swift Package Manager, a local
   in-repo package, a vendored source folder, or nothing at all — per section 3.
2. **No shared code with other portfolio apps.** Business rules are re-implemented
   here under this app's own type names.
3. **All code, identifiers, comments, UI copy and the README are in English.**
4. **No launch gate, no WebView shell, no remote configuration, no analytics.**
   Guideline 4.2 (Minimum Functionality): this is a native SwiftUI product, not
   a web browsing experience. WKWebView / SFSafariViewController as UI is a
   reject. Push notifications, Core Location, and sharing do not make a
   browser or a thin catalog into an App Store app.
5. **Guideline 5.1.1 (Privacy):** never direct the user to grant camera access.
   A pre-permission screen may exist; the proceed button is **Continue** or
   **Next**, never "Allow camera", "Enable camera", "Grant camera", or a bare
   Allow/Enable that triggers `requestAccess`. The system alert is the only Allow.
6. **No CI files.** No `bitrise.yml`, no `Scripts/`, no `metadata/` folder.
7. **Assets are AI-generated.** No stock photography. SF Symbols may support
   small affordances but must never be the primary iconography.
8. **The app must build clean** with
   `xcodegen generate && xcodebuild -scheme Sinopia -destination 'generic/platform=iOS' build`.
9. **Nothing may echo another app in this batch** in naming, layout or visuals.
10. **This is not a calorie meal-slot tracker** unless family is `food_tracker`.
   Do not invent food logging to fill the brief.

---

## 2. Product core

The product is offline-first. No account, no sign-in, no ads, no in-app purchase,
no analytics SDK, no remote config. All user data stays on the device.

A partner sketches on their half of today's split leaf so the pressed giornata holds both drawings as one keepsake.

### 2.1 User flow

1. Open to the Diptych: the split leaf shows two empty sinopie, each labeled with a person's name and ink color set in Bond.
2. Person A taps their sinopia and sketches freely with PencilKit; strokes near the center rule bleed tint into the adjacent half as spolvero.
3. Hand the device to Person B, who taps the opposite sinopia and draws their side; both halves are always visible, never blind.
4. Tap Press when both sinopie hold strokes: the giornata locks, writes a PressMark, and slides into the Pontata.
5. Browse the Pontata to scroll all past pressed giornate as a tile wall; tap any tile to open the full canvas read-only.
6. Open Bond to rename persons, swap ink colors, or share a pressed giornata as a PNG.

### 2.2 Essential behaviour

- PencilKit split canvas: two side-by-side PKCanvasView representables share one leaf, each constrained to its half plus a narrow bleed zone at the center sinopia rule.
- Spolvero bleed: strokes whose bezier path crosses the center sinopia rule copy their tail segment into the adjacent half, tinted in the sketcher's assigned ink color, creating a visible shared border.
- Press action: locks the giornata when both sinopie hold strokes, writes a PressMark keyed by daykey, and prevents further edits; Press is refused when either sinopia is empty.
- Arriccio carry-forward: a giornata with only one filled sinopia at midnight stays as an Arriccio and reappears on the next day's Diptych with the filled half dimmed.
- Pontata archive wall: a scrollable tile grid of all pressed giornate ordered newest-first; each tile renders a combined thumbnail of both sinopie.
- Bond profile: names both persons, assigns distinct ink colors mapped to PKInkingTool, and exports any pressed giornata as a shared PNG image.

---

## 3. Uniqueness assignment for Sinopia

| Axis | Assigned value |
| --- | --- |
| Architecture | **Split-canvas giornata fold (Fresh | Halved | Pressed); the codex is a fold over Giornate keyed by daykey; Sketch writes PencilKit strokes on the tapped Sinopia and folds Fresh to Halved when the first Sinopia receives strokes; Press writes a PressMark when both Sinopie hold strokes and folds Halved to Pressed; Press on Fresh is refused; Sketch on a Pressed Giornata is refused; strokes that cross the center rule bleed tint into the adjacent Sinopia as spolvero; a Giornata with one empty Sinopia at midnight stays Halved as an Arriccio; empty codex writes Gesso** |
| UI approach | **SwiftUI + PencilKit representable · realitykit-lite** |
| Naming convention | **Fresco / giornata lexicon** |
| File organization | **By giornata role (Giornata, Sinopia, PressMark, Arriccio, SpolveroMark, Gesso)** |
| Dependency strategy | **Local SPM package in repo** |
| Design direction | **shopify · split-compare · branded** |
| Typography | **Optima** |
| Navigation pattern | **Leaf-locked chrome (the split canvas never leaves; Pontata and Bond arrive as sheets; sketch and press fuse on Diptych)** |
| AI art style | **Holographic iridescent · illustration** |
| Functional twist | **Bleed-and-press (strokes that cross the center sinopia copy their tail as spolvero into the adjacent half; Press locks when both sinopie hold strokes; a one-sided midnight giornata carries as Arriccio)** |
| Persistence | **binary format** |
| Screen composition | see 3.6 |

### 3.0 Product concept

This is the product the contracts below are assigned to. Do not substitute another.

**Family** — pair_diary

**Core** — A partner sketches on their half of today's split leaf so the pressed giornata holds both drawings as one keepsake.

**Audience** — Couples, close friends, or parent-child pairs who share a device and want a daily visual ritual that is drawn, not typed.

**User flow**

1. Open to the Diptych: the split leaf shows two empty sinopie, each labeled with a person's name and ink color set in Bond.
2. Person A taps their sinopia and sketches freely with PencilKit; strokes near the center rule bleed tint into the adjacent half as spolvero.
3. Hand the device to Person B, who taps the opposite sinopia and draws their side; both halves are always visible, never blind.
4. Tap Press when both sinopie hold strokes: the giornata locks, writes a PressMark, and slides into the Pontata.
5. Browse the Pontata to scroll all past pressed giornate as a tile wall; tap any tile to open the full canvas read-only.
6. Open Bond to rename persons, swap ink colors, or share a pressed giornata as a PNG.

**Essential features**

- PencilKit split canvas: two side-by-side PKCanvasView representables share one leaf, each constrained to its half plus a narrow bleed zone at the center sinopia rule.
- Spolvero bleed: strokes whose bezier path crosses the center sinopia rule copy their tail segment into the adjacent half, tinted in the sketcher's assigned ink color, creating a visible shared border.
- Press action: locks the giornata when both sinopie hold strokes, writes a PressMark keyed by daykey, and prevents further edits; Press is refused when either sinopia is empty.
- Arriccio carry-forward: a giornata with only one filled sinopia at midnight stays as an Arriccio and reappears on the next day's Diptych with the filled half dimmed.
- Pontata archive wall: a scrollable tile grid of all pressed giornate ordered newest-first; each tile renders a combined thumbnail of both sinopie.
- Bond profile: names both persons, assigns distinct ink colors mapped to PKInkingTool, and exports any pressed giornata as a shared PNG image.

**Twist** — Bleed-and-press. Home is the split leaf. Each sinopia belongs to one person set in Bond. Sketch writes PencilKit strokes on the tapped sinopia. Strokes whose path crosses the center rule copy their tail into the adjacent sinopia as spolvero, tinted in the sketcher's ink. Press locks the giornata when both sinopie hold strokes and writes a PressMark keyed by daykey. A giornata with only one filled sinopia at midnight stays as an Arriccio and carries forward to the next Diptych. Undo peels the newest stroke including its spolvero. Pontata shows all pressed giornate as a scrollable tile wall. Bond names both persons and assigns ink colors. A leaf with no strokes writes Gesso.

**Why this is not a repeat** — The only existing pair_diary is Pugillar: a text diary with blind-seam encoding where each plate is typed unseen and Seal reveals both. Sinopia replaces text with PencilKit drawing, makes both halves always visible (never blind), and introduces a spolvero bleed mechanic at the center rule that physically merges strokes across the boundary. The verb is sketch-and-press, not type-and-seal. The Arriccio carry-forward (unfinished half persists to the next day) has no analogue in Pugillar's dead-leaf model. The fresco/giornata lexicon is entirely new. No architecture, naming, organization, navigation, or twist axis overlaps Pugillar.

### 3.0a Craft from the shipped portfolio

Full craft is in KNOWLEDGE.md. Follow it. Do not copy type names or layouts.
- Home: Diptych: two columns, one seam.
- Invariant: Bond days = startOfDay(now) − startOfDay(bondedAt). Milestones 7/30/90/365. Two-halves: A answers before B unlocks.
- Never: No public feed.
- Taste DNA is section 7.6. Do not invent a second look.
- A TabView with exactly three tabs is the factory stamp — use two or four-to-five destinations, or a different chrome. `-ReviewScreen today|log|goals` are launch keys, not tabs.

### 3.1 Architecture contract

SinopiaCore holds a pure fold over Giornate keyed by a daykey Int in YYYYMMDD form, and every Giornata sits in exactly one phase: Fresh, Halved, or Pressed. Sketch appends PencilKit strokes to the tapped Sinopia and folds Fresh to Halved the moment the first Sinopia receives ink; Press writes a PressMark and folds Halved to Pressed only when both Sinopie hold strokes. Press on a Fresh Giornata is refused and Sketch on a Pressed Giornata is refused, so the two illegal moves are return values the reducer reports rather than states the view can reach. Strokes whose bezier path crosses the center rule emit a SpolveroMark that copies the crossing tail into the adjacent Sinopia tinted in the sketcher's ink, and Undo peels the newest stroke together with its SpolveroMark as one step. A Giornata that still has one empty Sinopia when the daykey rolls stays Halved as an Arriccio and is carried onto the next Diptych with the filled half dimmed and read only. An empty codex writes Gesso, the single full page empty state the Diptych renders before any ink exists.

Put a short comment block at the top of each principal type stating the role it
plays in this architecture. The README must justify the pattern for this product.

### 3.2 UI contract

SwiftUI throughout, with one UIViewRepresentable around PKCanvasView used twice inside a single leaf: left Sinopia and right Sinopia share one GeometryReader frame, each clipped to its half plus a narrow bleed band at the center rule so a crossing stroke can be read before it is copied. The tapped Sinopia takes the tool picker; the other stays live and visible, never masked, because both halves are always in view. Depth is realitykit-lite and framework free: the leaf reads as a physical sheet through one layered shadow, a hairline center rule, and a small rotation3DEffect plus spring on the Press commit, all gated by accessibilityReduceMotion which drops to a fade. Density is airy with void surfaces, sparse chrome, and one jewel, the Press control at the foot of the leaf. Split-compare governs the frame: two panes and a verdict, where the verdict is Press, enabled or refused with a reason line. Native Button, Toggle, and TextField only; chrome lives inside the Button label with contentShape and a 44pt minimum, and every icon only control carries a VoiceOver label.

### 3.3 Naming contract

Convention: Fresco / giornata lexicon.

Examples to follow: ['GiornataFold.sketch(on: .left, strokes:) -> FoldResult, and GiornataFold.press(daykey:) which returns .refused(.freshLeaf) when no Sinopia holds ink', 'Sinopia with side, inkID, strokeData, and isFilled; SpolveroMark with sourceSide, tailPath, and inkID', 'PressMark(daykey:pressedAt:) and Arriccio(carriedFrom:filledSide:) as the two records that close or carry a day', 'Gesso as the empty codex marker, CodexBinary as the byte reader and writer, Pontata as the archive wall']

### 3.4 Dependency contract

Zero remote dependencies and no CocoaPods. One local Swift package lives in the repo at Packages/SinopiaCore and is added to the project as a path based dependency, so the fold, the byte codec, the daykey math, and the Bond day arithmetic compile and test without the app target. SinopiaCore imports Foundation and PencilKit only for stroke data round tripping; it imports no SwiftUI and no UIKit, which is what keeps the reducer unit testable. The app target links SwiftUI, PencilKit, and SinopiaCore. Nothing is fetched at build time and there is no network layer, so the product runs fully on device.

### 3.5 Navigation contract

Leaf-locked chrome, no TabView anywhere. Diptych is the root and never leaves the screen: sketch and press fuse there, so the split canvas is both the reading surface and the commit surface. One LeafRoute enum drives a single sheet presentation; the Diptych toolbar carries two icon buttons with VoiceOver labels, Pontata on the leading side and Bond on the trailing side. Pontata arrives as a sheet with the tile wall and dismisses back to the same leaf, scroll position and ink intact. Bond arrives as a sheet wrapped in its own NavigationStack; Settings is a row inside Bond and pushes there, which keeps four destinations without a tab bar. Sheets use large detents, fill the safe area, and never stack more than one deep. ProcessInfo.processInfo.arguments is read once after onboarding is marked complete, and -ReviewScreen today opens the Diptych, log opens the Pontata sheet, goals opens the Bond sheet, and settings pushes Settings inside Bond, four different frames.

### 3.6 Screen composition contract

Four screens. Diptych is the split leaf with two PencilKit sinopie, a center rule, and the Press button. Pontata is the tile wall of all pressed giornate. Bond names both persons and assigns ink colors. Settings stores preferences and export format.

Four screens, all reached from the leaf. 1. Diptych, the root: the split leaf at full height with the left Sinopia and right Sinopia side by side, each headed by a person name and ink swatch, a hairline center rule between them, a carried Arriccio banner when yesterday came over with one filled half, and the Press control pinned at the foot, full width, enabled only when both Sinopie hold strokes and otherwise showing the refusal reason. Empty leaf is Gesso, a full page with generated art, one headline, one line, and Sketch as the bottom full width CTA. 2. Pontata, a sheet: a scrollable tile wall of every pressed Giornata newest first, each tile a combined thumbnail of both Sinopie with its date, tiles framed and clipped so nothing paints over a neighbor, and a full page empty state before the first Press. Tapping a tile opens the pressed leaf read only with a Share action. 3. Bond, a sheet: both person names in editable fields, one distinct ink per person mapped to PKInkingTool, the bond day count with milestones at 7, 30, 90, and 365, and a Settings row. 4. Settings, pushed from Bond: export format for the shared PNG, haptics toggle, the demo state notice on Simulator, and the contact URL at https://sinopialeaf-press.pro so App Review can find it.

Section 5 lists the logical functions that must exist. This section decides how
they are grouped into actual screens. Where the two disagree, this section wins.

A TabView with exactly three tabs is the factory stamp — use two or four-to-five destinations, or a different chrome. `-ReviewScreen today|log|goals` are launch keys, not tabs.

---

## 4. Target file organization

Scheme: **By giornata role (Giornata, Sinopia, PressMark, Arriccio, SpolveroMark, Gesso)**

```
Sinopia/
  Sinopia/
  Sinopia.xcodeproj/
  Packages/SinopiaCore/
    Package.swift
    Sources/SinopiaCore/
      Giornata/Giornata.swift, GiornataPhase.swift, GiornataFold.swift, DayKey.swift
      Sinopia/Sinopia.swift, SinopiaSide.swift, InkAssignment.swift
      PressMark/PressMark.swift, PressRule.swift
      Arriccio/Arriccio.swift, ArriccioCarry.swift
      Spolvero/SpolveroMark.swift, BleedGeometry.swift
      Gesso/Gesso.swift
      Codex/Codex.swift, CodexBinary.swift, ByteCursor.swift, CodexFile.swift
      Bond/Bond.swift, BondDays.swift
    Tests/SinopiaCoreTests/GiornataFoldTests.swift, PressRefusalTests.swift, SpolveroBleedTests.swift, CodexBinaryTests.swift, BondDaysTests.swift, DayKeyTests.swift
  Sinopia/
    App/SinopiaApp.swift, LeafRoute.swift, CodexStore.swift
    Diptych/DiptychScreen.swift, SinopiaCanvas.swift, CenterRule.swift, PressControl.swift, ArriccioBanner.swift, GessoEmptyLeaf.swift
    Pontata/PontataSheet.swift, GiornataTile.swift, PressedLeafView.swift, PontataEmpty.swift
    Bond/BondSheet.swift, PersonField.swift, InkPicker.swift, BondDaysCard.swift
    Settings/SettingsScreen.swift, ContactRow.swift
    Design/Tokens.swift, TypeScale.swift, Space.swift, Radius.swift, PressButtonStyle.swift, Motion.swift
    Onboarding/OnboardingFlow.swift
    Review/ReviewScreen.swift
    Seed/DemoSeed.swift
    Resources/Assets.xcassets/, Info.plist
  SinopiaTests/DiptychStateTests.swift, ReviewScreenKeyTests.swift, SeedTests.swift
  Assets.xcassets/
```

Adapt the leaf files to the architecture, but the top-level shape is fixed. Do
not create a `Utils/` or `Helpers/` dumping ground.

---

## 5. Screens

Build the screens named in section 3.6. The labels below are logical;
actual type names follow this app's naming convention.

### 5.1 Onboarding
Three to four pages. Explains the product, writes initial settings, sets a
completion flag. Skip still writes sensible defaults. Re-runnable from Settings.

### 5.2 Diptych
A first-class screen for **Diptych**. Must render empty, populated and error states.

### 5.3 Bond
A first-class screen for **Bond**. Must render empty, populated and error states.

### 5.4 Shelf
A first-class screen for **Shelf**. Must render empty, populated and error states.

### 5.5 Settings
A first-class screen for **Settings**. Must render empty, populated and error states.

### 5.6 Settings
Holds: re-run onboarding, reset all data (confirmed), and the contact link to
the domain contact-us URL.

### 5.7 Twist screen
See section 12. The twist needs at least one screen of its own plus a surface on the home screen.


---

## 6. Domain model

Minimum entities, named per this app's convention:

- **PairEntry** — named per this app's convention.
- **Prompt** — named per this app's convention.
- Plus whatever the twist in section 12 requires.


---

## 7. Design system

Direction: **shopify · split-compare · branded**

### 7.1 Palette

| Token | Hex | Use |
| --- | --- | --- |
| `background` | `#FFFFFF` | Screen background |
| `surface` | `#FFFFFF` | Cards, rows, sheets |
| `ink` | `#000000` | Primary text and icons |
| `accent` | `#09A664` | Primary action, key figure, progress fill |
| `muted` | `#6B6B6B` | Secondary text, dividers, disabled |

Define these as named colours in `Assets.xcassets` and reach them through one
typed accessor. Never hard-code a hex string anywhere else.

### 7.2 Typography

Family: **Optima**

Optima carries the whole app, one family, no second kit. Display and titles use Optima Bold with tight tracking and short wide lines, at most two lines on the Diptych headline, set as Font.custom("Optima-Bold", size:, relativeTo: .largeTitle) so Dynamic Type still scales; body and person names use Optima Regular around 17pt relativeTo .body with generous leading near 1.35 for an editorial measure. Optima is a humanist sans with flared stems and a calligraphic axis, which is why it belongs on a fresco leaf: it reads as a drawn letter next to drawn ink without becoming a script. Numerals, the bond day count, and the daykey label use Optima with monospaced digit tracking through a fixed width frame so the count does not jitter, and every value goes through NumberFormatter. One rule only, the hairline center rule of the leaf, is allowed to sit under a title; the type never stacks a second divider. Custom sizes go through ScaledMetric and headlines are verified unclipped at AX5, with a system fallback resolved once in TypeScale so a missing face degrades in one place rather than per view.

Define a type scale of at most six steps behind one accessor and use only those
steps. Text stays legible at the largest Dynamic Type size.

### 7.3 Layout

- One base spacing unit (4 or 8 pt); only multiples of it.
- Corner radius and elevation are fixed by section 7.4, not chosen per screen.
- Every interactive element is at least 44x44 pt.

### 7.4 Component contract

Corner radius: **14pt** for cards, sheets and primary surfaces; **6pt** for chips, badges and small controls. Reach both through one accessor. Never a bare literal number, and never zero — a hard edge is not this app's design direction.

Elevation: **hairline+fill** — a 1pt hairline border plus a flat fill tint, reused everywhere a surface sits above another.

Primary control: **bordered prominent** — primary actions use `.buttonStyle(.borderedProminent)` or an equivalent filled, bordered shape.

This is arithmetic, not a suggestion: every card, sheet, chip and button in this app uses these two radii and this elevation style. Do not introduce a second radius or a second elevation style.

### 7.5 Custom rendering scope

This app's `ui` axis is **SwiftUI + PencilKit representable · realitykit-lite**.

If that approach uses anything beyond stock SwiftUI/UIKit controls — `Canvas`, `CALayer`, Metal, SceneKit, SpriteKit, RealityKit, a hand-drawn `UIViewRepresentable`, or any other pixel-level custom rendering — confine it to exactly one hero surface on one screen (the mechanic's home view, or the one screen this axis exists to showcase). Every other screen — every list, every settings screen, every sheet, every secondary surface — is built from stock components: `List`, `Form`, `NavigationStack`, `TabView`, `Button`, `.sheet`, native `Text`/`Image`. A second custom-rendered surface elsewhere in the app is a defect, not a stylistic choice.

If **SwiftUI + PencilKit representable · realitykit-lite** is already fully native (no custom drawing layer), this section is satisfied automatically — there is nothing to confine.

The `ui` axis value is an implementation choice. It must never appear as a user-visible section title or label.

### 7.6 Taste DNA

Aesthetic: **dark** (Dark-tech: void surfaces, one glow or jewel, sparse chrome.)

Reference system: **shopify** — steal rhythm and restraint, not their colours or logos.

Mood: **E-commerce platform. Dark-first cinematic, neon green accent, ultra-light type.**.

Home rhythm (`split-compare`, airy): Two panes, a verdict. Not a settings list.

Dark-tech: void surfaces, one glow or jewel, sparse chrome. Layout `split-compare`, density airy. Kit 14/6, hairline+fill, bordered prominent. Palette recipe `branded`. One spring on the commit (response ~0.4, damping ~0.8). Everything else is ease-out. Reduce Motion: fade, no spring. Reduce Motion: fade only. Do not invent a second radius or a second accent.

Type move: Editorial measure, generous leading, one rule. Reference type feel: dark.

Motion (`spring`): One spring on the commit (response ~0.4, damping ~0.8). Everything else is ease-out. Reduce Motion: fade, no spring.

Voice (`dry`): Short verbs. No warmth padding. 'Saved.' not 'Your changes were saved successfully.'

Anti-slop from KNOWLEDGE.md applies. Taste never overrides contrast, 44pt hits, VoiceOver labels, or Reduce Motion.

---

## 8. UI and UX quality bar

Every item here is a defect if it is missing. Do not treat this as advice.

**Layout**

- Respect safe areas on every screen. Nothing sits under the notch, the Dynamic
  Island or the home indicator.
- The app is portrait-only on iPhone. Lock it in the Info settings and do not
  write rotation-dependent layout.
- No layout shift when asynchronous data arrives. Reserve the final size up
  front, or use a redacted placeholder of the same dimensions.
- Long product names must truncate gracefully, never push a number off screen.
  Numbers win; names truncate.
- Sibling cards, images and titles never overlap. Each cell owns its frame;
  `scaledToFill` is clipped to that cell. A chopped headline or two canvases
  in one slot is a defect, not a collage.
- Minimum tap target 44x44 pt for every interactive element, including small
  icon buttons and list accessories.
- Pick one base spacing unit and use only multiples of it. No arbitrary values.

**Keyboard**

- The grams field uses `.decimalPad`, and the decimal separator matches the
  user's locale.
- Content scrolls out from under the keyboard. The focused field is always
  visible.
- Tapping outside the field, or scrolling, dismisses the keyboard.
- Validate on the fly: reject negative and non-numeric input rather than
  crashing the parser later.

**Loading and state**

- Every asynchronous operation has a visible loading state.
- Guard against the spinner flash: if the work finishes in under 150 ms, do not
  show a spinner at all.
- Every list has a designed empty state containing a primary action, not just a
  sentence of text.
- Every error state offers a retry, and states plainly what failed.
- Disable the primary button while its action is in flight so it cannot be
  double-tapped into a double push or a duplicate entry.

**Typography and accessibility**

- All text scales with Dynamic Type. Verify at the largest accessibility size:
  nothing may clip or overlap.
- Every icon-only control has an `accessibilityLabel`. Decorative images are
  marked as decorative so VoiceOver skips them.
- Colour is never the only signal. Pair it with a label, a shape or an icon.
- Honour Reduce Motion: replace movement-heavy transitions with a fade.
- Meet contrast requirements against the palette in section 7. Check the muted
  colour against the background specifically; that is where these palettes fail.

**Formatting**

- Format every number with `NumberFormatter`, never string interpolation. Group
  separators and decimal separators must follow the locale.
- Energy is shown as a whole number of kcal. Macros are shown with at most one
  decimal place.
- Round only at the point of display. Stored values keep full precision.
- Day boundaries use `Calendar.current.startOfDay(for:)` in the user's current
  time zone. Handle the day changing while the app is open, and handle the
  short and long days that daylight saving produces.
- Unknown macro values render as a dash or the word "unknown", never as 0.

**Motion and feedback**

- One haptic on a successful commit (a food logged, a target saved). No haptic
  on navigation.
- Animations are short (0.2 to 0.35 s) and use a single shared easing curve.
- Nothing animates on first appearance of a screen except an intentional entry
  transition.

**Navigation**

- Back always works and never loses entered data without asking.
- A destructive action (delete a log row, reset all data) is confirmed.
- Modal sheets can always be dismissed; there is no dead end.
- Deep state is restorable: relaunching returns the user to a sane screen.


Every item here is a defect if it is missing. Section 7.4 fixed the numbers —
this is where they have to show up on screen.

**Hierarchy and density**

- Every screen has exactly one dominant element (a hero number, a canvas, a
  primary card) that the eye lands on first. A screen where every element has
  equal weight reads as a spreadsheet, not a product.
- Related content is grouped into a card or a section with the elevation
  style from 7.4, not left floating on the bare background.
- Unused flat background is not "minimal" — see the density rule in
  `KNOWLEDGE.md`. If a screen has room left after the mechanic and the
  content, add a secondary surface (a stat strip, a recent-activity card, a
  related-item row), not a `Spacer`.

**Components**

- Every card, sheet, chip, row and button in the app uses the corner radius
  and elevation from section 7.4. No screen introduces its own radius or its
  own shadow value "just for this one card".
- Buttons have a pressed state (`ButtonStyle` with a scale or opacity change
  on `isPressed`) and a disabled state that is visibly different, not just
  non-interactive.
- Chips and badges are pill or rounded-rect shaped per 7.4, never a bare
  `Text` with no background sitting where a control is expected.
- A functional control (add, filter, sort, close, more, share, delete) is an
  SF Symbol inside a properly hit-targeted `Button`. SF Symbols are fine and
  expected here — section 16 only bans them as the app's primary brand
  iconography (app icon, empty-state hero, onboarding art), which is what the
  generated assets in section 13 are for.

**Depth and material**

- At least one surface in the app (a sheet, a modal, a floating toolbar) uses
  the elevation style from 7.4 to visibly sit above the content behind it.
  A flat app with no depth anywhere reads as a wireframe.
- Icons and generated art sit on the surface colour from 7.1, never directly
  on a colour that makes their edges disappear.

**Motion as feedback, not decoration**

- The one dominant element in a screen (7.4's primary control, the mechanic's
  hero) responds visibly to touch: a scale, a colour shift, a haptic — pick
  at least one. A control that looks identical pressed and unpressed reads as
  broken, not calm.

**Taste DNA (section 7.6)**

- Home uses the assigned layout family and density. Three identical equal-weight
  cards, a leftover bento hole, or a second column structure copied down the
  page is a defect.
- Copy follows the assigned voice. No em-dash, no elevate/unlock/seamless, no
  emoji, no SECTION 01 labels.
- Motion follows the assigned personality and honours Reduce Motion with a fade.
  One signature motion per view. No glow stacked on glass stacked on spring.
- Tokens by intent: the live verb wears accent; delete does not wear primary.


---

## 9. Concurrency

The target builds with Swift 6.2 and `SWIFT_STRICT_CONCURRENCY = complete`. It
must compile with **zero concurrency warnings**. Warnings here become crashes
later, so they are not negotiable.

- All UI types are `@MainActor`. Annotate the type, not individual methods.
- Any value crossing an actor boundary is `Sendable`. Prefer immutable structs
  of primitives.
- Do not use `@unchecked Sendable`. If it is genuinely unavoidable, it needs a
  comment explaining what guarantees the safety.
- No mutable global state. No `static var` that is written after launch.
- Networking and storage APIs are `async` and honour cancellation. When the
  search query changes, cancel the in-flight task; do not let a stale response
  overwrite fresh results.
- Use structured concurrency. Avoid `Task.detached` unless there is a stated
  reason. Never fire a `Task` that outlives the view without owning it.
- Never use `DispatchQueue.main.asyncAfter` to paper over an ordering problem.
  Fix the ordering.
- `Timer` and notification observers are invalidated in `deinit` or on
  disappear.


---

## 10. Persistence engineering

Chosen technology: **binary format**

One binary codex file, no UserDefaults for content. CodexBinary writes a single little endian file at Application Support/snp/codex.snp opened with a four byte magic 'SNPC', a version byte, the Bond record with both person names, inks, and bondedAt, then a count and a run of Giornata records. Each Giornata record is daykey as Int32 in YYYYMMDD form, a phase byte, a pressedAt interval, then for each Sinopia a side byte, an ink id, a length prefixed PKDrawing dataRepresentation blob, and a length prefixed run of SpolveroMark tails. Reads run through a bounds checked ByteCursor that returns a typed failure rather than trapping, and an unknown version or a short tail is treated as Gesso instead of a crash. Writes are whole file and atomic, staged to a sibling temp path and then replaced, so a Press interrupted mid write leaves the previous codex intact. UserDefaults holds only preferences and the versioned Simulator seed key snp.demo.v1, and the seed marks onboarding complete in the same pass so the review hook is reachable.

This app persists to **files on disk**. The following are mandatory.

- Write atomically. Either `Data.write(to:options: .atomic)` or write to a
  temporary file and `FileManager.replaceItemAt`. A non-atomic write that is
  interrupted leaves a truncated file and the app will not launch.
- Create the containing directory with
  `withIntermediateDirectories: true` before the first write.
- Every document carries a `schemaVersion` field from version 1, and the decoder
  switches on it.
- Decoding failure must be recoverable: keep the previous good file as a
  `.backup`, fall back to it, and if that also fails start from empty state and
  tell the user. Never crash on a corrupt file.
- All file IO happens off the main thread. The main thread never blocks on disk.
- Debounce writes during rapid edits, but force a flush when `scenePhase`
  becomes `.inactive` or `.background`, and after any destructive action.
- Exclude caches from backup with `URLResourceValues.isExcludedFromBackup` where
  appropriate; user data belongs in Application Support and should be backed up.
- Keep an explicit in-memory source of truth and treat the file as a projection
  of it, so a failed write never leaves the UI showing data that does not exist.


Regardless of technology:

- One seam between domain logic and storage; the UI never touches storage types.
- Writes survive a force-quit. Do not rely on `applicationWillTerminate`.
- Provide `resetAllData()`, used by tests and reachable from Settings.

---

## 11. Networking

- One client type owns both Open Food Facts endpoints.
- Set `User-Agent` on every request. Open Food Facts throttles clients that do
  not identify themselves.
- 15 second timeout. One retry on a transient transport failure, then a typed
  error. Do not retry a 404.
- Cancel the in-flight search when the query changes. Debounce input by roughly
  300 ms.
- Decode into DTO types that mirror the JSON exactly, then map to domain types.
  Never decode straight into your domain model.
- Dedicated `JSONDecoder` with `.useDefaultKeys`. Never `convertFromSnakeCase` —
  Open Food Facts keys like `energy-kcal_100g` break snake_case conversion.
- Resolve a scanned code with `GET /api/v2/product/<barcode>.json`, not a search.
- Open Food Facts data is user-contributed and frequently incomplete. Every
  numeric field is optional. A product with no energy value is a normal case
  that the UI must present, not an error.
- Some numeric fields arrive as strings. The decoder must accept both a number
  and a numeric string for every nutriment.
- `status` of `0` in the product response means not found. Map it to a distinct
  error case so the UI can offer manual entry.
- Never crash on malformed JSON. A decoding failure is a handled error.
- Cache every resolved product locally on success, so the app degrades to a
  working offline catalogue.


Set `User-Agent: Sinopia/1.0 (iOS; +https://sinopialeaf-press.pro)` on every request. Never reuse another app's string.
No required remote catalog. Network only if this product actually needs it.

---

## 11b. App Store readiness

The app must be submittable without further work.

- `PrivacyInfo.xcprivacy` in the target, declaring the UserDefaults access API
  reason `CA92.1` and the file timestamp reason `C617.1`, with
  `NSPrivacyTracking` false and no collected data types.
- `INFOPLIST_KEY_ITSAppUsesNonExemptEncryption = NO` in the pbxproj so TestFlight
  does not sit on Missing Compliance.
- `NSCameraUsageDescription` written specifically for this app. Generic strings
  get rejected.
- `LSApplicationCategoryType` of `public.app-category.healthcare-fitness`.
- Portrait only, iPhone and iPad (`TARGETED_DEVICE_FAMILY = "1,2"`).
- No account, no sign-in, no delete-account flow, no in-app purchase, no ads, no
  user-generated content, and therefore no report or block UI.
- App Tracking Transparency is never invoked.
- The camera is the only sensitive permission requested.
- Guideline 5.1.1 (Privacy): do not encourage or direct the user to grant camera
  access. A pre-permission screen may exist, but the proceed button must be
  **Continue** or **Next** — never "Allow camera", "Enable camera",
  "Grant camera", or a bare Allow/Enable that calls `requestAccess`. The
  system dialog is the only Allow. Denied/restricted offers Open Settings.
- The app must not present itself as a clinician or as medical advice.
- Guideline 4.2 (Design — Minimum Functionality): the binary must be a native
  product, not a web browsing experience. No WKWebView / SFSafariViewController
  / UIWebView as home, a tab, or the primary UX. A content catalog, article
  reader, or site wrapper that could be a website is a reject. Push
  notifications, Core Location, and sharing do not make that acceptable.
- Guideline 1.4.1 (Safety — Physical Harm): if the binary shows health or
  medical recommendations, body-based targets, dosages, "you should" guidance,
  or product health claims (food, drink, supplement, remedy), put citations
  in the app. Tappable links to the sources, easy to find: same screen as the
  claim, or a Sources row one tap from Settings. Name the source (Open Food
  Facts, USDA FoodData Central, WHO, NIH MedlinePlus, …) and link it. A
  "not medical advice" footer without sources is a reject. A personal log
  that never advises does not invent claims to cite.
- Nutrition catalog data is credited to the database this app actually uses
  (Open Food Facts unless the spec names another). Credit is a tappable link,
  not a dead "OpenFoodFacts" label.


Ignore the food-log and Open Food Facts lines above when they conflict with this
family. Category for this app is `public.app-category.lifestyle`. Camera permission only if the
product actually captures.

Project settings that follow from the above:

```yaml
INFOPLIST_KEY_UIUserInterfaceStyle: Light
INFOPLIST_KEY_UISupportedInterfaceOrientations: UIInterfaceOrientationPortrait
INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad: UIInterfaceOrientationPortrait
INFOPLIST_KEY_UIRequiresFullScreen: YES
INFOPLIST_KEY_ITSAppUsesNonExemptEncryption: NO
INFOPLIST_KEY_LSApplicationCategoryType: public.app-category.lifestyle
TARGETED_DEVICE_FAMILY: "1,2"
SWIFT_STRICT_CONCURRENCY: complete
```

---

## 12. Functional twist: Bleed-and-press (strokes that cross the center sinopia copy their tail as spolvero into the adjacent half; Press locks when both sinopie hold strokes; a one-sided midnight giornata carries as Arriccio)

Bleed-and-press is the verb and it lives on home. Each Sinopia belongs to one person named in Bond, and tapping a Sinopia gives that half the tool picker while the other half stays fully visible, so neither person ever draws blind. When a stroke's path crosses the center rule, the crossing tail is copied into the adjacent Sinopia as a SpolveroMark tinted in the sketcher's ink, which makes the seam a shared border both people can see forming. Press is the verdict of the split: it is refused with a stated reason while either Sinopia is empty, and when both hold strokes it writes a PressMark keyed by daykey, locks the Giornata against further Sketch, fires one haptic, and slides the leaf into the Pontata. Undo peels the newest stroke together with the SpolveroMark it produced, never leaving an orphan tail on the other half. A Giornata with one filled Sinopia at the day roll does not die: it stays Halved as an Arriccio and reappears on the next Diptych with the filled half dimmed, so the second person can still answer. The unit tested invariants are the refusal pair, the spolvero peel, the Arriccio carry, and bond days as startOfDay(now) minus startOfDay(bondedAt) with milestones at 7, 30, 90, and 365.

This is the app's marketed differentiator. It must be:

- visible on the home screen, not buried in settings;
- backed by real persisted data, not a cosmetic flourish;
- covered by at least one unit test;
- described in the README as the reason a user would pick this app.

---

## 13. AI-generated assets

Art style: **Holographic iridescent · illustration**


Base prompt, reused and extended for every asset:

```
Holographic iridescent illustration: thin film interference across a smooth plaster or pressed paper surface, the sheen shifting with the viewing angle so a flat plane reads as depth without any 3D render. Hand drawn illustration line under the sheen, calligraphic and slightly flared, as if a brush laid a sinopia sketch that was then sealed under a prismatic film. Technique is flat vector illustration plus a soft refractive gradient sweep and a faint diffraction banding, no photography, no lens flare, no chrome bevel, no drop shadow stack. Mood is quiet and ceremonial, two halves meeting at a single clean seam, airy negative space, one luminous focal point and nothing else competing. Use only the fixed palette tokens; no text, no letters, no numerals, no emoji, no UI chrome, no betting or casino motifs.
```

All 17 images below are required. Generate each one, export
as PNG, and add it to `Assets.xcassets` as its own image set named exactly as
given. Every name carries the `snp_` prefix.

### 13.1 App icon rules (strict)

The icon is rejected by App Store Connect if any of these are wrong:

- Exactly **1024 x 1024 px**.
- **No alpha channel.**
- sRGB colour profile, 8 bits per channel, PNG.
- **No text and no words** in the artwork.
- **No rounded corners and no built-in mask.**
- The subject stays inside the middle 80%.

### 13.2 Full asset list

| # | Image set | Size (px) | Alpha | Purpose |
| --- | --- | --- | --- | --- |
| 1 | `snp_AppIcon` | 1024x1024 | **NO** | App Store icon. NO alpha channel, NO transparency, NO text, NO rounded corners, NO drop shadow outside the canvas. |
| 2 | `snp_Splash` | 1290x2796 | fill | Launch background. The middle third must stay quiet so the wordmark reads on top. |
| 3 | `snp_Onboarding1` | 1024x1536 | **required cutout** | Onboarding page 1 illustration: what the app is for. |
| 4 | `snp_Onboarding2` | 1024x1536 | **required cutout** | Onboarding page 2 illustration: the main verb. |
| 5 | `snp_Onboarding3` | 1024x1536 | **required cutout** | Onboarding page 3 illustration: why they stay. |
| 6 | `snp_EmptyHome` | 1024x1024 | **required cutout** | Empty state: the home screen has nothing yet. Calm and inviting, never sad. |
| 7 | `snp_EmptyList` | 1024x1024 | **required cutout** | Empty state: a secondary list has no rows. |
| 8 | `snp_CardBackdrop` | 1200x800 | fill | Backdrop art for a primary card. Low contrast so text stays readable. |
| 9 | `snp_ControlFace` | 512x512 | **required cutout** | Custom control artwork used for the primary interactive element. |
| 10 | `snp_TwistHero` | 1024x1024 | **required cutout** | Hero art for the 'Bleed-and-press (strokes that cross the center sinopia copy their tail as spolvero into the adjacent half; Press locks when both sinopie hold strokes; a one-sided midnight giornata carries as Arriccio)' feature screen. |
| 11 | `snp_SuccessMark` | 512x512 | **required cutout** | Shown briefly when the primary action succeeds. |
| 12 | `snp_HeaderDecor` | 1200x600 | **required cutout** | Decorative header accent on the main screen. |
| 13 | `snp_GessoLeaf` | 1024x1024 | **required cutout** | Cutout of an empty split leaf standing upright, the two halves blank and the center seam drawn as one clean line, a single iridescent glint riding the seam. Solid opaque subject centered on the canvas with fully transparent corners and transparent background, real alpha, no plate, no frame, no glass pane, no hollow outline, no text. |
| 14 | `snp_PressSeal` | 1024x1024 | **required cutout** | Cutout of a small pressed seal shaped like two leaf halves folded together and clamped, edges bloomed with thin film iridescence where the halves meet. Solid opaque subject centered, transparent corners and transparent background, real alpha, no square plate behind it, no wire frame, no text, no numerals. |
| 15 | `snp_ArriccioCarry` | 1024x1024 | **required cutout** | Cutout of a single leaf half with one filled brush mark and one blank half folding over to wait, the blank half dimmed and the seam catching a thin iridescent edge. Solid opaque subject centered, transparent corners and transparent background, real alpha, no plate, no border, no text. |
| 16 | `snp_PontataWall` | 1024x1024 | **required cutout** | Cutout of a small stack of pressed leaves fanned into a tight wall, each leaf showing its center seam, the topmost catching an iridescent sweep. Solid opaque subject centered, transparent corners and transparent background, real alpha, no glass case, no hollow frame, no text. |
| 17 | `snp_BondPair` | 1024x1024 | **required cutout** | Cutout of two brush marks, distinct in weight and gesture, curving toward each other until their tails overlap into one iridescent bloom. Solid opaque subject centered, transparent corners and transparent background, real alpha, no plate, no circle badge, no text. |

### Prompt per asset

**`snp_AppIcon`** — 1024x1024

```
A single pressed leaf seen flat, split down the middle by one hairline seam, with two mirrored brush marks meeting and blending at the seam into a small iridescent bloom. Centered emblem filling the canvas edge to edge, flat illustration with thin film sheen, ceremonial and calm. No text, no letters, no numerals, no border, no rounded corner mask, no transparency.
```

**`snp_Splash`** — 1290x2796

```
Full bleed pressed plaster field with a faint vertical seam at the exact center and a slow iridescent sweep crossing it once, two soft brush traces reaching toward the seam from either side. Fills the entire canvas with no cut out subject, airy and quiet, illustration with thin film interference. No text, no glyphs, no UI elements.
```

**`snp_Onboarding1`** — 1024x1536

```
Holographic iridescent illustration: thin film interference across a smooth plaster or pressed paper surface, the sheen shifting with the viewing angle so a flat plane reads as depth without any 3D render. Hand drawn illustration line under the sheen, calligraphic and slightly flared, as if a brush laid a sinopia sketch that was then sealed under a prismatic film. Technique is flat vector illustration plus a soft refractive gradient sweep and a faint diffraction banding, no photography, no lens flare, no chrome bevel, no drop shadow stack. Mood is quiet and ceremonial, two halves meeting at a single clean seam, airy negative space, one luminous focal point and nothing else competing. Use only the fixed palette tokens; no text, no letters, no numerals, no emoji, no UI chrome, no betting or casino motifs., a person or object that is this product in one glance

HARD CUTOUT: isolated SOLID opaque subject on a fully transparent background, occupying the center of the canvas. Real PNG alpha channel. All four corners fully transparent. No square plate, no painted backdrop, no opaque box, no drop shadow that fills the canvas. Not glass, not a hollow frame, not a wire outline, not an empty vitrine — rembg punches through those and the cutout is empty. GenerateImage writes opaque RGB — after copy, convert the PNG to RGBA in place; do not generate it again for alpha.
```

**`snp_Onboarding2`** — 1024x1536

```
Holographic iridescent illustration: thin film interference across a smooth plaster or pressed paper surface, the sheen shifting with the viewing angle so a flat plane reads as depth without any 3D render. Hand drawn illustration line under the sheen, calligraphic and slightly flared, as if a brush laid a sinopia sketch that was then sealed under a prismatic film. Technique is flat vector illustration plus a soft refractive gradient sweep and a faint diffraction banding, no photography, no lens flare, no chrome bevel, no drop shadow stack. Mood is quiet and ceremonial, two halves meeting at a single clean seam, airy negative space, one luminous focal point and nothing else competing. Use only the fixed palette tokens; no text, no letters, no numerals, no emoji, no UI chrome, no betting or casino motifs., the primary action of this product, mid-gesture

HARD CUTOUT: isolated SOLID opaque subject on a fully transparent background, occupying the center of the canvas. Real PNG alpha channel. All four corners fully transparent. No square plate, no painted backdrop, no opaque box, no drop shadow that fills the canvas. Not glass, not a hollow frame, not a wire outline, not an empty vitrine — rembg punches through those and the cutout is empty. GenerateImage writes opaque RGB — after copy, convert the PNG to RGBA in place; do not generate it again for alpha.
```

**`snp_Onboarding3`** — 1024x1536

```
Holographic iridescent illustration: thin film interference across a smooth plaster or pressed paper surface, the sheen shifting with the viewing angle so a flat plane reads as depth without any 3D render. Hand drawn illustration line under the sheen, calligraphic and slightly flared, as if a brush laid a sinopia sketch that was then sealed under a prismatic film. Technique is flat vector illustration plus a soft refractive gradient sweep and a faint diffraction banding, no photography, no lens flare, no chrome bevel, no drop shadow stack. Mood is quiet and ceremonial, two halves meeting at a single clean seam, airy negative space, one luminous focal point and nothing else competing. Use only the fixed palette tokens; no text, no letters, no numerals, no emoji, no UI chrome, no betting or casino motifs., a later moment when the product has accumulated meaning

HARD CUTOUT: isolated SOLID opaque subject on a fully transparent background, occupying the center of the canvas. Real PNG alpha channel. All four corners fully transparent. No square plate, no painted backdrop, no opaque box, no drop shadow that fills the canvas. Not glass, not a hollow frame, not a wire outline, not an empty vitrine — rembg punches through those and the cutout is empty. GenerateImage writes opaque RGB — after copy, convert the PNG to RGBA in place; do not generate it again for alpha.
```

**`snp_EmptyHome`** — 1024x1024

```
Holographic iridescent illustration: thin film interference across a smooth plaster or pressed paper surface, the sheen shifting with the viewing angle so a flat plane reads as depth without any 3D render. Hand drawn illustration line under the sheen, calligraphic and slightly flared, as if a brush laid a sinopia sketch that was then sealed under a prismatic film. Technique is flat vector illustration plus a soft refractive gradient sweep and a faint diffraction banding, no photography, no lens flare, no chrome bevel, no drop shadow stack. Mood is quiet and ceremonial, two halves meeting at a single clean seam, airy negative space, one luminous focal point and nothing else competing. Use only the fixed palette tokens; no text, no letters, no numerals, no emoji, no UI chrome, no betting or casino motifs., a solid closed bowl, crate or folded cloth waiting to be used — ceramic, wood or fabric, fully opaque, not glass

HARD CUTOUT: isolated SOLID opaque subject on a fully transparent background, occupying the center of the canvas. Real PNG alpha channel. All four corners fully transparent. No square plate, no painted backdrop, no opaque box, no drop shadow that fills the canvas. Not glass, not a hollow frame, not a wire outline, not an empty vitrine — rembg punches through those and the cutout is empty. GenerateImage writes opaque RGB — after copy, convert the PNG to RGBA in place; do not generate it again for alpha.
```

**`snp_EmptyList`** — 1024x1024

```
Holographic iridescent illustration: thin film interference across a smooth plaster or pressed paper surface, the sheen shifting with the viewing angle so a flat plane reads as depth without any 3D render. Hand drawn illustration line under the sheen, calligraphic and slightly flared, as if a brush laid a sinopia sketch that was then sealed under a prismatic film. Technique is flat vector illustration plus a soft refractive gradient sweep and a faint diffraction banding, no photography, no lens flare, no chrome bevel, no drop shadow stack. Mood is quiet and ceremonial, two halves meeting at a single clean seam, airy negative space, one luminous focal point and nothing else competing. Use only the fixed palette tokens; no text, no letters, no numerals, no emoji, no UI chrome, no betting or casino motifs., an empty list, shelf or page

HARD CUTOUT: isolated SOLID opaque subject on a fully transparent background, occupying the center of the canvas. Real PNG alpha channel. All four corners fully transparent. No square plate, no painted backdrop, no opaque box, no drop shadow that fills the canvas. Not glass, not a hollow frame, not a wire outline, not an empty vitrine — rembg punches through those and the cutout is empty. GenerateImage writes opaque RGB — after copy, convert the PNG to RGBA in place; do not generate it again for alpha.
```

**`snp_CardBackdrop`** — 1200x800

```
Full bleed pressed paper texture with a barely visible center seam and a wide diagonal iridescent sheen, low contrast so type can sit on it without losing legibility. Fills the canvas, no subject, no cut out, no text, no glyphs.
```

**`snp_ControlFace`** — 512x512

```
Holographic iridescent illustration: thin film interference across a smooth plaster or pressed paper surface, the sheen shifting with the viewing angle so a flat plane reads as depth without any 3D render. Hand drawn illustration line under the sheen, calligraphic and slightly flared, as if a brush laid a sinopia sketch that was then sealed under a prismatic film. Technique is flat vector illustration plus a soft refractive gradient sweep and a faint diffraction banding, no photography, no lens flare, no chrome bevel, no drop shadow stack. Mood is quiet and ceremonial, two halves meeting at a single clean seam, airy negative space, one luminous focal point and nothing else competing. Use only the fixed palette tokens; no text, no letters, no numerals, no emoji, no UI chrome, no betting or casino motifs., the face of a single physical control such as a dial, key or slider handle

HARD CUTOUT: isolated SOLID opaque subject on a fully transparent background, occupying the center of the canvas. Real PNG alpha channel. All four corners fully transparent. No square plate, no painted backdrop, no opaque box, no drop shadow that fills the canvas. Not glass, not a hollow frame, not a wire outline, not an empty vitrine — rembg punches through those and the cutout is empty. GenerateImage writes opaque RGB — after copy, convert the PNG to RGBA in place; do not generate it again for alpha.
```

**`snp_TwistHero`** — 1024x1024

```
Holographic iridescent illustration: thin film interference across a smooth plaster or pressed paper surface, the sheen shifting with the viewing angle so a flat plane reads as depth without any 3D render. Hand drawn illustration line under the sheen, calligraphic and slightly flared, as if a brush laid a sinopia sketch that was then sealed under a prismatic film. Technique is flat vector illustration plus a soft refractive gradient sweep and a faint diffraction banding, no photography, no lens flare, no chrome bevel, no drop shadow stack. Mood is quiet and ceremonial, two halves meeting at a single clean seam, airy negative space, one luminous focal point and nothing else competing. Use only the fixed palette tokens; no text, no letters, no numerals, no emoji, no UI chrome, no betting or casino motifs., an emblem representing this app's signature feature

HARD CUTOUT: isolated SOLID opaque subject on a fully transparent background, occupying the center of the canvas. Real PNG alpha channel. All four corners fully transparent. No square plate, no painted backdrop, no opaque box, no drop shadow that fills the canvas. Not glass, not a hollow frame, not a wire outline, not an empty vitrine — rembg punches through those and the cutout is empty. GenerateImage writes opaque RGB — after copy, convert the PNG to RGBA in place; do not generate it again for alpha.
```

**`snp_SuccessMark`** — 512x512

```
Holographic iridescent illustration: thin film interference across a smooth plaster or pressed paper surface, the sheen shifting with the viewing angle so a flat plane reads as depth without any 3D render. Hand drawn illustration line under the sheen, calligraphic and slightly flared, as if a brush laid a sinopia sketch that was then sealed under a prismatic film. Technique is flat vector illustration plus a soft refractive gradient sweep and a faint diffraction banding, no photography, no lens flare, no chrome bevel, no drop shadow stack. Mood is quiet and ceremonial, two halves meeting at a single clean seam, airy negative space, one luminous focal point and nothing else competing. Use only the fixed palette tokens; no text, no letters, no numerals, no emoji, no UI chrome, no betting or casino motifs., a confirmation mark or celebratory emblem

HARD CUTOUT: isolated SOLID opaque subject on a fully transparent background, occupying the center of the canvas. Real PNG alpha channel. All four corners fully transparent. No square plate, no painted backdrop, no opaque box, no drop shadow that fills the canvas. Not glass, not a hollow frame, not a wire outline, not an empty vitrine — rembg punches through those and the cutout is empty. GenerateImage writes opaque RGB — after copy, convert the PNG to RGBA in place; do not generate it again for alpha.
```

**`snp_HeaderDecor`** — 1200x600

```
Holographic iridescent illustration: thin film interference across a smooth plaster or pressed paper surface, the sheen shifting with the viewing angle so a flat plane reads as depth without any 3D render. Hand drawn illustration line under the sheen, calligraphic and slightly flared, as if a brush laid a sinopia sketch that was then sealed under a prismatic film. Technique is flat vector illustration plus a soft refractive gradient sweep and a faint diffraction banding, no photography, no lens flare, no chrome bevel, no drop shadow stack. Mood is quiet and ceremonial, two halves meeting at a single clean seam, airy negative space, one luminous focal point and nothing else competing. Use only the fixed palette tokens; no text, no letters, no numerals, no emoji, no UI chrome, no betting or casino motifs., a wide decorative band or ornament

HARD CUTOUT: isolated SOLID opaque subject on a fully transparent background, occupying the center of the canvas. Real PNG alpha channel. All four corners fully transparent. No square plate, no painted backdrop, no opaque box, no drop shadow that fills the canvas. Not glass, not a hollow frame, not a wire outline, not an empty vitrine — rembg punches through those and the cutout is empty. GenerateImage writes opaque RGB — after copy, convert the PNG to RGBA in place; do not generate it again for alpha.
```

**`snp_GessoLeaf`** — 1024x1024

```
Cutout of an empty split leaf standing upright, the two halves blank and the center seam drawn as one clean line, a single iridescent glint riding the seam. Solid opaque subject centered on the canvas with fully transparent corners and transparent background, real alpha, no plate, no frame, no glass pane, no hollow outline, no text.

HARD CUTOUT: isolated SOLID opaque subject on a fully transparent background, occupying the center of the canvas. Real PNG alpha channel. All four corners fully transparent. No square plate, no painted backdrop, no opaque box, no drop shadow that fills the canvas. Not glass, not a hollow frame, not a wire outline, not an empty vitrine — rembg punches through those and the cutout is empty. GenerateImage writes opaque RGB — after copy, convert the PNG to RGBA in place; do not generate it again for alpha.
```

**`snp_PressSeal`** — 1024x1024

```
Cutout of a small pressed seal shaped like two leaf halves folded together and clamped, edges bloomed with thin film iridescence where the halves meet. Solid opaque subject centered, transparent corners and transparent background, real alpha, no square plate behind it, no wire frame, no text, no numerals.

HARD CUTOUT: isolated SOLID opaque subject on a fully transparent background, occupying the center of the canvas. Real PNG alpha channel. All four corners fully transparent. No square plate, no painted backdrop, no opaque box, no drop shadow that fills the canvas. Not glass, not a hollow frame, not a wire outline, not an empty vitrine — rembg punches through those and the cutout is empty. GenerateImage writes opaque RGB — after copy, convert the PNG to RGBA in place; do not generate it again for alpha.
```

**`snp_ArriccioCarry`** — 1024x1024

```
Cutout of a single leaf half with one filled brush mark and one blank half folding over to wait, the blank half dimmed and the seam catching a thin iridescent edge. Solid opaque subject centered, transparent corners and transparent background, real alpha, no plate, no border, no text.

HARD CUTOUT: isolated SOLID opaque subject on a fully transparent background, occupying the center of the canvas. Real PNG alpha channel. All four corners fully transparent. No square plate, no painted backdrop, no opaque box, no drop shadow that fills the canvas. Not glass, not a hollow frame, not a wire outline, not an empty vitrine — rembg punches through those and the cutout is empty. GenerateImage writes opaque RGB — after copy, convert the PNG to RGBA in place; do not generate it again for alpha.
```

**`snp_PontataWall`** — 1024x1024

```
Cutout of a small stack of pressed leaves fanned into a tight wall, each leaf showing its center seam, the topmost catching an iridescent sweep. Solid opaque subject centered, transparent corners and transparent background, real alpha, no glass case, no hollow frame, no text.

HARD CUTOUT: isolated SOLID opaque subject on a fully transparent background, occupying the center of the canvas. Real PNG alpha channel. All four corners fully transparent. No square plate, no painted backdrop, no opaque box, no drop shadow that fills the canvas. Not glass, not a hollow frame, not a wire outline, not an empty vitrine — rembg punches through those and the cutout is empty. GenerateImage writes opaque RGB — after copy, convert the PNG to RGBA in place; do not generate it again for alpha.
```

**`snp_BondPair`** — 1024x1024

```
Cutout of two brush marks, distinct in weight and gesture, curving toward each other until their tails overlap into one iridescent bloom. Solid opaque subject centered, transparent corners and transparent background, real alpha, no plate, no circle badge, no text.

HARD CUTOUT: isolated SOLID opaque subject on a fully transparent background, occupying the center of the canvas. Real PNG alpha channel. All four corners fully transparent. No square plate, no painted backdrop, no opaque box, no drop shadow that fills the canvas. Not glass, not a hollow frame, not a wire outline, not an empty vitrine — rembg punches through those and the cutout is empty. GenerateImage writes opaque RGB — after copy, convert the PNG to RGBA in place; do not generate it again for alpha.
```


### 13.3 Asset rules

- Cut-outs (everything except AppIcon, Splash, CardBackdrop): isolated subject,
  real PNG alpha, all four corners transparent. No square plate.
- Assets must be semantically different from each other.
- Record the exact prompt used for every asset in the README.
- SF Symbols are permitted only for close, chevron, share and similar system
  affordances.

Scanner frames, reticles, and seamless tiles are drawn in SwiftUI via `Path` or `Shape`. GenerateImage is not used for those. Every other in-app graphic (except AppIcon, Splash, CardBackdrop) is a **cutout**: isolated SOLID opaque subject in the center, real PNG alpha, all four corners transparent. An opaque square plate inside a circle or pentagon is a fail. A hollow glass box or wire frame with a transparent center is a fail.

---

## 14. Demo data

Seed a small local demo dataset for this family's entities so Simulator
screenshots are not empty. The same seed must mark onboarding complete and
fill the primary surface — otherwise `-ReviewScreen` never fires. Never seed
on a physical device. Guard with `#if targetEnvironment(simulator)` and
`snp.demo.v1`.

Seed the happy path: the home primary verb is enabled. The blocked / gated /
error state is a unit-test fixture, not Simulator home. Home chrome names the
job and the next tap in words a stranger knows. Axis values (`ui`, `naming`,
`architecture`) never become user-visible titles. A card that looks tappable
is a `Button`. A readout does not use button chrome.

---

## 16. Anti-patterns

The following will fail review:

- `try!`, `as!`, or force-unwrapping anything derived from the network, the
  database or a file.
- `fatalError` anywhere reachable at runtime. It is acceptable only for a
  programmer error in an initialiser that cannot fail in practice, and needs a
  comment.
- Swallowing an error with an empty `catch`.
- `print` used as production logging.
- A hard-coded hex colour outside the single colour accessor.
- A hard-coded font name outside the single typography accessor.
- An SF Symbol used as the app's brand iconography — the app icon, the
  empty-state hero, or onboarding art. Those come from section 13. SF Symbols
  are the right choice for every functional control (add, filter, sort,
  close, share, delete) — leaving those as bare text instead of a symbol is
  also a defect.
- Storing a value that can be computed (day totals, remaining budget, macro
  percentages).
- Blocking the main thread on disk or network work.
- `UIScreen.main` for sizing. Use the geometry the layout system gives you.
- Index positions used as list identity. Identity is a stable identifier.
- A view that reaches into the persistence layer directly, bypassing the
  architecture's designated seam.
- Business logic inside a `View` body or a `UIViewController` method, when the
  assigned architecture places it elsewhere.
- Copying a source file from another app in this batch.
- A `TabView` with exactly three tabs. That is the factory stamp — two or
  four-to-five destinations, or a different chrome. ReviewScreen keys are
  not tabs.


---

## 17. Tests

Add a unit test target `SinopiaTests` covering at minimum:

1. The core domain invariant of this family (the thing that would be wrong if
   the calculator, decay, crate, or log lied).
2. Empty, populated and invalid input paths for the primary verb.
3. The section 12 twist logic.
4. One architecture-specific test proving the pattern holds.
5. A persistence round-trip: write, relaunch-equivalent reload, verify.
6. Parse `ProcessInfo.processInfo.arguments` once after onboarding. 
   `-ReviewScreen today|log|goals` switches the running app's live navigation. Extra cover slugs open those screens.
   Cover that parser with a unit test. Do not host a `View` in the test.

---

## 18. README.md

Write `README.md` at the app folder root covering:

1. What the app does and who it is for.
2. The architecture used and **why** it suits this product.
3. The unique feature added and how it works.
4. The AI art style and the exact prompt used for every asset.
5. How this app differs from others in the batch.
6. Build instructions.

---

## 19. Definition of done

**Build**
- [ ] `xcodegen generate` succeeds.
- [ ] `xcodebuild -scheme Sinopia -destination 'generic/platform=iOS' build` succeeds.
- [ ] Zero new compiler warnings.
- [ ] Strict concurrency `complete` compiles clean.
- [ ] Test target passes.

**Function**
- [ ] Onboarding to first successful primary action works on a clean install.
- [ ] Every screen in section 3.6 exists and handles empty / filled / error.
- [ ] Reset and contact link live in Settings.
- [ ] Force-quitting immediately after a write loses nothing.
- [ ] Seeded home names the job and next tap; primary verb enabled.
- [ ] App reads `-ReviewScreen today|log|goals` after onboarding.

**Uniqueness**
- [ ] Architecture matches **Split-canvas giornata fold (Fresh | Halved | Pressed); the codex is a fold over Giornate keyed by daykey; Sketch writes PencilKit strokes on the tapped Sinopia and folds Fresh to Halved when the first Sinopia receives strokes; Press writes a PressMark when both Sinopie hold strokes and folds Halved to Pressed; Press on Fresh is refused; Sketch on a Pressed Giornata is refused; strokes that cross the center rule bleed tint into the adjacent Sinopia as spolvero; a Giornata with one empty Sinopia at midnight stays Halved as an Arriccio; empty codex writes Gesso** with no leakage across layers.
- [ ] UI approach matches **SwiftUI + PencilKit representable · realitykit-lite**.
- [ ] Custom rendering, if any, is confined to one hero surface (section 7.5).
- [ ] Navigation matches **Leaf-locked chrome (the split canvas never leaves; Pontata and Bond arrive as sheets; sketch and press fuse on Diptych)**.
- [ ] Screen composition follows section 3.6.
- [ ] Typography uses **Optima** and nothing else.
- [ ] Palette matches section 7.1 exactly.
- [ ] Home rhythm and motion match section 7.6. No second look.

**Quality**
- [ ] Section 8 UI/UX bar satisfied end to end.
- [ ] Contact link present.
- [ ] `PrivacyInfo.xcprivacy` present and correct.
- [ ] README complete.

---

## 20. Build commands

```bash
cd Sinopia
xcodegen generate
xcodebuild -scheme Sinopia -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO build
xcrun simctl list devices available
xcodebuild -scheme Sinopia -destination 'platform=iOS Simulator,id=<UDID>' test
```

Signing is off only on that command line. Do not put CODE_SIGNING_ALLOWED, CODE_SIGNING_REQUIRED, CODE_SIGN_IDENTITY or DEVELOPMENT_TEAM in project.yml — CI signs the archive. Leave CODE_SIGN_STYLE: Automatic as the scaffold set it. The exact simulator does not matter — use any available UDID from the list.
