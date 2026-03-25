import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:palestra/core/error/app_error.dart';
import 'package:palestra/core/error/error_handler.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';
import 'package:palestra/presentation/shared/providers/user_providers.dart';

/// Post-Google Sign-In onboarding: lets the user pick a role and
/// choose a username before landing on the dashboard.
class GoogleOnboardingScreen extends ConsumerStatefulWidget {
  const GoogleOnboardingScreen({super.key});

  @override
  ConsumerState<GoogleOnboardingScreen> createState() =>
      _GoogleOnboardingScreenState();
}

class _GoogleOnboardingScreenState
    extends ConsumerState<GoogleOnboardingScreen> {
  final _pageController = PageController();
  final _usernameFormKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  int _currentStep = 0;
  String? _role;
  bool _isLoading = false;
  String? _errorMessage;

  static const _totalSteps = 2;

  @override
  void initState() {
    super.initState();
    // Pre-fill username with the email prefix of the current user.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider).valueOrNull;
      if (user != null) {
        _usernameController.text = user.email.split('@').first;
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    setState(() {
      _currentStep = step;
      _errorMessage = null;
    });
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _onNext() {
    if (_role == null) {
      setState(
        () => _errorMessage = 'Scegli il tuo ruolo per continuare',
      );
      return;
    }
    _goToStep(1);
  }

  Future<void> _onComplete() async {
    if (!(_usernameFormKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.updateProfile({
        'role': _role,
        'username': _usernameController.text.trim(),
      });
      // Invalidate cached user so downstream providers refresh.
      ref.invalidate(currentUserProvider);

      if (mounted) context.go('/dashboard');
    } on AppError catch (e) {
      setState(() => _errorMessage = e.userMessage);
    } catch (e, st) {
      final appError = ErrorHandler.handle(e, st);
      setState(() => _errorMessage = appError.userMessage);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _OnboardingHeader(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              onBack: _currentStep > 0
                  ? () => _goToStep(_currentStep - 1)
                  : null,
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: _ErrorBanner(message: _errorMessage!),
              ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _StepRole(
                    selectedRole: _role,
                    onRoleSelected: (role) =>
                        setState(() => _role = role),
                  ),
                  _StepUsername(
                    formKey: _usernameFormKey,
                    controller: _usernameController,
                  ),
                ],
              ),
            ),
            _OnboardingFooter(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              isLoading: _isLoading,
              canGoNext: _role != null,
              onNext: _onNext,
              onComplete: _onComplete,
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// Header with progress dots + optional back button
// -------------------------------------------------------------------

class _OnboardingHeader extends StatelessWidget {
  const _OnboardingHeader({
    required this.currentStep,
    required this.totalSteps,
    this.onBack,
  });

  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack,
              tooltip: 'Indietro',
            )
          else
            const SizedBox(width: 48),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalSteps, (i) {
                final isActive = i == currentStep;
                final isCompleted = i < currentStep;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 12 : 8,
                  height: isActive ? 12 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive || isCompleted
                        ? AppColors.primary
                        : AppColors.textMuted.withAlpha(77),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------
// Footer with Avanti / Completa buttons
// -------------------------------------------------------------------

class _OnboardingFooter extends StatelessWidget {
  const _OnboardingFooter({
    required this.currentStep,
    required this.totalSteps,
    required this.isLoading,
    required this.canGoNext,
    required this.onNext,
    required this.onComplete,
  });

  final int currentStep;
  final int totalSteps;
  final bool isLoading;
  final bool canGoNext;
  final VoidCallback onNext;
  final VoidCallback onComplete;

  bool get _isLast => currentStep == totalSteps - 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: FilledButton(
        onPressed: isLoading
            ? null
            : _isLast
                ? onComplete
                : (canGoNext ? onNext : null),
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
        ),
        child: isLoading
            ? const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(_isLast ? 'Completa' : 'Avanti'),
      ),
    );
  }
}

// -------------------------------------------------------------------
// Step 1: Role selection
// -------------------------------------------------------------------

class _StepRole extends StatelessWidget {
  const _StepRole({
    required this.selectedRole,
    required this.onRoleSelected,
  });

  final String? selectedRole;
  final ValueChanged<String> onRoleSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Image.asset(
            'assets/images/prometheus_logo.png',
            height: 100,
          ),
          const SizedBox(height: 16),
          Text(
            'Benvenuto in Prometheus!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Chi sei?',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: _RoleCard(
                  emoji: '\u{1F3C3}',
                  title: 'Atleta',
                  subtitle: 'Voglio allenarmi\ncon un trainer',
                  isSelected: selectedRole == 'CLIENT',
                  onTap: () => onRoleSelected('CLIENT'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _RoleCard(
                  emoji: '\u{1F4AA}',
                  title: 'Trainer',
                  subtitle: 'Voglio gestire\ni miei clienti',
                  isSelected: selectedRole == 'TRAINER',
                  onTap: () => onRoleSelected('TRAINER'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? AppColors.primary.withAlpha(26)
              : AppColors.backgroundCard,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(51),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (isSelected) ...[
              const SizedBox(height: 8),
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 24,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// Step 2: Username
// -------------------------------------------------------------------

class _StepUsername extends StatelessWidget {
  const _StepUsername({
    required this.formKey,
    required this.controller,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: 32),
            const Text(
              '\u{1F464}',
              style: TextStyle(fontSize: 56),
            ),
            const SizedBox(height: 16),
            Text(
              'Scegli il tuo username',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Sarà il tuo identificativo unico',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: controller,
              textInputAction: TextInputAction.done,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.alternate_email),
                helperText: 'Sarà il tuo identificativo unico',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Inserisci uno username';
                }
                if (value.trim().length < 3) {
                  return 'Almeno 3 caratteri';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// Error banner
// -------------------------------------------------------------------

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.onErrorContainer,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onErrorContainer,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
