import 'dart:async';

import 'package:dio/dio.dart';
import 'package:palestra/core/storage/token_storage.dart';

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required TokenStorage tokenStorage,
    required Dio refreshDio,
    void Function()? onAuthFailure,
  })  : _tokenStorage = tokenStorage,
        _refreshDio = refreshDio,
        _onAuthFailure = onAuthFailure;

  final TokenStorage _tokenStorage;
  final Dio _refreshDio;
  final void Function()? _onAuthFailure;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final path = err.requestOptions.path;
    if (path.contains('/auth/refresh') || path.contains('/auth/login')) {
      _onAuthFailure?.call();
      return handler.next(err);
    }

    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) {
        _onAuthFailure?.call();
        return handler.next(err);
      }

      final response = await _refreshDio.post<Map<String, dynamic>>(
        '/api/auth/refresh/',
        data: {'refresh': refreshToken},
      );

      final newAccessToken = response.data?['access'] as String?;
      if (newAccessToken == null) {
        _onAuthFailure?.call();
        return handler.next(err);
      }

      await _tokenStorage.saveAccessToken(newAccessToken);

      final retryOptions = err.requestOptions;
      retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

      final retryResponse = await _refreshDio.fetch<dynamic>(retryOptions);
      return handler.resolve(retryResponse);
    } on DioException {
      _onAuthFailure?.call();
      return handler.next(err);
    }
  }
}
