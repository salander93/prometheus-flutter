// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TrainerSearchResult _$TrainerSearchResultFromJson(Map<String, dynamic> json) {
  return _TrainerSearchResult.fromJson(json);
}

/// @nodoc
mixin _$TrainerSearchResult {
  int get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String get fullName => throw _privateConstructorUsedError;
  String? get photo => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;

  /// Serializes this TrainerSearchResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrainerSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainerSearchResultCopyWith<TrainerSearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainerSearchResultCopyWith<$Res> {
  factory $TrainerSearchResultCopyWith(
          TrainerSearchResult value, $Res Function(TrainerSearchResult) then) =
      _$TrainerSearchResultCopyWithImpl<$Res, TrainerSearchResult>;
  @useResult
  $Res call(
      {int id,
      String username,
      @JsonKey(name: 'full_name') String fullName,
      String? photo,
      String? bio});
}

/// @nodoc
class _$TrainerSearchResultCopyWithImpl<$Res, $Val extends TrainerSearchResult>
    implements $TrainerSearchResultCopyWith<$Res> {
  _$TrainerSearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainerSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? fullName = null,
    Object? photo = freezed,
    Object? bio = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      photo: freezed == photo
          ? _value.photo
          : photo // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrainerSearchResultImplCopyWith<$Res>
    implements $TrainerSearchResultCopyWith<$Res> {
  factory _$$TrainerSearchResultImplCopyWith(_$TrainerSearchResultImpl value,
          $Res Function(_$TrainerSearchResultImpl) then) =
      __$$TrainerSearchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String username,
      @JsonKey(name: 'full_name') String fullName,
      String? photo,
      String? bio});
}

/// @nodoc
class __$$TrainerSearchResultImplCopyWithImpl<$Res>
    extends _$TrainerSearchResultCopyWithImpl<$Res, _$TrainerSearchResultImpl>
    implements _$$TrainerSearchResultImplCopyWith<$Res> {
  __$$TrainerSearchResultImplCopyWithImpl(_$TrainerSearchResultImpl _value,
      $Res Function(_$TrainerSearchResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrainerSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? fullName = null,
    Object? photo = freezed,
    Object? bio = freezed,
  }) {
    return _then(_$TrainerSearchResultImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      photo: freezed == photo
          ? _value.photo
          : photo // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrainerSearchResultImpl implements _TrainerSearchResult {
  const _$TrainerSearchResultImpl(
      {required this.id,
      required this.username,
      @JsonKey(name: 'full_name') required this.fullName,
      this.photo,
      this.bio});

  factory _$TrainerSearchResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrainerSearchResultImplFromJson(json);

  @override
  final int id;
  @override
  final String username;
  @override
  @JsonKey(name: 'full_name')
  final String fullName;
  @override
  final String? photo;
  @override
  final String? bio;

  @override
  String toString() {
    return 'TrainerSearchResult(id: $id, username: $username, fullName: $fullName, photo: $photo, bio: $bio)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainerSearchResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.photo, photo) || other.photo == photo) &&
            (identical(other.bio, bio) || other.bio == bio));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, username, fullName, photo, bio);

  /// Create a copy of TrainerSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainerSearchResultImplCopyWith<_$TrainerSearchResultImpl> get copyWith =>
      __$$TrainerSearchResultImplCopyWithImpl<_$TrainerSearchResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrainerSearchResultImplToJson(
      this,
    );
  }
}

abstract class _TrainerSearchResult implements TrainerSearchResult {
  const factory _TrainerSearchResult(
      {required final int id,
      required final String username,
      @JsonKey(name: 'full_name') required final String fullName,
      final String? photo,
      final String? bio}) = _$TrainerSearchResultImpl;

  factory _TrainerSearchResult.fromJson(Map<String, dynamic> json) =
      _$TrainerSearchResultImpl.fromJson;

  @override
  int get id;
  @override
  String get username;
  @override
  @JsonKey(name: 'full_name')
  String get fullName;
  @override
  String? get photo;
  @override
  String? get bio;

  /// Create a copy of TrainerSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainerSearchResultImplCopyWith<_$TrainerSearchResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConnectionRequest _$ConnectionRequestFromJson(Map<String, dynamic> json) {
  return _ConnectionRequest.fromJson(json);
}

/// @nodoc
mixin _$ConnectionRequest {
  int get id => throw _privateConstructorUsedError;
  int get trainer => throw _privateConstructorUsedError;
  @JsonKey(name: 'trainer_name')
  String get trainerName => throw _privateConstructorUsedError;
  int get client => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_name')
  String get clientName => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'trainer_photo')
  String? get trainerPhoto => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_photo')
  String? get clientPhoto => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this ConnectionRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConnectionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConnectionRequestCopyWith<ConnectionRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectionRequestCopyWith<$Res> {
  factory $ConnectionRequestCopyWith(
          ConnectionRequest value, $Res Function(ConnectionRequest) then) =
      _$ConnectionRequestCopyWithImpl<$Res, ConnectionRequest>;
  @useResult
  $Res call(
      {int id,
      int trainer,
      @JsonKey(name: 'trainer_name') String trainerName,
      int client,
      @JsonKey(name: 'client_name') String clientName,
      String status,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'trainer_photo') String? trainerPhoto,
      @JsonKey(name: 'client_photo') String? clientPhoto,
      String? message});
}

/// @nodoc
class _$ConnectionRequestCopyWithImpl<$Res, $Val extends ConnectionRequest>
    implements $ConnectionRequestCopyWith<$Res> {
  _$ConnectionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConnectionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trainer = null,
    Object? trainerName = null,
    Object? client = null,
    Object? clientName = null,
    Object? status = null,
    Object? createdAt = null,
    Object? trainerPhoto = freezed,
    Object? clientPhoto = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      trainer: null == trainer
          ? _value.trainer
          : trainer // ignore: cast_nullable_to_non_nullable
              as int,
      trainerName: null == trainerName
          ? _value.trainerName
          : trainerName // ignore: cast_nullable_to_non_nullable
              as String,
      client: null == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as int,
      clientName: null == clientName
          ? _value.clientName
          : clientName // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      trainerPhoto: freezed == trainerPhoto
          ? _value.trainerPhoto
          : trainerPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      clientPhoto: freezed == clientPhoto
          ? _value.clientPhoto
          : clientPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConnectionRequestImplCopyWith<$Res>
    implements $ConnectionRequestCopyWith<$Res> {
  factory _$$ConnectionRequestImplCopyWith(_$ConnectionRequestImpl value,
          $Res Function(_$ConnectionRequestImpl) then) =
      __$$ConnectionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int trainer,
      @JsonKey(name: 'trainer_name') String trainerName,
      int client,
      @JsonKey(name: 'client_name') String clientName,
      String status,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'trainer_photo') String? trainerPhoto,
      @JsonKey(name: 'client_photo') String? clientPhoto,
      String? message});
}

