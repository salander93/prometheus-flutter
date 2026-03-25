import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:palestra/core/theme/app_colors.dart';

/// Parses a rest-time string into total seconds.
///
/// Accepted formats:
/// - `"90"` — plain seconds
/// - `"1:30"` or `"01:30"` — min:sec
int parseRestTimeToSeconds(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return 0;

  if (trimmed.contains(':')) {
    final parts = trimmed.split(':');
    final minutes = int.tryParse(parts[0]) ?? 0;
    final seconds =
        parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
    return minutes * 60 + seconds;
  }

  return int.tryParse(trimmed) ?? 0;
}

/// Circular countdown timer shown between sets.
///
/// When [totalSeconds] elapses the ring turns [AppColors.danger].
/// The user can tap "Salta" to skip the rest period.
class RestTimerWidget extends StatefulWidget {
  const RestTimerWidget({
    required this.totalSeconds,
    required this.onComplete,
    required this.onSkip,
    super.key,
  });

  final int totalSeconds;
  final VoidCallback onComplete;
  final VoidCallback onSkip;

  @override
  State<RestTimerWidget> createState() => _RestTimerWidgetState();
}

class _RestTimerWidgetState extends State<RestTimerWidget>
    with SingleTickerProviderStateMixin {
  late int _remaining;
  Timer? _timer;
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _remaining = widget.totalSeconds;
    _animController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.totalSeconds),
    )..forward();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (_remaining <= 1) {
          _timer?.cancel();
          if (mounted) {
            setState(() => _remaining = 0);
            widget.onComplete();
          }
        } else {
          setState(() => _remaining--);
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  String _format(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isUp = _remaining <= 0;
    final ringColor = isUp ? AppColors.danger : AppColors.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Text(
          'Riposo',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 160,
          height: 160,
          child: AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              final progress = widget.totalSeconds > 0
                  ? _remaining / widget.totalSeconds
                  : 0.0;
              return CustomPaint(
                painter: _RingPainter(
                  progress: progress,
                  color: ringColor,
                ),
                child: child,
              );
            },
            child: Center(
              child: Text(
                _format(_remaining),
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(
                      color: ringColor,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: () {
            _timer?.cancel();
            widget.onSkip();
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            side: const BorderSide(color: AppColors.border),
          ),
          child: const Text('Salta'),
        ),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 8.0;

    // Background ring
    final bgPaint = Paint()
      ..color = AppColors.backgroundCardHover
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}
