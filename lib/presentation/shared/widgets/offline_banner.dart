import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palestra/core/connectivity/connectivity_service.dart';
import 'package:palestra/core/theme/app_colors.dart';

/// A slim banner displayed at the top of the screen when the device is offline.
///
/// Wrap the body of a scaffold with this widget to show offline state feedback.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);

    return Column(
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: isOnline
              ? const SizedBox.shrink()
              : const _OfflineBannerContent(),
        ),
        Expanded(child: child),
      ],
    );
  }
}

class _OfflineBannerContent extends StatelessWidget {
  const _OfflineBannerContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.accent.withValues(alpha: 0.15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 14,
            color: AppColors.accent,
          ),
          const SizedBox(width: 8),
          Text(
            'Sei offline — dati dalla cache',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
