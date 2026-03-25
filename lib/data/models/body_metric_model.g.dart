// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_metric_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BodyMetricImpl _$$BodyMetricImplFromJson(Map<String, dynamic> json) =>
    _$BodyMetricImpl(
      id: (json['id'] as num).toInt(),
      recordedAt: json['recorded_at'] as String,
      createdAt: json['created_at'] as String,
      weight: _doubleFromJson(json['weight']),
      chest: _doubleFromJson(json['chest']),
      waist: _doubleFromJson(json['waist']),
      hips: _doubleFromJson(json['hips']),
      shoulders: _doubleFromJson(json['shoulders']),
      neck: _doubleFromJson(json['neck']),
      bicepsLeft: _doubleFromJson(json['biceps_left']),
      bicepsRight: _doubleFromJson(json['biceps_right']),
      thighLeft: _doubleFromJson(json['thigh_left']),
      thighRight: _doubleFromJson(json['thigh_right']),
      calfLeft: _doubleFromJson(json['calf_left']),
      calfRight: _doubleFromJson(json['calf_right']),
      forearmLeft: _doubleFromJson(json['forearm_left']),
      forearmRight: _doubleFromJson(json['forearm_right']),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$BodyMetricImplToJson(_$BodyMetricImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recorded_at': instance.recordedAt,
      'created_at': instance.createdAt,
      'weight': instance.weight,
      'chest': instance.chest,
      'waist': instance.waist,
      'hips': instance.hips,
      'shoulders': instance.shoulders,
      'neck': instance.neck,
      'biceps_left': instance.bicepsLeft,
      'biceps_right': instance.bicepsRight,
      'thigh_left': instance.thighLeft,
      'thigh_right': instance.thighRight,
      'calf_left': instance.calfLeft,
      'calf_right': instance.calfRight,
      'forearm_left': instance.forearmLeft,
      'forearm_right': instance.forearmRight,
      'notes': instance.notes,
    };
