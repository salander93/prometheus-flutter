// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppError {
  String get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int statusCode, String message,
            Map<String, List<String>> fieldErrors)
        api,
    required TResult Function(String message) network,
    required TResult Function(String message, StackTrace? stackTrace) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int statusCode, String message,
            Map<String, List<String>> fieldErrors)?
        api,
    TResult? Function(String message)? network,
    TResult? Function(String message, StackTrace? stackTrace)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int statusCode, String message,
            Map<String, List<String>> fieldErrors)?
        api,
    TResult Function(String message)? network,
    TResult Function(String message, StackTrace? stackTrace)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ApiError value) api,
    required TResult Function(NetworkError value) network,
    required TResult Function(UnknownError value) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ApiError value)? api,
    TResult? Function(NetworkError value)? network,
    TResult? Function(UnknownError value)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ApiError value)? api,
    TResult Function(NetworkError value)? network,
    TResult Function(UnknownError value)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppErrorCopyWith<AppError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppErrorCopyWith<$Res> {
  factory $AppErrorCopyWith(AppError value, $Res Function(AppError) then) =
      _$AppErrorCopyWithImpl<$Res, AppError>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$AppErrorCopyWithImpl<$Res, $Val extends AppError>
    implements $AppErrorCopyWith<$Res> {
  _$AppErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiErrorImplCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory _$$ApiErrorImplCopyWith(
          _$ApiErrorImpl value, $Res Function(_$ApiErrorImpl) then) =
      __$$ApiErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int statusCode, String message, Map<String, List<String>> fieldErrors});
}

/// @nodoc
class __$$ApiErrorImplCopyWithImpl<$Res>
    extends _$AppErrorCopyWithImpl<$Res, _$ApiErrorImpl>
    implements _$$ApiErrorImplCopyWith<$Res> {
  __$$ApiErrorImplCopyWithImpl(
      _$ApiErrorImpl _value, $Res Function(_$ApiErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = null,
    Object? message = null,
    Object? fieldErrors = null,
  }) {
    return _then(_$ApiErrorImpl(
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      fieldErrors: null == fieldErrors
          ? _value._fieldErrors
          : fieldErrors // ignore: cast_nullable_to_non_nullable
              as Map<String, List<String>>,
    ));
  }
}

/// @nodoc

class _$ApiErrorImpl extends ApiError {
  const _$ApiErrorImpl(
      {required this.statusCode,
      required this.message,
      final Map<String, List<String>> fieldErrors = const {}})
      : _fieldErrors = fieldErrors,
        super._();

  @override
  final int statusCode;
  @override
  final String message;
  final Map<String, List<String>> _fieldErrors;
  @override
  @JsonKey()
  Map<String, List<String>> get fieldErrors {
    if (_fieldErrors is EqualUnmodifiableMapView) return _fieldErrors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_fieldErrors);
  }

  @override
  String toString() {
    return 'AppError.api(statusCode: $statusCode, message: $message, fieldErrors: $fieldErrors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiErrorImpl &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other._fieldErrors, _fieldErrors));
  }

  @override
  int get hashCode => Object.hash(runtimeType, statusCode, message,
      const DeepCollectionEquality().hash(_fieldErrors));

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiErrorImplCopyWith<_$ApiErrorImpl> get copyWith =>
      __$$ApiErrorImplCopyWithImpl<_$ApiErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int statusCode, String message,
            Map<String, List<String>> fieldErrors)
        api,
    required TResult Function(String message) network,
    required TResult Function(String message, StackTrace? stackTrace) unknown,
  }) {
    return api(statusCode, message, fieldErrors);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int statusCode, String message,
            Map<String, List<String>> fieldErrors)?
        api,
    TResult? Function(String message)? network,
    TResult? Function(String message, StackTrace? stackTrace)? unknown,
  }) {
    return api?.call(statusCode, message, fieldErrors);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int statusCode, String message,
            Map<String, List<String>> fieldErrors)?
        api,
    TResult Function(String message)? network,
    TResult Function(String message, StackTrace? stackTrace)? unknown,
    required TResult orElse(),
  }) {
    if (api != null) {
      return api(statusCode, message, fieldErrors);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ApiError value) api,
    required TResult Function(NetworkError value) network,
    required TResult Function(UnknownError value) unknown,
  }) {
    return api(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ApiError value)? api,
    TResult? Function(NetworkError value)? network,
    TResult? Function(UnknownError value)? unknown,
  }) {
    return api?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ApiError value)? api,
    TResult Function(NetworkError value)? network,
    TResult Function(UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    if (api != null) {
      return api(this);
    }
    return orElse();
  }
}

abstract class ApiError extends AppError {
  const factory ApiError(
      {required final int statusCode,
      required final String message,
      final Map<String, List<String>> fieldErrors}) = _$ApiErrorImpl;
  const ApiError._() : super._();

