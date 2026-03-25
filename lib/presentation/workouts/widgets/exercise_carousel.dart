import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/execution_models.dart';
import 'package:palestra/presentation/workouts/widgets/set_input_card.dart';

/// Holds the [TextEditingController]s for a single set's reps & weight inputs.
class SetInputControllers {
  SetInputControllers({required this.reps, required this.weight});

  final TextEditingController reps;
  final TextEditingController weight;

  void dispose() {
    reps.dispose();
    weight.dispose();
  }
}

/// A PageView-based carousel that renders one [_ExercisePage] per exercise.
class ExerciseCarousel extends StatelessWidget {
  const ExerciseCarousel({
    required this.pageController,
    required this.exercises,
    required this.inputs,
    required this.completedKeys,
    required this.onCompleteSet,
    required this.onEditSet,
    required this.currentPage,
    this.timerOverlay,
    this.nextExerciseCountdown,
    this.onPageChanged,
    super.key,
  });

  final PageController pageController;
  final List<ExerciseExecution> exercises;
  final Map<int, Map<int, SetInputControllers>> inputs;
  final Set<String> completedKeys;
  final void Function(int exerciseExecId, int setNumber, int? reps, double? weight) onCompleteSet;
  final void Function(int exerciseExecId, int setNumber) onEditSet;
  final int currentPage;
  final Widget? timerOverlay;
  final Widget? nextExerciseCountdown;
  final ValueChanged<int>? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: exercises.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return _ExercisePage(
          exercise: exercise,
          inputs: inputs[exercise.id] ?? {},
          completedKeys: completedKeys,
          onCompleteSet: (setNumber, reps, weight) =>
              onCompleteSet(exercise.id, setNumber, reps, weight),
          onEditSet: (setNumber) => onEditSet(exercise.id, setNumber),
          timerOverlay: index == currentPage ? timerOverlay : null,
          nextExerciseCountdown: index == currentPage ? nextExerciseCountdown : null,
        );
      },
    );
  }
}

/// Renders a single exercise: image, name, notes, timer overlay if present,
/// set cards using [SetInputCard], and next exercise countdown if present.
class _ExercisePage extends StatelessWidget {
  const _ExercisePage({
    required this.exercise,
    required this.inputs,
    required this.completedKeys,
    required this.onCompleteSet,
    required this.onEditSet,
    this.timerOverlay,
    this.nextExerciseCountdown,
  });

  final ExerciseExecution exercise;
  final Map<int, SetInputControllers> inputs;
  final Set<String> completedKeys;
  final void Function(int setNumber, int? reps, double? weight) onCompleteSet;
  final void Function(int setNumber) onEditSet;
  final Widget? timerOverlay;
  final Widget? nextExerciseCountdown;

  int _findActiveSetNumber() {
    for (final s in exercise.sets) {
      final key = '${exercise.id}:${s.setNumber}';
      if (!completedKeys.contains(key)) return s.setNumber;
    }
    return -1; // all completed
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final activeSetNumber = _findActiveSetNumber();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // Exercise image
        if (exercise.exerciseImage != null && exercise.exerciseImage!.isNotEmpty)
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
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        const SizedBox(height: 12),

        // Exercise name
        Text(
          exercise.exerciseName,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),

        // Notes
        if (exercise.notes != null && exercise.notes!.isNotEmpty) ...[
          Text(
            exercise.notes!,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Rest timer overlay (shown inline when on this page)
        if (timerOverlay != null) ...[
          timerOverlay!,
          const SizedBox(height: 16),
        ],

        // Set cards
        ...exercise.sets.map((s) {
          final key = '${exercise.id}:${s.setNumber}';
          final isCompleted = completedKeys.contains(key);
          final isActive = s.setNumber == activeSetNumber;
          final inp = inputs[s.setNumber];

          return SetInputCard(
            setNumber: s.setNumber,
            repsController: inp?.reps ?? TextEditingController(),
            weightController: inp?.weight ?? TextEditingController(),
            isCompleted: isCompleted,
            isActive: isActive,
            onComplete: () {
              final reps = int.tryParse(inp?.reps.text ?? '');
              final weight = double.tryParse(inp?.weight.text ?? '');
              onCompleteSet(s.setNumber, reps, weight);
            },
            onLongPress: isCompleted ? () => onEditSet(s.setNumber) : null,
          );
        }),

        // Next exercise countdown (shown at bottom when exercise is complete)
        if (nextExerciseCountdown != null) ...[
          const SizedBox(height: 16),
          nextExerciseCountdown!,
        ],
      ],
    );
  }
}
