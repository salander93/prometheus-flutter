// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkoutPlanSummary _$WorkoutPlanSummaryFromJson(Map<String, dynamic> json) {
  return _WorkoutPlanSummary.fromJson(json);
}

/// @nodoc
mixin _$WorkoutPlanSummary {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get trainer => throw _privateConstructorUsedError;
  @JsonKey(name: 'trainer_name')
  String get trainerName => throw _privateConstructorUsedError;
  int get client => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_name')
  String get clientName => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_weeks')
  int get durationWeeks => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_week')
  int get currentWeek => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this WorkoutPlanSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutPlanSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutPlanSummaryCopyWith<WorkoutPlanSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutPlanSummaryCopyWith<$Res> {
  factory $WorkoutPlanSummaryCopyWith(
          WorkoutPlanSummary value, $Res Function(WorkoutPlanSummary) then) =
      _$WorkoutPlanSummaryCopyWithImpl<$Res, WorkoutPlanSummary>;
  @useResult
  $Res call(
      {int id,
      String name,
      int trainer,
      @JsonKey(name: 'trainer_name') String trainerName,
      int client,
      @JsonKey(name: 'client_name') String clientName,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'duration_weeks') int durationWeeks,
      @JsonKey(name: 'current_week') int currentWeek,
      @JsonKey(name: 'created_at') String createdAt,
      String? description});
}

/// @nodoc
class _$WorkoutPlanSummaryCopyWithImpl<$Res, $Val extends WorkoutPlanSummary>
    implements $WorkoutPlanSummaryCopyWith<$Res> {
  _$WorkoutPlanSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutPlanSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? trainer = null,
    Object? trainerName = null,
    Object? client = null,
    Object? clientName = null,
    Object? isActive = null,
    Object? durationWeeks = null,
    Object? currentWeek = null,
    Object? createdAt = null,
    Object? description = freezed,
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
      durationWeeks: null == durationWeeks
          ? _value.durationWeeks
          : durationWeeks // ignore: cast_nullable_to_non_nullable
              as int,
      currentWeek: null == currentWeek
          ? _value.currentWeek
          : currentWeek // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutPlanSummaryImplCopyWith<$Res>
    implements $WorkoutPlanSummaryCopyWith<$Res> {
  factory _$$WorkoutPlanSummaryImplCopyWith(_$WorkoutPlanSummaryImpl value,
          $Res Function(_$WorkoutPlanSummaryImpl) then) =
      __$$WorkoutPlanSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      int trainer,
      @JsonKey(name: 'trainer_name') String trainerName,
      int client,
      @JsonKey(name: 'client_name') String clientName,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'duration_weeks') int durationWeeks,
      @JsonKey(name: 'current_week') int currentWeek,
      @JsonKey(name: 'created_at') String createdAt,
      String? description});
}

/// @nodoc
class __$$WorkoutPlanSummaryImplCopyWithImpl<$Res>
    extends _$WorkoutPlanSummaryCopyWithImpl<$Res, _$WorkoutPlanSummaryImpl>
    implements _$$WorkoutPlanSummaryImplCopyWith<$Res> {
  __$$WorkoutPlanSummaryImplCopyWithImpl(_$WorkoutPlanSummaryImpl _value,
      $Res Function(_$WorkoutPlanSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutPlanSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? trainer = null,
    Object? trainerName = null,
    Object? client = null,
    Object? clientName = null,
    Object? isActive = null,
    Object? durationWeeks = null,
    Object? currentWeek = null,
    Object? createdAt = null,
    Object? description = freezed,
  }) {
    return _then(_$WorkoutPlanSummaryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
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
      durationWeeks: null == durationWeeks
          ? _value.durationWeeks
          : durationWeeks // ignore: cast_nullable_to_non_nullable
              as int,
      currentWeek: null == currentWeek
          ? _value.currentWeek
          : currentWeek // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutPlanSummaryImpl implements _WorkoutPlanSummary {
  const _$WorkoutPlanSummaryImpl(
      {required this.id,
      required this.name,
      required this.trainer,
      @JsonKey(name: 'trainer_name') required this.trainerName,
      required this.client,
      @JsonKey(name: 'client_name') required this.clientName,
      @JsonKey(name: 'is_active') required this.isActive,
      @JsonKey(name: 'duration_weeks') required this.durationWeeks,
      @JsonKey(name: 'current_week') required this.currentWeek,
      @JsonKey(name: 'created_at') required this.createdAt,
      this.description});

  factory _$WorkoutPlanSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutPlanSummaryImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
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
  @JsonKey(name: 'duration_weeks')
  final int durationWeeks;
  @override
  @JsonKey(name: 'current_week')
  final int currentWeek;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  final String? description;

  @override
  String toString() {
    return 'WorkoutPlanSummary(id: $id, name: $name, trainer: $trainer, trainerName: $trainerName, client: $client, clientName: $clientName, isActive: $isActive, durationWeeks: $durationWeeks, currentWeek: $currentWeek, createdAt: $createdAt, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutPlanSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.trainer, trainer) || other.trainer == trainer) &&
            (identical(other.trainerName, trainerName) ||
                other.trainerName == trainerName) &&
            (identical(other.client, client) || other.client == client) &&
            (identical(other.clientName, clientName) ||
                other.clientName == clientName) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.durationWeeks, durationWeeks) ||
                other.durationWeeks == durationWeeks) &&
            (identical(other.currentWeek, currentWeek) ||
                other.currentWeek == currentWeek) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      trainer,
      trainerName,
      client,
      clientName,
      isActive,
      durationWeeks,
      currentWeek,
      createdAt,
      description);

  /// Create a copy of WorkoutPlanSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutPlanSummaryImplCopyWith<_$WorkoutPlanSummaryImpl> get copyWith =>
      __$$WorkoutPlanSummaryImplCopyWithImpl<_$WorkoutPlanSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutPlanSummaryImplToJson(
      this,
    );
  }
}

