// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_plan_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkoutPlanDetail _$WorkoutPlanDetailFromJson(Map<String, dynamic> json) {
  return _WorkoutPlanDetail.fromJson(json);
}

/// @nodoc
mixin _$WorkoutPlanDetail {
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
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date')
  String? get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  String? get endDate => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<WorkoutSession> get sessions => throw _privateConstructorUsedError;

  /// Serializes this WorkoutPlanDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutPlanDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutPlanDetailCopyWith<WorkoutPlanDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutPlanDetailCopyWith<$Res> {
  factory $WorkoutPlanDetailCopyWith(
          WorkoutPlanDetail value, $Res Function(WorkoutPlanDetail) then) =
      _$WorkoutPlanDetailCopyWithImpl<$Res, WorkoutPlanDetail>;
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
      @JsonKey(name: 'updated_at') String updatedAt,
      String? description,
      @JsonKey(name: 'start_date') String? startDate,
      @JsonKey(name: 'end_date') String? endDate,
      String? notes,
      List<WorkoutSession> sessions});
}

/// @nodoc
class _$WorkoutPlanDetailCopyWithImpl<$Res, $Val extends WorkoutPlanDetail>
    implements $WorkoutPlanDetailCopyWith<$Res> {
  _$WorkoutPlanDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutPlanDetail
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
    Object? updatedAt = null,
    Object? description = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? notes = freezed,
    Object? sessions = null,
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
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      sessions: null == sessions
          ? _value.sessions
          : sessions // ignore: cast_nullable_to_non_nullable
              as List<WorkoutSession>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutPlanDetailImplCopyWith<$Res>
    implements $WorkoutPlanDetailCopyWith<$Res> {
  factory _$$WorkoutPlanDetailImplCopyWith(_$WorkoutPlanDetailImpl value,
          $Res Function(_$WorkoutPlanDetailImpl) then) =
      __$$WorkoutPlanDetailImplCopyWithImpl<$Res>;
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
      @JsonKey(name: 'updated_at') String updatedAt,
      String? description,
      @JsonKey(name: 'start_date') String? startDate,
      @JsonKey(name: 'end_date') String? endDate,
      String? notes,
      List<WorkoutSession> sessions});
}

/// @nodoc
class __$$WorkoutPlanDetailImplCopyWithImpl<$Res>
    extends _$WorkoutPlanDetailCopyWithImpl<$Res, _$WorkoutPlanDetailImpl>
    implements _$$WorkoutPlanDetailImplCopyWith<$Res> {
  __$$WorkoutPlanDetailImplCopyWithImpl(_$WorkoutPlanDetailImpl _value,
      $Res Function(_$WorkoutPlanDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutPlanDetail
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
    Object? updatedAt = null,
    Object? description = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? notes = freezed,
    Object? sessions = null,
  }) {
    return _then(_$WorkoutPlanDetailImpl(
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
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      sessions: null == sessions
          ? _value._sessions
          : sessions // ignore: cast_nullable_to_non_nullable
              as List<WorkoutSession>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutPlanDetailImpl implements _WorkoutPlanDetail {
  const _$WorkoutPlanDetailImpl(
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
      @JsonKey(name: 'updated_at') required this.updatedAt,
      this.description,
      @JsonKey(name: 'start_date') this.startDate,
      @JsonKey(name: 'end_date') this.endDate,
      this.notes,
      final List<WorkoutSession> sessions = const []})
      : _sessions = sessions;

  factory _$WorkoutPlanDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutPlanDetailImplFromJson(json);

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
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @override
  final String? description;
  @override
  @JsonKey(name: 'start_date')
  final String? startDate;
  @override
  @JsonKey(name: 'end_date')
  final String? endDate;
  @override
  final String? notes;
  final List<WorkoutSession> _sessions;
  @override
  @JsonKey()
  List<WorkoutSession> get sessions {
    if (_sessions is EqualUnmodifiableListView) return _sessions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sessions);
  }

  @override
  String toString() {
    return 'WorkoutPlanDetail(id: $id, name: $name, trainer: $trainer, trainerName: $trainerName, client: $client, clientName: $clientName, isActive: $isActive, durationWeeks: $durationWeeks, currentWeek: $currentWeek, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, startDate: $startDate, endDate: $endDate, notes: $notes, sessions: $sessions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutPlanDetailImpl &&
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
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._sessions, _sessions));
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
      updatedAt,
      description,
      startDate,
      endDate,
      notes,
      const DeepCollectionEquality().hash(_sessions));

  /// Create a copy of WorkoutPlanDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutPlanDetailImplCopyWith<_$WorkoutPlanDetailImpl> get copyWith =>
      __$$WorkoutPlanDetailImplCopyWithImpl<_$WorkoutPlanDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutPlanDetailImplToJson(
      this,
    );
  }
}

