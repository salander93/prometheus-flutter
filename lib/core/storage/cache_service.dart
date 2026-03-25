import 'dart:convert';

import 'package:hive_ce/hive_ce.dart';

class CacheService {
  static const _boxName = 'api_cache';

  Future<Box<String>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return Hive.openBox<String>(_boxName);
    }
    return Hive.box<String>(_boxName);
  }

  /// Persists [data] under [key] with the current timestamp.
  Future<void> put(String key, dynamic data) async {
    final box = await _getBox();
    final entry = jsonEncode({
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    await box.put(key, entry);
  }

  /// Returns the cached [CacheEntry] for [key], or `null` if absent.
  ///
  /// Stale entries are still returned — callers decide whether to revalidate.
  Future<CacheEntry?> get(String key) async {
    final box = await _getBox();
    final raw = box.get(key);
    if (raw == null) return null;

    final map = jsonDecode(raw) as Map<String, dynamic>;
    final timestamp = map['timestamp'] as int;
    final ageMs = DateTime.now().millisecondsSinceEpoch - timestamp;

    return CacheEntry(data: map['data'], ageMs: ageMs);
  }

  /// Returns `true` when a non-expired entry exists for [key].
  Future<bool> isFresh(String key, Duration ttl) async {
    final entry = await get(key);
    if (entry == null) return false;
    return entry.isFresh(ttl);
  }

  /// Removes the entry for [key].
  Future<void> delete(String key) async {
    final box = await _getBox();
    await box.delete(key);
  }

  /// Wipes the entire cache box.
  Future<void> clearAll() async {
    final box = await _getBox();
    await box.clear();
  }
}

class CacheEntry {
  const CacheEntry({required this.data, required this.ageMs});

  final dynamic data;
  final int ageMs;

  bool isFresh(Duration ttl) => ageMs < ttl.inMilliseconds;
}
