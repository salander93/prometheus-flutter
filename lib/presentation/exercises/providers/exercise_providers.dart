import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palestra/core/storage/cache_providers.dart';
import 'package:palestra/data/models/exercise_model.dart';
import 'package:palestra/presentation/shared/providers/workout_providers.dart';

/// Provides a list of exercises, optionally filtered by search term and
/// muscle group.
final exercisesProvider = FutureProvider.family<List<ExerciseModel>,
    ({String? search, String? muscleGroup})>((ref, params) async {
  final cachedApi = ref.watch(cachedApiProvider);
  final repo = ref.watch(workoutRepositoryProvider);

  final searchPart = params.search ?? '';
  final musclePart = params.muscleGroup ?? '';
  final cacheKey = 'exercises_${searchPart}_$musclePart';

  return cachedApi.fetch<List<ExerciseModel>>(
    cacheKey: cacheKey,
    apiCall: () => repo.getExercises(
      search: params.search,
      muscleGroup: params.muscleGroup,
    ),
    fromCache: (json) => (json as List<dynamic>)
        .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    toCache: (data) => data.map((e) => e.toJson()).toList(),
    ttl: const Duration(minutes: 30),
  );
});

/// Provides the detail for a single exercise identified by its id.
final exerciseDetailProvider =
    FutureProvider.family<ExerciseModel, int>((ref, exerciseId) async {
  final repo = ref.watch(workoutRepositoryProvider);
  return repo.getExerciseDetail(exerciseId);
});
