import 'package:palestra/data/models/notification_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> getNotifications();
  Future<int> getUnreadCount();
  Future<void> markAsRead(int notificationId);
  Future<void> markAllAsRead();
}
