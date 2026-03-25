import 'package:palestra/data/models/execution_models.dart';
import 'package:palestra/data/models/exercise_model.dart';
import 'package:palestra/data/models/workout_models.dart';
import 'package:palestra/data/models/workout_plan_detail_model.dart';

abstract class WorkoutRepository {
  Future<List<WorkoutPlanSummary>> getPlans();
  Future<WorkoutPlanDetail> getPlanDetail(int planId);
  Future<WorkoutExecution?> getActiveExecution();
  Future<CalendarData> getCalendar({
    required int year,
    required int month,
  });
  Future<List<ActivityLogSummary>> getActivityLogs();

  // Exercise library
  Future<List<ExerciseModel>> getExercises({
    String? search,
    String? muscleGroup,
  });
  Future<ExerciseModel> getExerciseDetail(int exerciseId);

  // Execution flow
  Future<SessionSuggestionResponse> suggestSession(int planId);
  Future<WorkoutExecutionDetail> startExecution({
    required int planId,
    required int sessionId,
    required int weekNumber,
  });
  Future<WorkoutExecutionDetail> getExecutionDetail(int executionId);
  Future<WorkoutExecutionDetail> completeExecution(
    int executionId, {
    int? feeling,
    String? notes,
  });
  Future<ExerciseSet> logSet({
    required int executionId,
    required int exerciseExecutionId,
    required int setNumber,
    int? actualReps,
    double? actualWeight,
  });
}
