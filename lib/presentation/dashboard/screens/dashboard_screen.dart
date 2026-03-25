import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/relation_models.dart';
import 'package:palestra/data/models/user_model.dart';
import 'package:palestra/data/models/workout_models.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';
import 'package:palestra/presentation/dashboard/widgets/active_workout_card.dart';
import 'package:palestra/presentation/dashboard/widgets/client_avatar_list.dart';
import 'package:palestra/presentation/dashboard/widgets/recent_activity_list.dart';
import 'package:palestra/presentation/dashboard/widgets/trainer_stats_grid.dart';
import 'package:palestra/presentation/dashboard/widgets/training_calendar.dart';
import 'package:palestra/presentation/dashboard/widgets/welcome_card.dart';
import 'package:palestra/presentation/shared/providers/user_providers.dart';
import 'package:palestra/presentation/shared/providers/workout_providers.dart';
import 'package:palestra/presentation/shared/widgets/shimmer_loading.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (user.role == 'TRAINER') {
          return _TrainerDashboard(user: user);
        }
        return _ClientDashboard(user: user);
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, _) => Center(
        child: Text('Errore: $error'),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Client dashboard
// ---------------------------------------------------------------------------

class _ClientDashboard extends ConsumerWidget {
  const _ClientDashboard({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeAsync = ref.watch(activeExecutionProvider);
    final plansAsync = ref.watch(workoutPlansProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref
          ..invalidate(activeExecutionProvider)
          ..invalidate(workoutPlansProvider);
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          WelcomeCard(
            title: 'Ciao, ${user.fullName}',
            subtitle: 'Pronto per allenarti oggi?',
          ),
          const SizedBox(height: 16),
          activeAsync.when(
            data: (execution) {
              if (execution != null) {
                return Column(
                  children: [
                    ActiveWorkoutCard(
                      execution: execution,
                      onResume: () {
                        // TODO(dev): navigate to active workout
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }
              return plansAsync.when(
                data: (plans) {
                  final activePlans =
                      plans.where((p) => p.isActive).toList();
                  if (activePlans.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                'Non hai ancora una scheda '
                                'assegnata.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Contatta il tuo trainer!',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors
                                          .textSecondary,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      NextWorkoutCard(
                        plan: activePlans.first,
                        onStart: () {
                          // TODO(dev): navigate to start workout
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
            loading: () => const ShimmerLoading(type: ShimmerType.card),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const TrainingCalendar(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Trainer dashboard
// ---------------------------------------------------------------------------

class _TrainerDashboard extends ConsumerWidget {
  const _TrainerDashboard({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsAsync = ref.watch(myClientsProvider);
    final plansAsync = ref.watch(workoutPlansProvider);
    final logsAsync = ref.watch(activityLogsProvider);
    final textTheme = Theme.of(context).textTheme;

    return RefreshIndicator(
      onRefresh: () async {
        ref
          ..invalidate(myClientsProvider)
          ..invalidate(workoutPlansProvider)
          ..invalidate(activityLogsProvider);
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          WelcomeCard(
            title: 'Ciao Coach ${user.firstName}!',
            subtitle: 'Ecco la situazione dei tuoi clienti',
            isTrainer: true,
          ),
          const SizedBox(height: 16),
          clientsAsync.when(
            data: (clients) {
              final planCount = plansAsync.valueOrNull?.length ?? 0;
              return TrainerStatsGrid(
                clientCount: clients.length,
                planCount: planCount,
              );
            },
            loading: () => const ShimmerLoading(type: ShimmerType.card),
            error: (_, __) => TrainerStatsGrid(
              clientCount: 0,
              planCount: plansAsync.valueOrNull?.length ?? 0,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Clienti',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          clientsAsync.when(
            data: (clients) => ClientAvatarList(
              clients: clients,
              onClientTap: (_) {
                // TODO(dev): navigate to plans filtered by client
              },
            ),
            loading: () => const ShimmerLoading(),
            error: (_, __) => ClientAvatarList(
              clients: const <TrainerClient>[],
              onClientTap: (_) {},
            ),
          ),
          const SizedBox(height: 16),
          logsAsync.when(
            data: (logs) {
              final recent = logs.take(5).toList();
              return RecentActivityList(
                logs: recent,
                onViewAll: () {
                  // TODO(dev): navigate to full activity log
                },
              );
            },
            loading: () => const ShimmerLoading(),
            error: (_, __) => RecentActivityList(
              logs: const <ActivityLogSummary>[],
              onViewAll: () {},
            ),
          ),
        ],
      ),
    );
  }
}
