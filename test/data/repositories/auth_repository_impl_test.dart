import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:palestra/core/storage/token_storage.dart';
import 'package:palestra/data/datasources/remote/auth_remote_datasource.dart';
import 'package:palestra/data/models/auth_models.dart';
import 'package:palestra/data/repositories/auth_repository_impl.dart';

class MockAuthRemoteDatasource extends Mock
    implements AuthRemoteDatasource {}

class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late MockAuthRemoteDatasource mockDatasource;
  late MockTokenStorage mockTokenStorage;
  late AuthRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(
      const LoginRequest(username: '', password: ''),
    );
    registerFallbackValue(
      const RegisterRequest(
        username: '',
        email: '',
        password: '',
        firstName: '',
        lastName: '',
        role: '',
      ),
    );
    registerFallbackValue(const TokenRefreshRequest(refresh: ''));
    registerFallbackValue(const PasswordResetRequest(email: ''));
    registerFallbackValue(
      const PasswordResetConfirmRequest(token: '', newPassword: ''),
    );
  });

  setUp(() {
    mockDatasource = MockAuthRemoteDatasource();
    mockTokenStorage = MockTokenStorage();
    repository = AuthRepositoryImpl(
      remoteDatasource: mockDatasource,
      tokenStorage: mockTokenStorage,
    );
  });

  group('login', () {
    test('stores tokens and returns response on success', () async {
      const loginResponse = LoginResponse(
        access: 'access_123',
        refresh: 'refresh_456',
        user: LoginUserInfo(
          id: 1,
          username: 'mario',
          email: 'mario@test.com',
          fullName: 'Mario Rossi',
          role: 'CLIENT',
        ),
      );
      when(() => mockDatasource.login(any()))
          .thenAnswer((_) async => loginResponse);
      when(
        () => mockTokenStorage.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});

      final result =
          await repository.login(username: 'mario', password: 'secret');

      expect(result.access, 'access_123');
      verify(
        () => mockTokenStorage.saveTokens(
          accessToken: 'access_123',
          refreshToken: 'refresh_456',
        ),
      ).called(1);
    });
  });

  group('logout', () {
    test('clears tokens', () async {
      when(() => mockTokenStorage.clearTokens()).thenAnswer((_) async {});
      await repository.logout();
      verify(() => mockTokenStorage.clearTokens()).called(1);
    });
  });

  group('isAuthenticated', () {
    test('returns true when tokens exist', () async {
      when(() => mockTokenStorage.hasTokens()).thenAnswer((_) async => true);
      final result = await repository.isAuthenticated();
      expect(result, isTrue);
    });
  });
}
