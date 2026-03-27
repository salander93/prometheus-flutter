import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:palestra/core/connectivity/connectivity_service.dart';
import 'package:palestra/core/storage/cache_providers.dart';
import 'package:palestra/core/storage/pending_sets_storage.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/execution_models.dart';
import 'package:palestra/presentation/shared/providers/workout_providers.dart';
import 'package:palestra/presentation/workouts/providers/flame_progress_provider.dart';
import 'package:palestra/presentation/workouts/providers/rest_timer_provider.dart';
import 'package:palestra/presentation/workouts/providers/workout_state_provider.dart';
import 'package:palestra/presentation/workouts/services/audio_service.dart';
import 'package:palestra/presentation/workouts/services/haptic_service.dart';
import 'package:palestra/presentation/workouts/widgets/exercise_carousel.dart';
import 'package:palestra/presentation/workouts/widgets/flame_widget.dart';
import 'package:palestra/presentation/workouts/widgets/floating_timer_widget.dart';
import 'package:palestra/presentation/workouts/widgets/set_input_card.dart';

/// Provider that fetches and caches the execution detail.
final executionDetailProvider =
    FutureProvider.family<WorkoutExecutionDetail, int>((ref, executionId) async {
  final repo = ref.watch(workoutRepositoryProvider);
  return repo.getExecutionDetail(executionId);
});

/// The core live workout tracking screen — two-view design:
/// 1. Exercise List View (overview with progress)
/// 2. Exercise Detail View (set input, flame, timer — swipeable)
class LiveWorkoutScreen extends ConsumerStatefulWidget {
  const LiveWorkoutScreen({required this.executionId, super.key});

  final int executionId;

  @override
  ConsumerState<LiveWorkoutScreen> createState() => _LiveWorkoutScreenState();
}

class _LiveWorkoutScreenState extends ConsumerState<LiveWorkoutScreen> {
  final Map<int, Map<int, SetInputControllers>> _inputs = {};
  bool _initialized = false;

  // Which view are we in? null = exercise list, int = exercise index for detail
  int? _selectedExerciseIndex;

  // PageController for exercise detail carousel
  PageController? _detailPageController;

  // Completion view state
  int _feeling = 3;
  final _notesController = TextEditingController();
  bool _isCompleting = false;

  @override
  void dispose() {
    _notesController.dispose();
    _detailPageController?.dispose();
    for (final exeMap in _inputs.values) {
      for (final ctrl in exeMap.values) {
        ctrl.dispose();
      }
    }
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  void _initializeState(WorkoutExecutionDetail detail) {
    if (_initialized) return;
    _initialized = true;

    final exercises = detail.exerciseExecutions;
    var totalSets = 0;
    final alreadyCompleted = <String>{};

    for (final exe in exercises) {
      for (final s in exe.sets) {
        totalSets++;
        if (s.completedAt != null) {
          alreadyCompleted.add('${exe.id}:${s.setNumber}');
        }
      }
      _populateInputs(exe);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(workoutStateProvider.notifier).initialize(
            exercises: exercises,
            totalSets: totalSets,
            alreadyCompleted: alreadyCompleted,
          );
      ref.read(flameProgressProvider.notifier).update(
            completedSets: alreadyCompleted.length,
            totalSets: totalSets,
          );
    });
  }

  void _populateInputs(ExerciseExecution exe) {
    _inputs.putIfAbsent(exe.id, () {
      final map = <int, SetInputControllers>{};
      for (final s in exe.sets) {
        // If the set was already completed, pre-fill with actual values;
        // otherwise leave empty so target values show as placeholder text.
        final hasActual = s.completedAt != null;
        map[s.setNumber] = SetInputControllers(
          reps: TextEditingController(
            text: hasActual ? (s.actualReps?.toString() ?? '') : '',
          ),
          weight: TextEditingController(
            text: hasActual ? (s.actualWeight?.toString() ?? '') : '',
          ),
        );
      }
      return map;
    });
  }

  // ---------------------------------------------------------------------------
  // Navigation between views
  // ---------------------------------------------------------------------------

