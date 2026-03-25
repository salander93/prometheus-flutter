import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:palestra/core/error/app_error.dart';
import 'package:palestra/core/error/error_handler.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _success = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authRepositoryProvider).requestPasswordReset(
            email: _emailController.text.trim(),
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
        title: const Text('Recupera Password'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: _success
                  ? _SuccessState(onBack: () => context.go('/login'))
                  : _FormState(
                      formKey: _formKey,
                      emailController: _emailController,
                      isLoading: _isLoading,
                      errorMessage: _errorMessage,
                      onSubmit: _submit,
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
    required this.emailController,
    required this.isLoading,
    required this.onSubmit,
    this.errorMessage,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Inserisci la tua email e ti invieremo un link per '
            'resettare la password.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          if (errorMessage != null) ...[
            _ErrorBanner(message: errorMessage!),
            const SizedBox(height: 16),
          ],
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autocorrect: false,
            onFieldSubmitted: (_) => onSubmit(),
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Inserisci la tua email';
              }
              if (!value.contains('@')) {
                return 'Inserisci un indirizzo email valido';
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
                : const Text('Invia Link di Reset'),
          ),
        ],
      ),
    );
  }
}

class _SuccessState extends StatelessWidget {
  const _SuccessState({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.mark_email_read_outlined,
          size: 72,
          color: colorScheme.primary,
        ),
        const SizedBox(height: 24),
        Text(
          'Email inviata!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          'Controlla la tua casella di posta e segui le istruzioni '
          'per resettare la password.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 32),
        FilledButton(
          onPressed: onBack,
          child: const Text('Torna al Login'),
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
