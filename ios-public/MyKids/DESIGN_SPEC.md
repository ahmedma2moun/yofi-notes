# MyKids — UX & Design Specification

## Overview

**MyKids** is a child health event tracker for parents and caregivers. It lets parents log medicine doses, temperature readings, and custom health events for each of their children. The app works in two modes:

- **Guest Mode** — no account required, all data stored on-device only.
- **Logged-in Mode** — data synced to the cloud, multiple co-parents can share a child's profile.

**Platform:** iOS 17+, iPhone primary, iPad supported  
**Tone:** Warm, calm, trustworthy. Parents are using this in stressful moments (sick child at 2 AM). The UI must be fast, clear, and low-friction.  
**Visual language:** Soft rounded shapes, gentle color palette, generous white space. Not clinical — feels like a caring tool, not a medical record system.

---

## Navigation Architecture

```
App Launch
  └── Welcome Screen (first launch only)
        ├── Sign In → Login Screen
        ├── Create Account → Register Screen
        └── Continue as Guest
              │
              ▼
        ┌─────────────────────────────────┐
        │         Main Tab Bar            │
        │  [Children Tab]  [Settings Tab] │
        └─────────────────────────────────┘
              │
    Children Tab
        └── Children List Screen
              └── tap child → Child Events Screen
                    ├── tap + → Add/Edit Event Sheet
                    └── share icon → Share Child Sheet (logged-in only)
                          └── Accept Invite Sheet
```

---

## Design System

### Color Palette

| Token | Usage | Suggested Value |
|---|---|---|
| `Primary` | Buttons, active states, accents | Soft blue `#4A90D9` |
| `Primary Light` | Avatar backgrounds, chip fills | `#EBF4FF` |
| `Surface` | Card backgrounds | White / system background |
| `Surface Secondary` | Inactive chips, secondary fields | `#F2F2F7` |
| `Text Primary` | Main labels | `#1C1C1E` |
| `Text Secondary` | Subtitles, hints, metadata | `#8E8E93` |
| `Destructive` | Delete actions, errors | `#FF3B30` |
| `Medicine` | Medicine event icon | `#007AFF` (blue) |
| `Temperature` | Temperature event icon | `#FF9500` (orange) |
| `Custom` | Custom event icon | `#AF52DE` (purple) |
| `Success` | Copied confirmation, invite accepted | `#34C759` (green) |

> Support both Light and Dark mode. All surfaces and text should adapt automatically using iOS semantic colors.

### Typography

| Style | Font | Size | Weight | Usage |
|---|---|---|---|---|
| `Large Title` | SF Pro | 34pt | Bold | Welcome screen app name |
| `Title` | SF Pro | 28pt | Bold | Screen titles |
| `Headline` | SF Pro | 17pt | Semibold | Child name in list, event title |
| `Body` | SF Pro | 17pt | Regular | Form fields, descriptions |
| `Subheadline` | SF Pro | 15pt | Regular | Secondary info, date labels |
| `Caption` | SF Pro | 13pt | Regular | Timestamps, helper text |
| `Monospaced` | SF Mono | 24pt | Bold | Invite code display |

### Spacing

Use an 8pt grid throughout. Common values: 8, 12, 16, 20, 24, 32, 48.

### Shape

- Cards and sheets: `cornerRadius = 16`
- Buttons: `cornerRadius = 14` (full-width), `Capsule` (chips/pills)
- Avatars: `Circle`
- Input fields: Use iOS native `Form` / `TextField` which auto-style correctly.

### Iconography

Use SF Symbols throughout. Key icons:

| Symbol | Usage |
|---|---|
| `figure.2.and.child.holdinghands` | App icon, children tab |
| `pill.fill` | Medicine events |
| `thermometer.medium` | Temperature events |
| `star.fill` | Custom events |
| `person.badge.plus` | Share / accept invite |
| `gear` | Settings tab |
| `plus` | Add actions (toolbar) |
| `ellipsis` | Event row context menu |
| `chevron.up/down` | Expand/collapse sections |
| `doc.on.doc` | Copy invite code |
| `square.and.arrow.up` | Share sheet |
| `checkmark` | Success state |
| `arrow.right.square` | Sign out |
| `tray` | Empty state |
| `link.badge.plus` | Generate invite code |

---

## Screens

