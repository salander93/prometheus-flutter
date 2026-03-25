# Workout Experience Redesign — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refactor the live workout system from a monolithic StatefulWidget into Riverpod-driven components, achieve PWA feature parity (flame animation, advanced timer, next exercise countdown), and add native mobile enhancements (haptic, audio, Android notification).

**Architecture:** Decompose `LiveWorkoutScreen` (1049-line monolith) into 3 Riverpod StateNotifiers (workout state, rest timer, flame progress) + 7 focused widgets + 3 services. Reuse existing data layer (models, API datasource, repository, offline sync) unchanged.

**Tech Stack:** Flutter 3.41+, Riverpod 2.x (StateNotifier), CustomPainter (flame), AnimationController (timer/flame), audioplayers (audio), flutter_foreground_task (Android notification)

**Spec:** `docs/superpowers/specs/2026-03-25-workout-experience-redesign.md`

---

## File Structure

```
# NEW files
lib/presentation/workouts/providers/workout_state_provider.dart      # WorkoutStateNotifier — global workout session state
lib/presentation/workouts/providers/rest_timer_provider.dart         # RestTimerNotifier — 3-state timer
lib/presentation/workouts/providers/flame_progress_provider.dart     # FlameProgressNotifier — flame interpolation
lib/presentation/workouts/widgets/exercise_carousel.dart             # PageView extraction
lib/presentation/workouts/widgets/set_input_card.dart                # Single set card with gestures
lib/presentation/workouts/widgets/flame_widget.dart                  # 4-layer animated flame
lib/presentation/workouts/widgets/rest_timer_overlay.dart            # Timer with 3 states (replaces rest_timer_widget.dart)
lib/presentation/workouts/widgets/floating_timer_widget.dart         # Mini persistent timer
lib/presentation/workouts/widgets/progress_indicator_bar.dart        # Dots + expandable overview
lib/presentation/workouts/widgets/next_exercise_countdown.dart       # 5s auto-advance
lib/presentation/workouts/widgets/start_workout_sheet.dart           # Bottom sheet for session/week
lib/presentation/workouts/services/haptic_service.dart               # Haptic feedback abstraction
lib/presentation/workouts/services/audio_service.dart                # Audio feedback for timer
lib/presentation/workouts/services/workout_notification_service.dart # Android foreground notification
lib/presentation/dashboard/widgets/client_recent_activity_list.dart  # Client-facing storico
assets/audio/tick.wav                                                # Timer urgent tick
assets/audio/ding.wav                                                # Timer expired
assets/audio/celebration.wav                                         # Workout complete

# MODIFIED files
lib/presentation/workouts/screens/live_workout_screen.dart           # Rewrite as thin orchestrator
lib/presentation/shared/providers/workout_providers.dart             # Add sessionSuggestionProvider
lib/presentation/dashboard/screens/dashboard_screen.dart             # Wire buttons, add storico
lib/presentation/dashboard/widgets/active_workout_card.dart          # Wire navigation callbacks
lib/presentation/profile/screens/settings_screen.dart                # Add audio/haptic toggles
lib/data/models/workout_models.dart                                  # Extend ActivityLogSummary
pubspec.yaml                                                         # Add dependencies + audio assets
android/app/src/main/AndroidManifest.xml                             # Foreground service permissions
```

---

## Task 1: Add Dependencies & Assets Setup

**Files:**
- Modify: `pubspec.yaml`
- Create: `assets/audio/` directory (placeholder files)

- [ ] **Step 1: Add new dependencies to pubspec.yaml**

Add under `dependencies:` after existing entries:

```yaml
  audioplayers: ^6.1.0
  flutter_foreground_task: ^8.10.0
```

Add under `flutter: > assets:`:

```yaml
    - assets/audio/
```

- [ ] **Step 2: Create audio assets directory with placeholder files**

```bash
mkdir -p assets/audio
# Create minimal valid WAV files as placeholders (will be replaced with real sounds later)
# For now, create empty placeholder files
touch assets/audio/tick.wav assets/audio/ding.wav assets/audio/celebration.wav
```

- [ ] **Step 3: Run flutter pub get**

Run: `flutter pub get`
Expected: No errors, dependencies resolved

- [ ] **Step 4: Commit**

```bash
git add pubspec.yaml pubspec.lock assets/audio/
git commit -m "chore: add audioplayers and flutter_foreground_task dependencies + audio assets dir"
```

---

## Task 2: HapticService & AudioService

**Files:**
- Create: `lib/presentation/workouts/services/haptic_service.dart`
- Create: `lib/presentation/workouts/services/audio_service.dart`
- Test: `test/presentation/workouts/services/haptic_service_test.dart`
- Test: `test/presentation/workouts/services/audio_service_test.dart`

- [ ] **Step 1: Write haptic service test**

```dart
// test/presentation/workouts/services/haptic_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/presentation/workouts/services/haptic_service.dart';

void main() {
  group('HapticService', () {
    late HapticService service;

    setUp(() {
      service = HapticService();
    });

    test('setCompleted does not throw', () {
      expect(() => service.setCompleted(), returnsNormally);
    });

    test('exerciseCompleted does not throw', () {
      expect(() => service.exerciseCompleted(), returnsNormally);
    });

    test('workoutCompleted does not throw', () {
      expect(() => service.workoutCompleted(), returnsNormally);
    });

    test('timerTick does not throw', () {
      expect(() => service.timerTick(), returnsNormally);
    });

    test('disabled service is noop', () {
      service.enabled = false;
      expect(() => service.setCompleted(), returnsNormally);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/presentation/workouts/services/haptic_service_test.dart`
Expected: FAIL — cannot find `HapticService`

- [ ] **Step 3: Implement HapticService**

```dart
// lib/presentation/workouts/services/haptic_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hapticServiceProvider = Provider<HapticService>((ref) => HapticService());

class HapticService {
  bool enabled = true;

  bool get _canVibrate => enabled && !kIsWeb;

  void setCompleted() {
    if (!_canVibrate) return;
    HapticFeedback.lightImpact();
  }

  void exerciseCompleted() {
    if (!_canVibrate) return;
    HapticFeedback.mediumImpact();
  }

  void workoutCompleted() {
    if (!_canVibrate) return;
    HapticFeedback.heavyImpact();
  }

  void timerTick() {
    if (!_canVibrate) return;
    HapticFeedback.lightImpact();
  }

  void nextExercise() {
    if (!_canVibrate) return;
    HapticFeedback.mediumImpact();
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/presentation/workouts/services/haptic_service_test.dart`
Expected: All PASS

- [ ] **Step 5: Write audio service test**

```dart
// test/presentation/workouts/services/audio_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/presentation/workouts/services/audio_service.dart';

void main() {
  group('AudioService', () {
    late AudioService service;

    setUp(() {
      service = AudioService();
    });

    test('playTick does not throw when disabled', () async {
      service.enabled = false;
      expect(() => service.playTick(), returnsNormally);
    });

    test('playDing does not throw when disabled', () async {
      service.enabled = false;
      expect(() => service.playDing(), returnsNormally);
    });

    test('playCelebration does not throw when disabled', () async {
      service.enabled = false;
      expect(() => service.playCelebration(), returnsNormally);
    });

    test('dispose does not throw', () {
      expect(() => service.dispose(), returnsNormally);
    });
  });
}
```

- [ ] **Step 6: Run test to verify it fails**

Run: `flutter test test/presentation/workouts/services/audio_service_test.dart`
Expected: FAIL — cannot find `AudioService`

- [ ] **Step 7: Implement AudioService**

```dart
// lib/presentation/workouts/services/audio_service.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(() => service.dispose());
  return service;
});

class AudioService {
  bool enabled = true;
  final AudioPlayer _player = AudioPlayer();

  void playTick() {
    if (!enabled) return;
    _play('audio/tick.wav');
  }

  void playDing() {
    if (!enabled) return;
    _play('audio/ding.wav');
  }

  void playCelebration() {
    if (!enabled) return;
    _play('audio/celebration.wav');
  }

  void _play(String asset) {
    try {
      _player.play(AssetSource(asset));
    } catch (_) {
      // Graceful: audio files may be placeholders during dev
    }
  }

  void dispose() {
    _player.dispose();
  }
}
```

- [ ] **Step 8: Run test to verify it passes**

Run: `flutter test test/presentation/workouts/services/audio_service_test.dart`
Expected: All PASS

- [ ] **Step 9: Commit**

```bash
git add lib/presentation/workouts/services/haptic_service.dart \
        lib/presentation/workouts/services/audio_service.dart \
        test/presentation/workouts/services/
git commit -m "feat: add HapticService and AudioService with platform-aware graceful degradation"
```

---

