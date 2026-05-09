# BachelorUIUX — App Documentation

**Version:** 1.2
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
- Automatically uploads each completed session row to a Google Sheets spreadsheet in the background
- Provides a moderator interface for session management, labeling, upload status monitoring, and CSV export
- Resets cleanly between participants
- Provides interactive item detail screens (edit name/description, toggle favorite, change status) to give participants meaningful in-screen tasks beyond navigation

### What the app does NOT do
- No real backend, no persistent user accounts
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

**Detail View:** Accessible only from Items, via a `NavigationLink` list. Shares the `NavigationStack` of the active container. The detail screen shows the item's name, description, status, last-updated date, and creation date. It supports three interactive actions:
- **Edit** (pencil button, toolbar) — opens a sheet to rename the item and edit its description; saving stamps the "Last Updated" date to the current time
- **Favorite** (star button, toolbar) — toggles the favorite flag; favorited items show a yellow star in the Items list
- **Status** (tap the Status row) — opens a confirmation dialog to switch between Active, Archived, and Draft

All item changes persist within the session via a shared `ItemStore`. Changes are lost when the app is reset between participants.

**Profile interactions:** Edit Profile opens a full sheet with editable name and email fields. All other profile rows (Account Settings, Notifications, Privacy, Help & Support) show an alert confirming the tap — they are intentionally not implemented as these features are outside the scope of the study.

---

## 5. Task Design

The study uses four main tasks (A–D) that all participants complete in every version. Optional scenario tasks exist for extended sessions. Task design is governed by the Moderator Script (Version 1.0).

### Main Tasks

| Task | Instruction | Start | Success State | Type |
|---|---|---|---|---|
| A — Find Help | "Please find where you would get help in the app." | Home | Help screen visible | 1-step / interpretive |
| B — Find Settings | "Please find where you can change app settings." | Home | Settings screen visible | 1-step / interpretive |
| C — Open Item 3 | "Please find the list of items and open Item 3." | Home | Detail view of Item 3 visible | 2-step |
| D — Edit Item 3 | "Please find Item 3 and change its name." | Home | Edit sheet for Item 3 open | Multi-step / navigation + in-screen action |

**Task D dependency:** Task D requires the participant to first navigate to the Item 3 detail view (same path as Task C). If Task C was not completed successfully, the moderator navigates to Item 3 before starting Task D timing and records Task C as a failure.

**Success definition for Task D:** Success is counted when the participant reaches the edit interface for Item 3, not when typing is complete. This keeps the metric focused on navigation and toolbar discoverability, not typing skill. Opening the wrong item's edit view counts as partial success (wrong target).

**Multiple solutions:** Tasks A–C may be solved via either the primary navigation control or the hidden swipe gesture. Swipe-based solutions must be recorded separately under Gesture Discovery (see Section 7).

**Difficulty gradient:** Tasks A and B are single-step navigation. Task C is two-step (navigation to Items → select Item 3). Task D adds a third step (toolbar → edit sheet), testing toolbar discoverability on top of navigation.

### Optional Scenario Tasks

Use only if session time allows, or in a pilot round. Do not mix all optional tasks into a single 20–25 minute session.

| Scenario | Instruction | Success State |
|---|---|---|
| 1 — Help need | "Imagine you are stuck in the app and need help. Where would you go?" | Help screen visible |
| 2 — App behavior | "Imagine you want the app to behave differently. Where would you go?" | Settings screen visible |
| 3 — Item browsing | "Imagine you want to look through the items and open one in more detail." | Any item detail view visible |
| 4 — Personal data | "Imagine you want to change something about your personal information. Where would you go?" | Profile screen or Edit Profile interface visible |

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

### Manually collected metrics (moderator observation sheet)

The following metrics are recorded by the moderator on paper during each task, for each version:

| Metric | Definition | Scale |
|---|---|---|
| Task success | Participant reaches defined success state without moderator guidance | 2 = success / 1 = partial / 0 = failure |
| Time on task | Seconds from end of task instruction to success state or give-up | Seconds (approximate if needed) |
| Wrong turns | Intentional taps that move away from the expected route | Count per task |
| Hesitation | Visible pause before action | 0 = none (<2s) / 1 = mild (3–5s) / 2 = strong (>5s) |
| Navigation path | Sequence of taps taken | Free text (e.g. "Tab bar → Settings") |
| Gesture discovery | Whether participant attempts or discovers hidden swipe navigation | 0 = no attempt / 1 = accidental / 2 = intentional / 3 = discovered and reused |

**Wrong turn definition:** Counts intentional taps that change screen and move away from the target. Does not count looking without tapping, scrolling that does not change screen, reading labels, or accidental touches immediately self-corrected.

**Gesture discovery note:** If a participant discovers the swipe gesture in one version, the moderator notes whether they transfer it to subsequent versions. This is analytically relevant regardless of which task it occurs during.

