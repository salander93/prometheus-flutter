import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/presentation/auth/screens/login_screen.dart';

void main() {
  group('LoginScreen', () {
    testWidgets('renders username and password fields', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginScreen())),
      );
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Accedi'), findsOneWidget);
    });

    testWidgets(
      'shows validation errors when fields are empty',
      (tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: LoginScreen())),
        );
        await tester.tap(find.text('Accedi'));
        await tester.pumpAndSettle();
        expect(find.text('Inserisci username o email'), findsOneWidget);
        expect(find.text('Inserisci la password'), findsOneWidget);
      },
    );

    testWidgets('has link to register screen', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginScreen())),
      );
      expect(find.text('Non hai un account? Registrati'), findsOneWidget);
    });

    testWidgets('has link to forgot password', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginScreen())),
      );
      expect(find.text('Password dimenticata?'), findsOneWidget);
    });
  });
}
