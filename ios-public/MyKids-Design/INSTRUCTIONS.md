# MyKids — Design Handoff for Claude Code

This folder contains the **visual designs and production assets** for the MyKids iOS app, derived from `ios-public/MyKids/DESIGN_SPEC.md` in the source repo.

> **Audience:** Claude Code (and humans). Follow this document end-to-end to wire the assets into the Xcode project and update the SwiftUI views to match the screens.

---

## 1. What's in this folder

```
MyKids-Design/
├── INSTRUCTIONS.md              ← you are here
├── Screens.html                 ← open in a browser: all 14 screens + design system
├── lib/
│   ├── screens.jsx              ← React source for every screen mockup
│   ├── design-canvas.jsx        ← canvas chrome (no app code)
│   └── ios-frame.jsx            ← (unused but available)
└── assets/
    ├── AppIcon.appiconset/      ← drop-in replacement for the Xcode appiconset
    │   ├── Contents.json
    │   ├── Icon-1024.png        ← App Store marketing
    │   ├── Icon-180.png         ← iPhone 60pt @3x
    │   ├── Icon-167.png         ← iPad Pro 83.5pt @2x
    │   ├── Icon-152.png         ← iPad 76pt @2x
    │   ├── Icon-120.png         ← iPhone 60pt @2x / 40pt @3x
    │   ├── Icon-87.png          ← iPhone Settings 29pt @3x
    │   ├── Icon-80.png          ← Spotlight 40pt @2x
    │   ├── Icon-76.png          ← iPad 76pt @1x
    │   ├── Icon-60.png          ← Notification 20pt @3x
    │   ├── Icon-58.png          ← Settings 29pt @2x
    │   ├── Icon-40.png          ← Spotlight 40pt @1x
    │   ├── Icon-29.png          ← Settings 29pt @1x
    │   └── Icon-20.png          ← Notification 20pt @1x
    └── AccentColor.colorset/
        └── Contents.json        ← brand blue, light + dark variants
```

The mockups are **pure SwiftUI/UIKit-native styling** — no custom imagery is needed inside the app. Every icon is an SF Symbol (mapping table below).

---

## 2. How to apply the assets to the Xcode project

The asset catalog lives at `ios-public/MyKids/Assets.xcassets/`. **Replace both sets:**

```bash
# from the repo root
cp -R MyKids-Design/assets/AppIcon.appiconset/   ios-public/MyKids/Assets.xcassets/
cp -R MyKids-Design/assets/AccentColor.colorset/ ios-public/MyKids/Assets.xcassets/
```

That's it for the icon — Xcode picks up `Contents.json` and the PNGs automatically. No additional steps in Xcode.

The accent color is referenced as `Color.accentColor` throughout SwiftUI; the design uses it as the **Primary** brand colour (`#4A90D9` light / `#6FB1ED` dark).

---

## 3. Design tokens (canonical)

Put these in a single `Theme.swift` file (suggested location: `ios-public/MyKids/Theme/Theme.swift`) and reference them everywhere instead of literal values.

### Colors

```swift
import SwiftUI

extension Color {
    // Brand
    static let mkPrimary       = Color("AccentColor")              // #4A90D9 / #6FB1ED dark
    static let mkPrimaryLight  = Color(red: 0.92, green: 0.96, blue: 1.00)   // #EBF4FF

    // Surfaces — adapt automatically with system semantic colors
    static let mkSurface          = Color(.systemBackground)
    static let mkSurfaceSecondary = Color(.secondarySystemBackground)
    static let mkGroupedBg        = Color(.systemGroupedBackground)

    // Text — use semantic
    static let mkTextPrimary   = Color(.label)
    static let mkTextSecondary = Color(.secondaryLabel)
    static let mkTextTertiary  = Color(.tertiaryLabel)

    // Semantic event colors
    static let mkMedicine    = Color(red: 0.00, green: 0.48, blue: 1.00)   // #007AFF
    static let mkTemperature = Color(red: 1.00, green: 0.58, blue: 0.00)   // #FF9500
    static let mkCustom      = Color(red: 0.69, green: 0.32, blue: 0.87)   // #AF52DE
    static let mkSuccess     = Color(red: 0.20, green: 0.78, blue: 0.35)   // #34C759
    static let mkDestructive = Color(.systemRed)
}
```

### Typography — use built-in `Font.*` styles

