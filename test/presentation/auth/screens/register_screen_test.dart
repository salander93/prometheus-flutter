import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/presentation/auth/screens/register_screen.dart';

void main() {
  group('RegisterScreen', () {
    testWidgets('renders role selection on first step', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: RegisterScreen()),
        ),
      );
      expect(find.text('Atleta'), findsOneWidget);
      expect(find.text('Trainer'), findsOneWidget);
      expect(
        find.text('Benvenuto in Prometheus'),
        findsOneWidget,
      );
    });

    testWidgets(
      'Avanti button is disabled until role is selected',
      (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(home: RegisterScreen()),
          ),
        );
        // Avanti button should exist but be disabled
        final avanti = find.text('Avanti');
        expect(avanti, findsOneWidget);
        final button = tester.widget<FilledButton>(
          find.ancestor(
            of: avanti,
            matching: find.byType(FilledButton),
          ),
        );
        expect(button.onPressed, isNull);
      },
    );

    testWidgets(
      'selecting a role enables the Avanti button',
      (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(home: RegisterScreen()),
          ),
        );
        // Tap Atleta card
        await tester.tap(find.text('Atleta'));
        await tester.pumpAndSettle();

        final avanti = find.text('Avanti');
        final button = tester.widget<FilledButton>(
          find.ancestor(
            of: avanti,
            matching: find.byType(FilledButton),
          ),
        );
        expect(button.onPressed, isNotNull);
      },
    );

    testWidgets(
      'navigates to name step after selecting role',
      (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(home: RegisterScreen()),
          ),
        );
        await tester.tap(find.text('Atleta'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Avanti'));
        await tester.pumpAndSettle();

        expect(
          find.text('Piacere di conoscerti!'),
          findsOneWidget,
        );
      },
    );

    testWidgets('has link to login screen', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: RegisterScreen()),
        ),
      );
      expect(
        find.text('Hai già un account? Accedi'),
        findsOneWidget,
      );
    });
  });
}
