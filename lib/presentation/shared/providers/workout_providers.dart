import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palestra/core/storage/cache_providers.dart';
import 'package:palestra/data/datasources/remote/workout_remote_datasource.dart';
import 'package:palestra/data/models/execution_models.dart';
import 'package:palestra/data/models/workout_models.dart';
import 'package:palestra/data/models/workout_plan_detail_model.dart';
import 'package:palestra/data/repositories/workout_repository_impl.dart';
import 'package:palestra/domain/repositories/workout_repository.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';

final workoutRemoteDatasourceProvider =
    Provider<WorkoutRemoteDatasource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WorkoutRemoteDatasource(dio: apiClient.dio);
});

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return WorkoutRepositoryImpl(
    remoteDatasource: ref.watch(workoutRemoteDatasourceProvider),
  );
});

final workoutPlansProvider =
    FutureProvider<List<WorkoutPlanSummary>>((ref) async {
  final cachedApi = ref.watch(cachedApiProvider);
  final repo = ref.watch(workoutRepositoryProvider);

  return cachedApi.fetch<List<WorkoutPlanSummary>>(
    cacheKey: 'plans',
    apiCall: repo.getPlans,
    fromCache: (json) => (json as List<dynamic>)
        .map((e) => WorkoutPlanSummary.fromJson(e as Map<String, dynamic>))
        .toList(),
    toCache: (data) => data.map((e) => e.toJson()).toList(),
    ttl: const Duration(minutes: 2),
  );
});

final activeExecutionProvider =
    FutureProvider<WorkoutExecution?>((ref) async {
  final repo = ref.watch(workoutRepositoryProvider);
  return repo.getActiveExecution();
});

final calendarProvider = FutureProvider.family<CalendarData,
    ({int year, int month})>((ref, params) async {
  final repo = ref.watch(workoutRepositoryProvider);
  return repo.getCalendar(year: params.year, month: params.month);
});

final activityLogsProvider =
    FutureProvider<List<ActivityLogSummary>>((ref) async {
  final repo = ref.watch(workoutRepositoryProvider);
  return repo.getActivityLogs();
});

final planDetailProvider =
    FutureProvider.family<WorkoutPlanDetail, int>((ref, planId) async {
  final repo = ref.watch(workoutRepositoryProvider);
  return repo.getPlanDetail(planId);
});

final sessionSuggestionProvider =
    FutureProvider.family<SessionSuggestionResponse, int>((ref, planId) async {
  final repo = ref.read(workoutRepositoryProvider);
  return repo.suggestSession(planId);
});
