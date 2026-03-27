import 'package:palestra/data/datasources/remote/workout_remote_datasource.dart';
import 'package:palestra/data/models/execution_models.dart';
import 'package:palestra/data/models/exercise_model.dart';
import 'package:palestra/data/models/workout_models.dart';
import 'package:palestra/data/models/workout_plan_detail_model.dart';
import 'package:palestra/domain/repositories/workout_repository.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  WorkoutRepositoryImpl({required WorkoutRemoteDatasource remoteDatasource})
      : _remote = remoteDatasource;

  final WorkoutRemoteDatasource _remote;

  @override
  Future<List<WorkoutPlanSummary>> getPlans() => _remote.getPlans();

  @override
  Future<WorkoutPlanDetail> getPlanDetail(int planId) =>
      _remote.getPlanDetail(planId);

  @override
  Future<WorkoutExecution?> getActiveExecution() =>
      _remote.getActiveExecution();

  @override
  Future<CalendarData> getCalendar({
    required int year,
    required int month,
  }) => _remote.getCalendar(year: year, month: month);

  @override
  Future<List<ActivityLogSummary>> getActivityLogs() =>
      _remote.getActivityLogs();

  @override
  Future<List<ExerciseModel>> getExercises({
    String? search,
    String? muscleGroup,
  }) => _remote.getExercises(search: search, muscleGroup: muscleGroup);

  @override
  Future<ExerciseModel> getExerciseDetail(int exerciseId) =>
      _remote.getExerciseDetail(exerciseId);

  @override
  Future<SessionSuggestionResponse> suggestSession(int planId) =>
      _remote.suggestSession(planId);

  @override
  Future<WorkoutExecutionDetail> startExecution({
    required int planId,
    required int sessionId,
    required int weekNumber,
  }) => _remote.startExecution(
        planId: planId,
        sessionId: sessionId,
        weekNumber: weekNumber,
      );

  @override
  Future<WorkoutExecutionDetail> getExecutionDetail(int executionId) =>
      _remote.getExecutionDetail(executionId);

  @override
  Future<WorkoutExecutionDetail> completeExecution(
    int executionId, {
    int? feeling,
    String? notes,
  }) => _remote.completeExecution(executionId, feeling: feeling, notes: notes);

  @override
  Future<ExerciseSet> logSet({
    required int executionId,
    required int exerciseExecutionId,
    required int setNumber,
    int? actualReps,
    double? actualWeight,
  }) => _remote.logSet(
        executionId: executionId,
        exerciseExecutionId: exerciseExecutionId,
        setNumber: setNumber,
        actualReps: actualReps,
        actualWeight: actualWeight,
      );

  @override
  Future<ExerciseHistory> getExerciseHistory(int exerciseId) =>
      _remote.getExerciseHistory(exerciseId);
}
