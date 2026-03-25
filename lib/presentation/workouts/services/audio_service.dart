import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(() => service.dispose());
  return service;
});

class AudioService {
  bool enabled = true;
  AudioPlayer? _player;

  AudioPlayer get _audioPlayer => _player ??= AudioPlayer();

  void playTick() { if (!enabled) return; _play('audio/tick.wav'); }
  void playDing() { if (!enabled) return; _play('audio/ding.wav'); }
  void playCelebration() { if (!enabled) return; _play('audio/celebration.wav'); }

  void _play(String asset) {
    try { _audioPlayer.play(AssetSource(asset)); } catch (_) {}
  }

  void dispose() { _player?.dispose(); }
}
