import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palestra/core/storage/cache_providers.dart';
import 'package:palestra/data/datasources/remote/notification_remote_datasource.dart';
import 'package:palestra/data/models/notification_model.dart';
import 'package:palestra/data/repositories/notification_repository_impl.dart';
import 'package:palestra/domain/repositories/notification_repository.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';

final notificationRemoteDatasourceProvider =
    Provider<NotificationRemoteDatasource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NotificationRemoteDatasource(dio: apiClient.dio);
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(
    remoteDatasource: ref.watch(notificationRemoteDatasourceProvider),
  );
});

final notificationsProvider =
    FutureProvider<List<NotificationModel>>((ref) async {
  final cachedApi = ref.watch(cachedApiProvider);
  final repo = ref.watch(notificationRepositoryProvider);

  return cachedApi.fetch<List<NotificationModel>>(
    cacheKey: 'notifications',
    apiCall: repo.getNotifications,
    fromCache: (json) => (json as List<dynamic>)
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    toCache: (data) => data.map((e) => e.toJson()).toList(),
    ttl: const Duration(minutes: 1),
  );
});

final unreadCountProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.getUnreadCount();
});
