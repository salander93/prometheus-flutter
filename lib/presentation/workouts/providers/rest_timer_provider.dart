import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RestTimerStatus { idle, counting, urgent, overtime }

final restTimerProvider =
    StateNotifierProvider.autoDispose<RestTimerNotifier, RestTimerState>(
  (ref) => RestTimerNotifier(),
);

class RestTimerState {
  final RestTimerStatus status;
  final int remaining;
  final int total;
  final int exerciseExecId;

  const RestTimerState({required this.status, this.remaining = 0, this.total = 0, this.exerciseExecId = 0});
  const RestTimerState.idle() : status = RestTimerStatus.idle, remaining = 0, total = 0, exerciseExecId = 0;

  bool get isActive => status != RestTimerStatus.idle;
  int get overtimeSeconds => remaining < 0 ? remaining.abs() : 0;

  double get progressFraction {
    if (total == 0) return 0;
    if (status == RestTimerStatus.overtime) return 1.0;
    return 1.0 - (remaining / total);
  }

  String get formattedTime {
    if (status == RestTimerStatus.overtime) {
      final secs = overtimeSeconds;
      final m = secs ~/ 60;
      final s = secs % 60;
      return '+$m:${s.toString().padLeft(2, '0')}';
    }
    final m = remaining ~/ 60;
    final s = remaining % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  RestTimerState copyWith({RestTimerStatus? status, int? remaining, int? total, int? exerciseExecId}) =>
      RestTimerState(
        status: status ?? this.status,
        remaining: remaining ?? this.remaining,
        total: total ?? this.total,
        exerciseExecId: exerciseExecId ?? this.exerciseExecId,
      );
}

class RestTimerNotifier extends StateNotifier<RestTimerState> {
  Timer? _timer;
  RestTimerNotifier() : super(const RestTimerState.idle());

  void start({required int totalSeconds, required int exerciseExecId}) {
    _timer?.cancel();
    state = RestTimerState(status: RestTimerStatus.counting, remaining: totalSeconds, total: totalSeconds, exerciseExecId: exerciseExecId);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  void tick() {
    final next = state.remaining - 1;
    if (next <= 0 && state.status != RestTimerStatus.overtime) {
      state = state.copyWith(status: RestTimerStatus.overtime, remaining: next);
    } else if (next > 0 && next <= 5 && state.status != RestTimerStatus.overtime) {
      state = state.copyWith(status: RestTimerStatus.urgent, remaining: next);
    } else {
      state = state.copyWith(remaining: next);
    }
  }

  void skip() { _timer?.cancel(); state = const RestTimerState.idle(); }
  void reset() { _timer?.cancel(); state = const RestTimerState.idle(); }
  int get actualRestDuration => state.total == 0 ? 0 : state.total - state.remaining;

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }
}
