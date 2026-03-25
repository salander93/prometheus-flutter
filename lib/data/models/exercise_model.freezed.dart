// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExerciseModel _$ExerciseModelFromJson(Map<String, dynamic> json) {
  return _ExerciseModel.fromJson(json);
}

/// @nodoc
mixin _$ExerciseModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'muscle_group')
  String get muscleGroup => throw _privateConstructorUsedError;
  @JsonKey(name: 'muscle_group_display')
  String get muscleGroupDisplay => throw _privateConstructorUsedError;
  String get level => throw _privateConstructorUsedError;
  @JsonKey(name: 'level_display')
  String get levelDisplay => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_display')
  String get categoryDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_public')
  bool get isPublic => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_it')
  String? get nameIt => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get instructions => throw _privateConstructorUsedError;
  @JsonKey(name: 'secondary_muscles')
  String? get secondaryMuscles => throw _privateConstructorUsedError;
  String? get equipment => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'video_url')
  String? get videoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_owner')
  bool get isOwner => throw _privateConstructorUsedError;

  /// Serializes this ExerciseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExerciseModelCopyWith<ExerciseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseModelCopyWith<$Res> {
  factory $ExerciseModelCopyWith(
          ExerciseModel value, $Res Function(ExerciseModel) then) =
      _$ExerciseModelCopyWithImpl<$Res, ExerciseModel>;
  @useResult
  $Res call(
      {int id,
      String name,
      @JsonKey(name: 'muscle_group') String muscleGroup,
      @JsonKey(name: 'muscle_group_display') String muscleGroupDisplay,
      String level,
      @JsonKey(name: 'level_display') String levelDisplay,
      String category,
      @JsonKey(name: 'category_display') String categoryDisplay,
      @JsonKey(name: 'is_public') bool isPublic,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'name_it') String? nameIt,
      String? description,
      String? instructions,
      @JsonKey(name: 'secondary_muscles') String? secondaryMuscles,
      String? equipment,
      String? image,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'video_url') String? videoUrl,
      @JsonKey(name: 'is_owner') bool isOwner});
}

/// @nodoc
class _$ExerciseModelCopyWithImpl<$Res, $Val extends ExerciseModel>
    implements $ExerciseModelCopyWith<$Res> {
  _$ExerciseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? muscleGroup = null,
    Object? muscleGroupDisplay = null,
    Object? level = null,
    Object? levelDisplay = null,
    Object? category = null,
    Object? categoryDisplay = null,
    Object? isPublic = null,
    Object? createdAt = null,
    Object? nameIt = freezed,
    Object? description = freezed,
    Object? instructions = freezed,
    Object? secondaryMuscles = freezed,
    Object? equipment = freezed,
    Object? image = freezed,
    Object? imageUrl = freezed,
    Object? videoUrl = freezed,
    Object? isOwner = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      muscleGroup: null == muscleGroup
          ? _value.muscleGroup
          : muscleGroup // ignore: cast_nullable_to_non_nullable
              as String,
      muscleGroupDisplay: null == muscleGroupDisplay
          ? _value.muscleGroupDisplay
          : muscleGroupDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      levelDisplay: null == levelDisplay
          ? _value.levelDisplay
          : levelDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      categoryDisplay: null == categoryDisplay
          ? _value.categoryDisplay
          : categoryDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      nameIt: freezed == nameIt
          ? _value.nameIt
          : nameIt // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      instructions: freezed == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String?,
      secondaryMuscles: freezed == secondaryMuscles
          ? _value.secondaryMuscles
          : secondaryMuscles // ignore: cast_nullable_to_non_nullable
              as String?,
      equipment: freezed == equipment
          ? _value.equipment
          : equipment // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isOwner: null == isOwner
          ? _value.isOwner
          : isOwner // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExerciseModelImplCopyWith<$Res>
    implements $ExerciseModelCopyWith<$Res> {
  factory _$$ExerciseModelImplCopyWith(
          _$ExerciseModelImpl value, $Res Function(_$ExerciseModelImpl) then) =
      __$$ExerciseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      @JsonKey(name: 'muscle_group') String muscleGroup,
      @JsonKey(name: 'muscle_group_display') String muscleGroupDisplay,
      String level,
      @JsonKey(name: 'level_display') String levelDisplay,
      String category,
      @JsonKey(name: 'category_display') String categoryDisplay,
      @JsonKey(name: 'is_public') bool isPublic,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'name_it') String? nameIt,
      String? description,
      String? instructions,
      @JsonKey(name: 'secondary_muscles') String? secondaryMuscles,
      String? equipment,
      String? image,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'video_url') String? videoUrl,
      @JsonKey(name: 'is_owner') bool isOwner});
}

