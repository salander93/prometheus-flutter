import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:palestra/core/api/auth_interceptor.dart';
import 'package:palestra/core/storage/token_storage.dart';

class MockTokenStorage extends Mock implements TokenStorage {}

class MockDio extends Mock implements Dio {}

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

class FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  late MockTokenStorage mockTokenStorage;
  late AuthInterceptor interceptor;

  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
  });

  setUp(() {
    mockTokenStorage = MockTokenStorage();
    interceptor = AuthInterceptor(
      tokenStorage: mockTokenStorage,
      refreshDio: MockDio(),
    );
  });

  group('AuthInterceptor onRequest', () {
    test('adds Authorization header when token exists', () async {
      when(() => mockTokenStorage.getAccessToken())
          .thenAnswer((_) async => 'test_token');

      final options = RequestOptions(path: '/api/test/');
      final handler = MockRequestInterceptorHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], 'Bearer test_token');
      verify(() => handler.next(options)).called(1);
    });

    test('does not add header when no token', () async {
      when(() => mockTokenStorage.getAccessToken())
          .thenAnswer((_) async => null);

      final options = RequestOptions(path: '/api/test/');
      final handler = MockRequestInterceptorHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers.containsKey('Authorization'), isFalse);
      verify(() => handler.next(options)).called(1);
    });
  });
}
