import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workoutNotificationProvider = Provider<WorkoutNotificationService>(
  (ref) => WorkoutNotificationService(),
);

class WorkoutNotificationService {
  bool _isRunning = false;

  Future<void> start({
    required String planName,
    required String exerciseName,
    required int setNumber,
    required int totalSets,
    required double progress,
  }) async {
    if (kIsWeb || _isRunning) return;

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'workout_channel',
        channelName: 'Allenamento in corso',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: false,
      ),
    );

    await FlutterForegroundTask.startService(
      notificationTitle: '$planName — ${(progress * 100).round()}%',
      notificationText: '$exerciseName · Serie $setNumber/$totalSets',
    );
    _isRunning = true;
  }

  Future<void> update({
    required String planName,
    required String exerciseName,
    required int setNumber,
    required int totalSets,
    required double progress,
    String? timerText,
  }) async {
    if (kIsWeb || !_isRunning) return;

    final body = timerText != null
        ? '$exerciseName · Recupero $timerText'
        : '$exerciseName · Serie $setNumber/$totalSets';

    await FlutterForegroundTask.updateService(
      notificationTitle: '$planName — ${(progress * 100).round()}%',
      notificationText: body,
    );
  }

  Future<void> stop() async {
    if (kIsWeb || !_isRunning) return;
    await FlutterForegroundTask.stopService();
    _isRunning = false;
  }
}
