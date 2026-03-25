// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'execution_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkoutExecutionDetail _$WorkoutExecutionDetailFromJson(
    Map<String, dynamic> json) {
  return _WorkoutExecutionDetail.fromJson(json);
}

/// @nodoc
mixin _$WorkoutExecutionDetail {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'workout_plan')
  int get workoutPlan => throw _privateConstructorUsedError;
  @JsonKey(name: 'session')
  int get session => throw _privateConstructorUsedError;
  @JsonKey(name: 'week_number')
  int get weekNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'started_at')
  String get startedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'plan_name')
  String? get planName => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_name')
  String? get sessionName => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  String? get completedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'execution_time')
  int? get executionTime => throw _privateConstructorUsedError;
  int? get feeling => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'exercise_executions')
  List<ExerciseExecution> get exerciseExecutions =>
      throw _privateConstructorUsedError;

  /// Serializes this WorkoutExecutionDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutExecutionDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutExecutionDetailCopyWith<WorkoutExecutionDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutExecutionDetailCopyWith<$Res> {
  factory $WorkoutExecutionDetailCopyWith(WorkoutExecutionDetail value,
          $Res Function(WorkoutExecutionDetail) then) =
      _$WorkoutExecutionDetailCopyWithImpl<$Res, WorkoutExecutionDetail>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'workout_plan') int workoutPlan,
      @JsonKey(name: 'session') int session,
      @JsonKey(name: 'week_number') int weekNumber,
      @JsonKey(name: 'started_at') String startedAt,
      @JsonKey(name: 'plan_name') String? planName,
      @JsonKey(name: 'session_name') String? sessionName,
      @JsonKey(name: 'completed_at') String? completedAt,
      @JsonKey(name: 'execution_time') int? executionTime,
      int? feeling,
      String? notes,
      @JsonKey(name: 'exercise_executions')
      List<ExerciseExecution> exerciseExecutions});
}

/// @nodoc
class _$WorkoutExecutionDetailCopyWithImpl<$Res,
        $Val extends WorkoutExecutionDetail>
    implements $WorkoutExecutionDetailCopyWith<$Res> {
  _$WorkoutExecutionDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutExecutionDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workoutPlan = null,
    Object? session = null,
    Object? weekNumber = null,
    Object? startedAt = null,
    Object? planName = freezed,
    Object? sessionName = freezed,
    Object? completedAt = freezed,
    Object? executionTime = freezed,
    Object? feeling = freezed,
    Object? notes = freezed,
    Object? exerciseExecutions = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      workoutPlan: null == workoutPlan
          ? _value.workoutPlan
          : workoutPlan // ignore: cast_nullable_to_non_nullable
              as int,
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as int,
      weekNumber: null == weekNumber
          ? _value.weekNumber
          : weekNumber // ignore: cast_nullable_to_non_nullable
              as int,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as String,
      planName: freezed == planName
          ? _value.planName
          : planName // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionName: freezed == sessionName
          ? _value.sessionName
          : sessionName // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      executionTime: freezed == executionTime
          ? _value.executionTime
          : executionTime // ignore: cast_nullable_to_non_nullable
              as int?,
      feeling: freezed == feeling
          ? _value.feeling
          : feeling // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      exerciseExecutions: null == exerciseExecutions
          ? _value.exerciseExecutions
          : exerciseExecutions // ignore: cast_nullable_to_non_nullable
              as List<ExerciseExecution>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutExecutionDetailImplCopyWith<$Res>
    implements $WorkoutExecutionDetailCopyWith<$Res> {
  factory _$$WorkoutExecutionDetailImplCopyWith(
          _$WorkoutExecutionDetailImpl value,
          $Res Function(_$WorkoutExecutionDetailImpl) then) =
      __$$WorkoutExecutionDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'workout_plan') int workoutPlan,
      @JsonKey(name: 'session') int session,
      @JsonKey(name: 'week_number') int weekNumber,
      @JsonKey(name: 'started_at') String startedAt,
      @JsonKey(name: 'plan_name') String? planName,
      @JsonKey(name: 'session_name') String? sessionName,
      @JsonKey(name: 'completed_at') String? completedAt,
      @JsonKey(name: 'execution_time') int? executionTime,
      int? feeling,
      String? notes,
      @JsonKey(name: 'exercise_executions')
      List<ExerciseExecution> exerciseExecutions});
}