---

### 1. Welcome Screen

**File:** `Features/Welcome/WelcomeView.swift`  
**Shown:** First launch only. After the user picks a mode, this screen is never shown again unless they sign out.

#### Layout

```
┌─────────────────────────────┐
│                             │
│         (spacer)            │
│                             │
│   [icon: figure.2.and.      │
│    child.holdinghands]      │
│      80pt, blue,            │
│      hierarchical rendering │
│                             │
│     "MyKids"                │
│   [Large Title, bold]       │
│                             │
│  "Track your children's     │
│   health events"            │
│   [subheadline, secondary]  │
│                             │
│         (spacer)            │
│                             │
│  ┌─────────────────────┐   │
│  │      Sign In        │   │  ← Primary filled button
│  └─────────────────────┘   │
│  ┌─────────────────────┐   │
│  │   Create Account    │   │  ← Secondary filled button (surface bg)
│  └─────────────────────┘   │
│                             │
│    Continue as Guest        │  ← Text button, secondary color
│                             │
│  "Guest mode saves data on  │
│   this device only. Sign in │
│   to sync and share."       │  ← Caption, secondary, centered
│                             │
│      (bottom padding)       │
└─────────────────────────────┘
```

#### Interactions
- Tapping **Sign In** → presents `LoginView` as a sheet
- Tapping **Create Account** → presents `RegisterView` as a sheet
- Tapping **Continue as Guest** → dismisses to `Children List` immediately (no animation delay)
- After successful login/register from the sheets → `WelcomeView` automatically replaced by `Children List` (driven by `AppSession.mode` change)

#### States
- Single static state — no loading, no empty state needed.

---

### 2. Login Screen

**File:** `Features/Auth/LoginView.swift`  
**Presented as:** Modal sheet over Welcome screen.

#### Layout

```
┌─────────────────────────────┐
│  [Cancel]       Sign In     │  ← Navigation bar
├─────────────────────────────┤
│                             │
│  ┌─────────────────────┐   │
│  │  Email              │   │  ← TextField, email keyboard
│  │  Password           │   │  ← SecureField
│  └─────────────────────┘   │
│                             │
│  [error message if any]     │  ← Red text, small
│                             │
│  ┌─────────────────────┐   │
│  │      Sign In        │   │  ← Button, disabled when empty
│  └─────────────────────┘   │
│                             │
│  ──────── (spacer) ──────── │
│                             │
│  Don't have an account?     │
│  [Create one]               │  ← tappable, opens RegisterView
└─────────────────────────────┘
```

#### States
- **Default:** Fields empty, button disabled.
- **Filled:** Button enabled.
- **Loading:** Button replaced by `ProgressView`, fields not interactive.
- **Error:** Inline red error message below the fields section (e.g. "Invalid credentials").
- **Success:** Sheet dismisses automatically, app transitions to Children List.

#### Interactions
- "Create one" link → presents `RegisterView` as a sheet (on top, or replaces current sheet)
- Keyboard: `Return` on password field triggers login
- Dismiss via drag-down cancels with no side effect

---

### 3. Register Screen

**File:** `Features/Auth/RegisterView.swift`  
**Presented as:** Modal sheet.

#### Layout

```
┌─────────────────────────────┐
│  [Cancel]   Create Account  │
├─────────────────────────────┤
│                             │
│  YOUR NAME                  │
│  ┌─────────────────────┐   │
│  │  Full name (optional)│   │
│  └─────────────────────┘   │
│                             │
│  ACCOUNT                    │
│  ┌─────────────────────┐   │
│  │  Email              │   │
│  │  Password (min 6)   │   │
│  │  Confirm Password   │   │
│  └─────────────────────┘   │
│                             │
│  [error message if any]     │
│                             │
│  ┌─────────────────────┐   │
│  │   Create Account    │   │
│  └─────────────────────┘   │
└─────────────────────────────┘
```

#### Validation Rules (inline, show only on submit attempt)
- Email must be valid format
- Password minimum 6 characters
- Passwords must match — show "Passwords do not match" if they differ
- Create Account button disabled until: email non-empty + password ≥ 6 chars + passwords match

#### States
- Same loading/error/success pattern as Login.

---

### 4. Children List Screen

**File:** `Features/Children/ChildrenListView.swift`  
**Tab:** "Children" (tab 1, leftmost)

