// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      username: json['username'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

_$LoginResponseImpl _$$LoginResponseImplFromJson(Map<String, dynamic> json) =>
    _$LoginResponseImpl(
      access: json['access'] as String,
      refresh: json['refresh'] as String,
      user: LoginUserInfo.fromJson(json['user'] as Map<String, dynamic>),
      isNewUser: json['is_new_user'] as bool? ?? false,
    );

Map<String, dynamic> _$$LoginResponseImplToJson(_$LoginResponseImpl instance) =>
    <String, dynamic>{
      'access': instance.access,
      'refresh': instance.refresh,
      'user': instance.user,
      'is_new_user': instance.isNewUser,
    };

_$LoginUserInfoImpl _$$LoginUserInfoImplFromJson(Map<String, dynamic> json) =>
    _$LoginUserInfoImpl(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$$LoginUserInfoImplToJson(_$LoginUserInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'full_name': instance.fullName,
      'role': instance.role,
    };

_$RegisterRequestImpl _$$RegisterRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RegisterRequestImpl(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$$RegisterRequestImplToJson(
        _$RegisterRequestImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'role': instance.role,
    };

_$TokenRefreshRequestImpl _$$TokenRefreshRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$TokenRefreshRequestImpl(
      refresh: json['refresh'] as String,
    );

Map<String, dynamic> _$$TokenRefreshRequestImplToJson(
        _$TokenRefreshRequestImpl instance) =>
    <String, dynamic>{
      'refresh': instance.refresh,
    };

_$TokenRefreshResponseImpl _$$TokenRefreshResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$TokenRefreshResponseImpl(
      access: json['access'] as String,
    );

Map<String, dynamic> _$$TokenRefreshResponseImplToJson(
        _$TokenRefreshResponseImpl instance) =>
    <String, dynamic>{
      'access': instance.access,
    };

_$PasswordResetRequestImpl _$$PasswordResetRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$PasswordResetRequestImpl(
      email: json['email'] as String,
    );

Map<String, dynamic> _$$PasswordResetRequestImplToJson(
        _$PasswordResetRequestImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
    };

_$PasswordResetConfirmRequestImpl _$$PasswordResetConfirmRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$PasswordResetConfirmRequestImpl(
      token: json['token'] as String,
      newPassword: json['new_password'] as String,
    );

Map<String, dynamic> _$$PasswordResetConfirmRequestImplToJson(
        _$PasswordResetConfirmRequestImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'new_password': instance.newPassword,
    };
