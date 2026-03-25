import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required int id,
    required String title,
    required String message,
    @JsonKey(name: 'notification_type')
    required String notificationType,
    @JsonKey(name: 'is_read') required bool isRead,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'action_url') String? actionUrl,
    @JsonKey(name: 'related_user_name') String? relatedUserName,
    @JsonKey(name: 'related_user_photo') String? relatedUserPhoto,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

@freezed
class UnreadCountResponse with _$UnreadCountResponse {
  const factory UnreadCountResponse({
    required int count,
  }) = _UnreadCountResponse;

  factory UnreadCountResponse.fromJson(Map<String, dynamic> json) =>
      _$UnreadCountResponseFromJson(json);
}
