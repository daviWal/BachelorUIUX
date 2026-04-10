# BachelorUIUX — App Documentation

**Version:** 1.0
**Platform:** iOS (iPhone)
**Tech Stack:** Swift 5.0 / SwiftUI
**Minimum iOS:** 26.2

---

## 1. Purpose of the App (Research Context)

This app is a **controlled research instrument** built for a bachelor thesis on mobile navigation usability across generations. It is explicitly not a product — it has no real users, no backend, and no production purpose.

**Research goal:** Enable a direct, side-by-side comparison of three mobile navigation paradigms under identical content and task conditions, across two age groups:
- **Generation Z** (approx. 18–27)
- **Users aged 50–65**

**What is being tested:**
Navigation structure and discoverability — not visual aesthetics, branding, or content quality. All three variants present identical screens and identical content. The only variable is *how* the user navigates between them.

**Connection to the research question:**
The thesis investigates how age influences navigation strategy, perceived clarity, task confidence, and frustration when using different mobile navigation patterns. The app produces both descriptive data (time-on-variant) and supports qualitative observation (think-aloud, moderator notes).

---

## 2. Functional Scope

### What the app does
- Presents three distinct navigation variants, each routing to the same set of target screens
- Tracks time spent inside each variant per participant
- Provides a moderator interface for session management, labeling, and CSV export
- Resets cleanly between participants

### What the app does NOT do
- No real backend, no authentication, no persistent user accounts
- No real data behind Items, Profile, Settings, or Help — all content is placeholder
- No automatic task detection (e.g. no recognition of "task completed")
- No audio or screen recording (handled externally by the moderator)
- No Android or web version

### Supported platform
- iPhone, portrait orientation
- iOS simulator supported for development; all user testing must be conducted on a real iPhone device (gesture behavior can differ on simulator)

---

## 3. Navigation Concepts Implemented

Each variant is a self-contained SwiftUI container. All three share the same destination screens and labels.

### Version 1 — Hamburger Menu (`BurgerContentView`)

A toolbar icon (`≡`, `line.3.horizontal`) in the top-right corner reveals a drop-down menu listing all five screens. Navigation happens by tapping a menu item.

**Why chosen:**
The hamburger menu is one of the most debated patterns in mobile UX. It is prevalent in older web-to-mobile transitions but has been criticized for hiding navigation from users who do not know to look for it. It is particularly relevant to include because the icon is not self-explanatory to all age groups.

**Expected hypothesis:**
Older participants may struggle to locate the hamburger icon or understand it as a navigation trigger. Gen Z users are likely more familiar with it from prior app experience.

**Hidden navigation layer:**
In addition to the menu, a horizontal swipe gesture navigates between Home, Items, and Profile (but not Help or Settings). This gesture is not indicated anywhere on screen, making it a non-obvious secondary navigation path. Its presence allows observation of whether participants accidentally or intentionally discover it.

---

### Version 2 — Tab Bar (`TabBarContentView`)

Five tabs are permanently visible at the bottom of the screen, each labeled with both an icon and a text label: Home, Items, Profile, Help, Settings.

**Why chosen:**
Bottom navigation with visible text labels is the most widely recommended pattern for broad usability. It keeps all primary destinations visible at all times, which reduces cognitive load and eliminates the need to discover navigation. iOS Human Interface Guidelines endorse this as the default pattern for apps with multiple primary sections.

**Expected hypothesis:**
This variant is expected to produce the shortest task times and highest confidence across both age groups, particularly for the 50–65 group, because all options are always visible. Gen Z users should also perform well but may find it less novel.

**Hidden navigation layer:**
A horizontal swipe gesture also switches tabs, consistent with the other two variants.

---

### Version 3 — Content-based / Direct Navigation (`MainMenuContentView`)

Navigation is driven by large tappable buttons on the home screen. The home screen displays four buttons — Items, Profile, Help, Settings — each with an icon and full text label. A back chevron in the top toolbar returns to the home screen from any destination.

**Why chosen:**
This pattern is the most literal and visible: every navigation option is represented as a button on screen. It requires no learned icon vocabulary and makes navigation explicit. It resembles older-style app menus and simple kiosk-type interfaces.