/// @nodoc
class __$$ExerciseModelImplCopyWithImpl<$Res>
    extends _$ExerciseModelCopyWithImpl<$Res, _$ExerciseModelImpl>
    implements _$$ExerciseModelImplCopyWith<$Res> {
  __$$ExerciseModelImplCopyWithImpl(
      _$ExerciseModelImpl _value, $Res Function(_$ExerciseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? muscleGroup = null,
    Object? muscleGroupDisplay = null,
    Object? level = null,
    Object? levelDisplay = null,
    Object? category = null,
    Object? categoryDisplay = null,
    Object? isPublic = null,
    Object? createdAt = null,
    Object? nameIt = freezed,
    Object? description = freezed,
    Object? instructions = freezed,
    Object? secondaryMuscles = freezed,
    Object? equipment = freezed,
    Object? image = freezed,
    Object? imageUrl = freezed,
    Object? videoUrl = freezed,
    Object? isOwner = null,
  }) {
    return _then(_$ExerciseModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      muscleGroup: null == muscleGroup
          ? _value.muscleGroup
          : muscleGroup // ignore: cast_nullable_to_non_nullable
              as String,
      muscleGroupDisplay: null == muscleGroupDisplay
          ? _value.muscleGroupDisplay
          : muscleGroupDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      levelDisplay: null == levelDisplay
          ? _value.levelDisplay
          : levelDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      categoryDisplay: null == categoryDisplay
          ? _value.categoryDisplay
          : categoryDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      nameIt: freezed == nameIt
          ? _value.nameIt
          : nameIt // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      instructions: freezed == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String?,
      secondaryMuscles: freezed == secondaryMuscles
          ? _value.secondaryMuscles
          : secondaryMuscles // ignore: cast_nullable_to_non_nullable
              as String?,
      equipment: freezed == equipment
          ? _value.equipment
          : equipment // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isOwner: null == isOwner
          ? _value.isOwner
          : isOwner // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExerciseModelImpl implements _ExerciseModel {
  const _$ExerciseModelImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'muscle_group') required this.muscleGroup,
      @JsonKey(name: 'muscle_group_display') required this.muscleGroupDisplay,
      required this.level,
      @JsonKey(name: 'level_display') required this.levelDisplay,
      required this.category,
      @JsonKey(name: 'category_display') required this.categoryDisplay,
      @JsonKey(name: 'is_public') required this.isPublic,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'name_it') this.nameIt,
      this.description,
      this.instructions,
      @JsonKey(name: 'secondary_muscles') this.secondaryMuscles,
      this.equipment,
      this.image,
      @JsonKey(name: 'image_url') this.imageUrl,
      @JsonKey(name: 'video_url') this.videoUrl,
      @JsonKey(name: 'is_owner') this.isOwner = false});

  factory _$ExerciseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'muscle_group')
  final String muscleGroup;
  @override
  @JsonKey(name: 'muscle_group_display')
  final String muscleGroupDisplay;
  @override
  final String level;
  @override
  @JsonKey(name: 'level_display')
  final String levelDisplay;
  @override
  final String category;
  @override
  @JsonKey(name: 'category_display')
  final String categoryDisplay;
  @override
  @JsonKey(name: 'is_public')
  final bool isPublic;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'name_it')
  final String? nameIt;
  @override
  final String? description;
  @override
  final String? instructions;
  @override
  @JsonKey(name: 'secondary_muscles')
  final String? secondaryMuscles;
  @override
  final String? equipment;
  @override
  final String? image;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'video_url')
  final String? videoUrl;
  @override
  @JsonKey(name: 'is_owner')
  final bool isOwner;

  @override
  String toString() {
    return 'ExerciseModel(id: $id, name: $name, muscleGroup: $muscleGroup, muscleGroupDisplay: $muscleGroupDisplay, level: $level, levelDisplay: $levelDisplay, category: $category, categoryDisplay: $categoryDisplay, isPublic: $isPublic, createdAt: $createdAt, nameIt: $nameIt, description: $description, instructions: $instructions, secondaryMuscles: $secondaryMuscles, equipment: $equipment, image: $image, imageUrl: $imageUrl, videoUrl: $videoUrl, isOwner: $isOwner)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.muscleGroup, muscleGroup) ||
                other.muscleGroup == muscleGroup) &&
            (identical(other.muscleGroupDisplay, muscleGroupDisplay) ||
                other.muscleGroupDisplay == muscleGroupDisplay) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.levelDisplay, levelDisplay) ||
                other.levelDisplay == levelDisplay) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.categoryDisplay, categoryDisplay) ||
                other.categoryDisplay == categoryDisplay) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.nameIt, nameIt) || other.nameIt == nameIt) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions) &&
            (identical(other.secondaryMuscles, secondaryMuscles) ||
                other.secondaryMuscles == secondaryMuscles) &&
            (identical(other.equipment, equipment) ||
                other.equipment == equipment) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.isOwner, isOwner) || other.isOwner == isOwner));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        muscleGroup,
        muscleGroupDisplay,
        level,
        levelDisplay,
        category,
        categoryDisplay,
        isPublic,
        createdAt,
        nameIt,
        description,
        instructions,
        secondaryMuscles,
        equipment,
        image,
        imageUrl,
        videoUrl,
        isOwner
      ]);

  /// Create a copy of ExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseModelImplCopyWith<_$ExerciseModelImpl> get copyWith =>
      __$$ExerciseModelImplCopyWithImpl<_$ExerciseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseModelImplToJson(
      this,
    );
  }
}

