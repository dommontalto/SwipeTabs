# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

SwipeTabs is a SwiftUI iOS/iPadOS app demonstrating a swipeable tab interface. Targets iOS/iPadOS 26.2+, Swift 5.0.

## Build & Run

Open `SwipeTabs.xcodeproj` in Xcode and run on a simulator or device. There is no CLI build script — use Xcode or `xcodebuild`:

```bash
xcodebuild -project SwipeTabs.xcodeproj -scheme SwipeTabs -destination 'platform=iOS Simulator,name=iPhone 16' build
```

There are no tests at this time.

## Architecture

The app is a single-screen SwiftUI app with two source files:

- **`SwipeTabsApp.swift`** — `@main` entry point, renders `ContentView` in a `WindowGroup`.
- **`ContentView.swift`** — All UI logic. Contains a `Tab` model (title + color) and `ContentView` which manages:
  - A horizontally-scrollable page area driven by `selectedIndex` and `dragOffset` state.
  - A custom tab bar with a `matchedGeometryEffect` animated active indicator.
  - Paging is handled natively via `ScrollView` + `.scrollTargetBehavior(.paging)` + `.scrollTargetLayout()` + `.scrollPosition(id:)` — no manual drag gesture.
  - `containerRelativeFrame(.horizontal)` sizes each page to the scroll view width without needing `GeometryReader`.
