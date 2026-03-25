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
import 'package:palestra/presentation/workouts/widgets/next_exercise_countdown.dart';
import 'package:palestra/presentation/workouts/widgets/progress_indicator_bar.dart';
import 'package:palestra/presentation/workouts/widgets/rest_timer_overlay.dart';

/// Provider that fetches and caches the execution detail.
final executionDetailProvider =
    FutureProvider.family<WorkoutExecutionDetail, int>((ref, executionId) async {
  final repo = ref.watch(workoutRepositoryProvider);
  return repo.getExecutionDetail(executionId);
});

/// The core live workout tracking screen — thin orchestrator.
class LiveWorkoutScreen extends ConsumerStatefulWidget {
  const LiveWorkoutScreen({required this.executionId, super.key});

  final int executionId;

  @override
  ConsumerState<LiveWorkoutScreen> createState() => _LiveWorkoutScreenState();
}

class _LiveWorkoutScreenState extends ConsumerState<LiveWorkoutScreen> {
  late PageController _pageController;
  final Map<int, Map<int, SetInputControllers>> _inputs = {};
  bool _initialized = false;

  // Completion view state
  int _feeling = 3;
  final _notesController = TextEditingController();
  bool _isCompleting = false;

  // Next-exercise countdown
  bool _showNextExerciseCountdown = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _notesController.dispose();
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

