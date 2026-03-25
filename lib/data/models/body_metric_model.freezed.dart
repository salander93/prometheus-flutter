// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'body_metric_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BodyMetric _$BodyMetricFromJson(Map<String, dynamic> json) {
  return _BodyMetric.fromJson(json);
}

/// @nodoc
mixin _$BodyMetric {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'recorded_at')
  String get recordedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  double? get weight => throw _privateConstructorUsedError;
  double? get chest => throw _privateConstructorUsedError;
  double? get waist => throw _privateConstructorUsedError;
  double? get hips => throw _privateConstructorUsedError;
  double? get shoulders => throw _privateConstructorUsedError;
  double? get neck => throw _privateConstructorUsedError;
  @JsonKey(name: 'biceps_left')
  double? get bicepsLeft => throw _privateConstructorUsedError;
  @JsonKey(name: 'biceps_right')
  double? get bicepsRight => throw _privateConstructorUsedError;
  @JsonKey(name: 'thigh_left')
  double? get thighLeft => throw _privateConstructorUsedError;
  @JsonKey(name: 'thigh_right')
  double? get thighRight => throw _privateConstructorUsedError;
  @JsonKey(name: 'calf_left')
  double? get calfLeft => throw _privateConstructorUsedError;
  @JsonKey(name: 'calf_right')
  double? get calfRight => throw _privateConstructorUsedError;
  @JsonKey(name: 'forearm_left')
  double? get forearmLeft => throw _privateConstructorUsedError;
  @JsonKey(name: 'forearm_right')
  double? get forearmRight => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this BodyMetric to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BodyMetric
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BodyMetricCopyWith<BodyMetric> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BodyMetricCopyWith<$Res> {
  factory $BodyMetricCopyWith(
          BodyMetric value, $Res Function(BodyMetric) then) =
      _$BodyMetricCopyWithImpl<$Res, BodyMetric>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'recorded_at') String recordedAt,
      @JsonKey(name: 'created_at') String createdAt,
      double? weight,
      double? chest,
      double? waist,
      double? hips,
      double? shoulders,
      double? neck,
      @JsonKey(name: 'biceps_left') double? bicepsLeft,
      @JsonKey(name: 'biceps_right') double? bicepsRight,
      @JsonKey(name: 'thigh_left') double? thighLeft,
      @JsonKey(name: 'thigh_right') double? thighRight,
      @JsonKey(name: 'calf_left') double? calfLeft,
      @JsonKey(name: 'calf_right') double? calfRight,
      @JsonKey(name: 'forearm_left') double? forearmLeft,
      @JsonKey(name: 'forearm_right') double? forearmRight,
      String? notes});
}