**Expected hypothesis:**
This pattern is expected to be most accessible to the 50–65 group for tasks that start from home, as all options are immediately visible. However, it may create friction for returning to home mid-task, and the back button in the toolbar may not always be noticed.

**Hidden navigation layer:**
Same horizontal swipe gesture applies (clamped to Home, Items, Profile only).

---

### Hidden Gesture Navigation (all variants)

All three variants include a horizontal `DragGesture` that allows swiping between screens without using the visible navigation controls. The gesture is not indicated anywhere in the UI.

**Minimum distances:** 30px (Version 1), 20px (Versions 2 and 3)
**Threshold for trigger:** 50px horizontal translation
**Scope:** Cycles through Home → Items → Profile only (not Help or Settings)

**Research relevance:**
This allows observation of whether participants from either age group spontaneously discover or attempt gesture navigation when they are stuck or uncertain. Discovery of this gesture can be logged as a qualitative observation event.

---

## 4. Information Architecture

All three navigation variants give access to the same five screens:

```
┌─────────────────────────────────────────────────┐
│              Test Selection Screen               │
│         (Version 1 / Version 2 / Version 3)      │
└──────────┬──────────────┬──────────────┬─────────┘
           │              │              │
     Version 1       Version 2      Version 3
     (Burger)        (Tab Bar)     (Main Menu)
           │              │              │
           └──────────────┴──────────────┘
                          │
           ┌──────────────┼───────────────────┐
           │              │                   │
         Home           Items             Profile
                          │                   │
                       Detail              Edit Profile (sheet)
                      (per item)           Account Settings (alert)
                                           Notifications (alert)
                                           Privacy (alert)
                                           Help & Support (alert)
           │
         Help
           │
        Settings
```

**Key principle:** Every target screen is reachable through every navigation variant. The path differs; the destination does not.

**Detail View:** Accessible only from Items, via a `NavigationLink` list. Shares the `NavigationStack` of the active container.

**Profile interactions:** Edit Profile opens a full sheet with editable name and email fields. All other profile rows (Account Settings, Notifications, Privacy, Help & Support) show an alert confirming the tap — they are intentionally not implemented as these features are outside the scope of the study.

---

## 5. Task Design

