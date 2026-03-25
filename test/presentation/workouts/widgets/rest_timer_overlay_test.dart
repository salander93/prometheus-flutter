import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/presentation/workouts/providers/rest_timer_provider.dart';
import 'package:palestra/presentation/workouts/widgets/rest_timer_overlay.dart';

void main() {
  group('RestTimerOverlay', () {
    testWidgets('shows formatted time', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestTimerOverlay(
              state: const RestTimerState(status: RestTimerStatus.counting, remaining: 95, total: 120, exerciseExecId: 1),
              onSkip: () {},
              nextSetInfo: 'Panca Piana — Serie 3',
            ),
          ),
        ),
      );
      expect(find.text('1:35'), findsOneWidget);
      expect(find.text('Recupero'), findsOneWidget);
    });

    testWidgets('shows overtime format', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestTimerOverlay(
              state: const RestTimerState(status: RestTimerStatus.overtime, remaining: -12, total: 90, exerciseExecId: 1),
              onSkip: () {},
              nextSetInfo: 'Panca Piana — Serie 3',
            ),
          ),
        ),
      );
      expect(find.text('+0:12'), findsOneWidget);
    });

    testWidgets('skip button calls onSkip', (tester) async {
      var skipped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestTimerOverlay(
              state: const RestTimerState(status: RestTimerStatus.counting, remaining: 60, total: 90, exerciseExecId: 1),
              onSkip: () => skipped = true,
              nextSetInfo: 'Test',
            ),
          ),
        ),
      );
      await tester.tap(find.text('Salta recupero'));
      expect(skipped, true);
    });
  });
}
