import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/presentation/workouts/providers/rest_timer_provider.dart';

void main() {
  group('RestTimerState', () {
    test('idle state', () {
      const state = RestTimerState.idle();
      expect(state.status, RestTimerStatus.idle);
      expect(state.isActive, false);
    });
    test('counting state', () {
      const state = RestTimerState(status: RestTimerStatus.counting, remaining: 60, total: 90, exerciseExecId: 1);
      expect(state.isActive, true);
      expect(state.progressFraction, closeTo(0.333, 0.01));
    });
    test('urgent at 5 seconds', () {
      const state = RestTimerState(status: RestTimerStatus.urgent, remaining: 3, total: 90, exerciseExecId: 1);
      expect(state.status, RestTimerStatus.urgent);
    });
    test('overtime counts up', () {
      const state = RestTimerState(status: RestTimerStatus.overtime, remaining: -12, total: 90, exerciseExecId: 1);
      expect(state.overtimeSeconds, 12);
    });
    test('formatted time', () {
      const state = RestTimerState(status: RestTimerStatus.counting, remaining: 95, total: 120, exerciseExecId: 1);
      expect(state.formattedTime, '1:35');
    });
    test('formatted overtime time', () {
      const state = RestTimerState(status: RestTimerStatus.overtime, remaining: -12, total: 90, exerciseExecId: 1);
      expect(state.formattedTime, '+0:12');
    });
  });

  group('RestTimerNotifier', () {
    late RestTimerNotifier notifier;
    setUp(() { notifier = RestTimerNotifier(); });
    tearDown(() { notifier.dispose(); });

    test('start sets counting state', () {
      notifier.start(totalSeconds: 90, exerciseExecId: 1);
      expect(notifier.state.status, RestTimerStatus.counting);
      expect(notifier.state.remaining, 90);
      expect(notifier.state.total, 90);
    });
    test('skip resets to idle', () {
      notifier.start(totalSeconds: 90, exerciseExecId: 1);
      notifier.skip();
      expect(notifier.state.status, RestTimerStatus.idle);
    });
    test('reset returns to idle', () {
      notifier.start(totalSeconds: 90, exerciseExecId: 1);
      notifier.reset();
      expect(notifier.state.status, RestTimerStatus.idle);
    });
  });
}
