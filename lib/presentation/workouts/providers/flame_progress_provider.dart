import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final flameProgressProvider =
    StateNotifierProvider.autoDispose<FlameProgressNotifier, FlameProgressState>(
  (ref) => FlameProgressNotifier(),
);

class FlameProgressState {
  final double progress;
  const FlameProgressState({required this.progress});

  double get _clamped => progress.clamp(0.0, 1.0);
  double get scale => _lerp(0.15, 1.0);
  double get opacity => _lerp(0.2, 1.0);
  double get speedSeconds => _lerp(0.5, 0.2);
  double get glow => _lerp(0.0, 0.9);
  bool get isComplete => _clamped >= 1.0;
  int get percent => (_clamped * 100).round();

  double _lerp(double from, double to) {
    return from + (to - from) * _clamped;
  }
}

class FlameProgressNotifier extends StateNotifier<FlameProgressState> {
  FlameProgressNotifier() : super(const FlameProgressState(progress: 0.0));

  void update({required int completedSets, required int totalSets}) {
    final progress = totalSets == 0 ? 0.0 : completedSets / totalSets;
    state = FlameProgressState(progress: progress);
  }
}
