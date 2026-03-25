import 'package:freezed_annotation/freezed_annotation.dart';

part 'execution_models.freezed.dart';
part 'execution_models.g.dart';

@freezed
class WorkoutExecutionDetail with _$WorkoutExecutionDetail {
  const factory WorkoutExecutionDetail({
    required int id,
    @JsonKey(name: 'workout_plan') required int workoutPlan,
    @JsonKey(name: 'session') required int session,
    @JsonKey(name: 'week_number') required int weekNumber,
    @JsonKey(name: 'started_at') required String startedAt,
    @JsonKey(name: 'plan_name') String? planName,
    @JsonKey(name: 'session_name') String? sessionName,
    @JsonKey(name: 'completed_at') String? completedAt,
    @JsonKey(name: 'execution_time') int? executionTime,
    int? feeling,
    String? notes,
    @JsonKey(name: 'exercise_executions')
    @Default([])
    List<ExerciseExecution> exerciseExecutions,
  }) = _WorkoutExecutionDetail;

  factory WorkoutExecutionDetail.fromJson(
    Map<String, dynamic> json,
  ) => _$WorkoutExecutionDetailFromJson(json);
}

@freezed
class ExerciseExecution with _$ExerciseExecution {
  const factory ExerciseExecution({
    required int id,
    @JsonKey(name: 'workout_plan_exercise') required int planExercise,
    @JsonKey(name: 'exercise_name') String? exerciseName,
    required int order,
    @JsonKey(name: 'exercise_image') String? exerciseImage,
    String? notes,
    @Default([]) List<ExerciseSet> sets,
  }) = _ExerciseExecution;

  factory ExerciseExecution.fromJson(Map<String, dynamic> json) =>
      _$ExerciseExecutionFromJson(json);
}

@freezed
class ExerciseSet with _$ExerciseSet {
  const factory ExerciseSet({
    required int id,
    @JsonKey(name: 'set_number') required int setNumber,
    @JsonKey(name: 'target_reps', fromJson: _intFromJson) int? targetReps,
    @JsonKey(name: 'actual_reps', fromJson: _intFromJson) int? actualReps,
    @JsonKey(name: 'target_weight', fromJson: _doubleFromJson)
    double? targetWeight,
    @JsonKey(name: 'actual_weight', fromJson: _doubleFromJson)
    double? actualWeight,
    @JsonKey(name: 'rest_duration') int? restDuration,
    @JsonKey(name: 'completed_at') String? completedAt,
  }) = _ExerciseSet;

  factory ExerciseSet.fromJson(Map<String, dynamic> json) =>
      _$ExerciseSetFromJson(json);
}

/// Response from `GET /api/workouts/executions/suggest/?plan_id=N`.
///
/// The backend returns the full suggestion context including a workout plan
/// summary, the suggested session, and all available sessions.
@freezed
class SessionSuggestionResponse with _$SessionSuggestionResponse {
  const factory SessionSuggestionResponse({
    @JsonKey(name: 'workout_plan') required SuggestionPlanInfo workoutPlan,
    @JsonKey(name: 'suggested_session')
    required SuggestionSessionInfo suggestedSession,
    @JsonKey(name: 'suggested_week') required int suggestedWeek,
    @JsonKey(name: 'all_sessions')
    @Default([])
    List<SuggestionSessionInfo> allSessions,
  }) = _SessionSuggestionResponse;

  factory SessionSuggestionResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$SessionSuggestionResponseFromJson(json);
}

@freezed
class SuggestionPlanInfo with _$SuggestionPlanInfo {
  const factory SuggestionPlanInfo({
    required int id,
    required String name,
    @JsonKey(name: 'duration_weeks') required int durationWeeks,
  }) = _SuggestionPlanInfo;

  factory SuggestionPlanInfo.fromJson(Map<String, dynamic> json) =>
      _$SuggestionPlanInfoFromJson(json);
}

@freezed
class SuggestionSessionInfo with _$SuggestionSessionInfo {
  const factory SuggestionSessionInfo({
    int? id,
    String? name,
    String? description,
  }) = _SuggestionSessionInfo;

  factory SuggestionSessionInfo.fromJson(Map<String, dynamic> json) =>
      _$SuggestionSessionInfoFromJson(json);
}

int? _intFromJson(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  if (value is num) return value.toInt();
  return null;
}

double? _doubleFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