  void _openExerciseDetail(int exerciseIndex) {
    _detailPageController?.dispose();
    _detailPageController = PageController(initialPage: exerciseIndex);
    setState(() {
      _selectedExerciseIndex = exerciseIndex;
    });
    ref.read(workoutStateProvider.notifier).setCurrentPage(exerciseIndex);
  }

  void _backToList() {
    setState(() {
      _selectedExerciseIndex = null;
    });
  }

  // ---------------------------------------------------------------------------
  // Set logging (optimistic UI + offline fallback)
  // ---------------------------------------------------------------------------

  Future<void> _logSet(
    int exerciseExecId,
    int setNumber,
    int? reps,
    double? weight,
  ) async {
    final notifier = ref.read(workoutStateProvider.notifier);
    final flameNotifier = ref.read(flameProgressProvider.notifier);
    final haptic = ref.read(hapticServiceProvider);

    // Optimistic UI
    notifier.markSetCompleted(
      exerciseExecId: exerciseExecId,
      setNumber: setNumber,
    );
    final wState = ref.read(workoutStateProvider);
    flameNotifier.update(
      completedSets: wState.completedSetCount,
      totalSets: wState.totalSets,
    );
    haptic.setCompleted();

    // Always try API first, fall back to offline only on failure
    try {
      final repo = ref.read(workoutRepositoryProvider);
      await repo.logSet(
        executionId: widget.executionId,
        exerciseExecutionId: exerciseExecId,
        setNumber: setNumber,
        actualReps: reps,
        actualWeight: weight,
      );

      // Start rest timer using exercise-level rest_time
      final exercise = wState.exercises.firstWhere((e) => e.id == exerciseExecId);
      final rest = parseRestTimeToSeconds(exercise.restTime);
      if (rest > 0 && mounted) {
        ref.read(restTimerProvider.notifier).start(
              totalSeconds: rest,
              exerciseExecId: exerciseExecId,
            );
      }
    } catch (_) {
      await _saveSetOffline(exerciseExecId, setNumber, reps, weight);
      _showOfflineSnackBar();
    }

    _checkExerciseAndWorkoutCompletion(exerciseExecId);
  }

  void _checkExerciseAndWorkoutCompletion(int exerciseExecId) {
    final wState = ref.read(workoutStateProvider);
    final exercise = wState.exercises.firstWhere((e) => e.id == exerciseExecId);
    final isExerciseDone = wState.isExerciseComplete(exerciseExecId, exercise.sets.length);

    if (isExerciseDone) {
      final haptic = ref.read(hapticServiceProvider);
      haptic.exerciseCompleted();

      final allDone = wState.exercises.every(
        (e) => wState.isExerciseComplete(e.id, e.sets.length),
      );

      if (allDone) {
        haptic.workoutCompleted();
        ref.read(workoutStateProvider.notifier).showCompletion();
      }
    }
  }

