// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relation_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrainerClientImpl _$$TrainerClientImplFromJson(Map<String, dynamic> json) =>
    _$TrainerClientImpl(
      id: (json['id'] as num).toInt(),
      trainer: (json['trainer'] as num).toInt(),
      trainerName: json['trainer_name'] as String,
      client: (json['client'] as num).toInt(),
      clientName: json['client_name'] as String,
      isActive: json['is_active'] as bool,
      createdAt: json['created_at'] as String,
      trainerPhoto: json['trainer_photo'] as String?,
      clientPhoto: json['client_photo'] as String?,
    );

Map<String, dynamic> _$$TrainerClientImplToJson(_$TrainerClientImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trainer': instance.trainer,
      'trainer_name': instance.trainerName,
      'client': instance.client,
      'client_name': instance.clientName,
      'is_active': instance.isActive,
      'created_at': instance.createdAt,
      'trainer_photo': instance.trainerPhoto,
      'client_photo': instance.clientPhoto,
    };