abstract class _WorkoutPlanSummary implements WorkoutPlanSummary {
  const factory _WorkoutPlanSummary(
      {required final int id,
      required final String name,
      required final int trainer,
      @JsonKey(name: 'trainer_name') required final String trainerName,
      required final int client,
      @JsonKey(name: 'client_name') required final String clientName,
      @JsonKey(name: 'is_active') required final bool isActive,
      @JsonKey(name: 'duration_weeks') required final int durationWeeks,
      @JsonKey(name: 'current_week') required final int currentWeek,
      @JsonKey(name: 'created_at') required final String createdAt,
      final String? description}) = _$WorkoutPlanSummaryImpl;

  factory _WorkoutPlanSummary.fromJson(Map<String, dynamic> json) =
      _$WorkoutPlanSummaryImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
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
  @JsonKey(name: 'duration_weeks')
  int get durationWeeks;
  @override
  @JsonKey(name: 'current_week')
  int get currentWeek;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  String? get description;

  /// Create a copy of WorkoutPlanSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutPlanSummaryImplCopyWith<_$WorkoutPlanSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkoutExecution _$WorkoutExecutionFromJson(Map<String, dynamic> json) {
  return _WorkoutExecution.fromJson(json);
}

/// @nodoc
mixin _$WorkoutExecution {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_name')
  String? get sessionName => throw _privateConstructorUsedError;
  @JsonKey(name: 'plan_name')
  String? get planName => throw _privateConstructorUsedError;
  @JsonKey(name: 'week_number')
  int? get weekNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'started_at')
  String? get startedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  String? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this WorkoutExecution to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutExecution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutExecutionCopyWith<WorkoutExecution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutExecutionCopyWith<$Res> {
  factory $WorkoutExecutionCopyWith(
          WorkoutExecution value, $Res Function(WorkoutExecution) then) =
      _$WorkoutExecutionCopyWithImpl<$Res, WorkoutExecution>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'session_name') String? sessionName,
      @JsonKey(name: 'plan_name') String? planName,
      @JsonKey(name: 'week_number') int? weekNumber,
      @JsonKey(name: 'started_at') String? startedAt,
      @JsonKey(name: 'completed_at') String? completedAt});
}

/// @nodoc
class _$WorkoutExecutionCopyWithImpl<$Res, $Val extends WorkoutExecution>
    implements $WorkoutExecutionCopyWith<$Res> {
  _$WorkoutExecutionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutExecution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionName = freezed,
    Object? planName = freezed,
    Object? weekNumber = freezed,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      sessionName: freezed == sessionName
          ? _value.sessionName
          : sessionName // ignore: cast_nullable_to_non_nullable
              as String?,
      planName: freezed == planName
          ? _value.planName
          : planName // ignore: cast_nullable_to_non_nullable
              as String?,
      weekNumber: freezed == weekNumber
          ? _value.weekNumber
          : weekNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutExecutionImplCopyWith<$Res>
    implements $WorkoutExecutionCopyWith<$Res> {
  factory _$$WorkoutExecutionImplCopyWith(_$WorkoutExecutionImpl value,
          $Res Function(_$WorkoutExecutionImpl) then) =
      __$$WorkoutExecutionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'session_name') String? sessionName,
      @JsonKey(name: 'plan_name') String? planName,
      @JsonKey(name: 'week_number') int? weekNumber,
      @JsonKey(name: 'started_at') String? startedAt,
      @JsonKey(name: 'completed_at') String? completedAt});
}

