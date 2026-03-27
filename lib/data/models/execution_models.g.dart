// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'execution_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutExecutionDetailImpl _$$WorkoutExecutionDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkoutExecutionDetailImpl(
      id: (json['id'] as num).toInt(),
      workoutPlan: (json['workout_plan'] as num).toInt(),
      session: (json['session'] as num).toInt(),
      weekNumber: (json['week_number'] as num).toInt(),
      startedAt: json['started_at'] as String,
      planName: json['plan_name'] as String?,
      sessionName: json['session_name'] as String?,
      completedAt: json['completed_at'] as String?,
      executionTime: (json['execution_time'] as num?)?.toInt(),
      feeling: (json['feeling'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      exerciseExecutions: (json['exercise_executions'] as List<dynamic>?)
              ?.map(
                  (e) => ExerciseExecution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$WorkoutExecutionDetailImplToJson(
        _$WorkoutExecutionDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workout_plan': instance.workoutPlan,
      'session': instance.session,
      'week_number': instance.weekNumber,
      'started_at': instance.startedAt,
      'plan_name': instance.planName,
      'session_name': instance.sessionName,
      'completed_at': instance.completedAt,
      'execution_time': instance.executionTime,
      'feeling': instance.feeling,
      'notes': instance.notes,
      'exercise_executions': instance.exerciseExecutions,
    };

_$ExerciseExecutionImpl _$$ExerciseExecutionImplFromJson(
        Map<String, dynamic> json) =>
    _$ExerciseExecutionImpl(
      id: (json['id'] as num).toInt(),
      planExercise: (json['workout_plan_exercise'] as num).toInt(),
      exerciseName: json['exercise_name'] as String?,
      order: (json['order'] as num).toInt(),
      exerciseImage: json['exercise_image'] as String?,
      restTime: json['rest_time'] as String?,
      targetSets: (json['target_sets'] as num?)?.toInt(),
      targetReps: json['target_reps'] as String?,
      notes: json['notes'] as String?,
      sets: (json['sets'] as List<dynamic>?)
              ?.map((e) => ExerciseSet.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ExerciseExecutionImplToJson(
        _$ExerciseExecutionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workout_plan_exercise': instance.planExercise,
      'exercise_name': instance.exerciseName,
      'order': instance.order,
      'exercise_image': instance.exerciseImage,
      'rest_time': instance.restTime,
      'target_sets': instance.targetSets,
      'target_reps': instance.targetReps,
      'notes': instance.notes,
      'sets': instance.sets,
    };

_$ExerciseSetImpl _$$ExerciseSetImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseSetImpl(
      id: (json['id'] as num).toInt(),
      setNumber: (json['set_number'] as num).toInt(),
      targetReps: _intFromJson(json['target_reps']),
      actualReps: _intFromJson(json['actual_reps']),
      targetWeight: _doubleFromJson(json['target_weight']),
      actualWeight: _doubleFromJson(json['actual_weight']),
      restDuration: (json['rest_duration'] as num?)?.toInt(),
      completedAt: json['completed_at'] as String?,
    );

Map<String, dynamic> _$$ExerciseSetImplToJson(_$ExerciseSetImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'set_number': instance.setNumber,
      'target_reps': instance.targetReps,
      'actual_reps': instance.actualReps,
      'target_weight': instance.targetWeight,
      'actual_weight': instance.actualWeight,
      'rest_duration': instance.restDuration,
      'completed_at': instance.completedAt,
    };

_$SessionSuggestionResponseImpl _$$SessionSuggestionResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$SessionSuggestionResponseImpl(
      workoutPlan: SuggestionPlanInfo.fromJson(
          json['workout_plan'] as Map<String, dynamic>),
      suggestedSession: SuggestionSessionInfo.fromJson(
          json['suggested_session'] as Map<String, dynamic>),
      suggestedWeek: (json['suggested_week'] as num).toInt(),
      allSessions: (json['all_sessions'] as List<dynamic>?)
              ?.map((e) =>
                  SuggestionSessionInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SessionSuggestionResponseImplToJson(
        _$SessionSuggestionResponseImpl instance) =>
    <String, dynamic>{
      'workout_plan': instance.workoutPlan,
      'suggested_session': instance.suggestedSession,
      'suggested_week': instance.suggestedWeek,
      'all_sessions': instance.allSessions,
    };

_$SuggestionPlanInfoImpl _$$SuggestionPlanInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$SuggestionPlanInfoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      durationWeeks: (json['duration_weeks'] as num).toInt(),
    );

Map<String, dynamic> _$$SuggestionPlanInfoImplToJson(
        _$SuggestionPlanInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'duration_weeks': instance.durationWeeks,
    };

_$SuggestionSessionInfoImpl _$$SuggestionSessionInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$SuggestionSessionInfoImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$SuggestionSessionInfoImplToJson(
        _$SuggestionSessionInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };
