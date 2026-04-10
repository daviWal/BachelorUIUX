# Bachelor Project README

## Project Title
**Mobile-App-Navigation im Generationsvergleich**

## Project Summary
This project supports a bachelor thesis that investigates how different age groups perceive, understand, and use mobile app navigation. The focus is on comparing **Generation Z** users with users aged **50 to 65**. The project includes a **custom test app** that serves as the research instrument. Participants solve navigation tasks through different navigation patterns that lead to the same target screens. The goal is to identify age-related differences in navigation behavior, usability, confidence, and friction points, and derive practical UX recommendations. The thesis description explicitly calls for a self-developed mobile test app with at least three navigation patterns, moderated user tests, mixed-methods data collection, and qualitative analysis. fileciteturn0file0

---

## Core Research Goal
Build and test a mobile app that allows direct comparison of multiple navigation paths to identical destinations, then evaluate how two age groups differ in:
- navigation strategy
- perceived clarity
- task success
- confidence and trust
- frustration and disorientation
- reaction to visible vs hidden navigation elements

---

## Research Scope
According to the thesis brief, the app should include at least these navigation patterns:
1. **Bottom navigation** with icon + text
2. **Hamburger menu** with hierarchical navigation
3. **Direct buttons or in-content list navigation**

Optional:
4. **Hidden gesture-based navigation** as a separate discovery task, so it does not distort the main task flow. fileciteturn0file0

---

## Recommended Tech Direction
### Preferred option
**Swift / SwiftUI on iPhone**

Reason:
- cleaner control over native navigation patterns
- realistic mobile testing environment
- easier to observe user interaction on a phone
- aligns with your existing iOS experience

### Alternative option
**React / React Native**

Use this only if:
- you need faster UI iteration across devices
- you want easier prototyping with web-like structure
- you already have a partial implementation there

---

## Functional Product Definition
The app should not be a complex real product. It should be a **controlled UX test environment**.

### Minimum app structure
- Start screen / test selection screen
- Version 1: direct content navigation
- Version 2: tab bar / bottom navigation
- Version 3: hamburger menu
- Optional hidden swipe / gesture screen
- Shared target screens reachable through all versions:
  - Profile
  - Help
  - Settings
  - Detail view
  - maybe one list-to-detail flow
- Simple task completion logging
- Optional timer or event timestamp logging

### Important constraint
Each navigation version should allow users to reach the **same goals**, otherwise comparison becomes weak.

---

## Project Phases

# Phase 1 — Thesis Framing
## Goal
Lock the scientific and practical boundaries of the project.

## Tasks
- Finalize thesis title
- Finalize main research question
- Finalize 2–4 subquestions
- Define target age groups exactly
- Define what “successful navigation” means
- Define what “understandable” means operationally
- Decide whether hidden gestures are core or optional
- Decide whether study is purely qualitative or mixed-methods with descriptive metrics

## Deliverables
- one-page project scope
- final thesis research questions
- list of variables to observe

## Done criteria
- supervisor can approve the scope without ambiguity
- you can explain in one paragraph what exactly is being compared

## Risks
- research question too broad
- app becomes a product demo instead of a research instrument
- too many UX variables changed at once

---

# Phase 2 — Test Design
## Goal
Define the test logic before building too much UI.

## Tasks
- Define the app scenario
  - example: info/organization app
- Define all target screens
- Define 5–8 concrete tasks participants must perform
- Ensure each task has:
  - same start point
  - clear target state
  - measurable completion
- Decide task order
- Decide whether all users test all versions or only one version each
- Define what you observe:
  - completion
  - time
  - wrong taps
  - route chosen
  - hesitation
  - verbal statements

## Recommended task examples
- Find the help page
- Open profile settings
- Open the detail view of an item
- Return to the home screen
- Change one mock setting
- Find support/contact

## Deliverables
- task script
- moderator script
- observation sheet draft
- test matrix

## Done criteria
- every task can be completed in every navigation variant
- every task has a clear success/failure definition

## Risks
- tasks are too easy and do not reveal differences
- tasks are too artificial and not believable
- one version gets an unfair advantage due to content layout

---

# Phase 3 — Information Architecture
## Goal
Keep the content constant while varying navigation.

## Tasks
- Define full screen inventory
- Map the navigation structure for each version
- Keep labels, destination names, and content consistent across versions
- Decide what should be visible immediately vs hidden behind menus
- Create a comparison matrix showing how each target is reached in each version

## Deliverables
- IA diagram
- flow charts for version 1, 2, 3
- screen map

## Done criteria
- all target screens are mirrored logically across versions
- navigation differences are intentional and documented

## Risks
- content and navigation are mixed together
- labels differ too much between versions
- one version has fewer steps than others for no research reason

---

# Phase 4 — Wireframes and Prototype Logic
## Goal
Design the screens with minimal visual noise.