## Task 3: WorkoutStateNotifier (Riverpod Provider)

**Files:**
- Create: `lib/presentation/workouts/providers/workout_state_provider.dart`
- Test: `test/presentation/workouts/providers/workout_state_provider_test.dart`

- [ ] **Step 1: Write test for WorkoutStateNotifier**

```dart
// test/presentation/workouts/providers/workout_state_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/presentation/workouts/providers/workout_state_provider.dart';
import 'package:palestra/data/models/execution_models.dart';

void main() {
  group('WorkoutState', () {
    test('initial state has zero progress', () {
      final state = WorkoutState(
        exercises: [],
        completedKeys: {},
        currentPage: 0,
      );
      expect(state.totalSets, 0);
      expect(state.completedSetCount, 0);
      expect(state.progress, 0.0);
    });

    test('progress is calculated correctly', () {
      final state = WorkoutState(
        exercises: [],
        completedKeys: {'1:1', '1:2'},
        currentPage: 0,
        totalSetCount: 4,
      );
      expect(state.completedSetCount, 2);
      expect(state.progress, 0.5);
    });

    test('isExerciseComplete returns true when all sets done', () {
      final state = WorkoutState(
        exercises: [],
        completedKeys: {'100:1', '100:2', '100:3'},
        currentPage: 0,
      );
      expect(state.isExerciseComplete(100, 3), true);
      expect(state.isExerciseComplete(100, 4), false);
    });
  });

  group('WorkoutStateNotifier', () {
    test('markSetCompleted adds key', () {
      final notifier = WorkoutStateNotifier();
      notifier.initialize(exercises: [], totalSets: 10);
      notifier.markSetCompleted(exerciseExecId: 1, setNumber: 1);
      expect(notifier.state.completedKeys.contains('1:1'), true);
    });

    test('revertSetCompleted removes key', () {
      final notifier = WorkoutStateNotifier();
      notifier.initialize(exercises: [], totalSets: 10);
      notifier.markSetCompleted(exerciseExecId: 1, setNumber: 1);
      notifier.revertSetCompleted(exerciseExecId: 1, setNumber: 1);
      expect(notifier.state.completedKeys.contains('1:1'), false);
    });

    test('setCurrentPage updates page', () {
      final notifier = WorkoutStateNotifier();
      notifier.initialize(exercises: [], totalSets: 10);
      notifier.setCurrentPage(2);
      expect(notifier.state.currentPage, 2);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/presentation/workouts/providers/workout_state_provider_test.dart`
Expected: FAIL — cannot find imports

- [ ] **Step 3: Implement WorkoutStateNotifier**

```dart
// lib/presentation/workouts/providers/workout_state_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palestra/data/models/execution_models.dart';

final workoutStateProvider =
    StateNotifierProvider.autoDispose<WorkoutStateNotifier, WorkoutState>(
  (ref) => WorkoutStateNotifier(),
);

class WorkoutState {
  final List<ExerciseExecution> exercises;
  final Set<String> completedKeys;
  final int currentPage;
  final int totalSetCount;
  final bool showCompletion;

  const WorkoutState({
    required this.exercises,
    required this.completedKeys,
    required this.currentPage,
    this.totalSetCount = 0,
    this.showCompletion = false,
  });

  int get totalSets => totalSetCount;
  int get completedSetCount => completedKeys.length;
  double get progress => totalSets == 0 ? 0.0 : completedSetCount / totalSets;

  bool isSetCompleted(int exerciseExecId, int setNumber) =>
      completedKeys.contains('$exerciseExecId:$setNumber');

  bool isExerciseComplete(int exerciseExecId, int targetSets) {
    for (int i = 1; i <= targetSets; i++) {
      if (!completedKeys.contains('$exerciseExecId:$i')) return false;
    }
    return true;
  }

  WorkoutState copyWith({
    List<ExerciseExecution>? exercises,
    Set<String>? completedKeys,
    int? currentPage,
    int? totalSetCount,
    bool? showCompletion,
  }) =>
      WorkoutState(
        exercises: exercises ?? this.exercises,
        completedKeys: completedKeys ?? this.completedKeys,
        currentPage: currentPage ?? this.currentPage,
        totalSetCount: totalSetCount ?? this.totalSetCount,
        showCompletion: showCompletion ?? this.showCompletion,
      );
}

class WorkoutStateNotifier extends StateNotifier<WorkoutState> {
  WorkoutStateNotifier()
      : super(const WorkoutState(
          exercises: [],
          completedKeys: {},
          currentPage: 0,
        ));

  void initialize({
    required List<ExerciseExecution> exercises,
    required int totalSets,
    Set<String>? alreadyCompleted,
  }) {
    state = WorkoutState(
      exercises: exercises,
      completedKeys: alreadyCompleted ?? {},
      currentPage: 0,
      totalSetCount: totalSets,
    );
  }

  void markSetCompleted({required int exerciseExecId, required int setNumber}) {
    final key = '$exerciseExecId:$setNumber';
    state = state.copyWith(completedKeys: {...state.completedKeys, key});
  }

  void revertSetCompleted({required int exerciseExecId, required int setNumber}) {
    final key = '$exerciseExecId:$setNumber';
    state = state.copyWith(
      completedKeys: state.completedKeys.where((k) => k != key).toSet(),
    );
  }

  void setCurrentPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void showCompletion() {
    state = state.copyWith(showCompletion: true);
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/presentation/workouts/providers/workout_state_provider_test.dart`
Expected: All PASS

- [ ] **Step 5: Commit**

```bash
git add lib/presentation/workouts/providers/workout_state_provider.dart \
        test/presentation/workouts/providers/
git commit -m "feat: add WorkoutStateNotifier — Riverpod state for workout session"
```

---

## Task 4: RestTimerNotifier (3-state timer)

**Files:**
- Create: `lib/presentation/workouts/providers/rest_timer_provider.dart`
- Test: `test/presentation/workouts/providers/rest_timer_provider_test.dart`

- [ ] **Step 1: Write test for RestTimerNotifier**

```dart
// test/presentation/workouts/providers/rest_timer_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/presentation/workouts/providers/rest_timer_provider.dart';

void main() {
  group('RestTimerState', () {
    test('idle state', () {
      const state = RestTimerState.idle();
      expect(state.status, RestTimerStatus.idle);
      expect(state.isActive, false);
    });

    test('counting state', () {
      const state = RestTimerState(
        status: RestTimerStatus.counting,
        remaining: 60,
        total: 90,
        exerciseExecId: 1,
      );
      expect(state.isActive, true);
      expect(state.progressFraction, closeTo(0.333, 0.01));
    });

    test('urgent at 5 seconds', () {
      const state = RestTimerState(
        status: RestTimerStatus.urgent,
        remaining: 3,
        total: 90,
        exerciseExecId: 1,
      );
      expect(state.status, RestTimerStatus.urgent);
    });

    test('overtime counts up', () {
      const state = RestTimerState(
        status: RestTimerStatus.overtime,
        remaining: -12,
        total: 90,
        exerciseExecId: 1,
      );
      expect(state.overtimeSeconds, 12);
    });

    test('formatted time', () {
      const state = RestTimerState(
        status: RestTimerStatus.counting,
        remaining: 95,
        total: 120,
        exerciseExecId: 1,
      );
      expect(state.formattedTime, '1:35');
    });

    test('formatted overtime time', () {
      const state = RestTimerState(
        status: RestTimerStatus.overtime,
        remaining: -12,
        total: 90,
        exerciseExecId: 1,
      );
      expect(state.formattedTime, '+0:12');
    });
  });

  group('RestTimerNotifier', () {
    late RestTimerNotifier notifier;

    setUp(() {
      notifier = RestTimerNotifier();
    });

    tearDown(() {
      notifier.dispose();
    });

    test('start sets counting state', () {
      notifier.start(totalSeconds: 90, exerciseExecId: 1);
      expect(notifier.state.status, RestTimerStatus.counting);
      expect(notifier.state.remaining, 90);
      expect(notifier.state.total, 90);
    });

    test('skip resets to idle', () {
      notifier.start(totalSeconds: 90, exerciseExecId: 1);
      notifier.skip();
      expect(notifier.state.status, RestTimerStatus.idle);
    });

    test('reset returns to idle', () {
      notifier.start(totalSeconds: 90, exerciseExecId: 1);
      notifier.reset();
      expect(notifier.state.status, RestTimerStatus.idle);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/presentation/workouts/providers/rest_timer_provider_test.dart`
Expected: FAIL

- [ ] **Step 3: Implement RestTimerNotifier**

