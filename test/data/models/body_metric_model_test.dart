import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/data/models/body_metric_model.dart';

void main() {
  group('BodyMetric', () {
    test('deserializes full JSON', () {
      final json = <String, dynamic>{
        'id': 1,
        'recorded_at': '2026-03-01',
        'weight': 80.5,
        'chest': 100.0,
        'waist': 82.0,
        'hips': 98.0,
        'shoulders': 120.0,
        'neck': 38.0,
        'biceps_left': 35.0,
        'biceps_right': 36.0,
        'thigh_left': 58.0,
        'thigh_right': 57.5,
        'calf_left': 38.0,
        'calf_right': 38.5,
        'forearm_left': 30.0,
        'forearm_right': 30.5,
        'notes': 'Prima misurazione',
        'created_at': '2026-03-01T10:00:00Z',
      };
      final model = BodyMetric.fromJson(json);
      expect(model.id, 1);
      expect(model.weight, 80.5);
      expect(model.bicepsLeft, 35.0);
      expect(model.bicepsRight, 36.0);
      expect(model.forearmLeft, 30.0);
      expect(model.forearmRight, 30.5);
      expect(model.notes, 'Prima misurazione');
    });

    test('deserializes with all measurements null', () {
      final json = <String, dynamic>{
        'id': 2,
        'recorded_at': '2026-03-10',
        'created_at': '2026-03-10T08:00:00Z',
      };
      final model = BodyMetric.fromJson(json);
      expect(model.weight, isNull);
      expect(model.chest, isNull);
      expect(model.forearmLeft, isNull);
      expect(model.notes, isNull);
    });

    test('serializes to JSON with snake_case keys', () {
      const model = BodyMetric(
        id: 1,
        recordedAt: '2026-03-01',
        weight: 80.5,
        bicepsLeft: 35,
        bicepsRight: 36,
        forearmLeft: 30,
        forearmRight: 30.5,
        createdAt: '2026-03-01T10:00:00Z',
      );
      final json = model.toJson();
      expect(json['recorded_at'], '2026-03-01');
      expect(json['biceps_left'], 35);
      expect(json['forearm_left'], 30);
      expect(json['forearm_right'], 30.5);
    });
  });
}
