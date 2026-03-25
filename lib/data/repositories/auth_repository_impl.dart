import 'package:palestra/core/storage/token_storage.dart';
import 'package:palestra/data/datasources/remote/auth_remote_datasource.dart';
import 'package:palestra/data/models/auth_models.dart';
import 'package:palestra/data/models/user_model.dart';
import 'package:palestra/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDatasource remoteDatasource,
    required TokenStorage tokenStorage,
  })  : _remoteDatasource = remoteDatasource,
        _tokenStorage = tokenStorage;

  final AuthRemoteDatasource _remoteDatasource;
  final TokenStorage _tokenStorage;

  @override
  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final response = await _remoteDatasource.login(
      LoginRequest(username: username, password: password),
    );
    await _tokenStorage.saveTokens(
      accessToken: response.access,
      refreshToken: response.refresh,
    );
    return response;
  }

  @override
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    await _remoteDatasource.register(
      RegisterRequest(
        username: username,
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        role: role,
      ),
    );
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    await _remoteDatasource.requestPasswordReset(
      PasswordResetRequest(email: email),
    );
  }

  @override
  Future<void> confirmPasswordReset({
    required String token,
    required String newPassword,
  }) async {
    await _remoteDatasource.confirmPasswordReset(
      PasswordResetConfirmRequest(token: token, newPassword: newPassword),
    );
  }

  @override
  Future<UserModel> getCurrentUser() async =>
      _remoteDatasource.getCurrentUser();

  @override
  Future<bool> refreshToken() async {
    final storedRefreshToken = await _tokenStorage.getRefreshToken();
    if (storedRefreshToken == null) return false;
    try {
      final response = await _remoteDatasource.refreshToken(
        TokenRefreshRequest(refresh: storedRefreshToken),
      );
      await _tokenStorage.saveAccessToken(response.access);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> logout() async => _tokenStorage.clearTokens();

  @override
  Future<bool> isAuthenticated() async => _tokenStorage.hasTokens();
}