  int get statusCode;
  @override
  String get message;
  Map<String, List<String>> get fieldErrors;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiErrorImplCopyWith<_$ApiErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NetworkErrorImplCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory _$$NetworkErrorImplCopyWith(
          _$NetworkErrorImpl value, $Res Function(_$NetworkErrorImpl) then) =
      __$$NetworkErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$NetworkErrorImplCopyWithImpl<$Res>
    extends _$AppErrorCopyWithImpl<$Res, _$NetworkErrorImpl>
    implements _$$NetworkErrorImplCopyWith<$Res> {
  __$$NetworkErrorImplCopyWithImpl(
      _$NetworkErrorImpl _value, $Res Function(_$NetworkErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$NetworkErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$NetworkErrorImpl extends NetworkError {
  const _$NetworkErrorImpl({required this.message}) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'AppError.network(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkErrorImplCopyWith<_$NetworkErrorImpl> get copyWith =>
      __$$NetworkErrorImplCopyWithImpl<_$NetworkErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int statusCode, String message,
            Map<String, List<String>> fieldErrors)
        api,
    required TResult Function(String message) network,
    required TResult Function(String message, StackTrace? stackTrace) unknown,
  }) {
    return network(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int statusCode, String message,
            Map<String, List<String>> fieldErrors)?
        api,
    TResult? Function(String message)? network,
    TResult? Function(String message, StackTrace? stackTrace)? unknown,
  }) {
    return network?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int statusCode, String message,
            Map<String, List<String>> fieldErrors)?
        api,
    TResult Function(String message)? network,
    TResult Function(String message, StackTrace? stackTrace)? unknown,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ApiError value) api,
    required TResult Function(NetworkError value) network,
    required TResult Function(UnknownError value) unknown,
  }) {
    return network(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ApiError value)? api,
    TResult? Function(NetworkError value)? network,
    TResult? Function(UnknownError value)? unknown,
  }) {
    return network?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ApiError value)? api,
    TResult Function(NetworkError value)? network,
    TResult Function(UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(this);
    }
    return orElse();
  }
}

abstract class NetworkError extends AppError {
  const factory NetworkError({required final String message}) =
      _$NetworkErrorImpl;
  const NetworkError._() : super._();

  @override
  String get message;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetworkErrorImplCopyWith<_$NetworkErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownErrorImplCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory _$$UnknownErrorImplCopyWith(
          _$UnknownErrorImpl value, $Res Function(_$UnknownErrorImpl) then) =
      __$$UnknownErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, StackTrace? stackTrace});
}

/// @nodoc
class __$$UnknownErrorImplCopyWithImpl<$Res>
    extends _$AppErrorCopyWithImpl<$Res, _$UnknownErrorImpl>
    implements _$$UnknownErrorImplCopyWith<$Res> {
  __$$UnknownErrorImplCopyWithImpl(
      _$UnknownErrorImpl _value, $Res Function(_$UnknownErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? stackTrace = freezed,
  }) {
    return _then(_$UnknownErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      stackTrace: freezed == stackTrace
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

/// @nodoc

class _$UnknownErrorImpl extends UnknownError {
  const _$UnknownErrorImpl({required this.message, this.stackTrace})
      : super._();

  @override
  final String message;
  @override
  final StackTrace? stackTrace;

  @override
  String toString() {
    return 'AppError.unknown(message: $message, stackTrace: $stackTrace)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, stackTrace);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownErrorImplCopyWith<_$UnknownErrorImpl> get copyWith =>
      __$$UnknownErrorImplCopyWithImpl<_$UnknownErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int statusCode, String message,
            Map<String, List<String>> fieldErrors)
        api,
    required TResult Function(String message) network,
    required TResult Function(String message, StackTrace? stackTrace) unknown,
  }) {
    return unknown(message, stackTrace);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int statusCode, String message,
            Map<String, List<String>> fieldErrors)?
        api,
    TResult? Function(String message)? network,
    TResult? Function(String message, StackTrace? stackTrace)? unknown,
  }) {
    return unknown?.call(message, stackTrace);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int statusCode, String message,
            Map<String, List<String>> fieldErrors)?
        api,
    TResult Function(String message)? network,
    TResult Function(String message, StackTrace? stackTrace)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(message, stackTrace);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ApiError value) api,
    required TResult Function(NetworkError value) network,
    required TResult Function(UnknownError value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ApiError value)? api,
    TResult? Function(NetworkError value)? network,
    TResult? Function(UnknownError value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ApiError value)? api,
    TResult Function(NetworkError value)? network,
    TResult Function(UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class UnknownError extends AppError {
  const factory UnknownError(
      {required final String message,
      final StackTrace? stackTrace}) = _$UnknownErrorImpl;
  const UnknownError._() : super._();

  @override
  String get message;
  StackTrace? get stackTrace;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnknownErrorImplCopyWith<_$UnknownErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