#### Layout — Filled State

```
┌─────────────────────────────┐
│ [⊕ Accept Invite]  My Kids  [+]│  ← Nav bar. Accept Invite only if logged in
├─────────────────────────────┤
│                             │
│  ┌───────────────────────┐  │
│  │  [A]  Adam            │  │  ← Child row (see component below)
│  │       Born Mar 5 2021 │  │
│  └───────────────────────┘  │
│  ┌───────────────────────┐  │
│  │  [L]  Lena            │  │
│  │       Born Aug 12 2023│  │
│  └───────────────────────┘  │
│                             │
│  (pull to refresh)          │
└─────────────────────────────┘
```

#### Child Row Component

```
┌─────────────────────────────────────┐
│  ┌────┐                             │
│  │ A  │  Adam                       │  ← Initial letter avatar
│  │    │  Born March 5, 2021         │  ← Birth date (if set), caption
│  └────┘                             │
└─────────────────────────────────────┘
```

- Avatar: 48×48pt circle, `Primary Light` background, child's first initial in `Primary` color, title2 bold.
- Child name: headline weight.
- Birth date: caption, secondary color. Hidden if not set.
- The entire row is a `NavigationLink` → taps open `EventListView` for that child.
- **Swipe left** on a row reveals: **Edit** (blue) and **Delete** (red) actions.

#### Layout — Empty State

```
┌─────────────────────────────┐
│           My Kids      [+]  │
├─────────────────────────────┤
│                             │
│                             │
│   [figure.2.and.child       │
│    .holdinghands icon]      │
│      60pt, secondary        │
│                             │
│     No Children Yet         │
│   [headline]                │
│                             │
│  Tap + to add your first    │
│  child                      │
│  [subheadline, secondary]   │
│                             │
│   ┌──────────────────┐     │
│   │  Accept Invite   │     │  ← bordered button, logged-in only
│   └──────────────────┘     │
│                             │
└─────────────────────────────┘
```

#### Interactions
- `+` toolbar button → presents `AddChildView` as a sheet
- Accept Invite (nav bar leading, or empty state button) → presents `AcceptInviteView` as a sheet. **Logged-in only — hidden in guest mode.**
- Swipe → Edit → presents `AddChildView` pre-filled
- Swipe → Delete → confirmation dialog → deletes child and all its events
- Pull-to-refresh → reloads from backend (logged-in) or local store (guest)

---

### 5. Add / Edit Child Sheet

**File:** `Features/Children/AddChildView.swift`  
**Presented as:** Modal sheet.

#### Layout

```
┌─────────────────────────────┐
│  [Cancel]    Add Child [Save]│
├─────────────────────────────┤
│                             │
│  CHILD'S NAME               │
│  ┌─────────────────────┐   │
│  │  Name               │   │
│  └─────────────────────┘   │
│                             │
│  ┌─────────────────────┐   │
│  │  Add Birth Date  [toggle]│
│  │  ─────────────────  │   │  ← DatePicker shown when toggle is ON
│  │  Birth Date   [date]│   │
│  └─────────────────────┘   │
│                             │
└─────────────────────────────┘
```

- When editing, title changes to "Edit Child" and fields are pre-filled.
- **Save** button is disabled if name is empty.
- DatePicker limited to past dates only (cannot set a future birth date).
- Toggle animates the DatePicker in/out smoothly.

---

### 6. Child Events Screen

**File:** `Features/Events/EventListView.swift`  
**Pushed onto:** Navigation stack from Children List.

#### Layout — Filled State

```
┌─────────────────────────────┐
│  [< My Kids]  Adam   [+][⊕]│  ← Share icon only if logged-in
├─────────────────────────────┤
│ [Medicine] [Temperature]    │  ← Horizontal filter chip bar
│ [Custom Event]              │     sticky below nav bar
├─────────────────────────────┤
│                             │
│  TODAY          [chevron ▼] │  ← Day section header (collapsible)
│  ┌───────────────────────┐  │
│  │  💊  Panadol — 250mg  │  ●  ← Event row
│  │      2:30 PM          │  │
│  │                    ···│  │  ← context menu trigger (ellipsis)
│  └───────────────────────┘  │
│  ┌───────────────────────┐  │
│  │  🌡  38.5°C (Oral)    │  │
│  │      11:15 AM         │  │
│  │                    ···│  │
│  └───────────────────────┘  │
│                             │
│  YESTERDAY      [chevron ▼] │
│  ...                        │
│                             │
│  (pull to refresh)          │
└─────────────────────────────┘
```

