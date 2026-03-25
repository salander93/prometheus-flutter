import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palestra/core/notifications/push_notification_service.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';

/// Provider for the [PushNotificationService] singleton.
///
/// The service is a stub until Firebase is configured.
/// See [PushNotificationService.enabled] and the class-level docs
/// for activation instructions.
final pushNotificationServiceProvider =
    Provider<PushNotificationService>((ref) {
  final apiClient = ref.watch(apiClientProvider);

  return PushNotificationService(
    registerToken: (token, platform) async {
      await apiClient.dio.post<dynamic>(
        '/api/users/push/fcm/',
        data: {
          'device_token': token,
          'platform': platform,
        },
      );
    },
  );
});
