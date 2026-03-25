import 'package:flutter_test/flutter_test.dart';
import 'package:palestra/presentation/workouts/services/audio_service.dart';

void main() {
  group('AudioService', () {
    late AudioService service;
    setUp(() { service = AudioService(); });

    test('playTick does not throw when disabled', () async {
      service.enabled = false;
      expect(() => service.playTick(), returnsNormally);
    });
    test('playDing does not throw when disabled', () async {
      service.enabled = false;
      expect(() => service.playDing(), returnsNormally);
    });
    test('playCelebration does not throw when disabled', () async {
      service.enabled = false;
      expect(() => service.playCelebration(), returnsNormally);
    });
    test('dispose does not throw', () {
      expect(() => service.dispose(), returnsNormally);
    });
  });
}
