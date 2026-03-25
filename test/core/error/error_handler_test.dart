import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/core/error/app_error.dart';
import 'package:palestra/core/error/error_handler.dart';

void main() {
  group('ErrorHandler', () {
    test('handles connection timeout as NetworkError', () {
      final error = DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(),
      );
      final result = ErrorHandler.handle(error);
      expect(result, isA<NetworkError>());
    });

    test('handles bad response with DRF detail field', () {
      final error = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 403,
          data: {'detail': 'Non autorizzato.'},
          requestOptions: RequestOptions(),
        ),
        requestOptions: RequestOptions(),
      );
      final result = ErrorHandler.handle(error);
      expect(result, isA<ApiError>());
      expect((result as ApiError).statusCode, 403);
      expect(result.message, 'Non autorizzato.');
    });

    test('handles bad response with field validation errors', () {
      final error = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 400,
          data: {
            'email': ['Questa email è già in uso.'],
            'password': ['Troppo corta.', 'Troppo comune.'],
          },
          requestOptions: RequestOptions(),
        ),
        requestOptions: RequestOptions(),
      );
      final result = ErrorHandler.handle(error);
      expect(result, isA<ApiError>());
      final apiError = result as ApiError;
      expect(apiError.fieldErrors['email'], ['Questa email è già in uso.']);
      expect(apiError.fieldErrors['password']?.length, 2);
    });

    test('handles non-DioException as UnknownError', () {
      final result = ErrorHandler.handle(Exception('random'));
      expect(result, isA<UnknownError>());
    });

    test('passes through AppError unchanged', () {
      const original = AppError.network(message: 'Test');
      final result = ErrorHandler.handle(original);
      expect(identical(result, original), isTrue);
    });
  });
}
