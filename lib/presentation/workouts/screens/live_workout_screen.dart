import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:palestra/core/connectivity/connectivity_service.dart';
import 'package:palestra/core/storage/cache_providers.dart';
import 'package:palestra/core/storage/pending_sets_storage.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/execution_models.dart';
import 'package:palestra/presentation/shared/providers/workout_providers.dart';
import 'package:palestra/presentation/workouts/widgets/rest_timer_widget.dart';

/// Provider that fetches and caches the execution detail.
final executionDetailProvider = FutureProvider.family<
    WorkoutExecutionDetail, int>((ref, executionId) async {
  final repo = ref.watch(workoutRepositoryProvider);
  return repo.getExecutionDetail(executionId);
});

/// The core live workout tracking screen.
class LiveWorkoutScreen extends ConsumerStatefulWidget {
  const LiveWorkoutScreen({
    required this.executionId,
    super.key,
  });

  final int executionId;

  @override
  ConsumerState<LiveWorkoutScreen> createState() =>
      _LiveWorkoutScreenState();
}

class _LiveWorkoutScreenState
    extends ConsumerState<LiveWorkoutScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  // Set-logging input controllers keyed by exerciseExecution id
  final Map<int, Map<int, _SetInput>> _inputs = {};

  // Completed sets (optimistic UI)
  final Set<String> _completedKeys = {};

  // Rest timer state
  bool _showRestTimer = false;
  int _restSeconds = 0;

  // Completion state
  bool _showCompletion = false;
  int _feeling = 3;
  final _notesController = TextEditingController();
  bool _isCompleting = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _setKey(int exeId, int setNum) => '$exeId:$setNum';

  @override
  Widget build(BuildContext context) {
    final asyncExecution =
        ref.watch(executionDetailProvider(widget.executionId));

    return asyncExecution.when(
      data: (execution) =>
          _buildContent(context, execution),
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
              const Icon(
                Icons.error_outline,
                size: 56,
                color: AppColors.danger,
              ),
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
                onPressed: () => ref.invalidate(
                  executionDetailProvider(widget.executionId),
                ),
                child: const Text('Riprova'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WorkoutExecutionDetail execution,
  ) {
    final exercises = execution.exerciseExecutions;

    if (_showCompletion) {
      return _CompletionView(
        feeling: _feeling,
        notesController: _notesController,
        isCompleting: _isCompleting,
        onFeelingChanged: (f) => setState(() => _feeling = f),
        onComplete: _completeWorkout,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          execution.sessionName ?? 'Allenamento',
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _confirmExit(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                '${_currentPage + 1}/${exercises.length}',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: AppColors.textMuted),
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
          : PageView.builder(
              controller: _pageController,
              itemCount: exercises.length,
              onPageChanged: (i) =>
                  setState(() => _currentPage = i),
              itemBuilder: (context, index) {
                return _ExercisePage(
                  exercise: exercises[index],
                  inputs: _inputsFor(exercises[index]),
                  completedKeys: _completedKeys,
                  setKeyFn: _setKey,
                  showRestTimer: _showRestTimer &&
                      _currentPage == index,
                  restSeconds: _restSeconds,
                  onLogSet: (setNum, reps, weight) =>
                      _logSet(
                    exercises[index],
                    setNum,
                    reps,
                    weight,
                  ),
                  onRestComplete: _dismissRest,
                  onRestSkip: _dismissRest,
                );
              },
            ),
      bottomNavigationBar: exercises.isNotEmpty
          ? _BottomNav(
              currentPage: _currentPage,
              totalPages: exercises.length,
              onPrevious: _goToPrevious,
              onNext: () => _goToNext(exercises.length),
            )
          : null,
    );
  }

  Map<int, _SetInput> _inputsFor(ExerciseExecution exe) {
    return _inputs.putIfAbsent(exe.id, () {
      final map = <int, _SetInput>{};
      for (final s in exe.sets) {
        map[s.setNumber] = _SetInput(
          reps: TextEditingController(
            text: s.actualReps?.toString() ??
                s.targetReps?.toString() ??
                '',
          ),
          weight: TextEditingController(
            text: s.actualWeight?.toString() ??
                s.targetWeight?.toString() ??
                '',
          ),
        );
        // Mark already-completed sets
        if (s.completedAt != null) {
          _completedKeys.add(_setKey(exe.id, s.setNumber));
        }
      }
      return map;
    });
  }

  Future<void> _logSet(
    ExerciseExecution exercise,
    int setNumber,
    int? reps,
    double? weight,
  ) async {
    final key = _setKey(exercise.id, setNumber);
    // Optimistic: mark as done immediately so the UI is responsive.
    setState(() => _completedKeys.add(key));

    final isOnline = ref.read(isOnlineProvider);

    if (!isOnline) {
      // Offline path — queue locally and show a non-intrusive notice.
      await _saveSetOffline(
        exercise: exercise,
        setNumber: setNumber,
        reps: reps,
        weight: weight,
      );
      _showOfflineSnackBar();
      return;
    }

    try {
      final repo = ref.read(workoutRepositoryProvider);
      await repo.logSet(
        executionId: widget.executionId,
        exerciseExecutionId: exercise.id,
        setNumber: setNumber,
        actualReps: reps,
        actualWeight: weight,
      );

      // Find rest time from the set
      final set = exercise.sets.firstWhere(
        (s) => s.setNumber == setNumber,
      );
      final rest = set.restDuration ?? 0;

      if (rest > 0 && mounted) {
        setState(() {
          _showRestTimer = true;
          _restSeconds = rest;
        });
      }
    } catch (_) {
      // Network call failed despite appearing online — save offline as
      // fallback so the user doesn't lose their data.
      await _saveSetOffline(
        exercise: exercise,
        setNumber: setNumber,
        reps: reps,
        weight: weight,
      );
      _showOfflineSnackBar();
    }
  }

  Future<void> _saveSetOffline({
    required ExerciseExecution exercise,
    required int setNumber,
    required int? reps,
    required double? weight,
  }) async {
    final storage = ref.read(pendingSetsStorageProvider);
    await storage.addPendingSet(
      PendingSetData(
        executionId: widget.executionId,
        exerciseExecutionId: exercise.id,
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

  void _dismissRest() {
    setState(() => _showRestTimer = false);
  }

  void _goToPrevious() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNext(int total) {
    if (_currentPage < total - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Last exercise — show completion
      setState(() => _showCompletion = true);
    }
  }

  Future<void> _completeWorkout() async {
    setState(() => _isCompleting = true);
    try {
      final repo = ref.read(workoutRepositoryProvider);
      await repo.completeExecution(
        widget.executionId,
        feeling: _feeling,
        notes: _notesController.text.isNotEmpty
            ? _notesController.text
            : null,
      );
      if (mounted) {
        context.go('/dashboard');
      }
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Set input holder (not a widget — just controllers)
// ─────────────────────────────────────────────────────────────────────────────

class _SetInput {
  _SetInput({required this.reps, required this.weight});
  final TextEditingController reps;
  final TextEditingController weight;
}

// ─────────────────────────────────────────────────────────────────────────────
// Exercise page
// ─────────────────────────────────────────────────────────────────────────────

class _ExercisePage extends StatelessWidget {
  const _ExercisePage({
    required this.exercise,
    required this.inputs,
    required this.completedKeys,
    required this.setKeyFn,
    required this.showRestTimer,
    required this.restSeconds,
    required this.onLogSet,
    required this.onRestComplete,
    required this.onRestSkip,
  });

  final ExerciseExecution exercise;
  final Map<int, _SetInput> inputs;
  final Set<String> completedKeys;
  final String Function(int exeId, int setNum) setKeyFn;
  final bool showRestTimer;
  final int restSeconds;
  final void Function(int setNum, int? reps, double? weight)
      onLogSet;
  final VoidCallback onRestComplete;
  final VoidCallback onRestSkip;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      children: [
        // Exercise image
        if (exercise.exerciseImage != null &&
            exercise.exerciseImage!.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: exercise.exerciseImage!,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                height: 180,
                color: AppColors.backgroundCardHover,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        const SizedBox(height: 12),

        // Exercise name
        Text(
          exercise.exerciseName,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),

        // Notes
        if (exercise.notes != null &&
            exercise.notes!.isNotEmpty) ...[
          Text(
            exercise.notes!,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Rest timer overlay
        if (showRestTimer && restSeconds > 0) ...[
          RestTimerWidget(
            key: ValueKey('rest-${exercise.id}'),
            totalSeconds: restSeconds,
            onComplete: onRestComplete,
            onSkip: onRestSkip,
          ),
          const SizedBox(height: 16),
        ],

        // Set table
        _SetTable(
          exercise: exercise,
          inputs: inputs,
          completedKeys: completedKeys,
          setKeyFn: setKeyFn,
          onLogSet: onLogSet,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Set table
// ─────────────────────────────────────────────────────────────────────────────

class _SetTable extends StatelessWidget {
  const _SetTable({
    required this.exercise,
    required this.inputs,
    required this.completedKeys,
    required this.setKeyFn,
    required this.onLogSet,
  });

  final ExerciseExecution exercise;
  final Map<int, _SetInput> inputs;
  final Set<String> completedKeys;
  final String Function(int exeId, int setNum) setKeyFn;
  final void Function(int setNum, int? reps, double? weight)
      onLogSet;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final sets = exercise.sets;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: Text(
                    'Serie',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Rip.',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Peso (kg)',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 72),
              ],
            ),
          ),
          const Divider(height: 1),
          // Rows
          ...sets.map((s) {
            final key = setKeyFn(exercise.id, s.setNumber);
            final done = completedKeys.contains(key);
            final inp = inputs[s.setNumber];

            return _SetRow(
              setNumber: s.setNumber,
              targetReps: s.targetReps,
              targetWeight: s.targetWeight,
              repsController: inp?.reps,
              weightController: inp?.weight,
              isDone: done,
              onComplete: () {
                final reps =
                    int.tryParse(inp?.reps.text ?? '');
                final weight =
                    double.tryParse(inp?.weight.text ?? '');
                onLogSet(s.setNumber, reps, weight);
              },
            );
          }),
        ],
      ),
    );
  }
}

class _SetRow extends StatelessWidget {
  const _SetRow({
    required this.setNumber,
    required this.targetReps,
    required this.targetWeight,
    required this.repsController,
    required this.weightController,
    required this.isDone,
    required this.onComplete,
  });

  final int setNumber;
  final int? targetReps;
  final double? targetWeight;
  final TextEditingController? repsController;
  final TextEditingController? weightController;
  final bool isDone;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: isDone
            ? AppColors.success.withValues(alpha: 0.05)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          // Set number
          SizedBox(
            width: 36,
            child: isDone
                ? const Icon(
                    Icons.check_circle,
                    size: 20,
                    color: AppColors.success,
                  )
                : Text(
                    '$setNumber',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
          // Reps input
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
              ),
              child: _CompactInput(
                controller: repsController,
                hint: targetReps?.toString() ?? '-',
                enabled: !isDone,
              ),
            ),
          ),
          // Weight input
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
              ),
              child: _CompactInput(
                controller: weightController,
                hint: targetWeight?.toString() ?? '-',
                enabled: !isDone,
                isDecimal: true,
              ),
            ),
          ),
          // Complete button
          SizedBox(
            width: 72,
            child: isDone
                ? Text(
                    'Fatto',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.success,
                    ),
                    textAlign: TextAlign.center,
                  )
                : TextButton(
                    onPressed: onComplete,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(60, 32),
                      foregroundColor: AppColors.primary,
                    ),
                    child: const Text(
                      'Completa',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _CompactInput extends StatelessWidget {
  const _CompactInput({
    required this.controller,
    required this.hint,
    required this.enabled,
    this.isDecimal = false,
  });

  final TextEditingController? controller;
  final String hint;
  final bool enabled;
  final bool isDecimal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: TextField(
        controller: controller,
        enabled: enabled,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.numberWithOptions(
          decimal: isDecimal,
        ),
        inputFormatters: [
          if (isDecimal)
            FilteringTextInputFormatter.allow(
              RegExp(r'[\d.]'),
            )
          else
            FilteringTextInputFormatter.digitsOnly,
        ],
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: enabled
                  ? AppColors.textPrimary
                  : AppColors.textMuted,
            ),
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),
          filled: true,
          fillColor: enabled
              ? AppColors.backgroundInput
              : AppColors.backgroundCardHover,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.border,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.border,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom navigation (previous / next)
// ─────────────────────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentPage,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final isFirst = currentPage == 0;
    final isLast = currentPage == totalPages - 1;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isFirst ? null : onPrevious,
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Precedente'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 48),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: onNext,
                icon: Icon(
                  isLast
                      ? Icons.flag_rounded
                      : Icons.arrow_forward,
                  size: 18,
                ),
                label: Text(
                  isLast ? 'Completa' : 'Successivo',
                ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Completion view
// ─────────────────────────────────────────────────────────────────────────────

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
                hintText:
                    "Come \u00e8 andato l'allenamento?",
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
                isCompleting
                    ? 'Salvataggio...'
                    : 'Completa Allenamento',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
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
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(
                    color: selected
                        ? AppColors.primary
                        : AppColors.textMuted,
                    fontWeight: selected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
