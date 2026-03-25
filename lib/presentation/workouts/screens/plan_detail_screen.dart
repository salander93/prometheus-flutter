import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/workout_plan_detail_model.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';
import 'package:palestra/presentation/shared/providers/workout_providers.dart';

class PlanDetailScreen extends ConsumerStatefulWidget {
  const PlanDetailScreen({required this.planId, super.key});

  final int planId;

  @override
  ConsumerState<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends ConsumerState<PlanDetailScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _sessionCount = 0;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  TabController _ensureTabController(int count) {
    if (_tabController == null || _sessionCount != count) {
      _tabController?.dispose();
      _tabController = TabController(length: count, vsync: this);
      _sessionCount = count;
    }
    return _tabController!;
  }

  @override
  Widget build(BuildContext context) {
    final planAsync = ref.watch(planDetailProvider(widget.planId));
    final userAsync = ref.watch(currentUserProvider);
    final isTrainer = userAsync.valueOrNull?.role == 'TRAINER';

    return planAsync.when(
      data: (plan) => _PlanDetailContent(
        plan: plan,
        isTrainer: isTrainer,
        tabController: _ensureTabController(plan.sessions.length),
        onRetry: () => ref.invalidate(planDetailProvider(widget.planId)),
      ),
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Scheda')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Scheda')),
        body: _ErrorBody(
          onRetry: () => ref.invalidate(planDetailProvider(widget.planId)),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Main content widget
// ---------------------------------------------------------------------------

class _PlanDetailContent extends StatelessWidget {
  const _PlanDetailContent({
    required this.plan,
    required this.isTrainer,
    required this.tabController,
    required this.onRetry,
  });

  final WorkoutPlanDetail plan;
  final bool isTrainer;
  final TabController tabController;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final hasSessions = plan.sessions.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          plan.name,
          overflow: TextOverflow.ellipsis,
        ),
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            tooltip: 'Scarica PDF',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Download PDF in arrivo'),
                ),
              );
            },
          ),
        ],
        bottom: hasSessions
            ? TabBar(
                controller: tabController,
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textMuted,
                isScrollable: plan.sessions.length > 3,
                tabs: plan.sessions
                    .map((s) => Tab(text: s.name))
                    .toList(),
              )
            : null,
      ),
      body: Column(
        children: [
          _PlanHeader(plan: plan, isTrainer: isTrainer),
          if (hasSessions)
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: plan.sessions
                    .map((session) => _SessionTab(session: session))
                    .toList(),
              ),
            )
          else
            const Expanded(
              child: Center(
                child: Text(
                  'Nessuna sessione configurata',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: (!isTrainer && plan.isActive)
          ? _StartWorkoutBar(plan: plan)
          : null,
    );
  }
}

// ---------------------------------------------------------------------------
// Plan header
// ---------------------------------------------------------------------------

class _PlanHeader extends StatelessWidget {
  const _PlanHeader({required this.plan, required this.isTrainer});

  final WorkoutPlanDetail plan;
  final bool isTrainer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: AppColors.backgroundCard,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isTrainer
                          ? 'Cliente: ${plan.clientName}'
                          : 'Trainer: ${plan.trainerName}',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (plan.description != null &&
                        plan.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        plan.description!,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _ActiveBadge(isActive: plan.isActive),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            children: [
              _InfoChip(
                icon: Icons.calendar_today_outlined,
                label: '${plan.durationWeeks} settimane',
              ),
              _InfoChip(
                icon: Icons.repeat_outlined,
                label: 'Sett. ${plan.currentWeek}',
              ),
              if (plan.startDate != null)
                _InfoChip(
                  icon: Icons.play_arrow_outlined,
                  label: _formatDate(plan.startDate!),
                ),
              if (plan.endDate != null)
                _InfoChip(
                  icon: Icons.stop_outlined,
                  label: _formatDate(plan.endDate!),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}/'
          '${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textMuted),
        const SizedBox(width: 3),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textMuted,
              ),
        ),
      ],
    );
  }
}

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
// Session tab
// ---------------------------------------------------------------------------

class _SessionTab extends StatelessWidget {
  const _SessionTab({required this.session});

  final WorkoutSession session;

  @override
  Widget build(BuildContext context) {
    if (session.exercises.isEmpty) {
      return const Center(
        child: Text(
          'Nessun esercizio in questa sessione',
          style: TextStyle(color: AppColors.textMuted),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: session.exercises.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _ExerciseCard(
        exercise: session.exercises[index],
        index: index,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Exercise card
// ---------------------------------------------------------------------------

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({required this.exercise, required this.index});

  final SessionExercise exercise;
  final int index;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: AppColors.backgroundCard,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise image / placeholder
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: SizedBox(
                width: 80,
                height: 80,
                child: exercise.exerciseImage != null &&
                        exercise.exerciseImage!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: exercise.exerciseImage!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const ColoredBox(
                          color: AppColors.backgroundCardHover,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            _ExercisePlaceholder(index: index),
                      )
                    : _ExercisePlaceholder(index: index),
              ),
            ),
            // Exercise info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            exercise.exerciseName,
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (exercise.isPyramid)
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.show_chart,
                              size: 14,
                              color: AppColors.accent,
                            ),
                          ),
                      ],
                    ),
                    if (exercise.exerciseMuscleGroupDisplay != null) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          exercise.exerciseMuscleGroupDisplay!,
                          style: textTheme.labelSmall?.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        _StatPill(
                          label: '${exercise.sets}×${exercise.reps}',
                          icon: Icons.repeat,
                        ),
                        _StatPill(
                          label: exercise.restTime,
                          icon: Icons.timer_outlined,
                        ),
                        if (exercise.weightKg != null)
                          _StatPill(
                            label: '${exercise.weightKg} kg',
                            icon: Icons.fitness_center_outlined,
                          ),
                      ],
                    ),
                    if (exercise.notes.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        exercise.notes,
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.textMuted,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExercisePlaceholder extends StatelessWidget {
  const _ExercisePlaceholder({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.backgroundCardHover,
      child: Center(
        child: Text(
          '${index + 1}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textMuted),
        const SizedBox(width: 3),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom bar – start workout
// ---------------------------------------------------------------------------

class _StartWorkoutBar extends StatelessWidget {
  const _StartWorkoutBar({required this.plan});

  final WorkoutPlanDetail plan;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textPrimary,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            context.go('/plans/${plan.id}/start');
          },
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text(
            'Inizia Allenamento',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error body
// ---------------------------------------------------------------------------

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.onRetry});

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
              'Errore nel caricamento della scheda',
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
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