abstract class _WorkoutPlanDetail implements WorkoutPlanDetail {
  const factory _WorkoutPlanDetail(
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
      @JsonKey(name: 'updated_at') required final String updatedAt,
      final String? description,
      @JsonKey(name: 'start_date') final String? startDate,
      @JsonKey(name: 'end_date') final String? endDate,
      final String? notes,
      final List<WorkoutSession> sessions}) = _$WorkoutPlanDetailImpl;

  factory _WorkoutPlanDetail.fromJson(Map<String, dynamic> json) =
      _$WorkoutPlanDetailImpl.fromJson;

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
  @JsonKey(name: 'updated_at')
  String get updatedAt;
  @override
  String? get description;
  @override
  @JsonKey(name: 'start_date')
  String? get startDate;
  @override
  @JsonKey(name: 'end_date')
  String? get endDate;
  @override
  String? get notes;
  @override
  List<WorkoutSession> get sessions;

  /// Create a copy of WorkoutPlanDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutPlanDetailImplCopyWith<_$WorkoutPlanDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkoutSession _$WorkoutSessionFromJson(Map<String, dynamic> json) {
  return _WorkoutSession.fromJson(json);
}

/// @nodoc
mixin _$WorkoutSession {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<SessionExercise> get exercises => throw _privateConstructorUsedError;

  /// Serializes this WorkoutSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutSessionCopyWith<WorkoutSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutSessionCopyWith<$Res> {
  factory $WorkoutSessionCopyWith(
          WorkoutSession value, $Res Function(WorkoutSession) then) =
      _$WorkoutSessionCopyWithImpl<$Res, WorkoutSession>;
  @useResult
  $Res call(
      {int id,
      String name,
      int order,
      String? description,
      List<SessionExercise> exercises});
}

/// @nodoc
class _$WorkoutSessionCopyWithImpl<$Res, $Val extends WorkoutSession>
    implements $WorkoutSessionCopyWith<$Res> {
  _$WorkoutSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? order = null,
    Object? description = freezed,
    Object? exercises = null,
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
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      exercises: null == exercises
          ? _value.exercises
          : exercises // ignore: cast_nullable_to_non_nullable
              as List<SessionExercise>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutSessionImplCopyWith<$Res>
    implements $WorkoutSessionCopyWith<$Res> {
  factory _$$WorkoutSessionImplCopyWith(_$WorkoutSessionImpl value,
          $Res Function(_$WorkoutSessionImpl) then) =
      __$$WorkoutSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      int order,
      String? description,
      List<SessionExercise> exercises});
}

