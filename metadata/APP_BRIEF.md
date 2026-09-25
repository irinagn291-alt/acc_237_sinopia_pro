<!-- gf-brief source=4728671c1fed3c2096311ebb59baf299a90d5167c26f2141562e2845bbd7fdb6 written=2026-09-26T01:34:10+03:00 -->
# Sinopia
## What it is
Sinopia is a shared daily drawing leaf for two people who use one device. Each person sketches their half of today’s split leaf; both halves stay visible. When both sides hold ink, Press locks that day as one keepsake. It is for couples, close friends, or a parent and child who want a drawn ritual, not a typed one.

## Launch and onboarding
The home-screen name is “Sinopia”. The app always opens in a dark look. There is no login and no account.

**On a device (no sample leaves):** a cold launch opens the introduction, not the leaf.

1. Top right: “Skip”. Bottom: “Continue”.
2. Page 1: “Two halves, one leaf.” / “Each person sketches their side. Both stay visible.” “Continue”.
3. Page 2: “Ink can cross the seam.” / “A stroke that passes the center leaves a tint on the other half.” “Continue”.
4. Page 3: “Press locks the day.” / “When both halves hold ink, Press writes the keepsake.” “Continue”.
5. Page 4: “Name both people.” Fields “Left name” and “Right name”, prefilled with “Left” and “Right”. Bottom: “Start”.

“Skip” writes the names “Left” and “Right” and opens the leaf. “Start” uses the typed names, or “Left” and “Right” if a field is left blank, then opens the leaf. No credentials are needed.

After that first pass the leaf is empty: navigation title “Leaf”, then the blank-leaf page (see Screens).

**On Simulator:** the introduction is skipped. The leaf opens already named “Mara” and “Leo”, with today’s both halves already inked so “Press” is enabled, and four older pressed leaves already on the wall. Settings then includes “Demo leaves are loaded on Simulator.”

“Show introduction” in Settings runs the same four pages again. Existing leaves are not erased by that.

## Screens
There is no tab bar. The split leaf stays on screen. “Leaves” and “People” arrive as sheets. “Settings” is pushed from “People”.

### Leaf
Navigation title: “Leaf”.

Headline: “Sketch both halves.” Line: “Press when both sides hold ink.”

Toolbar, leading: a grid control labeled “Pontata”. It opens the “Leaves” sheet.

Toolbar, trailing: a back-arrow control labeled “Undo” (peels the newest stroke and any tint that stroke left on the other half), then a two-people control labeled “Bond” (opens the “People” sheet).

**Blank leaf (nothing drawn yet, after a device introduction or after erase):**
- “Blank leaf.”
- “Sketch the first half. The other person draws beside you.”
- “Sketch” — opens the split drawing surface for today.

**Split leaf (after “Sketch”, or whenever today already has ink):**
- If yesterday had only one filled half, a banner: “Carried over” / “{name} already sketched. The other half is still open.” That filled half is dimmed and will not take new ink. The other half is still open.
- Two chips, each a color swatch plus the person’s name (defaults “Left” and “Right”, or the names set in People). VoiceOver: “{name}, left half” and “{name}, right half”. Tap a chip to select that half; drawing tools appear for the selected half. Both halves stay visible. VoiceOver on the drawing surfaces: “Left sinopia” and “Right sinopia”.
- A hairline down the middle. A stroke that crosses it leaves a tint on the other half, in that person’s ink.
- Draw with a finger or a stylus. Ink stays the color assigned to that person.
- “Press” pinned at the foot. When it can run, it locks today, may play a haptic if “Haptics” is on, and opens the “Leaves” sheet with the new tile at the top.
- When “Press” cannot run, it stays dimmed and shows one of: “Sketch both halves first.” (no ink yet), “One half is still empty.” (only one side has ink), “This leaf is pressed.” (today is already locked). A pressed leaf will not take new strokes.

If the leaf cannot be read: “The leaf file could not be read.” and “Retry”. If an older good leaf was used instead: “Restored the last good leaf.”

### Leaves
Opened from “Pontata”, or automatically after a successful “Press”. Navigation title: “Leaves”. Trailing “Close” dismisses back to the same leaf.

When the wall has tiles: “Pressed leaves, newest first.” A two-column wall of pressed days, newest first. Each tile is both halves side by side plus a date in the device’s medium date style (for example “Sep 24, 2026” on a US English device). Tap a tile to open “Pressed”.

When nothing has been pressed yet:
- “No pressed leaves.”
- “Press today’s leaf. It lands here, newest first.”
- “Back to the leaf” — dismisses to “Leaf”.

If the wall cannot load: “The wall did not load.” / “The leaf file could not be read.” / “Retry”.

### Pressed
Pushed from a tile. Navigation title: “Pressed”. Title on the page is that day’s medium date, or “Pressed leaf” if the day cannot be shown as a date. The locked split drawing is shown read-only.

“Share” — once the picture is ready, opens the system share sheet with a PNG of that pressed leaf. Until the picture is ready, “Share” is visible but disabled.

The standard back control returns to “Leaves”.

### People
Opened from “Bond”. Navigation title: “People”. Trailing “Close” dismisses to “Leaf”.

