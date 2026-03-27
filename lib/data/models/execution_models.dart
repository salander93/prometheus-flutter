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
    @JsonKey(name: 'exercise_id') int? exerciseId,
    @JsonKey(name: 'exercise_name') String? exerciseName,
    required int order,
    @JsonKey(name: 'exercise_image') String? exerciseImage,
    @JsonKey(name: 'rest_time') String? restTime,
    @JsonKey(name: 'target_sets') int? targetSets,
    @JsonKey(name: 'target_reps') String? targetReps,
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

// =============================================================================
// Exercise History Models (plain classes — read-only, no Freezed needed)
// =============================================================================

class ExerciseHistory {
  ExerciseHistory({
    required this.exerciseId,
    required this.exerciseName,
    required this.totalSessions,
    this.maxWeight,
    this.maxReps,
    required this.history,
  });

  final int exerciseId;
  final String exerciseName;
  final int totalSessions;
  final double? maxWeight;
  final int? maxReps;
  final List<ExerciseHistorySession> history;

  factory ExerciseHistory.fromJson(Map<String, dynamic> json) {
    final pr = json['personal_records'] as Map<String, dynamic>?;
    return ExerciseHistory(
      exerciseId: json['exercise_id'] as int,
      exerciseName: json['exercise_name'] as String,
      totalSessions: json['total_sessions'] as int? ?? 0,
      maxWeight: (pr?['max_weight'] as num?)?.toDouble(),
      maxReps: (pr?['max_reps'] as num?)?.toInt(),
      history: (json['history'] as List<dynamic>? ?? [])
          .map((e) => ExerciseHistorySession.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ExerciseHistorySession {
  ExerciseHistorySession({
    required this.date,
    this.sessionName,
    this.planName,
    this.weekNumber,
    required this.sets,
  });

  final String date;
  final String? sessionName;
  final String? planName;
  final int? weekNumber;
  final List<ExerciseHistorySet> sets;

  factory ExerciseHistorySession.fromJson(Map<String, dynamic> json) =>
      ExerciseHistorySession(
        date: json['date'] as String? ?? '',
        sessionName: json['session_name'] as String?,
        planName: json['plan_name'] as String?,
        weekNumber: json['week_number'] as int?,
        sets: (json['sets'] as List<dynamic>? ?? [])
            .map(
              (e) => ExerciseHistorySet.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      );
}

class ExerciseHistorySet {
  ExerciseHistorySet({
    required this.setNumber,
    this.reps,
    this.weight,
    this.completed = false,
    this.notes,
  });

  final int setNumber;
  final int? reps;
  final double? weight;
  final bool completed;
  final String? notes;

  factory ExerciseHistorySet.fromJson(Map<String, dynamic> json) =>
      ExerciseHistorySet(
        setNumber: json['set_number'] as int? ?? 0,
        reps: (json['reps'] as num?)?.toInt(),
        weight: (json['weight'] as num?)?.toDouble(),
        completed: json['completed'] as bool? ?? false,
        notes: json['notes'] as String?,
      );
}

/// Parses rest time strings like "1'", "90", "1:30", "90s" into seconds.
int parseRestTimeToSeconds(String? restTime) {
  if (restTime == null || restTime.isEmpty) return 0;
  final s = restTime.trim();
  // "1'" or "2'" → minutes
  if (s.endsWith("'")) {
    final mins = int.tryParse(s.substring(0, s.length - 1));
    if (mins != null) return mins * 60;
  }
  // "1:30" → minutes:seconds
  if (s.contains(':')) {
    final parts = s.split(':');
    final mins = int.tryParse(parts[0]) ?? 0;
    final secs = int.tryParse(parts[1]) ?? 0;
    return mins * 60 + secs;
  }
  // "90" or "90s" → seconds
  final cleaned = s.replaceAll(RegExp(r'[^\d]'), '');
  return int.tryParse(cleaned) ?? 0;
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