/// @nodoc
class __$$WorkoutExecutionDetailImplCopyWithImpl<$Res>
    extends _$WorkoutExecutionDetailCopyWithImpl<$Res,
        _$WorkoutExecutionDetailImpl>
    implements _$$WorkoutExecutionDetailImplCopyWith<$Res> {
  __$$WorkoutExecutionDetailImplCopyWithImpl(
      _$WorkoutExecutionDetailImpl _value,
      $Res Function(_$WorkoutExecutionDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutExecutionDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workoutPlan = null,
    Object? session = null,
    Object? weekNumber = null,
    Object? startedAt = null,
    Object? planName = freezed,
    Object? sessionName = freezed,
    Object? completedAt = freezed,
    Object? executionTime = freezed,
    Object? feeling = freezed,
    Object? notes = freezed,
    Object? exerciseExecutions = null,
  }) {
    return _then(_$WorkoutExecutionDetailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      workoutPlan: null == workoutPlan
          ? _value.workoutPlan
          : workoutPlan // ignore: cast_nullable_to_non_nullable
              as int,
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as int,
      weekNumber: null == weekNumber
          ? _value.weekNumber
          : weekNumber // ignore: cast_nullable_to_non_nullable
              as int,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as String,
      planName: freezed == planName
          ? _value.planName
          : planName // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionName: freezed == sessionName
          ? _value.sessionName
          : sessionName // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      executionTime: freezed == executionTime
          ? _value.executionTime
          : executionTime // ignore: cast_nullable_to_non_nullable
              as int?,
      feeling: freezed == feeling
          ? _value.feeling
          : feeling // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      exerciseExecutions: null == exerciseExecutions
          ? _value._exerciseExecutions
          : exerciseExecutions // ignore: cast_nullable_to_non_nullable
              as List<ExerciseExecution>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutExecutionDetailImpl implements _WorkoutExecutionDetail {
  const _$WorkoutExecutionDetailImpl(
      {required this.id,
      @JsonKey(name: 'workout_plan') required this.workoutPlan,
      @JsonKey(name: 'session') required this.session,
      @JsonKey(name: 'week_number') required this.weekNumber,
      @JsonKey(name: 'started_at') required this.startedAt,
      @JsonKey(name: 'plan_name') this.planName,
      @JsonKey(name: 'session_name') this.sessionName,
      @JsonKey(name: 'completed_at') this.completedAt,
      @JsonKey(name: 'execution_time') this.executionTime,
      this.feeling,
      this.notes,
      @JsonKey(name: 'exercise_executions')
      final List<ExerciseExecution> exerciseExecutions = const []})
      : _exerciseExecutions = exerciseExecutions;

  factory _$WorkoutExecutionDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutExecutionDetailImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'workout_plan')
  final int workoutPlan;
  @override
  @JsonKey(name: 'session')
  final int session;
  @override
  @JsonKey(name: 'week_number')
  final int weekNumber;
  @override
  @JsonKey(name: 'started_at')
  final String startedAt;
  @override
  @JsonKey(name: 'plan_name')
  final String? planName;
  @override
  @JsonKey(name: 'session_name')
  final String? sessionName;
  @override
  @JsonKey(name: 'completed_at')
  final String? completedAt;
  @override
  @JsonKey(name: 'execution_time')
  final int? executionTime;
  @override
  final int? feeling;
  @override
  final String? notes;
  final List<ExerciseExecution> _exerciseExecutions;
  @override
  @JsonKey(name: 'exercise_executions')
  List<ExerciseExecution> get exerciseExecutions {
    if (_exerciseExecutions is EqualUnmodifiableListView)
      return _exerciseExecutions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exerciseExecutions);
  }

  @override
  String toString() {
    return 'WorkoutExecutionDetail(id: $id, workoutPlan: $workoutPlan, session: $session, weekNumber: $weekNumber, startedAt: $startedAt, planName: $planName, sessionName: $sessionName, completedAt: $completedAt, executionTime: $executionTime, feeling: $feeling, notes: $notes, exerciseExecutions: $exerciseExecutions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutExecutionDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workoutPlan, workoutPlan) ||
                other.workoutPlan == workoutPlan) &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.weekNumber, weekNumber) ||
                other.weekNumber == weekNumber) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.planName, planName) ||
                other.planName == planName) &&
            (identical(other.sessionName, sessionName) ||
                other.sessionName == sessionName) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.executionTime, executionTime) ||
                other.executionTime == executionTime) &&
            (identical(other.feeling, feeling) || other.feeling == feeling) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality()
                .equals(other._exerciseExecutions, _exerciseExecutions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      workoutPlan,
      session,
      weekNumber,
      startedAt,
      planName,
      sessionName,
      completedAt,
      executionTime,
      feeling,
      notes,
      const DeepCollectionEquality().hash(_exerciseExecutions));

  /// Create a copy of WorkoutExecutionDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutExecutionDetailImplCopyWith<_$WorkoutExecutionDetailImpl>
      get copyWith => __$$WorkoutExecutionDetailImplCopyWithImpl<
          _$WorkoutExecutionDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutExecutionDetailImplToJson(
      this,
    );
  }
}

abstract class _WorkoutExecutionDetail implements WorkoutExecutionDetail {
  const factory _WorkoutExecutionDetail(
          {required final int id,
          @JsonKey(name: 'workout_plan') required final int workoutPlan,
          @JsonKey(name: 'session') required final int session,
          @JsonKey(name: 'week_number') required final int weekNumber,
          @JsonKey(name: 'started_at') required final String startedAt,
          @JsonKey(name: 'plan_name') final String? planName,
          @JsonKey(name: 'session_name') final String? sessionName,
          @JsonKey(name: 'completed_at') final String? completedAt,
          @JsonKey(name: 'execution_time') final int? executionTime,
          final int? feeling,
          final String? notes,
          @JsonKey(name: 'exercise_executions')
          final List<ExerciseExecution> exerciseExecutions}) =
      _$WorkoutExecutionDetailImpl;