```dart
// lib/presentation/workouts/providers/rest_timer_provider.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RestTimerStatus { idle, counting, urgent, overtime }

final restTimerProvider =
    StateNotifierProvider.autoDispose<RestTimerNotifier, RestTimerState>(
  (ref) => RestTimerNotifier(),
);

class RestTimerState {
  final RestTimerStatus status;
  final int remaining; // seconds (negative = overtime)
  final int total;
  final int exerciseExecId;

  const RestTimerState({
    required this.status,
    this.remaining = 0,
    this.total = 0,
    this.exerciseExecId = 0,
  });

  const RestTimerState.idle()
      : status = RestTimerStatus.idle,
        remaining = 0,
        total = 0,
        exerciseExecId = 0;

  bool get isActive => status != RestTimerStatus.idle;
  int get overtimeSeconds => remaining < 0 ? remaining.abs() : 0;

  double get progressFraction {
    if (total == 0) return 0;
    if (status == RestTimerStatus.overtime) return 1.0;
    return 1.0 - (remaining / total);
  }

  String get formattedTime {
    if (status == RestTimerStatus.overtime) {
      final secs = overtimeSeconds;
      final m = secs ~/ 60;
      final s = secs % 60;
      return '+$m:${s.toString().padLeft(2, '0')}';
    }
    final m = remaining ~/ 60;
    final s = remaining % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  RestTimerState copyWith({
    RestTimerStatus? status,
    int? remaining,
    int? total,
    int? exerciseExecId,
  }) =>
      RestTimerState(
        status: status ?? this.status,
        remaining: remaining ?? this.remaining,
        total: total ?? this.total,
        exerciseExecId: exerciseExecId ?? this.exerciseExecId,
      );
}

class RestTimerNotifier extends StateNotifier<RestTimerState> {
  Timer? _timer;

  RestTimerNotifier() : super(const RestTimerState.idle());

  void start({required int totalSeconds, required int exerciseExecId}) {
    _timer?.cancel();
    state = RestTimerState(
      status: RestTimerStatus.counting,
      remaining: totalSeconds,
      total: totalSeconds,
      exerciseExecId: exerciseExecId,
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  void tick() {
    final next = state.remaining - 1;
    if (next <= 0 && state.status != RestTimerStatus.overtime) {
      // Transition to overtime
      state = state.copyWith(
        status: RestTimerStatus.overtime,
        remaining: next,
      );
    } else if (next > 0 && next <= 5 && state.status != RestTimerStatus.overtime) {
      // Transition to (or stay in) urgent
      state = state.copyWith(
        status: RestTimerStatus.urgent,
        remaining: next,
      );
    } else {
      state = state.copyWith(remaining: next);
    }
  }

  void skip() {
    _timer?.cancel();
    state = const RestTimerState.idle();
  }

  void reset() {
    _timer?.cancel();
    state = const RestTimerState.idle();
  }

  int get actualRestDuration {
    if (state.total == 0) return 0;
    return state.total - state.remaining;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/presentation/workouts/providers/rest_timer_provider_test.dart`
Expected: All PASS

- [ ] **Step 5: Commit**

```bash
git add lib/presentation/workouts/providers/rest_timer_provider.dart \
        test/presentation/workouts/providers/rest_timer_provider_test.dart
git commit -m "feat: add RestTimerNotifier with 3 states — counting, urgent, overtime"
```

---

## Task 5: FlameProgressNotifier

**Files:**
- Create: `lib/presentation/workouts/providers/flame_progress_provider.dart`
- Test: `test/presentation/workouts/providers/flame_progress_provider_test.dart`

- [ ] **Step 1: Write test for FlameProgressNotifier**

```dart
// test/presentation/workouts/providers/flame_progress_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/presentation/workouts/providers/flame_progress_provider.dart';

void main() {
  group('FlameProgressState', () {
    test('zero progress state', () {
      const state = FlameProgressState(progress: 0.0);
      expect(state.scale, closeTo(0.15, 0.01));
      expect(state.opacity, closeTo(0.2, 0.01));
      expect(state.isComplete, false);
    });

    test('50% progress state', () {
      const state = FlameProgressState(progress: 0.5);
      expect(state.scale, closeTo(0.55, 0.05));
      expect(state.opacity, closeTo(0.65, 0.05));
      expect(state.glow, closeTo(0.5, 0.05));
    });

    test('100% progress state', () {
      const state = FlameProgressState(progress: 1.0);
      expect(state.scale, closeTo(1.0, 0.01));
      expect(state.opacity, closeTo(1.0, 0.01));
      expect(state.glow, closeTo(0.9, 0.01));
      expect(state.isComplete, true);
    });

    test('progress clamped to 0-1', () {
      const state = FlameProgressState(progress: 1.5);
      expect(state.scale, closeTo(1.0, 0.01));
    });
  });

  group('FlameProgressNotifier', () {
    test('update sets progress', () {
      final notifier = FlameProgressNotifier();
      notifier.update(completedSets: 5, totalSets: 10);
      expect(notifier.state.progress, 0.5);
    });

    test('zero total sets gives zero progress', () {
      final notifier = FlameProgressNotifier();
      notifier.update(completedSets: 0, totalSets: 0);
      expect(notifier.state.progress, 0.0);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/presentation/workouts/providers/flame_progress_provider_test.dart`
Expected: FAIL

- [ ] **Step 3: Implement FlameProgressNotifier**

```dart
// lib/presentation/workouts/providers/flame_progress_provider.dart
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final flameProgressProvider =
    StateNotifierProvider.autoDispose<FlameProgressNotifier, FlameProgressState>(
  (ref) => FlameProgressNotifier(),
);

class FlameProgressState {
  final double progress; // 0.0 to 1.0

  const FlameProgressState({required this.progress});

  double get _clamped => progress.clamp(0.0, 1.0);

  // Interpolated parameters matching PWA flame behavior
  double get scale => _lerp(0.15, 1.0);
  double get opacity => _lerp(0.2, 1.0);
  double get speedSeconds => _lerp(0.5, 0.2); // faster as progress increases
  double get glow => _lerp(0.0, 0.9);
  bool get isComplete => _clamped >= 1.0;
  int get percent => (_clamped * 100).round();

  double _lerp(double from, double to) {
    // easeOutCubic curve for smoother ramp-up
    final t = _clamped;
    final curved = 1.0 - math.pow(1.0 - t, 3).toDouble();
    return from + (to - from) * curved;
  }
}

class FlameProgressNotifier extends StateNotifier<FlameProgressState> {
  FlameProgressNotifier() : super(const FlameProgressState(progress: 0.0));

  void update({required int completedSets, required int totalSets}) {
    final progress = totalSets == 0 ? 0.0 : completedSets / totalSets;
    state = FlameProgressState(progress: progress);
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/presentation/workouts/providers/flame_progress_provider_test.dart`
Expected: All PASS

- [ ] **Step 5: Commit**

```bash
git add lib/presentation/workouts/providers/flame_progress_provider.dart \
        test/presentation/workouts/providers/flame_progress_provider_test.dart
git commit -m "feat: add FlameProgressNotifier — interpolated flame parameters from workout progress"
```

---

## Task 6: FlameWidget (Animated CustomPainter)

**Files:**
- Create: `lib/presentation/workouts/widgets/flame_widget.dart`
- Test: `test/presentation/workouts/widgets/flame_widget_test.dart`

- [ ] **Step 1: Write widget test**

```dart
// test/presentation/workouts/widgets/flame_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/presentation/workouts/widgets/flame_widget.dart';

void main() {
  group('FlameWidget', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlameWidget(
              scale: 0.5,
              opacity: 0.7,
              speedSeconds: 0.3,
              glow: 0.5,
              size: 48,
            ),
          ),
        ),
      );
      expect(find.byType(FlameWidget), findsOneWidget);
    });

    testWidgets('compact mode renders small', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlameWidget(
              scale: 1.0,
              opacity: 1.0,
              speedSeconds: 0.2,
              glow: 0.9,
              size: 28,
            ),
          ),
        ),
      );
      final box = tester.renderObject<RenderBox>(find.byType(FlameWidget));
      expect(box.size.width, 28);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/presentation/workouts/widgets/flame_widget_test.dart`
Expected: FAIL

- [ ] **Step 3: Implement FlameWidget**

