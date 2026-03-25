import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String username,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String access,
    required String refresh,
    required LoginUserInfo user,
    @JsonKey(name: 'is_new_user') @Default(false) bool isNewUser,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@freezed
class LoginUserInfo with _$LoginUserInfo {
  const factory LoginUserInfo({
    required int id,
    required String username,
    required String email,
    @JsonKey(name: 'full_name') required String fullName,
    required String role,
  }) = _LoginUserInfo;

  factory LoginUserInfo.fromJson(Map<String, dynamic> json) =>
      _$LoginUserInfoFromJson(json);
}

@freezed
class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String username,
    required String email,
    required String password,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    required String role,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}

@freezed
class TokenRefreshRequest with _$TokenRefreshRequest {
  const factory TokenRefreshRequest({
    required String refresh,
  }) = _TokenRefreshRequest;

  factory TokenRefreshRequest.fromJson(Map<String, dynamic> json) =>
      _$TokenRefreshRequestFromJson(json);
}

@freezed
class TokenRefreshResponse with _$TokenRefreshResponse {
  const factory TokenRefreshResponse({
    required String access,
  }) = _TokenRefreshResponse;

  factory TokenRefreshResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenRefreshResponseFromJson(json);
}

@freezed
class PasswordResetRequest with _$PasswordResetRequest {
  const factory PasswordResetRequest({
    required String email,
  }) = _PasswordResetRequest;

  factory PasswordResetRequest.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetRequestFromJson(json);
}

@freezed
class PasswordResetConfirmRequest with _$PasswordResetConfirmRequest {
  const factory PasswordResetConfirmRequest({
    required String token,
    @JsonKey(name: 'new_password') required String newPassword,
  }) = _PasswordResetConfirmRequest;

  factory PasswordResetConfirmRequest.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetConfirmRequestFromJson(json);
}
