// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) {
  return _LoginRequest.fromJson(json);
}

/// @nodoc
mixin _$LoginRequest {
  String get username => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Serializes this LoginRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginRequestCopyWith<LoginRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginRequestCopyWith<$Res> {
  factory $LoginRequestCopyWith(
          LoginRequest value, $Res Function(LoginRequest) then) =
      _$LoginRequestCopyWithImpl<$Res, LoginRequest>;
  @useResult
  $Res call({String username, String password});
}

/// @nodoc
class _$LoginRequestCopyWithImpl<$Res, $Val extends LoginRequest>
    implements $LoginRequestCopyWith<$Res> {
  _$LoginRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? password = null,
  }) {
    return _then(_value.copyWith(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoginRequestImplCopyWith<$Res>
    implements $LoginRequestCopyWith<$Res> {
  factory _$$LoginRequestImplCopyWith(
          _$LoginRequestImpl value, $Res Function(_$LoginRequestImpl) then) =
      __$$LoginRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String username, String password});
}

/// @nodoc
class __$$LoginRequestImplCopyWithImpl<$Res>
    extends _$LoginRequestCopyWithImpl<$Res, _$LoginRequestImpl>
    implements _$$LoginRequestImplCopyWith<$Res> {
  __$$LoginRequestImplCopyWithImpl(
      _$LoginRequestImpl _value, $Res Function(_$LoginRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? password = null,
  }) {
    return _then(_$LoginRequestImpl(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginRequestImpl implements _LoginRequest {
  const _$LoginRequestImpl({required this.username, required this.password});

  factory _$LoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginRequestImplFromJson(json);

  @override
  final String username;
  @override
  final String password;

  @override
  String toString() {
    return 'LoginRequest(username: $username, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginRequestImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, username, password);

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      __$$LoginRequestImplCopyWithImpl<_$LoginRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginRequestImplToJson(
      this,
    );
  }
}

abstract class _LoginRequest implements LoginRequest {
  const factory _LoginRequest(
      {required final String username,
      required final String password}) = _$LoginRequestImpl;

  factory _LoginRequest.fromJson(Map<String, dynamic> json) =
      _$LoginRequestImpl.fromJson;

  @override
  String get username;
  @override
  String get password;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return _LoginResponse.fromJson(json);
}

/// @nodoc
mixin _$LoginResponse {
  String get access => throw _privateConstructorUsedError;
  String get refresh => throw _privateConstructorUsedError;
  LoginUserInfo get user => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_new_user')
  bool get isNewUser => throw _privateConstructorUsedError;

  /// Serializes this LoginResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginResponseCopyWith<LoginResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginResponseCopyWith<$Res> {
  factory $LoginResponseCopyWith(
          LoginResponse value, $Res Function(LoginResponse) then) =
      _$LoginResponseCopyWithImpl<$Res, LoginResponse>;
  @useResult
  $Res call(
      {String access,
      String refresh,
      LoginUserInfo user,
      @JsonKey(name: 'is_new_user') bool isNewUser});

  $LoginUserInfoCopyWith<$Res> get user;
}

/// @nodoc
class _$LoginResponseCopyWithImpl<$Res, $Val extends LoginResponse>
    implements $LoginResponseCopyWith<$Res> {
  _$LoginResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? access = null,
    Object? refresh = null,
    Object? user = null,
    Object? isNewUser = null,
  }) {
    return _then(_value.copyWith(
      access: null == access
          ? _value.access
          : access // ignore: cast_nullable_to_non_nullable
              as String,
      refresh: null == refresh
          ? _value.refresh
          : refresh // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as LoginUserInfo,
      isNewUser: null == isNewUser
          ? _value.isNewUser
          : isNewUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LoginUserInfoCopyWith<$Res> get user {
    return $LoginUserInfoCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LoginResponseImplCopyWith<$Res>
    implements $LoginResponseCopyWith<$Res> {
  factory _$$LoginResponseImplCopyWith(
          _$LoginResponseImpl value, $Res Function(_$LoginResponseImpl) then) =
      __$$LoginResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String access,
      String refresh,
      LoginUserInfo user,
      @JsonKey(name: 'is_new_user') bool isNewUser});

  @override
  $LoginUserInfoCopyWith<$Res> get user;
}

/// @nodoc
class __$$LoginResponseImplCopyWithImpl<$Res>
    extends _$LoginResponseCopyWithImpl<$Res, _$LoginResponseImpl>
    implements _$$LoginResponseImplCopyWith<$Res> {
  __$$LoginResponseImplCopyWithImpl(
      _$LoginResponseImpl _value, $Res Function(_$LoginResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? access = null,
    Object? refresh = null,
    Object? user = null,
    Object? isNewUser = null,
  }) {
    return _then(_$LoginResponseImpl(
      access: null == access
          ? _value.access
          : access // ignore: cast_nullable_to_non_nullable
              as String,
      refresh: null == refresh
          ? _value.refresh
          : refresh // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as LoginUserInfo,
      isNewUser: null == isNewUser
          ? _value.isNewUser
          : isNewUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginResponseImpl implements _LoginResponse {
  const _$LoginResponseImpl(
      {required this.access,
      required this.refresh,
      required this.user,
      @JsonKey(name: 'is_new_user') this.isNewUser = false});

  factory _$LoginResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginResponseImplFromJson(json);

  @override
  final String access;
  @override
  final String refresh;
  @override
  final LoginUserInfo user;
  @override
  @JsonKey(name: 'is_new_user')
  final bool isNewUser;

  @override
  String toString() {
    return 'LoginResponse(access: $access, refresh: $refresh, user: $user, isNewUser: $isNewUser)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginResponseImpl &&
            (identical(other.access, access) || other.access == access) &&
            (identical(other.refresh, refresh) || other.refresh == refresh) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.isNewUser, isNewUser) ||
                other.isNewUser == isNewUser));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, access, refresh, user, isNewUser);

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginResponseImplCopyWith<_$LoginResponseImpl> get copyWith =>
      __$$LoginResponseImplCopyWithImpl<_$LoginResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginResponseImplToJson(
      this,
    );
  }
}

abstract class _LoginResponse implements LoginResponse {
  const factory _LoginResponse(
          {required final String access,
          required final String refresh,
          required final LoginUserInfo user,
          @JsonKey(name: 'is_new_user') final bool isNewUser}) =
      _$LoginResponseImpl;

  factory _LoginResponse.fromJson(Map<String, dynamic> json) =
      _$LoginResponseImpl.fromJson;

  @override
  String get access;
  @override
  String get refresh;
  @override
  LoginUserInfo get user;
  @override
  @JsonKey(name: 'is_new_user')
  bool get isNewUser;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginResponseImplCopyWith<_$LoginResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoginUserInfo _$LoginUserInfoFromJson(Map<String, dynamic> json) {
  return _LoginUserInfo.fromJson(json);
}

/// @nodoc
mixin _$LoginUserInfo {
  int get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String get fullName => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;

  /// Serializes this LoginUserInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginUserInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginUserInfoCopyWith<LoginUserInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginUserInfoCopyWith<$Res> {
  factory $LoginUserInfoCopyWith(
          LoginUserInfo value, $Res Function(LoginUserInfo) then) =
      _$LoginUserInfoCopyWithImpl<$Res, LoginUserInfo>;
  @useResult
  $Res call(
      {int id,
      String username,
      String email,
      @JsonKey(name: 'full_name') String fullName,
      String role});
}

/// @nodoc
class _$LoginUserInfoCopyWithImpl<$Res, $Val extends LoginUserInfo>
    implements $LoginUserInfoCopyWith<$Res> {
  _$LoginUserInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginUserInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? email = null,
    Object? fullName = null,
    Object? role = null,
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
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoginUserInfoImplCopyWith<$Res>
    implements $LoginUserInfoCopyWith<$Res> {
  factory _$$LoginUserInfoImplCopyWith(
          _$LoginUserInfoImpl value, $Res Function(_$LoginUserInfoImpl) then) =
      __$$LoginUserInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String username,
      String email,
      @JsonKey(name: 'full_name') String fullName,
      String role});
}

/// @nodoc
class __$$LoginUserInfoImplCopyWithImpl<$Res>
    extends _$LoginUserInfoCopyWithImpl<$Res, _$LoginUserInfoImpl>
    implements _$$LoginUserInfoImplCopyWith<$Res> {
  __$$LoginUserInfoImplCopyWithImpl(
      _$LoginUserInfoImpl _value, $Res Function(_$LoginUserInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginUserInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? email = null,
    Object? fullName = null,
    Object? role = null,
  }) {
    return _then(_$LoginUserInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginUserInfoImpl implements _LoginUserInfo {
  const _$LoginUserInfoImpl(
      {required this.id,
      required this.username,
      required this.email,
      @JsonKey(name: 'full_name') required this.fullName,
      required this.role});

  factory _$LoginUserInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginUserInfoImplFromJson(json);

  @override
  final int id;
  @override
  final String username;
  @override
  final String email;
  @override
  @JsonKey(name: 'full_name')
  final String fullName;
  @override
  final String role;

  @override
  String toString() {
    return 'LoginUserInfo(id: $id, username: $username, email: $email, fullName: $fullName, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginUserInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, username, email, fullName, role);

  /// Create a copy of LoginUserInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginUserInfoImplCopyWith<_$LoginUserInfoImpl> get copyWith =>
      __$$LoginUserInfoImplCopyWithImpl<_$LoginUserInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginUserInfoImplToJson(
      this,
    );
  }
}

abstract class _LoginUserInfo implements LoginUserInfo {
  const factory _LoginUserInfo(
      {required final int id,
      required final String username,
      required final String email,
      @JsonKey(name: 'full_name') required final String fullName,
      required final String role}) = _$LoginUserInfoImpl;

  factory _LoginUserInfo.fromJson(Map<String, dynamic> json) =
      _$LoginUserInfoImpl.fromJson;

  @override
  int get id;
  @override
  String get username;
  @override
  String get email;
  @override
  @JsonKey(name: 'full_name')
  String get fullName;
  @override
  String get role;

  /// Create a copy of LoginUserInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginUserInfoImplCopyWith<_$LoginUserInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) {
  return _RegisterRequest.fromJson(json);
}

/// @nodoc
mixin _$RegisterRequest {
  String get username => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String get lastName => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;

  /// Serializes this RegisterRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterRequestCopyWith<RegisterRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterRequestCopyWith<$Res> {
  factory $RegisterRequestCopyWith(
          RegisterRequest value, $Res Function(RegisterRequest) then) =
      _$RegisterRequestCopyWithImpl<$Res, RegisterRequest>;
  @useResult
  $Res call(
      {String username,
      String email,
      String password,
      @JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      String role});
}

/// @nodoc
class _$RegisterRequestCopyWithImpl<$Res, $Val extends RegisterRequest>
    implements $RegisterRequestCopyWith<$Res> {
  _$RegisterRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? email = null,
    Object? password = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? role = null,
  }) {
    return _then(_value.copyWith(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegisterRequestImplCopyWith<$Res>
    implements $RegisterRequestCopyWith<$Res> {
  factory _$$RegisterRequestImplCopyWith(_$RegisterRequestImpl value,
          $Res Function(_$RegisterRequestImpl) then) =
      __$$RegisterRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String username,
      String email,
      String password,
      @JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      String role});
}

/// @nodoc
class __$$RegisterRequestImplCopyWithImpl<$Res>
    extends _$RegisterRequestCopyWithImpl<$Res, _$RegisterRequestImpl>
    implements _$$RegisterRequestImplCopyWith<$Res> {
  __$$RegisterRequestImplCopyWithImpl(
      _$RegisterRequestImpl _value, $Res Function(_$RegisterRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? email = null,
    Object? password = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? role = null,
  }) {
    return _then(_$RegisterRequestImpl(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterRequestImpl implements _RegisterRequest {
  const _$RegisterRequestImpl(
      {required this.username,
      required this.email,
      required this.password,
      @JsonKey(name: 'first_name') required this.firstName,
      @JsonKey(name: 'last_name') required this.lastName,
      required this.role});

  factory _$RegisterRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterRequestImplFromJson(json);

  @override
  final String username;
  @override
  final String email;
  @override
  final String password;
  @override
  @JsonKey(name: 'first_name')
  final String firstName;
  @override
  @JsonKey(name: 'last_name')
  final String lastName;
  @override
  final String role;

  @override
  String toString() {
    return 'RegisterRequest(username: $username, email: $email, password: $password, firstName: $firstName, lastName: $lastName, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterRequestImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, username, email, password, firstName, lastName, role);

  /// Create a copy of RegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterRequestImplCopyWith<_$RegisterRequestImpl> get copyWith =>
      __$$RegisterRequestImplCopyWithImpl<_$RegisterRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterRequestImplToJson(
      this,
    );
  }
}

abstract class _RegisterRequest implements RegisterRequest {
  const factory _RegisterRequest(
      {required final String username,
      required final String email,
      required final String password,
      @JsonKey(name: 'first_name') required final String firstName,
      @JsonKey(name: 'last_name') required final String lastName,
      required final String role}) = _$RegisterRequestImpl;

  factory _RegisterRequest.fromJson(Map<String, dynamic> json) =
      _$RegisterRequestImpl.fromJson;

  @override
  String get username;
  @override
  String get email;
  @override
  String get password;
  @override
  @JsonKey(name: 'first_name')
  String get firstName;
  @override
  @JsonKey(name: 'last_name')
  String get lastName;
  @override
  String get role;

  /// Create a copy of RegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterRequestImplCopyWith<_$RegisterRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TokenRefreshRequest _$TokenRefreshRequestFromJson(Map<String, dynamic> json) {
  return _TokenRefreshRequest.fromJson(json);
}

/// @nodoc
mixin _$TokenRefreshRequest {
  String get refresh => throw _privateConstructorUsedError;

  /// Serializes this TokenRefreshRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TokenRefreshRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TokenRefreshRequestCopyWith<TokenRefreshRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TokenRefreshRequestCopyWith<$Res> {
  factory $TokenRefreshRequestCopyWith(
          TokenRefreshRequest value, $Res Function(TokenRefreshRequest) then) =
      _$TokenRefreshRequestCopyWithImpl<$Res, TokenRefreshRequest>;
  @useResult
  $Res call({String refresh});
}

/// @nodoc
class _$TokenRefreshRequestCopyWithImpl<$Res, $Val extends TokenRefreshRequest>
    implements $TokenRefreshRequestCopyWith<$Res> {
  _$TokenRefreshRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TokenRefreshRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? refresh = null,
  }) {
    return _then(_value.copyWith(
      refresh: null == refresh
          ? _value.refresh
          : refresh // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TokenRefreshRequestImplCopyWith<$Res>
    implements $TokenRefreshRequestCopyWith<$Res> {
  factory _$$TokenRefreshRequestImplCopyWith(_$TokenRefreshRequestImpl value,
          $Res Function(_$TokenRefreshRequestImpl) then) =
      __$$TokenRefreshRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String refresh});
}

/// @nodoc
class __$$TokenRefreshRequestImplCopyWithImpl<$Res>
    extends _$TokenRefreshRequestCopyWithImpl<$Res, _$TokenRefreshRequestImpl>
    implements _$$TokenRefreshRequestImplCopyWith<$Res> {
  __$$TokenRefreshRequestImplCopyWithImpl(_$TokenRefreshRequestImpl _value,
      $Res Function(_$TokenRefreshRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of TokenRefreshRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? refresh = null,
  }) {
    return _then(_$TokenRefreshRequestImpl(
      refresh: null == refresh
          ? _value.refresh
          : refresh // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TokenRefreshRequestImpl implements _TokenRefreshRequest {
  const _$TokenRefreshRequestImpl({required this.refresh});

  factory _$TokenRefreshRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$TokenRefreshRequestImplFromJson(json);

  @override
  final String refresh;

  @override
  String toString() {
    return 'TokenRefreshRequest(refresh: $refresh)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TokenRefreshRequestImpl &&
            (identical(other.refresh, refresh) || other.refresh == refresh));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, refresh);

  /// Create a copy of TokenRefreshRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TokenRefreshRequestImplCopyWith<_$TokenRefreshRequestImpl> get copyWith =>
      __$$TokenRefreshRequestImplCopyWithImpl<_$TokenRefreshRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TokenRefreshRequestImplToJson(
      this,
    );
  }
}

abstract class _TokenRefreshRequest implements TokenRefreshRequest {
  const factory _TokenRefreshRequest({required final String refresh}) =
      _$TokenRefreshRequestImpl;

  factory _TokenRefreshRequest.fromJson(Map<String, dynamic> json) =
      _$TokenRefreshRequestImpl.fromJson;

  @override
  String get refresh;

  /// Create a copy of TokenRefreshRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TokenRefreshRequestImplCopyWith<_$TokenRefreshRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TokenRefreshResponse _$TokenRefreshResponseFromJson(Map<String, dynamic> json) {
  return _TokenRefreshResponse.fromJson(json);
}

/// @nodoc
mixin _$TokenRefreshResponse {
  String get access => throw _privateConstructorUsedError;

  /// Serializes this TokenRefreshResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TokenRefreshResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TokenRefreshResponseCopyWith<TokenRefreshResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TokenRefreshResponseCopyWith<$Res> {
  factory $TokenRefreshResponseCopyWith(TokenRefreshResponse value,
          $Res Function(TokenRefreshResponse) then) =
      _$TokenRefreshResponseCopyWithImpl<$Res, TokenRefreshResponse>;
  @useResult
  $Res call({String access});
}

/// @nodoc
class _$TokenRefreshResponseCopyWithImpl<$Res,
        $Val extends TokenRefreshResponse>
    implements $TokenRefreshResponseCopyWith<$Res> {
  _$TokenRefreshResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TokenRefreshResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? access = null,
  }) {
    return _then(_value.copyWith(
      access: null == access
          ? _value.access
          : access // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TokenRefreshResponseImplCopyWith<$Res>
    implements $TokenRefreshResponseCopyWith<$Res> {
  factory _$$TokenRefreshResponseImplCopyWith(_$TokenRefreshResponseImpl value,
          $Res Function(_$TokenRefreshResponseImpl) then) =
      __$$TokenRefreshResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String access});
}

/// @nodoc
class __$$TokenRefreshResponseImplCopyWithImpl<$Res>
    extends _$TokenRefreshResponseCopyWithImpl<$Res, _$TokenRefreshResponseImpl>
    implements _$$TokenRefreshResponseImplCopyWith<$Res> {
  __$$TokenRefreshResponseImplCopyWithImpl(_$TokenRefreshResponseImpl _value,
      $Res Function(_$TokenRefreshResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of TokenRefreshResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? access = null,
  }) {
    return _then(_$TokenRefreshResponseImpl(
      access: null == access
          ? _value.access
          : access // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TokenRefreshResponseImpl implements _TokenRefreshResponse {
  const _$TokenRefreshResponseImpl({required this.access});

  factory _$TokenRefreshResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TokenRefreshResponseImplFromJson(json);

  @override
  final String access;

  @override
  String toString() {
    return 'TokenRefreshResponse(access: $access)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TokenRefreshResponseImpl &&
            (identical(other.access, access) || other.access == access));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, access);

  /// Create a copy of TokenRefreshResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TokenRefreshResponseImplCopyWith<_$TokenRefreshResponseImpl>
      get copyWith =>
          __$$TokenRefreshResponseImplCopyWithImpl<_$TokenRefreshResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TokenRefreshResponseImplToJson(
      this,
    );
  }
}

abstract class _TokenRefreshResponse implements TokenRefreshResponse {
  const factory _TokenRefreshResponse({required final String access}) =
      _$TokenRefreshResponseImpl;

  factory _TokenRefreshResponse.fromJson(Map<String, dynamic> json) =
      _$TokenRefreshResponseImpl.fromJson;

  @override
  String get access;

  /// Create a copy of TokenRefreshResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TokenRefreshResponseImplCopyWith<_$TokenRefreshResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PasswordResetRequest _$PasswordResetRequestFromJson(Map<String, dynamic> json) {
  return _PasswordResetRequest.fromJson(json);
}

/// @nodoc
mixin _$PasswordResetRequest {
  String get email => throw _privateConstructorUsedError;

  /// Serializes this PasswordResetRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PasswordResetRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PasswordResetRequestCopyWith<PasswordResetRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordResetRequestCopyWith<$Res> {
  factory $PasswordResetRequestCopyWith(PasswordResetRequest value,
          $Res Function(PasswordResetRequest) then) =
      _$PasswordResetRequestCopyWithImpl<$Res, PasswordResetRequest>;
  @useResult
  $Res call({String email});
}

/// @nodoc
class _$PasswordResetRequestCopyWithImpl<$Res,
        $Val extends PasswordResetRequest>
    implements $PasswordResetRequestCopyWith<$Res> {
  _$PasswordResetRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PasswordResetRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PasswordResetRequestImplCopyWith<$Res>
    implements $PasswordResetRequestCopyWith<$Res> {
  factory _$$PasswordResetRequestImplCopyWith(_$PasswordResetRequestImpl value,
          $Res Function(_$PasswordResetRequestImpl) then) =
      __$$PasswordResetRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email});
}

/// @nodoc
class __$$PasswordResetRequestImplCopyWithImpl<$Res>
    extends _$PasswordResetRequestCopyWithImpl<$Res, _$PasswordResetRequestImpl>
    implements _$$PasswordResetRequestImplCopyWith<$Res> {
  __$$PasswordResetRequestImplCopyWithImpl(_$PasswordResetRequestImpl _value,
      $Res Function(_$PasswordResetRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of PasswordResetRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_$PasswordResetRequestImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PasswordResetRequestImpl implements _PasswordResetRequest {
  const _$PasswordResetRequestImpl({required this.email});

  factory _$PasswordResetRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PasswordResetRequestImplFromJson(json);

  @override
  final String email;

  @override
  String toString() {
    return 'PasswordResetRequest(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordResetRequestImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email);

  /// Create a copy of PasswordResetRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordResetRequestImplCopyWith<_$PasswordResetRequestImpl>
      get copyWith =>
          __$$PasswordResetRequestImplCopyWithImpl<_$PasswordResetRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PasswordResetRequestImplToJson(
      this,
    );
  }
}

abstract class _PasswordResetRequest implements PasswordResetRequest {
  const factory _PasswordResetRequest({required final String email}) =
      _$PasswordResetRequestImpl;

  factory _PasswordResetRequest.fromJson(Map<String, dynamic> json) =
      _$PasswordResetRequestImpl.fromJson;

  @override
  String get email;

  /// Create a copy of PasswordResetRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PasswordResetRequestImplCopyWith<_$PasswordResetRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PasswordResetConfirmRequest _$PasswordResetConfirmRequestFromJson(
    Map<String, dynamic> json) {
  return _PasswordResetConfirmRequest.fromJson(json);
}

/// @nodoc
mixin _$PasswordResetConfirmRequest {
  String get token => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_password')
  String get newPassword => throw _privateConstructorUsedError;

  /// Serializes this PasswordResetConfirmRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PasswordResetConfirmRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PasswordResetConfirmRequestCopyWith<PasswordResetConfirmRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordResetConfirmRequestCopyWith<$Res> {
  factory $PasswordResetConfirmRequestCopyWith(
          PasswordResetConfirmRequest value,
          $Res Function(PasswordResetConfirmRequest) then) =
      _$PasswordResetConfirmRequestCopyWithImpl<$Res,
          PasswordResetConfirmRequest>;
  @useResult
  $Res call({String token, @JsonKey(name: 'new_password') String newPassword});
}

/// @nodoc
class _$PasswordResetConfirmRequestCopyWithImpl<$Res,
        $Val extends PasswordResetConfirmRequest>
    implements $PasswordResetConfirmRequestCopyWith<$Res> {
  _$PasswordResetConfirmRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PasswordResetConfirmRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? newPassword = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PasswordResetConfirmRequestImplCopyWith<$Res>
    implements $PasswordResetConfirmRequestCopyWith<$Res> {
  factory _$$PasswordResetConfirmRequestImplCopyWith(
          _$PasswordResetConfirmRequestImpl value,
          $Res Function(_$PasswordResetConfirmRequestImpl) then) =
      __$$PasswordResetConfirmRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token, @JsonKey(name: 'new_password') String newPassword});
}

/// @nodoc
class __$$PasswordResetConfirmRequestImplCopyWithImpl<$Res>
    extends _$PasswordResetConfirmRequestCopyWithImpl<$Res,
        _$PasswordResetConfirmRequestImpl>
    implements _$$PasswordResetConfirmRequestImplCopyWith<$Res> {
  __$$PasswordResetConfirmRequestImplCopyWithImpl(
      _$PasswordResetConfirmRequestImpl _value,
      $Res Function(_$PasswordResetConfirmRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of PasswordResetConfirmRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? newPassword = null,
  }) {
    return _then(_$PasswordResetConfirmRequestImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PasswordResetConfirmRequestImpl
    implements _PasswordResetConfirmRequest {
  const _$PasswordResetConfirmRequestImpl(
      {required this.token,
      @JsonKey(name: 'new_password') required this.newPassword});

  factory _$PasswordResetConfirmRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$PasswordResetConfirmRequestImplFromJson(json);

  @override
  final String token;
  @override
  @JsonKey(name: 'new_password')
  final String newPassword;

  @override
  String toString() {
    return 'PasswordResetConfirmRequest(token: $token, newPassword: $newPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordResetConfirmRequestImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token, newPassword);

  /// Create a copy of PasswordResetConfirmRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordResetConfirmRequestImplCopyWith<_$PasswordResetConfirmRequestImpl>
      get copyWith => __$$PasswordResetConfirmRequestImplCopyWithImpl<
          _$PasswordResetConfirmRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PasswordResetConfirmRequestImplToJson(
      this,
    );
  }
}

abstract class _PasswordResetConfirmRequest
    implements PasswordResetConfirmRequest {
  const factory _PasswordResetConfirmRequest(
          {required final String token,
          @JsonKey(name: 'new_password') required final String newPassword}) =
      _$PasswordResetConfirmRequestImpl;

  factory _PasswordResetConfirmRequest.fromJson(Map<String, dynamic> json) =
      _$PasswordResetConfirmRequestImpl.fromJson;

  @override
  String get token;
  @override
  @JsonKey(name: 'new_password')
  String get newPassword;

  /// Create a copy of PasswordResetConfirmRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PasswordResetConfirmRequestImplCopyWith<_$PasswordResetConfirmRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