The following tasks are recommended for participant sessions. Each task has an identical start point (the relevant version's home screen) and a clearly defined success state.

| # | Task | Start | Target | Notes |
|---|---|---|---|---|
| 1 | Find the Help section | Home | Help screen visible | Tests primary navigation discoverability |
| 2 | Open Settings | Home | Settings screen visible | Tests whether all destinations are findable |
| 3 | Open your Profile | Home | Profile screen visible | Most prominent target across all variants |
| 4 | Open the detail view of any item | Home | Detail view of any item | Tests multi-step navigation (Home → Items → Detail) |
| 5 | Edit your profile name | Profile | Edit Profile sheet open | Tests in-screen interaction, not navigation |
| 6 | Return to the test selection screen | Any screen | Selection screen | Tests back/exit navigation |

**Multiple solutions:**
Tasks 1–4 may be solved via either the primary navigation control or the hidden swipe gesture. If a participant discovers and uses swipe navigation, this should be noted by the moderator as it is analytically relevant.

**Difficulty gradient:**
Tasks 1–2 test direct single-step navigation. Task 4 requires two steps. Task 6 tests knowledge of the exit path, which is only accessible from Profile (via "Back to Test Selection").

---

## 6. Interaction Design Decisions

### Text labels on all navigation elements
All navigation items across all three variants use both icons and text labels. This was a deliberate choice to avoid testing icon literacy instead of navigation structure. Research consistently shows that text labels significantly improve navigation success rates for older users.

### Button sizing
All tappable elements use SwiftUI's default padding (`padding()`) which produces tap targets well above the 44×44pt minimum recommended by Apple's HIG. This is especially important for the 50–65 age group, where motor precision may differ.

### Consistent screen content
All five destination screens display the same content regardless of which navigation variant is active. Wording, layout, and visual weight are identical across variants. Only the navigation chrome (toolbar, tab bar, back button) differs.

### No animations or transitions between navigation variants
Switching between variants on the test selection screen is instantaneous (no transition animation). This prevents carry-over visual impressions between variants.

### Visibility vs. hiddenness
The three variants deliberately span the spectrum from fully visible (Version 3: all options as buttons on screen) to partially hidden (Version 2: visible but requires knowing to look at the bottom) to hidden-until-invoked (Version 1: hamburger menu requires a tap to reveal). This gradient is intentional for research purposes.

---

## 7. Data Collection (Technical Perspective)

### What is logged
The app automatically records one `VariantSession` entry per navigation variant used:

| Field | Description |
|---|---|
| `participant_id` | Manually entered by moderator (e.g. P01) |
| `age_group` | Selected by moderator: "Gen Z" or "50–65" |
| `variant` | "Version 1", "Version 2", or "Version 3" |
| `start` | ISO 8601 timestamp when participant tapped the version button |
| `end` | ISO 8601 timestamp when participant tapped "Back to Test Selection" |
| `duration_s` | Total seconds spent inside the variant |

### What is NOT logged
- Individual screen visits or tap events
- Wrong turns or error paths (observed and noted manually by moderator)
- Think-aloud speech (captured via external audio/video recording)

### Storage and export
Data is held in memory only (`SessionManager`, an in-memory `ObservableObject`). Nothing is written to disk automatically. The moderator exports via the iOS Share sheet (CSV format) at the end of each session. Data is not anonymized by the app — participant IDs should be assigned by the researcher using a separate anonymization key.

### Reset behavior
Tapping Reset on the selection screen clears all in-memory session data including participant ID, age group, and all logged variant sessions. The app returns to a clean state ready for the next participant.

---

## 8. Experimental Setup Integration

### Session flow
1. Moderator opens the app and taps **Moderator** to enter participant ID and age group
2. Moderator hands device to participant
3. Participant taps a version button — timer starts automatically
4. Participant completes assigned tasks within that variant using think-aloud protocol
5. Moderator observes; notes errors, hesitations, verbal statements
6. Participant taps **Back to Test Selection** when done — timer stops automatically
7. Repeat steps 3–6 for additional variants if testing multiple
8. Moderator opens Moderator view and exports CSV
9. Moderator taps Reset before the next participant

### Recording
The app does not perform screen or audio recording. External recording (screen mirroring to a Mac, or a second camera on a tripod) is recommended for capturing:
- Navigation paths taken
- Hesitation moments
- Think-aloud comments

### Moderation style
Moderated sessions with a think-aloud protocol are assumed. The moderator should not guide the participant toward the correct navigation path. Encouragement to keep thinking aloud is appropriate; hints about where to tap are not.

### Device
Testing should be conducted on a physical iPhone in portrait orientation. Do not use an iPad (the layout is optimized for phone dimensions) and do not test on a simulator (swipe gesture behavior differs).

---

## 9. Limitations of the App

**Prototype nature:**
This is not a production application. Content is placeholder, interactions that would involve a real backend (account editing, actual settings changes) show alerts instead of performing real actions. Participants should be briefed that the app is a prototype and that some interactions are simulated.

**Artificial tasks:**
Study tasks are designed for research comparability, not real-world realism. Participants are asked to find screens they have no genuine need for. This artificiality may affect engagement and task approach compared to natural usage.

**Single-device, sequential testing:**
If participants test multiple variants in the same session on the same device, learning effects may occur. A participant who learned the swipe gesture in Version 1 may apply it in Version 2. Counterbalancing the order of variants across participants is strongly recommended.

**No error tracking:**
The app does not automatically detect wrong taps, dead ends, or incorrect paths. These must be observed and noted manually by the moderator. This limits data precision but was chosen to keep the app simple and stable.

**In-memory only:**
If the app is backgrounded for too long, iOS may terminate it, losing all session data. Export CSV immediately after each session.

**Same content visible to all participants:**
The placeholder names ("YOUR NAME", "Item 1–5") are neutral but not personalized. Participants are asked to imagine the app as their own. This framing requires moderator guidance to be consistent across sessions.

---

## 10. Technical Implementation

### Stack
- **Language:** Swift 5.0
- **UI framework:** SwiftUI only (no UIKit)
- **Minimum deployment:** iOS 26.2
- **Dependencies:** None (no external packages, no CocoaPods, no SPM dependencies)
- **Project format:** Xcode 26.3, `PBXFileSystemSynchronizedRootGroup` (filesystem-synced groups — adding files to the `BachelorUIUX/` folder is sufficient; no manual project.pbxproj edits needed)

### Architecture
`ContentView` acts as the root coordinator. It holds:
- A `TestVersion` enum state that switches between the selection screen and the three container views
- A `SessionManager` (`@StateObject`) that survives variant switches

Each navigation variant is a self-contained SwiftUI `View` that owns its own `@State private var selectedScreen`. There is no shared navigation state between variants. The only shared state is the `SessionManager`, passed down via a callback pattern (`onBackToTestSelection`) rather than through the environment, to keep coupling explicit and minimal.

**Navigation model:** Each container wraps content in a `NavigationStack`. Screen switches within a variant replace the content of a `Group` inside that stack. Detail views pushed via `NavigationLink` (e.g. from `ItemsView`) use the container's stack naturally.

### File structure
```
BachelorUIUX/
├── ContentView.swift           — root coordinator, version selection
├── BurgerContentView.swift     — Version 1: hamburger menu
├── TabBarContentView.swift     — Version 2: tab bar
├── MainMenuContentView.swift   — Version 3: content buttons
├── HomeView.swift              — shared destination
├── ItemsView.swift             — shared destination (list → detail)
├── DetailView.swift            — shared destination (pushed via NavigationLink)
├── ProfileView.swift           — shared destination (with inline interactions)
├── ProfilePopupView.swift      — Edit Profile sheet + ProfileAction enum
├── HelpView.swift              — shared destination
├── SettingsView.swift          — shared destination
└── Moderator/
    ├── SessionManager.swift    — ObservableObject, session data and CSV export
    └── ModeratorView.swift     — researcher-only sheet
```

### Known issues
- The navigation title in `TabBarContentView` is managed manually via `titleForTab(_:)` rather than per-tab. Tab bar views would normally set their own `navigationTitle`, but the outer `NavigationStack` wrapping requires this workaround.
- `SettingsView` toggles do not persist between sessions (in-memory only). This is intentional.

---

## 11. Design Consistency Across Variants

Ensuring the three navigation variants are comparable is the most critical methodological requirement of the app.

### Measures taken
- **Identical screens:** All five destination screens (`HomeView`, `ItemsView`, `DetailView`, `ProfileView`, `HelpView`, `SettingsView`) are shared Swift structs used across all three variants. A change to any destination screen automatically applies to all three.
- **Identical labels:** Navigation item labels ("Home", "Items", "Profile", "Help", "Settings") are identical across all three variants. No synonyms or alternate phrasings.
- **Identical icons:** The same SF Symbols are used for each destination across all variants.
- **No color coding of variants:** The version selection buttons use different background colors (blue, green, gray) to distinguish them on the selection screen, but once inside a variant, no color scheme indicates which version is active.
- **Navigation chrome only:** The only differences between variants are the navigation mechanisms themselves (toolbar menu, tab bar, home screen buttons). No content, copy, imagery, or layout within destination screens differs.

### What to watch for
If a destination screen is modified, verify the change is visually and functionally identical in all three variants before conducting user tests. A screen that is accidentally harder to use in one variant will confound results.

---

## 12. Ethical and Privacy Considerations

### Data stored by the app
The app stores only:
- A participant ID (alphanumeric string entered by the researcher, e.g. "P01")
- An age group label ("Gen Z" or "50–65")
- Timestamps and durations per navigation variant

No names, contact information, audio, video, or biometric data is stored by the app.

### Anonymization
Participant IDs are assigned by the researcher using an external anonymization key. The app itself does not link IDs to real identities. The exported CSV file contains only the ID, age group, and timing data.

### Data persistence
All data is held in memory only. It is exported manually via the iOS Share sheet and is never transmitted over a network. If the app is closed without exporting, all data for that session is lost.

### Consent
Informed consent should be obtained before each session, covering:
- The purpose of the study
- What the app records (timing data only)
- Whether and how the session is recorded externally (audio/video)
- The participant's right to stop at any time
- How data will be stored, anonymized, and used

The app itself does not implement a consent flow. Consent should be handled on paper or via a separate digital form before the device is handed to the participant.
