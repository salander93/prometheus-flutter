import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';

@freezed
sealed class AppError with _$AppError {
  const AppError._();

  const factory AppError.api({
    required int statusCode,
    required String message,
    @Default({}) Map<String, List<String>> fieldErrors,
  }) = ApiError;

  const factory AppError.network({
    required String message,
  }) = NetworkError;

  const factory AppError.unknown({
    required String message,
    StackTrace? stackTrace,
  }) = UnknownError;

  String get userMessage => switch (this) {
        ApiError(:final message) => message,
        NetworkError(:final message) => message,
        UnknownError(:final message) => message,
      };
}