/// @nodoc
class __$$WorkoutExecutionImplCopyWithImpl<$Res>
    extends _$WorkoutExecutionCopyWithImpl<$Res, _$WorkoutExecutionImpl>
    implements _$$WorkoutExecutionImplCopyWith<$Res> {
  __$$WorkoutExecutionImplCopyWithImpl(_$WorkoutExecutionImpl _value,
      $Res Function(_$WorkoutExecutionImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutExecution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionName = freezed,
    Object? planName = freezed,
    Object? weekNumber = freezed,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_$WorkoutExecutionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      sessionName: freezed == sessionName
          ? _value.sessionName
          : sessionName // ignore: cast_nullable_to_non_nullable
              as String?,
      planName: freezed == planName
          ? _value.planName
          : planName // ignore: cast_nullable_to_non_nullable
              as String?,
      weekNumber: freezed == weekNumber
          ? _value.weekNumber
          : weekNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutExecutionImpl implements _WorkoutExecution {
  const _$WorkoutExecutionImpl(
      {required this.id,
      @JsonKey(name: 'session_name') this.sessionName,
      @JsonKey(name: 'plan_name') this.planName,
      @JsonKey(name: 'week_number') this.weekNumber,
      @JsonKey(name: 'started_at') this.startedAt,
      @JsonKey(name: 'completed_at') this.completedAt});

  factory _$WorkoutExecutionImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutExecutionImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'session_name')
  final String? sessionName;
  @override
  @JsonKey(name: 'plan_name')
  final String? planName;
  @override
  @JsonKey(name: 'week_number')
  final int? weekNumber;
  @override
  @JsonKey(name: 'started_at')
  final String? startedAt;
  @override
  @JsonKey(name: 'completed_at')
  final String? completedAt;

  @override
  String toString() {
    return 'WorkoutExecution(id: $id, sessionName: $sessionName, planName: $planName, weekNumber: $weekNumber, startedAt: $startedAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutExecutionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionName, sessionName) ||
                other.sessionName == sessionName) &&
            (identical(other.planName, planName) ||
                other.planName == planName) &&
            (identical(other.weekNumber, weekNumber) ||
                other.weekNumber == weekNumber) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, sessionName, planName,
      weekNumber, startedAt, completedAt);

  /// Create a copy of WorkoutExecution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutExecutionImplCopyWith<_$WorkoutExecutionImpl> get copyWith =>
      __$$WorkoutExecutionImplCopyWithImpl<_$WorkoutExecutionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutExecutionImplToJson(
      this,
    );
  }
}

abstract class _WorkoutExecution implements WorkoutExecution {
  const factory _WorkoutExecution(
          {required final int id,
          @JsonKey(name: 'session_name') final String? sessionName,
          @JsonKey(name: 'plan_name') final String? planName,
          @JsonKey(name: 'week_number') final int? weekNumber,
          @JsonKey(name: 'started_at') final String? startedAt,
          @JsonKey(name: 'completed_at') final String? completedAt}) =
      _$WorkoutExecutionImpl;

  factory _WorkoutExecution.fromJson(Map<String, dynamic> json) =
      _$WorkoutExecutionImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'session_name')
  String? get sessionName;
  @override
  @JsonKey(name: 'plan_name')
  String? get planName;
  @override
  @JsonKey(name: 'week_number')
  int? get weekNumber;
  @override
  @JsonKey(name: 'started_at')
  String? get startedAt;
  @override
  @JsonKey(name: 'completed_at')
  String? get completedAt;

  /// Create a copy of WorkoutExecution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutExecutionImplCopyWith<_$WorkoutExecutionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CalendarData _$CalendarDataFromJson(Map<String, dynamic> json) {
  return _CalendarData.fromJson(json);
}

