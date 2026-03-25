// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return _NotificationModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'notification_type')
  String get notificationType => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  bool get isRead => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'action_url')
  String? get actionUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'related_user_name')
  String? get relatedUserName => throw _privateConstructorUsedError;
  @JsonKey(name: 'related_user_photo')
  String? get relatedUserPhoto => throw _privateConstructorUsedError;

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationModelCopyWith<NotificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationModelCopyWith<$Res> {
  factory $NotificationModelCopyWith(
          NotificationModel value, $Res Function(NotificationModel) then) =
      _$NotificationModelCopyWithImpl<$Res, NotificationModel>;
  @useResult
  $Res call(
      {int id,
      String title,
      String message,
      @JsonKey(name: 'notification_type') String notificationType,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'action_url') String? actionUrl,
      @JsonKey(name: 'related_user_name') String? relatedUserName,
      @JsonKey(name: 'related_user_photo') String? relatedUserPhoto});
}

/// @nodoc
class _$NotificationModelCopyWithImpl<$Res, $Val extends NotificationModel>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? message = null,
    Object? notificationType = null,
    Object? isRead = null,
    Object? createdAt = null,
    Object? actionUrl = freezed,
    Object? relatedUserName = freezed,
    Object? relatedUserPhoto = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      notificationType: null == notificationType
          ? _value.notificationType
          : notificationType // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedUserName: freezed == relatedUserName
          ? _value.relatedUserName
          : relatedUserName // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedUserPhoto: freezed == relatedUserPhoto
          ? _value.relatedUserPhoto
          : relatedUserPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationModelImplCopyWith<$Res>
    implements $NotificationModelCopyWith<$Res> {
  factory _$$NotificationModelImplCopyWith(_$NotificationModelImpl value,
          $Res Function(_$NotificationModelImpl) then) =
      __$$NotificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String message,
      @JsonKey(name: 'notification_type') String notificationType,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'action_url') String? actionUrl,
      @JsonKey(name: 'related_user_name') String? relatedUserName,
      @JsonKey(name: 'related_user_photo') String? relatedUserPhoto});
}

/// @nodoc
class __$$NotificationModelImplCopyWithImpl<$Res>
    extends _$NotificationModelCopyWithImpl<$Res, _$NotificationModelImpl>
    implements _$$NotificationModelImplCopyWith<$Res> {
  __$$NotificationModelImplCopyWithImpl(_$NotificationModelImpl _value,
      $Res Function(_$NotificationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? message = null,
    Object? notificationType = null,
    Object? isRead = null,
    Object? createdAt = null,
    Object? actionUrl = freezed,
    Object? relatedUserName = freezed,
    Object? relatedUserPhoto = freezed,
  }) {
    return _then(_$NotificationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      notificationType: null == notificationType
          ? _value.notificationType
          : notificationType // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedUserName: freezed == relatedUserName
          ? _value.relatedUserName
          : relatedUserName // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedUserPhoto: freezed == relatedUserPhoto
          ? _value.relatedUserPhoto
          : relatedUserPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationModelImpl implements _NotificationModel {
  const _$NotificationModelImpl(
      {required this.id,
      required this.title,
      required this.message,
      @JsonKey(name: 'notification_type') required this.notificationType,
      @JsonKey(name: 'is_read') required this.isRead,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'action_url') this.actionUrl,
      @JsonKey(name: 'related_user_name') this.relatedUserName,
      @JsonKey(name: 'related_user_photo') this.relatedUserPhoto});

  factory _$NotificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationModelImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String message;
  @override
  @JsonKey(name: 'notification_type')
  final String notificationType;
  @override
  @JsonKey(name: 'is_read')
  final bool isRead;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'action_url')
  final String? actionUrl;
  @override
  @JsonKey(name: 'related_user_name')
  final String? relatedUserName;
  @override
  @JsonKey(name: 'related_user_photo')
  final String? relatedUserPhoto;

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, message: $message, notificationType: $notificationType, isRead: $isRead, createdAt: $createdAt, actionUrl: $actionUrl, relatedUserName: $relatedUserName, relatedUserPhoto: $relatedUserPhoto)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.notificationType, notificationType) ||
                other.notificationType == notificationType) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.actionUrl, actionUrl) ||
                other.actionUrl == actionUrl) &&
            (identical(other.relatedUserName, relatedUserName) ||
                other.relatedUserName == relatedUserName) &&
            (identical(other.relatedUserPhoto, relatedUserPhoto) ||
                other.relatedUserPhoto == relatedUserPhoto));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      message,
      notificationType,
      isRead,
      createdAt,
      actionUrl,
      relatedUserName,
      relatedUserPhoto);

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      __$$NotificationModelImplCopyWithImpl<_$NotificationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationModel implements NotificationModel {
  const factory _NotificationModel(
      {required final int id,
      required final String title,
      required final String message,
      @JsonKey(name: 'notification_type')
      required final String notificationType,
      @JsonKey(name: 'is_read') required final bool isRead,
      @JsonKey(name: 'created_at') required final String createdAt,
      @JsonKey(name: 'action_url') final String? actionUrl,
      @JsonKey(name: 'related_user_name') final String? relatedUserName,
      @JsonKey(name: 'related_user_photo')
      final String? relatedUserPhoto}) = _$NotificationModelImpl;

  factory _NotificationModel.fromJson(Map<String, dynamic> json) =
      _$NotificationModelImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get message;
  @override
  @JsonKey(name: 'notification_type')
  String get notificationType;
  @override
  @JsonKey(name: 'is_read')
  bool get isRead;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'action_url')
  String? get actionUrl;
  @override
  @JsonKey(name: 'related_user_name')
  String? get relatedUserName;
  @override
  @JsonKey(name: 'related_user_photo')
  String? get relatedUserPhoto;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UnreadCountResponse _$UnreadCountResponseFromJson(Map<String, dynamic> json) {
  return _UnreadCountResponse.fromJson(json);
}