/// @nodoc
class __$$WorkoutSessionImplCopyWithImpl<$Res>
    extends _$WorkoutSessionCopyWithImpl<$Res, _$WorkoutSessionImpl>
    implements _$$WorkoutSessionImplCopyWith<$Res> {
  __$$WorkoutSessionImplCopyWithImpl(
      _$WorkoutSessionImpl _value, $Res Function(_$WorkoutSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? order = null,
    Object? description = freezed,
    Object? exercises = null,
  }) {
    return _then(_$WorkoutSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      exercises: null == exercises
          ? _value._exercises
          : exercises // ignore: cast_nullable_to_non_nullable
              as List<SessionExercise>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutSessionImpl implements _WorkoutSession {
  const _$WorkoutSessionImpl(
      {required this.id,
      required this.name,
      required this.order,
      this.description,
      final List<SessionExercise> exercises = const []})
      : _exercises = exercises;

  factory _$WorkoutSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutSessionImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final int order;
  @override
  final String? description;
  final List<SessionExercise> _exercises;
  @override
  @JsonKey()
  List<SessionExercise> get exercises {
    if (_exercises is EqualUnmodifiableListView) return _exercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exercises);
  }

  @override
  String toString() {
    return 'WorkoutSession(id: $id, name: $name, order: $order, description: $description, exercises: $exercises)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._exercises, _exercises));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, order, description,
      const DeepCollectionEquality().hash(_exercises));

  /// Create a copy of WorkoutSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutSessionImplCopyWith<_$WorkoutSessionImpl> get copyWith =>
      __$$WorkoutSessionImplCopyWithImpl<_$WorkoutSessionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutSessionImplToJson(
      this,
    );
  }
}

abstract class _WorkoutSession implements WorkoutSession {
  const factory _WorkoutSession(
      {required final int id,
      required final String name,
      required final int order,
      final String? description,
      final List<SessionExercise> exercises}) = _$WorkoutSessionImpl;

  factory _WorkoutSession.fromJson(Map<String, dynamic> json) =
      _$WorkoutSessionImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  int get order;
  @override
  String? get description;
  @override
  List<SessionExercise> get exercises;

  /// Create a copy of WorkoutSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutSessionImplCopyWith<_$WorkoutSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SessionExercise _$SessionExerciseFromJson(Map<String, dynamic> json) {
  return _SessionExercise.fromJson(json);
}

/// @nodoc
mixin _$SessionExercise {
  int get id => throw _privateConstructorUsedError;
  int get exercise => throw _privateConstructorUsedError;
  @JsonKey(name: 'exercise_name')
  String get exerciseName => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  int get sets => throw _privateConstructorUsedError;
  String get reps => throw _privateConstructorUsedError;
  @JsonKey(name: 'rest_time')
  String get restTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'exercise_description')
  String? get exerciseDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'exercise_image')
  String? get exerciseImage => throw _privateConstructorUsedError;
  @JsonKey(name: 'exercise_video_url')
  String? get exerciseVideoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'exercise_muscle_group')
  String? get exerciseMuscleGroup => throw _privateConstructorUsedError;
  @JsonKey(name: 'exercise_muscle_group_display')
  String? get exerciseMuscleGroupDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'weight_kg')
  double? get weightKg => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_pyramid')
  bool get isPyramid => throw _privateConstructorUsedError;
  @JsonKey(name: 'set_details')
  Map<String, dynamic>? get setDetails => throw _privateConstructorUsedError;
  @JsonKey(name: 'weekly_progressions')
  List<WeeklyProgression> get weeklyProgressions =>
      throw _privateConstructorUsedError;

  /// Serializes this SessionExercise to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionExercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionExerciseCopyWith<SessionExercise> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionExerciseCopyWith<$Res> {
  factory $SessionExerciseCopyWith(
          SessionExercise value, $Res Function(SessionExercise) then) =
      _$SessionExerciseCopyWithImpl<$Res, SessionExercise>;
  @useResult
  $Res call(
      {int id,
      int exercise,
      @JsonKey(name: 'exercise_name') String exerciseName,
      int order,
      int sets,
      String reps,
      @JsonKey(name: 'rest_time') String restTime,
      @JsonKey(name: 'exercise_description') String? exerciseDescription,
      @JsonKey(name: 'exercise_image') String? exerciseImage,
      @JsonKey(name: 'exercise_video_url') String? exerciseVideoUrl,
      @JsonKey(name: 'exercise_muscle_group') String? exerciseMuscleGroup,
      @JsonKey(name: 'exercise_muscle_group_display')
      String? exerciseMuscleGroupDisplay,
      @JsonKey(name: 'weight_kg') double? weightKg,
      String notes,
      @JsonKey(name: 'is_pyramid') bool isPyramid,
      @JsonKey(name: 'set_details') Map<String, dynamic>? setDetails,
      @JsonKey(name: 'weekly_progressions')
      List<WeeklyProgression> weeklyProgressions});
}

