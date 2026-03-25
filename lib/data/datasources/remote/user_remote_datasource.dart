import 'package:dio/dio.dart';
import 'package:palestra/data/models/body_metric_model.dart';
import 'package:palestra/data/models/relation_models.dart';
import 'package:palestra/data/models/user_model.dart';

class UserRemoteDatasource {
  UserRemoteDatasource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<UserModel> getProfile() async {
    final r = await _dio.get<Map<String, dynamic>>('/api/users/me/');
    return UserModel.fromJson(r.data!);
  }

  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    final r = await _dio.patch<Map<String, dynamic>>(
      '/api/users/update_profile/',
      data: data,
    );
    return UserModel.fromJson(r.data!);
  }

  Future<void> uploadPhoto(String filePath) async {
    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(filePath),
    });
    await _dio.post<dynamic>('/api/users/upload-photo/', data: formData);
  }

  Future<void> deletePhoto() async {
    await _dio.delete<dynamic>('/api/users/delete-photo/');
  }

  Future<List<TrainerClient>> getMyClients() async {
    final r = await _dio.get<List<dynamic>>('/api/users/my_clients/');
    return (r.data ?? [])
        .map((e) => TrainerClient.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<TrainerClient>> getMyTrainers() async {
    final r = await _dio.get<List<dynamic>>('/api/users/my_trainers/');
    return (r.data ?? [])
        .map((e) => TrainerClient.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<BodyMetric?> getLatestMetrics() async {
    final r =
        await _dio.get<Map<String, dynamic>>('/api/users/body-metrics/latest/');
    if (r.data == null || r.data!.isEmpty) return null;
    return BodyMetric.fromJson(r.data!);
  }

  Future<List<BodyMetric>> getMetricsHistory({String? timeRange}) async {
    final params = <String, dynamic>{};
    if (timeRange != null) params['range'] = timeRange;
    final r = await _dio.get<List<dynamic>>(
      '/api/users/body-metrics/history/',
      queryParameters: params,
    );
    return (r.data ?? [])
        .map((e) => BodyMetric.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<BodyMetric> addMetric(Map<String, dynamic> data) async {
    final r = await _dio.post<Map<String, dynamic>>(
      '/api/users/body-metrics/',
      data: data,
    );
    return BodyMetric.fromJson(r.data!);
  }
}