| Spec name     | SwiftUI                                       | Used for                       |
|---------------|-----------------------------------------------|--------------------------------|
| Large Title   | `.largeTitle.bold()`                          | Nav bar large titles           |
| Title         | `.title.bold()` / `.title2.bold()`            | Empty-state titles             |
| Headline      | `.headline`                                   | Child name, event title        |
| Body          | `.body`                                       | Form fields, descriptions      |
| Subheadline   | `.subheadline`                                | Date labels, secondary info    |
| Caption       | `.caption`                                    | Timestamps, helper             |
| Monospaced    | `.system(size: 24, weight: .bold, design: .monospaced)` | Invite code           |

All sizes scale with Dynamic Type automatically.

### Spacing — 8pt grid

`4, 8, 12, 16, 20, 24, 32, 48` — prefer the higher values for vertical rhythm; cards always sit 16pt from screen edges.

### Shape

| Use                 | Radius / shape          |
|---------------------|-------------------------|
| Cards & sheets      | `cornerRadius(16)` (12 if grouped inside a Form) |
| Full-width buttons  | `cornerRadius(14)`      |
| Chips / pills       | `Capsule()`             |
| Avatars             | `Circle()`              |
| Input fields        | iOS native `.textFieldStyle(.roundedBorder)` or grouped `Form` |

---

## 4. SF Symbol mapping (canonical, no custom assets)

| Where                      | Symbol                              | Color           |
|----------------------------|-------------------------------------|-----------------|
| App identity / Children tab| `figure.2.and.child.holdinghands`   | `.mkPrimary`    |
| Medicine event             | `pill.fill`                         | `.mkMedicine`   |
| Temperature event          | `thermometer.medium`                | `.mkTemperature`|
| Custom event               | `star.fill`                         | `.mkCustom`     |
| Add (toolbar)              | `plus`                              | `.mkPrimary`    |
| Share child                | `square.and.arrow.up`               | `.mkPrimary`    |
| Accept invite              | `person.badge.plus`                 | `.mkPrimary`    |
| Generate invite code       | `link.badge.plus`                   | white on primary|
| Copy invite code           | `doc.on.doc`                        | `.mkPrimary`    |
| Settings tab               | `gearshape`                         | semantic        |
| Sign out                   | `arrow.right.square`                | `.mkDestructive`|
| Event row context menu     | `ellipsis`                          | `.mkTextSecondary`|
| Empty event list           | `tray`                              | `.mkTextTertiary` |
| Day section toggle         | `chevron.down` (rotate when collapsed)| `.mkTextSecondary`|
| Success confirmation       | `checkmark`                         | `.mkSuccess`    |

Render the bigger ones with `.symbolRenderingMode(.hierarchical)` for a softer feel — particularly the welcome-screen family glyph and the empty-state icons.

---

## 5. Screen-by-screen implementation notes

Open `Screens.html` side-by-side while reading. Each screen maps to one SwiftUI file in `Features/`.

### 01 · Welcome — `Features/Welcome/WelcomeView.swift`
- White background. Centered icon block: 132pt rounded-square in `.mkPrimaryLight` with the family SF Symbol at 80pt `.mkPrimary` rendered hierarchically.
- Below: "MyKids" (.largeTitle.bold) + subhead ("Track your children's health events" in `.mkTextSecondary`).
- Bottom stack (24pt gap from edge): **Sign In** (primary filled) → **Create Account** (secondary filled, `.mkSurfaceSecondary` background) → **Continue as Guest** (text-only link in `.mkPrimary`) → 13pt caption explaining guest mode.
- All three buttons height 50, radius 14, full-width minus 16pt inset.

### 02 · Sign In — `Features/Auth/LoginView.swift`
- Presented as `.sheet`. iOS gives the drag handle automatically.
- Navigation title "Sign In", inline. Leading `Cancel`.
- Single inset-grouped `Form` with two rows: email (`.keyboardType(.emailAddress)`, `.textInputAutocapitalization(.never)`) and password (`SecureField`).
- Below the form: full-width **Sign In** primary button; disabled until both fields non-empty.
- Loading state: replace button label with `ProgressView()`, disable form.
- Errors: red `.caption` inline above the button — **not** an alert.
- Footer: "Don't have an account? Create one" — the second half is a tappable `.mkPrimary` link that presents `RegisterView`.

### 03 · Create Account — `Features/Auth/RegisterView.swift`
- Same chrome as Sign In, title "Create Account".
- Two grouped sections: **Your Name** (single optional row) and **Account** (email / password / confirm password).
- Inline validation rules (show only on submit attempt): email format, password ≥ 6 chars, passwords match.
- "Create Account" button disabled until all rules pass.