/// @nodoc
class _$BodyMetricCopyWithImpl<$Res, $Val extends BodyMetric>
    implements $BodyMetricCopyWith<$Res> {
  _$BodyMetricCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BodyMetric
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recordedAt = null,
    Object? createdAt = null,
    Object? weight = freezed,
    Object? chest = freezed,
    Object? waist = freezed,
    Object? hips = freezed,
    Object? shoulders = freezed,
    Object? neck = freezed,
    Object? bicepsLeft = freezed,
    Object? bicepsRight = freezed,
    Object? thighLeft = freezed,
    Object? thighRight = freezed,
    Object? calfLeft = freezed,
    Object? calfRight = freezed,
    Object? forearmLeft = freezed,
    Object? forearmRight = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      recordedAt: null == recordedAt
          ? _value.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      chest: freezed == chest
          ? _value.chest
          : chest // ignore: cast_nullable_to_non_nullable
              as double?,
      waist: freezed == waist
          ? _value.waist
          : waist // ignore: cast_nullable_to_non_nullable
              as double?,
      hips: freezed == hips
          ? _value.hips
          : hips // ignore: cast_nullable_to_non_nullable
              as double?,
      shoulders: freezed == shoulders
          ? _value.shoulders
          : shoulders // ignore: cast_nullable_to_non_nullable
              as double?,
      neck: freezed == neck
          ? _value.neck
          : neck // ignore: cast_nullable_to_non_nullable
              as double?,
      bicepsLeft: freezed == bicepsLeft
          ? _value.bicepsLeft
          : bicepsLeft // ignore: cast_nullable_to_non_nullable
              as double?,
      bicepsRight: freezed == bicepsRight
          ? _value.bicepsRight
          : bicepsRight // ignore: cast_nullable_to_non_nullable
              as double?,
      thighLeft: freezed == thighLeft
          ? _value.thighLeft
          : thighLeft // ignore: cast_nullable_to_non_nullable
              as double?,
      thighRight: freezed == thighRight
          ? _value.thighRight
          : thighRight // ignore: cast_nullable_to_non_nullable
              as double?,
      calfLeft: freezed == calfLeft
          ? _value.calfLeft
          : calfLeft // ignore: cast_nullable_to_non_nullable
              as double?,
      calfRight: freezed == calfRight
          ? _value.calfRight
          : calfRight // ignore: cast_nullable_to_non_nullable
              as double?,
      forearmLeft: freezed == forearmLeft
          ? _value.forearmLeft
          : forearmLeft // ignore: cast_nullable_to_non_nullable
              as double?,
      forearmRight: freezed == forearmRight
          ? _value.forearmRight
          : forearmRight // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BodyMetricImplCopyWith<$Res>
    implements $BodyMetricCopyWith<$Res> {
  factory _$$BodyMetricImplCopyWith(
          _$BodyMetricImpl value, $Res Function(_$BodyMetricImpl) then) =
      __$$BodyMetricImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'recorded_at') String recordedAt,
      @JsonKey(name: 'created_at') String createdAt,
      double? weight,
      double? chest,
      double? waist,
      double? hips,
      double? shoulders,
      double? neck,
      @JsonKey(name: 'biceps_left') double? bicepsLeft,
      @JsonKey(name: 'biceps_right') double? bicepsRight,
      @JsonKey(name: 'thigh_left') double? thighLeft,
      @JsonKey(name: 'thigh_right') double? thighRight,
      @JsonKey(name: 'calf_left') double? calfLeft,
      @JsonKey(name: 'calf_right') double? calfRight,
      @JsonKey(name: 'forearm_left') double? forearmLeft,
      @JsonKey(name: 'forearm_right') double? forearmRight,
      String? notes});
}

