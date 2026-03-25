// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'body_check_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BodyCheckModel _$BodyCheckModelFromJson(Map<String, dynamic> json) {
  return _BodyCheckModel.fromJson(json);
}

/// @nodoc
mixin _$BodyCheckModel {
  int get id => throw _privateConstructorUsedError;
  int get client => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_name')
  String get clientName => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_photo')
  String? get clientPhoto => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'weight_kg', fromJson: _doubleFromJson)
  double? get weightKg => throw _privateConstructorUsedError;
  @JsonKey(name: 'body_fat_percent', fromJson: _doubleFromJson)
  double? get bodyFatPercent => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_viewed_by_trainer')
  bool get isViewedByTrainer => throw _privateConstructorUsedError;
  List<BodyCheckPhoto> get photos => throw _privateConstructorUsedError;
  List<BodyCheckComment> get comments => throw _privateConstructorUsedError;
  List<BodyCheckShare> get shares => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_count')
  int get photoCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'comment_count')
  int get commentCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_owner')
  bool get isOwner => throw _privateConstructorUsedError;

  /// Serializes this BodyCheckModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BodyCheckModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BodyCheckModelCopyWith<BodyCheckModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BodyCheckModelCopyWith<$Res> {
  factory $BodyCheckModelCopyWith(
          BodyCheckModel value, $Res Function(BodyCheckModel) then) =
      _$BodyCheckModelCopyWithImpl<$Res, BodyCheckModel>;
  @useResult
  $Res call(
      {int id,
      int client,
      @JsonKey(name: 'client_name') String clientName,
      String date,
      String title,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      @JsonKey(name: 'client_photo') String? clientPhoto,
      String? notes,
      @JsonKey(name: 'weight_kg', fromJson: _doubleFromJson) double? weightKg,
      @JsonKey(name: 'body_fat_percent', fromJson: _doubleFromJson)
      double? bodyFatPercent,
      @JsonKey(name: 'is_viewed_by_trainer') bool isViewedByTrainer,
      List<BodyCheckPhoto> photos,
      List<BodyCheckComment> comments,
      List<BodyCheckShare> shares,
      @JsonKey(name: 'photo_count') int photoCount,
      @JsonKey(name: 'comment_count') int commentCount,
      @JsonKey(name: 'is_owner') bool isOwner});
}

/// @nodoc
class _$BodyCheckModelCopyWithImpl<$Res, $Val extends BodyCheckModel>
    implements $BodyCheckModelCopyWith<$Res> {
  _$BodyCheckModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BodyCheckModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? client = null,
    Object? clientName = null,
    Object? date = null,
    Object? title = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? clientPhoto = freezed,
    Object? notes = freezed,
    Object? weightKg = freezed,
    Object? bodyFatPercent = freezed,
    Object? isViewedByTrainer = null,
    Object? photos = null,
    Object? comments = null,
    Object? shares = null,
    Object? photoCount = null,
    Object? commentCount = null,
    Object? isOwner = null,
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
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      clientPhoto: freezed == clientPhoto
          ? _value.clientPhoto
          : clientPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      weightKg: freezed == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double?,
      bodyFatPercent: freezed == bodyFatPercent
          ? _value.bodyFatPercent
          : bodyFatPercent // ignore: cast_nullable_to_non_nullable
              as double?,
      isViewedByTrainer: null == isViewedByTrainer
          ? _value.isViewedByTrainer
          : isViewedByTrainer // ignore: cast_nullable_to_non_nullable
              as bool,
      photos: null == photos
          ? _value.photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<BodyCheckPhoto>,
      comments: null == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<BodyCheckComment>,
      shares: null == shares
          ? _value.shares
          : shares // ignore: cast_nullable_to_non_nullable
              as List<BodyCheckShare>,
      photoCount: null == photoCount
          ? _value.photoCount
          : photoCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      isOwner: null == isOwner
          ? _value.isOwner
          : isOwner // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BodyCheckModelImplCopyWith<$Res>
    implements $BodyCheckModelCopyWith<$Res> {
  factory _$$BodyCheckModelImplCopyWith(_$BodyCheckModelImpl value,
          $Res Function(_$BodyCheckModelImpl) then) =
      __$$BodyCheckModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int client,
      @JsonKey(name: 'client_name') String clientName,
      String date,
      String title,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      @JsonKey(name: 'client_photo') String? clientPhoto,
      String? notes,
      @JsonKey(name: 'weight_kg', fromJson: _doubleFromJson) double? weightKg,
      @JsonKey(name: 'body_fat_percent', fromJson: _doubleFromJson)
      double? bodyFatPercent,
      @JsonKey(name: 'is_viewed_by_trainer') bool isViewedByTrainer,
      List<BodyCheckPhoto> photos,
      List<BodyCheckComment> comments,
      List<BodyCheckShare> shares,
      @JsonKey(name: 'photo_count') int photoCount,
      @JsonKey(name: 'comment_count') int commentCount,
      @JsonKey(name: 'is_owner') bool isOwner});
}

