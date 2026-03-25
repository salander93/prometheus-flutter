import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('deserializes from JSON with all fields', () {
      final json = {
        'id': 1,
        'username': 'mario',
        'email': 'mario@test.com',
        'first_name': 'Mario',
        'last_name': 'Rossi',
        'full_name': 'Mario Rossi',
        'role': 'CLIENT',
        'phone': '+39123456',
        'photo': 'http://localhost:8010/media/photos/mario.jpg',
        'bio': 'Fitness enthusiast',
        'birth_date': '1990-05-15',
        'height': 180.5,
        'age': 35,
        'share_body_checks_with_trainers': true,
      };
      final user = UserModel.fromJson(json);
      expect(user.id, 1);
      expect(user.fullName, 'Mario Rossi');
      expect(user.role, 'CLIENT');
      expect(user.height, 180.5);
      expect(user.shareBodyChecksWithTrainers, isTrue);
    });

    test('handles null optional fields', () {
      final json = {
        'id': 1,
        'username': 'mario',
        'email': 'mario@test.com',
        'first_name': 'Mario',
        'last_name': 'Rossi',
        'full_name': 'Mario Rossi',
        'role': 'TRAINER',
      };
      final user = UserModel.fromJson(json);
      expect(user.phone, isNull);
      expect(user.photo, isNull);
      expect(user.shareBodyChecksWithTrainers, isFalse);
    });
  });
}