/// @nodoc
class _$SessionExerciseCopyWithImpl<$Res, $Val extends SessionExercise>
    implements $SessionExerciseCopyWith<$Res> {
  _$SessionExerciseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionExercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? exercise = null,
    Object? exerciseName = null,
    Object? order = null,
    Object? sets = null,
    Object? reps = null,
    Object? restTime = null,
    Object? exerciseDescription = freezed,
    Object? exerciseImage = freezed,
    Object? exerciseVideoUrl = freezed,
    Object? exerciseMuscleGroup = freezed,
    Object? exerciseMuscleGroupDisplay = freezed,
    Object? weightKg = freezed,
    Object? notes = null,
    Object? isPyramid = null,
    Object? setDetails = freezed,
    Object? weeklyProgressions = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      exercise: null == exercise
          ? _value.exercise
          : exercise // ignore: cast_nullable_to_non_nullable
              as int,
      exerciseName: null == exerciseName
          ? _value.exerciseName
          : exerciseName // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      sets: null == sets
          ? _value.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as int,
      reps: null == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as String,
      restTime: null == restTime
          ? _value.restTime
          : restTime // ignore: cast_nullable_to_non_nullable
              as String,
      exerciseDescription: freezed == exerciseDescription
          ? _value.exerciseDescription
          : exerciseDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      exerciseImage: freezed == exerciseImage
          ? _value.exerciseImage
          : exerciseImage // ignore: cast_nullable_to_non_nullable
              as String?,
      exerciseVideoUrl: freezed == exerciseVideoUrl
          ? _value.exerciseVideoUrl
          : exerciseVideoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      exerciseMuscleGroup: freezed == exerciseMuscleGroup
          ? _value.exerciseMuscleGroup
          : exerciseMuscleGroup // ignore: cast_nullable_to_non_nullable
              as String?,
      exerciseMuscleGroupDisplay: freezed == exerciseMuscleGroupDisplay
          ? _value.exerciseMuscleGroupDisplay
          : exerciseMuscleGroupDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      weightKg: freezed == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      isPyramid: null == isPyramid
          ? _value.isPyramid
          : isPyramid // ignore: cast_nullable_to_non_nullable
              as bool,
      setDetails: freezed == setDetails
          ? _value.setDetails
          : setDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      weeklyProgressions: null == weeklyProgressions
          ? _value.weeklyProgressions
          : weeklyProgressions // ignore: cast_nullable_to_non_nullable
              as List<WeeklyProgression>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionExerciseImplCopyWith<$Res>
    implements $SessionExerciseCopyWith<$Res> {
  factory _$$SessionExerciseImplCopyWith(_$SessionExerciseImpl value,
          $Res Function(_$SessionExerciseImpl) then) =
      __$$SessionExerciseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int exercise,
      @JsonKey(name: 'exercise_name') String exerciseName,
      int order,
      int sets,
      String reps,
      @JsonKey(name: 'rest_time') String restTime,
      @JsonKey(name: 'exercise_description') String? exerciseDescription,
      @JsonKey(name: 'exercise_image') String? exerciseImage,
      @JsonKey(name: 'exercise_video_url') String? exerciseVideoUrl,
      @JsonKey(name: 'exercise_muscle_group') String? exerciseMuscleGroup,
      @JsonKey(name: 'exercise_muscle_group_display')
      String? exerciseMuscleGroupDisplay,
      @JsonKey(name: 'weight_kg') double? weightKg,
      String notes,
      @JsonKey(name: 'is_pyramid') bool isPyramid,
      @JsonKey(name: 'set_details') Map<String, dynamic>? setDetails,
      @JsonKey(name: 'weekly_progressions')
      List<WeeklyProgression> weeklyProgressions});
}