    // Initialize providers (post-frame to avoid modifying during build)
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
        map[s.setNumber] = SetInputControllers(
          reps: TextEditingController(
            text: s.actualReps?.toString() ?? s.targetReps?.toString() ?? '',
          ),
          weight: TextEditingController(
            text: s.actualWeight?.toString() ?? s.targetWeight?.toString() ?? '',
          ),
        );
      }
      return map;
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

    final isOnline = ref.read(isOnlineProvider);

    if (!isOnline) {
      await _saveSetOffline(exerciseExecId, setNumber, reps, weight);
      _showOfflineSnackBar();
      _checkExerciseAndWorkoutCompletion(exerciseExecId);
      return;
    }

    try {
      final repo = ref.read(workoutRepositoryProvider);
      await repo.logSet(
        executionId: widget.executionId,
        exerciseExecutionId: exerciseExecId,
        setNumber: setNumber,
        actualReps: reps,
        actualWeight: weight,
      );

      // Start rest timer if needed
      final exercise = wState.exercises.firstWhere((e) => e.id == exerciseExecId);
      final set = exercise.sets.firstWhere((s) => s.setNumber == setNumber);
      final rest = set.restDuration ?? 0;
      if (rest > 0 && mounted) {
        ref.read(restTimerProvider.notifier).start(
              totalSeconds: rest,
              exerciseExecId: exerciseExecId,
            );
      }
    } catch (_) {
      // Network failed — save offline as fallback
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

      // Check if all exercises are complete
      final allDone = wState.exercises.every(
        (e) => wState.isExerciseComplete(e.id, e.sets.length),
      );

      if (allDone) {
        haptic.workoutCompleted();
        ref.read(workoutStateProvider.notifier).showCompletion();
      } else {
        // Show next exercise countdown
        setState(() => _showNextExerciseCountdown = true);
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
        content: Text('Salvato offline — verrà sincronizzato'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  void _jumpToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _advanceToNextExercise() {
    setState(() => _showNextExerciseCountdown = false);
    final wState = ref.read(workoutStateProvider);
    final nextPage = wState.currentPage + 1;
    if (nextPage < wState.exercises.length) {
      _jumpToPage(nextPage);
    }
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

  Future<void> _confirmExit(BuildContext context) async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Esci dall'allenamento?"),
        content: const Text(
          "L'allenamento rimarr\u00e0 in sospeso. "
          'Potrai riprenderlo pi\u00f9 tardi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Esci'),
          ),
        ],
      ),
    );
    if ((leave ?? false) && mounted) {
      if (context.mounted) context.go('/dashboard');
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
    final timerState = ref.watch(restTimerProvider);
    final flameState = ref.watch(flameProgressProvider);
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

    // Build completed exercise indices for ProgressIndicatorBar
    final completedIndices = <int>{};
    for (var i = 0; i < exercises.length; i++) {
      if (wState.isExerciseComplete(exercises[i].id, exercises[i].sets.length)) {
        completedIndices.add(i);
      }
    }

    // Current exercise's id for floating timer logic
    final currentExerciseId =
        exercises.isNotEmpty ? exercises[wState.currentPage].id : -1;

    // Next exercise info for countdown
    Widget? nextCountdown;
    if (_showNextExerciseCountdown && wState.currentPage < exercises.length - 1) {
      final nextExe = exercises[wState.currentPage + 1];
      nextCountdown = NextExerciseCountdown(
        exerciseName: nextExe.exerciseName ?? 'Esercizio',
        exerciseInfo: '${nextExe.sets.length} serie',
        isLastExercise: wState.currentPage + 1 == exercises.length - 1,
        onComplete: _advanceToNextExercise,
        onSkip: _advanceToNextExercise,
      );
    }

    // Timer overlay for current exercise
    Widget? timerOverlay;
    if (timerState.isActive && timerState.exerciseExecId == currentExerciseId) {
      // Build next set info string
      final nextSetInfo = _buildNextSetInfo(exercises[wState.currentPage], wState);
      timerOverlay = RestTimerOverlay(
        state: timerState,
        onSkip: () => ref.read(restTimerProvider.notifier).skip(),
        nextSetInfo: nextSetInfo,
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _confirmExit(context),
        ),
        title: Text(
          execution.sessionName ?? 'Allenamento',
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          // Flame + percentage
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
          // Mini timer in app bar
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
      body: exercises.isEmpty
          ? const Center(
              child: Text(
                'Nessun esercizio',
                style: TextStyle(color: AppColors.textMuted),
              ),
            )
          : Stack(
              children: [
                Column(
                  children: [
                    ProgressIndicatorBar(
                      total: exercises.length,
                      currentIndex: wState.currentPage,
                      completedIndices: completedIndices,
                      onTapIndex: _jumpToPage,
                    ),
                    Expanded(
                      child: ExerciseCarousel(
                        pageController: _pageController,
                        exercises: exercises,
                        inputs: _inputs,
                        completedKeys: wState.completedKeys,
                        onCompleteSet: _logSet,
                        onPageChanged: (page) {
                          ref.read(workoutStateProvider.notifier).setCurrentPage(page);
                          setState(() => _showNextExerciseCountdown = false);
                        },
                        onEditSet: (exeId, setNum) {
                          // Long-press to revert: allow re-editing
                          ref.read(workoutStateProvider.notifier).revertSetCompleted(
                                exerciseExecId: exeId,
                                setNumber: setNum,
                              );
                          final ws = ref.read(workoutStateProvider);
                          ref.read(flameProgressProvider.notifier).update(
                                completedSets: ws.completedSetCount,
                                totalSets: ws.totalSets,
                              );
                        },
                        currentPage: wState.currentPage,
                        timerOverlay: timerOverlay,
                        nextExerciseCountdown: nextCountdown,
                      ),
                    ),
                  ],
                ),
                // Floating timer when on a different exercise
                if (timerState.isActive &&
                    timerState.exerciseExecId != currentExerciseId)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingTimerWidget(
                      state: timerState,
                      exerciseName: _exerciseNameForId(
                        exercises,
                        timerState.exerciseExecId,
                      ),
                      onTap: () {
                        final idx = exercises
                            .indexWhere((e) => e.id == timerState.exerciseExecId);
                        if (idx >= 0) _jumpToPage(idx);
                      },
                    ),
                  ),
              ],
            ),
    );
  }

  String _buildNextSetInfo(ExerciseExecution exercise, WorkoutState wState) {
    for (final s in exercise.sets) {
      if (!wState.isSetCompleted(exercise.id, s.setNumber)) {
        final reps = s.targetReps?.toString() ?? '?';
        final weight = s.targetWeight?.toString() ?? '?';
        return 'Serie ${s.setNumber}: $reps rip x $weight kg';
      }
    }
    return '';
  }

  String _exerciseNameForId(List<ExerciseExecution> exercises, int id) {
    return exercises
        .firstWhere(
          (e) => e.id == id,
          orElse: () => exercises.first,
        )
        .exerciseName ?? 'Esercizio';
  }
}

// ---------------------------------------------------------------------------
// Completion View
// ---------------------------------------------------------------------------

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

            // Feeling selector
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

            // Notes
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
