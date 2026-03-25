import 'package:dio/dio.dart';
import 'package:palestra/data/models/notification_model.dart';

class NotificationRemoteDatasource {
  NotificationRemoteDatasource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<List<NotificationModel>> getNotifications() async {
    final r = await _dio.get<dynamic>('/api/users/notifications/');
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
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<int> getUnreadCount() async {
    final r = await _dio
        .get<Map<String, dynamic>>('/api/users/notifications/unread_count/');
    return (r.data?['count'] as int?) ?? 0;
  }

  Future<void> markAsRead(int notificationId) async {
    await _dio.post<dynamic>(
      '/api/users/notifications/$notificationId/mark_read/',
    );
  }

  Future<void> markAllAsRead() async {
    await _dio.post<dynamic>('/api/users/notifications/mark_all_read/');
  }
}
