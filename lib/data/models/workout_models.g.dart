// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutPlanSummaryImpl _$$WorkoutPlanSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkoutPlanSummaryImpl(
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
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$WorkoutPlanSummaryImplToJson(
        _$WorkoutPlanSummaryImpl instance) =>
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
      'description': instance.description,
    };

_$WorkoutExecutionImpl _$$WorkoutExecutionImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkoutExecutionImpl(
      id: (json['id'] as num).toInt(),
      sessionName: json['session_name'] as String?,
      planName: json['plan_name'] as String?,
      weekNumber: (json['week_number'] as num?)?.toInt(),
      startedAt: json['started_at'] as String?,
      completedAt: json['completed_at'] as String?,
    );

Map<String, dynamic> _$$WorkoutExecutionImplToJson(
        _$WorkoutExecutionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_name': instance.sessionName,
      'plan_name': instance.planName,
      'week_number': instance.weekNumber,
      'started_at': instance.startedAt,
      'completed_at': instance.completedAt,
    };

_$CalendarDataImpl _$$CalendarDataImplFromJson(Map<String, dynamic> json) =>
    _$CalendarDataImpl(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      trainingDays: (json['training_days'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as List<dynamic>),
          ) ??
          const <String, List<dynamic>>{},
    );

Map<String, dynamic> _$$CalendarDataImplToJson(_$CalendarDataImpl instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'training_days': instance.trainingDays,
    };

_$ActivityLogSummaryImpl _$$ActivityLogSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$ActivityLogSummaryImpl(
      id: (json['id'] as num).toInt(),
      clientName: json['client_name'] as String,
      date: json['date'] as String,
      createdAt: json['created_at'] as String,
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      feelingDisplay: json['feeling_display'] as String?,
    );

Map<String, dynamic> _$$ActivityLogSummaryImplToJson(
        _$ActivityLogSummaryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'client_name': instance.clientName,
      'date': instance.date,
      'created_at': instance.createdAt,
      'duration_minutes': instance.durationMinutes,
      'feeling_display': instance.feelingDisplay,
    };