### 04 · Children List (filled) — `Features/Children/ChildrenListView.swift`
- `NavigationStack` with a large title "My Kids".
- Toolbar: **trailing** `plus` button presenting `AddChildView`; **leading** `person.badge.plus` button presenting `AcceptInviteView` — **hidden when `session.isGuest`**.
- List rendered as a single inset-grouped section. Each row:
  - 48pt circle avatar, `.mkPrimaryLight` background, initial in `.mkPrimary` `.title2.bold()`.
  - Right of avatar: child name (`.headline`) and "Born <date>" (`.caption`, `.mkTextSecondary`).
  - Chevron disclosure (set automatically by `NavigationLink`).
- Swipe actions: leading "Edit" (`.mkPrimary`) opens `AddChildView` pre-filled; trailing "Delete" (`.destructive`) shows a confirmation dialog.
- Pull-to-refresh: `.refreshable { await viewModel.reload() }`.
- Bottom tab bar — see §6.

### 05 · Children List (empty)
- Vertically centered: 60pt family glyph (hierarchical, `.mkTextSecondary`), "No Children Yet" (`.headline`), "Tap + to add your first child" (`.subheadline`, secondary).
- Below, with 24pt gap: **bordered** "Accept Invite" button (1.5pt `.mkPrimary` stroke, radius 14) — **logged-in only**.

### 06 · Add / Edit Child — `Features/Children/AddChildView.swift`
- Sheet with `Cancel` (leading) and bold `Save` (trailing). Save disabled when name empty.
- `Form` → section "CHILD'S NAME" with a `TextField`.
- Below it (no header): a section with `Toggle("Add Birth Date")`; when on, animate in a `DatePicker(..., in: ...Date())` immediately under it (`.easeInOut(0.2)`).
- Editing mode: title becomes "Edit Child" and fields pre-fill from the passed-in `Child`.

### 07 · Events List (filled) — `Features/Events/EventListView.swift`
- Inline title = child's name; back chevron labels "My Kids".
- Toolbar trailing: `plus` (always) + `square.and.arrow.up` (logged-in only).
- **Below the nav bar**: a horizontal `ScrollView` of `Capsule()` chips (Medicine / Temperature / Custom Event). Sticky — sits in a `safeAreaInset(edge: .top)` so it stays put while the list scrolls. Active chip: `.mkPrimary` fill, white text. Inactive: `.mkSurfaceSecondary` fill, primary text. Single-select.
- **List body**: group events by day, in descending order. Day headers say "Today" / "Yesterday" / `MMM d, yyyy` and include a chevron that rotates 90° when collapsed. Today expanded by default; older days collapsed.
- **Event row**:
  - 36pt rounded-rect (radius 9) tint background at 4% opacity around the SF Symbol icon (medicine/thermometer/star), tinted by event-type color.
  - Title comes from the payload:
    - Medicine: `"\(medicineName) — \(dose) \(unit)"`
    - Temperature: `"\(value)°C (\(method))"`
    - Custom: `label`
  - Time: `.caption`, secondary (`h:mm a`).
  - Trailing `ellipsis` button opens a context menu: Edit, Delete.
  - If `notes` are present, tapping the row expands a `.mkSurfaceSecondary` notes block inside the row with `.easeInOut(0.2)`.
- Pull-to-refresh on the list.

### 08 · Events List (empty)
- Same chips bar visible.
- Centered empty state: `tray` SF Symbol (48pt, tertiary), "No Events" (`.headline`), and a subhead that names the active filter ("No Medicine events yet", etc.).

### 09 · Log Event sheet — `Features/Events/AddEventView.swift`
- Sheet titled "Log Event" (or "Edit Event"). Cancel + bold Save.
- Sections, in order:
  1. **EVENT TYPE** — `Picker(.segmented)` Medicine / Temperature / Custom.
  2. **TIME** — `Picker(.segmented)` Now / Custom. When Custom, animate in a `DatePicker` directly under it.
  3. **Dynamic payload section** — title and rows change with type. **Cross-fade with `.easeInOut(0.2)` when the type changes.**
     - Medicine: name, dose (decimal keyboard), unit picker [mg / ml / tablet / cm]
     - Temperature: value °C (decimal keyboard), method picker [Oral / Axillary / Rectal / Forehead]
     - Custom: single "Event label" text field
  4. **NOTES (OPTIONAL)** — multiline `TextEditor`, minimum 3 lines, expandable to ~6.
- Save shows a centered `ProgressView()` overlay while writing.

### 10–11 · Share Child — `Features/Share/ShareChildView.swift`
- Logged-in only sheet, title "Share <name>", trailing bold `Done`.
- **Before**: short explainer paragraph (`.subheadline` secondary), then a single primary button labelled "Generate Invite Code" with the `link.badge.plus` SF Symbol. Below a separator: tiny caption "Each code is single-use and expires in 7 days."
- **After**: replace the button with a `.mkSurfaceSecondary` rounded box (radius 16, 36pt vertical padding) containing the code in **monospaced 28pt bold with 4pt tracking**, formatted as `AB3D 5FGH` (space in the middle is purely visual). Below the box: tiny "Expires <date>" caption.
- Two stacked CTAs below the box:
  1. **Copy Code** — bordered (`.mkPrimary` 1.5pt stroke) with `doc.on.doc` icon. On tap, copy to clipboard, change label to **"Copied!"** with a green checkmark for 2s using a spring animation, then revert.
  2. **Share via…** — `.borderedProminent` filled with `square.and.arrow.up` icon, triggers iOS native `ShareLink` with a pre-written message.

### 12 · Accept Invite — `Features/Share/AcceptInviteView.swift`
- Logged-in only. Sheet. Cancel + title "Accept Invite".
- Short explainer + a single monospaced `TextField` (placeholder `e.g. AB3D5FGH`). `.textInputAutocapitalization(.characters)`, strip spaces on input.
- **Join** primary button disabled until input is ≥ 6 chars.
- On error, show inline red `.caption` above the button (`Code not found`, `Code already used`, `Code expired`).
- On success, dismiss the sheet — the new child appears in the list automatically via the view-model refresh.

### 13 · Settings — Logged-in — `Features/Settings/SettingsView.swift`
- Large title "Settings".
- **ACCOUNT** section: two read-only rows (Name, Email) shown with right-aligned `.secondary` value style.
- A separate section containing a single destructive **Sign Out** row: `arrow.right.square` symbol + red label. Tap → `.confirmationDialog` ("You will need to sign in again. Local data stays on the device.").
- **ABOUT** section: "Version 1.0".

### 14 · Settings — Guest
- **MODE** section: a single card-style row — `person` SF Symbol in `.mkPrimaryLight` square, "Guest Mode" headline, and a `.caption` explainer.
- Below it, two `NavigationLink` rows pushing the Login and Register screens (not modal — push transitions).
- **ABOUT** section: same Version row.

---

## 6. The shared tab bar

Both top-level screens (`ChildrenListView`, `SettingsView`) live inside a `TabView` defined in `RootView.swift`. The system tab bar is fine — don't custom-render it. Tabs:

```swift
TabView {
    NavigationStack { ChildrenListView() }
        .tabItem { Label("Children", systemImage: "figure.2.and.child.holdinghands") }
    NavigationStack { SettingsView() }
        .tabItem { Label("Settings", systemImage: "gearshape") }
}
.tint(.mkPrimary)
```

The tab bar is **hidden during onboarding** (Welcome screen) — driven by `AppSession.mode`.

---

## 7. Animations (canonical)

| Trigger                          | Animation                          |
|----------------------------------|------------------------------------|
| Event type segmented change      | `.easeInOut(duration: 0.2)` cross-fade on payload section |
| Day section expand / collapse    | `.easeInOut(duration: 0.2)`        |
| Notes expand inside event row    | `.easeInOut(duration: 0.2)`        |
| Filter chip selection            | `.spring(response: 0.3)`           |
| "Copied!" confirmation           | `.spring(response: 0.35, dampingFraction: 0.6)` scale + color swap |
| Birth-date `DatePicker` reveal   | `.easeInOut(duration: 0.2)`        |
| Sheets, push nav                 | iOS defaults — don't override      |

---

## 8. Accessibility checklist

- [ ] Every interactive control has an `.accessibilityLabel` (icons-only buttons especially: `+`, ellipsis, share, copy).
- [ ] Event row reads as `"<Type>, <summary>, <time>"` to VoiceOver — set `.accessibilityElement(children: .combine)` and an explicit label.
- [ ] No color-only signal — every event-type tint is paired with its SF Symbol.
- [ ] All tappable targets ≥ 44×44pt.
- [ ] Dynamic Type: don't hardcode font sizes; use built-in `Font` styles.
- [ ] Dark mode: use semantic colors (`.label`, `.systemBackground`) for everything except the brand blue accent which has its own dark variant in the asset catalog.

---

## 9. Definition of done

1. App icon shows the new family glyph on the home screen (light + dark wallpapers).
2. All 14 screens visually match `Screens.html` at iPhone 15 size.
3. Empty states render the SF Symbol + headline + helper text exactly as specified.
4. Logged-in vs. guest mode hides/shows the share-related affordances correctly.
5. Pulled-to-refresh on both Children and Events lists.
6. Dark mode looks intentional (semantic colors do most of the work; verify on a real device).
7. VoiceOver pass on Events list reads coherent event summaries.

---

*If anything in `DESIGN_SPEC.md` contradicts this document, the spec wins — file a note and ask before changing the design.*