## Tasks
- Create low-fidelity wireframes first
- Design the common screens
- Design version-specific entry/navigation components
- Use clear labels and large enough tap targets
- Avoid visual polish that distracts from the navigation test
- Define how back behavior works in every screen
- Define what happens when user gets lost

## Important rule
Do not test five things at once. The study is about navigation first, not branding, animations, or microinteractions.

## Deliverables
- wireframes for all screens
- interaction notes
- clickable prototype or development-ready sketches

## Done criteria
- no screen is ambiguous about where the user currently is
- no broken back flow
- all three variants feel like the same app, not three different apps

---

# Phase 5 — App Implementation
## Goal
Build a stable test app.

## Build order
1. shared models and app structure
2. home/test selection screen
3. common destination screens
4. version 1 navigation
5. version 2 navigation
6. version 3 navigation
7. optional hidden gesture flow
8. logging and timestamps
9. polish for test stability

## Technical tasks
- create reusable screen components
- standardize route names
- ensure predictable navigation state
- add simple data logging:
  - participant ID
  - age group
  - task ID
  - version
  - start timestamp
  - end timestamp
  - success/failure
  - wrong attempt count if possible
- create reset mechanism so each participant starts clean

## Deliverables
- working test app
- installable build for device/simulator
- test-reset workflow

## Done criteria
- app never crashes during core task flow
- every task can be completed from fresh start
- back buttons and reset flow work consistently

## Risks
- navigation stack inconsistencies
- hidden state between test runs
- simulator-only behavior that differs from real phone behavior

---

# Phase 6 — Internal QA Before User Testing
## Goal
Do not start participant testing with an unstable prototype.

## What must be tested
### Functional testing
- every screen opens correctly
- every target screen is reachable in each version
- every back button behaves correctly
- no duplicate or broken navigation bars
- hamburger opens/closes correctly
- swipe gesture only triggers where intended
- logout/reset returns properly to test selection
- profile/settings/help/detail views open correctly

### Consistency testing
- same labels across versions
- same destinations across versions
- same task difficulty across versions as much as possible

### Device testing
- at least one real iPhone test
- simulator test
- portrait mode behavior
- font scaling check if relevant

### Reset testing
- after one full test, app can be reset quickly
- previous participant data does not interfere

### Logging testing
- timestamps save correctly
- task completions are recorded correctly
- failed attempts do not corrupt logs

## Deliverables
- QA checklist
- known issues list
- test version number

## Done criteria
- no critical blocker remains
- app is stable enough for moderated sessions

---

# Phase 7 — Pilot Study
## Goal
Run 2–4 pilot sessions before the real study.

## Tasks
- test with at least one younger and one older participant if possible
- measure whether tasks are understandable
- check whether moderator instructions are clear
- note where participants misunderstand the task itself rather than the navigation
- validate session length
- revise unclear wording

## What to look for
- are tasks too easy?
- are users confused by content instead of navigation?
- does think-aloud disrupt performance too much?
- do hidden gestures need to be separated more clearly?

## Deliverables
- pilot notes
- revised task script
- revised app if needed

## Done criteria
- no major confusion caused by wording or broken flows
- estimated session duration is realistic

---

# Phase 8 — Main User Study
## Goal
Collect the actual thesis data.

## Sample target
- 10 participants: Generation Z
- 10 participants: age 50–65

This matches the thesis plan and is appropriate for a qualitative, exploratory setup. fileciteturn0file0

## Session structure
1. welcome and consent
2. brief intro
3. demographic/context questions
4. task execution with think-aloud
5. observation and screen recording
6. short follow-up interview
7. debrief

## Data to capture
### Quantitative/descriptive
- task completion
- task time
- path taken
- detours/errors

### Qualitative
- think-aloud comments
- hesitation moments
- observed confusion
- follow-up interview answers

## Deliverables
- completed sessions
- recordings
- observation notes
- exported logs

## Done criteria
- balanced participant set collected
- all sessions recorded and labeled cleanly

## Risks
- inconsistent moderation
- older participants feeling “tested” instead of the app being tested
- technical recording failure

---

# Phase 9 — Data Preparation
## Goal
Prepare data for analysis without chaos.

## Tasks
- assign anonymized participant IDs
- organize recordings and notes
- create a master table of sessions
- transcribe relevant interview parts
- extract descriptive metrics into a spreadsheet
- prepare qualitative coding material

## Folder suggestion
- `/data/raw`
- `/data/anonymized`
- `/data/transcripts`
- `/data/metrics`
- `/analysis`
- `/docs`

## Deliverables
- anonymized dataset
- transcript package
- descriptive metrics table

## Done criteria
- every recording maps to one participant ID
- all files are named consistently

---

# Phase 10 — Analysis
## Goal
Answer the research questions with disciplined structure.

## Qualitative analysis
Use qualitative content analysis according to Mayring, as planned in the thesis description. fileciteturn0file0

### Suggested initial deductive categories
- Verständlichkeit
- Orientierung
- Vertrauen/Sicherheit
- Frustration
- Sichtbarkeit
- Erwartungskonformität
- Strategiewechsel
- Umgang mit Icons
- Umgang mit versteckter Navigation