/// @nodoc
class __$$SessionExerciseImplCopyWithImpl<$Res>
    extends _$SessionExerciseCopyWithImpl<$Res, _$SessionExerciseImpl>
    implements _$$SessionExerciseImplCopyWith<$Res> {
  __$$SessionExerciseImplCopyWithImpl(
      _$SessionExerciseImpl _value, $Res Function(_$SessionExerciseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionExercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? exercise = null,
    Object? exerciseName = null,
    Object? order = null,
    Object? sets = null,
    Object? reps = null,
    Object? restTime = null,
    Object? exerciseDescription = freezed,
    Object? exerciseImage = freezed,
    Object? exerciseVideoUrl = freezed,
    Object? exerciseMuscleGroup = freezed,
    Object? exerciseMuscleGroupDisplay = freezed,
    Object? weightKg = freezed,
    Object? notes = null,
    Object? isPyramid = null,
    Object? setDetails = freezed,
    Object? weeklyProgressions = null,
  }) {
    return _then(_$SessionExerciseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      exercise: null == exercise
          ? _value.exercise
          : exercise // ignore: cast_nullable_to_non_nullable
              as int,
      exerciseName: null == exerciseName
          ? _value.exerciseName
          : exerciseName // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      sets: null == sets
          ? _value.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as int,
      reps: null == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as String,
      restTime: null == restTime
          ? _value.restTime
          : restTime // ignore: cast_nullable_to_non_nullable
              as String,
      exerciseDescription: freezed == exerciseDescription
          ? _value.exerciseDescription
          : exerciseDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      exerciseImage: freezed == exerciseImage
          ? _value.exerciseImage
          : exerciseImage // ignore: cast_nullable_to_non_nullable
              as String?,
      exerciseVideoUrl: freezed == exerciseVideoUrl
          ? _value.exerciseVideoUrl
          : exerciseVideoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      exerciseMuscleGroup: freezed == exerciseMuscleGroup
          ? _value.exerciseMuscleGroup
          : exerciseMuscleGroup // ignore: cast_nullable_to_non_nullable
              as String?,
      exerciseMuscleGroupDisplay: freezed == exerciseMuscleGroupDisplay
          ? _value.exerciseMuscleGroupDisplay
          : exerciseMuscleGroupDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      weightKg: freezed == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      isPyramid: null == isPyramid
          ? _value.isPyramid
          : isPyramid // ignore: cast_nullable_to_non_nullable
              as bool,
      setDetails: freezed == setDetails
          ? _value._setDetails
          : setDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      weeklyProgressions: null == weeklyProgressions
          ? _value._weeklyProgressions
          : weeklyProgressions // ignore: cast_nullable_to_non_nullable
              as List<WeeklyProgression>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionExerciseImpl implements _SessionExercise {
  const _$SessionExerciseImpl(
      {required this.id,
      required this.exercise,
      @JsonKey(name: 'exercise_name') required this.exerciseName,
      required this.order,
      required this.sets,
      required this.reps,
      @JsonKey(name: 'rest_time') required this.restTime,
      @JsonKey(name: 'exercise_description') this.exerciseDescription,
      @JsonKey(name: 'exercise_image') this.exerciseImage,
      @JsonKey(name: 'exercise_video_url') this.exerciseVideoUrl,
      @JsonKey(name: 'exercise_muscle_group') this.exerciseMuscleGroup,
      @JsonKey(name: 'exercise_muscle_group_display')
      this.exerciseMuscleGroupDisplay,
      @JsonKey(name: 'weight_kg') this.weightKg,
      this.notes = '',
      @JsonKey(name: 'is_pyramid') this.isPyramid = false,
      @JsonKey(name: 'set_details') final Map<String, dynamic>? setDetails,
      @JsonKey(name: 'weekly_progressions')
      final List<WeeklyProgression> weeklyProgressions = const []})
      : _setDetails = setDetails,
        _weeklyProgressions = weeklyProgressions;

  factory _$SessionExerciseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionExerciseImplFromJson(json);

  @override
  final int id;
  @override
  final int exercise;
  @override
  @JsonKey(name: 'exercise_name')
  final String exerciseName;
  @override
  final int order;
  @override
  final int sets;
  @override
  final String reps;
  @override
  @JsonKey(name: 'rest_time')
  final String restTime;
  @override
  @JsonKey(name: 'exercise_description')
  final String? exerciseDescription;
  @override
  @JsonKey(name: 'exercise_image')
  final String? exerciseImage;
  @override
  @JsonKey(name: 'exercise_video_url')
  final String? exerciseVideoUrl;
  @override
  @JsonKey(name: 'exercise_muscle_group')
  final String? exerciseMuscleGroup;
  @override
  @JsonKey(name: 'exercise_muscle_group_display')
  final String? exerciseMuscleGroupDisplay;
  @override
  @JsonKey(name: 'weight_kg')
  final double? weightKg;
  @override
  @JsonKey()
  final String notes;
  @override
  @JsonKey(name: 'is_pyramid')
  final bool isPyramid;
  final Map<String, dynamic>? _setDetails;
  @override
  @JsonKey(name: 'set_details')
  Map<String, dynamic>? get setDetails {
    final value = _setDetails;
    if (value == null) return null;
    if (_setDetails is EqualUnmodifiableMapView) return _setDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<WeeklyProgression> _weeklyProgressions;
  @override
  @JsonKey(name: 'weekly_progressions')
  List<WeeklyProgression> get weeklyProgressions {
    if (_weeklyProgressions is EqualUnmodifiableListView)
      return _weeklyProgressions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weeklyProgressions);
  }

  @override
  String toString() {
    return 'SessionExercise(id: $id, exercise: $exercise, exerciseName: $exerciseName, order: $order, sets: $sets, reps: $reps, restTime: $restTime, exerciseDescription: $exerciseDescription, exerciseImage: $exerciseImage, exerciseVideoUrl: $exerciseVideoUrl, exerciseMuscleGroup: $exerciseMuscleGroup, exerciseMuscleGroupDisplay: $exerciseMuscleGroupDisplay, weightKg: $weightKg, notes: $notes, isPyramid: $isPyramid, setDetails: $setDetails, weeklyProgressions: $weeklyProgressions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionExerciseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.exercise, exercise) ||
                other.exercise == exercise) &&
            (identical(other.exerciseName, exerciseName) ||
                other.exerciseName == exerciseName) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.sets, sets) || other.sets == sets) &&
            (identical(other.reps, reps) || other.reps == reps) &&
            (identical(other.restTime, restTime) ||
                other.restTime == restTime) &&
            (identical(other.exerciseDescription, exerciseDescription) ||
                other.exerciseDescription == exerciseDescription) &&
            (identical(other.exerciseImage, exerciseImage) ||
                other.exerciseImage == exerciseImage) &&
            (identical(other.exerciseVideoUrl, exerciseVideoUrl) ||
                other.exerciseVideoUrl == exerciseVideoUrl) &&
            (identical(other.exerciseMuscleGroup, exerciseMuscleGroup) ||
                other.exerciseMuscleGroup == exerciseMuscleGroup) &&
            (identical(other.exerciseMuscleGroupDisplay,
                    exerciseMuscleGroupDisplay) ||
                other.exerciseMuscleGroupDisplay ==
                    exerciseMuscleGroupDisplay) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isPyramid, isPyramid) ||
                other.isPyramid == isPyramid) &&
            const DeepCollectionEquality()
                .equals(other._setDetails, _setDetails) &&
            const DeepCollectionEquality()
                .equals(other._weeklyProgressions, _weeklyProgressions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      exercise,
      exerciseName,
      order,
      sets,
      reps,
      restTime,
      exerciseDescription,
      exerciseImage,
      exerciseVideoUrl,
      exerciseMuscleGroup,
      exerciseMuscleGroupDisplay,
      weightKg,
      notes,
      isPyramid,
      const DeepCollectionEquality().hash(_setDetails),
      const DeepCollectionEquality().hash(_weeklyProgressions));

  /// Create a copy of SessionExercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionExerciseImplCopyWith<_$SessionExerciseImpl> get copyWith =>
      __$$SessionExerciseImplCopyWithImpl<_$SessionExerciseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionExerciseImplToJson(
      this,
    );
  }
}

