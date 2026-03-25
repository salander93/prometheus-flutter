import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/data/models/relation_models.dart';

void main() {
  group('TrainerClient', () {
    test('deserializes from JSON', () {
      final json = <String, dynamic>{
        'id': 1,
        'trainer': 2,
        'trainer_name': 'Marco Bianchi',
        'trainer_photo': '/media/photos/marco.jpg',
        'client': 3,
        'client_name': 'Luca Rossi',
        'client_photo': null,
        'is_active': true,
        'created_at': '2026-01-15T00:00:00Z',
      };
      final model = TrainerClient.fromJson(json);
      expect(model.id, 1);
      expect(model.trainerName, 'Marco Bianchi');
      expect(model.trainerPhoto, '/media/photos/marco.jpg');
      expect(model.clientName, 'Luca Rossi');
      expect(model.clientPhoto, isNull);
      expect(model.isActive, isTrue);
    });

    test('serializes to JSON with snake_case keys', () {
      const model = TrainerClient(
        id: 1,
        trainer: 2,
        trainerName: 'Marco Bianchi',
        client: 3,
        clientName: 'Luca Rossi',
        isActive: true,
        createdAt: '2026-01-15T00:00:00Z',
      );
      final json = model.toJson();
      expect(json['trainer_name'], 'Marco Bianchi');
      expect(json['client_name'], 'Luca Rossi');
      expect(json['is_active'], isTrue);
      expect(json['created_at'], '2026-01-15T00:00:00Z');
    });

    test('supports optional photos', () {
      final json = <String, dynamic>{
        'id': 2,
        'trainer': 4,
        'trainer_name': 'Anna Verdi',
        'client': 5,
        'client_name': 'Paolo Neri',
        'is_active': false,
        'created_at': '2026-02-01T00:00:00Z',
      };
      final model = TrainerClient.fromJson(json);
      expect(model.trainerPhoto, isNull);
      expect(model.clientPhoto, isNull);
    });
  });
}