Per-version subjective ratings (collected after each version via post-test questions):

| Rating | Question | Scale |
|---|---|---|
| Perceived ease | "How easy was this version to navigate?" | 1 (very difficult) – 5 (very easy) |
| Confidence | "How confident did you feel navigating this version?" | 1 (not at all) – 5 (very confident) |
| Frustration | "Did anything feel confusing or frustrating?" | Yes/No + optional 1–5 rating |

Verbal observations (think-aloud quotes, especially around visibility, labels, icons, uncertainty, expectations, and comparisons to familiar apps) are noted in free text on the observation sheet.

### Storage and export

**Primary — automatic Google Sheets upload:**
The moment a participant taps "Back to Test Selection", `SessionManager.endSession()` fires a background upload to a configured Google Sheets spreadsheet. The row is appended silently without interrupting the session flow. The Moderator view shows a cloud icon next to each completed session:

| Icon | Meaning |
|---|---|
| Blue (uploading) | Upload in progress |
| Green (checkmark) | Row successfully written to the sheet |
| Red (exclamation) | Upload failed — use CSV export as fallback |

All participant data accumulates in one spreadsheet across all testing days, making cross-participant comparison straightforward.

**Fallback — CSV export:**
The Export button in the Moderator view remains available. It generates a CSV via the iOS Share sheet covering all sessions recorded in the current app session. Use this if the upload icons are red or if the device has no internet connection.

**In-memory state:**
`SessionManager` is an in-memory `ObservableObject`. The in-app session list is lost if the app is terminated. The Google Sheet is the persistent record — export CSV additionally if working in a low-connectivity environment.

**Credentials:**
Upload credentials are stored in `SheetsConfig.swift`, which is excluded from version control via `.gitignore`. The file must be present on the device's build for uploads to work.

Data is not anonymized by the app — participant IDs should be assigned by the researcher using a separate anonymization key.

### Reset behavior
Tapping Reset on the selection screen clears all in-memory session data including participant ID, age group, and all logged variant sessions. It does not affect rows already written to the Google Sheet. The app returns to a clean state ready for the next participant.

---

## 8. Experimental Setup Integration

### Counterbalanced version order

To reduce learning and order effects, the sequence of navigation versions is counterbalanced across participants using a Latin Square rotation:

| Group | Order |
|---|---|
| A | Version 1 → Version 2 → Version 3 |
| B | Version 2 → Version 3 → Version 1 |
| C | Version 3 → Version 1 → Version 2 |

Assignment: P01 = A, P02 = B, P03 = C, P04 = A, P05 = B, P06 = C, and so on. Apply the same rotation independently within each age group where possible.

### Session flow

**Before handing over the device:**
1. Moderator opens the app and taps **Moderator** to enter participant ID and age group
2. Moderator reads introduction script aloud (study purpose, prototype framing, no right/wrong answers)
3. Moderator reads think-aloud instruction aloud
4. Moderator reads consent script aloud; records consent answer; stops session if participant declines
5. Moderator asks pre-test questions (app usage habits, smartphone confidence, exploration style)
6. Moderator hands device to participant

**Per version (repeat for each of the three versions):**

7. Participant taps the version button for this session's assigned version — timer starts automatically
8. Moderator gives tasks one at a time (A, B, C, D); participant completes each using think-aloud protocol
9. Moderator observes and records metrics on observation sheet: success score, time, wrong turns, hesitation, navigation path, gesture discovery, key quotes
10. Participant taps **Back to Test Selection** when the moderator signals the version is complete — timer stops automatically and the session row is uploaded to Google Sheets in the background
11. Moderator asks per-version post-test questions (ease, confidence, frustration) and records answers
12. Repeat steps 7–11 for the next version in the assigned order

**After all three versions:**

13. Moderator asks final comparison questions (preference, easiest, most confusing, real-world preference)
14. Moderator opens Moderator view — confirm all three session rows show a green cloud icon; use Export CSV as a backup if any show red
15. Moderator reads closing script aloud
16. Moderator taps Reset before the next participant

### Recording
The app does not perform screen or audio recording. External recording (screen mirroring to a Mac, or a second camera on a tripod) is recommended for capturing:
- Navigation paths taken
- Hesitation moments
- Think-aloud comments

### Moderation rules
The moderator must not guide the participant toward the correct navigation path. The only permitted prompt during tasks is: *"Please keep thinking aloud."*

Not permitted:
- Saying where to tap
- Naming or pointing to navigation elements
- Explaining the meaning of icons
- Correcting wrong turns immediately
- Comparing versions while the participant is still testing

### Device
Testing must be conducted on a physical iPhone in portrait orientation. Do not use an iPad (the layout is optimized for phone dimensions) and do not test on a simulator (swipe gesture behavior differs).

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
If the app is backgrounded for too long, iOS may terminate it, losing the in-app session list. However, any rows that were already uploaded to Google Sheets before termination are safe. Export CSV after each participant as an additional backup.

