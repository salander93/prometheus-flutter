import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/workout_models.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';
import 'package:palestra/presentation/shared/providers/workout_providers.dart';
import 'package:palestra/presentation/shared/widgets/shimmer_loading.dart';

class PlansListScreen extends ConsumerWidget {
  const PlansListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final plansAsync = ref.watch(workoutPlansProvider);

    final isTrainer = userAsync.valueOrNull?.role == 'TRAINER';

    return Stack(
      children: [
        plansAsync.when(
          data: (plans) => _PlansList(
            plans: plans,
            isTrainer: isTrainer,
            onRefresh: () async => ref.invalidate(workoutPlansProvider),
          ),
          loading: () => const ShimmerLoading(),
          error: (error, _) => _ErrorView(
            onRetry: () => ref.invalidate(workoutPlansProvider),
          ),
        ),
        if (isTrainer)
          Positioned(
            right: 16,
            bottom: 96,
            child: FloatingActionButton(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textPrimary,
              tooltip: 'Crea nuova scheda',
              onPressed: () {
                // TODO(dev): navigate to create plan screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funzionalità in arrivo'),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Plans list body
// ---------------------------------------------------------------------------

class _PlansList extends StatelessWidget {
  const _PlansList({
    required this.plans,
    required this.isTrainer,
    required this.onRefresh,
  });

  final List<WorkoutPlanSummary> plans;
  final bool isTrainer;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (plans.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          children: [_EmptyState(isTrainer: isTrainer)],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        itemCount: plans.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _PlanCard(
          plan: plans[index],
          isTrainer: isTrainer,
          onTap: () => context.push('/plans/${plans[index].id}'),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Plan card
// ---------------------------------------------------------------------------

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.isTrainer,
    required this.onTap,
  });

  final WorkoutPlanSummary plan;
  final bool isTrainer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final subtitle = isTrainer ? plan.clientName : plan.trainerName;

    return Material(
      color: AppColors.backgroundCard,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      plan.name,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _ActiveBadge(isActive: plan.isActive),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                isTrainer ? 'Cliente: $subtitle' : 'Trainer: $subtitle',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${plan.durationWeeks} settimane',
                    style: textTheme.labelMedium?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.repeat_outlined,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Settimana ${plan.currentWeek}',
                    style: textTheme.labelMedium?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
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
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Active badge
// ---------------------------------------------------------------------------

class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.success.withValues(alpha: 0.15)
            : AppColors.textMuted.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? AppColors.success : AppColors.textMuted,
          width: 0.5,
        ),
      ),
      child: Text(
        isActive ? 'Attiva' : 'Inattiva',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isActive ? AppColors.success : AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
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
              Icons.assignment_outlined,
              size: 64,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              isTrainer
                  ? 'Nessuna scheda creata'
                  : 'Nessuna scheda assegnata',
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (isTrainer) ...[
              const SizedBox(height: 8),
              Text(
                'Crea la prima scheda per i tuoi clienti',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ],
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