  factory _WorkoutExecutionDetail.fromJson(Map<String, dynamic> json) =
      _$WorkoutExecutionDetailImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'workout_plan')
  int get workoutPlan;
  @override
  @JsonKey(name: 'session')
  int get session;
  @override
  @JsonKey(name: 'week_number')
  int get weekNumber;
  @override
  @JsonKey(name: 'started_at')
  String get startedAt;
  @override
  @JsonKey(name: 'plan_name')
  String? get planName;
  @override
  @JsonKey(name: 'session_name')
  String? get sessionName;
  @override
  @JsonKey(name: 'completed_at')
  String? get completedAt;
  @override
  @JsonKey(name: 'execution_time')
  int? get executionTime;
  @override
  int? get feeling;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'exercise_executions')
  List<ExerciseExecution> get exerciseExecutions;

  /// Create a copy of WorkoutExecutionDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutExecutionDetailImplCopyWith<_$WorkoutExecutionDetailImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ExerciseExecution _$ExerciseExecutionFromJson(Map<String, dynamic> json) {
  return _ExerciseExecution.fromJson(json);
}

/// @nodoc
mixin _$ExerciseExecution {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'plan_exercise')
  int get planExercise => throw _privateConstructorUsedError;
  @JsonKey(name: 'exercise_name')
  String get exerciseName => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  @JsonKey(name: 'exercise_image')
  String? get exerciseImage => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<ExerciseSet> get sets => throw _privateConstructorUsedError;

  /// Serializes this ExerciseExecution to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExerciseExecution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExerciseExecutionCopyWith<ExerciseExecution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseExecutionCopyWith<$Res> {
  factory $ExerciseExecutionCopyWith(
          ExerciseExecution value, $Res Function(ExerciseExecution) then) =
      _$ExerciseExecutionCopyWithImpl<$Res, ExerciseExecution>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'plan_exercise') int planExercise,
      @JsonKey(name: 'exercise_name') String exerciseName,
      int order,
      @JsonKey(name: 'exercise_image') String? exerciseImage,
      String? notes,
      List<ExerciseSet> sets});
}

/// @nodoc
class _$ExerciseExecutionCopyWithImpl<$Res, $Val extends ExerciseExecution>
    implements $ExerciseExecutionCopyWith<$Res> {
  _$ExerciseExecutionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExerciseExecution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? planExercise = null,
    Object? exerciseName = null,
    Object? order = null,
    Object? exerciseImage = freezed,
    Object? notes = freezed,
    Object? sets = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      planExercise: null == planExercise
          ? _value.planExercise
          : planExercise // ignore: cast_nullable_to_non_nullable
              as int,
      exerciseName: null == exerciseName
          ? _value.exerciseName
          : exerciseName // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      exerciseImage: freezed == exerciseImage
          ? _value.exerciseImage
          : exerciseImage // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      sets: null == sets
          ? _value.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as List<ExerciseSet>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExerciseExecutionImplCopyWith<$Res>
    implements $ExerciseExecutionCopyWith<$Res> {
  factory _$$ExerciseExecutionImplCopyWith(_$ExerciseExecutionImpl value,
          $Res Function(_$ExerciseExecutionImpl) then) =
      __$$ExerciseExecutionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'plan_exercise') int planExercise,
      @JsonKey(name: 'exercise_name') String exerciseName,
      int order,
      @JsonKey(name: 'exercise_image') String? exerciseImage,
      String? notes,
      List<ExerciseSet> sets});
}

/// @nodoc
class __$$ExerciseExecutionImplCopyWithImpl<$Res>
    extends _$ExerciseExecutionCopyWithImpl<$Res, _$ExerciseExecutionImpl>
    implements _$$ExerciseExecutionImplCopyWith<$Res> {
  __$$ExerciseExecutionImplCopyWithImpl(_$ExerciseExecutionImpl _value,
      $Res Function(_$ExerciseExecutionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExerciseExecution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? planExercise = null,
    Object? exerciseName = null,
    Object? order = null,
    Object? exerciseImage = freezed,
    Object? notes = freezed,
    Object? sets = null,
  }) {
    return _then(_$ExerciseExecutionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      planExercise: null == planExercise
          ? _value.planExercise
          : planExercise // ignore: cast_nullable_to_non_nullable
              as int,
      exerciseName: null == exerciseName
          ? _value.exerciseName
          : exerciseName // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      exerciseImage: freezed == exerciseImage
          ? _value.exerciseImage
          : exerciseImage // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      sets: null == sets
          ? _value._sets
          : sets // ignore: cast_nullable_to_non_nullable
              as List<ExerciseSet>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExerciseExecutionImpl implements _ExerciseExecution {
  const _$ExerciseExecutionImpl(
      {required this.id,
      @JsonKey(name: 'plan_exercise') required this.planExercise,
      @JsonKey(name: 'exercise_name') required this.exerciseName,
      required this.order,
      @JsonKey(name: 'exercise_image') this.exerciseImage,
      this.notes,
      final List<ExerciseSet> sets = const []})
      : _sets = sets;

  factory _$ExerciseExecutionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseExecutionImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'plan_exercise')
  final int planExercise;
  @override
  @JsonKey(name: 'exercise_name')
  final String exerciseName;
  @override
  final int order;
  @override
  @JsonKey(name: 'exercise_image')
  final String? exerciseImage;
  @override
  final String? notes;
  final List<ExerciseSet> _sets;
  @override
  @JsonKey()
  List<ExerciseSet> get sets {
    if (_sets is EqualUnmodifiableListView) return _sets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sets);
  }

  @override
  String toString() {
    return 'ExerciseExecution(id: $id, planExercise: $planExercise, exerciseName: $exerciseName, order: $order, exerciseImage: $exerciseImage, notes: $notes, sets: $sets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseExecutionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.planExercise, planExercise) ||
                other.planExercise == planExercise) &&
            (identical(other.exerciseName, exerciseName) ||
                other.exerciseName == exerciseName) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.exerciseImage, exerciseImage) ||
                other.exerciseImage == exerciseImage) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._sets, _sets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, planExercise, exerciseName,
      order, exerciseImage, notes, const DeepCollectionEquality().hash(_sets));

  /// Create a copy of ExerciseExecution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseExecutionImplCopyWith<_$ExerciseExecutionImpl> get copyWith =>
      __$$ExerciseExecutionImplCopyWithImpl<_$ExerciseExecutionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseExecutionImplToJson(
      this,
    );
  }
}