abstract class _SessionExercise implements SessionExercise {
  const factory _SessionExercise(
      {required final int id,
      required final int exercise,
      @JsonKey(name: 'exercise_name') required final String exerciseName,
      required final int order,
      required final int sets,
      required final String reps,
      @JsonKey(name: 'rest_time') required final String restTime,
      @JsonKey(name: 'exercise_description') final String? exerciseDescription,
      @JsonKey(name: 'exercise_image') final String? exerciseImage,
      @JsonKey(name: 'exercise_video_url') final String? exerciseVideoUrl,
      @JsonKey(name: 'exercise_muscle_group') final String? exerciseMuscleGroup,
      @JsonKey(name: 'exercise_muscle_group_display')
      final String? exerciseMuscleGroupDisplay,
      @JsonKey(name: 'weight_kg') final double? weightKg,
      final String notes,
      @JsonKey(name: 'is_pyramid') final bool isPyramid,
      @JsonKey(name: 'set_details') final Map<String, dynamic>? setDetails,
      @JsonKey(name: 'weekly_progressions')
      final List<WeeklyProgression>
          weeklyProgressions}) = _$SessionExerciseImpl;

  factory _SessionExercise.fromJson(Map<String, dynamic> json) =
      _$SessionExerciseImpl.fromJson;

