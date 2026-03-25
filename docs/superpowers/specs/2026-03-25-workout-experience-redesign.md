# Workout Experience Redesign — Spec

**Date:** 2026-03-25
**Status:** Approved
**Approach:** B — Refactor + Feature (riarchitettura a componenti Riverpod, riuso layer data/API)

## Context

Prometheus Flutter is migrated from a Vanilla JS PWA. The live workout system is functional but has gaps compared to the original PWA and lacks native mobile enhancements. The current `LiveWorkoutScreen` is a 500+ line monolith with local `StatefulWidget` state that doesn't scale for the features needed.

## Goals

1. Achieve feature parity with the original Vanilla JS PWA workout experience
2. Add native mobile enhancements impossible in the PWA (haptic, notifications, gesture)
3. Refactor to component-based architecture with Riverpod state management
4. Deliver a premium, immersive workout experience (target: mobile-first, APK + PWA)

## Non-Goals

- Intelligent weight suggestions (deferred)
- Backend API changes (use existing endpoints)
- Changes to non-workout screens beyond Dashboard

---

## Feature 1: Dashboard Hub

**Problem:** Dashboard has "Inizia Allenamento" and "Riprendi" cards with TODO placeholders. No workout history on client dashboard. Starting a workout requires navigating to Plans → Plan Detail → Session Selector (3 screens).

**Solution:**

- Wire `ActiveWorkoutCard.onResume` to navigate to `/workout/{executionId}`
- Wire `ActiveWorkoutCard.onStart` to open a bottom sheet (replaces `SessionSelectorScreen`)
- Bottom sheet: pre-filled session + week from `/api/workouts/executions/suggest/`, one tap "Inizia" to start
- Add `RecentActivityList` widget to client dashboard showing last 3-5 completed workouts
- Each activity card shows: session name, relative date, duration, set count, feeling emoji
- "Vedi tutto" link opens `ActivityScreen`

**Files:**
- `lib/presentation/dashboard/screens/dashboard_screen.dart` — add storico section, wire buttons
- `lib/presentation/dashboard/widgets/active_workout_card.dart` — wire navigation
- `lib/presentation/dashboard/widgets/recent_activity_list.dart` — new widget
- `lib/presentation/workouts/widgets/start_workout_sheet.dart` — new bottom sheet

**Data:** Uses existing `activeExecutionProvider`, `workoutPlansProvider`, `sessionSuggestionProvider`, and `WorkoutRemoteDatasource.getExecutions()` for history.

---

## Feature 2: Flame Animation

**Problem:** Flutter has only a static `FlameIcon` (CustomPainter). The PWA had an animated 4-layer flame with sparks that grew with workout progress.

**Solution:**

`FlameWidget` — CustomPainter with animated layers:

- **4 concentric layers:** outer (deep orange #d84315→#ffb74d), middle (orange-yellow #ff5722→#ffeb3b), inner (yellow #ff9800→#fff59d), core (white-yellow #ffc107→#ffffff)
- **4 AnimationControllers** staggered for wave motion (matching PWA's `flameWave1-4` keyframes)
- **5 spark particles** with independent rise + fade + horizontal drift animations
- **Radial glow** at base via `MaskFilter.blur`

`FlameProgressNotifier` — Riverpod StateNotifier:

- Input: `completedSets / totalSets` from `WorkoutStateNotifier`
- Output parameters interpolated with `Curves.easeOutCubic`:

| Progress | Scale | Opacity | Speed   | Glow |
|----------|-------|---------|---------|------|
| 0%       | 0.15  | 0.2     | 0.5s    | 0    |
| 25%      | 0.35  | 0.4     | 0.42s   | 0.15 |
| 50%      | 0.55  | 0.65    | 0.35s   | 0.5  |
| 75%      | 0.78  | 0.85    | 0.27s   | 0.7  |
| 100%     | 1.0   | 1.0     | 0.2s    | 0.9  |

- At 100%: continuous pulse animation + haptic celebration pattern
- Two render sizes: compact (28px, for app bar with percentage text) and large (for completion screen)

**Positioning:** Compact flame lives in the app bar, always visible during workout. Shows flame icon + "42%" text in a pill-shaped container.

**Files:**
- `lib/presentation/workouts/widgets/flame_widget.dart` — replaces `lib/presentation/shared/widgets/flame_icon.dart`
- `lib/presentation/workouts/providers/flame_progress_provider.dart` — new

---

## Feature 3: Advanced Rest Timer

**Problem:** Flutter has a basic timer with ring countdown. Missing: urgent state, overtime mode, floating widget, audio/haptic feedback.

**Solution:**

`RestTimerNotifier` — Riverpod StateNotifier with 3 states:

1. **Counting** (normal): orange ring, MM:SS countdown, auto-starts after set completion using `ExerciseSet.restDuration`
2. **Urgent** (≤5 seconds): red ring with glow + drop shadow, red text, beep tick audio every second, light haptic every second
3. **Overtime** (timer expired, user still resting): green ring fully filled, counts up with "+0:12" format, tracks `actualRestDuration` for API submission

`RestTimerOverlay` — inline timer widget:
- Circular ring (160px) with progress arc, color changes per state
- Center: MM:SS (or +MM:SS in overtime)
- Preview of next set below timer (exercise name, target reps × weight)
- "Salta recupero" button

`FloatingTimerWidget` — persistent mini timer:
- Appears when user navigates to a different exercise while timer is running
- Glassmorphic design: backdrop blur + colored border matching state
- Shows: mini ring (36px) + time + exercise name + "Tap per tornare"
- Position: bottom-right, above navigation
- Inherits state colors (orange/red/green)
- Tap navigates back to the exercise with active timer

**Files:**
- `lib/presentation/workouts/providers/rest_timer_provider.dart` — new
- `lib/presentation/workouts/widgets/rest_timer_overlay.dart` — rewrite of `rest_timer_widget.dart`
- `lib/presentation/workouts/widgets/floating_timer_widget.dart` — new

---

## Feature 4: Next Exercise Countdown

**Problem:** Not implemented in Flutter. PWA had 5-second auto-advance after completing last set of an exercise.

**Solution:**

Trigger: when the last target set of an exercise is completed (not extra sets).

UI — `NextExerciseCountdown` widget:
- Slide-up animation from bottom with green gradient background
- Shows: "PROSSIMO ESERCIZIO" label, exercise name, set × reps info
- Circular countdown ring (48px) counting 5→0 seconds in teal (#00D4AA)
- "Vai ora →" button for immediate skip
- At 0: auto-swipes PageView to next exercise + haptic medium impact
- On last exercise of workout: shows "Completa Allenamento" instead

**Files:**
- `lib/presentation/workouts/widgets/next_exercise_countdown.dart` — new

---

## Feature 5: Android Persistent Notification

**Problem:** When user switches to another app or locks phone, they lose visibility of workout state and timer.

**Solution:**

`WorkoutNotificationService` — Android Foreground Service:

- Starts when workout begins, stops on completion/cancel
- Notification content:
  - Title: "Push Day — 42%" (plan name + progress)
  - Body: "Panca Piana · Serie 3/4" (current exercise + set)
  - When timer active: shows countdown in real-time
- Action buttons:
  - "Completa Set" — logs current set with target values
  - "Salta Recupero" — skips rest timer
- Updates in real-time (timer countdown, exercise changes, progress)
- Implementation: `flutter_local_notifications` + `flutter_foreground_task` packages
- Graceful degradation: noop on web/PWA (check `kIsWeb`)

**Files:**
- `lib/presentation/workouts/services/workout_notification_service.dart` — new

---

## Feature 6: Exercise Carousel with Progress Overview

**Problem:** Current PageView works but lacks position awareness. PWA had a 3-level view hierarchy.

**Solution:**

Hybrid approach — carousel as primary view + expandable overview:

`ExerciseCarousel`:
- Horizontal PageView, one exercise per page, swipe to navigate
- Smooth page transitions with slight scale effect on adjacent pages

`ProgressIndicatorBar`:
- Horizontal dots below app bar: teal (completed), orange (current), gray (pending)
- "3/5" counter text
- Tap dots: expands into full exercise overview list (bottom sheet or inline expand)
- Overview shows all exercises with completion status, tap to jump to any exercise
- Collapses back to dots on selection or swipe down

**Files:**
- `lib/presentation/workouts/widgets/exercise_carousel.dart` — extracted from LiveWorkoutScreen
- `lib/presentation/workouts/widgets/progress_indicator_bar.dart` — new

---

## Feature 7: Enhanced Gestures & Set Input

**Problem:** Current set input uses a table layout with text fields. Functional but not premium.

**Solution:**

`SetInputCard` — redesigned as individual cards per set:

- Card layout: set number circle | reps input | weight input | "Completa" button
- Completed sets: teal check circle, muted values, "Fatto" label
- Active set: orange border, editable fields, prominent button
- Pending sets: gray, dimmed, non-interactive

Gestures:
- **Swipe left on active set:** quick-complete with current/target values + haptic light
- **Long press on completed set:** re-enable editing (allows corrections)
- **Number keyboard:** digits only for reps, digits + decimal for weight

**Files:**
- `lib/presentation/workouts/widgets/set_input_card.dart` — new (replaces _SetTable)

---

## Feature 8: Haptic & Audio Feedback

**Problem:** No sensory feedback in current implementation.

**Solution:**

`HapticService`:
- Set completed: `HapticFeedback.lightImpact()`
- Exercise completed: `HapticFeedback.mediumImpact()`
- Timer urgent (each second): `HapticFeedback.lightImpact()`
- Workout 100%: `HapticFeedback.heavyImpact()` + vibration pattern
- Next exercise auto-advance: `HapticFeedback.mediumImpact()`
- Graceful degradation: noop on web via `kIsWeb` check
- Toggleable from Settings screen

`AudioService`:
- Timer urgent tick: short beep each second (≤5s remaining)
- Timer expired: longer ding sound
- Workout completed: celebration sound
- Implementation: `audioplayers` package with bundled asset audio files
- Toggleable from Settings screen (independent from haptic toggle)

**Files:**
- `lib/presentation/workouts/services/haptic_service.dart` — new
- `lib/presentation/workouts/services/audio_service.dart` — new

---

## Architecture

### State Management Migration

Current: local `StatefulWidget` state with `Map<int, Map<int, _SetInput>>` and scattered `setState()` calls.

New: Riverpod providers:

```
WorkoutStateNotifier (StateNotifier<WorkoutState>)
├── exercises: List<ExerciseExecution>
├── completedSets: Set<String>
├── currentPage: int
├── totalSets / completedSetCount (computed)
└── methods: logSet(), completeExercise(), completeWorkout()

RestTimerNotifier (StateNotifier<RestTimerState>)
├── status: RestTimerStatus (idle/counting/urgent/overtime)
├── remaining: int (seconds)
├── total: int (seconds)
├── exerciseId: int (which exercise started the timer)
└── methods: start(), skip(), tick()

FlameProgressNotifier (StateNotifier<FlameProgressState>)
├── progress: double (0.0-1.0)
├── scale, opacity, speed, glow: double (interpolated)
└── isComplete: bool
```

`LiveWorkoutScreen` becomes a thin orchestrator that reads these providers and composes the widget tree. No local state beyond `PageController` and `TextEditingControllers`.

### What Gets Reused (Unchanged)

- `lib/data/models/execution_models.dart` — Freezed DTOs
- `lib/data/datasources/remote/workout_remote_datasource.dart` — API calls
- `lib/data/repositories/workout_repository_impl.dart` — repository
- `lib/domain/repositories/workout_repository.dart` — interface
- `lib/core/storage/pending_sets_storage.dart` — offline queue
- `lib/core/connectivity/sync_service.dart` — sync on reconnect
- GoRouter route configuration

### What Gets Rewritten

- `LiveWorkoutScreen` — from monolith to thin orchestrator
- `RestTimerWidget` → `RestTimerOverlay` (3 states + new design)
- Set input table → `SetInputCard` cards with gestures

### What's New

- 3 Riverpod providers (workout state, timer, flame)
- `FlameWidget` (animated CustomPainter)
- `FloatingTimerWidget`
- `NextExerciseCountdown`
- `ProgressIndicatorBar`
- `StartWorkoutSheet` (bottom sheet)
- `RecentActivityList` (dashboard)
- `WorkoutNotificationService` (Android foreground)
- `HapticService` + `AudioService`

### New Dependencies

- `audioplayers` — audio playback for timer sounds
- `flutter_foreground_task` — Android foreground service
- `flutter_local_notifications` — notification display (may already be present for FCM)

---

## Platform Behavior

| Feature | Android APK | Web/PWA |
|---------|-------------|---------|
| Flame animation | Full | Full |
| Rest timer (3 states) | Full | Full |
| Floating timer | Full | Full |
| Next exercise countdown | Full | Full |
| Haptic feedback | Full | Noop (graceful) |
| Audio feedback | Full | Full (Web Audio API) |
| Persistent notification | Full (foreground service) | Noop (graceful) |
| Swipe gestures | Full | Full (touch/trackpad) |

---

## File Structure (Complete)

```
lib/presentation/workouts/
├── providers/
│   ├── workout_state_provider.dart
│   ├── rest_timer_provider.dart
│   └── flame_progress_provider.dart
├── screens/
│   ├── live_workout_screen.dart          # Thin orchestrator
│   └── workout_completion_screen.dart
├── widgets/
│   ├── exercise_carousel.dart
│   ├── set_input_card.dart
│   ├── flame_widget.dart
│   ├── rest_timer_overlay.dart
│   ├── floating_timer_widget.dart
│   ├── progress_indicator_bar.dart
│   ├── next_exercise_countdown.dart
│   └── start_workout_sheet.dart
└── services/
    ├── haptic_service.dart
    ├── audio_service.dart
    └── workout_notification_service.dart

lib/presentation/dashboard/
├── widgets/
│   ├── active_workout_card.dart          # Updated
│   └── recent_activity_list.dart         # New
└── screens/
    └── dashboard_screen.dart             # Updated
```