abstract class _ExerciseExecution implements ExerciseExecution {
  const factory _ExerciseExecution(
      {required final int id,
      @JsonKey(name: 'plan_exercise') required final int planExercise,
      @JsonKey(name: 'exercise_name') required final String exerciseName,
      required final int order,
      @JsonKey(name: 'exercise_image') final String? exerciseImage,
      final String? notes,
      final List<ExerciseSet> sets}) = _$ExerciseExecutionImpl;

  factory _ExerciseExecution.fromJson(Map<String, dynamic> json) =
      _$ExerciseExecutionImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'plan_exercise')
  int get planExercise;
  @override
  @JsonKey(name: 'exercise_name')
  String get exerciseName;
  @override
  int get order;
  @override
  @JsonKey(name: 'exercise_image')
  String? get exerciseImage;
  @override
  String? get notes;
  @override
  List<ExerciseSet> get sets;

  /// Create a copy of ExerciseExecution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExerciseExecutionImplCopyWith<_$ExerciseExecutionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExerciseSet _$ExerciseSetFromJson(Map<String, dynamic> json) {
  return _ExerciseSet.fromJson(json);
}

/// @nodoc
mixin _$ExerciseSet {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'set_number')
  int get setNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_reps')
  int? get targetReps => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_reps')
  int? get actualReps => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_weight', fromJson: _doubleFromJson)
  double? get targetWeight => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_weight', fromJson: _doubleFromJson)
  double? get actualWeight => throw _privateConstructorUsedError;
  @JsonKey(name: 'rest_duration')
  int? get restDuration => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  String? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this ExerciseSet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExerciseSet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExerciseSetCopyWith<ExerciseSet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseSetCopyWith<$Res> {
  factory $ExerciseSetCopyWith(
          ExerciseSet value, $Res Function(ExerciseSet) then) =
      _$ExerciseSetCopyWithImpl<$Res, ExerciseSet>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'set_number') int setNumber,
      @JsonKey(name: 'target_reps') int? targetReps,
      @JsonKey(name: 'actual_reps') int? actualReps,
      @JsonKey(name: 'target_weight', fromJson: _doubleFromJson)
      double? targetWeight,
      @JsonKey(name: 'actual_weight', fromJson: _doubleFromJson)
      double? actualWeight,
      @JsonKey(name: 'rest_duration') int? restDuration,
      @JsonKey(name: 'completed_at') String? completedAt});
}

/// @nodoc
class _$ExerciseSetCopyWithImpl<$Res, $Val extends ExerciseSet>
    implements $ExerciseSetCopyWith<$Res> {
  _$ExerciseSetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExerciseSet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? setNumber = null,
    Object? targetReps = freezed,
    Object? actualReps = freezed,
    Object? targetWeight = freezed,
    Object? actualWeight = freezed,
    Object? restDuration = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      setNumber: null == setNumber
          ? _value.setNumber
          : setNumber // ignore: cast_nullable_to_non_nullable
              as int,
      targetReps: freezed == targetReps
          ? _value.targetReps
          : targetReps // ignore: cast_nullable_to_non_nullable
              as int?,
      actualReps: freezed == actualReps
          ? _value.actualReps
          : actualReps // ignore: cast_nullable_to_non_nullable
              as int?,
      targetWeight: freezed == targetWeight
          ? _value.targetWeight
          : targetWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      actualWeight: freezed == actualWeight
          ? _value.actualWeight
          : actualWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      restDuration: freezed == restDuration
          ? _value.restDuration
          : restDuration // ignore: cast_nullable_to_non_nullable
              as int?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExerciseSetImplCopyWith<$Res>
    implements $ExerciseSetCopyWith<$Res> {
  factory _$$ExerciseSetImplCopyWith(
          _$ExerciseSetImpl value, $Res Function(_$ExerciseSetImpl) then) =
      __$$ExerciseSetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'set_number') int setNumber,
      @JsonKey(name: 'target_reps') int? targetReps,
      @JsonKey(name: 'actual_reps') int? actualReps,
      @JsonKey(name: 'target_weight', fromJson: _doubleFromJson)
      double? targetWeight,
      @JsonKey(name: 'actual_weight', fromJson: _doubleFromJson)
      double? actualWeight,
      @JsonKey(name: 'rest_duration') int? restDuration,
      @JsonKey(name: 'completed_at') String? completedAt});
}