  @override
  int get id;
  @override
  int get exercise;
  @override
  @JsonKey(name: 'exercise_name')
  String get exerciseName;
  @override
  int get order;
  @override
  int get sets;
  @override
  String get reps;
  @override
  @JsonKey(name: 'rest_time')
  String get restTime;
  @override
  @JsonKey(name: 'exercise_description')
  String? get exerciseDescription;
  @override
  @JsonKey(name: 'exercise_image')
  String? get exerciseImage;
  @override
  @JsonKey(name: 'exercise_video_url')
  String? get exerciseVideoUrl;
  @override
  @JsonKey(name: 'exercise_muscle_group')
  String? get exerciseMuscleGroup;
  @override
  @JsonKey(name: 'exercise_muscle_group_display')
  String? get exerciseMuscleGroupDisplay;
  @override
  @JsonKey(name: 'weight_kg')
  double? get weightKg;
  @override
  String get notes;
  @override
  @JsonKey(name: 'is_pyramid')
  bool get isPyramid;
  @override
  @JsonKey(name: 'set_details')
  Map<String, dynamic>? get setDetails;
  @override
  @JsonKey(name: 'weekly_progressions')
  List<WeeklyProgression> get weeklyProgressions;

  /// Create a copy of SessionExercise
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionExerciseImplCopyWith<_$SessionExerciseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeeklyProgression _$WeeklyProgressionFromJson(Map<String, dynamic> json) {
  return _WeeklyProgression.fromJson(json);
}

/// @nodoc
mixin _$WeeklyProgression {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'week_number')
  int get weekNumber => throw _privateConstructorUsedError;
  int get sets => throw _privateConstructorUsedError;
  String get reps => throw _privateConstructorUsedError;
  @JsonKey(name: 'rest_time')
  String get restTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'weight_kg')
  double? get weightKg => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;

  /// Serializes this WeeklyProgression to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeeklyProgression
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeeklyProgressionCopyWith<WeeklyProgression> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyProgressionCopyWith<$Res> {
  factory $WeeklyProgressionCopyWith(
          WeeklyProgression value, $Res Function(WeeklyProgression) then) =
      _$WeeklyProgressionCopyWithImpl<$Res, WeeklyProgression>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'week_number') int weekNumber,
      int sets,
      String reps,
      @JsonKey(name: 'rest_time') String restTime,
      @JsonKey(name: 'weight_kg') double? weightKg,
      String notes});
}

/// @nodoc
class _$WeeklyProgressionCopyWithImpl<$Res, $Val extends WeeklyProgression>
    implements $WeeklyProgressionCopyWith<$Res> {
  _$WeeklyProgressionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeeklyProgression
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? weekNumber = null,
    Object? sets = null,
    Object? reps = null,
    Object? restTime = null,
    Object? weightKg = freezed,
    Object? notes = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      weekNumber: null == weekNumber
          ? _value.weekNumber
          : weekNumber // ignore: cast_nullable_to_non_nullable
              as int,
      sets: null == sets
          ? _value.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as int,
      reps: null == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as String,
      restTime: null == restTime
          ? _value.restTime
          : restTime // ignore: cast_nullable_to_non_nullable
              as String,
      weightKg: freezed == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeeklyProgressionImplCopyWith<$Res>
    implements $WeeklyProgressionCopyWith<$Res> {
  factory _$$WeeklyProgressionImplCopyWith(_$WeeklyProgressionImpl value,
          $Res Function(_$WeeklyProgressionImpl) then) =
      __$$WeeklyProgressionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'week_number') int weekNumber,
      int sets,
      String reps,
      @JsonKey(name: 'rest_time') String restTime,
      @JsonKey(name: 'weight_kg') double? weightKg,
      String notes});
}

