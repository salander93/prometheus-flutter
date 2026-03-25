import 'package:dio/dio.dart';
import 'package:palestra/data/models/body_check_model.dart';

class BodyCheckRemoteDatasource {
  BodyCheckRemoteDatasource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<List<BodyCheckModel>> getBodyChecks() async {
    final r = await _dio.get<dynamic>('/api/workouts/body-checks/');
    return _parsePaginatedList(r.data, BodyCheckModel.fromJson);
  }

  Future<BodyCheckModel> getBodyCheckDetail(int id) async {
    final r = await _dio
        .get<Map<String, dynamic>>('/api/workouts/body-checks/$id/');
    return BodyCheckModel.fromJson(r.data!);
  }

  /// Returns only the created body check's ID.
  Future<int> createBodyCheck({
    required String title,
    required String date,
    String? notes,
    double? weightKg,
    double? bodyFatPercent,
  }) async {
    final r = await _dio.post<Map<String, dynamic>>(
      '/api/workouts/body-checks/',
      data: <String, dynamic>{
        'title': title,
        'date': date,
        if (notes != null) 'notes': notes,
        if (weightKg != null) 'weight_kg': weightKg,
        if (bodyFatPercent != null)
          'body_fat_percent': bodyFatPercent,
      },
    );
    return r.data!['id'] as int;
  }

  Future<void> uploadPhoto({
    required int bodyCheckId,
    required String filePath,
    required String position,
    List<int>? bytes,
  }) async {
    final MultipartFile file;
    if (bytes != null) {
      file = MultipartFile.fromBytes(
        bytes,
        filename: 'photo.jpg',
      );
    } else {
      file = await MultipartFile.fromFile(filePath);
    }
    final formData = FormData.fromMap(<String, dynamic>{
      'photo': file,
      'position': position,
    });
    await _dio.post<void>(
      '/api/workouts/body-checks/$bodyCheckId/upload-photo/',
      data: formData,
    );
  }

  Future<void> deleteBodyCheck(int id) async {
    await _dio.delete<void>('/api/workouts/body-checks/$id/');
  }

  Future<void> addComment({
    required int bodyCheckId,
    required String message,
  }) async {
    await _dio.post<void>(
      '/api/workouts/body-checks/$bodyCheckId/comments/',
      data: <String, dynamic>{'message': message},
    );
  }

  Future<void> shareWithTrainer({
    required int bodyCheckId,
    required int trainerId,
  }) async {
    await _dio.post<void>(
      '/api/workouts/body-checks/$bodyCheckId/share/',
      data: <String, dynamic>{'trainer': trainerId},
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  List<T> _parsePaginatedList<T>(
    dynamic data,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final List<dynamic> list;
    if (data is Map<String, dynamic> && data.containsKey('results')) {
      list = data['results'] as List<dynamic>;
    } else if (data is List) {
      list = data;
    } else {
      list = [];
    }
    return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }
}
