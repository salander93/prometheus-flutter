import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';
import 'package:palestra/presentation/auth/screens/forgot_password_screen.dart';
import 'package:palestra/presentation/auth/screens/google_onboarding_screen.dart';
import 'package:palestra/presentation/auth/screens/login_screen.dart';
import 'package:palestra/presentation/auth/screens/register_screen.dart';
import 'package:palestra/presentation/auth/screens/reset_password_screen.dart';
import 'package:palestra/presentation/auth/screens/verify_email_screen.dart';
import 'package:palestra/presentation/body_checks/screens/body_check_compare_screen.dart';
import 'package:palestra/presentation/body_checks/screens/body_check_detail_screen.dart';
import 'package:palestra/presentation/body_checks/screens/body_check_wizard_screen.dart';
import 'package:palestra/presentation/body_checks/screens/body_checks_gallery_screen.dart';
import 'package:palestra/presentation/body_checks/screens/photo_editor_screen.dart';
import 'package:palestra/presentation/body_metrics/screens/body_metrics_screen.dart';
import 'package:palestra/presentation/dashboard/screens/dashboard_screen.dart';
import 'package:palestra/presentation/exercises/screens/exercise_detail_screen.dart';
import 'package:palestra/presentation/exercises/screens/exercise_list_screen.dart';
import 'package:palestra/presentation/notifications/screens/notifications_screen.dart';
import 'package:palestra/presentation/profile/screens/profile_edit_screen.dart';
import 'package:palestra/presentation/profile/screens/profile_screen.dart';
import 'package:palestra/presentation/profile/screens/settings_screen.dart';
import 'package:palestra/presentation/requests/screens/requests_screen.dart';
import 'package:palestra/presentation/shared/screens/splash_screen.dart';
import 'package:palestra/presentation/shared/widgets/app_navigation_shell.dart';
import 'package:palestra/presentation/trainers/screens/trainer_search_screen.dart';
import 'package:palestra/presentation/workouts/screens/activity_screen.dart';
import 'package:palestra/presentation/workouts/screens/live_workout_screen.dart';
import 'package:palestra/presentation/workouts/screens/plan_detail_screen.dart';
import 'package:palestra/presentation/workouts/screens/plans_list_screen.dart';
import 'package:palestra/presentation/workouts/screens/session_selector_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      // While auth is still loading, stay on splash
      if (authState.isLoading) {
        return state.matchedLocation == '/splash' ? null : '/splash';
      }

      final auth = authState.valueOrNull;
      if (auth == null) return null;

      final loc = state.matchedLocation;
      final isAuthRoute = loc == '/login' ||
          loc == '/register' ||
          loc.startsWith('/forgot-password') ||
          loc.startsWith('/reset-password') ||
          loc.startsWith('/verify-email');
      final isSplash = loc == '/splash';

      if (auth == AuthState.unauthenticated && !isAuthRoute) {
        return '/login';
      }
      if (auth == AuthState.authenticated && (isAuthRoute || isSplash)) {
        return '/dashboard';
      }
      if (isSplash && auth == AuthState.unauthenticated) {
        return '/login';
      }
      return null;
    },
    routes: [
      // ── Splash ──────────────────────────────────────────────────────────
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) =>
            _buildPage(const SplashScreen(), state),
      ),

      // ── Auth routes (no shell) ───────────────────────────────────────────
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) =>
            _buildPage(const LoginScreen(), state),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) =>
            _buildPage(const RegisterScreen(), state),
      ),
      GoRoute(
        path: '/forgot-password',
        pageBuilder: (context, state) =>
            _buildPage(const ForgotPasswordScreen(), state),
      ),
      GoRoute(
        path: '/reset-password/:token',
        pageBuilder: (context, state) => _buildPage(
          ResetPasswordScreen(
            token: state.pathParameters['token']!,
          ),
          state,
        ),
      ),
      GoRoute(
        path: '/verify-email/:token',
        pageBuilder: (context, state) => _buildPage(
          VerifyEmailScreen(
            token: state.pathParameters['token']!,
          ),
          state,
        ),
      ),

      // ── Post-Google Sign-In onboarding (no shell) ───────────────────────
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) =>
            _buildPage(const GoogleOnboardingScreen(), state),
      ),

      // ── Fullscreen body check wizard (no shell) ─────────────────────────
      GoRoute(
        path: '/body-checks/new',
        pageBuilder: (context, state) => _buildFullscreenPage(
          const BodyCheckWizardScreen(),
          state,
        ),
      ),

      // ── Fullscreen photo editor (no shell) ──────────────────────────────
      GoRoute(
        path: '/body-checks/edit-photo',
        pageBuilder: (context, state) {
          final args = state.extra! as Map<String, dynamic>;
          return _buildFullscreenPage(
            PhotoEditorScreen(
              imageBytes: args['imageBytes'] as Uint8List,
              position: args['position'] as String,
              positionLabel: args['positionLabel'] as String,
              referenceImageBytes:
                  args['referenceImageBytes'] as Uint8List?,
            ),
            state,
          );
        },
      ),

      // ── Authenticated shell routes ───────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) =>
            AppNavigationShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) =>
                _buildPage(const DashboardScreen(), state),
          ),
          // Workout inside shell so bottom nav stays visible
          GoRoute(
            path: '/workout/:executionId',
            pageBuilder: (context, state) => _buildPage(
              LiveWorkoutScreen(
                executionId: int.parse(
                  state.pathParameters['executionId']!,
                ),
              ),
              state,
            ),
          ),
          GoRoute(
            path: '/plans',
            pageBuilder: (context, state) =>
                _buildPage(const PlansListScreen(), state),
            routes: [
              GoRoute(
                path: ':id',
                pageBuilder: (context, state) => _buildPage(
                  PlanDetailScreen(
                    planId: int.parse(
                      state.pathParameters['id']!,
                    ),
                  ),
                  state,
                ),
                routes: [
                  GoRoute(
                    path: 'start',
                    pageBuilder: (context, state) => _buildPage(
                      SessionSelectorScreen(
                        planId: int.parse(
                          state.pathParameters['id']!,
                        ),
                      ),
                      state,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/exercises',
            pageBuilder: (context, state) =>
                _buildPage(const ExerciseListScreen(), state),
            routes: [
              GoRoute(
                path: ':id',
                pageBuilder: (context, state) => _buildPage(
                  ExerciseDetailScreen(
                    exerciseId: int.parse(
                      state.pathParameters['id']!,
                    ),
                  ),
                  state,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/activity',
            pageBuilder: (context, state) =>
                _buildPage(const ActivityScreen(), state),
          ),
          GoRoute(
            path: '/body-checks',
            pageBuilder: (context, state) =>
                _buildPage(const BodyChecksGalleryScreen(), state),
            routes: [
              GoRoute(
                path: 'compare',
                pageBuilder: (context, state) =>
                    _buildPage(const BodyCheckCompareScreen(), state),
              ),
              GoRoute(
                path: ':id',
                pageBuilder: (context, state) => _buildPage(
                  BodyCheckDetailScreen(
                    bodyCheckId: int.parse(
                      state.pathParameters['id']!,
                    ),
                  ),
                  state,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/body-metrics',
            pageBuilder: (context, state) =>
                _buildPage(const BodyMetricsScreen(), state),
          ),
          GoRoute(
            path: '/requests',
            pageBuilder: (context, state) =>
                _buildPage(const RequestsScreen(), state),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) =>
                _buildPage(const ProfileScreen(), state),
            routes: [
              GoRoute(
                path: 'edit',
                pageBuilder: (context, state) =>
                    _buildPage(const ProfileEditScreen(), state),
              ),
              GoRoute(
                path: 'settings',
                pageBuilder: (context, state) =>
                    _buildPage(const SettingsScreen(), state),
              ),
            ],
          ),
          GoRoute(
            path: '/notifications',
            pageBuilder: (context, state) =>
                _buildPage(const NotificationsScreen(), state),
          ),
          GoRoute(
            path: '/trainers',
            pageBuilder: (context, state) =>
                _buildPage(const TrainerSearchScreen(), state),
          ),
        ],
      ),
    ],
  );
});

/// Slide-up transition used for fullscreen overlay routes (e.g. wizard).
CustomTransitionPage<void> _buildFullscreenPage(
  Widget child,
  GoRouterState state,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    fullscreenDialog: true,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(
          CurveTween(curve: Curves.easeOutCubic).animate(animation),
        ),
        child: child,
      );
    },
  );
}

/// Subtle fade + slight horizontal slide transition applied to all routes.
CustomTransitionPage<void> _buildPage(Widget child, GoRouterState state) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.03, 0),
            end: Offset.zero,
          ).animate(
            CurveTween(curve: Curves.easeOut).animate(animation),
          ),
          child: child,
        ),
      );
    },
  );
}

/// Wraps a [Widget] in a [Scaffold] suitable for use as a shell child.
///
/// Screens rendered inside [AppNavigationShell] should not provide their own
/// [Scaffold] (or at least not their own [AppBar]) so that the shell's app bar
/// and bottom navigation bar are the single source of truth. This helper is
/// intentionally unused at the moment – individual screens will adopt it
/// incrementally as they are built out in later tasks.
@visibleForTesting
Widget shellBody(Widget child) => child;
