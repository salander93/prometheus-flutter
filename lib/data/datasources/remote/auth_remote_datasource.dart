import 'package:dio/dio.dart';
import 'package:palestra/data/models/auth_models.dart';
import 'package:palestra/data/models/user_model.dart';

class AuthRemoteDatasource {
  AuthRemoteDatasource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/auth/login/',
      data: request.toJson(),
    );
    return LoginResponse.fromJson(response.data!);
  }

  Future<void> register(RegisterRequest request) async {
    await _dio.post<Map<String, dynamic>>(
      '/api/users/',
      data: request.toJson(),
    );
  }

  Future<TokenRefreshResponse> refreshToken(
    TokenRefreshRequest request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/auth/refresh/',
      data: request.toJson(),
    );
    return TokenRefreshResponse.fromJson(response.data!);
  }

  Future<UserModel> getCurrentUser() async {
    final response =
        await _dio.get<Map<String, dynamic>>('/api/users/me/');
    return UserModel.fromJson(response.data!);
  }

  Future<void> requestPasswordReset(PasswordResetRequest request) async {
    await _dio.post<Map<String, dynamic>>(
      '/api/auth/password-reset/',
      data: request.toJson(),
    );
  }

  Future<void> confirmPasswordReset(
    PasswordResetConfirmRequest request,
  ) async {
    await _dio.post<Map<String, dynamic>>(
      '/api/auth/password-reset/confirm/',
      data: request.toJson(),
    );
  }
}
