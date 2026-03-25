// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_plan_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutPlanDetailImpl _$$WorkoutPlanDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkoutPlanDetailImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      trainer: (json['trainer'] as num).toInt(),
      trainerName: json['trainer_name'] as String,
      client: (json['client'] as num).toInt(),
      clientName: json['client_name'] as String,
      isActive: json['is_active'] as bool,
      durationWeeks: (json['duration_weeks'] as num).toInt(),
      currentWeek: (json['current_week'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      description: json['description'] as String?,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      notes: json['notes'] as String?,
      sessions: (json['sessions'] as List<dynamic>?)
              ?.map((e) => WorkoutSession.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$WorkoutPlanDetailImplToJson(
        _$WorkoutPlanDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'trainer': instance.trainer,
      'trainer_name': instance.trainerName,
      'client': instance.client,
      'client_name': instance.clientName,
      'is_active': instance.isActive,
      'duration_weeks': instance.durationWeeks,
      'current_week': instance.currentWeek,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'description': instance.description,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'notes': instance.notes,
      'sessions': instance.sessions,
    };

_$WorkoutSessionImpl _$$WorkoutSessionImplFromJson(Map<String, dynamic> json) =>
    _$WorkoutSessionImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      order: (json['order'] as num).toInt(),
      description: json['description'] as String?,
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map((e) => SessionExercise.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$WorkoutSessionImplToJson(
        _$WorkoutSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'order': instance.order,
      'description': instance.description,
      'exercises': instance.exercises,
    };

_$SessionExerciseImpl _$$SessionExerciseImplFromJson(
        Map<String, dynamic> json) =>
    _$SessionExerciseImpl(
      id: (json['id'] as num).toInt(),
      exercise: (json['exercise'] as num).toInt(),
      exerciseName: json['exercise_name'] as String,
      order: (json['order'] as num).toInt(),
      sets: (json['sets'] as num).toInt(),
      reps: json['reps'] as String,
      restTime: json['rest_time'] as String,
      exerciseDescription: json['exercise_description'] as String?,
      exerciseImage: json['exercise_image'] as String?,
      exerciseVideoUrl: json['exercise_video_url'] as String?,
      exerciseMuscleGroup: json['exercise_muscle_group'] as String?,
      exerciseMuscleGroupDisplay:
          json['exercise_muscle_group_display'] as String?,
      weightKg: _doubleFromJson(json['weight_kg']),
      notes: json['notes'] as String? ?? '',
      isPyramid: json['is_pyramid'] as bool? ?? false,
      setDetails: json['set_details'] as Map<String, dynamic>?,
      weeklyProgressions: (json['weekly_progressions'] as List<dynamic>?)
              ?.map(
                  (e) => WeeklyProgression.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SessionExerciseImplToJson(
        _$SessionExerciseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'exercise': instance.exercise,
      'exercise_name': instance.exerciseName,
      'order': instance.order,
      'sets': instance.sets,
      'reps': instance.reps,
      'rest_time': instance.restTime,
      'exercise_description': instance.exerciseDescription,
      'exercise_image': instance.exerciseImage,
      'exercise_video_url': instance.exerciseVideoUrl,
      'exercise_muscle_group': instance.exerciseMuscleGroup,
      'exercise_muscle_group_display': instance.exerciseMuscleGroupDisplay,
      'weight_kg': instance.weightKg,
      'notes': instance.notes,
      'is_pyramid': instance.isPyramid,
      'set_details': instance.setDetails,
      'weekly_progressions': instance.weeklyProgressions,
    };

_$WeeklyProgressionImpl _$$WeeklyProgressionImplFromJson(
        Map<String, dynamic> json) =>
    _$WeeklyProgressionImpl(
      id: (json['id'] as num).toInt(),
      weekNumber: (json['week_number'] as num).toInt(),
      sets: (json['sets'] as num).toInt(),
      reps: json['reps'] as String,
      restTime: json['rest_time'] as String,
      weightKg: _doubleFromJson(json['weight_kg']),
      notes: json['notes'] as String? ?? '',
    );

Map<String, dynamic> _$$WeeklyProgressionImplToJson(
        _$WeeklyProgressionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'week_number': instance.weekNumber,
      'sets': instance.sets,
      'reps': instance.reps,
      'rest_time': instance.restTime,
      'weight_kg': instance.weightKg,
      'notes': instance.notes,
    };