/// @nodoc
class __$$BodyCheckModelImplCopyWithImpl<$Res>
    extends _$BodyCheckModelCopyWithImpl<$Res, _$BodyCheckModelImpl>
    implements _$$BodyCheckModelImplCopyWith<$Res> {
  __$$BodyCheckModelImplCopyWithImpl(
      _$BodyCheckModelImpl _value, $Res Function(_$BodyCheckModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BodyCheckModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? client = null,
    Object? clientName = null,
    Object? date = null,
    Object? title = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? clientPhoto = freezed,
    Object? notes = freezed,
    Object? weightKg = freezed,
    Object? bodyFatPercent = freezed,
    Object? isViewedByTrainer = null,
    Object? photos = null,
    Object? comments = null,
    Object? shares = null,
    Object? photoCount = null,
    Object? commentCount = null,
    Object? isOwner = null,
  }) {
    return _then(_$BodyCheckModelImpl(
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
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      clientPhoto: freezed == clientPhoto
          ? _value.clientPhoto
          : clientPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      weightKg: freezed == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double?,
      bodyFatPercent: freezed == bodyFatPercent
          ? _value.bodyFatPercent
          : bodyFatPercent // ignore: cast_nullable_to_non_nullable
              as double?,
      isViewedByTrainer: null == isViewedByTrainer
          ? _value.isViewedByTrainer
          : isViewedByTrainer // ignore: cast_nullable_to_non_nullable
              as bool,
      photos: null == photos
          ? _value._photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<BodyCheckPhoto>,
      comments: null == comments
          ? _value._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<BodyCheckComment>,
      shares: null == shares
          ? _value._shares
          : shares // ignore: cast_nullable_to_non_nullable
              as List<BodyCheckShare>,
      photoCount: null == photoCount
          ? _value.photoCount
          : photoCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      isOwner: null == isOwner
          ? _value.isOwner
          : isOwner // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BodyCheckModelImpl implements _BodyCheckModel {
  const _$BodyCheckModelImpl(
      {required this.id,
      required this.client,
      @JsonKey(name: 'client_name') required this.clientName,
      required this.date,
      required this.title,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'client_photo') this.clientPhoto,
      this.notes,
      @JsonKey(name: 'weight_kg', fromJson: _doubleFromJson) this.weightKg,
      @JsonKey(name: 'body_fat_percent', fromJson: _doubleFromJson)
      this.bodyFatPercent,
      @JsonKey(name: 'is_viewed_by_trainer') this.isViewedByTrainer = false,
      final List<BodyCheckPhoto> photos = const [],
      final List<BodyCheckComment> comments = const [],
      final List<BodyCheckShare> shares = const [],
      @JsonKey(name: 'photo_count') this.photoCount = 0,
      @JsonKey(name: 'comment_count') this.commentCount = 0,
      @JsonKey(name: 'is_owner') this.isOwner = false})
      : _photos = photos,
        _comments = comments,
        _shares = shares;

  factory _$BodyCheckModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BodyCheckModelImplFromJson(json);

  @override
  final int id;
  @override
  final int client;
  @override
  @JsonKey(name: 'client_name')
  final String clientName;
  @override
  final String date;
  @override
  final String title;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @override
  @JsonKey(name: 'client_photo')
  final String? clientPhoto;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'weight_kg', fromJson: _doubleFromJson)
  final double? weightKg;
  @override
  @JsonKey(name: 'body_fat_percent', fromJson: _doubleFromJson)
  final double? bodyFatPercent;
  @override
  @JsonKey(name: 'is_viewed_by_trainer')
  final bool isViewedByTrainer;
  final List<BodyCheckPhoto> _photos;
  @override
  @JsonKey()
  List<BodyCheckPhoto> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  final List<BodyCheckComment> _comments;
  @override
  @JsonKey()
  List<BodyCheckComment> get comments {
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comments);
  }

  final List<BodyCheckShare> _shares;
  @override
  @JsonKey()
  List<BodyCheckShare> get shares {
    if (_shares is EqualUnmodifiableListView) return _shares;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shares);
  }

  @override
  @JsonKey(name: 'photo_count')
  final int photoCount;
  @override
  @JsonKey(name: 'comment_count')
  final int commentCount;
  @override
  @JsonKey(name: 'is_owner')
  final bool isOwner;

  @override
  String toString() {
    return 'BodyCheckModel(id: $id, client: $client, clientName: $clientName, date: $date, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, clientPhoto: $clientPhoto, notes: $notes, weightKg: $weightKg, bodyFatPercent: $bodyFatPercent, isViewedByTrainer: $isViewedByTrainer, photos: $photos, comments: $comments, shares: $shares, photoCount: $photoCount, commentCount: $commentCount, isOwner: $isOwner)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BodyCheckModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.client, client) || other.client == client) &&
            (identical(other.clientName, clientName) ||
                other.clientName == clientName) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.clientPhoto, clientPhoto) ||
                other.clientPhoto == clientPhoto) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.bodyFatPercent, bodyFatPercent) ||
                other.bodyFatPercent == bodyFatPercent) &&
            (identical(other.isViewedByTrainer, isViewedByTrainer) ||
                other.isViewedByTrainer == isViewedByTrainer) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            const DeepCollectionEquality().equals(other._comments, _comments) &&
            const DeepCollectionEquality().equals(other._shares, _shares) &&
            (identical(other.photoCount, photoCount) ||
                other.photoCount == photoCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.isOwner, isOwner) || other.isOwner == isOwner));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      client,
      clientName,
      date,
      title,
      createdAt,
      updatedAt,
      clientPhoto,
      notes,
      weightKg,
      bodyFatPercent,
      isViewedByTrainer,
      const DeepCollectionEquality().hash(_photos),
      const DeepCollectionEquality().hash(_comments),
      const DeepCollectionEquality().hash(_shares),
      photoCount,
      commentCount,
      isOwner);

  /// Create a copy of BodyCheckModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BodyCheckModelImplCopyWith<_$BodyCheckModelImpl> get copyWith =>
      __$$BodyCheckModelImplCopyWithImpl<_$BodyCheckModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BodyCheckModelImplToJson(
      this,
    );
  }
}