#### Filter Chip Bar
- Horizontally scrollable row of chips, one per event type (Medicine, Temperature, Custom Event).
- Only one chip active at a time (single select).
- Active chip: filled `Primary` background, white text.
- Inactive chip: `Surface Secondary` background, primary text.
- Pill / capsule shape.
- Sticky — stays visible when scrolling the list.

#### Day Section Headers
- Show "Today", "Yesterday", or formatted date (e.g. "May 20, 2026").
- Tapping the header expands or collapses that day's events with a smooth animation.
- Today's section starts expanded by default; previous days start collapsed.
- Chevron icon rotates to indicate state.

#### Event Row Component

```
┌──────────────────────────────────┐
│  [icon]  Title (payload summary) │  ···
│          Time (e.g. 2:30 PM)     │
│  ─────────────────────────────── │  ← expands if notes exist
│  [notes text]                    │
└──────────────────────────────────┘
```

- Icon: SF Symbol colored by event type (blue for medicine, orange for temp, purple for custom). 36pt frame.
- Title: computed from payload (e.g. "Panadol — 250 mg", "38.5°C (Oral)", "Vomiting").
- Time: caption, secondary.
- Notes: expandable by tapping the row. Only shows chevron if notes exist.
- `···` (ellipsis) on the right → context menu with **Edit** and **Delete**.

#### Layout — Empty State

```
┌─────────────────────────────┐
│  [< My Kids]  Adam    [+]   │
├─────────────────────────────┤
│ [Medicine] [Temperature]    │
│ [Custom Event]              │
├─────────────────────────────┤
│                             │
│    [tray icon]              │
│    48pt, secondary          │
│                             │
│    No Events                │
│    [headline]               │
│                             │
│  No Medicine events yet     │
│  [subheadline, secondary]   │
│                             │
└─────────────────────────────┘
```

---

### 7. Add / Edit Event Sheet

**File:** `Features/Events/AddEventView.swift`  
**Presented as:** Modal sheet.

#### Layout

```
┌─────────────────────────────┐
│  [Cancel]  Log Event  [Save]│
├─────────────────────────────┤
│                             │
│  EVENT TYPE                 │
│  [Medicine][Temperature]    │  ← Segmented picker
│  [Custom Event]             │
│                             │
│  TIME                       │
│  [Now        ][Custom]      │  ← Segmented picker
│  [DatePicker if Custom]     │
│                             │
│  ── Dynamic section ──────  │
│                             │
│  If Medicine:               │
│    MEDICINE                 │
│    ┌────────────────────┐   │
│    │ Medicine name      │   │
│    │ Dose (decimal)     │   │
│    │ Unit [mg▾]         │   │  ← Picker: mg, ml, tablet, cm
│    └────────────────────┘   │
│                             │
│  If Temperature:            │
│    TEMPERATURE              │
│    ┌────────────────────┐   │
│    │ Value (°C)         │   │
│    │ Method [Oral▾]     │   │  ← Picker: Oral, Axillary, Rectal, Forehead
│    └────────────────────┘   │
│                             │
│  If Custom:                 │
│    CUSTOM EVENT             │
│    ┌────────────────────┐   │
│    │ Event label        │   │
│    └────────────────────┘   │
│                             │
│  NOTES (OPTIONAL)           │
│  ┌────────────────────┐     │
│  │ Notes...           │     │  ← Multiline, 3–6 lines
│  └────────────────────┘     │
│                             │
└─────────────────────────────┘
```

- Event Type segmented control switches the dynamic section with an animated transition.
- Time defaults to "Now" (no picker shown). Selecting "Custom" slides in the DatePicker.
- Save button shows a `ProgressView` overlay while saving.
- When editing, title becomes "Edit Event" and all fields pre-fill.
- Payload fields are optional — user can save with just the type selected.

---

### 8. Share Child Sheet

**File:** `Features/Share/ShareChildView.swift`  
**Presented as:** Modal sheet from the Events screen toolbar.  
**Availability:** Logged-in users only.

