---
status: pending
priority: p2
issue_id: "002"
tags: [ui, video, youtube-parity, flutter]
dependencies: []
---

# Complete YouTube Player Parity

Track the remaining YouTube-style mobile player capabilities that are not yet implemented in the Flutter `BnaVideo` component.

## Problem Statement

The current Flutter video player already covers the core playback surface, control overlay, fullscreen rotation, double-tap seek, hold-for-2x, captions on/off, mute, disabled state, loading, and replay. However, several YouTube-style behaviors are still placeholders or missing entirely.

This matters because:

- The visual direction for this component is explicitly based on the YouTube mobile player, not the original RN `Video` implementation.
- Placeholder icons without real behavior can mislead future contributors and QA.
- Remaining gaps now span both functionality and interaction design, so they need durable tracking instead of being left as implicit debt.

## Findings

- `lib/features/ui_showcase/widgets/bna_video.dart` currently exposes a `cast` control, but `_handleCastPressed()` is still a placeholder.
- `lib/features/ui_showcase/widgets/bna_video.dart` currently exposes a `gauge` control in fullscreen, but `_handleSpeedPressed()` is still a placeholder.
- The current player supports caption visibility toggling, but not caption language, size/style, or "show when muted" behaviors.
- The current player has fullscreen rotation, double-tap seek, and hold-for-2x, but does not support PiP, pinch-to-zoom, screen lock, chapters, or a settings sheet.
- The current player does not support a YouTube-style miniplayer or queue/watch-next flow.

## Proposed Solutions

### Option 1: Core Parity First

**Approach:** Implement the most player-local gaps first: playback-speed menu, cast flow, and a settings sheet that can host quality/captions/lock-screen options.

**Pros:**
- Highest user-visible value inside the current component
- Keeps scope focused on the player itself
- Reuses the existing top-right controls already in the UI

**Cons:**
- Does not address app-level flows like queue or miniplayer
- Still leaves deeper parity gaps open

**Effort:** 1-2 days

**Risk:** Medium

---

### Option 2: Full Interaction Parity Roadmap

**Approach:** Split the remaining work into player-local features, fullscreen gestures, and app-level playback continuity features, then implement them in phases.

**Pros:**
- Produces a clear roadmap
- Avoids mixing local widget work with broader navigation/state work
- Better fit for cross-session execution

**Cons:**
- More planning overhead
- Slower to deliver the first missing feature

**Effort:** 2-4 days across multiple sessions

**Risk:** Medium

## Recommended Action

**To be filled during triage.** Preferred order is: playback-speed menu, cast integration, settings sheet, PiP, then fullscreen interaction enhancements.

## Technical Details

**Affected files:**
- `lib/features/ui_showcase/widgets/bna_video.dart`
- `lib/features/ui_showcase/pages/video_component_page.dart`

**Related components:**
- Any future media browsing surface that may host miniplayer or queue behavior
- App-level navigation/state if PiP or miniplayer are implemented

**Database changes (if any):**
- Migration needed? No
- New columns/tables? None

## Resources

- `lib/features/ui_showcase/widgets/bna_video.dart`
- [Manage caption settings](https://support.google.com/youtube/answer/100078?co=GENIE.Platform%3DAndroid&hl=en-EN)
- [Speed up or slow down YouTube videos](https://support.google.com/youtube/answer/7509567?co=GENIE.Platform%3DAndroid&hl=en)
- [Using picture-in-picture on your mobile device](https://support.google.com/youtube/answer/7552722?co=GENIE.Platform%3DAndroid&hl=en)
- [Watch YouTube on your smart TV by linking to your devices](https://support.google.com/youtube/answer/7640706?co=GENIE.Platform%3DAndroid&hl=en-EN)
- [Video Chapters](https://support.google.com/youtube/answer/9884579?hl=en-419)
- [Watch videos on the Miniplayer](https://support.google.com/youtube/answer/9162927?co=GENIE.Platform%3DAndroid&hl=en-EN)
- [Change the quality of your video](https://support.google.com/youtube/answer/91449?co=GENIE.Platform%3DAndroid&hl=en)
- [Lock your screen in the YouTube app](https://support.google.com/youtube/answer/14001626?hl=en-419)
- [Pinch to zoom](https://support.google.com/youtube/answer/12820428?hl=en-EN)
- [Queue videos on YouTube](https://support.google.com/youtube/answer/9546304?co=GENIE.Platform%3DAndroid&hl=en-uk)

## Acceptance Criteria

- [ ] Remaining unimplemented YouTube-style player features are explicitly tracked in one durable todo
- [ ] The todo separates placeholder functionality from fully missing functionality
- [ ] The todo lists a practical implementation order
- [ ] Future sessions can continue from this backlog without re-discovery

## Work Log

### 2026-05-15 - Initial Discovery

**By:** Codex

**Actions:**
- Audited the current Flutter `BnaVideo` player against YouTube mobile player behavior
- Confirmed that cast and playback-speed controls are still placeholders
- Identified additional parity gaps around captions settings, PiP, pinch-to-zoom, lock screen, chapters, miniplayer, queue, and quality controls
- Logged the remaining work as a durable todo

**Learnings:**
- The current component already covers the most visible playback interactions
- The remaining gaps split naturally into player-local, fullscreen-gesture, and app-level continuity work

## Notes

- Placeholder controls already exist in the UI for cast and playback speed, so these should be addressed before adding new surface area.
- Miniplayer and queue likely need broader app-level design decisions, not only widget-level changes.
