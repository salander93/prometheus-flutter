import 'package:palestra/core/storage/pending_sets_storage.dart';
import 'package:palestra/domain/repositories/workout_repository.dart';

/// Background service that uploads locally-queued workout sets to the server.
///
/// Call [syncPendingSets] whenever connectivity is restored.  The service is
/// re-entrant-safe: concurrent calls are silently ignored while a sync is
/// already running.
class SyncService {
  SyncService({
    required PendingSetsStorage pendingSetsStorage,
    required WorkoutRepository workoutRepository,
  })  : _storage = pendingSetsStorage,
        _repo = workoutRepository;

  final PendingSetsStorage _storage;
  final WorkoutRepository _repo;
  bool _isSyncing = false;

  /// Uploads all pending sets in chronological order.
  ///
  /// Stops on the first failure and leaves the remaining sets for the next
  /// call (retry on next reconnect).
  Future<void> syncPendingSets() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final pending = await _storage.getPendingSets();
      // Chronological order ensures server-side consistency.
      pending.sort(
        (a, b) => a.value.timestamp.compareTo(b.value.timestamp),
      );

      for (final entry in pending) {
        try {
          await _repo.logSet(
            executionId: entry.value.executionId,
            exerciseExecutionId: entry.value.exerciseExecutionId,
            setNumber: entry.value.setNumber,
            actualReps: entry.value.actualReps,
            actualWeight: entry.value.actualWeight,
          );
          await _storage.removePendingSet(entry.key);
        } catch (_) {
          // Stop on first failure — will retry on the next sync trigger.
          break;
        }
      }
    } finally {
      _isSyncing = false;
    }
  }
}