/// @nodoc
class __$$WeeklyProgressionImplCopyWithImpl<$Res>
    extends _$WeeklyProgressionCopyWithImpl<$Res, _$WeeklyProgressionImpl>
    implements _$$WeeklyProgressionImplCopyWith<$Res> {
  __$$WeeklyProgressionImplCopyWithImpl(_$WeeklyProgressionImpl _value,
      $Res Function(_$WeeklyProgressionImpl) _then)
      : super(_value, _then);

  /// Create a copy of WeeklyProgression
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? weekNumber = null,
    Object? sets = null,
    Object? reps = null,
    Object? restTime = null,
    Object? weightKg = freezed,
    Object? notes = null,
  }) {
    return _then(_$WeeklyProgressionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      weekNumber: null == weekNumber
          ? _value.weekNumber
          : weekNumber // ignore: cast_nullable_to_non_nullable
              as int,
      sets: null == sets
          ? _value.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as int,
      reps: null == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as String,
      restTime: null == restTime
          ? _value.restTime
          : restTime // ignore: cast_nullable_to_non_nullable
              as String,
      weightKg: freezed == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeeklyProgressionImpl implements _WeeklyProgression {
  const _$WeeklyProgressionImpl(
      {required this.id,
      @JsonKey(name: 'week_number') required this.weekNumber,
      required this.sets,
      required this.reps,
      @JsonKey(name: 'rest_time') required this.restTime,
      @JsonKey(name: 'weight_kg') this.weightKg,
      this.notes = ''});

  factory _$WeeklyProgressionImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklyProgressionImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'week_number')
  final int weekNumber;
  @override
  final int sets;
  @override
  final String reps;
  @override
  @JsonKey(name: 'rest_time')
  final String restTime;
  @override
  @JsonKey(name: 'weight_kg')
  final double? weightKg;
  @override
  @JsonKey()
  final String notes;

  @override
  String toString() {
    return 'WeeklyProgression(id: $id, weekNumber: $weekNumber, sets: $sets, reps: $reps, restTime: $restTime, weightKg: $weightKg, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyProgressionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.weekNumber, weekNumber) ||
                other.weekNumber == weekNumber) &&
            (identical(other.sets, sets) || other.sets == sets) &&
            (identical(other.reps, reps) || other.reps == reps) &&
            (identical(other.restTime, restTime) ||
                other.restTime == restTime) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, weekNumber, sets, reps, restTime, weightKg, notes);

  /// Create a copy of WeeklyProgression
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyProgressionImplCopyWith<_$WeeklyProgressionImpl> get copyWith =>
      __$$WeeklyProgressionImplCopyWithImpl<_$WeeklyProgressionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklyProgressionImplToJson(
      this,
    );
  }
}

abstract class _WeeklyProgression implements WeeklyProgression {
  const factory _WeeklyProgression(
      {required final int id,
      @JsonKey(name: 'week_number') required final int weekNumber,
      required final int sets,
      required final String reps,
      @JsonKey(name: 'rest_time') required final String restTime,
      @JsonKey(name: 'weight_kg') final double? weightKg,
      final String notes}) = _$WeeklyProgressionImpl;

  factory _WeeklyProgression.fromJson(Map<String, dynamic> json) =
      _$WeeklyProgressionImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'week_number')
  int get weekNumber;
  @override
  int get sets;
  @override
  String get reps;
  @override
  @JsonKey(name: 'rest_time')
  String get restTime;
  @override
  @JsonKey(name: 'weight_kg')
  double? get weightKg;
  @override
  String get notes;

  /// Create a copy of WeeklyProgression
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeeklyProgressionImplCopyWith<_$WeeklyProgressionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
