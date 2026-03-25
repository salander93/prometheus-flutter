import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:palestra/core/connectivity/connectivity_service.dart';
import 'package:palestra/core/notifications/notification_providers.dart';
import 'package:palestra/core/storage/cache_providers.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';
import 'package:palestra/presentation/shared/providers/notification_providers.dart';
import 'package:palestra/presentation/shared/widgets/flame_icon.dart';
import 'package:palestra/presentation/shared/widgets/offline_banner.dart';

class _NavDestinationSpec {
  const _NavDestinationSpec({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.path,
    this.useFlameIcon = false,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String path;
  final bool useFlameIcon;
}

const _clientDestinations = [
  _NavDestinationSpec(
    label: 'Home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    path: '/dashboard',
  ),
  _NavDestinationSpec(
    label: 'Trainer',
    icon: Icons.people_outline,
    selectedIcon: Icons.people,
    path: '/trainers',
  ),
  _NavDestinationSpec(
    label: 'Schede',
    icon: Icons.assignment_outlined,
    selectedIcon: Icons.assignment,
    path: '/plans',
  ),
  _NavDestinationSpec(
    label: 'Workout',
    icon: Icons.whatshot_outlined,
    selectedIcon: Icons.whatshot,
    path: '/activity',
    useFlameIcon: true,
  ),
  _NavDestinationSpec(
    label: 'Check',
    icon: Icons.photo_library_outlined,
    selectedIcon: Icons.photo_library,
    path: '/body-checks',
  ),
  _NavDestinationSpec(
    label: 'Profilo',
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    path: '/profile',
  ),
];

const _trainerDestinations = [
  _NavDestinationSpec(
    label: 'Home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    path: '/dashboard',
  ),
  _NavDestinationSpec(
    label: 'Esercizi',
    icon: Icons.fitness_center_outlined,
    selectedIcon: Icons.fitness_center,
    path: '/exercises',
  ),
  _NavDestinationSpec(
    label: 'Richieste',
    icon: Icons.mail_outline,
    selectedIcon: Icons.mail,
    path: '/requests',
  ),
  _NavDestinationSpec(
    label: 'Schede',
    icon: Icons.assignment_outlined,
    selectedIcon: Icons.assignment,
    path: '/plans',
  ),
  _NavDestinationSpec(
    label: 'Check',
    icon: Icons.photo_library_outlined,
    selectedIcon: Icons.photo_library,
    path: '/body-checks',
  ),
  _NavDestinationSpec(
    label: 'Profilo',
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    path: '/profile',
  ),
];

class AppNavigationShell extends ConsumerStatefulWidget {
  const AppNavigationShell({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AppNavigationShell> createState() =>
      _AppNavigationShellState();
}

class _AppNavigationShellState extends ConsumerState<AppNavigationShell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Kick off a sync on mount in case the user was offline during a
      // previous session and queued sets are waiting.
      if (ref.read(isOnlineProvider)) {
        ref.read(syncServiceProvider).syncPendingSets();
      }

      // Initialize push notifications now that the user is authenticated.
      ref.read(pushNotificationServiceProvider).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Trigger a background sync whenever connectivity is restored.
    ref.listen<AsyncValue<bool>>(connectivityProvider, (prev, next) {
      final isOnline = next.valueOrNull ?? false;
      if (isOnline) {
        ref.read(syncServiceProvider).syncPendingSets();
      }
    });

    final userAsync = ref.watch(currentUserProvider);
    final unreadAsync = ref.watch(unreadCountProvider);

    final isTrainer = userAsync.valueOrNull?.role == 'TRAINER';
    final destinations =
        isTrainer ? _trainerDestinations : _clientDestinations;

    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _indexForLocation(location, destinations);

    final unreadCount = unreadAsync.valueOrNull ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.primaryLight, AppColors.secondary],
          ).createShader(bounds),
          child: const Text(
            'Prometheus',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => context.go('/notifications'),
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.danger,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        unreadCount > 99 ? '99+' : '$unreadCount',
                        style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontSize: 9,
                                ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: OfflineBanner(child: widget.child),
      bottomNavigationBar: _FloatingPillNav(
        destinations: destinations,
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          context.go(destinations[index].path);
        },
      ),
    );
  }

  int _indexForLocation(
    String location,
    List<_NavDestinationSpec> destinations,
  ) {
    for (var i = 0; i < destinations.length; i++) {
      if (location.startsWith(destinations[i].path)) return i;
    }
    return 0;
  }
}

// ---------------------------------------------------------------------------
// Floating pill navigation bar
// ---------------------------------------------------------------------------

class _FloatingPillNav extends StatelessWidget {
  const _FloatingPillNav({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final List<_NavDestinationSpec> destinations;
  final int selectedIndex;
  final void Function(int index) onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        bottomPadding + 16,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xD914141A),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66000000),
                  blurRadius: 32,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i = 0; i < destinations.length; i++)
                  Expanded(
                    child: _PillNavItem(
                    icon: destinations[i].icon,
                    selectedIcon: destinations[i].selectedIcon,
                    label: destinations[i].label,
                    isSelected: i == selectedIndex,
                    useFlameIcon: destinations[i].useFlameIcon,
                    onTap: () => onDestinationSelected(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PillNavItem extends StatelessWidget {
  const _PillNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.useFlameIcon = false,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool useFlameIcon;

  @override
  Widget build(BuildContext context) {
    final iconColor = isSelected
        ? Colors.white
        : AppColors.textSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 48,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: 44,
            height: 40,
            decoration: isSelected
                ? BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x66FF6B35),
                        blurRadius: 15,
                        offset: Offset(0, 4),
                      ),
                    ],
                  )
                : null,
            child: useFlameIcon
                ? Center(
                    child: FlameIcon(
                      size: 24,
                      color: iconColor,
                    ),
                  )
                : Icon(
                    isSelected ? selectedIcon : icon,
                    size: 24,
                    color: iconColor,
                  ),
          ),
        ),
      ),
    );
  }
}
