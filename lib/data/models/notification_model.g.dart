// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationModelImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      message: json['message'] as String,
      notificationType: json['notification_type'] as String,
      isRead: json['is_read'] as bool,
      createdAt: json['created_at'] as String,
      actionUrl: json['action_url'] as String?,
      relatedUserName: json['related_user_name'] as String?,
      relatedUserPhoto: json['related_user_photo'] as String?,
    );

Map<String, dynamic> _$$NotificationModelImplToJson(
        _$NotificationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'notification_type': instance.notificationType,
      'is_read': instance.isRead,
      'created_at': instance.createdAt,
      'action_url': instance.actionUrl,
      'related_user_name': instance.relatedUserName,
      'related_user_photo': instance.relatedUserPhoto,
    };

_$UnreadCountResponseImpl _$$UnreadCountResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$UnreadCountResponseImpl(
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$UnreadCountResponseImplToJson(
        _$UnreadCountResponseImpl instance) =>
    <String, dynamic>{
      'count': instance.count,
    };
