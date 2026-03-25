import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_plan_detail_model.freezed.dart';
part 'workout_plan_detail_model.g.dart';

@freezed
class WorkoutPlanDetail with _$WorkoutPlanDetail {
  const factory WorkoutPlanDetail({
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
    @JsonKey(name: 'updated_at') required String updatedAt,
    String? description,
    @JsonKey(name: 'start_date') String? startDate,
    @JsonKey(name: 'end_date') String? endDate,
    String? notes,
    @Default([]) List<WorkoutSession> sessions,
  }) = _WorkoutPlanDetail;

  factory WorkoutPlanDetail.fromJson(Map<String, dynamic> json) =>
      _$WorkoutPlanDetailFromJson(json);
}

@freezed
class WorkoutSession with _$WorkoutSession {
  const factory WorkoutSession({
    required int id,
    required String name,
    required int order,
    String? description,
    @Default([]) List<SessionExercise> exercises,
  }) = _WorkoutSession;

  factory WorkoutSession.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSessionFromJson(json);
}

@freezed
class SessionExercise with _$SessionExercise {
  const factory SessionExercise({
    required int id,
    required int exercise,
    @JsonKey(name: 'exercise_name') required String exerciseName,
    required int order,
    required int sets,
    required String reps,
    @JsonKey(name: 'rest_time') required String restTime,
    @JsonKey(name: 'exercise_description') String? exerciseDescription,
    @JsonKey(name: 'exercise_image') String? exerciseImage,
    @JsonKey(name: 'exercise_video_url') String? exerciseVideoUrl,
    @JsonKey(name: 'exercise_muscle_group') String? exerciseMuscleGroup,
    @JsonKey(name: 'exercise_muscle_group_display')
    String? exerciseMuscleGroupDisplay,
    @JsonKey(name: 'weight_kg', fromJson: _doubleFromJson) double? weightKg,
    @Default('') String notes,
    @JsonKey(name: 'is_pyramid') @Default(false) bool isPyramid,
    @JsonKey(name: 'set_details') Map<String, dynamic>? setDetails,
    @JsonKey(name: 'weekly_progressions')
    @Default([])
    List<WeeklyProgression> weeklyProgressions,
  }) = _SessionExercise;

  factory SessionExercise.fromJson(Map<String, dynamic> json) =>
      _$SessionExerciseFromJson(json);
}

@freezed
class WeeklyProgression with _$WeeklyProgression {
  const factory WeeklyProgression({
    required int id,
    @JsonKey(name: 'week_number') required int weekNumber,
    required int sets,
    required String reps,
    @JsonKey(name: 'rest_time') required String restTime,
    @JsonKey(name: 'weight_kg', fromJson: _doubleFromJson) double? weightKg,
    @Default('') String notes,
  }) = _WeeklyProgression;

  factory WeeklyProgression.fromJson(Map<String, dynamic> json) =>
      _$WeeklyProgressionFromJson(json);
}

double? _doubleFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
