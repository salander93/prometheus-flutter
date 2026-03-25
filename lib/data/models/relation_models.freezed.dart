// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'relation_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TrainerClient _$TrainerClientFromJson(Map<String, dynamic> json) {
  return _TrainerClient.fromJson(json);
}

/// @nodoc
mixin _$TrainerClient {
  int get id => throw _privateConstructorUsedError;
  int get trainer => throw _privateConstructorUsedError;
  @JsonKey(name: 'trainer_name')
  String get trainerName => throw _privateConstructorUsedError;
  int get client => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_name')
  String get clientName => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'trainer_photo')
  String? get trainerPhoto => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_photo')
  String? get clientPhoto => throw _privateConstructorUsedError;

  /// Serializes this TrainerClient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrainerClient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainerClientCopyWith<TrainerClient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainerClientCopyWith<$Res> {
  factory $TrainerClientCopyWith(
          TrainerClient value, $Res Function(TrainerClient) then) =
      _$TrainerClientCopyWithImpl<$Res, TrainerClient>;
  @useResult
  $Res call(
      {int id,
      int trainer,
      @JsonKey(name: 'trainer_name') String trainerName,
      int client,
      @JsonKey(name: 'client_name') String clientName,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'trainer_photo') String? trainerPhoto,
      @JsonKey(name: 'client_photo') String? clientPhoto});
}

/// @nodoc
class _$TrainerClientCopyWithImpl<$Res, $Val extends TrainerClient>
    implements $TrainerClientCopyWith<$Res> {
  _$TrainerClientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainerClient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trainer = null,
    Object? trainerName = null,
    Object? client = null,
    Object? clientName = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? trainerPhoto = freezed,
    Object? clientPhoto = freezed,
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
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrainerClientImplCopyWith<$Res>
    implements $TrainerClientCopyWith<$Res> {
  factory _$$TrainerClientImplCopyWith(
          _$TrainerClientImpl value, $Res Function(_$TrainerClientImpl) then) =
      __$$TrainerClientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int trainer,
      @JsonKey(name: 'trainer_name') String trainerName,
      int client,
      @JsonKey(name: 'client_name') String clientName,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'trainer_photo') String? trainerPhoto,
      @JsonKey(name: 'client_photo') String? clientPhoto});
}

/// @nodoc
class __$$TrainerClientImplCopyWithImpl<$Res>
    extends _$TrainerClientCopyWithImpl<$Res, _$TrainerClientImpl>
    implements _$$TrainerClientImplCopyWith<$Res> {
  __$$TrainerClientImplCopyWithImpl(
      _$TrainerClientImpl _value, $Res Function(_$TrainerClientImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrainerClient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trainer = null,
    Object? trainerName = null,
    Object? client = null,
    Object? clientName = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? trainerPhoto = freezed,
    Object? clientPhoto = freezed,
  }) {
    return _then(_$TrainerClientImpl(
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
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrainerClientImpl implements _TrainerClient {
  const _$TrainerClientImpl(
      {required this.id,
      required this.trainer,
      @JsonKey(name: 'trainer_name') required this.trainerName,
      required this.client,
      @JsonKey(name: 'client_name') required this.clientName,
      @JsonKey(name: 'is_active') required this.isActive,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'trainer_photo') this.trainerPhoto,
      @JsonKey(name: 'client_photo') this.clientPhoto});

  factory _$TrainerClientImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrainerClientImplFromJson(json);

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
  @JsonKey(name: 'is_active')
  final bool isActive;
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
  String toString() {
    return 'TrainerClient(id: $id, trainer: $trainer, trainerName: $trainerName, client: $client, clientName: $clientName, isActive: $isActive, createdAt: $createdAt, trainerPhoto: $trainerPhoto, clientPhoto: $clientPhoto)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainerClientImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.trainer, trainer) || other.trainer == trainer) &&
            (identical(other.trainerName, trainerName) ||
                other.trainerName == trainerName) &&
            (identical(other.client, client) || other.client == client) &&
            (identical(other.clientName, clientName) ||
                other.clientName == clientName) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.trainerPhoto, trainerPhoto) ||
                other.trainerPhoto == trainerPhoto) &&
            (identical(other.clientPhoto, clientPhoto) ||
                other.clientPhoto == clientPhoto));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, trainer, trainerName, client,
      clientName, isActive, createdAt, trainerPhoto, clientPhoto);

  /// Create a copy of TrainerClient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainerClientImplCopyWith<_$TrainerClientImpl> get copyWith =>
      __$$TrainerClientImplCopyWithImpl<_$TrainerClientImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrainerClientImplToJson(
      this,
    );
  }
}

abstract class _TrainerClient implements TrainerClient {
  const factory _TrainerClient(
          {required final int id,
          required final int trainer,
          @JsonKey(name: 'trainer_name') required final String trainerName,
          required final int client,
          @JsonKey(name: 'client_name') required final String clientName,
          @JsonKey(name: 'is_active') required final bool isActive,
          @JsonKey(name: 'created_at') required final String createdAt,
          @JsonKey(name: 'trainer_photo') final String? trainerPhoto,
          @JsonKey(name: 'client_photo') final String? clientPhoto}) =
      _$TrainerClientImpl;

  factory _TrainerClient.fromJson(Map<String, dynamic> json) =
      _$TrainerClientImpl.fromJson;

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
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'trainer_photo')
  String? get trainerPhoto;
  @override
  @JsonKey(name: 'client_photo')
  String? get clientPhoto;

  /// Create a copy of TrainerClient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainerClientImplCopyWith<_$TrainerClientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