/// @nodoc
mixin _$UnreadCountResponse {
  int get count => throw _privateConstructorUsedError;

  /// Serializes this UnreadCountResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UnreadCountResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UnreadCountResponseCopyWith<UnreadCountResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnreadCountResponseCopyWith<$Res> {
  factory $UnreadCountResponseCopyWith(
          UnreadCountResponse value, $Res Function(UnreadCountResponse) then) =
      _$UnreadCountResponseCopyWithImpl<$Res, UnreadCountResponse>;
  @useResult
  $Res call({int count});
}

/// @nodoc
class _$UnreadCountResponseCopyWithImpl<$Res, $Val extends UnreadCountResponse>
    implements $UnreadCountResponseCopyWith<$Res> {
  _$UnreadCountResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UnreadCountResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UnreadCountResponseImplCopyWith<$Res>
    implements $UnreadCountResponseCopyWith<$Res> {
  factory _$$UnreadCountResponseImplCopyWith(_$UnreadCountResponseImpl value,
          $Res Function(_$UnreadCountResponseImpl) then) =
      __$$UnreadCountResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int count});
}

/// @nodoc
class __$$UnreadCountResponseImplCopyWithImpl<$Res>
    extends _$UnreadCountResponseCopyWithImpl<$Res, _$UnreadCountResponseImpl>
    implements _$$UnreadCountResponseImplCopyWith<$Res> {
  __$$UnreadCountResponseImplCopyWithImpl(_$UnreadCountResponseImpl _value,
      $Res Function(_$UnreadCountResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of UnreadCountResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
  }) {
    return _then(_$UnreadCountResponseImpl(
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UnreadCountResponseImpl implements _UnreadCountResponse {
  const _$UnreadCountResponseImpl({required this.count});

  factory _$UnreadCountResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnreadCountResponseImplFromJson(json);

  @override
  final int count;

  @override
  String toString() {
    return 'UnreadCountResponse(count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnreadCountResponseImpl &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, count);

  /// Create a copy of UnreadCountResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnreadCountResponseImplCopyWith<_$UnreadCountResponseImpl> get copyWith =>
      __$$UnreadCountResponseImplCopyWithImpl<_$UnreadCountResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnreadCountResponseImplToJson(
      this,
    );
  }
}

abstract class _UnreadCountResponse implements UnreadCountResponse {
  const factory _UnreadCountResponse({required final int count}) =
      _$UnreadCountResponseImpl;

  factory _UnreadCountResponse.fromJson(Map<String, dynamic> json) =
      _$UnreadCountResponseImpl.fromJson;

  @override
  int get count;

  /// Create a copy of UnreadCountResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnreadCountResponseImplCopyWith<_$UnreadCountResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
