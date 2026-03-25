import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Push notification service backed by Firebase Cloud Messaging.
class PushNotificationService {
  PushNotificationService({required this.registerToken});

  final Future<void> Function(String token, String platform) registerToken;

  static const enabled = true;
  bool _initialized = false;

  /// Initialize push notifications.
  ///
  /// Requests permission, registers the FCM token with the backend, and sets
  /// up listeners for foreground messages and notification taps.
  /// No-op if [enabled] is `false` or already initialized.
  Future<void> initialize() async {
    if (!enabled || _initialized) return;

    try {
      final messaging = FirebaseMessaging.instance;

      // Request permission (Android 13+ and iOS).
      final settings = await messaging.requestPermission();
      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        log('PushNotificationService: permission denied');
        return;
      }

      // Retrieve and register the FCM token.
      final token = await messaging.getToken();
      if (token != null) {
        final platform = _platform();
        await registerToken(token, platform);
      }

      // Re-register on token refresh.
      messaging.onTokenRefresh.listen((newToken) {
        registerToken(newToken, _platform());
      });

      // Handle messages received while the app is in the foreground.
      FirebaseMessaging.onMessage.listen((message) {
        log(
          'PushNotificationService: foreground — '
          '${message.notification?.title}',
        );
        // In-app display can be added here via a Riverpod provider.
      });

      // Handle notification tap when app was in background / terminated.
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        log('PushNotificationService: opened from notification — '
            '${message.data}');
        // action_url navigation is handled at the router level.
      });

      _initialized = true;
      log('PushNotificationService: initialized');
    } catch (e, st) {
      log(
        'PushNotificationService: initialization failed',
        error: e,
        stackTrace: st,
      );
    }
  }

  /// Returns the platform string.
  ///
  /// Avoids `dart:io` on web by checking [kIsWeb] first.
  static String _platform() {
    if (kIsWeb) return 'web';
    // defaultTargetPlatform is available on all platforms via flutter/foundation.
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return 'other';
    }
  }
}
