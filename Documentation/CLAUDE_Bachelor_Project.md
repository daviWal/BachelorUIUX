# CLAUDE.md

## Project Identity
This repository contains the implementation and research support material for a bachelor thesis on **mobile app navigation across generations**.

The project goal is not to build a feature-rich product. The goal is to build a **controlled research app** for comparing how:
- **Generation Z** users
- users aged **50–65**

perceive and use different mobile navigation patterns.

The thesis description defines three main navigation styles to compare:
- bottom navigation
- hamburger menu
- direct content-based navigation

An optional hidden gesture flow may be included as a separate discovery task. fileciteturn0file0

---

## What This Project Must Optimize For
When making decisions, prioritize in this order:
1. **Research validity**
2. **Task comparability across navigation variants**
3. **Stability during moderated user tests**
4. **Simplicity of implementation**
5. **Visual polish**

If a change improves aesthetics but makes comparison weaker, reject it.

---

## Product Rules
- All navigation variants must reach the same target screens.
- Labels and content should stay as consistent as possible.
- Differences between variants should come from navigation structure, not unrelated UI changes.
- Avoid unnecessary animations or decorative complexity.
- The app must be easy to reset between participants.
- Hidden gestures must not contaminate the main test unless intentionally isolated.

---

## Main Screens Expected
- Test selection / start screen
- Home screen
- Help
- Profile
- Settings
- Detail view
- Optional hidden-swipe / gesture task screen

---

## Development Priorities
### First build
- shared screens
- routing structure
- version 1
- version 2
- version 3
- reset flow
- basic event logging

### Then improve
- consistency
- tap target sizes
- back navigation
- observation support
- export/logging reliability

### Only later
- styling polish
- nicer typography
- secondary convenience features

---

## Testing Standard
Do not consider a screen “done” unless it passes:
- opens correctly
- returns correctly
- is reachable in intended flow
- behaves consistently on device
- does not add duplicate navigation controls
- does not trap the participant in a dead end

Do not start real user tests before at least a minimal pilot round.

---

## Research Constraints
The study logic requires:
- fixed tasks
- common starting point
- clear target states
- comparable paths
- capture of both qualitative and descriptive data

Useful descriptive signals:
- task completion
- time on task
- path taken
- wrong turns

Useful qualitative signals:
- think-aloud comments
- hesitation
- confusion
- confidence
- frustration

This matches the thesis plan of moderated testing, recordings, and mixed-methods evaluation with Mayring-based qualitative analysis. fileciteturn0file0

---

## Coding / Architecture Guidance
- Prefer reusable destination screens with separate navigation wrappers.
- Keep navigation logic modular by variant.
- Use predictable route names.
- Keep test data and logging simple.
- Avoid deep coupling between business logic and UI.
- Add a reset/test mode early.
- Prefer explicit behavior over clever abstractions.

---

## What to Watch Out For
- One navigation version accidentally becoming easier because of different wording
- Broken back behavior
- Hidden UI state leaking between test sessions
- Visual emphasis biasing user choices
- Logging events not matching actual task flow
- Simulator behavior differing from real device use

---

## Definition of Success
This project succeeds when it delivers:
- a stable research app with at least 3 navigation patterns
- a usable testing workflow
- analyzable behavioral data
- evidence strong enough to derive UX recommendations for age-diverse navigation design

---

## Preferred Working Style for Future Edits
When updating this project:
- keep changes focused
- explain tradeoffs clearly
- do not introduce complexity without research value
- preserve comparability across versions
- test every navigation change end-to-end