When names exist:
- “Who draws each half.”
- Fields “Left name” and “Right name”.
- If either field is blank: “Name both people.”
- “Save” — writes the names. Empty names are allowed; the next open then uses the empty People page.
- Two ink swatches with the current names, then “Swap inks” (the two colors trade). If both inks ever match: “Inks must differ. Swap again.”
- A day count (locale-formatted) plus “day bonded” or “days bonded”. Marks are 7, 30, 90, and 365. Lines the user can see:
  - “Next mark at {n} days.”
  - “No mark yet.”
  - “Marks {list}. Next {n}.”
  - “Marks {list}.”
- A row “Settings” — pushes Settings.
- If the leaf cannot be read: “The leaf file could not be read.” and “Retry”.

When both saved names are empty:
- “Name the pair.”
- “Each person keeps one half and one ink.”
- “Left name”, “Right name”, “Save”.

### Settings
Pushed from “People”. Navigation title: “Settings”.

When preferences are already set:
- “Haptics” — a switch. On by default after introduction. When on, a successful “Press” can play a haptic.
- “Export” / “PNG” / “Pressed leaves share as a PNG.” (readout only; there is no format picker.)
- On Simulator only: “Demo leaves are loaded on Simulator.”
- “Contact” — opens the contact page outside the app.
- “Show introduction” — returns to the four introduction pages.
- “Erase every leaf” — confirmation “Erase every leaf?” / “Pressed leaves and today’s ink are removed.” Buttons: “Erase”, “Cancel”. “Erase” clears every leaf and today’s ink, puts the names back to “Left” and “Right”, and returns to the blank leaf. It does not sign anyone out (there is no account).

When preferences have never been saved:
- “Preferences are unset.”
- “Haptics and PNG export start from here.”
- “Save” — turns haptics on and sets export to PNG.

## Features
- Shared daily leaf for two people on one device
- Split drawing surface; both halves always visible
- “Sketch” on a blank leaf
- Named halves and assigned inks (“Left name”, “Right name”, “Swap inks”)
- Ink that crosses the seam leaves a tint on the other half
- “Undo” peels the newest stroke and its tint together
- “Press” locks the day when both halves hold ink
- “Leaves” wall of pressed days, newest first
- “Pressed” read-only leaf and “Share” as a PNG
- “Carried over” half when only one person drew before the day rolled
- “People” names, inks, and “days bonded” with marks at 7, 30, 90, and 365
- “Settings”: “Haptics”, PNG export readout, “Contact”, “Show introduction”, “Erase every leaf”
- All of this stays on this device unless the person uses “Share”

## Behaviours that can look like bugs
- **“Press” will not run** until both halves hold ink. On a fresh leaf it stays dimmed with “Sketch both halves first.” After only one side is drawn it shows “One half is still empty.” Draw on the empty half, then “Press” enables.
- **After “Press”**, today is locked. The control stays dimmed with “This leaf is pressed.” The halves will not take new ink. The “Leaves” sheet opens on purpose. “Close” or swipe down returns to the same locked leaf.
- **“Undo”** on a blank or already pressed leaf does nothing the person can see. Peel while the leaf is still open and has strokes.
- **Blank leaf before the first stroke:** “Blank leaf.” / “Sketch the first half. The other person draws beside you.” Tap “Sketch” to reach the split surface. This is the first-run and post-erase home, not a broken screen.
- **Empty wall:** “No pressed leaves.” / “Press today's leaf. It lands here, newest first.” Press a finished day, or tap “Back to the leaf”.
- **“Carried over”** is intentional. A day that had only one filled half at midnight comes back the next day with that half dimmed. The other person still draws the open half, then “Press”.
- **“Share”** on “Pressed” can sit disabled for a moment while the PNG is prepared, then it works.
- **“Name both people.”** on People does not block “Save”. Saving two blank names then shows “Name the pair.” Enter names and tap “Save”.
- **“Erase every leaf”** clears drawings and resets names to “Left” and “Right”. The “days bonded” count can then jump to a very large number with “Marks 7, 30, 90, 365.” Opening “Show introduction” and tapping “Start” (or “Skip”) sets a new start of the bond.
- **On Simulator**, a cold launch skips the introduction and already has ink. On a device it does not. That difference is intentional sample content, not a missing screen.

## Starter content and resume
**Device:** none. After introduction the leaf is blank until someone sketches.

**Simulator:** names “Mara” and “Leo”; about ten “days bonded” with “Marks 7. Next 30.”; four pressed leaves on “Leaves”; today’s both halves already inked so “Press” is ready. Settings shows “Demo leaves are loaded on Simulator.”

Unfinished work resumes. Today’s ink is still there after a relaunch. A one-sided day carries to the next leaf under “Carried over”. A pressed day stays locked. “Show introduction” does not throw away leaves.

## Permissions
None. The app never presents a camera, photos, microphone, location, or tracking prompt.

## Absent
Genuinely absent: login or accounts, in-app purchase, ads, analytics, public user-generated content (no feed, comments, or other people’s posts), account deletion flow, App Tracking Transparency prompt.

People do draw private sketches on this device. Those drawings are not posted for anyone else. “Share” is the system share sheet for a PNG the person chooses to send.

## Data and support
Data stays on this device. Nothing is uploaded for an account.

The on-screen control is “Contact” in Settings. It opens the contact page outside the app.

## Scanning and health
None. The app does not scan barcodes or QR codes. It does not show health, medical, or product-health information and has no citations.

## Platform
Copy is English. Dates and numbers follow the device locale; behaviour is the same in every region. Portrait only, full screen. iPhone and iPad. Minimum iOS 17.0. Dark appearance only.

## Category
Lifestyle
