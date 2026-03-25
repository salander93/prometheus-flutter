import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:palestra/core/theme/app_colors.dart';

/// Auto-advancing countdown banner shown between exercises.
///
/// Counts down 5 seconds then calls [onComplete]. The user may tap
/// "Vai ora →" (or "Completa" for the last exercise) to skip.
class NextExerciseCountdown extends StatefulWidget {
  const NextExerciseCountdown({
    required this.exerciseName,
    required this.exerciseInfo,
    required this.onComplete,
    required this.onSkip,
    this.isLastExercise = false,
    super.key,
  });

  final String exerciseName;
  final String exerciseInfo;
  final bool isLastExercise;
  final VoidCallback onComplete;
  final VoidCallback onSkip;

  @override
  State<NextExerciseCountdown> createState() => _NextExerciseCountdownState();
}

class _NextExerciseCountdownState extends State<NextExerciseCountdown>
    with SingleTickerProviderStateMixin {
  static const _totalSeconds = 5;

  late int _remaining;
  Timer? _timer;
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _remaining = _totalSeconds;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _totalSeconds),
    )..forward();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining <= 1) {
        _timer?.cancel();
        if (mounted) {
          setState(() => _remaining = 0);
          widget.onComplete();
        }
      } else {
        if (mounted) setState(() => _remaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.isLastExercise
        ? 'COMPLETA ALLENAMENTO'
        : 'PROSSIMO ESERCIZIO';
    final buttonLabel = widget.isLastExercise ? 'Completa' : 'Vai ora →';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.success.withValues(alpha: 0.15),
            Colors.transparent,
          ],
        ),
        border: const Border(
          top: BorderSide(color: AppColors.success),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.exerciseName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (widget.exerciseInfo.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    widget.exerciseInfo,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Countdown ring
          SizedBox(
            width: 48,
            height: 48,
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                final progress = _remaining / _totalSeconds;
                return CustomPaint(
                  painter: _CountdownRingPainter(
                    progress: progress,
                    color: AppColors.success,
                  ),
                  child: child,
                );
              },
              child: Center(
                child: Text(
                  '$_remaining',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: () {
              _timer?.cancel();
              widget.onSkip();
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: AppColors.backgroundBase,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }
}

class _CountdownRingPainter extends CustomPainter {
  _CountdownRingPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const strokeWidth = 3.0;

    // Background ring then progress arc
    canvas
      ..drawCircle(
        center,
        radius,
        Paint()
          ..color = AppColors.backgroundCardHover
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
      )
      ..drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
  }

  @override
  bool shouldRepaint(_CountdownRingPainter old) =>
      old.progress != progress || old.color != color;
}