/// @nodoc
mixin _$CalendarData {
  int get year => throw _privateConstructorUsedError;
  int get month => throw _privateConstructorUsedError;
  @JsonKey(name: 'training_days')
  Map<String, List<dynamic>> get trainingDays =>
      throw _privateConstructorUsedError;

  /// Serializes this CalendarData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CalendarData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalendarDataCopyWith<CalendarData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarDataCopyWith<$Res> {
  factory $CalendarDataCopyWith(
          CalendarData value, $Res Function(CalendarData) then) =
      _$CalendarDataCopyWithImpl<$Res, CalendarData>;
  @useResult
  $Res call(
      {int year,
      int month,
      @JsonKey(name: 'training_days') Map<String, List<dynamic>> trainingDays});
}

/// @nodoc
class _$CalendarDataCopyWithImpl<$Res, $Val extends CalendarData>
    implements $CalendarDataCopyWith<$Res> {
  _$CalendarDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalendarData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? trainingDays = null,
  }) {
    return _then(_value.copyWith(
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      trainingDays: null == trainingDays
          ? _value.trainingDays
          : trainingDays // ignore: cast_nullable_to_non_nullable
              as Map<String, List<dynamic>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CalendarDataImplCopyWith<$Res>
    implements $CalendarDataCopyWith<$Res> {
  factory _$$CalendarDataImplCopyWith(
          _$CalendarDataImpl value, $Res Function(_$CalendarDataImpl) then) =
      __$$CalendarDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int year,
      int month,
      @JsonKey(name: 'training_days') Map<String, List<dynamic>> trainingDays});
}

/// @nodoc
class __$$CalendarDataImplCopyWithImpl<$Res>
    extends _$CalendarDataCopyWithImpl<$Res, _$CalendarDataImpl>
    implements _$$CalendarDataImplCopyWith<$Res> {
  __$$CalendarDataImplCopyWithImpl(
      _$CalendarDataImpl _value, $Res Function(_$CalendarDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of CalendarData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? trainingDays = null,
  }) {
    return _then(_$CalendarDataImpl(
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      trainingDays: null == trainingDays
          ? _value._trainingDays
          : trainingDays // ignore: cast_nullable_to_non_nullable
              as Map<String, List<dynamic>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CalendarDataImpl implements _CalendarData {
  const _$CalendarDataImpl(
      {required this.year,
      required this.month,
      @JsonKey(name: 'training_days')
      final Map<String, List<dynamic>> trainingDays =
          const <String, List<dynamic>>{}})
      : _trainingDays = trainingDays;

  factory _$CalendarDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CalendarDataImplFromJson(json);

  @override
  final int year;
  @override
  final int month;
  final Map<String, List<dynamic>> _trainingDays;
  @override
  @JsonKey(name: 'training_days')
  Map<String, List<dynamic>> get trainingDays {
    if (_trainingDays is EqualUnmodifiableMapView) return _trainingDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_trainingDays);
  }

  @override
  String toString() {
    return 'CalendarData(year: $year, month: $month, trainingDays: $trainingDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarDataImpl &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            const DeepCollectionEquality()
                .equals(other._trainingDays, _trainingDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, year, month,
      const DeepCollectionEquality().hash(_trainingDays));

  /// Create a copy of CalendarData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarDataImplCopyWith<_$CalendarDataImpl> get copyWith =>
      __$$CalendarDataImplCopyWithImpl<_$CalendarDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CalendarDataImplToJson(
      this,
    );
  }
}

abstract class _CalendarData implements CalendarData {
  const factory _CalendarData(
      {required final int year,
      required final int month,
      @JsonKey(name: 'training_days')
      final Map<String, List<dynamic>> trainingDays}) = _$CalendarDataImpl;

  factory _CalendarData.fromJson(Map<String, dynamic> json) =
      _$CalendarDataImpl.fromJson;

  @override
  int get year;
  @override
  int get month;
  @override
  @JsonKey(name: 'training_days')
  Map<String, List<dynamic>> get trainingDays;

  /// Create a copy of CalendarData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalendarDataImplCopyWith<_$CalendarDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityLogSummary _$ActivityLogSummaryFromJson(Map<String, dynamic> json) {
  return _ActivityLogSummary.fromJson(json);
}

/// @nodoc
mixin _$ActivityLogSummary {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_name')
  String get clientName => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_minutes')
  int? get durationMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'feeling_display')
  String? get feelingDisplay => throw _privateConstructorUsedError;

  /// Serializes this ActivityLogSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityLogSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityLogSummaryCopyWith<ActivityLogSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityLogSummaryCopyWith<$Res> {
  factory $ActivityLogSummaryCopyWith(
          ActivityLogSummary value, $Res Function(ActivityLogSummary) then) =
      _$ActivityLogSummaryCopyWithImpl<$Res, ActivityLogSummary>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'client_name') String clientName,
      String date,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'duration_minutes') int? durationMinutes,
      @JsonKey(name: 'feeling_display') String? feelingDisplay});
}

