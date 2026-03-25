import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:palestra/core/error/app_error.dart';
import 'package:palestra/core/error/error_handler.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({required this.token, super.key});

  final String token;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _success = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authRepositoryProvider).confirmPasswordReset(
            token: widget.token,
            newPassword: _passwordController.text,
          );
      if (mounted) {
        setState(() => _success = true);
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuova Password'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: _success
                  ? _SuccessState(onLogin: () => context.go('/login'))
                  : _FormState(
                      formKey: _formKey,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      isLoading: _isLoading,
                      obscurePassword: _obscurePassword,
                      errorMessage: _errorMessage,
                      onSubmit: _submit,
                      onToggleObscure: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormState extends StatelessWidget {
  const _FormState({
    required this.formKey,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isLoading,
    required this.obscurePassword,
    required this.onSubmit,
    required this.onToggleObscure,
    this.errorMessage,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isLoading;
  final bool obscurePassword;
  final String? errorMessage;
  final VoidCallback onSubmit;
  final VoidCallback onToggleObscure;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (errorMessage != null) ...[
            _ErrorBanner(message: errorMessage!),
            const SizedBox(height: 16),
          ],
          TextFormField(
            controller: passwordController,
            obscureText: obscurePassword,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Nuova password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: onToggleObscure,
                tooltip:
                    obscurePassword ? 'Mostra password' : 'Nascondi password',
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Inserisci la nuova password';
              }
              if (value.length < 8) {
                return 'La password deve contenere almeno 8 caratteri';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: confirmPasswordController,
            obscureText: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => onSubmit(),
            decoration: const InputDecoration(
              labelText: 'Conferma password',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Conferma la nuova password';
              }
              if (value != passwordController.text) {
                return 'Le password non corrispondono';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: isLoading ? null : onSubmit,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Aggiorna Password'),
          ),
        ],
      ),
    );
  }
}

class _SuccessState extends StatelessWidget {
  const _SuccessState({required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 72,
          color: colorScheme.primary,
        ),
        const SizedBox(height: 24),
        Text(
          'Password aggiornata!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          'La tua password è stata aggiornata con successo.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 32),
        FilledButton(
          onPressed: onLogin,
          child: const Text('Accedi'),
        ),
      ],
    );
  }
}

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