```dart
// lib/presentation/workouts/widgets/flame_widget.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

class FlameWidget extends StatefulWidget {
  final double scale;
  final double opacity;
  final double speedSeconds;
  final double glow;
  final double size;

  const FlameWidget({
    super.key,
    required this.scale,
    required this.opacity,
    required this.speedSeconds,
    required this.glow,
    this.size = 48,
  });

  @override
  State<FlameWidget> createState() => _FlameWidgetState();
}

class _FlameWidgetState extends State<FlameWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _waveControllers;
  late List<AnimationController> _sparkControllers;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    // 4 wave controllers for the 4 flame layers
    _waveControllers = List.generate(4, (i) {
      final controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: (widget.speedSeconds * 1000).toInt(),
        ),
      );
      // Stagger start times
      Future.delayed(Duration(milliseconds: i * 80), () {
        if (mounted) controller.repeat(reverse: true);
      });
      return controller;
    });

    // 5 spark controllers
    _sparkControllers = List.generate(5, (i) {
      final controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 800 + i * 200),
      );
      Future.delayed(Duration(milliseconds: i * 300), () {
        if (mounted) controller.repeat();
      });
      return controller;
    });
  }

  @override
  void didUpdateWidget(FlameWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.speedSeconds != widget.speedSeconds) {
      for (final c in _waveControllers) {
        c.duration = Duration(
          milliseconds: (widget.speedSeconds * 1000).toInt(),
        );
      }
    }
  }

  @override
  void dispose() {
    for (final c in _waveControllers) {
      c.dispose();
    }
    for (final c in _sparkControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([..._waveControllers, ..._sparkControllers]),
        builder: (context, _) {
          return Opacity(
            opacity: widget.opacity.clamp(0.0, 1.0),
            child: CustomPaint(
              painter: _FlamePainter(
                scale: widget.scale,
                glow: widget.glow,
                waveValues: _waveControllers.map((c) => c.value).toList(),
                sparkValues: _sparkControllers.map((c) => c.value).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FlamePainter extends CustomPainter {
  final double scale;
  final double glow;
  final List<double> waveValues;
  final List<double> sparkValues;

  _FlamePainter({
    required this.scale,
    required this.glow,
    required this.waveValues,
    required this.sparkValues,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height;

    // Glow at base
    if (glow > 0) {
      final glowPaint = Paint()
        ..color = const Color(0xFFFF6B35).withValues(alpha: glow * 0.4)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, glow * 15);
      canvas.drawCircle(Offset(cx, cy - 4), size.width * 0.3 * scale, glowPaint);
    }

    // Layer definitions: [widthFraction, heightFraction, colors]
    final layers = [
      [0.6, 0.75, const Color(0xFFD84315), const Color(0xFFFFB74D)],
      [0.45, 0.63, const Color(0xFFFF5722), const Color(0xFFFFEB3B)],
      [0.32, 0.5, const Color(0xFFFF9800), const Color(0xFFFFF59D)],
      [0.2, 0.35, const Color(0xFFFFC107), const Color(0xFFFFFFFF)],
    ];

    for (int i = 0; i < 4; i++) {
      final wave = i < waveValues.length ? waveValues[i] : 0.0;
      final w = size.width * (layers[i][0] as double) * scale;
      final h = size.height * (layers[i][1] as double) * scale;
      final wobble = (wave - 0.5) * 4 * scale;

      final path = Path();
      final left = cx - w / 2 + wobble;
      final right = cx + w / 2 + wobble;
      final top = cy - h;

      path.moveTo(cx + wobble, top);
      path.quadraticBezierTo(right + w * 0.1, top + h * 0.4, right, cy);
      path.lineTo(left, cy);
      path.quadraticBezierTo(left - w * 0.1, top + h * 0.4, cx + wobble, top);
      path.close();

      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [layers[i][2] as Color, layers[i][3] as Color],
        ).createShader(Rect.fromLTWH(left, top, w, h));

      canvas.drawPath(path, paint);
    }

    // Sparks
    if (scale > 0.3) {
      final sparkPositions = [0.22, 0.65, 0.45, 0.32, 0.58];
      for (int i = 0; i < 5 && i < sparkValues.length; i++) {
        final sv = sparkValues[i];
        final sx = size.width * sparkPositions[i];
        final sy = cy - (sv * size.height * 0.8 * scale);
        final sparkAlpha = (1.0 - sv) * scale;

        final sparkPaint = Paint()
          ..color = const Color(0xFFFFB74D).withValues(alpha: sparkAlpha.clamp(0.0, 1.0));
        canvas.drawCircle(
          Offset(sx + math.sin(sv * math.pi) * 4, sy),
          2 * scale,
          sparkPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_FlamePainter old) => true;
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/presentation/workouts/widgets/flame_widget_test.dart`
Expected: All PASS

- [ ] **Step 5: Commit**

```bash
git add lib/presentation/workouts/widgets/flame_widget.dart \
        test/presentation/workouts/widgets/flame_widget_test.dart
git commit -m "feat: add FlameWidget — 4-layer animated flame with sparks and glow"
```

---

## Task 7: RestTimerOverlay (3-state timer UI)

**Files:**
- Create: `lib/presentation/workouts/widgets/rest_timer_overlay.dart`
- Test: `test/presentation/workouts/widgets/rest_timer_overlay_test.dart`

- [ ] **Step 1: Write widget test**

```dart
// test/presentation/workouts/widgets/rest_timer_overlay_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/presentation/workouts/providers/rest_timer_provider.dart';
import 'package:palestra/presentation/workouts/widgets/rest_timer_overlay.dart';

void main() {
  group('RestTimerOverlay', () {
    testWidgets('shows formatted time', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestTimerOverlay(
              state: const RestTimerState(
                status: RestTimerStatus.counting,
                remaining: 95,
                total: 120,
                exerciseExecId: 1,
              ),
              onSkip: () {},
              nextSetInfo: 'Panca Piana — Serie 3',
            ),
          ),
        ),
      );
      expect(find.text('1:35'), findsOneWidget);
      expect(find.text('Recupero'), findsOneWidget);
    });

    testWidgets('shows overtime format', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestTimerOverlay(
              state: const RestTimerState(
                status: RestTimerStatus.overtime,
                remaining: -12,
                total: 90,
                exerciseExecId: 1,
              ),
              onSkip: () {},
              nextSetInfo: 'Panca Piana — Serie 3',
            ),
          ),
        ),
      );
      expect(find.text('+0:12'), findsOneWidget);
    });

    testWidgets('skip button calls onSkip', (tester) async {
      var skipped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestTimerOverlay(
              state: const RestTimerState(
                status: RestTimerStatus.counting,
                remaining: 60,
                total: 90,
                exerciseExecId: 1,
              ),
              onSkip: () => skipped = true,
              nextSetInfo: 'Test',
            ),
          ),
        ),
      );
      await tester.tap(find.text('Salta recupero'));
      expect(skipped, true);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/presentation/workouts/widgets/rest_timer_overlay_test.dart`
Expected: FAIL

- [ ] **Step 3: Implement RestTimerOverlay**

```dart
// lib/presentation/workouts/widgets/rest_timer_overlay.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/presentation/workouts/providers/rest_timer_provider.dart';

class RestTimerOverlay extends StatelessWidget {
  final RestTimerState state;
  final VoidCallback onSkip;
  final String nextSetInfo;

  const RestTimerOverlay({
    super.key,
    required this.state,
    required this.onSkip,
    required this.nextSetInfo,
  });

  Color get _ringColor {
    switch (state.status) {
      case RestTimerStatus.urgent:
        return AppColors.danger;
      case RestTimerStatus.overtime:
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }

  Color get _textColor {
    switch (state.status) {
      case RestTimerStatus.urgent:
        return AppColors.danger;
      case RestTimerStatus.overtime:
        return AppColors.success;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Recupero',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textMuted,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 16),
        // Timer ring
        SizedBox(
          width: 180,
          height: 180,
          child: CustomPaint(
            painter: _TimerRingPainter(
              progress: state.progressFraction,
              color: _ringColor,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.formattedTime,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: _textColor,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  if (state.status != RestTimerStatus.overtime)
                    Text(
                      'di ${_formatTotal(state.total)}',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Next set preview
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                'PROSSIMO SET',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                nextSetInfo,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: onSkip,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.textMuted),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
          ),
          child: Text(
            'Salta recupero',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  String _formatTotal(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

class _TimerRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _TimerRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;

    // Background ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..color = Colors.white.withValues(alpha: 0.1),
    );

    // Progress arc
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..color = color;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_TimerRingPainter old) =>
      old.progress != progress || old.color != color;
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/presentation/workouts/widgets/rest_timer_overlay_test.dart`
Expected: All PASS

- [ ] **Step 5: Commit**

```bash
git add lib/presentation/workouts/widgets/rest_timer_overlay.dart \
        test/presentation/workouts/widgets/rest_timer_overlay_test.dart
git commit -m "feat: add RestTimerOverlay with 3 visual states — normal, urgent, overtime"
```

---

## Task 8: FloatingTimerWidget

**Files:**
- Create: `lib/presentation/workouts/widgets/floating_timer_widget.dart`
- Test: `test/presentation/workouts/widgets/floating_timer_widget_test.dart`

