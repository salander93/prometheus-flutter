import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/data/models/auth_models.dart';

void main() {
  group('LoginResponse', () {
    test('deserializes from JSON', () {
      final json = {
        'access': 'access_token_123',
        'refresh': 'refresh_token_456',
        'user': {
          'id': 1,
          'username': 'mario',
          'email': 'mario@test.com',
          'full_name': 'Mario Rossi',
          'role': 'CLIENT',
        },
      };
      final response = LoginResponse.fromJson(json);
      expect(response.access, 'access_token_123');
      expect(response.refresh, 'refresh_token_456');
      expect(response.user.id, 1);
      expect(response.user.username, 'mario');
      expect(response.user.role, 'CLIENT');
    });
  });

  group('LoginRequest', () {
    test('serializes to JSON', () {
      const request = LoginRequest(username: 'mario', password: 'secret123');
      final json = request.toJson();
      expect(json['username'], 'mario');
      expect(json['password'], 'secret123');
    });
  });

  group('RegisterRequest', () {
    test('serializes to JSON with snake_case keys', () {
      const request = RegisterRequest(
        username: 'mario',
        email: 'mario@test.com',
        password: 'secret123',
        firstName: 'Mario',
        lastName: 'Rossi',
        role: 'CLIENT',
      );
      final json = request.toJson();
      expect(json['first_name'], 'Mario');
      expect(json['last_name'], 'Rossi');
      expect(json['role'], 'CLIENT');
    });
  });

  group('TokenRefreshRequest', () {
    test('serializes to JSON', () {
      const request = TokenRefreshRequest(refresh: 'my_refresh_token');
      expect(request.toJson()['refresh'], 'my_refresh_token');
    });
  });
}