  Future<void> _saveSetOffline(
    int exerciseExecId,
    int setNumber,
    int? reps,
    double? weight,
  ) async {
    final storage = ref.read(pendingSetsStorageProvider);
    await storage.addPendingSet(
      PendingSetData(
        executionId: widget.executionId,
        exerciseExecutionId: exerciseExecId,
        setNumber: setNumber,
        actualReps: reps,
        actualWeight: weight,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  void _showOfflineSnackBar() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Salvato offline — verra sincronizzato'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Completion
  // ---------------------------------------------------------------------------

  Future<void> _completeWorkout() async {
    setState(() => _isCompleting = true);
    try {
      final repo = ref.read(workoutRepositoryProvider);
      await repo.completeExecution(
        widget.executionId,
        feeling: _feeling,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );
      if (mounted) context.go('/dashboard');
    } catch (e) {
      if (mounted) {
        setState(() => _isCompleting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: $e')),
        );
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final asyncExecution = ref.watch(executionDetailProvider(widget.executionId));

    // Listen to rest timer for audio/haptic side effects
    ref.listen<RestTimerState>(restTimerProvider, (prev, next) {
      if (next.status == RestTimerStatus.urgent && prev?.status != RestTimerStatus.urgent) {
        ref.read(audioServiceProvider).playTick();
        ref.read(hapticServiceProvider).timerTick();
      }
      if (next.status == RestTimerStatus.overtime && prev?.status != RestTimerStatus.overtime) {
        ref.read(audioServiceProvider).playDing();
      }
    });

    return asyncExecution.when(
      data: (execution) {
        _initializeState(execution);
        return _buildWorkout(context, execution);
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Allenamento')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(title: const Text('Allenamento')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 56, color: AppColors.danger),
              const SizedBox(height: 16),
              Text(
                'Errore nel caricamento',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    ref.invalidate(executionDetailProvider(widget.executionId)),
                child: const Text('Riprova'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkout(BuildContext context, WorkoutExecutionDetail execution) {
    final wState = ref.watch(workoutStateProvider);
    final exercises = execution.exerciseExecutions;

    if (wState.showCompletion) {
      return _CompletionView(
        feeling: _feeling,
        notesController: _notesController,
        isCompleting: _isCompleting,
        onFeelingChanged: (f) => setState(() => _feeling = f),
        onComplete: _completeWorkout,
      );
    }

    if (exercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(execution.sessionName ?? 'Allenamento'),
          automaticallyImplyLeading: false,
        ),
        body: const Center(
          child: Text(
            'Nessun esercizio',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    // Show exercise detail or exercise list
    if (_selectedExerciseIndex != null) {
      return _buildExerciseDetailView(context, execution, wState, exercises);
    }
    return _buildExerciseListView(context, execution, wState, exercises);
  }

  // ---------------------------------------------------------------------------
  // VIEW 1: Exercise List
  // ---------------------------------------------------------------------------

  Widget _buildExerciseListView(
    BuildContext context,
    WorkoutExecutionDetail execution,
    WorkoutState wState,
    List<ExerciseExecution> exercises,
  ) {
    final flameState = ref.watch(flameProgressProvider);
    final timerState = ref.watch(restTimerProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          execution.sessionName ?? 'Allenamento',
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          // Flame + percentage in app bar
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FlameWidget(
                scale: flameState.scale,
                opacity: flameState.opacity,
                speedSeconds: flameState.speedSeconds,
                glow: flameState.glow,
                size: 28,
              ),
              const SizedBox(width: 4),
              Text(
                '${flameState.percent}%',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
          if (timerState.isActive)
            Padding(
              padding: const EdgeInsets.only(right: 12, left: 8),
              child: Center(
                child: Text(
                  timerState.formattedTime,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: timerState.status == RestTimerStatus.urgent
                            ? AppColors.danger
                            : AppColors.textMuted,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Progress bar at top (4px, green fill)
              _WorkoutProgressBar(progress: wState.progress),

              // Scrollable exercise card list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exe = exercises[index];
                    final completedSets = _countCompletedSets(exe, wState);
                    final totalSets = exe.sets.length;
                    final isComplete = wState.isExerciseComplete(exe.id, totalSets);
                    final isInProgress = completedSets > 0 && !isComplete;

                    return _ExerciseListCard(
                      index: index,
                      exercise: exe,
                      completedSets: completedSets,
                      totalSets: totalSets,
                      isComplete: isComplete,
                      isInProgress: isInProgress,
                      onTap: () => _openExerciseDetail(index),
                    );
                  },
                ),
              ),
            ],
          ),

          // Floating timer when navigating away from timed exercise
          if (timerState.isActive)
            Positioned(
              bottom: 80,
              right: 16,
              child: FloatingTimerWidget(
                state: timerState,
                exerciseName: _exerciseNameForId(exercises, timerState.exerciseExecId),
                onTap: () {
                  final idx = exercises.indexWhere((e) => e.id == timerState.exerciseExecId);
                  if (idx >= 0) _openExerciseDetail(idx);
                },
              ),
            ),

          // "Termina Allenamento" button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _TerminaButton(
              completedSetCount: wState.completedSetCount,
              totalSets: wState.totalSets,
              onPressed: () {
                ref.read(workoutStateProvider.notifier).showCompletion();
              },
            ),
          ),
        ],
      ),
    );
  }

  int _countCompletedSets(ExerciseExecution exe, WorkoutState wState) {
    var count = 0;
    for (final s in exe.sets) {
      if (wState.isSetCompleted(exe.id, s.setNumber)) count++;
    }
    return count;
  }

  // ---------------------------------------------------------------------------
  // VIEW 2: Exercise Detail (carousel)
  // ---------------------------------------------------------------------------

  Widget _buildExerciseDetailView(
    BuildContext context,
    WorkoutExecutionDetail execution,
    WorkoutState wState,
    List<ExerciseExecution> exercises,
  ) {
    final flameState = ref.watch(flameProgressProvider);
    final timerState = ref.watch(restTimerProvider);
    final currentExercise = exercises[_selectedExerciseIndex!];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _backToList,
        ),
        title: Text(
          execution.sessionName ?? 'Allenamento',
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          // Elapsed timer pill badge
          _ElapsedTimerBadge(startedAt: execution.startedAt),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Exercise dots indicator
              _ExerciseDotsIndicator(
                total: exercises.length,
                currentIndex: _selectedExerciseIndex!,
                completedIndices: _buildCompletedIndices(exercises, wState),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _detailPageController,
                  itemCount: exercises.length,
                  onPageChanged: (page) {
                    setState(() => _selectedExerciseIndex = page);
                    ref.read(workoutStateProvider.notifier).setCurrentPage(page);
                  },
                  itemBuilder: (context, index) {
                    final exe = exercises[index];
                    return _ExerciseDetailPage(
                      exercise: exe,
                      exerciseIndex: index,
                      totalExercises: exercises.length,
                      inputs: _inputs[exe.id] ?? {},
                      completedKeys: wState.completedKeys,
                      flameState: flameState,
                      timerState: timerState,
                      isCurrentPage: index == _selectedExerciseIndex,
                      onCompleteSet: (setNumber, reps, weight) =>
                          _logSet(exe.id, setNumber, reps, weight),
                      onEditSet: (setNumber) {
                        ref.read(workoutStateProvider.notifier).revertSetCompleted(
                              exerciseExecId: exe.id,
                              setNumber: setNumber,
                            );
                        final ws = ref.read(workoutStateProvider);
                        ref.read(flameProgressProvider.notifier).update(
                              completedSets: ws.completedSetCount,
                              totalSets: ws.totalSets,
                            );
                      },
                      onSkipTimer: () => ref.read(restTimerProvider.notifier).skip(),
                      onStartTimer: () {
                        final rest = parseRestTimeToSeconds(exe.restTime);
                        ref.read(restTimerProvider.notifier).start(
                              totalSeconds: rest > 0 ? rest : 60,
                              exerciseExecId: exe.id,
                            );
                      },
                      onResetTimer: () => ref.read(restTimerProvider.notifier).reset(),
                    );
                  },
                ),
              ),
            ],
          ),

          // Floating timer when on a different exercise
          if (timerState.isActive &&
              timerState.exerciseExecId != currentExercise.id)
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingTimerWidget(
                state: timerState,
                exerciseName: _exerciseNameForId(exercises, timerState.exerciseExecId),
                onTap: () {
                  final idx = exercises.indexWhere(
                    (e) => e.id == timerState.exerciseExecId,
                  );
                  if (idx >= 0) {
                    _detailPageController?.animateToPage(
                      idx,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Set<int> _buildCompletedIndices(
    List<ExerciseExecution> exercises,
    WorkoutState wState,
  ) {
    final indices = <int>{};
    for (var i = 0; i < exercises.length; i++) {
      if (wState.isExerciseComplete(exercises[i].id, exercises[i].sets.length)) {
        indices.add(i);
      }
    }
    return indices;
  }

  String _exerciseNameForId(List<ExerciseExecution> exercises, int id) {
    return exercises
            .firstWhere(
              (e) => e.id == id,
              orElse: () => exercises.first,
            )
            .exerciseName ??
        'Esercizio';
  }
}

// =============================================================================
// EXERCISE LIST VIEW COMPONENTS
// =============================================================================

/// Green progress bar at top of exercise list (4px, animated).
class _WorkoutProgressBar extends StatelessWidget {
  const _WorkoutProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: double.infinity,
      color: Colors.white.withValues(alpha: 0.05),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          decoration: const BoxDecoration(
            color: AppColors.success,
          ),
        ),
      ),
    );
  }
}

/// A single exercise card in the list view — PWA style.
class _ExerciseListCard extends StatelessWidget {
  const _ExerciseListCard({
    required this.index,
    required this.exercise,
    required this.completedSets,
    required this.totalSets,
    required this.isComplete,
    required this.isInProgress,
    required this.onTap,
  });

  final int index;
  final ExerciseExecution exercise;
  final int completedSets;
  final int totalSets;
  final bool isComplete;
  final bool isInProgress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final fillFraction = totalSets == 0 ? 0.0 : completedSets / totalSets;

    // Card border color
    final Color borderColor;
    if (isComplete) {
      borderColor = AppColors.success;
    } else if (isInProgress) {
      borderColor = AppColors.primary;
    } else {
      borderColor = AppColors.border;
    }

    // Build subtitle: "4x10 . 90s"
    final subtitle = _buildSubtitle();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xD916161A), // rgba(22,22,26,0.85)
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: isInProgress || isComplete ? 1.5 : 1,
          ),
          boxShadow: isInProgress
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Orange gradient fill based on completion
            if (fillFraction > 0)
              Positioned.fill(
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: fillFraction,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.12),
                          AppColors.primary.withValues(alpha: 0.04),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // Card content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  // Status circle
                  _StatusCircle(
                    index: index,
                    isComplete: isComplete,
                    isInProgress: isInProgress,
                  ),
                  const SizedBox(width: 12),

                  // Exercise name + subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.exerciseName ?? 'Esercizio',
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              subtitle,
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.textMuted,
                                fontSize: 13,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Progress count + dots
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$completedSets/$totalSets',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: isComplete
                              ? AppColors.success
                              : isInProgress
                                  ? AppColors.primary
                                  : AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Set dots
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(totalSets, (i) {
                          final setNum = i + 1;
                          final isFilled = completedSets >= setNum;
                          return Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isFilled
                                  ? AppColors.primary
                                  : Colors.white.withValues(alpha: 0.2),
                              boxShadow: isFilled
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.5),
                                        blurRadius: 4,
                                      ),
                                    ]
                                  : null,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildSubtitle() {
    if (exercise.sets.isEmpty) return '';
    final setCount = exercise.sets.length;
    final firstSet = exercise.sets.first;
    final reps = firstSet.targetReps?.toString() ?? '?';
    final rest = firstSet.restDuration;
    final restStr = rest != null && rest > 0 ? ' \u2022 ${rest}s' : '';
    return '$setCount\u00D7$reps$restStr';
  }
}

/// Status circle on the left of each exercise card.
class _StatusCircle extends StatelessWidget {
  const _StatusCircle({
    required this.index,
    required this.isComplete,
    required this.isInProgress,
  });

  final int index;
  final bool isComplete;
  final bool isInProgress;

  @override
  Widget build(BuildContext context) {
    if (isComplete) {
      return Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: AppColors.success,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text(
            '\u2713',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      );
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isInProgress
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.backgroundBase,
        shape: BoxShape.circle,
        border: Border.all(
          color: isInProgress ? AppColors.primary : AppColors.border,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          '${index + 1}',
          style: TextStyle(
            color: isInProgress ? AppColors.primary : AppColors.textMuted,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

/// Dots indicator at the top of the exercise detail view.
class _ExerciseDotsIndicator extends StatelessWidget {
  const _ExerciseDotsIndicator({
    required this.total,
    required this.currentIndex,
    required this.completedIndices,
  });

  final int total;
  final int currentIndex;
  final Set<int> completedIndices;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(total, (i) {
          final Color color;
          if (completedIndices.contains(i)) {
            color = AppColors.success;
          } else if (i == currentIndex) {
            color = AppColors.primary;
          } else {
            color = Colors.white.withValues(alpha: 0.15);
          }
          return Container(
            width: i == currentIndex ? 24 : 8,
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }
}

// =============================================================================
// EXERCISE DETAIL VIEW COMPONENTS
// =============================================================================

/// A single exercise's detail page inside the swipeable carousel.
class _ExerciseDetailPage extends StatefulWidget {
  const _ExerciseDetailPage({
    required this.exercise,
    required this.exerciseIndex,
    required this.totalExercises,
    required this.inputs,
    required this.completedKeys,
    required this.flameState,
    required this.timerState,
    required this.isCurrentPage,
    required this.onCompleteSet,
    required this.onEditSet,
    required this.onSkipTimer,
    required this.onStartTimer,
    required this.onResetTimer,
  });

  final ExerciseExecution exercise;
  final int exerciseIndex;
  final int totalExercises;
  final Map<int, SetInputControllers> inputs;
  final Set<String> completedKeys;
  final FlameProgressState flameState;
  final RestTimerState timerState;
  final bool isCurrentPage;
  final void Function(int setNumber, int? reps, double? weight) onCompleteSet;
  final void Function(int setNumber) onEditSet;
  final VoidCallback onSkipTimer;
  final VoidCallback onStartTimer;
  final VoidCallback onResetTimer;

  @override
  State<_ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<_ExerciseDetailPage> {
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  int _findActiveSetNumber() {
    for (final s in widget.exercise.sets) {
      final key = '${widget.exercise.id}:${s.setNumber}';
      if (!widget.completedKeys.contains(key)) return s.setNumber;
    }
    return -1; // all completed
  }

  String _buildExerciseSubtitle() {
    final sets = widget.exercise.sets;
    if (sets.isEmpty) return '';
    final setCount = sets.length;
    final firstSet = sets.first;
    final reps = firstSet.targetReps?.toString() ?? '?';
    final rest = firstSet.restDuration;
    final restStr = rest != null && rest > 0
        ? " \u00B7 rec.${rest >= 60 ? "${rest ~/ 60}'" : "${rest}s"}"
        : '';
    return '${widget.exerciseIndex + 1}/${widget.totalExercises} \u00B7 $setCount\u00D7$reps$restStr';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final activeSetNumber = _findActiveSetNumber();
    final isTimerForThisExercise = widget.isCurrentPage &&
        widget.timerState.isActive &&
        widget.timerState.exerciseExecId == widget.exercise.id;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        // --- EXERCISE HEADER ---
        Text(
          widget.exercise.exerciseName ?? 'Esercizio',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          _buildExerciseSubtitle(),
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.textMuted,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
        if (widget.exercise.notes != null && widget.exercise.notes!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            widget.exercise.notes!,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 16),

        // --- FLAME ---
        Center(
          child: Column(
            children: [
              FlameWidget(
                scale: widget.flameState.scale,
                opacity: widget.flameState.opacity,
                speedSeconds: widget.flameState.speedSeconds,
                glow: widget.flameState.glow,
                size: 56,
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.flameState.percent}%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // --- RECUPERO TIMER (always visible) ---
        _AlwaysVisibleRestTimer(
          timerState: isTimerForThisExercise ? widget.timerState : null,
          defaultRestSeconds: widget.exercise.sets.isNotEmpty
              ? (widget.exercise.sets.first.restDuration ?? 60)
              : 60,
          onStart: widget.onStartTimer,
          onReset: widget.onResetTimer,
        ),
        const SizedBox(height: 20),

        // --- CURRENT SET INPUT ---
        if (activeSetNumber > 0) ...[
          _buildActiveSetInput(activeSetNumber),
          const SizedBox(height: 8),
          // --- NOTE INPUT ---
          _NoteInput(controller: _noteController),
          const SizedBox(height: 16),
        ],

        // --- COMPLETED SETS ---
        ..._buildCompletedSets(),

        // --- ALL DONE ---
        if (activeSetNumber < 0)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 40),
                const SizedBox(height: 8),
                Text(
                  'Esercizio completato!',
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 24),

        // --- STORICO SECTION ---
        _StoricoSection(exercise: widget.exercise),
      ],
    );
  }

  Widget _buildActiveSetInput(int activeSetNumber) {
    final inp = widget.inputs[activeSetNumber];
    // Find the target values for placeholder
    final activeSet = widget.exercise.sets.firstWhere(
      (s) => s.setNumber == activeSetNumber,
      orElse: () => widget.exercise.sets.first,
    );

    return SetInputCard(
      setNumber: activeSetNumber,
      totalSets: widget.exercise.sets.length,
      repsController: inp?.reps ?? TextEditingController(),
      weightController: inp?.weight ?? TextEditingController(),
      repsPlaceholder: activeSet.targetReps?.toString(),
      weightPlaceholder: activeSet.targetWeight?.toString(),
      isCompleted: false,
      isActive: true,
      onComplete: () {
        final reps = int.tryParse(inp?.reps.text ?? '');
        final weight = double.tryParse(inp?.weight.text ?? '');
        widget.onCompleteSet(activeSetNumber, reps, weight);
        _noteController.clear();
      },
    );
  }

  List<Widget> _buildCompletedSets() {
    final completed = <Widget>[];
    for (final s in widget.exercise.sets) {
      final key = '${widget.exercise.id}:${s.setNumber}';
      if (widget.completedKeys.contains(key)) {
        final inp = widget.inputs[s.setNumber];
        completed.add(
          _CompletedSetRow(
            setNumber: s.setNumber,
            reps: inp?.reps.text ?? '',
            weight: inp?.weight.text ?? '',
            onLongPress: () => widget.onEditSet(s.setNumber),
          ),
        );
      }
    }
    if (completed.isNotEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'SERIE COMPLETATE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...completed,
      ];
    }
    return [];
  }
}

/// Elapsed workout timer badge (orange pill) — shows time since workout started.
class _ElapsedTimerBadge extends StatefulWidget {
  const _ElapsedTimerBadge({required this.startedAt});

  final String startedAt;

  @override
  State<_ElapsedTimerBadge> createState() => _ElapsedTimerBadgeState();
}

class _ElapsedTimerBadgeState extends State<_ElapsedTimerBadge> {
  late final Timer _ticker;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateElapsed();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _updateElapsed());
  }

  void _updateElapsed() {
    final started = DateTime.tryParse(widget.startedAt);
    if (started == null) return;
    if (!mounted) return;
    setState(() {
      _elapsed = DateTime.now().difference(started);
    });
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  String _format(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Text(
        _format(_elapsed),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontFamily: 'monospace',
          color: AppColors.primary,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

/// Always-visible rest timer with vertical layout.
/// Shows idle state when timer is not running, with "Avvia" and "Reset" buttons.
class _AlwaysVisibleRestTimer extends StatelessWidget {
  const _AlwaysVisibleRestTimer({
    required this.timerState,
    required this.defaultRestSeconds,
    required this.onStart,
    required this.onReset,
  });

  final RestTimerState? timerState;
  final int defaultRestSeconds;
  final VoidCallback onStart;
  final VoidCallback onReset;

  bool get _isActive => timerState != null && timerState!.isActive;
  bool get _isOvertime => timerState?.status == RestTimerStatus.overtime;

  Color get _accentColor {
    if (timerState == null || !_isActive) return AppColors.textMuted;
    return switch (timerState!.status) {
      RestTimerStatus.urgent => AppColors.danger,
      RestTimerStatus.overtime => AppColors.success,
      _ => AppColors.primary,
    };
  }

  String get _displayTime {
    if (_isActive) return timerState!.formattedTime;
    // Show default rest time when idle
    final m = defaultRestSeconds ~/ 60;
    final s = defaultRestSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final color = _accentColor;

    // Box decorations based on state
    BoxDecoration boxDecoration;
    if (_isOvertime) {
      boxDecoration = BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withValues(alpha: 0.12),
            AppColors.success.withValues(alpha: 0.06),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.25),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      );
    } else if (_isActive) {
      boxDecoration = BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      );
    } else {
      boxDecoration = BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: boxDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // "RECUPERO" label
          Text(
            'RECUPERO',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          // Ring + time
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: CustomPaint(
                  painter: _InlineTimerRingPainter(
                    progress: _isActive ? timerState!.progressFraction : 0.0,
                    color: color,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.timer_outlined,
                      size: 14,
                      color: color,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _displayTime,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: color,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Buttons row: "Avvia" (green) and "Reset" (red)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _isActive ? null : onStart,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isActive
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isActive
                          ? AppColors.success.withValues(alpha: 0.2)
                          : AppColors.success.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    'Avvia',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _isActive
                          ? AppColors.success.withValues(alpha: 0.4)
                          : AppColors.success,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onReset,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.danger,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Note input field below the set input.
class _NoteInput extends StatelessWidget {
  const _NoteInput({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: 'Aggiungi nota...',
        hintStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.textMuted,
        ),
        filled: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

/// Storico section — shows historical performance for this exercise.
/// Currently a placeholder until the API returns exercise history data.
class _StoricoSection extends StatelessWidget {
  const _StoricoSection({required this.exercise});

  final ExerciseExecution exercise;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: STORICO + PR badges
          Row(
            children: [
              Text(
                'STORICO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              // PR badges (placeholder — will be populated with real data)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.2),
                      AppColors.primaryDark.withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'PR: --',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Placeholder content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Nessuno storico disponibile',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineTimerRingPainter extends CustomPainter {
  _InlineTimerRingPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;
    const strokeWidth = 3.0;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.10)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_InlineTimerRingPainter old) =>
      old.progress != progress || old.color != color;
}

/// Compact completed set row shown below the active input.
class _CompletedSetRow extends StatelessWidget {
  const _CompletedSetRow({
    required this.setNumber,
    required this.reps,
    required this.weight,
    required this.onLongPress,
  });

  final int setNumber;
  final String reps;
  final String weight;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.success.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 18),
            const SizedBox(width: 10),
            Text(
              'Serie $setNumber',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
              ),
            ),
            const Spacer(),
            Text(
              '${reps.isEmpty ? "—" : reps} rip',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              '\u00D7',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            const SizedBox(width: 4),
            Text(
              '${weight.isEmpty ? "—" : weight} kg',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Termina Allenamento" button pinned at the bottom.
class _TerminaButton extends StatelessWidget {
  const _TerminaButton({
    required this.completedSetCount,
    required this.totalSets,
    required this.onPressed,
  });

  final int completedSetCount;
  final int totalSets;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final allDone = completedSetCount == totalSets && totalSets > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundBase,
        border: const Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: SafeArea(
        top: false,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: allDone ? AppColors.success : AppColors.backgroundCard,
            foregroundColor: allDone ? Colors.white : AppColors.textSecondary,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            allDone
                ? 'Completa Allenamento \u2713'
                : 'Termina Allenamento ($completedSetCount/$totalSets)',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// COMPLETION VIEW
// =============================================================================

class _CompletionView extends StatelessWidget {
  const _CompletionView({
    required this.feeling,
    required this.notesController,
    required this.isCompleting,
    required this.onFeelingChanged,
    required this.onComplete,
  });

  final int feeling;
  final TextEditingController notesController;
  final bool isCompleting;
  final ValueChanged<int> onFeelingChanged;
  final VoidCallback onComplete;

  static const _feelingLabels = [
    (1, '\u{1F62B}', 'Malissimo'),
    (2, '\u{1F615}', 'Faticoso'),
    (3, '\u{1F610}', 'Normale'),
    (4, '\u{1F642}', 'Bene'),
    (5, '\u{1F4AA}', 'Alla grande'),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completa Allenamento'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            const Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: AppColors.accent,
            ),
            const SizedBox(height: 16),
            Text(
              'Ottimo lavoro!',
              style: textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Come ti sei sentito?',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _feelingLabels.map((item) {
                final (value, emoji, label) = item;
                final selected = feeling == value;
                return _FeelingOption(
                  value: value,
                  emoji: emoji,
                  label: label,
                  selected: selected,
                  onTap: () => onFeelingChanged(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
            Text('Note (opzionale)', style: textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Come \u00e8 andato l'allenamento?",
              ),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: isCompleting ? null : onComplete,
              icon: isCompleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.textPrimary,
                      ),
                    )
                  : const Icon(Icons.check_rounded),
              label: Text(
                isCompleting ? 'Salvataggio...' : 'Completa Allenamento',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _FeelingOption extends StatelessWidget {
  const _FeelingOption({
    required this.value,
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final int value;
  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: selected ? AppColors.primary : AppColors.textMuted,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