- [ ] **Step 1: Write widget test**

```dart
// test/presentation/workouts/widgets/floating_timer_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/presentation/workouts/providers/rest_timer_provider.dart';
import 'package:palestra/presentation/workouts/widgets/floating_timer_widget.dart';

void main() {
  group('FloatingTimerWidget', () {
    testWidgets('renders time and exercise name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FloatingTimerWidget(
              state: const RestTimerState(
                status: RestTimerStatus.counting,
                remaining: 83,
                total: 120,
                exerciseExecId: 1,
              ),
              exerciseName: 'Panca Piana',
              onTap: () {},
            ),
          ),
        ),
      );
      expect(find.text('1:23'), findsOneWidget);
      expect(find.text('Panca Piana'), findsOneWidget);
    });

    testWidgets('tap calls onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FloatingTimerWidget(
              state: const RestTimerState(
                status: RestTimerStatus.counting,
                remaining: 60,
                total: 90,
                exerciseExecId: 1,
              ),
              exerciseName: 'Test',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(FloatingTimerWidget));
      expect(tapped, true);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/presentation/workouts/widgets/floating_timer_widget_test.dart`
Expected: FAIL

- [ ] **Step 3: Implement FloatingTimerWidget**

```dart
// lib/presentation/workouts/widgets/floating_timer_widget.dart
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/presentation/workouts/providers/rest_timer_provider.dart';

class FloatingTimerWidget extends StatelessWidget {
  final RestTimerState state;
  final String exerciseName;
  final VoidCallback onTap;

  const FloatingTimerWidget({
    super.key,
    required this.state,
    required this.exerciseName,
    required this.onTap,
  });

  Color get _borderColor {
    switch (state.status) {
      case RestTimerStatus.urgent:
        return AppColors.danger;
      case RestTimerStatus.overtime:
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }

  String get _label {
    switch (state.status) {
      case RestTimerStatus.urgent:
        return 'Sbrigati!';
      default:
        return 'Recupero';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.backgroundCard.withValues(alpha: 0.95),
              border: Border.all(color: _borderColor),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _label,
                  style: TextStyle(
                    fontSize: 9,
                    color: state.status == RestTimerStatus.urgent
                        ? AppColors.danger
                        : AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Mini ring
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: CustomPaint(
                        painter: _MiniRingPainter(
                          progress: state.progressFraction,
                          color: _borderColor,
                        ),
                        child: Center(
                          child: Text(
                            state.formattedTime,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: state.status == RestTimerStatus.urgent
                                  ? AppColors.danger
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exerciseName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Tap per tornare',
                          style: TextStyle(
                            fontSize: 10,
                            color: state.status == RestTimerStatus.urgent
                                ? AppColors.danger
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _MiniRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.white.withValues(alpha: 0.1),
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_MiniRingPainter old) =>
      old.progress != progress || old.color != color;
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/presentation/workouts/widgets/floating_timer_widget_test.dart`
Expected: All PASS

- [ ] **Step 5: Commit**

```bash
git add lib/presentation/workouts/widgets/floating_timer_widget.dart \
        test/presentation/workouts/widgets/floating_timer_widget_test.dart
git commit -m "feat: add FloatingTimerWidget — glassmorphic mini timer with state colors"
```

---

## Task 9: ProgressIndicatorBar + NextExerciseCountdown + SetInputCard

**Files:**
- Create: `lib/presentation/workouts/widgets/progress_indicator_bar.dart`
- Create: `lib/presentation/workouts/widgets/next_exercise_countdown.dart`
- Create: `lib/presentation/workouts/widgets/set_input_card.dart`
- Test: `test/presentation/workouts/widgets/progress_indicator_bar_test.dart`

- [ ] **Step 1: Write test for ProgressIndicatorBar**

```dart
// test/presentation/workouts/widgets/progress_indicator_bar_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/presentation/workouts/widgets/progress_indicator_bar.dart';

void main() {
  group('ProgressIndicatorBar', () {
    testWidgets('shows correct count text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProgressIndicatorBar(
              total: 5,
              currentIndex: 2,
              completedIndices: const {0, 1},
              onTapIndex: (_) {},
            ),
          ),
        ),
      );
      expect(find.text('3/5'), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2: Implement ProgressIndicatorBar**

```dart
// lib/presentation/workouts/widgets/progress_indicator_bar.dart
import 'package:flutter/material.dart';
import 'package:palestra/core/theme/app_colors.dart';

class ProgressIndicatorBar extends StatelessWidget {
  final int total;
  final int currentIndex;
  final Set<int> completedIndices;
  final ValueChanged<int> onTapIndex;

