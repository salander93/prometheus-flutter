import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/data/models/notification_model.dart';

void main() {
  group('NotificationModel', () {
    test('deserializes from JSON', () {
      final json = <String, dynamic>{
        'id': 1,
        'title': 'Nuovo allenamento',
        'message': 'Il tuo trainer ha creato un piano.',
        'notification_type': 'WORKOUT_ASSIGNED',
        'is_read': false,
        'action_url': '/plans/1/',
        'related_user_name': 'Marco Bianchi',
        'related_user_photo': null,
        'created_at': '2026-03-01T08:00:00Z',
      };
      final model = NotificationModel.fromJson(json);
      expect(model.id, 1);
      expect(model.notificationType, 'WORKOUT_ASSIGNED');
      expect(model.isRead, isFalse);
      expect(model.actionUrl, '/plans/1/');
      expect(model.relatedUserName, 'Marco Bianchi');
      expect(model.relatedUserPhoto, isNull);
    });

    test('serializes to JSON with snake_case keys', () {
      const model = NotificationModel(
        id: 2,
        title: 'Messaggio',
        message: 'Testo del messaggio',
        notificationType: 'MESSAGE',
        isRead: true,
        createdAt: '2026-03-02T10:00:00Z',
      );
      final json = model.toJson();
      expect(json['notification_type'], 'MESSAGE');
      expect(json['is_read'], isTrue);
      expect(json['created_at'], '2026-03-02T10:00:00Z');
    });

    test('supports optional action_url and related user fields', () {
      final json = <String, dynamic>{
        'id': 3,
        'title': 'Info',
        'message': 'Testo',
        'notification_type': 'GENERIC',
        'is_read': false,
        'created_at': '2026-03-03T00:00:00Z',
      };
      final model = NotificationModel.fromJson(json);
      expect(model.actionUrl, isNull);
      expect(model.relatedUserName, isNull);
    });
  });

  group('UnreadCountResponse', () {
    test('deserializes from JSON', () {
      final json = <String, dynamic>{'count': 5};
      final model = UnreadCountResponse.fromJson(json);
      expect(model.count, 5);
    });

    test('serializes to JSON', () {
      const model = UnreadCountResponse(count: 3);
      expect(model.toJson()['count'], 3);
    });
  });
}
