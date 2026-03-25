import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palestra/core/storage/cache_providers.dart';
import 'package:palestra/data/datasources/remote/user_remote_datasource.dart';
import 'package:palestra/data/models/body_metric_model.dart';
import 'package:palestra/data/models/relation_models.dart';
import 'package:palestra/data/repositories/user_repository_impl.dart';
import 'package:palestra/domain/repositories/user_repository.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';

final userRemoteDatasourceProvider = Provider<UserRemoteDatasource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserRemoteDatasource(dio: apiClient.dio);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    remoteDatasource: ref.watch(userRemoteDatasourceProvider),
  );
});

final myClientsProvider = FutureProvider<List<TrainerClient>>((ref) async {
  final cachedApi = ref.watch(cachedApiProvider);
  final repo = ref.watch(userRepositoryProvider);

  return cachedApi.fetch<List<TrainerClient>>(
    cacheKey: 'my_clients',
    apiCall: repo.getMyClients,
    fromCache: (json) => (json as List<dynamic>)
        .map((e) => TrainerClient.fromJson(e as Map<String, dynamic>))
        .toList(),
    toCache: (data) => data.map((e) => e.toJson()).toList(),
  );
});

final myTrainersProvider = FutureProvider<List<TrainerClient>>((ref) async {
  final cachedApi = ref.watch(cachedApiProvider);
  final repo = ref.watch(userRepositoryProvider);

  return cachedApi.fetch<List<TrainerClient>>(
    cacheKey: 'my_trainers',
    apiCall: repo.getMyTrainers,
    fromCache: (json) => (json as List<dynamic>)
        .map((e) => TrainerClient.fromJson(e as Map<String, dynamic>))
        .toList(),
    toCache: (data) => data.map((e) => e.toJson()).toList(),
  );
});

final latestMetricsProvider = FutureProvider<BodyMetric?>((ref) async {
  final repo = ref.watch(userRepositoryProvider);
  return repo.getLatestMetrics();
});

final metricsHistoryProvider =
    FutureProvider.family<List<BodyMetric>, String?>((ref, timeRange) async {
  final repo = ref.watch(userRepositoryProvider);
  return repo.getMetricsHistory(timeRange: timeRange);
});
