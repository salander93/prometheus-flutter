import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/presentation/workouts/providers/rest_timer_provider.dart';
import 'package:palestra/presentation/workouts/widgets/floating_timer_widget.dart';

void main() {
  group('FloatingTimerWidget', () {
    testWidgets('renders time and exercise name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FloatingTimerWidget(
              state: const RestTimerState(status: RestTimerStatus.counting, remaining: 83, total: 120, exerciseExecId: 1),
              exerciseName: 'Panca Piana',
              onTap: () {},
            ),
          ),
        ),
      );
      expect(find.text('1:23'), findsOneWidget);
      expect(find.text('Panca Piana'), findsOneWidget);
    });

    testWidgets('tap calls onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FloatingTimerWidget(
              state: const RestTimerState(status: RestTimerStatus.counting, remaining: 60, total: 90, exerciseExecId: 1),
              exerciseName: 'Test',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(FloatingTimerWidget));
      expect(tapped, true);
    });
  });
}
