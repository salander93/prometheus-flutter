import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/workout_models.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';
import 'package:palestra/presentation/shared/providers/workout_providers.dart';
import 'package:palestra/presentation/shared/widgets/shimmer_loading.dart';
import 'package:palestra/presentation/workouts/widgets/start_workout_sheet.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final logsAsync = ref.watch(activityLogsProvider);
    final activeExecution = ref.watch(activeExecutionProvider).valueOrNull;
    final allPlans = ref.watch(workoutPlansProvider).valueOrNull ?? [];
    // Only show plans that are active (sessions checked at sheet level)
    final plans = allPlans.where((p) => p.isActive).toList();

    final isTrainer = userAsync.valueOrNull?.role == 'TRAINER';

    return logsAsync.when(
      data: (logs) => _LogsList(
        logs: logs,
        isTrainer: isTrainer,
        activeExecution: isTrainer ? null : activeExecution,
        activePlans: isTrainer ? [] : plans,
        onRefresh: () async {
          ref.invalidate(activityLogsProvider);
          ref.invalidate(activeExecutionProvider);
        },
      ),
      loading: () => const ShimmerLoading(),
      error: (error, _) => _ErrorView(
        onRetry: () => ref.invalidate(activityLogsProvider),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Logs list body
// ---------------------------------------------------------------------------

class _LogsList extends StatelessWidget {
  const _LogsList({
    required this.logs,
    required this.isTrainer,
    required this.onRefresh,
    this.activeExecution,
    this.activePlans = const [],
  });

  final List<ActivityLogSummary> logs;
  final bool isTrainer;
  final Future<void> Function() onRefresh;
  final WorkoutExecution? activeExecution;
  final List<WorkoutPlanSummary> activePlans;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          // Active workout banner
          if (activeExecution != null) ...[
            _ActiveWorkoutBanner(
              execution: activeExecution!,
              onResume: () => context.go('/workout/${activeExecution!.id}'),
            ),
            const SizedBox(height: 16),
          ],

          // Start workout buttons (if no active workout and has plans)
          if (activeExecution == null && activePlans.isNotEmpty) ...[
            Text(
              'Inizia Allenamento',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...activePlans.map((plan) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _StartWorkoutButton(
                plan: plan,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => StartWorkoutSheet(planId: plan.id),
                  );
                },
              ),
            )),
            const SizedBox(height: 16),
          ],

          // Storico header
          if (logs.isNotEmpty) ...[
            Text(
              'Storico',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Log cards
          if (logs.isEmpty)
            _EmptyState(isTrainer: isTrainer)
          else
            ...logs.map((log) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ActivityCard(log: log, isTrainer: isTrainer),
            )),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Active workout banner (simple orange bar like old PWA activity page)
// ---------------------------------------------------------------------------

class _ActiveWorkoutBanner extends StatelessWidget {
  const _ActiveWorkoutBanner({
    required this.execution,
    required this.onResume,
  });

  final WorkoutExecution execution;
  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onResume,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    execution.sessionName ?? 'Allenamento in corso',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  if (execution.planName != null)
                    Text(
                      execution.planName!,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Riprendi',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Start workout button
// ---------------------------------------------------------------------------

class _StartWorkoutButton extends StatelessWidget {
  const _StartWorkoutButton({
    required this.plan,
    required this.onTap,
  });

  final WorkoutPlanSummary plan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Settimana ${plan.currentWeek} di ${plan.durationWeeks}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        );
  }
}

// ---------------------------------------------------------------------------
// Activity card
// ---------------------------------------------------------------------------

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.log, required this.isTrainer});

  final ActivityLogSummary log;
  final bool isTrainer;

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('d MMMM yyyy', 'it_IT').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final formattedDate = _formatDate(log.date);

    return Material(
      color: AppColors.backgroundCard,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Text(
              formattedDate,
              style: textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),

            if (isTrainer) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    log.clientName,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 12),

            // Stats row
            Row(
              children: [
                if (log.durationMinutes != null) ...[
                  const Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${log.durationMinutes} min',
                    style: textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                if (log.feelingDisplay != null) ...[
                  Text(
                    _feelingEmoji(log.feelingDisplay!),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    log.feelingDisplay!,
                    style: textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const Spacer(),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textMuted,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _feelingEmoji(String feeling) {
    final lower = feeling.toLowerCase();
    if (lower.contains('ottim') || lower.contains('excel')) return '🔥';
    if (lower.contains('bene') || lower.contains('buon')) return '😊';
    if (lower.contains('normal') || lower.contains('nella media')) return '😐';
    if (lower.contains('male') || lower.contains('stanca')) return '😔';
    if (lower.contains('pessim')) return '😞';
    return '💪';
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isTrainer});

  final bool isTrainer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.fitness_center_outlined,
              size: 64,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              isTrainer
                  ? 'Nessuna attività dei clienti'
                  : 'Nessun allenamento registrato',
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isTrainer
                  ? 'Le sessioni dei tuoi clienti appariranno qui'
                  : 'Completa il tuo primo allenamento per vederlo qui',
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error view
// ---------------------------------------------------------------------------

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
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
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Riprova'),
            ),
          ],
        ),
      ),
    );
  }
}