**Requires network connectivity:**
Automatic upload to Google Sheets requires an active internet connection. If the device is offline, the cloud icon turns red and the row will not appear in the sheet. In this case, use the CSV export as the primary data source. Test network connectivity before each session.

**Same content visible to all participants:**
The placeholder names ("YOUR NAME", "Item 1–5") are neutral but not personalized. Participants are asked to imagine the app as their own. This framing requires moderator guidance to be consistent across sessions.

---

## 10. Technical Implementation

### Stack
- **Language:** Swift 5.0
- **UI framework:** SwiftUI only (no UIKit)
- **Minimum deployment:** iOS 26.2
- **Dependencies:** No Swift packages or CocoaPods. The Google Sheets integration uses only `URLSession` (Foundation) and `SecKeyCreateSignature` (Security framework) — both built into iOS.
- **Project format:** Xcode 26.3, `PBXFileSystemSynchronizedRootGroup` (filesystem-synced groups — adding files to the `BachelorUIUX/` folder is sufficient; no manual project.pbxproj edits needed)

### Architecture
`ContentView` acts as the root coordinator. It holds:
- A `TestVersion` enum state that switches between the selection screen and the three container views
- A `SessionManager` (`@StateObject`) that survives variant switches
- An `ItemStore` (`@StateObject`) injected into the environment via `.environmentObject(itemStore)`, making it available to all destination screens across all three variants

Each navigation variant is a self-contained SwiftUI `View` that owns its own `@State private var selectedScreen`. There is no shared navigation state between variants. `SessionManager` is passed via a callback pattern (`onBackToTestSelection`); `ItemStore` travels via the SwiftUI environment so no changes to the three container files were needed.

**ItemStore:** A shared `ObservableObject` that holds five pre-loaded `AppItem` values with staggered creation and last-updated dates. Mutations (rename, favorite toggle, status change) are published via `@Published var items`, causing all observing views to update automatically. The store is reset only when the moderator taps Reset — item changes made during a variant session persist if the participant switches variants.

**Navigation model:** Each container wraps content in a `NavigationStack`. Screen switches within a variant replace the content of a `Group` inside that stack. Detail views pushed via `NavigationLink` (e.g. from `ItemsView`) use the container's stack naturally.

### File structure
```
BachelorUIUX/
├── ContentView.swift           — root coordinator, version selection, ItemStore injection
├── BurgerContentView.swift     — Version 1: hamburger menu
├── TabBarContentView.swift     — Version 2: tab bar
├── MainMenuContentView.swift   — Version 3: content buttons
├── HomeView.swift              — shared destination
├── ItemsView.swift             — shared destination (list → detail, shows favorite star)
├── DetailView.swift            — shared destination (edit, favorite, status, metadata)
├── ItemStore.swift             — AppItem model, ItemStatus enum, ItemStore ObservableObject
├── ItemEditView.swift          — edit sheet for item name and description
├── ProfileView.swift           — shared destination (with inline interactions)
├── ProfilePopupView.swift      — Edit Profile sheet + ProfileAction enum
├── HelpView.swift              — shared destination
├── SettingsView.swift          — shared destination
└── Moderator/
    ├── SessionManager.swift    — ObservableObject, session data, CSV export, upload trigger
    ├── ModeratorView.swift     — researcher-only sheet, shows upload status icons
    ├── SheetsUploader.swift    — Google Sheets API client (JWT signing, OAuth2, REST calls)
    └── SheetsConfig.swift      — spreadsheet ID and service account credentials
                                  (gitignored — never committed to version control)
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

**Note on DetailView interactivity:**
`DetailView` now contains interactive elements (pencil button, star button, tappable status row). These are in-screen interactions, not navigation — they do not vary across the three variants. All participants see the same detail screen regardless of which navigation version they are using. This preserves experimental validity: the navigation path to the detail screen differs per variant, but everything inside it is identical.

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

### Data persistence and transmission
Session data is automatically uploaded to a private Google Sheets spreadsheet after each variant ends. This transmission is encrypted (HTTPS) and authenticated via a service account private key. Only the researcher's Google account has access to the spreadsheet.

The data transmitted per row is limited to: participant ID, age group, variant name, start timestamp, end timestamp, and duration in seconds. No device identifiers, IP addresses, or personal data beyond what the moderator enters are sent.

The iOS Share sheet CSV export transmits data only to destinations the moderator explicitly selects (e.g. their own email or cloud storage). If the app is closed without exporting and without a successful upload, data for that session is lost.

### Consent
Informed consent should be obtained before each session, covering:
- The purpose of the study
- What the app records (timing data only)
- Whether and how the session is recorded externally (audio/video)
- The participant's right to stop at any time
- How data will be stored, anonymized, and used

The app itself does not implement a consent flow. Consent should be handled on paper or via a separate digital form before the device is handed to the participant.
