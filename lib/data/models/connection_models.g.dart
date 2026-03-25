// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrainerSearchResultImpl _$$TrainerSearchResultImplFromJson(
        Map<String, dynamic> json) =>
    _$TrainerSearchResultImpl(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      fullName: json['full_name'] as String,
      photo: json['photo'] as String?,
      bio: json['bio'] as String?,
    );

Map<String, dynamic> _$$TrainerSearchResultImplToJson(
        _$TrainerSearchResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'full_name': instance.fullName,
      'photo': instance.photo,
      'bio': instance.bio,
    };

_$ConnectionRequestImpl _$$ConnectionRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ConnectionRequestImpl(
      id: (json['id'] as num).toInt(),
      trainer: (json['trainer'] as num).toInt(),
      trainerName: json['trainer_name'] as String,
      client: (json['client'] as num).toInt(),
      clientName: json['client_name'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
      trainerPhoto: json['trainer_photo'] as String?,
      clientPhoto: json['client_photo'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$ConnectionRequestImplToJson(
        _$ConnectionRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trainer': instance.trainer,
      'trainer_name': instance.trainerName,
      'client': instance.client,
      'client_name': instance.clientName,
      'status': instance.status,
      'created_at': instance.createdAt,
      'trainer_photo': instance.trainerPhoto,
      'client_photo': instance.clientPhoto,
      'message': instance.message,
    };

_$PlanRequestImpl _$$PlanRequestImplFromJson(Map<String, dynamic> json) =>
    _$PlanRequestImpl(
      id: (json['id'] as num).toInt(),
      client: (json['client'] as num).toInt(),
      clientName: json['client_name'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
      trainer: (json['trainer'] as num?)?.toInt(),
      trainerName: json['trainer_name'] as String?,
      message: json['message'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$PlanRequestImplToJson(_$PlanRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'client': instance.client,
      'client_name': instance.clientName,
      'status': instance.status,
      'created_at': instance.createdAt,
      'trainer': instance.trainer,
      'trainer_name': instance.trainerName,
      'message': instance.message,
      'notes': instance.notes,
    };
