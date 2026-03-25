import 'package:dio/dio.dart';
import 'package:palestra/core/error/app_error.dart';

class ErrorHandler {
  const ErrorHandler._();

  static AppError handle(Object error, [StackTrace? stackTrace]) {
    if (error is DioException) {
      return _handleDioError(error);
    }
    if (error is AppError) {
      return error;
    }
    return AppError.unknown(
      message: error.toString(),
      stackTrace: stackTrace,
    );
  }

  static AppError _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppError.network(message: 'Connessione scaduta. Riprova.');
      case DioExceptionType.connectionError:
        return const AppError.network(message: 'Nessuna connessione internet.');
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);
      case DioExceptionType.cancel:
        return const AppError.network(message: 'Richiesta annullata.');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return AppError.unknown(
          message: error.message ?? 'Errore sconosciuto.',
        );
    }
  }

  static AppError _handleBadResponse(Response<dynamic>? response) {
    if (response == null) {
      return const AppError.unknown(message: 'Nessuna risposta dal server.');
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    if (data is Map<String, dynamic>) {
      final message = data['detail'] as String? ??
          data['error'] as String? ??
          data['message'] as String? ??
          'Errore del server.';

      final fieldErrors = <String, List<String>>{};
      for (final entry in data.entries) {
        if (entry.key == 'detail' ||
            entry.key == 'error' ||
            entry.key == 'message') {
          continue;
        }
        if (entry.value is List) {
          fieldErrors[entry.key] =
              (entry.value as List).map((e) => e.toString()).toList();
        }
      }

      return AppError.api(
        statusCode: statusCode,
        message: message,
        fieldErrors: fieldErrors,
      );
    }

    return AppError.api(
      statusCode: statusCode,
      message: 'Errore del server ($statusCode).',
    );
  }
}