/// @nodoc
class __$$BodyMetricImplCopyWithImpl<$Res>
    extends _$BodyMetricCopyWithImpl<$Res, _$BodyMetricImpl>
    implements _$$BodyMetricImplCopyWith<$Res> {
  __$$BodyMetricImplCopyWithImpl(
      _$BodyMetricImpl _value, $Res Function(_$BodyMetricImpl) _then)
      : super(_value, _then);

  /// Create a copy of BodyMetric
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recordedAt = null,
    Object? createdAt = null,
    Object? weight = freezed,
    Object? chest = freezed,
    Object? waist = freezed,
    Object? hips = freezed,
    Object? shoulders = freezed,
    Object? neck = freezed,
    Object? bicepsLeft = freezed,
    Object? bicepsRight = freezed,
    Object? thighLeft = freezed,
    Object? thighRight = freezed,
    Object? calfLeft = freezed,
    Object? calfRight = freezed,
    Object? forearmLeft = freezed,
    Object? forearmRight = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$BodyMetricImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      recordedAt: null == recordedAt
          ? _value.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      chest: freezed == chest
          ? _value.chest
          : chest // ignore: cast_nullable_to_non_nullable
              as double?,
      waist: freezed == waist
          ? _value.waist
          : waist // ignore: cast_nullable_to_non_nullable
              as double?,
      hips: freezed == hips
          ? _value.hips
          : hips // ignore: cast_nullable_to_non_nullable
              as double?,
      shoulders: freezed == shoulders
          ? _value.shoulders
          : shoulders // ignore: cast_nullable_to_non_nullable
              as double?,
      neck: freezed == neck
          ? _value.neck
          : neck // ignore: cast_nullable_to_non_nullable
              as double?,
      bicepsLeft: freezed == bicepsLeft
          ? _value.bicepsLeft
          : bicepsLeft // ignore: cast_nullable_to_non_nullable
              as double?,
      bicepsRight: freezed == bicepsRight
          ? _value.bicepsRight
          : bicepsRight // ignore: cast_nullable_to_non_nullable
              as double?,
      thighLeft: freezed == thighLeft
          ? _value.thighLeft
          : thighLeft // ignore: cast_nullable_to_non_nullable
              as double?,
      thighRight: freezed == thighRight
          ? _value.thighRight
          : thighRight // ignore: cast_nullable_to_non_nullable
              as double?,
      calfLeft: freezed == calfLeft
          ? _value.calfLeft
          : calfLeft // ignore: cast_nullable_to_non_nullable
              as double?,
      calfRight: freezed == calfRight
          ? _value.calfRight
          : calfRight // ignore: cast_nullable_to_non_nullable
              as double?,
      forearmLeft: freezed == forearmLeft
          ? _value.forearmLeft
          : forearmLeft // ignore: cast_nullable_to_non_nullable
              as double?,
      forearmRight: freezed == forearmRight
          ? _value.forearmRight
          : forearmRight // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BodyMetricImpl implements _BodyMetric {
  const _$BodyMetricImpl(
      {required this.id,
      @JsonKey(name: 'recorded_at') required this.recordedAt,
      @JsonKey(name: 'created_at') required this.createdAt,
      this.weight,
      this.chest,
      this.waist,
      this.hips,
      this.shoulders,
      this.neck,
      @JsonKey(name: 'biceps_left') this.bicepsLeft,
      @JsonKey(name: 'biceps_right') this.bicepsRight,
      @JsonKey(name: 'thigh_left') this.thighLeft,
      @JsonKey(name: 'thigh_right') this.thighRight,
      @JsonKey(name: 'calf_left') this.calfLeft,
      @JsonKey(name: 'calf_right') this.calfRight,
      @JsonKey(name: 'forearm_left') this.forearmLeft,
      @JsonKey(name: 'forearm_right') this.forearmRight,
      this.notes});

  factory _$BodyMetricImpl.fromJson(Map<String, dynamic> json) =>
      _$$BodyMetricImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'recorded_at')
  final String recordedAt;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  final double? weight;
  @override
  final double? chest;
  @override
  final double? waist;
  @override
  final double? hips;
  @override
  final double? shoulders;
  @override
  final double? neck;
  @override
  @JsonKey(name: 'biceps_left')
  final double? bicepsLeft;
  @override
  @JsonKey(name: 'biceps_right')
  final double? bicepsRight;
  @override
  @JsonKey(name: 'thigh_left')
  final double? thighLeft;
  @override
  @JsonKey(name: 'thigh_right')
  final double? thighRight;
  @override
  @JsonKey(name: 'calf_left')
  final double? calfLeft;
  @override
  @JsonKey(name: 'calf_right')
  final double? calfRight;
  @override
  @JsonKey(name: 'forearm_left')
  final double? forearmLeft;
  @override
  @JsonKey(name: 'forearm_right')
  final double? forearmRight;
  @override
  final String? notes;

  @override
  String toString() {
    return 'BodyMetric(id: $id, recordedAt: $recordedAt, createdAt: $createdAt, weight: $weight, chest: $chest, waist: $waist, hips: $hips, shoulders: $shoulders, neck: $neck, bicepsLeft: $bicepsLeft, bicepsRight: $bicepsRight, thighLeft: $thighLeft, thighRight: $thighRight, calfLeft: $calfLeft, calfRight: $calfRight, forearmLeft: $forearmLeft, forearmRight: $forearmRight, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BodyMetricImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.chest, chest) || other.chest == chest) &&
            (identical(other.waist, waist) || other.waist == waist) &&
            (identical(other.hips, hips) || other.hips == hips) &&
            (identical(other.shoulders, shoulders) ||
                other.shoulders == shoulders) &&
            (identical(other.neck, neck) || other.neck == neck) &&
            (identical(other.bicepsLeft, bicepsLeft) ||
                other.bicepsLeft == bicepsLeft) &&
            (identical(other.bicepsRight, bicepsRight) ||
                other.bicepsRight == bicepsRight) &&
            (identical(other.thighLeft, thighLeft) ||
                other.thighLeft == thighLeft) &&
            (identical(other.thighRight, thighRight) ||
                other.thighRight == thighRight) &&
            (identical(other.calfLeft, calfLeft) ||
                other.calfLeft == calfLeft) &&
            (identical(other.calfRight, calfRight) ||
                other.calfRight == calfRight) &&
            (identical(other.forearmLeft, forearmLeft) ||
                other.forearmLeft == forearmLeft) &&
            (identical(other.forearmRight, forearmRight) ||
                other.forearmRight == forearmRight) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      recordedAt,
      createdAt,
      weight,
      chest,
      waist,
      hips,
      shoulders,
      neck,
      bicepsLeft,
      bicepsRight,
      thighLeft,
      thighRight,
      calfLeft,
      calfRight,
      forearmLeft,
      forearmRight,
      notes);

  /// Create a copy of BodyMetric
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BodyMetricImplCopyWith<_$BodyMetricImpl> get copyWith =>
      __$$BodyMetricImplCopyWithImpl<_$BodyMetricImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BodyMetricImplToJson(
      this,
    );
  }
}

