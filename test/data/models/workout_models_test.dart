import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/data/models/workout_models.dart';

void main() {
  group('WorkoutPlanSummary', () {
    test('deserializes from JSON', () {
      final json = <String, dynamic>{
        'id': 1,
        'name': 'Piano Forza',
        'description': 'Programma forza base',
        'trainer': 2,
        'trainer_name': 'Marco Bianchi',
        'client': 3,
        'client_name': 'Luca Rossi',
        'is_active': true,
        'duration_weeks': 8,
        'current_week': 3,
        'created_at': '2026-01-01T00:00:00Z',
      };
      final model = WorkoutPlanSummary.fromJson(json);
      expect(model.id, 1);
      expect(model.trainerName, 'Marco Bianchi');
      expect(model.clientName, 'Luca Rossi');
      expect(model.isActive, isTrue);
      expect(model.durationWeeks, 8);
      expect(model.currentWeek, 3);
    });

    test('serializes to JSON', () {
      const model = WorkoutPlanSummary(
        id: 1,
        name: 'Piano Forza',
        trainer: 2,
        trainerName: 'Marco Bianchi',
        client: 3,
        clientName: 'Luca Rossi',
        isActive: true,
        durationWeeks: 8,
        currentWeek: 3,
        createdAt: '2026-01-01T00:00:00Z',
      );
      final json = model.toJson();
      expect(json['trainer_name'], 'Marco Bianchi');
      expect(json['is_active'], isTrue);
      expect(json['duration_weeks'], 8);
      expect(json['current_week'], 3);
    });

    test('supports optional description', () {
      final json = <String, dynamic>{
        'id': 1,
        'name': 'Piano',
        'trainer': 2,
        'trainer_name': 'Trainer',
        'client': 3,
        'client_name': 'Client',
        'is_active': false,
        'duration_weeks': 4,
        'current_week': 1,
        'created_at': '2026-01-01T00:00:00Z',
      };
      final model = WorkoutPlanSummary.fromJson(json);
      expect(model.description, isNull);
    });
  });

  group('WorkoutExecution', () {
    test('deserializes from JSON with all fields', () {
      final json = <String, dynamic>{
        'id': 10,
        'session_name': 'Giorno A',
        'plan_name': 'Piano Forza',
        'week_number': 2,
        'started_at': '2026-03-01T09:00:00Z',
        'completed_at': '2026-03-01T10:00:00Z',
      };
      final model = WorkoutExecution.fromJson(json);
      expect(model.id, 10);
      expect(model.sessionName, 'Giorno A');
      expect(model.planName, 'Piano Forza');
      expect(model.weekNumber, 2);
    });

    test('deserializes with nullable fields absent', () {
      final json = <String, dynamic>{'id': 5};
      final model = WorkoutExecution.fromJson(json);
      expect(model.sessionName, isNull);
      expect(model.completedAt, isNull);
    });
  });

  group('CalendarData', () {
    test('deserializes from JSON', () {
      final json = <String, dynamic>{
        'year': 2026,
        'month': 3,
        'training_days': {
          '2026-03-01': [
            {'id': 1, 'session': 'Giorno A', 'duration': 60},
          ],
          '2026-03-05': <dynamic>[],
        },
      };
      final model = CalendarData.fromJson(json);
      expect(model.year, 2026);
      expect(model.month, 3);
      expect(model.trainingDays.keys, contains('2026-03-01'));
    });

    test('defaults to empty training_days when absent', () {
      final json = <String, dynamic>{'year': 2026, 'month': 3};
      final model = CalendarData.fromJson(json);
      expect(model.trainingDays, isEmpty);
    });
  });

  group('ActivityLogSummary', () {
    test('deserializes from JSON', () {
      final json = <String, dynamic>{
        'id': 7,
        'client_name': 'Luca Rossi',
        'date': '2026-03-10',
        'duration_minutes': 45,
        'feeling_display': 'Bene',
        'created_at': '2026-03-10T12:00:00Z',
      };
      final model = ActivityLogSummary.fromJson(json);
      expect(model.id, 7);
      expect(model.clientName, 'Luca Rossi');
      expect(model.durationMinutes, 45);
      expect(model.feelingDisplay, 'Bene');
    });

    test('supports nullable optional fields', () {
      final json = <String, dynamic>{
        'id': 8,
        'client_name': 'Mario',
        'date': '2026-03-11',
        'created_at': '2026-03-11T08:00:00Z',
      };
      final model = ActivityLogSummary.fromJson(json);
      expect(model.durationMinutes, isNull);
      expect(model.feelingDisplay, isNull);
    });
  });
}
