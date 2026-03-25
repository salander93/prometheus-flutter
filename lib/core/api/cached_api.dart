import 'package:palestra/core/storage/cache_service.dart';

class CachedApi {
  CachedApi({required CacheService cacheService}) : _cache = cacheService;

  final CacheService _cache;

  /// Fetches data using a stale-while-revalidate strategy.
  ///
  /// - If the cache is fresh, returns cached data immediately and triggers a
  ///   background refresh.
  /// - If the cache is stale or absent, calls the network. On success the
  ///   result is stored. On failure, stale cache is returned when available;
  ///   otherwise the error is rethrown.
  Future<T> fetch<T>({
    required String cacheKey,
    required Future<T> Function() apiCall,
    required T Function(dynamic json) fromCache,
    required dynamic Function(T data) toCache,
    Duration ttl = const Duration(minutes: 5),
  }) async {
    final cached = await _cache.get(cacheKey);

    if (cached != null && cached.isFresh(ttl)) {
      // Return immediately; refresh in background (fire-and-forget).
      unawaited(_refreshInBackground(cacheKey, apiCall, toCache));
      return fromCache(cached.data);
    }

    try {
      final data = await apiCall();
      await _cache.put(cacheKey, toCache(data));
      return data;
    } catch (_) {
      if (cached != null) {
        return fromCache(cached.data);
      }
      rethrow;
    }
  }

  Future<void> _refreshInBackground<T>(
    String cacheKey,
    Future<T> Function() apiCall,
    dynamic Function(T data) toCache,
  ) async {
    try {
      final data = await apiCall();
      await _cache.put(cacheKey, toCache(data));
    } catch (_) {
      // Silently ignore background refresh failures.
    }
  }
}

/// Explicitly discards a [Future] to satisfy `unawaited_futures` lint rules.
void unawaited(Future<void> future) {}