abstract class _BodyCheckModel implements BodyCheckModel {
  const factory _BodyCheckModel(
      {required final int id,
      required final int client,
      @JsonKey(name: 'client_name') required final String clientName,
      required final String date,
      required final String title,
      @JsonKey(name: 'created_at') required final String createdAt,
      @JsonKey(name: 'updated_at') final String? updatedAt,
      @JsonKey(name: 'client_photo') final String? clientPhoto,
      final String? notes,
      @JsonKey(name: 'weight_kg', fromJson: _doubleFromJson)
      final double? weightKg,
      @JsonKey(name: 'body_fat_percent', fromJson: _doubleFromJson)
      final double? bodyFatPercent,
      @JsonKey(name: 'is_viewed_by_trainer') final bool isViewedByTrainer,
      final List<BodyCheckPhoto> photos,
      final List<BodyCheckComment> comments,
      final List<BodyCheckShare> shares,
      @JsonKey(name: 'photo_count') final int photoCount,
      @JsonKey(name: 'comment_count') final int commentCount,
      @JsonKey(name: 'is_owner') final bool isOwner}) = _$BodyCheckModelImpl;

  factory _BodyCheckModel.fromJson(Map<String, dynamic> json) =
      _$BodyCheckModelImpl.fromJson;

  @override
  int get id;
  @override
  int get client;
  @override
  @JsonKey(name: 'client_name')
  String get clientName;
  @override
  String get date;
  @override
  String get title;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;
  @override
  @JsonKey(name: 'client_photo')
  String? get clientPhoto;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'weight_kg', fromJson: _doubleFromJson)
  double? get weightKg;
  @override
  @JsonKey(name: 'body_fat_percent', fromJson: _doubleFromJson)
  double? get bodyFatPercent;
  @override
  @JsonKey(name: 'is_viewed_by_trainer')
  bool get isViewedByTrainer;
  @override
  List<BodyCheckPhoto> get photos;
  @override
  List<BodyCheckComment> get comments;
  @override
  List<BodyCheckShare> get shares;
  @override
  @JsonKey(name: 'photo_count')
  int get photoCount;
  @override
  @JsonKey(name: 'comment_count')
  int get commentCount;
  @override
  @JsonKey(name: 'is_owner')
  bool get isOwner;

  /// Create a copy of BodyCheckModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BodyCheckModelImplCopyWith<_$BodyCheckModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BodyCheckPhoto _$BodyCheckPhotoFromJson(Map<String, dynamic> json) {
  return _BodyCheckPhoto.fromJson(json);
}

