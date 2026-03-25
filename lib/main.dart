import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:palestra/core/routing/app_router.dart';
import 'package:palestra/core/theme/app_theme.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initializeDateFormatting('it_IT');

  // Initialize Firebase — failure is non-fatal (push won't work but app runs).
  try {
    await Firebase.initializeApp();
  } catch (e) {
    log('Firebase init failed: $e');
  }

  runApp(const ProviderScope(child: PalestraApp()));
}

class PalestraApp extends ConsumerStatefulWidget {
  const PalestraApp({super.key});

  @override
  ConsumerState<PalestraApp> createState() => _PalestraAppState();
}

class _PalestraAppState extends ConsumerState<PalestraApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final authCheck = await ref.read(authCheckProvider.future);
      ref.read(authStateProvider.notifier).state = AsyncData(authCheck);
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Prometheus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
