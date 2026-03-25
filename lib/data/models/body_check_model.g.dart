// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_check_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BodyCheckModelImpl _$$BodyCheckModelImplFromJson(Map<String, dynamic> json) =>
    _$BodyCheckModelImpl(
      id: (json['id'] as num).toInt(),
      client: (json['client'] as num).toInt(),
      clientName: json['client_name'] as String,
      date: json['date'] as String,
      title: json['title'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
      clientPhoto: json['client_photo'] as String?,
      notes: json['notes'] as String?,
      weightKg: _doubleFromJson(json['weight_kg']),
      bodyFatPercent: _doubleFromJson(json['body_fat_percent']),
      isViewedByTrainer: json['is_viewed_by_trainer'] as bool? ?? false,
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => BodyCheckPhoto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => BodyCheckComment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      shares: (json['shares'] as List<dynamic>?)
              ?.map((e) => BodyCheckShare.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      photoCount: (json['photo_count'] as num?)?.toInt() ?? 0,
      commentCount: (json['comment_count'] as num?)?.toInt() ?? 0,
      isOwner: json['is_owner'] as bool? ?? false,
    );

Map<String, dynamic> _$$BodyCheckModelImplToJson(
        _$BodyCheckModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'client': instance.client,
      'client_name': instance.clientName,
      'date': instance.date,
      'title': instance.title,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'client_photo': instance.clientPhoto,
      'notes': instance.notes,
      'weight_kg': instance.weightKg,
      'body_fat_percent': instance.bodyFatPercent,
      'is_viewed_by_trainer': instance.isViewedByTrainer,
      'photos': instance.photos,
      'comments': instance.comments,
      'shares': instance.shares,
      'photo_count': instance.photoCount,
      'comment_count': instance.commentCount,
      'is_owner': instance.isOwner,
    };

_$BodyCheckPhotoImpl _$$BodyCheckPhotoImplFromJson(Map<String, dynamic> json) =>
    _$BodyCheckPhotoImpl(
      id: (json['id'] as num).toInt(),
      photo: json['photo'] as String,
      position: json['position'] as String,
      positionDisplay: json['position_display'] as String,
      order: (json['order'] as num).toInt(),
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$$BodyCheckPhotoImplToJson(
        _$BodyCheckPhotoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'photo': instance.photo,
      'position': instance.position,
      'position_display': instance.positionDisplay,
      'order': instance.order,
      'created_at': instance.createdAt,
    };

_$BodyCheckCommentImpl _$$BodyCheckCommentImplFromJson(
        Map<String, dynamic> json) =>
    _$BodyCheckCommentImpl(
      id: (json['id'] as num).toInt(),
      author: (json['author'] as num).toInt(),
      authorName: json['author_name'] as String,
      authorRole: json['author_role'] as String,
      message: json['message'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      authorPhoto: json['author_photo'] as String?,
      isOwn: json['is_own'] as bool? ?? false,
    );

Map<String, dynamic> _$$BodyCheckCommentImplToJson(
        _$BodyCheckCommentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'author_name': instance.authorName,
      'author_role': instance.authorRole,
      'message': instance.message,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'author_photo': instance.authorPhoto,
      'is_own': instance.isOwn,
    };

_$BodyCheckShareImpl _$$BodyCheckShareImplFromJson(Map<String, dynamic> json) =>
    _$BodyCheckShareImpl(
      id: (json['id'] as num).toInt(),
      trainer: (json['trainer'] as num).toInt(),
      trainerName: json['trainer_name'] as String,
      sharedAt: json['shared_at'] as String,
      trainerPhoto: json['trainer_photo'] as String?,
      isViewed: json['is_viewed'] as bool? ?? false,
    );

Map<String, dynamic> _$$BodyCheckShareImplToJson(
        _$BodyCheckShareImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trainer': instance.trainer,
      'trainer_name': instance.trainerName,
      'shared_at': instance.sharedAt,
      'trainer_photo': instance.trainerPhoto,
      'is_viewed': instance.isViewed,
    };