/// @nodoc
mixin _$BodyCheckPhoto {
  int get id => throw _privateConstructorUsedError;
  String get photo => throw _privateConstructorUsedError;
  String get position => throw _privateConstructorUsedError;
  @JsonKey(name: 'position_display')
  String get positionDisplay => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this BodyCheckPhoto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BodyCheckPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BodyCheckPhotoCopyWith<BodyCheckPhoto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BodyCheckPhotoCopyWith<$Res> {
  factory $BodyCheckPhotoCopyWith(
          BodyCheckPhoto value, $Res Function(BodyCheckPhoto) then) =
      _$BodyCheckPhotoCopyWithImpl<$Res, BodyCheckPhoto>;
  @useResult
  $Res call(
      {int id,
      String photo,
      String position,
      @JsonKey(name: 'position_display') String positionDisplay,
      int order,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class _$BodyCheckPhotoCopyWithImpl<$Res, $Val extends BodyCheckPhoto>
    implements $BodyCheckPhotoCopyWith<$Res> {
  _$BodyCheckPhotoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BodyCheckPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? photo = null,
    Object? position = null,
    Object? positionDisplay = null,
    Object? order = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      photo: null == photo
          ? _value.photo
          : photo // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String,
      positionDisplay: null == positionDisplay
          ? _value.positionDisplay
          : positionDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BodyCheckPhotoImplCopyWith<$Res>
    implements $BodyCheckPhotoCopyWith<$Res> {
  factory _$$BodyCheckPhotoImplCopyWith(_$BodyCheckPhotoImpl value,
          $Res Function(_$BodyCheckPhotoImpl) then) =
      __$$BodyCheckPhotoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String photo,
      String position,
      @JsonKey(name: 'position_display') String positionDisplay,
      int order,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class __$$BodyCheckPhotoImplCopyWithImpl<$Res>
    extends _$BodyCheckPhotoCopyWithImpl<$Res, _$BodyCheckPhotoImpl>
    implements _$$BodyCheckPhotoImplCopyWith<$Res> {
  __$$BodyCheckPhotoImplCopyWithImpl(
      _$BodyCheckPhotoImpl _value, $Res Function(_$BodyCheckPhotoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BodyCheckPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? photo = null,
    Object? position = null,
    Object? positionDisplay = null,
    Object? order = null,
    Object? createdAt = null,
  }) {
    return _then(_$BodyCheckPhotoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      photo: null == photo
          ? _value.photo
          : photo // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String,
      positionDisplay: null == positionDisplay
          ? _value.positionDisplay
          : positionDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BodyCheckPhotoImpl implements _BodyCheckPhoto {
  const _$BodyCheckPhotoImpl(
      {required this.id,
      required this.photo,
      required this.position,
      @JsonKey(name: 'position_display') required this.positionDisplay,
      required this.order,
      @JsonKey(name: 'created_at') required this.createdAt});

  factory _$BodyCheckPhotoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BodyCheckPhotoImplFromJson(json);

  @override
  final int id;
  @override
  final String photo;
  @override
  final String position;
  @override
  @JsonKey(name: 'position_display')
  final String positionDisplay;
  @override
  final int order;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  @override
  String toString() {
    return 'BodyCheckPhoto(id: $id, photo: $photo, position: $position, positionDisplay: $positionDisplay, order: $order, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BodyCheckPhotoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.photo, photo) || other.photo == photo) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.positionDisplay, positionDisplay) ||
                other.positionDisplay == positionDisplay) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, photo, position, positionDisplay, order, createdAt);

  /// Create a copy of BodyCheckPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BodyCheckPhotoImplCopyWith<_$BodyCheckPhotoImpl> get copyWith =>
      __$$BodyCheckPhotoImplCopyWithImpl<_$BodyCheckPhotoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BodyCheckPhotoImplToJson(
      this,
    );
  }
}

abstract class _BodyCheckPhoto implements BodyCheckPhoto {
  const factory _BodyCheckPhoto(
      {required final int id,
      required final String photo,
      required final String position,
      @JsonKey(name: 'position_display') required final String positionDisplay,
      required final int order,
      @JsonKey(name: 'created_at')
      required final String createdAt}) = _$BodyCheckPhotoImpl;

  factory _BodyCheckPhoto.fromJson(Map<String, dynamic> json) =
      _$BodyCheckPhotoImpl.fromJson;

  @override
  int get id;
  @override
  String get photo;
  @override
  String get position;
  @override
  @JsonKey(name: 'position_display')
  String get positionDisplay;
  @override
  int get order;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;

  /// Create a copy of BodyCheckPhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BodyCheckPhotoImplCopyWith<_$BodyCheckPhotoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BodyCheckComment _$BodyCheckCommentFromJson(Map<String, dynamic> json) {
  return _BodyCheckComment.fromJson(json);
}

/// @nodoc
mixin _$BodyCheckComment {
  int get id => throw _privateConstructorUsedError;
  int get author => throw _privateConstructorUsedError;
  @JsonKey(name: 'author_name')
  String get authorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'author_role')
  String get authorRole => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'author_photo')
  String? get authorPhoto => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_own')
  bool get isOwn => throw _privateConstructorUsedError;

  /// Serializes this BodyCheckComment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BodyCheckComment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BodyCheckCommentCopyWith<BodyCheckComment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BodyCheckCommentCopyWith<$Res> {
  factory $BodyCheckCommentCopyWith(
          BodyCheckComment value, $Res Function(BodyCheckComment) then) =
      _$BodyCheckCommentCopyWithImpl<$Res, BodyCheckComment>;
  @useResult
  $Res call(
      {int id,
      int author,
      @JsonKey(name: 'author_name') String authorName,
      @JsonKey(name: 'author_role') String authorRole,
      String message,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt,
      @JsonKey(name: 'author_photo') String? authorPhoto,
      @JsonKey(name: 'is_own') bool isOwn});
}

/// @nodoc
class _$BodyCheckCommentCopyWithImpl<$Res, $Val extends BodyCheckComment>
    implements $BodyCheckCommentCopyWith<$Res> {
  _$BodyCheckCommentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BodyCheckComment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? author = null,
    Object? authorName = null,
    Object? authorRole = null,
    Object? message = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? authorPhoto = freezed,
    Object? isOwn = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as int,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorRole: null == authorRole
          ? _value.authorRole
          : authorRole // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      authorPhoto: freezed == authorPhoto
          ? _value.authorPhoto
          : authorPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      isOwn: null == isOwn
          ? _value.isOwn
          : isOwn // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BodyCheckCommentImplCopyWith<$Res>
    implements $BodyCheckCommentCopyWith<$Res> {
  factory _$$BodyCheckCommentImplCopyWith(_$BodyCheckCommentImpl value,
          $Res Function(_$BodyCheckCommentImpl) then) =
      __$$BodyCheckCommentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int author,
      @JsonKey(name: 'author_name') String authorName,
      @JsonKey(name: 'author_role') String authorRole,
      String message,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt,
      @JsonKey(name: 'author_photo') String? authorPhoto,
      @JsonKey(name: 'is_own') bool isOwn});
}

/// @nodoc
class __$$BodyCheckCommentImplCopyWithImpl<$Res>
    extends _$BodyCheckCommentCopyWithImpl<$Res, _$BodyCheckCommentImpl>
    implements _$$BodyCheckCommentImplCopyWith<$Res> {
  __$$BodyCheckCommentImplCopyWithImpl(_$BodyCheckCommentImpl _value,
      $Res Function(_$BodyCheckCommentImpl) _then)
      : super(_value, _then);

  /// Create a copy of BodyCheckComment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? author = null,
    Object? authorName = null,
    Object? authorRole = null,
    Object? message = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? authorPhoto = freezed,
    Object? isOwn = null,
  }) {
    return _then(_$BodyCheckCommentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as int,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorRole: null == authorRole
          ? _value.authorRole
          : authorRole // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      authorPhoto: freezed == authorPhoto
          ? _value.authorPhoto
          : authorPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      isOwn: null == isOwn
          ? _value.isOwn
          : isOwn // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BodyCheckCommentImpl implements _BodyCheckComment {
  const _$BodyCheckCommentImpl(
      {required this.id,
      required this.author,
      @JsonKey(name: 'author_name') required this.authorName,
      @JsonKey(name: 'author_role') required this.authorRole,
      required this.message,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'author_photo') this.authorPhoto,
      @JsonKey(name: 'is_own') this.isOwn = false});

  factory _$BodyCheckCommentImpl.fromJson(Map<String, dynamic> json) =>
      _$$BodyCheckCommentImplFromJson(json);

  @override
  final int id;
  @override
  final int author;
  @override
  @JsonKey(name: 'author_name')
  final String authorName;
  @override
  @JsonKey(name: 'author_role')
  final String authorRole;
  @override
  final String message;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @override
  @JsonKey(name: 'author_photo')
  final String? authorPhoto;
  @override
  @JsonKey(name: 'is_own')
  final bool isOwn;

  @override
  String toString() {
    return 'BodyCheckComment(id: $id, author: $author, authorName: $authorName, authorRole: $authorRole, message: $message, createdAt: $createdAt, updatedAt: $updatedAt, authorPhoto: $authorPhoto, isOwn: $isOwn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BodyCheckCommentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorRole, authorRole) ||
                other.authorRole == authorRole) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.authorPhoto, authorPhoto) ||
                other.authorPhoto == authorPhoto) &&
            (identical(other.isOwn, isOwn) || other.isOwn == isOwn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, author, authorName,
      authorRole, message, createdAt, updatedAt, authorPhoto, isOwn);

  /// Create a copy of BodyCheckComment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BodyCheckCommentImplCopyWith<_$BodyCheckCommentImpl> get copyWith =>
      __$$BodyCheckCommentImplCopyWithImpl<_$BodyCheckCommentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BodyCheckCommentImplToJson(
      this,
    );
  }
}