/// @nodoc
class __$$ExerciseSetImplCopyWithImpl<$Res>
    extends _$ExerciseSetCopyWithImpl<$Res, _$ExerciseSetImpl>
    implements _$$ExerciseSetImplCopyWith<$Res> {
  __$$ExerciseSetImplCopyWithImpl(
      _$ExerciseSetImpl _value, $Res Function(_$ExerciseSetImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExerciseSet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? setNumber = null,
    Object? targetReps = freezed,
    Object? actualReps = freezed,
    Object? targetWeight = freezed,
    Object? actualWeight = freezed,
    Object? restDuration = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_$ExerciseSetImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      setNumber: null == setNumber
          ? _value.setNumber
          : setNumber // ignore: cast_nullable_to_non_nullable
              as int,
      targetReps: freezed == targetReps
          ? _value.targetReps
          : targetReps // ignore: cast_nullable_to_non_nullable
              as int?,
      actualReps: freezed == actualReps
          ? _value.actualReps
          : actualReps // ignore: cast_nullable_to_non_nullable
              as int?,
      targetWeight: freezed == targetWeight
          ? _value.targetWeight
          : targetWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      actualWeight: freezed == actualWeight
          ? _value.actualWeight
          : actualWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      restDuration: freezed == restDuration
          ? _value.restDuration
          : restDuration // ignore: cast_nullable_to_non_nullable
              as int?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExerciseSetImpl implements _ExerciseSet {
  const _$ExerciseSetImpl(
      {required this.id,
      @JsonKey(name: 'set_number') required this.setNumber,
      @JsonKey(name: 'target_reps') this.targetReps,
      @JsonKey(name: 'actual_reps') this.actualReps,
      @JsonKey(name: 'target_weight', fromJson: _doubleFromJson)
      this.targetWeight,
      @JsonKey(name: 'actual_weight', fromJson: _doubleFromJson)
      this.actualWeight,
      @JsonKey(name: 'rest_duration') this.restDuration,
      @JsonKey(name: 'completed_at') this.completedAt});

  factory _$ExerciseSetImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseSetImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'set_number')
  final int setNumber;
  @override
  @JsonKey(name: 'target_reps')
  final int? targetReps;
  @override
  @JsonKey(name: 'actual_reps')
  final int? actualReps;
  @override
  @JsonKey(name: 'target_weight', fromJson: _doubleFromJson)
  final double? targetWeight;
  @override
  @JsonKey(name: 'actual_weight', fromJson: _doubleFromJson)
  final double? actualWeight;
  @override
  @JsonKey(name: 'rest_duration')
  final int? restDuration;
  @override
  @JsonKey(name: 'completed_at')
  final String? completedAt;

  @override
  String toString() {
    return 'ExerciseSet(id: $id, setNumber: $setNumber, targetReps: $targetReps, actualReps: $actualReps, targetWeight: $targetWeight, actualWeight: $actualWeight, restDuration: $restDuration, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseSetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.setNumber, setNumber) ||
                other.setNumber == setNumber) &&
            (identical(other.targetReps, targetReps) ||
                other.targetReps == targetReps) &&
            (identical(other.actualReps, actualReps) ||
                other.actualReps == actualReps) &&
            (identical(other.targetWeight, targetWeight) ||
                other.targetWeight == targetWeight) &&
            (identical(other.actualWeight, actualWeight) ||
                other.actualWeight == actualWeight) &&
            (identical(other.restDuration, restDuration) ||
                other.restDuration == restDuration) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, setNumber, targetReps,
      actualReps, targetWeight, actualWeight, restDuration, completedAt);

  /// Create a copy of ExerciseSet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseSetImplCopyWith<_$ExerciseSetImpl> get copyWith =>
      __$$ExerciseSetImplCopyWithImpl<_$ExerciseSetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseSetImplToJson(
      this,
    );
  }
}

abstract class _ExerciseSet implements ExerciseSet {
  const factory _ExerciseSet(
          {required final int id,
          @JsonKey(name: 'set_number') required final int setNumber,
          @JsonKey(name: 'target_reps') final int? targetReps,
          @JsonKey(name: 'actual_reps') final int? actualReps,
          @JsonKey(name: 'target_weight', fromJson: _doubleFromJson)
          final double? targetWeight,
          @JsonKey(name: 'actual_weight', fromJson: _doubleFromJson)
          final double? actualWeight,
          @JsonKey(name: 'rest_duration') final int? restDuration,
          @JsonKey(name: 'completed_at') final String? completedAt}) =
      _$ExerciseSetImpl;

  factory _ExerciseSet.fromJson(Map<String, dynamic> json) =
      _$ExerciseSetImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'set_number')
  int get setNumber;
  @override
  @JsonKey(name: 'target_reps')
  int? get targetReps;
  @override
  @JsonKey(name: 'actual_reps')
  int? get actualReps;
  @override
  @JsonKey(name: 'target_weight', fromJson: _doubleFromJson)
  double? get targetWeight;
  @override
  @JsonKey(name: 'actual_weight', fromJson: _doubleFromJson)
  double? get actualWeight;
  @override
  @JsonKey(name: 'rest_duration')
  int? get restDuration;
  @override
  @JsonKey(name: 'completed_at')
  String? get completedAt;

  /// Create a copy of ExerciseSet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExerciseSetImplCopyWith<_$ExerciseSetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SessionSuggestionResponse _$SessionSuggestionResponseFromJson(
    Map<String, dynamic> json) {
  return _SessionSuggestionResponse.fromJson(json);
}

