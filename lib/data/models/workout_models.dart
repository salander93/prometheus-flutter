import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_models.freezed.dart';
part 'workout_models.g.dart';

@freezed
class WorkoutPlanSummary with _$WorkoutPlanSummary {
  const factory WorkoutPlanSummary({
    required int id,
    required String name,
    required int trainer,
    @JsonKey(name: 'trainer_name') required String trainerName,
    required int client,
    @JsonKey(name: 'client_name') required String clientName,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'duration_weeks') required int durationWeeks,
    @JsonKey(name: 'current_week') required int currentWeek,
    @JsonKey(name: 'created_at') required String createdAt,
    String? description,
  }) = _WorkoutPlanSummary;

  factory WorkoutPlanSummary.fromJson(Map<String, dynamic> json) =>
      _$WorkoutPlanSummaryFromJson(json);
}

@freezed
class WorkoutExecution with _$WorkoutExecution {
  const factory WorkoutExecution({
    required int id,
    @JsonKey(name: 'session_name') String? sessionName,
    @JsonKey(name: 'plan_name') String? planName,
    @JsonKey(name: 'week_number') int? weekNumber,
    @JsonKey(name: 'started_at') String? startedAt,
    @JsonKey(name: 'completed_at') String? completedAt,
  }) = _WorkoutExecution;

  factory WorkoutExecution.fromJson(Map<String, dynamic> json) =>
      _$WorkoutExecutionFromJson(json);
}

/// Represents the training calendar for a given month.
///
/// The backend returns:
/// `{"year": N, "month": N, "training_days": {"YYYY-MM-DD": [...]}}`
@freezed
class CalendarData with _$CalendarData {
  const factory CalendarData({
    required int year,
    required int month,
    @JsonKey(name: 'training_days')
    @Default(<String, List<dynamic>>{})
    Map<String, List<dynamic>> trainingDays,
  }) = _CalendarData;

  factory CalendarData.fromJson(Map<String, dynamic> json) =>
      _$CalendarDataFromJson(json);
}

@freezed
class ActivityLogSummary with _$ActivityLogSummary {
  const factory ActivityLogSummary({
    required int id,
    @JsonKey(name: 'client_name') required String clientName,
    required String date,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    @JsonKey(name: 'feeling_display') String? feelingDisplay,
  }) = _ActivityLogSummary;

  factory ActivityLogSummary.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogSummaryFromJson(json);
}