  const ProgressIndicatorBar({
    super.key,
    required this.total,
    required this.currentIndex,
    required this.completedIndices,
    required this.onTapIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(total, (i) {
            Color color;
            if (completedIndices.contains(i)) {
              color = AppColors.success;
            } else if (i == currentIndex) {
              color = AppColors.primary;
            } else {
              color = Colors.white.withValues(alpha: 0.15);
            }
            return GestureDetector(
              onTap: () => onTapIndex(i),
              child: Container(
                width: 24,
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
          const SizedBox(width: 4),
          Text(
            '${currentIndex + 1}/$total',
            style: TextStyle(fontSize: 10, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Implement NextExerciseCountdown**

```dart
// lib/presentation/workouts/widgets/next_exercise_countdown.dart
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:palestra/core/theme/app_colors.dart';

class NextExerciseCountdown extends StatefulWidget {
  final String exerciseName;
  final String exerciseInfo;
  final bool isLastExercise;
  final VoidCallback onComplete;
  final VoidCallback onSkip;

  const NextExerciseCountdown({
    super.key,
    required this.exerciseName,
    required this.exerciseInfo,
    this.isLastExercise = false,
    required this.onComplete,
    required this.onSkip,
  });

  @override
  State<NextExerciseCountdown> createState() => _NextExerciseCountdownState();
}

class _NextExerciseCountdownState extends State<NextExerciseCountdown>
    with SingleTickerProviderStateMixin {
  int _remaining = 5;
  Timer? _timer;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..forward();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining <= 1) {
        _timer?.cancel();
        widget.onComplete();
      } else {
        setState(() => _remaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppColors.success.withValues(alpha: 0.15),
            Colors.transparent,
          ],
        ),
        border: Border(
          top: BorderSide(color: AppColors.success.withValues(alpha: 0.2)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.isLastExercise ? 'COMPLETA ALLENAMENTO' : 'PROSSIMO ESERCIZIO',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.success,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.exerciseName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          Text(
            widget.exerciseInfo,
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: AnimatedBuilder(
                  animation: _animController,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: _CountdownRingPainter(
                        progress: _animController.value,
                      ),
                      child: Center(
                        child: Text(
                          '$_remaining',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              FilledButton(
                onPressed: widget.onSkip,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: AppColors.backgroundBase,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: Text(
                  widget.isLastExercise ? 'Completa' : 'Vai ora →',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CountdownRingPainter extends CustomPainter {
  final double progress;

  _CountdownRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.white.withValues(alpha: 0.1),
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = AppColors.success,
    );
  }

  @override
  bool shouldRepaint(_CountdownRingPainter old) => old.progress != progress;
}
```

- [ ] **Step 4: Implement SetInputCard**

```dart
// lib/presentation/workouts/widgets/set_input_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palestra/core/theme/app_colors.dart';

class SetInputCard extends StatelessWidget {
  final int setNumber;
  final TextEditingController repsController;
  final TextEditingController weightController;
  final bool isCompleted;
  final bool isActive;
  final VoidCallback? onComplete;
  final VoidCallback? onLongPress;

  const SetInputCard({
    super.key,
    required this.setNumber,
    required this.repsController,
    required this.weightController,
    this.isCompleted = false,
    this.isActive = false,
    this.onComplete,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompleted) return _buildCompleted();
    if (isActive) return _buildActive();
    return _buildPending();
  }

  Widget _buildCompleted() {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.05),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 14, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  _ValueDisplay(label: 'RIP', value: repsController.text),
                  const SizedBox(width: 16),
                  _ValueDisplay(label: 'KG', value: weightController.text),
                ],
              ),
            ),
            Text(
              'Fatto',
              style: TextStyle(fontSize: 11, color: AppColors.success),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActive() {
    return Dismissible(
      key: ValueKey('set-$setNumber'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onComplete?.call();
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.check, color: AppColors.success),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          border: Border.all(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$setNumber',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  _CompactInput(
                    label: 'RIP',
                    controller: repsController,
                    decimal: false,
                  ),
                  const SizedBox(width: 12),
                  _CompactInput(
                    label: 'KG',
                    controller: weightController,
                    decimal: true,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: onComplete,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                minimumSize: Size.zero,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Completa', style: TextStyle(fontSize: 12)),
                  SizedBox(width: 4),
                  Icon(Icons.check, size: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPending() {
    return Opacity(
      opacity: 0.5,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$setNumber',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  _ValueDisplay(label: 'RIP', value: repsController.text),
                  const SizedBox(width: 16),
                  _ValueDisplay(label: 'KG', value: weightController.text),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValueDisplay extends StatelessWidget {
  final String label;
  final String value;

  const _ValueDisplay({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
        Text(
          value.isEmpty ? '-' : value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _CompactInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool decimal;

  const _CompactInput({
    required this.label,
    required this.controller,
    required this.decimal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.backgroundBase,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
          TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: decimal),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                decimal ? RegExp(r'[\d.]') : RegExp(r'\d'),
              ),
            ],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 5: Run all tests**

Run: `flutter test test/presentation/workouts/widgets/progress_indicator_bar_test.dart`
Expected: All PASS

- [ ] **Step 6: Commit**

```bash
git add lib/presentation/workouts/widgets/progress_indicator_bar.dart \
        lib/presentation/workouts/widgets/next_exercise_countdown.dart \
        lib/presentation/workouts/widgets/set_input_card.dart \
        test/presentation/workouts/widgets/progress_indicator_bar_test.dart
git commit -m "feat: add ProgressIndicatorBar, NextExerciseCountdown, and SetInputCard widgets"
```

---

## Task 10: Relocate sessionSuggestionProvider + StartWorkoutSheet

**Files:**
- Modify: `lib/presentation/shared/providers/workout_providers.dart` (add provider)
- Modify: `lib/presentation/workouts/screens/session_selector_screen.dart` (remove provider, import from shared)
- Create: `lib/presentation/workouts/widgets/start_workout_sheet.dart`

- [ ] **Step 1: Move sessionSuggestionProvider to shared providers**

In `lib/presentation/shared/providers/workout_providers.dart`, add after existing providers (around line 60):

```dart
final sessionSuggestionProvider =
    FutureProvider.family<SessionSuggestionResponse, int>((ref, planId) async {
  final repo = ref.read(workoutRepositoryProvider);
  return repo.suggestSession(planId);
});
```

Add import at top: `import 'package:palestra/data/models/execution_models.dart';`

- [ ] **Step 2: Update session_selector_screen.dart to use shared provider**

In `lib/presentation/workouts/screens/session_selector_screen.dart`:
- Remove lines 9-13 (the local `sessionSuggestionProvider` definition)
- Add import: `import 'package:palestra/presentation/shared/providers/workout_providers.dart';`
- The provider usage in the file stays the same (it references `sessionSuggestionProvider` which now comes from the import)

- [ ] **Step 3: Implement StartWorkoutSheet**

```dart
// lib/presentation/workouts/widgets/start_workout_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/execution_models.dart';
import 'package:palestra/presentation/shared/providers/workout_providers.dart';

class StartWorkoutSheet extends ConsumerStatefulWidget {
  final int planId;

  const StartWorkoutSheet({super.key, required this.planId});

  @override
  ConsumerState<StartWorkoutSheet> createState() => _StartWorkoutSheetState();
}

class _StartWorkoutSheetState extends ConsumerState<StartWorkoutSheet> {
  int? _selectedSessionId;
  int _weekNumber = 1;
  bool _isStarting = false;
  bool _defaultsSet = false;

  void _setDefaults(SessionSuggestionResponse suggestion) {
    if (_defaultsSet) return;
    _defaultsSet = true;
    _selectedSessionId = suggestion.suggestedSession?.id;
    _weekNumber = suggestion.suggestedWeek ?? 1;
  }

  Future<void> _start() async {
    if (_selectedSessionId == null || _isStarting) return;
    setState(() => _isStarting = true);
    try {
      final repo = ref.read(workoutRepositoryProvider);
      final execution = await repo.startExecution(
        widget.planId,
        _selectedSessionId!,
        _weekNumber,
      );
      if (mounted) {
        Navigator.of(context).pop();
        context.go('/workout/${execution.id}');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isStarting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final suggestionAsync = ref.watch(sessionSuggestionProvider(widget.planId));

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: suggestionAsync.when(
        loading: () => const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => SizedBox(
          height: 200,
          child: Center(child: Text('Errore: $e')),
        ),
        data: (suggestion) {
          _setDefaults(suggestion);
          final sessions = suggestion.allSessions;
          final maxWeeks = suggestion.workoutPlan.durationWeeks;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Inizia Allenamento',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              Text(
                suggestion.workoutPlan.name,
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              // Session selector
              Text('Sessione', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedSessionId,
                dropdownColor: AppColors.backgroundCard,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.textMuted),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: sessions.map((s) {
                  return DropdownMenuItem(
                    value: s.id,
                    child: Text(s.name ?? 'Sessione ${s.id}'),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedSessionId = v),
              ),
              const SizedBox(height: 16),
              // Week selector
              Text('Settimana', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _weekNumber,
                dropdownColor: AppColors.backgroundCard,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.textMuted),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: List.generate(maxWeeks, (i) {
                  return DropdownMenuItem(
                    value: i + 1,
                    child: Text('Settimana ${i + 1}'),
                  );
                }),
                onChanged: (v) => setState(() => _weekNumber = v ?? 1),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isStarting ? null : _start,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isStarting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text(
                        'Inizia',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 4: Verify no regressions**

Run: `flutter analyze`
Expected: No errors

- [ ] **Step 5: Commit**

```bash
git add lib/presentation/shared/providers/workout_providers.dart \
        lib/presentation/workouts/screens/session_selector_screen.dart \
        lib/presentation/workouts/widgets/start_workout_sheet.dart
git commit -m "feat: relocate sessionSuggestionProvider + add StartWorkoutSheet bottom sheet"
```

---

## Task 11: Extend ActivityLogSummary Model + Dashboard Hub

**Files:**
- Modify: `lib/data/models/workout_models.dart` (extend `ActivityLogSummary`)
- Modify: `lib/presentation/dashboard/screens/dashboard_screen.dart`
- Modify: `lib/presentation/dashboard/widgets/active_workout_card.dart`
- Create: `lib/presentation/dashboard/widgets/client_recent_activity_list.dart`

- [ ] **Step 0: Extend ActivityLogSummary with sessionName and setCount**

In `lib/data/models/workout_models.dart`, add two optional fields to `ActivityLogSummary`:

```dart
@freezed
class ActivityLogSummary with _$ActivityLogSummary {
  const factory ActivityLogSummary({
    required int id,
    String? clientName,
    String? sessionName,      // NEW — session name for client-facing storico
    int? setCount,            // NEW — total sets completed
    String? date,
    String? createdAt,
    int? durationMinutes,
    String? feelingDisplay,
  }) = _ActivityLogSummary;

  factory ActivityLogSummary.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogSummaryFromJson(json);
}
```

Then regenerate Freezed code:
```bash
dart run build_runner build --delete-conflicting-outputs
```

Note: These fields are optional so existing API responses without them will still parse. The backend can add `session_name` and `set_count` to the list response later — for now they may be null and we fall back gracefully.

- [ ] **Step 1: Create ClientRecentActivityList**

```dart
// lib/presentation/dashboard/widgets/client_recent_activity_list.dart
import 'package:flutter/material.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/workout_models.dart';

class ClientRecentActivityList extends StatelessWidget {
  final List<ActivityLogSummary> logs;
  final VoidCallback onViewAll;

  const ClientRecentActivityList({
    super.key,
    required this.logs,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Storico Recente',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  'Vedi tutto →',
                  style: TextStyle(fontSize: 12, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...logs.take(5).map((log) => _ActivityTile(log: log)),
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final ActivityLogSummary log;

  const _ActivityTile({required this.log});

  String get _feelingEmoji {
    final f = log.feelingDisplay?.toLowerCase() ?? '';
    if (f.contains('ottim') || f.contains('excel')) return '🔥';
    if (f.contains('grande') || f.contains('bene')) return '💪';
    if (f.contains('normal')) return '😊';
    if (f.contains('fatica') || f.contains('diff')) return '😮‍💨';
    return '😐';
  }

  String get _relativeDate {
    try {
      final date = DateTime.parse(log.date ?? log.createdAt ?? '');
      final diff = DateTime.now().difference(date);
      if (diff.inDays == 0) return 'Oggi';
      if (diff.inDays == 1) return 'Ieri';
      if (diff.inDays < 7) return '${diff.inDays} giorni fa';
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.sessionName ?? log.clientName ?? 'Allenamento',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  [
                    _relativeDate,
                    if (log.durationMinutes != null) '${log.durationMinutes} min',
                    if (log.setCount != null) '${log.setCount} serie',
                  ].join(' · '),
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          if (log.feelingDisplay != null) ...[
            Text(_feelingEmoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              log.feelingDisplay!,
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Wire ActiveWorkoutCard navigation**

In `lib/presentation/dashboard/widgets/active_workout_card.dart`:

Replace the `onResume` and `onStart` callback types — the cards already accept `VoidCallback` params. No changes needed to the widget file itself.

- [ ] **Step 3: Update DashboardScreen — wire buttons and add storico**

In `lib/presentation/dashboard/screens/dashboard_screen.dart`, update `_ClientDashboard`:

- Import `StartWorkoutSheet` and `ClientRecentActivityList`
- Wire `ActiveWorkoutCard.onResume` to `context.go('/workout/${execution.id}')`
- Wire `NextWorkoutCard.onStart` to show `StartWorkoutSheet` bottom sheet
- Add `ClientRecentActivityList` below the calendar widget, using `activityLogsProvider`
- Wire "Vedi tutto" to `context.go('/activity')`

Key changes to `_ClientDashboard.build()` (currently lines 51-154):

After the `ActiveWorkoutCard` / `NextWorkoutCard` block, and after `TrainingCalendar`, add:

```dart
// Import at top
import 'package:palestra/presentation/dashboard/widgets/client_recent_activity_list.dart';
import 'package:palestra/presentation/workouts/widgets/start_workout_sheet.dart';

// In _ClientDashboard build, replace the TODO callbacks:
// For ActiveWorkoutCard:
onResume: () => context.go('/workout/${execution.id}'),

// For NextWorkoutCard:
onStart: () {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => StartWorkoutSheet(planId: plan.id),
  );
},

// After TrainingCalendar widget, add:
ref.watch(activityLogsProvider).when(
  data: (logs) => ClientRecentActivityList(
    logs: logs,
    onViewAll: () => context.go('/activity'),
  ),
  loading: () => const SizedBox.shrink(),
  error: (_, __) => const SizedBox.shrink(),
),
```

- [ ] **Step 4: Verify no regressions**

Run: `flutter analyze`
Expected: No errors

- [ ] **Step 5: Commit**

```bash
git add lib/presentation/dashboard/widgets/client_recent_activity_list.dart \
        lib/presentation/dashboard/screens/dashboard_screen.dart \
        lib/presentation/dashboard/widgets/active_workout_card.dart
git commit -m "feat: wire Dashboard hub — start/resume buttons + client storico recente"
```

---

## Task 12: Rewrite LiveWorkoutScreen as Thin Orchestrator

This is the largest task. The current `live_workout_screen.dart` (1049 lines) gets rewritten to use the new Riverpod providers and composed widgets.

**Files:**
- Modify: `lib/presentation/workouts/screens/live_workout_screen.dart` (full rewrite)
- Create: `lib/presentation/workouts/widgets/exercise_carousel.dart`

- [ ] **Step 1: Create ExerciseCarousel extraction**

```dart
// lib/presentation/workouts/widgets/exercise_carousel.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/execution_models.dart';
import 'package:palestra/presentation/workouts/widgets/set_input_card.dart';

class ExerciseCarousel extends StatelessWidget {
  final PageController pageController;
  final List<ExerciseExecution> exercises;
  final Map<int, Map<int, SetInputControllers>> inputs;
  final Set<String> completedKeys;
  final int? activeSetExerciseId;
  final void Function(int exerciseExecId, int setNumber, int? reps, double? weight)
      onCompleteSet;
  final void Function(int exerciseExecId, int setNumber) onEditSet;
  final Widget? timerOverlay;
  final Widget? nextExerciseCountdown;
  final int currentPage;

  const ExerciseCarousel({
    super.key,
    required this.pageController,
    required this.exercises,
    required this.inputs,
    required this.completedKeys,
    this.activeSetExerciseId,
    required this.onCompleteSet,
    required this.onEditSet,
    this.timerOverlay,
    this.nextExerciseCountdown,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return _ExercisePage(
          exercise: exercise,
          inputs: inputs[exercise.id] ?? {},
          completedKeys: completedKeys,
          onCompleteSet: onCompleteSet,
          onEditSet: onEditSet,
          timerOverlay: index == currentPage ? timerOverlay : null,
          nextExerciseCountdown:
              index == currentPage ? nextExerciseCountdown : null,
        );
      },
    );
  }
}

class SetInputControllers {
  final TextEditingController reps;
  final TextEditingController weight;

  SetInputControllers({required this.reps, required this.weight});

  void dispose() {
    reps.dispose();
    weight.dispose();
  }
}

class _ExercisePage extends StatelessWidget {
  final ExerciseExecution exercise;
  final Map<int, SetInputControllers> inputs;
  final Set<String> completedKeys;
  final void Function(int exerciseExecId, int setNumber, int? reps, double? weight)
      onCompleteSet;
  final void Function(int exerciseExecId, int setNumber) onEditSet;
  final Widget? timerOverlay;
  final Widget? nextExerciseCountdown;

  const _ExercisePage({
    required this.exercise,
    required this.inputs,
    required this.completedKeys,
    required this.onCompleteSet,
    required this.onEditSet,
    this.timerOverlay,
    this.nextExerciseCountdown,
  });

  int _findActiveSetNumber() {
    for (final set in exercise.sets) {
      final key = '${exercise.id}:${set.setNumber}';
      if (!completedKeys.contains(key)) return set.setNumber;
    }
    return exercise.sets.length + 1; // all done
  }

  @override
  Widget build(BuildContext context) {
    final activeSetNumber = _findActiveSetNumber();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise image
          if (exercise.exerciseImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: exercise.exerciseImage!,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 12),
          // Exercise name
          Text(
            exercise.exerciseName ?? 'Esercizio',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          if (exercise.notes != null && exercise.notes!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                exercise.notes!,
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ),
          const SizedBox(height: 16),

          // Timer overlay (if active on this page)
          if (timerOverlay != null) timerOverlay!,

          // Set cards
          ...exercise.sets.map((set) {
            final key = '${exercise.id}:${set.setNumber}';
            final isCompleted = completedKeys.contains(key);
            final isActive = !isCompleted && set.setNumber == activeSetNumber;
            final controllers = inputs[set.setNumber];

            if (controllers == null) return const SizedBox.shrink();

            return SetInputCard(
              setNumber: set.setNumber,
              repsController: controllers.reps,
              weightController: controllers.weight,
              isCompleted: isCompleted,
              isActive: isActive,
              onComplete: isActive
                  ? () {
                      final reps = int.tryParse(controllers.reps.text);
                      final weight = double.tryParse(controllers.weight.text);
                      onCompleteSet(exercise.id, set.setNumber, reps, weight);
                    }
                  : null,
              onLongPress: isCompleted
                  ? () => onEditSet(exercise.id, set.setNumber)
                  : null,
            );
          }),

          // Next exercise countdown (if active on this page)
          if (nextExerciseCountdown != null) ...[
            const SizedBox(height: 16),
            nextExerciseCountdown!,
          ],
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Rewrite LiveWorkoutScreen as orchestrator**

**Important notes:**
- Keep `executionDetailProvider` (currently lines 15-19 of the file) at the top of the file — it's used by this screen only.
- After `logSet()` succeeds, check `ExerciseSet.restDuration`: if non-null and > 0, call `ref.read(restTimerProvider.notifier).start(totalSeconds: rest, exerciseExecId: exId)` to auto-start the timer.
- After each set completion, call `ref.read(flameProgressProvider.notifier).update(...)` to update flame.
- After last set of an exercise, show `NextExerciseCountdown`.
- Call `ref.read(hapticServiceProvider).setCompleted()` after set logged.
- Call `ref.read(workoutNotificationProvider).update(...)` after state changes.

Rewrite `lib/presentation/workouts/screens/live_workout_screen.dart` to be a thin orchestrator that:
- Uses `WorkoutStateNotifier` for state
- Uses `RestTimerNotifier` for timer
- Uses `FlameProgressNotifier` for flame
- Composes: `ProgressIndicatorBar`, `ExerciseCarousel`, `FloatingTimerWidget`, `FlameWidget` in app bar
- Keeps `_CompletionView` inline (as decided in spec)
- Delegates set logging to repository (same API flow, using providers)
- Triggers `HapticService` and `AudioService` at appropriate points

The new screen should be ~300-400 lines max (vs current 1049).

Key structure:
```dart
class LiveWorkoutScreen extends ConsumerStatefulWidget { ... }

class _LiveWorkoutScreenState extends ConsumerState<LiveWorkoutScreen> {
  late PageController _pageController;
  final Map<int, Map<int, SetInputControllers>> _inputs = {};

  // Init: populate state from execution detail
  // LogSet: call repo, update WorkoutStateNotifier, trigger timer/haptic
  // Build: Stack with ExerciseCarousel + FloatingTimerWidget overlay

  @override
  Widget build(BuildContext context) {
    final workoutState = ref.watch(workoutStateProvider);
    final timerState = ref.watch(restTimerProvider);
    final flameState = ref.watch(flameProgressProvider);

    if (workoutState.showCompletion) return _CompletionView(...);

    return Scaffold(
      appBar: AppBar(
        // FlameWidget + percentage in actions
      ),
      body: Stack(
        children: [
          Column(
            children: [
              ProgressIndicatorBar(...),
              Expanded(child: ExerciseCarousel(...)),
            ],
          ),
          // FloatingTimerWidget (positioned bottom-right)
          if (timerState.isActive && timerState.exerciseExecId != _currentExerciseId)
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingTimerWidget(...),
            ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Run full test suite**

Run: `flutter test`
Expected: Existing tests still pass, no regressions

- [ ] **Step 4: Run the app and verify manually**

Run: `flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8010`
Expected: Can start workout from dashboard, see flame, timer works with 3 states, floating timer appears

- [ ] **Step 5: Commit**

```bash
git add lib/presentation/workouts/screens/live_workout_screen.dart \
        lib/presentation/workouts/widgets/exercise_carousel.dart
git commit -m "feat: rewrite LiveWorkoutScreen as thin orchestrator with Riverpod components"
```

---

## Task 13: Settings — Audio & Haptic Toggles

**Files:**
- Modify: `lib/presentation/profile/screens/settings_screen.dart`

- [ ] **Step 1: Add toggles to settings screen**

In `lib/presentation/profile/screens/settings_screen.dart`:

- Add state variables: `_hapticEnabled = true`, `_audioEnabled = true`
- Add a new "Allenamento" section between "Notifiche" and "Account" sections
- Add `SwitchListTile` for "Feedback aptico" and "Suoni timer"
- Wire to `HapticService.enabled` and `AudioService.enabled` via providers

```dart
// Add imports
import 'package:palestra/presentation/workouts/services/haptic_service.dart';
import 'package:palestra/presentation/workouts/services/audio_service.dart';

// Add state
bool _hapticEnabled = true;
bool _audioEnabled = true;

// Add section in build, after Notifiche section:
_SectionHeader(title: 'Allenamento'),
SwitchListTile(
  title: const Text('Feedback aptico'),
  subtitle: const Text('Vibrazione durante l\'allenamento'),
  value: _hapticEnabled,
  activeColor: AppColors.primary,
  onChanged: (v) {
    setState(() => _hapticEnabled = v);
    ref.read(hapticServiceProvider).enabled = v;
  },
),
SwitchListTile(
  title: const Text('Suoni timer'),
  subtitle: const Text('Beep al termine del recupero'),
  value: _audioEnabled,
  activeColor: AppColors.primary,
  onChanged: (v) {
    setState(() => _audioEnabled = v);
    ref.read(audioServiceProvider).enabled = v;
  },
),
```

- [ ] **Step 2: Verify**

Run: `flutter analyze`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add lib/presentation/profile/screens/settings_screen.dart
git commit -m "feat: add haptic and audio toggle settings for workout feedback"
```

---

## Task 14: WorkoutNotificationService (Android Foreground)

**Files:**
- Create: `lib/presentation/workouts/services/workout_notification_service.dart`
- Modify: `android/app/src/main/AndroidManifest.xml`

- [ ] **Step 1: Add Android manifest permissions**

In `android/app/src/main/AndroidManifest.xml`, add inside `<manifest>` before `<application>`:

```xml
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

- [ ] **Step 2: Implement WorkoutNotificationService**

```dart
// lib/presentation/workouts/services/workout_notification_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workoutNotificationProvider = Provider<WorkoutNotificationService>(
  (ref) => WorkoutNotificationService(),
);

class WorkoutNotificationService {
  bool _isRunning = false;

  Future<void> start({
    required String planName,
    required String exerciseName,
    required int setNumber,
    required int totalSets,
    required double progress,
  }) async {
    if (kIsWeb || _isRunning) return;

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'workout_channel',
        channelName: 'Allenamento in corso',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      foregroundTaskOptions: ForegroundTaskOptions(
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: false,
      ),
    );

    await FlutterForegroundTask.startService(
      notificationTitle: '$planName — ${(progress * 100).round()}%',
      notificationText: '$exerciseName · Serie $setNumber/$totalSets',
    );
    _isRunning = true;
  }

  Future<void> update({
    required String planName,
    required String exerciseName,
    required int setNumber,
    required int totalSets,
    required double progress,
    String? timerText,
  }) async {
    if (kIsWeb || !_isRunning) return;

    final body = timerText != null
        ? '$exerciseName · Recupero $timerText'
        : '$exerciseName · Serie $setNumber/$totalSets';

    await FlutterForegroundTask.updateService(
      notificationTitle: '$planName — ${(progress * 100).round()}%',
      notificationText: body,
    );
  }

  Future<void> stop() async {
    if (kIsWeb || !_isRunning) return;
    await FlutterForegroundTask.stopService();
    _isRunning = false;
  }
}
```

- [ ] **Step 3: Verify**

Run: `flutter analyze`
Expected: No errors

- [ ] **Step 4: Commit**

```bash
git add lib/presentation/workouts/services/workout_notification_service.dart \
        android/app/src/main/AndroidManifest.xml
git commit -m "feat: add WorkoutNotificationService — Android foreground service for workout tracking"
```

---

## Task 15: Integration Testing & Cleanup

**Files:**
- Remove: `lib/presentation/shared/widgets/flame_icon.dart` (replaced by `FlameWidget`)
- Update: any imports referencing `FlameIcon` → use `FlameWidget` or remove
- Clean up: `lib/presentation/workouts/widgets/rest_timer_widget.dart` (replaced by `rest_timer_overlay.dart`)

- [ ] **Step 1: Update FlameIcon references**

Run: `grep -r "flame_icon" lib/` to find all usages. Known imports:
- `lib/presentation/shared/widgets/app_navigation_shell.dart` — imports `FlameIcon`
- `lib/presentation/dashboard/widgets/welcome_card.dart` — may reference flame

For static (non-animated) contexts, keep `flame_icon.dart` as-is or replace with a static `FlameWidget(scale: 1.0, opacity: 1.0, speedSeconds: 0.5, glow: 0.0, size: 24)`. The animated `FlameWidget` is only needed in the live workout screen.

- [ ] **Step 2: Remove old rest_timer_widget.dart if no longer imported**

Run: `grep -r "rest_timer_widget" lib/` — if only `live_workout_screen.dart` imported it (now rewritten), the file can be deleted.

- [ ] **Step 3: Run full test suite**

Run: `flutter test`
Expected: All tests pass

- [ ] **Step 4: Run flutter analyze**

Run: `flutter analyze`
Expected: No issues

- [ ] **Step 5: Commit cleanup**

```bash
git add -A
git commit -m "chore: remove old FlameIcon and RestTimerWidget, update references"
```

---

## Task 16: Manual End-to-End Verification

- [ ] **Step 1: Start backend**

```bash
cd ~/PycharmProjects/personal/palestra && podman compose up -d
```

- [ ] **Step 2: Run on Chrome**

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8010
```

- [ ] **Step 3: Verify each feature**

Checklist:
- [ ] Dashboard shows "Inizia Allenamento" card → tap → bottom sheet with session/week → start
- [ ] Dashboard shows "Riprendi" card for active workout → tap → navigates to live workout
- [ ] Dashboard shows storico recente with last workouts
- [ ] Live workout: flame in app bar grows with progress
- [ ] Live workout: progress dots show correct state
- [ ] Live workout: set input cards work (tap to complete, swipe left for quick complete)
- [ ] Live workout: rest timer shows after set completion with 3 states
- [ ] Live workout: floating timer appears when swiping to other exercise
- [ ] Live workout: next exercise countdown after last set
- [ ] Live workout: completion view with feeling + notes
- [ ] Settings: haptic and audio toggles present

- [ ] **Step 4: Test on Android emulator**

```bash
export ANDROID_HOME=~/android-sdk
$ANDROID_HOME/emulator/emulator -avd Prometheus_Phone -gpu host &
flutter run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:8010
```

Additional Android checks:
- [ ] Haptic feedback works on set completion
- [ ] Persistent notification appears in notification shade
- [ ] Notification updates with timer countdown

- [ ] **Step 5: Final commit if any fixes needed**

```bash
git add -A
git commit -m "fix: end-to-end verification fixes"
```
