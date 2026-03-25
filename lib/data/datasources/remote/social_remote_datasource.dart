import 'package:dio/dio.dart';
import 'package:palestra/data/models/connection_models.dart';

class SocialRemoteDatasource {
  SocialRemoteDatasource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<List<TrainerSearchResult>> searchTrainers({
    String? query,
    String? code,
  }) async {
    final params = <String, dynamic>{};
    if (query != null && query.isNotEmpty) params['q'] = query;
    if (code != null && code.isNotEmpty) params['code'] = code;

    final r = await _dio.get<dynamic>(
      '/api/users/trainers/search/',
      queryParameters: params,
    );
    final data = r.data;
    final List<dynamic> list;
    if (data is Map<String, dynamic> && data.containsKey('results')) {
      list = data['results'] as List<dynamic>;
    } else if (data is List) {
      list = data;
    } else {
      list = [];
    }
    return list
        .map(
          (e) => TrainerSearchResult.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<ConnectionRequest>> getConnectionRequests() async {
    final r = await _dio.get<dynamic>('/api/users/connection-requests/');
    final data = r.data;
    final List<dynamic> list;
    if (data is Map<String, dynamic> && data.containsKey('results')) {
      list = data['results'] as List<dynamic>;
    } else if (data is List) {
      list = data;
    } else {
      list = [];
    }
    return list
        .map(
          (e) => ConnectionRequest.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> sendConnectionRequest({
    required int trainerId,
    String? message,
  }) async {
    final body = <String, dynamic>{'trainer': trainerId};
    if (message != null && message.isNotEmpty) body['message'] = message;
    await _dio.post<dynamic>('/api/users/connection-requests/', data: body);
  }

  Future<void> updateConnectionRequestStatus(
    int requestId,
    String status,
  ) async {
    await _dio.patch<dynamic>(
      '/api/users/connection-requests/$requestId/',
      data: {'status': status},
    );
  }

  Future<List<PlanRequest>> getPlanRequests() async {
    final r = await _dio.get<dynamic>('/api/users/plan-requests/');
    final data = r.data;
    final List<dynamic> list;
    if (data is Map<String, dynamic> && data.containsKey('results')) {
      list = data['results'] as List<dynamic>;
    } else if (data is List) {
      list = data;
    } else {
      list = [];
    }
    return list
        .map((e) => PlanRequest.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> createPlanRequest({
    required int trainerId,
    String? message,
  }) async {
    final body = <String, dynamic>{'trainer': trainerId};
    if (message != null && message.isNotEmpty) body['message'] = message;
    await _dio.post<dynamic>('/api/users/plan-requests/', data: body);
  }

  Future<void> updatePlanRequestStatus(int requestId, String status) async {
    await _dio.patch<dynamic>(
      '/api/users/plan-requests/$requestId/',
      data: {'status': status},
    );
  }
}