abstract class _BodyMetric implements BodyMetric {
  const factory _BodyMetric(
      {required final int id,
      @JsonKey(name: 'recorded_at') required final String recordedAt,
      @JsonKey(name: 'created_at') required final String createdAt,
      final double? weight,
      final double? chest,
      final double? waist,
      final double? hips,
      final double? shoulders,
      final double? neck,
      @JsonKey(name: 'biceps_left') final double? bicepsLeft,
      @JsonKey(name: 'biceps_right') final double? bicepsRight,
      @JsonKey(name: 'thigh_left') final double? thighLeft,
      @JsonKey(name: 'thigh_right') final double? thighRight,
      @JsonKey(name: 'calf_left') final double? calfLeft,
      @JsonKey(name: 'calf_right') final double? calfRight,
      @JsonKey(name: 'forearm_left') final double? forearmLeft,
      @JsonKey(name: 'forearm_right') final double? forearmRight,
      final String? notes}) = _$BodyMetricImpl;

  factory _BodyMetric.fromJson(Map<String, dynamic> json) =
      _$BodyMetricImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'recorded_at')
  String get recordedAt;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  double? get weight;
  @override
  double? get chest;
  @override
  double? get waist;
  @override
  double? get hips;
  @override
  double? get shoulders;
  @override
  double? get neck;
  @override
  @JsonKey(name: 'biceps_left')
  double? get bicepsLeft;
  @override
  @JsonKey(name: 'biceps_right')
  double? get bicepsRight;
  @override
  @JsonKey(name: 'thigh_left')
  double? get thighLeft;
  @override
  @JsonKey(name: 'thigh_right')
  double? get thighRight;
  @override
  @JsonKey(name: 'calf_left')
  double? get calfLeft;
  @override
  @JsonKey(name: 'calf_right')
  double? get calfRight;
  @override
  @JsonKey(name: 'forearm_left')
  double? get forearmLeft;
  @override
  @JsonKey(name: 'forearm_right')
  double? get forearmRight;
  @override
  String? get notes;

  /// Create a copy of BodyMetric
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BodyMetricImplCopyWith<_$BodyMetricImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
