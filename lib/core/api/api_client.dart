import 'package:dio/dio.dart';
import 'package:palestra/core/api/api_constants.dart';
import 'package:palestra/core/api/auth_interceptor.dart';
import 'package:palestra/core/storage/token_storage.dart';

class ApiClient {
  ApiClient({
    required TokenStorage tokenStorage,
    void Function()? onAuthFailure,
  }) {
    final refreshDio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
      ),
    );

    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      AuthInterceptor(
        tokenStorage: tokenStorage,
        refreshDio: refreshDio,
        onAuthFailure: onAuthFailure,
      ),
    );
  }

  late final Dio dio;
}
