import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/presentation/workouts/widgets/progress_indicator_bar.dart';

void main() {
  group('ProgressIndicatorBar', () {
    testWidgets('shows correct count text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProgressIndicatorBar(total: 5, currentIndex: 2, completedIndices: const {0, 1}, onTapIndex: (_) {}),
          ),
        ),
      );
      expect(find.text('3/5'), findsOneWidget);
    });
  });
}