/// @nodoc
class __$$ConnectionRequestImplCopyWithImpl<$Res>
    extends _$ConnectionRequestCopyWithImpl<$Res, _$ConnectionRequestImpl>
    implements _$$ConnectionRequestImplCopyWith<$Res> {
  __$$ConnectionRequestImplCopyWithImpl(_$ConnectionRequestImpl _value,
      $Res Function(_$ConnectionRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConnectionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trainer = null,
    Object? trainerName = null,
    Object? client = null,
    Object? clientName = null,
    Object? status = null,
    Object? createdAt = null,
    Object? trainerPhoto = freezed,
    Object? clientPhoto = freezed,
    Object? message = freezed,
  }) {
    return _then(_$ConnectionRequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      trainer: null == trainer
          ? _value.trainer
          : trainer // ignore: cast_nullable_to_non_nullable
              as int,
      trainerName: null == trainerName
          ? _value.trainerName
          : trainerName // ignore: cast_nullable_to_non_nullable
              as String,
      client: null == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as int,
      clientName: null == clientName
          ? _value.clientName
          : clientName // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      trainerPhoto: freezed == trainerPhoto
          ? _value.trainerPhoto
          : trainerPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      clientPhoto: freezed == clientPhoto
          ? _value.clientPhoto
          : clientPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConnectionRequestImpl implements _ConnectionRequest {
  const _$ConnectionRequestImpl(
      {required this.id,
      required this.trainer,
      @JsonKey(name: 'trainer_name') required this.trainerName,
      required this.client,
      @JsonKey(name: 'client_name') required this.clientName,
      required this.status,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'trainer_photo') this.trainerPhoto,
      @JsonKey(name: 'client_photo') this.clientPhoto,
      this.message});

  factory _$ConnectionRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConnectionRequestImplFromJson(json);

  @override
  final int id;
  @override
  final int trainer;
  @override
  @JsonKey(name: 'trainer_name')
  final String trainerName;
  @override
  final int client;
  @override
  @JsonKey(name: 'client_name')
  final String clientName;
  @override
  final String status;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'trainer_photo')
  final String? trainerPhoto;
  @override
  @JsonKey(name: 'client_photo')
  final String? clientPhoto;
  @override
  final String? message;

  @override
  String toString() {
    return 'ConnectionRequest(id: $id, trainer: $trainer, trainerName: $trainerName, client: $client, clientName: $clientName, status: $status, createdAt: $createdAt, trainerPhoto: $trainerPhoto, clientPhoto: $clientPhoto, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectionRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.trainer, trainer) || other.trainer == trainer) &&
            (identical(other.trainerName, trainerName) ||
                other.trainerName == trainerName) &&
            (identical(other.client, client) || other.client == client) &&
            (identical(other.clientName, clientName) ||
                other.clientName == clientName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.trainerPhoto, trainerPhoto) ||
                other.trainerPhoto == trainerPhoto) &&
            (identical(other.clientPhoto, clientPhoto) ||
                other.clientPhoto == clientPhoto) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, trainer, trainerName, client,
      clientName, status, createdAt, trainerPhoto, clientPhoto, message);

  /// Create a copy of ConnectionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectionRequestImplCopyWith<_$ConnectionRequestImpl> get copyWith =>
      __$$ConnectionRequestImplCopyWithImpl<_$ConnectionRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConnectionRequestImplToJson(
      this,
    );
  }
}

abstract class _ConnectionRequest implements ConnectionRequest {
  const factory _ConnectionRequest(
      {required final int id,
      required final int trainer,
      @JsonKey(name: 'trainer_name') required final String trainerName,
      required final int client,
      @JsonKey(name: 'client_name') required final String clientName,
      required final String status,
      @JsonKey(name: 'created_at') required final String createdAt,
      @JsonKey(name: 'trainer_photo') final String? trainerPhoto,
      @JsonKey(name: 'client_photo') final String? clientPhoto,
      final String? message}) = _$ConnectionRequestImpl;

  factory _ConnectionRequest.fromJson(Map<String, dynamic> json) =
      _$ConnectionRequestImpl.fromJson;

  @override
  int get id;
  @override
  int get trainer;
  @override
  @JsonKey(name: 'trainer_name')
  String get trainerName;
  @override
  int get client;
  @override
  @JsonKey(name: 'client_name')
  String get clientName;
  @override
  String get status;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'trainer_photo')
  String? get trainerPhoto;
  @override
  @JsonKey(name: 'client_photo')
  String? get clientPhoto;
  @override
  String? get message;

  /// Create a copy of ConnectionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConnectionRequestImplCopyWith<_$ConnectionRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlanRequest _$PlanRequestFromJson(Map<String, dynamic> json) {
  return _PlanRequest.fromJson(json);
}

/// @nodoc
mixin _$PlanRequest {
  int get id => throw _privateConstructorUsedError;
  int get client => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_name')
  String get clientName => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  int? get trainer => throw _privateConstructorUsedError;
  @JsonKey(name: 'trainer_name')
  String? get trainerName => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this PlanRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlanRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlanRequestCopyWith<PlanRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanRequestCopyWith<$Res> {
  factory $PlanRequestCopyWith(
          PlanRequest value, $Res Function(PlanRequest) then) =
      _$PlanRequestCopyWithImpl<$Res, PlanRequest>;
  @useResult
  $Res call(
      {int id,
      int client,
      @JsonKey(name: 'client_name') String clientName,
      String status,
      @JsonKey(name: 'created_at') String createdAt,
      int? trainer,
      @JsonKey(name: 'trainer_name') String? trainerName,
      String? message,
      String? notes});
}

/// @nodoc
class _$PlanRequestCopyWithImpl<$Res, $Val extends PlanRequest>
    implements $PlanRequestCopyWith<$Res> {
  _$PlanRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlanRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? client = null,
    Object? clientName = null,
    Object? status = null,
    Object? createdAt = null,
    Object? trainer = freezed,
    Object? trainerName = freezed,
    Object? message = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      client: null == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as int,
      clientName: null == clientName
          ? _value.clientName
          : clientName // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      trainer: freezed == trainer
          ? _value.trainer
          : trainer // ignore: cast_nullable_to_non_nullable
              as int?,
      trainerName: freezed == trainerName
          ? _value.trainerName
          : trainerName // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlanRequestImplCopyWith<$Res>
    implements $PlanRequestCopyWith<$Res> {
  factory _$$PlanRequestImplCopyWith(
          _$PlanRequestImpl value, $Res Function(_$PlanRequestImpl) then) =
      __$$PlanRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int client,
      @JsonKey(name: 'client_name') String clientName,
      String status,
      @JsonKey(name: 'created_at') String createdAt,
      int? trainer,
      @JsonKey(name: 'trainer_name') String? trainerName,
      String? message,
      String? notes});
}

