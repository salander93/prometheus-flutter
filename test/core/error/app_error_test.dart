import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/core/error/app_error.dart';

void main() {
  group('AppError', () {
    test('ApiError holds status code, message, and field errors', () {
      const error = AppError.api(
        statusCode: 400,
        message: 'Validation failed',
        fieldErrors: {'email': ['Email already exists']},
      );

      expect(error, isA<ApiError>());
      expect((error as ApiError).statusCode, 400);
      expect(error.message, 'Validation failed');
      expect(error.fieldErrors['email'], ['Email already exists']);
    });

    test('NetworkError holds message', () {
      const error = AppError.network(message: 'No internet connection');
      expect(error, isA<NetworkError>());
      expect((error as NetworkError).message, 'No internet connection');
    });

    test('UnknownError holds message', () {
      const error = AppError.unknown(message: 'Something went wrong');
      expect(error, isA<UnknownError>());
      expect((error as UnknownError).message, 'Something went wrong');
    });

    test('userMessage returns human-readable text for all types', () {
      expect(
        const AppError.api(statusCode: 400, message: 'Bad request').userMessage,
        'Bad request',
      );
      expect(
        const AppError.network(message: 'Timeout').userMessage,
        'Timeout',
      );
      expect(
        const AppError.unknown(message: 'Oops').userMessage,
        'Oops',
      );
    });
  });
}