/// @nodoc
mixin _$SessionSuggestionResponse {
  @JsonKey(name: 'workout_plan')
  SuggestionPlanInfo get workoutPlan => throw _privateConstructorUsedError;
  @JsonKey(name: 'suggested_session')
  SuggestionSessionInfo get suggestedSession =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'suggested_week')
  int get suggestedWeek => throw _privateConstructorUsedError;
  @JsonKey(name: 'all_sessions')
  List<SuggestionSessionInfo> get allSessions =>
      throw _privateConstructorUsedError;

  /// Serializes this SessionSuggestionResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionSuggestionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionSuggestionResponseCopyWith<SessionSuggestionResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionSuggestionResponseCopyWith<$Res> {
  factory $SessionSuggestionResponseCopyWith(SessionSuggestionResponse value,
          $Res Function(SessionSuggestionResponse) then) =
      _$SessionSuggestionResponseCopyWithImpl<$Res, SessionSuggestionResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'workout_plan') SuggestionPlanInfo workoutPlan,
      @JsonKey(name: 'suggested_session')
      SuggestionSessionInfo suggestedSession,
      @JsonKey(name: 'suggested_week') int suggestedWeek,
      @JsonKey(name: 'all_sessions') List<SuggestionSessionInfo> allSessions});

  $SuggestionPlanInfoCopyWith<$Res> get workoutPlan;
  $SuggestionSessionInfoCopyWith<$Res> get suggestedSession;
}

