import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/presentation/workouts/providers/flame_progress_provider.dart';

void main() {
  group('FlameProgressState', () {
    test('zero progress state', () {
      const state = FlameProgressState(progress: 0.0);
      expect(state.scale, closeTo(0.15, 0.01));
      expect(state.opacity, closeTo(0.2, 0.01));
      expect(state.isComplete, false);
    });
    test('50% progress state', () {
      const state = FlameProgressState(progress: 0.5);
      expect(state.scale, closeTo(0.55, 0.05));
      expect(state.opacity, closeTo(0.65, 0.05));
      expect(state.glow, closeTo(0.5, 0.05));
    });
    test('100% progress state', () {
      const state = FlameProgressState(progress: 1.0);
      expect(state.scale, closeTo(1.0, 0.01));
      expect(state.opacity, closeTo(1.0, 0.01));
      expect(state.glow, closeTo(0.9, 0.01));
      expect(state.isComplete, true);
    });
    test('progress clamped to 0-1', () {
      const state = FlameProgressState(progress: 1.5);
      expect(state.scale, closeTo(1.0, 0.01));
    });
  });

  group('FlameProgressNotifier', () {
    test('update sets progress', () {
      final notifier = FlameProgressNotifier();
      notifier.update(completedSets: 5, totalSets: 10);
      expect(notifier.state.progress, 0.5);
    });
    test('zero total sets gives zero progress', () {
      final notifier = FlameProgressNotifier();
      notifier.update(completedSets: 0, totalSets: 0);
      expect(notifier.state.progress, 0.0);
    });
  });
}
