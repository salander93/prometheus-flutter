import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/presentation/workouts/widgets/flame_widget.dart';

void main() {
  group('FlameWidget', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlameWidget(scale: 0.5, opacity: 0.7, speedSeconds: 0.3, glow: 0.5, size: 48),
          ),
        ),
      );
      expect(find.byType(FlameWidget), findsOneWidget);
    });

    testWidgets('compact mode renders small', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlameWidget(scale: 1.0, opacity: 1.0, speedSeconds: 0.2, glow: 0.9, size: 28),
          ),
        ),
      );
      final box = tester.renderObject<RenderBox>(find.byType(FlameWidget));
      expect(box.size.width, 28);
    });
  });
}
