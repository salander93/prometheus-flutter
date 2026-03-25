import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:palestra/core/error/error_handler.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({required this.token, super.key});

  final String token;

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool _isLoading = true;
  bool _isSuccess = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _verifyEmail();
  }

  Future<void> _verifyEmail() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.dio.post<Map<String, dynamic>>(
        '/api/users/verify-email/',
        data: {'token': widget.token},
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSuccess = true;
        });
      }
    } catch (e, st) {
      final appError = ErrorHandler.handle(e, st);
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSuccess = false;
          _errorMessage = appError.userMessage;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifica Email'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _isLoading
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isSuccess ? Icons.check_circle : Icons.error,
                        color: _isSuccess
                            ? colorScheme.primary
                            : colorScheme.error,
                        size: 64,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _isSuccess
                            ? 'Email verificata!'
                            : (_errorMessage ?? 'Errore sconosciuto.'),
                        style: textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      FilledButton(
                        onPressed: () => context.go('/login'),
                        child: const Text('Vai al Login'),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
