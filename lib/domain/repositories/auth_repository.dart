import 'package:palestra/data/models/auth_models.dart';
import 'package:palestra/data/models/user_model.dart';

abstract class AuthRepository {
  Future<LoginResponse> login({
    required String username,
    required String password,
  });

  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  });

  Future<void> requestPasswordReset({required String email});

  Future<void> confirmPasswordReset({
    required String token,
    required String newPassword,
  });

  Future<UserModel> getCurrentUser();

  Future<bool> refreshToken();

  Future<void> logout();

  Future<bool> isAuthenticated();
}
