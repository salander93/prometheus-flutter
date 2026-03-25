import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:palestra/core/auth/google_auth_service.dart';
import 'package:palestra/core/error/app_error.dart';
import 'package:palestra/core/error/error_handler.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/datasources/remote/firebase_auth_datasource.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authRepositoryProvider).login(
            username: _usernameController.text.trim(),
            password: _passwordController.text,
          );
      ref.read(authStateProvider.notifier).state =
          const AsyncData(AuthState.authenticated);
    } on AppError catch (e) {
      setState(() => _errorMessage = e.userMessage);
    } catch (e, st) {
      final appError = ErrorHandler.handle(e, st);
      setState(() => _errorMessage = appError.userMessage);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 32,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _AppLogo(colorScheme: colorScheme),
                    const SizedBox(height: 32),
                    // ---- Google Sign-In ----
                    _GoogleSignInButton(
                      isLoading: _isLoading,
                      onPressed: _signInWithGoogle,
                    ),
                    const SizedBox(height: 16),
                    _OrDivider(colorScheme: colorScheme),
                    const SizedBox(height: 16),
                    // ---- Error banner ----
                    if (_errorMessage != null) ...[
                      _ErrorBanner(message: _errorMessage!),
                      const SizedBox(height: 16),
                    ],
                    // ---- Credentials form ----
                    TextFormField(
                      controller: _usernameController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Username o email',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Inserisci username o email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _login(),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          tooltip: _obscurePassword
                              ? 'Mostra password'
                              : 'Nascondi password',
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci la password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.go('/forgot-password'),
                        child: const Text('Password dimenticata?'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Accedi'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.go('/register'),
                      child: const Text('Non hai un account? Registrati'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// Google Sign-In button
// ---------------------------------------------------------------

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: _GoogleIcon(),
      label: const Text('Continua con Google'),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: const BorderSide(color: AppColors.borderLight),
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

// ---------------------------------------------------------------
// "oppure" divider
// ---------------------------------------------------------------

class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'oppure',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}

// ---------------------------------------------------------------
// App logo
// ---------------------------------------------------------------

class _AppLogo extends StatelessWidget {
  const _AppLogo({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/prometheus_logo.png',
          height: 120,
        ),
        const SizedBox(height: 16),
        Text(
          'Prometheus',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Forgia il tuo potenziale',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),
      ],
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
