import 'dart:convert';

import 'package:hive_ce/hive_ce.dart';

/// Persistent storage for workout sets that have not yet been synced to the
/// server (e.g. because the device was offline when the user completed them).
class PendingSetsStorage {
  static const _boxName = 'pending_sets';

  Future<Box<String>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return Hive.openBox<String>(_boxName);
    }
    return Hive.box<String>(_boxName);
  }

  /// Persists [set] with a unique key derived from its ids and current time.
  Future<void> addPendingSet(PendingSetData set) async {
    final box = await _getBox();
    final now = DateTime.now().millisecondsSinceEpoch;
    final key = '${set.exerciseExecutionId}_${set.setNumber}_$now';
    await box.put(key, jsonEncode(set.toJson()));
  }

  /// Returns all pending sets ordered by insertion key (FIFO-ish).
  Future<List<MapEntry<String, PendingSetData>>> getPendingSets() async {
    final box = await _getBox();
    final entries = <MapEntry<String, PendingSetData>>[];
    for (final key in box.keys) {
      final raw = box.get(key as String);
      if (raw != null) {
        final json = jsonDecode(raw) as Map<String, dynamic>;
        entries.add(MapEntry(key, PendingSetData.fromJson(json)));
      }
    }
    return entries;
  }

  /// Deletes the entry identified by [key].
  Future<void> removePendingSet(String key) async {
    final box = await _getBox();
    await box.delete(key);
  }

  /// Returns the number of pending sets waiting to be synced.
  Future<int> pendingCount() async {
    final box = await _getBox();
    return box.length;
  }
}

/// Plain data class representing a set that has not been synced yet.
///
/// Deliberately not freezed — simpler for manual JSON serialisation which is
/// needed here because Hive stores raw strings.
class PendingSetData {
  PendingSetData({
    required this.executionId,
    required this.exerciseExecutionId,
    required this.setNumber,
    required this.timestamp,
    this.actualReps,
    this.actualWeight,
  });

  factory PendingSetData.fromJson(Map<String, dynamic> json) {
    return PendingSetData(
      executionId: json['execution_id'] as int,
      exerciseExecutionId: json['exercise_execution_id'] as int,
      setNumber: json['set_number'] as int,
      actualReps: json['actual_reps'] as int?,
      actualWeight: (json['actual_weight'] as num?)?.toDouble(),
      timestamp: json['timestamp'] as int,
    );
  }

  /// The parent workout execution id (needed for the API call).
  final int executionId;
  final int exerciseExecutionId;
  final int setNumber;
  final int? actualReps;
  final double? actualWeight;

  /// Unix milliseconds at the time the set was completed locally.
  final int timestamp;

  Map<String, dynamic> toJson() => {
        'execution_id': executionId,
        'exercise_execution_id': exerciseExecutionId,
        'set_number': setNumber,
        'actual_reps': actualReps,
        'actual_weight': actualWeight,
        'timestamp': timestamp,
      };
}