#### Layout — Before Generating Code

```
┌─────────────────────────────┐
│          Share Adam    [Done]│
├─────────────────────────────┤
│                             │
│  Share Adam's profile with  │
│  another parent. They'll be │
│  able to view and add       │
│  health events.             │
│  [secondary, small]         │
│                             │
│  INVITE CODE                │
│  ┌─────────────────────┐   │
│  │  Generate Invite    │   │  ← Button with link.badge.plus icon
│  │       Code          │   │
│  └─────────────────────┘   │
│                             │
│  ─────────────────────────  │
│  Each code is single-use    │
│  and expires in 7 days.     │
│  [caption, secondary]       │
└─────────────────────────────┘
```

#### Layout — After Generating Code

```
┌─────────────────────────────┐
│          Share Adam    [Done]│
├─────────────────────────────┤
│                             │
│  INVITE CODE                │
│  ┌─────────────────────┐   │
│  │                     │   │
│  │    AB3D 5FGH         │   │  ← Monospaced bold, 24pt, tracking +4
│  │                     │   │     Surface Secondary background, rounded
│  └─────────────────────┘   │
│                             │
│  Expires May 30, 2026       │  ← caption, secondary
│                             │
│  ┌─────────────────────┐   │
│  │ 📋  Copy Code       │   │  ← bordered button
│  └─────────────────────┘   │
│  ┌─────────────────────┐   │
│  │ ↑  Share via…       │   │  ← borderedProminent (filled primary)
│  └─────────────────────┘   │  ← iOS native ShareSheet
│                             │
└─────────────────────────────┘
```

#### Interactions
- **Generate** button shows `ProgressView` while the API call runs.
- **Copy Code** → copies code to clipboard + button label briefly changes to "Copied!" with a green checkmark for 2 seconds, then resets.
- **Share via…** → triggers iOS native share sheet with a pre-written message containing the code.
- Only one code visible at a time. Tapping Generate again would create a new code (consider adding a "Regenerate" label on second press).

---

### 9. Accept Invite Sheet

**File:** `Features/Share/AcceptInviteView.swift`  
**Presented as:** Modal sheet.  
**Availability:** Logged-in users only.

#### Layout

```
┌─────────────────────────────┐
│  [Cancel]   Accept Invite   │
├─────────────────────────────┤
│                             │
│  Enter the invite code      │
│  shared by another parent.  │
│  [secondary, small]         │
│                             │
│  INVITE CODE                │
│  ┌─────────────────────┐   │
│  │  e.g. AB3D5FGH      │   │  ← Monospaced font, auto-capitalizes
│  └─────────────────────┘   │
│                             │
│  [error if invalid code]    │
│                             │
│  ┌─────────────────────┐   │
│  │        Join         │   │  ← Disabled until ≥ 6 chars entered
│  └─────────────────────┘   │
│                             │
└─────────────────────────────┘
```

#### Interactions
- Input auto-capitalizes and strips spaces.
- Join button disabled until at least 6 characters entered.
- On success → sheet dismisses, new child appears in the Children List.
- Error cases: "Code not found", "Code already used", "Code expired" — shown inline in red.

---

### 10. Settings Screen

**File:** `Features/Settings/SettingsView.swift`  
**Tab:** "Settings" (tab 2, rightmost)

#### Layout — Logged-in User

```
┌─────────────────────────────┐
│           Settings          │
├─────────────────────────────┤
│                             │
│  ACCOUNT                    │
│  ┌─────────────────────┐   │
│  │  Name        Ahmed  │   │
│  │  Email   a@test.com │   │
│  └─────────────────────┘   │
│                             │
│  ┌─────────────────────┐   │
│  │  🔴 Sign Out        │   │  ← Destructive red
│  └─────────────────────┘   │
│                             │
│  ABOUT                      │
│  ┌─────────────────────┐   │
│  │  Version      1.0   │   │
│  └─────────────────────┘   │
│                             │
└─────────────────────────────┘
```

#### Layout — Guest User

