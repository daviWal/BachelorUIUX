# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

This is a **controlled UX research instrument** for a bachelor thesis studying how **Generation Z** and users aged **50–65** perceive and use different mobile navigation patterns. The app is not a product — it is a test environment. Every decision must preserve **research validity** and **comparability across navigation variants**.

Priority order for all decisions:
1. Research validity
2. Task comparability across navigation variants
3. Stability during moderated user tests
4. Simplicity of implementation
5. Visual polish

If a change improves aesthetics but weakens comparison, reject it.

## Building & Running

This is an Xcode project — open via:

```
open BachelorUIUX.xcodeproj
```

- **Run tests:** `Cmd+U` in Xcode, or:
  ```
  xcodebuild test -scheme BachelorUIUX -destination 'platform=iOS Simulator,name=iPhone 16'
  ```
- **Build only:**
  ```
  xcodebuild build -scheme BachelorUIUX -destination 'platform=iOS Simulator,name=iPhone 16'
  ```

**Target:** iOS 26.2+, Swift 5.0, SwiftUI only (no UIKit). Default actor isolation is `MainActor`.

## Architecture

`ContentView` is a **test harness** with a `TestVersion` enum. Users select a navigation variant, then complete tasks within it. All three variants route to the same shared leaf screens.

| Version | File | Pattern |
|---|---|---|
| 1 | `BurgerContentView.swift` | Hamburger/toolbar menu |
| 2 | `TabBarContentView.swift` | Standard tab bar (3 tabs) |
| 3 | `MainMenuContentView.swift` | Direct button/content navigation |

Shared destination screens: `HomeView`, `ItemsView`, `ProfileView`. Each container manages its own `@State` for active screen and implements `DragGesture`-based swipe navigation. `ProfileView` includes a "Back to Test Selection" button for session reset.

**Planned screens not yet built:** Help, Settings, Detail view, optional hidden-gesture task screen.

**Planned logging not yet built:** participant ID, age group, task ID, version, start/end timestamps, success/failure, wrong attempt count.

## Core Product Rules

- All navigation variants must reach the same target screens.
- Labels and content must stay consistent across variants — differences come from navigation structure only.
- Avoid animations or decorative complexity that could bias results.
- The app must be easy to reset between participants (no state leaking between sessions).
- Hidden gesture flow must be isolated so it does not contaminate the main test.

## A Screen Is Only "Done" When It:
- Opens correctly from its intended entry point
- Returns correctly (no broken back navigation)
- Is reachable in the intended flow
- Behaves consistently on a real device
- Has no duplicate navigation controls
- Does not trap the participant in a dead end

## Testing

- **Unit tests** use Swift Testing (`import Testing`, `@Test` macros, `#expect()`).
- **UI tests** use XCTest; `BachelorUIUXUITestsLaunchTests.swift` captures a screenshot per configuration on launch.

## Architecture Guidance

- Keep navigation logic modular per variant — do not share navigation state across versions.
- Prefer reusable destination screens with separate navigation wrappers per variant.
- Add reset/test mode early; every session must start from a clean state.
- Keep logging simple and separate from UI.
- Prefer explicit behavior over clever abstractions.

## Critical Pitfalls

- One variant accidentally becoming easier due to different wording or content layout
- Hidden UI state leaking between test sessions
- Broken back navigation in any variant
- Visual emphasis biasing user choices between variants
- Logging events not matching actual task flow
- Simulator behavior differing from real device (always test on a physical iPhone before user studies)