/// @nodoc
class _$SessionSuggestionResponseCopyWithImpl<$Res,
        $Val extends SessionSuggestionResponse>
    implements $SessionSuggestionResponseCopyWith<$Res> {
  _$SessionSuggestionResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionSuggestionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutPlan = null,
    Object? suggestedSession = null,
    Object? suggestedWeek = null,
    Object? allSessions = null,
  }) {
    return _then(_value.copyWith(
      workoutPlan: null == workoutPlan
          ? _value.workoutPlan
          : workoutPlan // ignore: cast_nullable_to_non_nullable
              as SuggestionPlanInfo,
      suggestedSession: null == suggestedSession
          ? _value.suggestedSession
          : suggestedSession // ignore: cast_nullable_to_non_nullable
              as SuggestionSessionInfo,
      suggestedWeek: null == suggestedWeek
          ? _value.suggestedWeek
          : suggestedWeek // ignore: cast_nullable_to_non_nullable
              as int,
      allSessions: null == allSessions
          ? _value.allSessions
          : allSessions // ignore: cast_nullable_to_non_nullable
              as List<SuggestionSessionInfo>,
    ) as $Val);
  }

  /// Create a copy of SessionSuggestionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SuggestionPlanInfoCopyWith<$Res> get workoutPlan {
    return $SuggestionPlanInfoCopyWith<$Res>(_value.workoutPlan, (value) {
      return _then(_value.copyWith(workoutPlan: value) as $Val);
    });
  }

  /// Create a copy of SessionSuggestionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SuggestionSessionInfoCopyWith<$Res> get suggestedSession {
    return $SuggestionSessionInfoCopyWith<$Res>(_value.suggestedSession,
        (value) {
      return _then(_value.copyWith(suggestedSession: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SessionSuggestionResponseImplCopyWith<$Res>
    implements $SessionSuggestionResponseCopyWith<$Res> {
  factory _$$SessionSuggestionResponseImplCopyWith(
          _$SessionSuggestionResponseImpl value,
          $Res Function(_$SessionSuggestionResponseImpl) then) =
      __$$SessionSuggestionResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'workout_plan') SuggestionPlanInfo workoutPlan,
      @JsonKey(name: 'suggested_session')
      SuggestionSessionInfo suggestedSession,
      @JsonKey(name: 'suggested_week') int suggestedWeek,
      @JsonKey(name: 'all_sessions') List<SuggestionSessionInfo> allSessions});

  @override
  $SuggestionPlanInfoCopyWith<$Res> get workoutPlan;
  @override
  $SuggestionSessionInfoCopyWith<$Res> get suggestedSession;
}

/// @nodoc
class __$$SessionSuggestionResponseImplCopyWithImpl<$Res>
    extends _$SessionSuggestionResponseCopyWithImpl<$Res,
        _$SessionSuggestionResponseImpl>
    implements _$$SessionSuggestionResponseImplCopyWith<$Res> {
  __$$SessionSuggestionResponseImplCopyWithImpl(
      _$SessionSuggestionResponseImpl _value,
      $Res Function(_$SessionSuggestionResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionSuggestionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutPlan = null,
    Object? suggestedSession = null,
    Object? suggestedWeek = null,
    Object? allSessions = null,
  }) {
    return _then(_$SessionSuggestionResponseImpl(
      workoutPlan: null == workoutPlan
          ? _value.workoutPlan
          : workoutPlan // ignore: cast_nullable_to_non_nullable
              as SuggestionPlanInfo,
      suggestedSession: null == suggestedSession
          ? _value.suggestedSession
          : suggestedSession // ignore: cast_nullable_to_non_nullable
              as SuggestionSessionInfo,
      suggestedWeek: null == suggestedWeek
          ? _value.suggestedWeek
          : suggestedWeek // ignore: cast_nullable_to_non_nullable
              as int,
      allSessions: null == allSessions
          ? _value._allSessions
          : allSessions // ignore: cast_nullable_to_non_nullable
              as List<SuggestionSessionInfo>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionSuggestionResponseImpl implements _SessionSuggestionResponse {
  const _$SessionSuggestionResponseImpl(
      {@JsonKey(name: 'workout_plan') required this.workoutPlan,
      @JsonKey(name: 'suggested_session') required this.suggestedSession,
      @JsonKey(name: 'suggested_week') required this.suggestedWeek,
      @JsonKey(name: 'all_sessions')
      final List<SuggestionSessionInfo> allSessions = const []})
      : _allSessions = allSessions;

  factory _$SessionSuggestionResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionSuggestionResponseImplFromJson(json);

  @override
  @JsonKey(name: 'workout_plan')
  final SuggestionPlanInfo workoutPlan;
  @override
  @JsonKey(name: 'suggested_session')
  final SuggestionSessionInfo suggestedSession;
  @override
  @JsonKey(name: 'suggested_week')
  final int suggestedWeek;
  final List<SuggestionSessionInfo> _allSessions;
  @override
  @JsonKey(name: 'all_sessions')
  List<SuggestionSessionInfo> get allSessions {
    if (_allSessions is EqualUnmodifiableListView) return _allSessions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allSessions);
  }

  @override
  String toString() {
    return 'SessionSuggestionResponse(workoutPlan: $workoutPlan, suggestedSession: $suggestedSession, suggestedWeek: $suggestedWeek, allSessions: $allSessions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionSuggestionResponseImpl &&
            (identical(other.workoutPlan, workoutPlan) ||
                other.workoutPlan == workoutPlan) &&
            (identical(other.suggestedSession, suggestedSession) ||
                other.suggestedSession == suggestedSession) &&
            (identical(other.suggestedWeek, suggestedWeek) ||
                other.suggestedWeek == suggestedWeek) &&
            const DeepCollectionEquality()
                .equals(other._allSessions, _allSessions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, workoutPlan, suggestedSession,
      suggestedWeek, const DeepCollectionEquality().hash(_allSessions));

  /// Create a copy of SessionSuggestionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionSuggestionResponseImplCopyWith<_$SessionSuggestionResponseImpl>
      get copyWith => __$$SessionSuggestionResponseImplCopyWithImpl<
          _$SessionSuggestionResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionSuggestionResponseImplToJson(
      this,
    );
  }
}

abstract class _SessionSuggestionResponse implements SessionSuggestionResponse {
  const factory _SessionSuggestionResponse(
          {@JsonKey(name: 'workout_plan')
          required final SuggestionPlanInfo workoutPlan,
          @JsonKey(name: 'suggested_session')
          required final SuggestionSessionInfo suggestedSession,
          @JsonKey(name: 'suggested_week') required final int suggestedWeek,
          @JsonKey(name: 'all_sessions')
          final List<SuggestionSessionInfo> allSessions}) =
      _$SessionSuggestionResponseImpl;

  factory _SessionSuggestionResponse.fromJson(Map<String, dynamic> json) =
      _$SessionSuggestionResponseImpl.fromJson;

  @override
  @JsonKey(name: 'workout_plan')
  SuggestionPlanInfo get workoutPlan;
  @override
  @JsonKey(name: 'suggested_session')
  SuggestionSessionInfo get suggestedSession;
  @override
  @JsonKey(name: 'suggested_week')
  int get suggestedWeek;
  @override
  @JsonKey(name: 'all_sessions')
  List<SuggestionSessionInfo> get allSessions;

  /// Create a copy of SessionSuggestionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionSuggestionResponseImplCopyWith<_$SessionSuggestionResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SuggestionPlanInfo _$SuggestionPlanInfoFromJson(Map<String, dynamic> json) {
  return _SuggestionPlanInfo.fromJson(json);
}

/// @nodoc
mixin _$SuggestionPlanInfo {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_weeks')
  int get durationWeeks => throw _privateConstructorUsedError;

  /// Serializes this SuggestionPlanInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SuggestionPlanInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SuggestionPlanInfoCopyWith<SuggestionPlanInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuggestionPlanInfoCopyWith<$Res> {
  factory $SuggestionPlanInfoCopyWith(
          SuggestionPlanInfo value, $Res Function(SuggestionPlanInfo) then) =
      _$SuggestionPlanInfoCopyWithImpl<$Res, SuggestionPlanInfo>;
  @useResult
  $Res call(
      {int id,
      String name,
      @JsonKey(name: 'duration_weeks') int durationWeeks});
}

/// @nodoc
class _$SuggestionPlanInfoCopyWithImpl<$Res, $Val extends SuggestionPlanInfo>
    implements $SuggestionPlanInfoCopyWith<$Res> {
  _$SuggestionPlanInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SuggestionPlanInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? durationWeeks = null,
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
      durationWeeks: null == durationWeeks
          ? _value.durationWeeks
          : durationWeeks // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SuggestionPlanInfoImplCopyWith<$Res>
    implements $SuggestionPlanInfoCopyWith<$Res> {
  factory _$$SuggestionPlanInfoImplCopyWith(_$SuggestionPlanInfoImpl value,
          $Res Function(_$SuggestionPlanInfoImpl) then) =
      __$$SuggestionPlanInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      @JsonKey(name: 'duration_weeks') int durationWeeks});
}

/// @nodoc
class __$$SuggestionPlanInfoImplCopyWithImpl<$Res>
    extends _$SuggestionPlanInfoCopyWithImpl<$Res, _$SuggestionPlanInfoImpl>
    implements _$$SuggestionPlanInfoImplCopyWith<$Res> {
  __$$SuggestionPlanInfoImplCopyWithImpl(_$SuggestionPlanInfoImpl _value,
      $Res Function(_$SuggestionPlanInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SuggestionPlanInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? durationWeeks = null,
  }) {
    return _then(_$SuggestionPlanInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      durationWeeks: null == durationWeeks
          ? _value.durationWeeks
          : durationWeeks // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SuggestionPlanInfoImpl implements _SuggestionPlanInfo {
  const _$SuggestionPlanInfoImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'duration_weeks') required this.durationWeeks});

  factory _$SuggestionPlanInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SuggestionPlanInfoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'duration_weeks')
  final int durationWeeks;

  @override
  String toString() {
    return 'SuggestionPlanInfo(id: $id, name: $name, durationWeeks: $durationWeeks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuggestionPlanInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.durationWeeks, durationWeeks) ||
                other.durationWeeks == durationWeeks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, durationWeeks);

  /// Create a copy of SuggestionPlanInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuggestionPlanInfoImplCopyWith<_$SuggestionPlanInfoImpl> get copyWith =>
      __$$SuggestionPlanInfoImplCopyWithImpl<_$SuggestionPlanInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SuggestionPlanInfoImplToJson(
      this,
    );
  }
}