```
┌─────────────────────────────┐
│           Settings          │
├─────────────────────────────┤
│                             │
│  MODE                       │
│  ┌─────────────────────┐   │
│  │  👤 Guest Mode      │   │
│  │  Your data is on    │   │
│  │  this device only.  │   │
│  └─────────────────────┘   │
│                             │
│  ┌─────────────────────┐   │
│  │  Sign In  ›         │   │  ← NavigationLink
│  │  Create Account ›   │   │  ← NavigationLink
│  └─────────────────────┘   │
│                             │
│  ABOUT                      │
│  ┌─────────────────────┐   │
│  │  Version      1.0   │   │
│  └─────────────────────┘   │
│                             │
└─────────────────────────────┘
```

#### Interactions
- **Sign Out** → confirmation dialog ("You will need to sign in again…") → on confirm, clears session, navigates back to Welcome screen.
- **Sign In / Create Account** links (guest mode) → push Login or Register as navigation destinations.

---

## Shared Components

### Loading States
- Full-screen `ProgressView("Loading…")` shown only when the list is empty and loading for the first time.
- For mutations (save, delete), show a `ProgressView` overlay centered on screen.
- Pull-to-refresh does not show the full-screen loader.

### Error States
- Errors from API calls shown as an `.alert` with an "OK" dismiss button.
- Inline validation errors (forms) shown as red text within the form, not alerts.

### Empty States
- Each list screen has a custom empty state with an icon, title, and helper text.
- No generic "Something went wrong" placeholders — always explain what the user can do next.

### Confirmation Dialogs
- Destructive actions (delete child, delete event, sign out) always require a `.confirmationDialog` with a cancel option.
- Dialog message explains the consequence (e.g. "All events for this child will be deleted. This cannot be undone.").

---

## Gestures & Animations

| Interaction | Animation |
|---|---|
| Event type switch in Add Event | `.easeInOut(0.2)` cross-fade of payload section |
| Day section expand/collapse | `.easeInOut(0.2)` |
| Event notes expand | `.easeInOut(0.2)` |
| Filter chip selection | `.spring(response: 0.3)` on background fill |
| "Copied!" confirmation | `.spring` scale + color change |
| Sheet presentation | Default iOS modal transition |
| Navigation push | Default iOS slide |

---

## Accessibility

- All interactive elements have clear accessibility labels.
- Color is never the only way to convey information (icons always accompany color).
- Minimum touch target: 44×44pt.
- Dynamic Type: all text uses standard SF Pro styles that scale with system font size.
- VoiceOver: event rows should read as "[Type], [summary], [time]".

---

## Data Model Reference (for design context)

### Child
- `name`: String (required)
- `birthDate`: Date? (optional)

### HealthEvent
- `type`: Medicine | Temperature | Custom
- `occurredAt`: Date
- `notes`: String? (optional)
- `payload`:
  - Medicine: `medicineName`, `doseMg` (number), `unit` (mg/ml/tablet/cm)
  - Temperature: `valueCelsius` (number), `method` (oral/axillary/rectal/forehead)
  - Custom: `label` (string)

---

## User Flows

### Flow 1 — First-time guest user adds a medicine event

1. App opens → Welcome Screen
2. Tap "Continue as Guest"
3. Children List (empty state)
4. Tap `+` → Add Child Sheet
5. Enter child's name, optionally add birth date, tap Save
6. Child appears in list → tap it
7. Events Screen (empty, Medicine filter active)
8. Tap `+` → Add Event Sheet
9. Select Medicine, enter name & dose, tap Save
10. Event appears in the list

### Flow 2 — Returning logged-in user shares a child with co-parent

1. App opens → Children List (direct, no Welcome)
2. Tap child → Events Screen
3. Tap share icon (top-right)
4. Share Child Sheet → tap "Generate Invite Code"
5. Code appears (e.g. AB3D5FGH)
6. Tap "Share via…" → sends message with code to co-parent

### Flow 3 — Co-parent accepts invite

1. App opens → (if first time) Welcome → Create Account
2. Children List (empty, with Accept Invite button)
3. Tap Accept Invite
4. Enter code from co-parent → tap Join
5. Child appears in their Children List
6. They can now view and add events for that child

### Flow 4 — Guest user upgrades to account

1. Guest user is on Settings tab
2. Sees "Guest Mode" section → taps "Create Account"
3. Fills in Register form → taps Create Account
4. Account created, session switches to logged-in
5. Existing local (guest) data remains on device — the new account starts fresh on the server
   *(Note for engineering: consider adding a "migrate guest data" flow in a future version)*