abstract class _BodyCheckComment implements BodyCheckComment {
  const factory _BodyCheckComment(
      {required final int id,
      required final int author,
      @JsonKey(name: 'author_name') required final String authorName,
      @JsonKey(name: 'author_role') required final String authorRole,
      required final String message,
      @JsonKey(name: 'created_at') required final String createdAt,
      @JsonKey(name: 'updated_at') required final String updatedAt,
      @JsonKey(name: 'author_photo') final String? authorPhoto,
      @JsonKey(name: 'is_own') final bool isOwn}) = _$BodyCheckCommentImpl;

  factory _BodyCheckComment.fromJson(Map<String, dynamic> json) =
      _$BodyCheckCommentImpl.fromJson;

  @override
  int get id;
  @override
  int get author;
  @override
  @JsonKey(name: 'author_name')
  String get authorName;
  @override
  @JsonKey(name: 'author_role')
  String get authorRole;
  @override
  String get message;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;
  @override
  @JsonKey(name: 'author_photo')
  String? get authorPhoto;
  @override
  @JsonKey(name: 'is_own')
  bool get isOwn;

  /// Create a copy of BodyCheckComment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BodyCheckCommentImplCopyWith<_$BodyCheckCommentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BodyCheckShare _$BodyCheckShareFromJson(Map<String, dynamic> json) {
  return _BodyCheckShare.fromJson(json);
}