/// @nodoc
class __$$PlanRequestImplCopyWithImpl<$Res>
    extends _$PlanRequestCopyWithImpl<$Res, _$PlanRequestImpl>
    implements _$$PlanRequestImplCopyWith<$Res> {
  __$$PlanRequestImplCopyWithImpl(
      _$PlanRequestImpl _value, $Res Function(_$PlanRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlanRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? client = null,
    Object? clientName = null,
    Object? status = null,
    Object? createdAt = null,
    Object? trainer = freezed,
    Object? trainerName = freezed,
    Object? message = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$PlanRequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      client: null == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as int,
      clientName: null == clientName
          ? _value.clientName
          : clientName // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      trainer: freezed == trainer
          ? _value.trainer
          : trainer // ignore: cast_nullable_to_non_nullable
              as int?,
      trainerName: freezed == trainerName
          ? _value.trainerName
          : trainerName // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlanRequestImpl implements _PlanRequest {
  const _$PlanRequestImpl(
      {required this.id,
      required this.client,
      @JsonKey(name: 'client_name') required this.clientName,
      required this.status,
      @JsonKey(name: 'created_at') required this.createdAt,
      this.trainer,
      @JsonKey(name: 'trainer_name') this.trainerName,
      this.message,
      this.notes});

  factory _$PlanRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlanRequestImplFromJson(json);

  @override
  final int id;
  @override
  final int client;
  @override
  @JsonKey(name: 'client_name')
  final String clientName;
  @override
  final String status;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  final int? trainer;
  @override
  @JsonKey(name: 'trainer_name')
  final String? trainerName;
  @override
  final String? message;
  @override
  final String? notes;

  @override
  String toString() {
    return 'PlanRequest(id: $id, client: $client, clientName: $clientName, status: $status, createdAt: $createdAt, trainer: $trainer, trainerName: $trainerName, message: $message, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.client, client) || other.client == client) &&
            (identical(other.clientName, clientName) ||
                other.clientName == clientName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.trainer, trainer) || other.trainer == trainer) &&
            (identical(other.trainerName, trainerName) ||
                other.trainerName == trainerName) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, client, clientName, status,
      createdAt, trainer, trainerName, message, notes);

  /// Create a copy of PlanRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanRequestImplCopyWith<_$PlanRequestImpl> get copyWith =>
      __$$PlanRequestImplCopyWithImpl<_$PlanRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlanRequestImplToJson(
      this,
    );
  }
}

abstract class _PlanRequest implements PlanRequest {
  const factory _PlanRequest(
      {required final int id,
      required final int client,
      @JsonKey(name: 'client_name') required final String clientName,
      required final String status,
      @JsonKey(name: 'created_at') required final String createdAt,
      final int? trainer,
      @JsonKey(name: 'trainer_name') final String? trainerName,
      final String? message,
      final String? notes}) = _$PlanRequestImpl;

  factory _PlanRequest.fromJson(Map<String, dynamic> json) =
      _$PlanRequestImpl.fromJson;

  @override
  int get id;
  @override
  int get client;
  @override
  @JsonKey(name: 'client_name')
  String get clientName;
  @override
  String get status;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  int? get trainer;
  @override
  @JsonKey(name: 'trainer_name')
  String? get trainerName;
  @override
  String? get message;
  @override
  String? get notes;

  /// Create a copy of PlanRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlanRequestImplCopyWith<_$PlanRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
