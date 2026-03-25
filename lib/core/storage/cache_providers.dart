import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palestra/core/api/cached_api.dart';
import 'package:palestra/core/connectivity/sync_service.dart';
import 'package:palestra/core/storage/cache_service.dart';
import 'package:palestra/core/storage/pending_sets_storage.dart';
import 'package:palestra/presentation/shared/providers/workout_providers.dart';

final cacheServiceProvider = Provider<CacheService>((_) => CacheService());

final cachedApiProvider = Provider<CachedApi>((ref) {
  return CachedApi(cacheService: ref.watch(cacheServiceProvider));
});

final pendingSetsStorageProvider =
    Provider<PendingSetsStorage>((_) => PendingSetsStorage());

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    pendingSetsStorage: ref.watch(pendingSetsStorageProvider),
    workoutRepository: ref.watch(workoutRepositoryProvider),
  );
});
