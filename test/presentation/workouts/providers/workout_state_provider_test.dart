// test/presentation/workouts/providers/workout_state_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/presentation/workouts/providers/workout_state_provider.dart';
import 'package:palestra/data/models/execution_models.dart';

void main() {
  group('WorkoutState', () {
    test('initial state has zero progress', () {
      final state = WorkoutState(exercises: [], completedKeys: {}, currentPage: 0);
      expect(state.totalSets, 0);
      expect(state.completedSetCount, 0);
      expect(state.progress, 0.0);
    });

    test('progress is calculated correctly', () {
      final state = WorkoutState(exercises: [], completedKeys: {'1:1', '1:2'}, currentPage: 0, totalSetCount: 4);
      expect(state.completedSetCount, 2);
      expect(state.progress, 0.5);
    });

    test('isExerciseComplete returns true when all sets done', () {
      final state = WorkoutState(exercises: [], completedKeys: {'100:1', '100:2', '100:3'}, currentPage: 0);
      expect(state.isExerciseComplete(100, 3), true);
      expect(state.isExerciseComplete(100, 4), false);
    });
  });

  group('WorkoutStateNotifier', () {
    test('markSetCompleted adds key', () {
      final notifier = WorkoutStateNotifier();
      notifier.initialize(exercises: [], totalSets: 10);
      notifier.markSetCompleted(exerciseExecId: 1, setNumber: 1);
      expect(notifier.state.completedKeys.contains('1:1'), true);
    });

    test('revertSetCompleted removes key', () {
      final notifier = WorkoutStateNotifier();
      notifier.initialize(exercises: [], totalSets: 10);
      notifier.markSetCompleted(exerciseExecId: 1, setNumber: 1);
      notifier.revertSetCompleted(exerciseExecId: 1, setNumber: 1);
      expect(notifier.state.completedKeys.contains('1:1'), false);
    });

    test('setCurrentPage updates page', () {
      final notifier = WorkoutStateNotifier();
      notifier.initialize(exercises: [], totalSets: 10);
      notifier.setCurrentPage(2);
      expect(notifier.state.currentPage, 2);
    });
  });
}
