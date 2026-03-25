import 'package:freezed_annotation/freezed_annotation.dart';

part 'body_check_model.freezed.dart';
part 'body_check_model.g.dart';

@freezed
class BodyCheckModel with _$BodyCheckModel {
  const factory BodyCheckModel({
    required int id,
    required int client,
    @JsonKey(name: 'client_name') required String clientName,
    required String date,
    required String title,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'client_photo') String? clientPhoto,
    String? notes,
    @JsonKey(name: 'weight_kg', fromJson: _doubleFromJson)
    double? weightKg,
    @JsonKey(name: 'body_fat_percent', fromJson: _doubleFromJson)
    double? bodyFatPercent,
    @JsonKey(name: 'is_viewed_by_trainer')
    @Default(false)
    bool isViewedByTrainer,
    @Default([]) List<BodyCheckPhoto> photos,
    @Default([]) List<BodyCheckComment> comments,
    @Default([]) List<BodyCheckShare> shares,
    @JsonKey(name: 'photo_count') @Default(0) int photoCount,
    @JsonKey(name: 'comment_count') @Default(0) int commentCount,
    @JsonKey(name: 'is_owner') @Default(false) bool isOwner,
  }) = _BodyCheckModel;

  factory BodyCheckModel.fromJson(Map<String, dynamic> json) =>
      _$BodyCheckModelFromJson(json);
}

@freezed
class BodyCheckPhoto with _$BodyCheckPhoto {
  const factory BodyCheckPhoto({
    required int id,
    required String photo,
    required String position,
    @JsonKey(name: 'position_display') required String positionDisplay,
    required int order,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _BodyCheckPhoto;

  factory BodyCheckPhoto.fromJson(Map<String, dynamic> json) =>
      _$BodyCheckPhotoFromJson(json);
}

@freezed
class BodyCheckComment with _$BodyCheckComment {
  const factory BodyCheckComment({
    required int id,
    required int author,
    @JsonKey(name: 'author_name') required String authorName,
    @JsonKey(name: 'author_role') required String authorRole,
    required String message,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
    @JsonKey(name: 'author_photo') String? authorPhoto,
    @JsonKey(name: 'is_own') @Default(false) bool isOwn,
  }) = _BodyCheckComment;

  factory BodyCheckComment.fromJson(Map<String, dynamic> json) =>
      _$BodyCheckCommentFromJson(json);
}

@freezed
class BodyCheckShare with _$BodyCheckShare {
  const factory BodyCheckShare({
    required int id,
    required int trainer,
    @JsonKey(name: 'trainer_name') required String trainerName,
    @JsonKey(name: 'shared_at') required String sharedAt,
    @JsonKey(name: 'trainer_photo') String? trainerPhoto,
    @JsonKey(name: 'is_viewed') @Default(false) bool isViewed,
  }) = _BodyCheckShare;

  factory BodyCheckShare.fromJson(Map<String, dynamic> json) =>
      _$BodyCheckShareFromJson(json);
}

/// Parses a double from either a number or a string.
double? _doubleFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
