import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hapticServiceProvider = Provider<HapticService>((ref) => HapticService());

class HapticService {
  bool enabled = true;
  bool get _canVibrate => enabled && !kIsWeb;

  void setCompleted() { if (!_canVibrate) return; HapticFeedback.lightImpact(); }
  void exerciseCompleted() { if (!_canVibrate) return; HapticFeedback.mediumImpact(); }
  void workoutCompleted() { if (!_canVibrate) return; HapticFeedback.heavyImpact(); }
  void timerTick() { if (!_canVibrate) return; HapticFeedback.lightImpact(); }
  void nextExercise() { if (!_canVibrate) return; HapticFeedback.mediumImpact(); }
}