abstract class _SuggestionPlanInfo implements SuggestionPlanInfo {
  const factory _SuggestionPlanInfo(
          {required final int id,
          required final String name,
          @JsonKey(name: 'duration_weeks') required final int durationWeeks}) =
      _$SuggestionPlanInfoImpl;

  factory _SuggestionPlanInfo.fromJson(Map<String, dynamic> json) =
      _$SuggestionPlanInfoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'duration_weeks')
  int get durationWeeks;

  /// Create a copy of SuggestionPlanInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuggestionPlanInfoImplCopyWith<_$SuggestionPlanInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SuggestionSessionInfo _$SuggestionSessionInfoFromJson(
    Map<String, dynamic> json) {
  return _SuggestionSessionInfo.fromJson(json);
}

/// @nodoc
mixin _$SuggestionSessionInfo {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this SuggestionSessionInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SuggestionSessionInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SuggestionSessionInfoCopyWith<SuggestionSessionInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuggestionSessionInfoCopyWith<$Res> {
  factory $SuggestionSessionInfoCopyWith(SuggestionSessionInfo value,
          $Res Function(SuggestionSessionInfo) then) =
      _$SuggestionSessionInfoCopyWithImpl<$Res, SuggestionSessionInfo>;
  @useResult
  $Res call({int? id, String? name, String? description});
}

/// @nodoc
class _$SuggestionSessionInfoCopyWithImpl<$Res,
        $Val extends SuggestionSessionInfo>
    implements $SuggestionSessionInfoCopyWith<$Res> {
  _$SuggestionSessionInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SuggestionSessionInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SuggestionSessionInfoImplCopyWith<$Res>
    implements $SuggestionSessionInfoCopyWith<$Res> {
  factory _$$SuggestionSessionInfoImplCopyWith(
          _$SuggestionSessionInfoImpl value,
          $Res Function(_$SuggestionSessionInfoImpl) then) =
      __$$SuggestionSessionInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, String? name, String? description});
}

/// @nodoc
class __$$SuggestionSessionInfoImplCopyWithImpl<$Res>
    extends _$SuggestionSessionInfoCopyWithImpl<$Res,
        _$SuggestionSessionInfoImpl>
    implements _$$SuggestionSessionInfoImplCopyWith<$Res> {
  __$$SuggestionSessionInfoImplCopyWithImpl(_$SuggestionSessionInfoImpl _value,
      $Res Function(_$SuggestionSessionInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SuggestionSessionInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
  }) {
    return _then(_$SuggestionSessionInfoImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SuggestionSessionInfoImpl implements _SuggestionSessionInfo {
  const _$SuggestionSessionInfoImpl({this.id, this.name, this.description});

  factory _$SuggestionSessionInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SuggestionSessionInfoImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? description;

  @override
  String toString() {
    return 'SuggestionSessionInfo(id: $id, name: $name, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuggestionSessionInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description);

  /// Create a copy of SuggestionSessionInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuggestionSessionInfoImplCopyWith<_$SuggestionSessionInfoImpl>
      get copyWith => __$$SuggestionSessionInfoImplCopyWithImpl<
          _$SuggestionSessionInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SuggestionSessionInfoImplToJson(
      this,
    );
  }
}

abstract class _SuggestionSessionInfo implements SuggestionSessionInfo {
  const factory _SuggestionSessionInfo(
      {final int? id,
      final String? name,
      final String? description}) = _$SuggestionSessionInfoImpl;

  factory _SuggestionSessionInfo.fromJson(Map<String, dynamic> json) =
      _$SuggestionSessionInfoImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  String? get description;

  /// Create a copy of SuggestionSessionInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuggestionSessionInfoImplCopyWith<_$SuggestionSessionInfoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
