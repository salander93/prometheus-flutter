import 'package:palestra/data/datasources/remote/notification_remote_datasource.dart';
import 'package:palestra/data/models/notification_model.dart';
import 'package:palestra/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({
    required NotificationRemoteDatasource remoteDatasource,
  }) : _remote = remoteDatasource;

  final NotificationRemoteDatasource _remote;

  @override
  Future<List<NotificationModel>> getNotifications() =>
      _remote.getNotifications();

  @override
  Future<int> getUnreadCount() => _remote.getUnreadCount();

  @override
  Future<void> markAsRead(int notificationId) =>
      _remote.markAsRead(notificationId);

  @override
  Future<void> markAllAsRead() => _remote.markAllAsRead();
}