### Inductive additions
- new patterns emerging from observed behavior
- generation-specific language or metaphors
- coping strategies when lost

## Quantitative/descriptive analysis
- compare completion rates
- compare average task times
- compare wrong turns / detours
- compare preferred navigation patterns

## Deliverables
- coding scheme
- coded excerpts
- summary tables
- interpretation notes

## Done criteria
- each main finding maps back to evidence
- descriptive metrics support, not replace, the qualitative interpretation

---

# Phase 11 — UX Recommendations
## Goal
Translate findings into design implications.

## Output format
Recommendations should be concrete, not vague.

### Weak
“Make navigation intuitive.”

### Better
“Use visible bottom navigation with text labels for frequently used primary destinations; avoid relying solely on icon meaning for older adults.”

## Recommendation areas
- visibility of primary navigation
- role of text labels
- depth of hierarchy
- button size and tap safety
- discoverability of gestures
- back navigation clarity
- consistency across screens

## Deliverables
- recommendation list
- design implications section for thesis

## Done criteria
- each recommendation is tied to observed evidence
- recommendations distinguish between general best practice and age-specific finding

---

# Phase 12 — Thesis Writing
## Goal
Write in parallel with the project, not only at the end.

## Suggested chapter sequence
1. Introduction
2. Problem statement and motivation
3. Theoretical background
4. Research question and goals
5. Methodology
6. App concept and implementation
7. Study design
8. Results
9. Discussion
10. UX recommendations
11. Limitations
12. Conclusion

## Parallel writing strategy
Write these early:
- intro draft
- research questions
- methodology draft
- app concept chapter
- test design chapter

Write later:
- results
- discussion
- implications

---

## Suggested Testing Checklist

### Navigation correctness
- [ ] Version 1 opens all target screens
- [ ] Version 2 opens all target screens
- [ ] Version 3 opens all target screens
- [ ] Optional hidden gesture works only where expected
- [ ] Back navigation is consistent everywhere
- [ ] No dead-end screen exists

### Task validity
- [ ] Each task has one clear goal
- [ ] Goal can be reached in each version
- [ ] Same content appears in all versions
- [ ] Wording of tasks is neutral

### UX fairness
- [ ] One version is not visually emphasized more than the others
- [ ] Labels are comparable across versions
- [ ] Button sizes are usable for both age groups

### Study readiness
- [ ] Consent flow prepared
- [ ] Moderator script prepared
- [ ] Observation sheet prepared
- [ ] Participant IDs defined
- [ ] Recording method tested
- [ ] Backup recording method available

### Data integrity
- [ ] Logs export correctly
- [ ] Recordings are named consistently
- [ ] Notes map to participant IDs
- [ ] Anonymization workflow defined

---

## Suggested Project Folder Structure
```text
project-root/
├── README.md
├── CLAUDE.md
├── docs/
│   ├── thesis-scope.md
│   ├── research-questions.md
│   ├── task-script.md
│   ├── moderator-guide.md
│   ├── qa-checklist.md
│   └── ethics-consent-notes.md
├── design/
│   ├── wireframes/
│   ├── flows/
│   └── prototypes/
├── app/
│   ├── shared/
│   ├── version1/
│   ├── version2/
│   ├── version3/
│   └── logging/
├── data/
│   ├── raw/
│   ├── anonymized/
│   ├── transcripts/
│   └── metrics/
├── analysis/
│   ├── coding/
│   └── summaries/
└── thesis/
    ├── figures/
    └── drafts/
```

---

## Definition of Done for the Entire Project
The project is done when:
- the app contains at least 3 clearly distinct navigation patterns
- all test tasks are executable in all patterns
- pilot testing has been completed and issues fixed
- at least 20 moderated sessions are completed or the final agreed sample is reached
- data is anonymized and organized
- qualitative and descriptive analysis are completed
- UX recommendations are evidence-based
- thesis text documents the design, method, results, and limitations cleanly

---

## Critical Pitfalls to Avoid
- Comparing different content instead of different navigation
- Letting visual design differences bias the result
- Testing hidden gestures without clear framing
- Making older participants feel judged rather than supported
- Forgetting to standardize moderator behavior
- Starting the study before the app is stable
- Collecting too much data without a clean analysis plan

---

## Recommended Next 10 Actions
1. Freeze the exact research question wording.
2. Decide Swift/SwiftUI vs React.
3. Finalize the app scenario and target screens.
4. Write the exact participant tasks.
5. Draw all three navigation flows.
6. Build the shared screens first.
7. Implement all three navigation variants.
8. Add simple task logging and reset flow.
9. Run 2–4 pilot sessions.
10. Revise before full participant testing.

---

## Notes / Assumptions Used in This README
This README is based on the current bachelor thesis description and the already discussed project direction: a mobile test app that compares multiple navigation patterns across two age groups with moderated testing and mixed qualitative/descriptive analysis. fileciteturn0file0