/// @nodoc
class _$ActivityLogSummaryCopyWithImpl<$Res, $Val extends ActivityLogSummary>
    implements $ActivityLogSummaryCopyWith<$Res> {
  _$ActivityLogSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityLogSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientName = null,
    Object? date = null,
    Object? createdAt = null,
    Object? durationMinutes = freezed,
    Object? feelingDisplay = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      clientName: null == clientName
          ? _value.clientName
          : clientName // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      durationMinutes: freezed == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      feelingDisplay: freezed == feelingDisplay
          ? _value.feelingDisplay
          : feelingDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityLogSummaryImplCopyWith<$Res>
    implements $ActivityLogSummaryCopyWith<$Res> {
  factory _$$ActivityLogSummaryImplCopyWith(_$ActivityLogSummaryImpl value,
          $Res Function(_$ActivityLogSummaryImpl) then) =
      __$$ActivityLogSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'client_name') String clientName,
      String date,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'duration_minutes') int? durationMinutes,
      @JsonKey(name: 'feeling_display') String? feelingDisplay});
}

/// @nodoc
class __$$ActivityLogSummaryImplCopyWithImpl<$Res>
    extends _$ActivityLogSummaryCopyWithImpl<$Res, _$ActivityLogSummaryImpl>
    implements _$$ActivityLogSummaryImplCopyWith<$Res> {
  __$$ActivityLogSummaryImplCopyWithImpl(_$ActivityLogSummaryImpl _value,
      $Res Function(_$ActivityLogSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActivityLogSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientName = null,
    Object? date = null,
    Object? createdAt = null,
    Object? durationMinutes = freezed,
    Object? feelingDisplay = freezed,
  }) {
    return _then(_$ActivityLogSummaryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      clientName: null == clientName
          ? _value.clientName
          : clientName // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      durationMinutes: freezed == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      feelingDisplay: freezed == feelingDisplay
          ? _value.feelingDisplay
          : feelingDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityLogSummaryImpl implements _ActivityLogSummary {
  const _$ActivityLogSummaryImpl(
      {required this.id,
      @JsonKey(name: 'client_name') required this.clientName,
      required this.date,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'duration_minutes') this.durationMinutes,
      @JsonKey(name: 'feeling_display') this.feelingDisplay});

  factory _$ActivityLogSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityLogSummaryImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'client_name')
  final String clientName;
  @override
  final String date;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'duration_minutes')
  final int? durationMinutes;
  @override
  @JsonKey(name: 'feeling_display')
  final String? feelingDisplay;

  @override
  String toString() {
    return 'ActivityLogSummary(id: $id, clientName: $clientName, date: $date, createdAt: $createdAt, durationMinutes: $durationMinutes, feelingDisplay: $feelingDisplay)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityLogSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientName, clientName) ||
                other.clientName == clientName) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.feelingDisplay, feelingDisplay) ||
                other.feelingDisplay == feelingDisplay));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, clientName, date, createdAt,
      durationMinutes, feelingDisplay);

  /// Create a copy of ActivityLogSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityLogSummaryImplCopyWith<_$ActivityLogSummaryImpl> get copyWith =>
      __$$ActivityLogSummaryImplCopyWithImpl<_$ActivityLogSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityLogSummaryImplToJson(
      this,
    );
  }
}

abstract class _ActivityLogSummary implements ActivityLogSummary {
  const factory _ActivityLogSummary(
          {required final int id,
          @JsonKey(name: 'client_name') required final String clientName,
          required final String date,
          @JsonKey(name: 'created_at') required final String createdAt,
          @JsonKey(name: 'duration_minutes') final int? durationMinutes,
          @JsonKey(name: 'feeling_display') final String? feelingDisplay}) =
      _$ActivityLogSummaryImpl;

  factory _ActivityLogSummary.fromJson(Map<String, dynamic> json) =
      _$ActivityLogSummaryImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'client_name')
  String get clientName;
  @override
  String get date;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'duration_minutes')
  int? get durationMinutes;
  @override
  @JsonKey(name: 'feeling_display')
  String? get feelingDisplay;

  /// Create a copy of ActivityLogSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityLogSummaryImplCopyWith<_$ActivityLogSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