/// @nodoc
mixin _$BodyCheckShare {
  int get id => throw _privateConstructorUsedError;
  int get trainer => throw _privateConstructorUsedError;
  @JsonKey(name: 'trainer_name')
  String get trainerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'shared_at')
  String get sharedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'trainer_photo')
  String? get trainerPhoto => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_viewed')
  bool get isViewed => throw _privateConstructorUsedError;

  /// Serializes this BodyCheckShare to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BodyCheckShare
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BodyCheckShareCopyWith<BodyCheckShare> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BodyCheckShareCopyWith<$Res> {
  factory $BodyCheckShareCopyWith(
          BodyCheckShare value, $Res Function(BodyCheckShare) then) =
      _$BodyCheckShareCopyWithImpl<$Res, BodyCheckShare>;
  @useResult
  $Res call(
      {int id,
      int trainer,
      @JsonKey(name: 'trainer_name') String trainerName,
      @JsonKey(name: 'shared_at') String sharedAt,
      @JsonKey(name: 'trainer_photo') String? trainerPhoto,
      @JsonKey(name: 'is_viewed') bool isViewed});
}

/// @nodoc
class _$BodyCheckShareCopyWithImpl<$Res, $Val extends BodyCheckShare>
    implements $BodyCheckShareCopyWith<$Res> {
  _$BodyCheckShareCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BodyCheckShare
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trainer = null,
    Object? trainerName = null,
    Object? sharedAt = null,
    Object? trainerPhoto = freezed,
    Object? isViewed = null,
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
      sharedAt: null == sharedAt
          ? _value.sharedAt
          : sharedAt // ignore: cast_nullable_to_non_nullable
              as String,
      trainerPhoto: freezed == trainerPhoto
          ? _value.trainerPhoto
          : trainerPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      isViewed: null == isViewed
          ? _value.isViewed
          : isViewed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BodyCheckShareImplCopyWith<$Res>
    implements $BodyCheckShareCopyWith<$Res> {
  factory _$$BodyCheckShareImplCopyWith(_$BodyCheckShareImpl value,
          $Res Function(_$BodyCheckShareImpl) then) =
      __$$BodyCheckShareImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int trainer,
      @JsonKey(name: 'trainer_name') String trainerName,
      @JsonKey(name: 'shared_at') String sharedAt,
      @JsonKey(name: 'trainer_photo') String? trainerPhoto,
      @JsonKey(name: 'is_viewed') bool isViewed});
}

