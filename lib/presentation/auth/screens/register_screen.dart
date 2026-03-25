import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:palestra/core/auth/google_auth_service.dart';
import 'package:palestra/core/error/app_error.dart';
import 'package:palestra/core/error/error_handler.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/datasources/remote/firebase_auth_datasource.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';

/// 4-step registration wizard for Prometheus.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _pageController = PageController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameFormKey = GlobalKey<FormState>();
  final _contactFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  int _currentStep = 0;
  String? _role;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _errorMessage;
  Map<String, List<String>> _fieldErrors = {};
  bool _showSuccess = false;

  static const _totalSteps = 4;

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _canGoNext {
    switch (_currentStep) {
      case 0:
        return _role != null;
      case 1:
        return true;
      case 2:
        return true;
      case 3:
        return true;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (!_validateCurrentStep()) return;
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _role != null;
      case 1:
        return _nameFormKey.currentState?.validate() ??
            false;
      case 2:
        return _contactFormKey.currentState?.validate() ??
            false;
      case 3:
        return _passwordFormKey.currentState?.validate() ??
            false;
      default:
        return true;
    }
  }

  Future<void> _register() async {
    if (!_validateCurrentStep()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _fieldErrors = {};
    });

    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.register(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        role: _role!,
      );

      if (!mounted) return;
      setState(() => _showSuccess = true);
    } catch (e, st) {
      final appError = ErrorHandler.handle(e, st);
      setState(() {
        _errorMessage = appError.userMessage;
        if (appError is ApiError) {
          _fieldErrors = appError.fieldErrors;
        }
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _fieldError(String field) {
    final errors = _fieldErrors[field];
    if (errors == null || errors.isEmpty) return null;
    return errors.first;
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final googleAuthService = GoogleAuthService();
      final firebaseToken = await googleAuthService.signInWithGoogle();

      if (firebaseToken == null) {
        // User cancelled — stop loading silently.
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final apiClient = ref.read(apiClientProvider);
      final datasource = FirebaseAuthDatasource(dio: apiClient.dio);
      final loginResponse =
          await datasource.authenticateWithFirebase(firebaseToken);

      final tokenStorage = ref.read(tokenStorageProvider);
      await tokenStorage.saveTokens(
        accessToken: loginResponse.access,
        refreshToken: loginResponse.refresh,
      );

      ref.read(authStateProvider.notifier).state =
          const AsyncData(AuthState.authenticated);

      if (loginResponse.isNewUser && mounted) {
        context.go('/onboarding');
      }
    } catch (e, st) {
      final error = ErrorHandler.handle(e, st);
      if (mounted) setState(() => _errorMessage = error.userMessage);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showSuccess) return const _SuccessScreen();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _WizardHeader(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              onBack: _currentStep > 0
                  ? _previousStep
                  : () => context.go('/login'),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child:
                    _ErrorBanner(message: _errorMessage!),
              ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics:
                    const NeverScrollableScrollPhysics(),
                children: [
                  _StepRole(
                    selectedRole: _role,
                    onRoleSelected: (role) =>
                        setState(() => _role = role),
                    isLoading: _isLoading,
                    onSignInWithGoogle: _signInWithGoogle,
                  ),
                  _StepName(
                    formKey: _nameFormKey,
                    firstNameController:
                        _firstNameController,
                    lastNameController:
                        _lastNameController,
                    firstNameError:
                        _fieldError('first_name'),
                    lastNameError:
                        _fieldError('last_name'),
                  ),
                  _StepContact(
                    formKey: _contactFormKey,
                    emailController: _emailController,
                    usernameController:
                        _usernameController,
                    emailError: _fieldError('email'),
                    usernameError:
                        _fieldError('username'),
                  ),
                  _StepPassword(
                    formKey: _passwordFormKey,
                    passwordController:
                        _passwordController,
                    confirmPasswordController:
                        _confirmPasswordController,
                    obscurePassword: _obscurePassword,
                    obscureConfirm: _obscureConfirm,
                    onTogglePassword: () => setState(
                      () => _obscurePassword =
                          !_obscurePassword,
                    ),
                    onToggleConfirm: () => setState(
                      () => _obscureConfirm =
                          !_obscureConfirm,
                    ),
                    passwordError:
                        _fieldError('password'),
                  ),
                ],
              ),
            ),
            _WizardFooter(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              canGoNext: _canGoNext,
              isLoading: _isLoading,
              onNext: _nextStep,
              onPrevious: _previousStep,
              onSubmit: _register,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// Wizard header with progress dots + back button
// ---------------------------------------------------------------

class _WizardHeader extends StatelessWidget {
  const _WizardHeader({
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
  });

  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBack,
            tooltip: 'Indietro',
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalSteps, (i) {
                final isActive = i == currentStep;
                final isCompleted = i < currentStep;
                return AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  width: isActive ? 12 : 8,
                  height: isActive ? 12 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive || isCompleted
                        ? AppColors.primary
                        : AppColors.textMuted
                            .withAlpha(77),
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

// ---------------------------------------------------------------
// Wizard footer with navigation buttons
// ---------------------------------------------------------------

class _WizardFooter extends StatelessWidget {
  const _WizardFooter({
    required this.currentStep,
    required this.totalSteps,
    required this.canGoNext,
    required this.isLoading,
    required this.onNext,
    required this.onPrevious,
    required this.onSubmit,
  });

  final int currentStep;
  final int totalSteps;
  final bool canGoNext;
  final bool isLoading;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final isLast = currentStep == totalSteps - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: isLoading ? null : onPrevious,
                child: const Text('Indietro'),
              ),
            )
          else
            const Spacer(),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: FilledButton(
              onPressed: isLoading
                  ? null
                  : canGoNext
                      ? (isLast ? onSubmit : onNext)
                      : null,
              child: isLoading
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      isLast ? 'Registrati' : 'Avanti',
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------
// Step 1: Role selection
// ---------------------------------------------------------------

class _StepRole extends StatelessWidget {
  const _StepRole({
    required this.selectedRole,
    required this.onRoleSelected,
    required this.isLoading,
    required this.onSignInWithGoogle,
  });

  final String? selectedRole;
  final ValueChanged<String> onRoleSelected;
  final bool isLoading;
  final VoidCallback onSignInWithGoogle;

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
            'Benvenuto in Prometheus',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              // ignore: lines_longer_than_80_chars
              '"Meglio essere incatenato a questa roccia'
              ' che servo di Zeus"',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          // ---- Google Sign-In (quick path) ----
          OutlinedButton.icon(
            onPressed: isLoading ? null : onSignInWithGoogle,
            icon: _GoogleIcon(),
            label: const Text('Continua con Google'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: AppColors.borderLight),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(child: Divider(color: AppColors.border)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'oppure registrati',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const Expanded(child: Divider(color: AppColors.border)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Chi sei?',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
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
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => context.go('/login'),
            child: const Text('Hai già un account? Accedi'),
          ),
        ],
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: const Center(
        child: Text(
          'G',
          style: TextStyle(
            color: Color(0xFF4285F4),
            fontSize: 13,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
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
            color: isSelected
                ? AppColors.primary
                : AppColors.border,
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
              style:
                  theme.textTheme.titleMedium?.copyWith(
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

// ---------------------------------------------------------------
// Step 2: Name
// ---------------------------------------------------------------

class _StepName extends StatelessWidget {
  const _StepName({
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    this.firstNameError,
    this.lastNameError,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final String? firstNameError;
  final String? lastNameError;

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
              '\u{1F44B}',
              style: TextStyle(fontSize: 56),
            ),
            const SizedBox(height: 16),
            Text(
              'Piacere di conoscerti!',
              style:
                  theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Come ti chiami?',
              style:
                  theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: firstNameController,
              textCapitalization:
                  TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Nome',
                prefixIcon:
                    const Icon(Icons.person_outline),
                errorText: firstNameError,
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Inserisci il nome';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: lastNameController,
              textCapitalization:
                  TextCapitalization.words,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Cognome',
                prefixIcon:
                    const Icon(Icons.person_outline),
                errorText: lastNameError,
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Inserisci il cognome';
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

// ---------------------------------------------------------------
// Step 3: Contact (email + username)
// ---------------------------------------------------------------

class _StepContact extends StatelessWidget {
  const _StepContact({
    required this.formKey,
    required this.emailController,
    required this.usernameController,
    this.emailError,
    this.usernameError,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController usernameController;
  final String? emailError;
  final String? usernameError;

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
              '\u{1F4E7}',
              style: TextStyle(fontSize: 56),
            ),
            const SizedBox(height: 16),
            Text(
              'Come possiamo contattarti?',
              style:
                  theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Email e username',
              style:
                  theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon:
                    const Icon(Icons.email_outlined),
                errorText: emailError,
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Inserisci la tua email';
                }
                if (!value.contains('@')) {
                  return 'Email non valida';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: usernameController,
              textInputAction: TextInputAction.done,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon:
                    const Icon(Icons.alternate_email),
                helperText:
                    'Sarà il tuo identificativo unico',
                errorText: usernameError,
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Inserisci uno username';
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

// ---------------------------------------------------------------
// Step 4: Password
// ---------------------------------------------------------------

class _StepPassword extends StatelessWidget {
  const _StepPassword({
    required this.formKey,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirm,
    required this.onTogglePassword,
    required this.onToggleConfirm,
    this.passwordError,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirm;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirm;
  final String? passwordError;

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
              '\u{1F510}',
              style: TextStyle(fontSize: 56),
            ),
            const SizedBox(height: 16),
            Text(
              'Proteggi il tuo account',
              style:
                  theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Scegli una password sicura',
              style:
                  theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: passwordController,
              obscureText: obscurePassword,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon:
                    const Icon(Icons.lock_outline),
                errorText: passwordError,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: onTogglePassword,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Inserisci una password';
                }
                if (value.length < 8) {
                  return 'Almeno 8 caratteri';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: passwordController,
              builder: (context, value, _) {
                return _PasswordStrengthBar(
                  password: value.text,
                );
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: obscureConfirm,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Conferma password',
                prefixIcon:
                    const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureConfirm
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: onToggleConfirm,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Conferma la password';
                }
                if (value != passwordController.text) {
                  return 'Le password non coincidono';
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

// ---------------------------------------------------------------
// Password strength indicator
// ---------------------------------------------------------------

enum _PasswordStrength { empty, weak, medium, strong }

class _PasswordStrengthBar extends StatelessWidget {
  const _PasswordStrengthBar({required this.password});

  final String password;

  _PasswordStrength get _strength {
    if (password.isEmpty) return _PasswordStrength.empty;
    var score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (RegExp('[A-Z]').hasMatch(password)) score++;
    if (RegExp('[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]')
        .hasMatch(password)) {
      score++;
    }
    if (score <= 1) return _PasswordStrength.weak;
    if (score <= 3) return _PasswordStrength.medium;
    return _PasswordStrength.strong;
  }

  @override
  Widget build(BuildContext context) {
    final strength = _strength;
    if (strength == _PasswordStrength.empty) {
      return const SizedBox.shrink();
    }

    final (color, label, fraction) = switch (strength) {
      _PasswordStrength.weak => (
          AppColors.danger,
          'Debole',
          0.33,
        ),
      _PasswordStrength.medium => (
          AppColors.accent,
          'Media',
          0.66,
        ),
      _PasswordStrength.strong => (
          AppColors.success,
          'Forte',
          1.0,
        ),
      _PasswordStrength.empty => (
          Colors.transparent,
          '',
          0.0,
        ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fraction,
            backgroundColor:
                AppColors.textMuted.withAlpha(51),
            color: color,
            minHeight: 4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Sicurezza: $label',
          style:
              Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                  ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------
// Success screen after registration
// ---------------------------------------------------------------

class _SuccessScreen extends StatelessWidget {
  const _SuccessScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.success,
                  size: 80,
                ),
                const SizedBox(height: 24),
                Text(
                  'Registrazione completata!',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Controlla la tua email per'
                  ' verificare il tuo account.',
                  style:
                      theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: () => context.go('/login'),
                  icon: const Icon(Icons.login),
                  label: const Text('Vai al Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// Error banner
// ---------------------------------------------------------------

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
