// lib/presentation/workouts/providers/workout_state_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palestra/data/models/execution_models.dart';

final workoutStateProvider =
    StateNotifierProvider.autoDispose<WorkoutStateNotifier, WorkoutState>(
  (ref) => WorkoutStateNotifier(),
);

class WorkoutState {
  final List<ExerciseExecution> exercises;
  final Set<String> completedKeys;
  final int currentPage;
  final int totalSetCount;
  final bool showCompletion;

  const WorkoutState({
    required this.exercises,
    required this.completedKeys,
    required this.currentPage,
    this.totalSetCount = 0,
    this.showCompletion = false,
  });

  int get totalSets => totalSetCount;
  int get completedSetCount => completedKeys.length;
  double get progress => totalSets == 0 ? 0.0 : completedSetCount / totalSets;

  bool isSetCompleted(int exerciseExecId, int setNumber) =>
      completedKeys.contains('$exerciseExecId:$setNumber');

  bool isExerciseComplete(int exerciseExecId, int targetSets) {
    for (int i = 1; i <= targetSets; i++) {
      if (!completedKeys.contains('$exerciseExecId:$i')) return false;
    }
    return true;
  }

  WorkoutState copyWith({
    List<ExerciseExecution>? exercises,
    Set<String>? completedKeys,
    int? currentPage,
    int? totalSetCount,
    bool? showCompletion,
  }) =>
      WorkoutState(
        exercises: exercises ?? this.exercises,
        completedKeys: completedKeys ?? this.completedKeys,
        currentPage: currentPage ?? this.currentPage,
        totalSetCount: totalSetCount ?? this.totalSetCount,
        showCompletion: showCompletion ?? this.showCompletion,
      );
}

class WorkoutStateNotifier extends StateNotifier<WorkoutState> {
  WorkoutStateNotifier()
      : super(const WorkoutState(exercises: [], completedKeys: {}, currentPage: 0));

  void initialize({
    required List<ExerciseExecution> exercises,
    required int totalSets,
    Set<String>? alreadyCompleted,
  }) {
    state = WorkoutState(
      exercises: exercises,
      completedKeys: alreadyCompleted ?? {},
      currentPage: 0,
      totalSetCount: totalSets,
    );
  }

  void markSetCompleted({required int exerciseExecId, required int setNumber}) {
    final key = '$exerciseExecId:$setNumber';
    state = state.copyWith(completedKeys: {...state.completedKeys, key});
  }

  void revertSetCompleted({required int exerciseExecId, required int setNumber}) {
    final key = '$exerciseExecId:$setNumber';
    state = state.copyWith(completedKeys: state.completedKeys.where((k) => k != key).toSet());
  }

  void setCurrentPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void showCompletion() {
    state = state.copyWith(showCompletion: true);
  }
}