/// @nodoc
class __$$BodyCheckShareImplCopyWithImpl<$Res>
    extends _$BodyCheckShareCopyWithImpl<$Res, _$BodyCheckShareImpl>
    implements _$$BodyCheckShareImplCopyWith<$Res> {
  __$$BodyCheckShareImplCopyWithImpl(
      _$BodyCheckShareImpl _value, $Res Function(_$BodyCheckShareImpl) _then)
      : super(_value, _then);

  /// Create a copy of BodyCheckShare
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trainer = null,
    Object? trainerName = null,
    Object? sharedAt = null,
    Object? trainerPhoto = freezed,
    Object? isViewed = null,
  }) {
    return _then(_$BodyCheckShareImpl(
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
      sharedAt: null == sharedAt
          ? _value.sharedAt
          : sharedAt // ignore: cast_nullable_to_non_nullable
              as String,
      trainerPhoto: freezed == trainerPhoto
          ? _value.trainerPhoto
          : trainerPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      isViewed: null == isViewed
          ? _value.isViewed
          : isViewed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BodyCheckShareImpl implements _BodyCheckShare {
  const _$BodyCheckShareImpl(
      {required this.id,
      required this.trainer,
      @JsonKey(name: 'trainer_name') required this.trainerName,
      @JsonKey(name: 'shared_at') required this.sharedAt,
      @JsonKey(name: 'trainer_photo') this.trainerPhoto,
      @JsonKey(name: 'is_viewed') this.isViewed = false});

  factory _$BodyCheckShareImpl.fromJson(Map<String, dynamic> json) =>
      _$$BodyCheckShareImplFromJson(json);

  @override
  final int id;
  @override
  final int trainer;
  @override
  @JsonKey(name: 'trainer_name')
  final String trainerName;
  @override
  @JsonKey(name: 'shared_at')
  final String sharedAt;
  @override
  @JsonKey(name: 'trainer_photo')
  final String? trainerPhoto;
  @override
  @JsonKey(name: 'is_viewed')
  final bool isViewed;

  @override
  String toString() {
    return 'BodyCheckShare(id: $id, trainer: $trainer, trainerName: $trainerName, sharedAt: $sharedAt, trainerPhoto: $trainerPhoto, isViewed: $isViewed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BodyCheckShareImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.trainer, trainer) || other.trainer == trainer) &&
            (identical(other.trainerName, trainerName) ||
                other.trainerName == trainerName) &&
            (identical(other.sharedAt, sharedAt) ||
                other.sharedAt == sharedAt) &&
            (identical(other.trainerPhoto, trainerPhoto) ||
                other.trainerPhoto == trainerPhoto) &&
            (identical(other.isViewed, isViewed) ||
                other.isViewed == isViewed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, trainer, trainerName, sharedAt, trainerPhoto, isViewed);

  /// Create a copy of BodyCheckShare
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BodyCheckShareImplCopyWith<_$BodyCheckShareImpl> get copyWith =>
      __$$BodyCheckShareImplCopyWithImpl<_$BodyCheckShareImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BodyCheckShareImplToJson(
      this,
    );
  }
}

abstract class _BodyCheckShare implements BodyCheckShare {
  const factory _BodyCheckShare(
      {required final int id,
      required final int trainer,
      @JsonKey(name: 'trainer_name') required final String trainerName,
      @JsonKey(name: 'shared_at') required final String sharedAt,
      @JsonKey(name: 'trainer_photo') final String? trainerPhoto,
      @JsonKey(name: 'is_viewed') final bool isViewed}) = _$BodyCheckShareImpl;

  factory _BodyCheckShare.fromJson(Map<String, dynamic> json) =
      _$BodyCheckShareImpl.fromJson;

  @override
  int get id;
  @override
  int get trainer;
  @override
  @JsonKey(name: 'trainer_name')
  String get trainerName;
  @override
  @JsonKey(name: 'shared_at')
  String get sharedAt;
  @override
  @JsonKey(name: 'trainer_photo')
  String? get trainerPhoto;
  @override
  @JsonKey(name: 'is_viewed')
  bool get isViewed;

  /// Create a copy of BodyCheckShare
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BodyCheckShareImplCopyWith<_$BodyCheckShareImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
