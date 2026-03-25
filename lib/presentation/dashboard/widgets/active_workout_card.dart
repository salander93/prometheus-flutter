import 'package:flutter/material.dart';
import 'package:palestra/data/models/workout_models.dart';

class ActiveWorkoutCard extends StatelessWidget {
  const ActiveWorkoutCard({
    required this.execution,
    required this.onResume,
    super.key,
  });

  final WorkoutExecution execution;
  final VoidCallback onResume;

  String _elapsedTime() {
    final startedAt = execution.startedAt;
    if (startedAt == null) return '';
    final start = DateTime.tryParse(startedAt);
    if (start == null) return '';
    final elapsed = DateTime.now().difference(start);
    final hours = elapsed.inHours;
    final minutes = elapsed.inMinutes % 60;
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final elapsed = _elapsedTime();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.play_circle_outline,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Allenamento in corso',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              execution.sessionName ?? 'Sessione senza nome',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (execution.planName != null) ...[
              const SizedBox(height: 4),
              Text(
                execution.planName!,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (elapsed.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Tempo trascorso: $elapsed',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onResume,
              icon: const Icon(Icons.play_arrow, size: 18),
              label: const Text('Riprendi'),
            ),
          ],
        ),
      ),
    );
  }
}

class NextWorkoutCard extends StatelessWidget {
  const NextWorkoutCard({
    required this.plan,
    required this.onStart,
    super.key,
  });

  final WorkoutPlanSummary plan;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: colorScheme.secondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Prossimo allenamento',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              plan.name,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Settimana ${plan.currentWeek} di ${plan.durationWeeks}',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.fitness_center, size: 18),
              label: const Text('Inizia'),
            ),
          ],
        ),
      ),
    );
  }
}
