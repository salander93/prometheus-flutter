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
      weight: (json['weight'] as num?)?.toDouble(),
      chest: (json['chest'] as num?)?.toDouble(),
      waist: (json['waist'] as num?)?.toDouble(),
      hips: (json['hips'] as num?)?.toDouble(),
      shoulders: (json['shoulders'] as num?)?.toDouble(),
      neck: (json['neck'] as num?)?.toDouble(),
      bicepsLeft: (json['biceps_left'] as num?)?.toDouble(),
      bicepsRight: (json['biceps_right'] as num?)?.toDouble(),
      thighLeft: (json['thigh_left'] as num?)?.toDouble(),
      thighRight: (json['thigh_right'] as num?)?.toDouble(),
      calfLeft: (json['calf_left'] as num?)?.toDouble(),
      calfRight: (json['calf_right'] as num?)?.toDouble(),
      forearmLeft: (json['forearm_left'] as num?)?.toDouble(),
      forearmRight: (json['forearm_right'] as num?)?.toDouble(),
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
