import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/presentation/workouts/services/haptic_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HapticService', () {
    late HapticService service;
    setUp(() { service = HapticService(); });

    test('setCompleted does not throw', () {
      expect(() => service.setCompleted(), returnsNormally);
    });
    test('exerciseCompleted does not throw', () {
      expect(() => service.exerciseCompleted(), returnsNormally);
    });
    test('workoutCompleted does not throw', () {
      expect(() => service.workoutCompleted(), returnsNormally);
    });
    test('timerTick does not throw', () {
      expect(() => service.timerTick(), returnsNormally);
    });
    test('disabled service is noop', () {
      service.enabled = false;
      expect(() => service.setCompleted(), returnsNormally);
    });
  });
}
