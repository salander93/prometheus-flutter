import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:palestra/core/storage/token_storage.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockStorage;
  late TokenStorage tokenStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    tokenStorage = TokenStorage(storage: mockStorage);
  });

  group('TokenStorage', () {
    test('saveTokens stores access and refresh tokens', () async {
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      await tokenStorage.saveTokens(
        accessToken: 'access_123',
        refreshToken: 'refresh_456',
      );

      verify(
        () => mockStorage.write(
          key: 'access_token',
          value: 'access_123',
        ),
      ).called(1);
      verify(
        () => mockStorage.write(
          key: 'refresh_token',
          value: 'refresh_456',
        ),
      ).called(1);
    });

    test('getAccessToken returns stored token', () async {
      when(
        () => mockStorage.read(key: 'access_token'),
      ).thenAnswer((_) async => 'access_123');
      final result = await tokenStorage.getAccessToken();
      expect(result, 'access_123');
    });

    test('getRefreshToken returns stored token', () async {
      when(
        () => mockStorage.read(key: 'refresh_token'),
      ).thenAnswer((_) async => 'refresh_456');
      final result = await tokenStorage.getRefreshToken();
      expect(result, 'refresh_456');
    });

    test('clearTokens deletes all tokens', () async {
      when(() => mockStorage.deleteAll()).thenAnswer((_) async {});
      await tokenStorage.clearTokens();
      verify(() => mockStorage.deleteAll()).called(1);
    });

    test('hasTokens returns true when access token exists', () async {
      when(
        () => mockStorage.read(key: 'access_token'),
      ).thenAnswer((_) async => 'some_token');
      final result = await tokenStorage.hasTokens();
      expect(result, isTrue);
    });

    test('hasTokens returns false when no access token', () async {
      when(
        () => mockStorage.read(key: 'access_token'),
      ).thenAnswer((_) async => null);
      final result = await tokenStorage.hasTokens();
      expect(result, isFalse);
    });
  });
}
