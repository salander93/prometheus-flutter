import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:palestra/core/notifications/push_notification_service.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/notification_model.dart';
import 'package:palestra/presentation/shared/providers/notification_providers.dart';
import 'package:palestra/presentation/shared/widgets/shimmer_loading.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends ConsumerState<NotificationsScreen> {
  bool _markingAll = false;

  Future<void> _markAllAsRead() async {
    setState(() => _markingAll = true);
    try {
      final repo = ref.read(notificationRepositoryProvider);
      await repo.markAllAsRead();
      ref
        ..invalidate(notificationsProvider)
        ..invalidate(unreadCountProvider);
    } finally {
      if (mounted) setState(() => _markingAll = false);
    }
  }

  Future<void> _markAsRead(
    NotificationModel notification,
  ) async {
    if (notification.isRead) return;
    final repo = ref.read(notificationRepositoryProvider);
    await repo.markAsRead(notification.id);
    ref
      ..invalidate(notificationsProvider)
      ..invalidate(unreadCountProvider);
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return notificationsAsync.when(
      data: (notifications) {
        Future<void> onRefresh() async {
          ref
            ..invalidate(notificationsProvider)
            ..invalidate(unreadCountProvider);
        }

        final hasUnread = notifications.any((n) => !n.isRead);

        if (notifications.isEmpty) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: const Column(
              children: [
                _PushNotificationBanner(),
                Expanded(child: _EmptyState()),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.builder(
            itemCount: notifications.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _NotificationsHeader(
                  hasUnread: hasUnread,
                  markingAll: _markingAll,
                  onMarkAll: _markAllAsRead,
                );
              }
              if (index == 1) {
                return const _PushNotificationBanner();
              }
              final notification = notifications[index - 2];
              return _NotificationCard(
                notification: notification,
                onTap: () => _markAsRead(notification),
              );
            },
          ),
        );
      },
      loading: () => const ShimmerLoading(),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 8),
            Text('Errore: $error'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => ref.invalidate(notificationsProvider),
              child: const Text('Riprova'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Notifications header with "mark all as read" action
// ---------------------------------------------------------------------------

class _NotificationsHeader extends StatelessWidget {
  const _NotificationsHeader({
    required this.hasUnread,
    required this.markingAll,
    required this.onMarkAll,
  });

  final bool hasUnread;
  final bool markingAll;
  final VoidCallback onMarkAll;

  @override
  Widget build(BuildContext context) {
    if (!hasUnread) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (markingAll)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: onMarkAll,
              child: const Text('Segna tutte come lette'),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Push notification banner
// ---------------------------------------------------------------------------

/// Shown at the top of the notifications screen when push notifications
/// have not yet been configured (i.e. [PushNotificationService.enabled]
/// is `false`).
class _PushNotificationBanner extends StatelessWidget {
  const _PushNotificationBanner();

  @override
  Widget build(BuildContext context) {
    if (PushNotificationService.enabled) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              Icons.notifications_active_outlined,
              color: colorScheme.secondary,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attiva le notifiche push',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Ricevi notifiche anche quando l'app è chiusa",
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSecondaryContainer
                          .withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: 'Configurazione Firebase necessaria',
              child: FilledButton.tonal(
                onPressed: null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Attiva',
                  style: textTheme.labelMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Notification card
// ---------------------------------------------------------------------------

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  final NotificationModel notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isUnread = !notification.isRead;

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isUnread
              ? colorScheme.primaryContainer.withValues(alpha: 0.15)
              : null,
          border: Border(
            left: isUnread
                ? BorderSide(
                    color: colorScheme.primary,
                    width: 3,
                  )
                : BorderSide.none,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NotificationAvatar(notification: notification),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: isUnread
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _timeAgo(notification.createdAt),
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.message,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Notification avatar
// ---------------------------------------------------------------------------

class _NotificationAvatar extends StatelessWidget {
  const _NotificationAvatar({required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (notification.relatedUserPhoto != null) {
      return CircleAvatar(
        radius: 22,
        backgroundImage: CachedNetworkImageProvider(
          notification.relatedUserPhoto!,
        ),
      );
    }

    final (icon, iconColor, bgColor) = _iconData(
      notification.notificationType,
      colorScheme,
    );

    return CircleAvatar(
      radius: 22,
      backgroundColor: bgColor,
      child: Icon(icon, color: iconColor, size: 20),
    );
  }

  (IconData, Color, Color) _iconData(
    String type,
    ColorScheme cs,
  ) {
    switch (type) {
      case 'CONNECTION_ACCEPTED':
        return (
          Icons.check_circle,
          AppColors.success,
          AppColors.success.withValues(alpha: 0.15),
        );
      case 'CONNECTION_REJECTED':
        return (
          Icons.cancel,
          AppColors.danger,
          AppColors.danger.withValues(alpha: 0.15),
        );
      case 'CONNECTION_REQUEST':
        return (
          Icons.person_add,
          AppColors.primary,
          AppColors.primary.withValues(alpha: 0.15),
        );
      case 'PLAN_REQUEST':
        return (
          Icons.assignment,
          AppColors.primary,
          AppColors.primary.withValues(alpha: 0.15),
        );
      case 'PLAN_COMPLETED':
        return (
          Icons.check_circle,
          AppColors.success,
          AppColors.success.withValues(alpha: 0.15),
        );
      default:
        return (
          Icons.notifications,
          AppColors.textSecondary,
          AppColors.backgroundCardHover,
        );
    }
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 72,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'Nessuna notifica',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Le tue notifiche appariranno qui',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Time-ago helper
// ---------------------------------------------------------------------------

String _timeAgo(String isoDate) {
  try {
    final dt = DateTime.parse(isoDate).toLocal();
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'Adesso';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min fa';
    if (diff.inHours < 24) return '${diff.inHours} ore fa';
    if (diff.inDays < 7) return '${diff.inDays} giorni fa';
    return DateFormat('dd MMM yyyy', 'it_IT').format(dt);
  } catch (_) {
    return isoDate;
  }
}
