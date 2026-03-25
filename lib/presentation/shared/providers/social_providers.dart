import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palestra/data/datasources/remote/social_remote_datasource.dart';
import 'package:palestra/data/models/connection_models.dart';
import 'package:palestra/data/repositories/social_repository_impl.dart';
import 'package:palestra/domain/repositories/social_repository.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';

final socialRemoteDatasourceProvider =
    Provider<SocialRemoteDatasource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SocialRemoteDatasource(dio: apiClient.dio);
});

final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  return SocialRepositoryImpl(
    remoteDatasource: ref.watch(socialRemoteDatasourceProvider),
  );
});

// ── Trainer search ───────────────────────────────────────────────────────────

final trainerSearchQueryProvider = StateProvider<String>((ref) => '');

final trainerSearchResultsProvider = FutureProvider.autoDispose
    .family<List<TrainerSearchResult>, String>(
  (ref, query) async {
    final repo = ref.watch(socialRepositoryProvider);
    if (query.isEmpty) return [];
    return repo.searchTrainers(query: query);
  },
);

final trainerByCodeProvider = FutureProvider.autoDispose
    .family<List<TrainerSearchResult>, String>(
  (ref, code) async {
    if (code.isEmpty) return [];
    final repo = ref.watch(socialRepositoryProvider);
    return repo.searchTrainers(code: code);
  },
);

// ── Connection requests ──────────────────────────────────────────────────────

final connectionRequestsProvider =
    FutureProvider<List<ConnectionRequest>>((ref) async {
  final repo = ref.watch(socialRepositoryProvider);
  return repo.getConnectionRequests();
});

// ── Plan requests ────────────────────────────────────────────────────────────

final planRequestsProvider =
    FutureProvider<List<PlanRequest>>((ref) async {
  final repo = ref.watch(socialRepositoryProvider);
  return repo.getPlanRequests();
});