abstract class _ExerciseModel implements ExerciseModel {
  const factory _ExerciseModel(
      {required final int id,
      required final String name,
      @JsonKey(name: 'muscle_group') required final String muscleGroup,
      @JsonKey(name: 'muscle_group_display')
      required final String muscleGroupDisplay,
      required final String level,
      @JsonKey(name: 'level_display') required final String levelDisplay,
      required final String category,
      @JsonKey(name: 'category_display') required final String categoryDisplay,
      @JsonKey(name: 'is_public') required final bool isPublic,
      @JsonKey(name: 'created_at') required final String createdAt,
      @JsonKey(name: 'name_it') final String? nameIt,
      final String? description,
      final String? instructions,
      @JsonKey(name: 'secondary_muscles') final String? secondaryMuscles,
      final String? equipment,
      final String? image,
      @JsonKey(name: 'image_url') final String? imageUrl,
      @JsonKey(name: 'video_url') final String? videoUrl,
      @JsonKey(name: 'is_owner') final bool isOwner}) = _$ExerciseModelImpl;

  factory _ExerciseModel.fromJson(Map<String, dynamic> json) =
      _$ExerciseModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'muscle_group')
  String get muscleGroup;
  @override
  @JsonKey(name: 'muscle_group_display')
  String get muscleGroupDisplay;
  @override
  String get level;
  @override
  @JsonKey(name: 'level_display')
  String get levelDisplay;
  @override
  String get category;
  @override
  @JsonKey(name: 'category_display')
  String get categoryDisplay;
  @override
  @JsonKey(name: 'is_public')
  bool get isPublic;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'name_it')
  String? get nameIt;
  @override
  String? get description;
  @override
  String? get instructions;
  @override
  @JsonKey(name: 'secondary_muscles')
  String? get secondaryMuscles;
  @override
  String? get equipment;
  @override
  String? get image;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'video_url')
  String? get videoUrl;
  @override
  @JsonKey(name: 'is_owner')
  bool get isOwner;

  /// Create a copy of ExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExerciseModelImplCopyWith<_$ExerciseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
